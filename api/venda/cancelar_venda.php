<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../../config/conexao.php';
/** @var PDO $pdo */

if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Sessão expirada']);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['erro' => 'Método não permitido']);
    exit;
}
try {
    $dados = json_decode(file_get_contents('php://input'), true, 512, JSON_THROW_ON_ERROR);
    $numero = filter_var($dados['num_venda'] ?? null, FILTER_VALIDATE_INT);
    $motivo = trim((string)($dados['motivo'] ?? ''));
    if (!$numero || $numero < 1 || $motivo === '' || mb_strlen($motivo) > 255) {
        throw new InvalidArgumentException('Informe a venda e um motivo de até 255 caracteres');
    }

    $pdo->beginTransaction();
    $stmt = $pdo->prepare('SELECT num_venda, situacao FROM venda WHERE num_venda = :id FOR UPDATE');
    $stmt->execute([':id' => $numero]);
    $venda = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$venda) throw new InvalidArgumentException('Venda não encontrada');
    if ($venda['situacao'] === 'CANCELADA') throw new InvalidArgumentException('Esta venda já foi cancelada');

    $stmt = $pdo->prepare("SELECT id, forma_pagamento, valor FROM movimento_financeiro WHERE num_venda = :id AND tipo = 'ENTRADA' FOR UPDATE");
    $stmt->execute([':id' => $numero]);
    $recebimentos = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (count($recebimentos) > 1) {
        throw new InvalidArgumentException('A venda possui mais de um recebimento. Verifique os lançamentos financeiros antes de cancelar.');
    }
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM movimento_financeiro WHERE num_venda = :id AND tipo = 'SAIDA'");
    $stmt->execute([':id' => $numero]);
    if ((int)$stmt->fetchColumn() > 0) throw new InvalidArgumentException('Esta venda já possui estorno financeiro. Verifique antes de cancelar.');

    $stmt = $pdo->prepare("UPDATE venda SET situacao = 'CANCELADA', cancelada_em = NOW(), cancelada_por = :usuario, motivo_cancelamento = :motivo WHERE num_venda = :id AND situacao = 'ATIVA'");
    $stmt->execute([':usuario' => (string)$_SESSION['usuario_id'], ':motivo' => $motivo, ':id' => $numero]);
    if ($stmt->rowCount() !== 1) throw new RuntimeException('Não foi possível cancelar a venda');

    // Somente estorna quando existe um recebimento original.
    // Vendas importadas sem financeiro podem ser canceladas sem criar saída fictícia.
    if (count($recebimentos) === 1) {
        $recebimento = $recebimentos[0];
        $stmt = $pdo->prepare("INSERT INTO movimento_financeiro (num_venda, tipo, forma_pagamento, valor, data_movimento) VALUES (:venda, 'SAIDA', :forma, :valor, CURDATE())");
        $stmt->execute([':venda' => $numero, ':forma' => $recebimento['forma_pagamento'], ':valor' => $recebimento['valor']]);
    }
    // Os itens não são excluídos. A fn_estoque ignora vendas canceladas.
    $pdo->commit();
    echo json_encode(['mensagem' => count($recebimentos) === 1
        ? 'Venda cancelada. Estoque restabelecido e financeiro estornado.'
        : 'Venda cancelada. Estoque restabelecido; não havia recebimento financeiro para estornar.']);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    $validacao = $e instanceof InvalidArgumentException;
    http_response_code($validacao ? 400 : 500);
    error_log('Erro ao cancelar venda ' . ($numero ?? 'desconhecida') . ': ' . $e->getMessage());
    echo json_encode(['erro' => $validacao ? $e->getMessage() : 'Não foi possível cancelar a venda. Confira o SQL de atualização e o log do PHP.']);
}
