<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;
$dados = json_decode(file_get_contents('php://input'), true);

switch ($metodo) {

    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM venda WHERE num_venda  = :num_venda ');
            $stmt->execute([':num_venda ' => $id]);
            $venda = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$venda) {
                http_response_code(404);
                echo json_encode(['erro' => 'venda não encontrada']);
                break;
            }
            echo json_encode($venda);
        } else {
            
            $stmt = $pdo->query('SELECT * FROM venda ORDER BY num_venda DESC');
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            
        }
        break;

        
    case 'POST':
        if (empty($dados['num_cliente']) || !isset($dados['valor_total'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe cliente e valor total']);
            break;
        }

        $stmt = $pdo->prepare('
            INSERT INTO venda
            (
                data_venda, num_cliente, desconto_valor,
                desconto_percentual, acrescimo, valor_total, observacao
            )
            VALUES
            (
                :data_venda, :num_cliente, :desconto_valor,
                :desconto_percentual, :acrescimo, :valor_total, :observacao
            )
        ');

        $stmt->execute([
            ':data_venda' => $dados['data_venda'],
            ':num_cliente' => $dados['num_cliente'] ?? null,
            ':desconto_valor' => $dados['desconto_valor'] ?? null,
            ':desconto_percentual' => $dados['desconto_percentual'] ?? 0,
            ':acrescimo' => $dados['acrescimo'],
            ':valor_total' => (float) ($dados['valor_total'] ?? 0),
            ':observacao' => $dados['observacao'] ?? null   
        ]);

        http_response_code(201);
        echo json_encode(['num_venda' => $pdo->lastInsertId()]);
        break;

    case 'PUT':
        // if (!$id) {
        //     http_response_code(400);
        //     echo json_encode(['erro' => 'Informe o ID do produto.']);
        //     break;
        // }

        // if (empty($dados['nome']) || !isset($dados['valor'])) {
        //     http_response_code(400);
        //     echo json_encode(['erro' => 'Informe nome e valor de venda.']);
        //     break;
        // }

        // $verificar = $pdo->prepare(
        //     'SELECT id FROM produto WHERE id = :id'
        // );
        // $verificar->execute([':id' => $id]);

        // if (!$verificar->fetch(PDO::FETCH_ASSOC)) {
        //     http_response_code(404);
        //     echo json_encode(['erro' => 'Produto não encontrado.']);
        //     break;
        // }

        // $stmt = $pdo->prepare('
        //     UPDATE produto
        //     SET
        //         nome = :nome,
        //         descricao = :descricao,
        //         categoria = :categoria,
        //         valor_custo = :custo,
        //         valor_venda = :valor,
        //         estoque = :estoque
        //     WHERE id = :id
        // ');

        // $stmt->execute([
        //     ':nome' => $dados['nome'],
        //     ':descricao' => $dados['descricao'] ?? null,
        //     ':categoria' => $dados['categoria'] ?? null,
        //     ':custo' => $dados['custo'] ?? 0,
        //     ':valor' => $dados['valor'],
        //     ':estoque' => (int) ($dados['estoque'] ?? 0),
        //     ':id' => $id
        // ]);

        // http_response_code(200);
        // echo json_encode([
        //     'id' => $id,
        //     'mensagem' => 'Produto atualizado com sucesso.'
        // ]);
    break;

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}