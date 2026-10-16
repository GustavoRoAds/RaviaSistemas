<?php
header('Content-Type: application/json; charset=utf-8');


require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;

$dados = json_decode(file_get_contents('php://input'), true);

switch ($metodo) {

    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM produto WHERE id = :codigo');
            $stmt->execute([':codigo' => $id]);
            $produto = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$produto) {
                http_response_code(404);
                echo json_encode(['erro' => 'Produto não encontrado']);
                break;
            }
            echo json_encode($produto);
        } else {
            $stmt = $pdo->query('SELECT * FROM produto ORDER BY id DESC');
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;

        
    case 'POST':
        if (empty($dados['nome']) || !isset($dados['preco'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe nome e preco']);
            break;
        }


        // if (!empty($dados['categoria_id'])) {

            
            // $stmt = $pdo->prepare('SELECT id FROM categoria WHERE id = :id');
            // $stmt->execute([
            //     ':id' => $dados['categoria_id']
            // ]);
            
            // $categoria = $stmt->fetch(PDO::FETCH_ASSOC);
            
        //     if (!$categoria) {
        //         http_response_code(400);
        //         echo json_encode(['erro' => 'categoria não encontrada']);
        //         break;
        //     }
        // }

        $stmt = $pdo->prepare('
                INSERT INTO produto 
                    (
                        nomeProduto, 
                        descricaoProduto, 
                        valorCusto, 
                        valorVenda, 
                        categoria_id
                    ) 
                    VALUES 
                    (
                        :nomeProduto, 
                        :descricaoProduto, 
                        :valorCusto, 
                        :valorVenda, 
                        :categoria_id
                    )');
    
        $stmt->execute([
        ':nomeProduto'  => $dados['nome'],
        ':descricaoProduto' => $dados['descricao'] ?? null,
        ':valorCusto' => $dados['custo'] ?? null,
        ':valorVenda' => $dados['valor'],
        ':categoria_id' => $dados['categoria_id'] ?? null,
        ]);    

        http_response_code(201);
        echo json_encode(['id' => $pdo->lastInsertId()]);
        break;









            case 'PUT':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o id do produto']);
            break;
        }

        if (empty($dados['nome']) || !isset($dados['valor'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe nome e valor']);
            break;
        }

        $stmt = $pdo->prepare('
            UPDATE produtos SET
                nomeProduto = :nomeProduto,
                descricaoProduto = :descricaoProduto,
                valorCusto = :valorCusto,
                valorVenda = :valorVenda,
                categoria_id = :categoria_id
            WHERE codigo = :codigo');

        $stmt->execute([
            ':nomeProduto'      => $dados['nome'],
            ':descricaoProduto' => $dados['descricao'] ?? null,
            ':valorCusto'       => $dados['custo'] ?? null,
            ':valorVenda'       => $dados['valor'],
            ':categoria_id'     => $dados['categoria_id'] ?? null,
            ':codigo'           => $id,
        ]);

        echo json_encode(['ok' => true]);
        break;







        

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}