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

        $num_venda = (int) ($dados['num_venda'] ?? 0);
        $itens = $dados['itens'] ?? [];
    
        if ($num_venda <= 0 || !is_array($itens) || count($itens) === 0) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe a venda e seus produtos']);
            break;
        }
    
        try {
    
            $pdo->beginTransaction();
    
            $stmt = $pdo->prepare('
                INSERT INTO item_venda
                (
                    num_venda, num_produto, quantidade,
                    preco_unitario, desconto_valor,
                    desconto_percentual, acrescimo, subtotal_item
                )
                VALUES
                (
                    :num_venda, :num_produto, :quantidade,
                    :preco_unitario, :desconto_valor,
                    :desconto_percentual, :acrescimo, :subtotal_item
                )
            ');
    
            foreach ($itens as $item) {
    
                $produto = (int) ($item['num_produto'] ?? 0);
                $quantidade = (int) ($item['quantidade'] ?? 0);
                $preco = (float) ($item['preco_unitario'] ?? 0);
    
                if ($produto <= 0 || $quantidade <= 0 || $preco <= 0) {
                    throw new Exception('Produto, quantidade ou preço inválido');
                }
    
                $stmt->execute([
                    ':num_venda' => $num_venda,
                    ':num_produto' => $produto,
                    ':quantidade' => $quantidade,
                    ':preco_unitario' => $preco,
                    ':desconto_valor' => $item['desconto_valor'] ?? 0,
                    ':desconto_percentual' => $item['desconto_percentual'] ?? 0,
                    ':acrescimo' => $item['acrescimo'] ?? 0,
                    ':subtotal_item' => round($quantidade * $preco, 2)
                ]);
            }
    
            $pdo->commit();
    
            http_response_code(201);
    
            echo json_encode([
                'mensagem' => 'Itens cadastrados com sucesso',
                'num_venda' => $num_venda,
                'quantidade_itens' => count($itens)
            ]);
    
        } catch (Throwable $e) {
    
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
    
            http_response_code(400);
    
            echo json_encode([
                'erro' => 'Não foi possível cadastrar os itens'
            ]);
    
            // error_log($e->getMessage());
            echo json_encode([
                'erro' => 'Não foi possível cadastrar os itens',
                'detalhes' => $e->getMessage()
            ]);
        }
    
        break;
    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}