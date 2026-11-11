<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Sessão expirada']);
    exit;
}
require_once __DIR__ . '/../../config/conexao.php';
try {
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $stmt = $pdo->query('SELECT c.cliente_padrao_codigo, cl.nome, cl.cpf FROM configuracao_sistema c LEFT JOIN cliente cl ON cl.codigo = c.cliente_padrao_codigo AND cl.ativo = 1 WHERE c.id = 1');
        echo json_encode($stmt->fetch(PDO::FETCH_ASSOC) ?: ['cliente_padrao_codigo' => null]);
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
        exit;
    }
    $dados = json_decode(file_get_contents('php://input'), true);
    if (!is_array($dados) || !array_key_exists('cliente_padrao_codigo', $dados)) {
        http_response_code(400);
        echo json_encode(['erro' => 'Informe o cliente padrão']);
        exit;
    }
    $codigo = $dados['cliente_padrao_codigo'];
    if ($codigo === '' || $codigo === null) {
        $codigo = null;
    } else {
        if (filter_var($codigo, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]) === false) {
            http_response_code(400);
            echo json_encode(['erro' => 'Código inválido']);
            exit;
        }
        $codigo = (int) $codigo;
        $consulta = $pdo->prepare('SELECT codigo FROM cliente WHERE codigo = ? AND ativo = 1');
        $consulta->execute([$codigo]);
        if (!$consulta->fetchColumn()) {
            http_response_code(400);
            echo json_encode(['erro' => 'Selecione um cliente ativo']);
            exit;
        }
    }
    $stmt = $pdo->prepare('INSERT INTO configuracao_sistema (id, cliente_padrao_codigo) VALUES (1, ?) ON DUPLICATE KEY UPDATE cliente_padrao_codigo = VALUES(cliente_padrao_codigo)');
    $stmt->execute([$codigo]);
    echo json_encode(['sucesso' => true]);
} catch (Throwable $e) {
    error_log('Erro nas configurações: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['erro' => 'Não foi possível acessar as configurações. Verifique a atualização do banco.']);
}
