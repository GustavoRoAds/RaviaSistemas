<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if ($metodo === 'GET') {
    try {
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM venda WHERE num_venda = :id');
            $stmt->execute([':id' => $id]);

            $venda = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$venda) {
                http_response_code(404);
                echo json_encode(['erro' => 'Venda não encontrada']);
                exit;
            }
            echo json_encode($venda);
        } else {
            $stmt = $pdo->query('SELECT v.*, c.nome AS nome_cliente FROM venda v LEFT JOIN cliente c ON c.codigo = v.num_cliente ORDER BY v.num_venda DESC');
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
    } catch (Throwable $e) {
        http_response_code(500);
        echo json_encode(['erro' => 'Erro ao consultar vendas']);
    }
    exit;
}
if ($metodo !== 'POST') {
    http_response_code(405);
    header('Allow: GET, POST');
    echo json_encode(['erro' => 'Método não permitido']);
    exit;
}
if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Sessão expirada']);
    exit;
}

try {
    $dados = json_decode(file_get_contents('php://input'), true, 512, JSON_THROW_ON_ERROR);
    if (!is_array($dados)) throw new InvalidArgumentException('Dados inválidos');
    $cliente = filter_var($dados['num_cliente'] ?? null, FILTER_VALIDATE_INT);
    $funcionario = filter_var($dados['num_funcionario'] ?? null, FILTER_VALIDATE_INT);
    if (!$funcionario || $funcionario < 1) throw new InvalidArgumentException('Informe o funcionário responsável');
    $itens = $dados['itens'] ?? null;
    $forma = $dados['forma_pagamento'] ?? '';
    $formas = ['DINHEIRO', 'PIX', 'CARTAO_DEBITO', 'CARTAO_CREDITO'];
    if (!$cliente || $cliente < 1 || !is_array($itens) || count($itens) === 0) throw new InvalidArgumentException('Informe cliente e produtos');
    if (!in_array($forma, $formas, true)) throw new InvalidArgumentException('Informe uma forma de pagamento válida');
    $descontoValor = (float)($dados['desconto_valor'] ?? 0);
    $descontoPercentual = (float)($dados['desconto_percentual'] ?? 0);
    $acrescimo = (float)($dados['acrescimo'] ?? 0);
    if (!is_finite($descontoValor) || !is_finite($descontoPercentual) || !is_finite($acrescimo) || $descontoValor < 0 || $descontoPercentual < 0 || $descontoPercentual > 100 || $acrescimo < 0) throw new InvalidArgumentException('Desconto ou acréscimo inválido');
    $observacao = (string)($dados['observacao'] ?? '');
    if (mb_strlen($observacao) > 500) throw new InvalidArgumentException('Observação muito longa');
    $data = $dados['data_venda'] ?? date('Y-m-d');
    if (!is_string($data) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $data) || !checkdate((int)substr($data, 5, 2), (int)substr($data, 8, 2), (int)substr($data, 0, 4))) throw new InvalidArgumentException('Data inválida');

    $agrupados = [];
    $subtotal = 0.0;
    foreach ($itens as $item) {
        $produto = filter_var($item['num_produto'] ?? null, FILTER_VALIDATE_INT);
        $qtd = filter_var($item['quantidade'] ?? null, FILTER_VALIDATE_INT);
        $preco = (float)($item['preco_unitario'] ?? 0);
        if (!$produto || !$qtd || $produto < 1 || $qtd < 1 || !is_finite($preco) || $preco <= 0) throw new InvalidArgumentException('Produto, quantidade ou preço inválido');
        $agrupados[$produto] = ($agrupados[$produto] ?? 0) + $qtd;
        $subtotal += round($qtd * $preco, 2);
    }
    $desconto = $descontoPercentual > 0 ? round($subtotal * $descontoPercentual / 100, 2) : $descontoValor;
    $desconto = min($desconto, $subtotal);
    $total = round($subtotal - $desconto + $acrescimo, 2);
    if ($total <= 0) throw new InvalidArgumentException('Valor total inválido');
    if (!isset($dados['valor_total']) || abs($total - (float)$dados['valor_total']) > 0.02) throw new InvalidArgumentException('Total da venda divergente; atualize os valores');

    $pdo->beginTransaction();
    $clienteStmt = $pdo->prepare('SELECT codigo FROM cliente WHERE codigo = :id');
    $clienteStmt->execute([':id' => $cliente]);
    if (!$clienteStmt->fetchColumn()) throw new InvalidArgumentException('Cliente não encontrado');

    $funcStmt = $pdo->prepare('SELECT id FROM funcionario WHERE id = :id AND ativo = 1');
    $funcStmt->execute([':id' => $funcionario]);
    if (!$funcStmt->fetchColumn()) throw new InvalidArgumentException('Funcionário não encontrado ou inativo');

    $funcStmt = $pdo->prepare('SELECT id FROM funcionario WHERE id = :id AND ativo = 1');
    $funcStmt->execute([':id' => $funcionario]);
    if (!$funcStmt->fetchColumn()) throw new InvalidArgumentException('Funcionário não encontrado ou inativo');

    // Bloqueio dos produtos em ordem fixa para impedir vendas concorrentes acima do saldo.
    ksort($agrupados, SORT_NUMERIC);
    $bloquear = $pdo->prepare('SELECT id FROM produto WHERE id = :id FOR UPDATE');
    $consultar = $pdo->prepare('SELECT fn_estoque(:id)');
    foreach ($agrupados as $produto => $qtd) {
        $bloquear->execute([':id' => $produto]);
        if (!$bloquear->fetchColumn()) throw new InvalidArgumentException('Produto ' . $produto . ' não encontrado');
        $consultar->execute([':id' => $produto]);
        if ((int)$consultar->fetchColumn() < $qtd) throw new InvalidArgumentException('Estoque insuficiente para o produto ' . $produto);
    }

    $stmt = $pdo->prepare('INSERT INTO venda (data_venda, num_cliente, num_funcionario, desconto_valor, desconto_percentual, acrescimo, valor_total, observacao) VALUES (:data, :cliente, :funcionario, :desconto, :percentual, :acrescimo, :total, :observacao)');
    $stmt->execute([':data' => $data, ':cliente' => $cliente, ':funcionario' => $funcionario, ':desconto' => $descontoValor, ':percentual' => $descontoPercentual, ':acrescimo' => $acrescimo, ':total' => $total, ':observacao' => $observacao]);
    $venda = (int)$pdo->lastInsertId();
    $stmtItem = $pdo->prepare('INSERT INTO item_venda (num_venda, num_produto, quantidade, preco_unitario, desconto_valor, desconto_percentual, acrescimo, subtotal_item) VALUES (:venda, :produto, :qtd, :preco, 0, 0, 0, :subtotal)');
    foreach ($itens as $item) {
        $qtd = (int)$item['quantidade'];
        $preco = (float)$item['preco_unitario'];
        $stmtItem->execute([':venda' => $venda, ':produto' => (int)$item['num_produto'], ':qtd' => $qtd, ':preco' => $preco, ':subtotal' => round($qtd * $preco, 2)]);
    }
    $stmtFin = $pdo->prepare('INSERT INTO movimento_financeiro (num_venda, tipo, forma_pagamento, valor, data_movimento) VALUES (:venda, :tipo, :forma, :valor, :data)');
    $stmtFin->execute([':venda' => $venda, ':tipo' => 'ENTRADA', ':forma' => $forma, ':valor' => $total, ':data' => $data]);
    $pdo->commit();
    http_response_code(201);
    echo json_encode(['num_venda' => $venda, 'valor_total' => $total, 'forma_pagamento' => $forma, 'mensagem' => 'Venda registrada com sucesso']);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    $validacao = $e instanceof InvalidArgumentException;
    http_response_code($validacao ? 400 : 500);
    error_log('Erro ao registrar venda: ' . $e->getMessage());
    echo json_encode(['erro' => $validacao ? $e->getMessage() : 'Erro ao registrar venda. Verifique a instalação do SQL e o log do servidor']);
}
