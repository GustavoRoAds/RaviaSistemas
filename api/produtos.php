<?php
header('Content-Type: application/json; charset=utf-8');

require 'config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;

$dados = json_decode(file_get_contents('php://input'), true);

switch ($metodo) {

    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM produtos WHERE codigo = :codigo');
            $stmt->execute([':codigo' => $id]);
            $produto = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$produto) {
                http_response_code(404);
                echo json_encode(['erro' => 'Produto não encontrado']);
                break;
            }
            echo json_encode($produto);
        } else {
            $stmt = $pdo->query('SELECT * FROM produtos ORDER BY codigo DESC');
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;

        
    case 'POST':
        if (empty($dados['nome']) || !isset($dados['preco'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe nome e preco']);
            break;
        }

        if ($dados['categoria_id']) 
        $stmt = $pdo->prepare('INSERT INTO produtos (nomeProduto, descricaoProduto, 
                                                    valorCusto, valorVenda, 
                                                    categoria_id) 
                                                    VALUES (:nomeProduto, :descricaoProduto, :valorCusto,
                                                    :valorVenda, :categoria_id)');
        $stmt->execute([
            ':nomeProduto'  => $dados['nome'],
            ':descricaoProduto' => $dados['descricao'],
            ':valorCusto' => $dados['custo'],
            ':valorVenda' => $dados['valor'],
            ':categoria_id' => $dados['categoria_id'],
        ]);

        http_response_code(201);
        echo json_encode(['id' => $pdo->lastInsertId()]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}