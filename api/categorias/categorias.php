<?php

session_start();
header('Content-Type: application/json; charset=utf-8');

ini_set('display_errors', '0');

if (!isset($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Não autorizado. Faça login.'], JSON_UNESCAPED_UNICODE);
    exit;
}

require __DIR__ . '/../../config/conexao.php';

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

try {
    if (in_array($_SERVER['REQUEST_METHOD'], ['POST', 'PUT'], true)) {
        $dados = json_decode(file_get_contents('php://input'), true);
        $descricao = trim((string)($dados['descricao'] ?? ''));
        if ($descricao === '' || mb_strlen($descricao) > 100) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe uma descrição de até 100 caracteres.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $stmt = $pdo->prepare('INSERT INTO categoria (descricao) VALUES (?)');
            $stmt->execute([$descricao]);
            $codigo = (int)$pdo->lastInsertId();
            http_response_code(201);
        } else {
            $codigo = filter_var($dados['codigo'] ?? '', FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
            $pdo->beginTransaction();
            $stmt = $pdo->prepare('SELECT descricao FROM categoria WHERE codigo = ? FOR UPDATE');
            $stmt->execute([$codigo]);
            $anterior = $stmt->fetchColumn();
            if ($anterior === false) {
                $pdo->rollBack();
                http_response_code(404);
                echo json_encode(['erro' => 'Registro não localizado.'], JSON_UNESCAPED_UNICODE);
                exit;
            }
            $stmt = $pdo->prepare('UPDATE categoria SET descricao = ? WHERE codigo = ?');
            $stmt->execute([$descricao, $codigo]);
            $stmt = $pdo->prepare('UPDATE produto SET categoria = ? WHERE categoria = ?');
            $stmt->execute([$descricao, $anterior]);
            $pdo->commit();
        }
        echo json_encode(['id' => $codigo, 'nome' => $descricao], JSON_UNESCAPED_UNICODE);
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
        $codigo = filter_var($_GET['id'] ?? '', FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
        if (!$codigo) {
            http_response_code(400);
            echo json_encode(['erro' => 'Código inválido.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        $stmt = $pdo->prepare('DELETE FROM categoria WHERE codigo = ? AND NOT EXISTS (SELECT 1 FROM produto WHERE produto.categoria = categoria.descricao)');
        $stmt->execute([$codigo]);
        if (!$stmt->rowCount()) {
            $stmt = $pdo->prepare('SELECT codigo FROM categoria WHERE codigo = ?');
            $stmt->execute([$codigo]);
            $existe = $stmt->fetchColumn();
            http_response_code($existe ? 409 : 404);
            echo json_encode(['erro' => $existe ? 'Não é possível excluir uma categoria vinculada a produtos.' : 'Categoria não encontrada.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        echo json_encode(['sucesso' => true]);
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        exit;
    }
    if (isset($_GET['id'])) {
        $stmt = $pdo->prepare('SELECT codigo AS id, descricao AS nome FROM categoria WHERE codigo = ?');
        $stmt->execute([$_GET['id']]);
        $registro = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$registro) {
            http_response_code(404);
            echo json_encode(['erro' => 'Registro não localizado.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        echo json_encode($registro, JSON_UNESCAPED_UNICODE);
        exit;
    }
    $stmt = $pdo->query('SELECT codigo AS id, descricao AS nome FROM categoria ORDER BY descricao');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC), JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    if ($e->getCode() === '23000') {
        http_response_code(409);
        echo json_encode(['erro' => 'Código ou descrição já cadastrados.'], JSON_UNESCAPED_UNICODE);
        exit;
    }
    error_log('[api/categorias/categorias.php] ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['erro' => 'Erro ao acessar o banco de dados.'], JSON_UNESCAPED_UNICODE);
}
