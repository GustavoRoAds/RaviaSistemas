<?php
// =====================================================
//  API DE CATEGORIAS
//  GET api/categorias.php -> lista todas as categorias
// =====================================================

session_start();
header('Content-Type: application/json; charset=utf-8');

// erros do PHP não podem aparecer na resposta, senão quebram o JSON
ini_set('display_errors', '0');

// só quem está logado pode usar a API
if (!isset($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Não autorizado. Faça login.'], JSON_UNESCAPED_UNICODE);
    exit;
}

require __DIR__ . '/../config/conexao.php';
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

try {
    $stmt = $pdo->query('SELECT * FROM categoria ORDER BY id');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC), JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    error_log('[api/categorias/categorias.php] ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['erro' => 'Erro ao acessar o banco de dados.'], JSON_UNESCAPED_UNICODE);
}