<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

switch ($metodo) {

    case 'GET':

        if (!$id || $id <= 0) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o código do produto']);
            break;
        }

        try {
        
            $stmt = $pdo->prepare("
                SELECT id, nome
                FROM produto
                WHERE id = :id
            ");

            $stmt->execute([':id' => $id]);
            $produto = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$produto) {
                http_response_code(404);
                echo json_encode(['erro' => 'Produto não encontrado']);
                break;
            }

            $stmt = $pdo->prepare("
                SELECT fn_estoque(:id) AS estoque
            ");

            $stmt->execute([':id' => $id]);
            $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

            echo json_encode([
                'codigo' => (int) $produto['id'],
                'nome' => $produto['nome'],
                'estoque' => (int) $resultado['estoque']
            ]);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['erro' => 'Erro ao consultar estoque']);
        }

        break;

    default:
        http_response_code(405);
        header('Allow: GET');
        echo json_encode(['erro' => 'Método não permitido']);
        break;
}