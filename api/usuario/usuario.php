<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../vendor/autoload.php';

use Kreait\Firebase\Factory;

$dados = json_decode(file_get_contents('php://input'), true);

try {
    
    $firebase = (new Factory)
        ->withServiceAccount(getenv('FIREBASE_CREDENTIALS_PATH'));

    $auth = $firebase->createAuth();

    $usuario = $auth->createUser([
        'displayName' => $dados['nome'],
        'email' => $dados['email'],
        'password' => $dados['senha'],
        'emailVerified' => false
    ]);

    http_response_code(201);

    echo json_encode([
        'mensagem' => 'Usuário cadastrado com sucesso!',
        'uid' => $usuario->uid
    ]);

} catch (Throwable $e) {
    error_log($e->getMessage());

    http_response_code(400);

    echo json_encode([
        'erro' => 'Não foi possível cadastrar o usuário.'
    ]);
}