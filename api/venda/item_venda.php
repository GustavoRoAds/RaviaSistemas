<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;
$dados = json_decode(file_get_contents('php://input'), true);

switch ($metodo) {

    case 'GET':
        // if ($id) {
        //     $stmt = $pdo->prepare('SELECT * FROM venda WHERE num_venda  = :num_venda ');
        //     $stmt->execute([':num_venda ' => $id]);
        //     $venda = $stmt->fetch(PDO::FETCH_ASSOC);

        //     if (!$venda) {
        //         http_response_code(404);
        //         echo json_encode(['erro' => 'venda não encontrado']);
        //         break;
        //     }
        //     echo json_encode($venda);
        // } else {
            
        //     $stmt = $pdo->query('SELECT * FROM venda ORDER BY num_venda DESC');
        //     echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            
        // }
        // break;

        
    case 'POST':
        if (empty($dados['num_venda']) || !isset($dados['num_produto'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe a venda e produto']);
            break;
        }

        if (empty($dados['preco_unitario']) || !isset($dados['quantidade'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o valor e quantidade']);
            break;
        }

        if (isset($dados['quantidade']) < 0) {
            http_response_code(400);
            echo json_encode(['erro' => 'quantidade tem que ser maior que zero']);
            break;
        }

        $stmt = $pdo->prepare('
            INSERT INTO item_venda
            (
                num_venda, num_produto, quantidade,
                preco_unitario, desconto_valor, desconto_percentual, acrescimo, subtotal_item
            )
            VALUES
            (
                :num_venda, :num_produto, :quantidade,
                :preco_unitario, :desconto_valor, :desconto_percentual, :acrescimo, :subtotal_item
            )
        ');

        $stmt->execute([
            ':num_venda' => $dados['num_venda'],
            ':num_produto' => $dados['num_produto'] ?? null,
            ':quantidade' => $dados['quantidade'] ?? null,
            ':preco_unitario' => $dados['preco_unitario'] ?? 0,
            ':desconto_valor' => $dados['desconto_valor'],
            ':desconto_percentual' => (int) ($dados['desconto_percentual'] ?? 0),
            ':subtotal_item' => (int) ($dados['subtotal_item'] ?? 0),
            ':acrescimo' => (int) ($dados['acrescimo'] ?? 0)   
        ]);

        http_response_code(201);
        echo json_encode(['num_venda' => $pdo->lastInsertId()]);
        break;
    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}