<?php
header('Content-Type: application/json; charset=utf-8');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function responder(int $status, array $dados): void
{
    http_response_code($status);
    echo json_encode($dados, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

if (empty($_SESSION['usuario_id'])) {
    responder(401, ['erro' => 'Sessão expirada. Faça login novamente.']);
}

$metodo = $_SERVER['REQUEST_METHOD'];
if (!in_array($metodo, ['GET', 'POST'], true)) {
    header('Allow: GET, POST');
    responder(405, ['erro' => 'Método não permitido.']);
}

$credenciais = getenv('FIREBASE_CREDENTIALS_PATH');
if (!$credenciais || !is_file($credenciais) || !is_readable($credenciais)) {
    responder(500, ['erro' => 'Firebase não configurado. Defina FIREBASE_CREDENTIALS_PATH com o caminho absoluto para o JSON da conta de serviço do Firebase.']);
}

try {
    require_once __DIR__ . '/../../vendor/autoload.php';
    $auth = (new \Kreait\Firebase\Factory())
        ->withServiceAccount($credenciais)
        ->createAuth();

    if ($metodo === 'GET') {
        $usuarios = [];
        foreach ($auth->listUsers() as $usuario) {
            $usuarios[] = [
                'uid' => $usuario->uid,
                'displayName' => $usuario->displayName ?? '',
                'email' => $usuario->email ?? '',
                'disabled' => (bool) ($usuario->disabled ?? false),
            ];
        }
        responder(200, $usuarios);
    }

    $dados = json_decode(file_get_contents('php://input'), true);
    if (!is_array($dados)) {
        responder(400, ['erro' => 'Envie os dados em formato JSON.']);
    }

    $nome = trim((string) ($dados['nome'] ?? ''));
    $email = trim((string) ($dados['email'] ?? ''));
    $senha = (string) ($dados['senha'] ?? '');

    if ($nome === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($senha) < 6) {
        responder(400, ['erro' => 'Informe nome, e-mail válido e senha de pelo menos 6 caracteres.']);
    }

    $usuario = $auth->createUser([
        'displayName' => $nome,
        'email' => $email,
        'password' => $senha,
        'emailVerified' => false,
    ]);

    responder(201, ['mensagem' => 'Usuário cadastrado com sucesso!', 'uid' => $usuario->uid]);
} catch (\Kreait\Firebase\Exception\Auth\EmailExists $e) {
    responder(409, ['erro' => 'Este e-mail já está cadastrado no Firebase.']);
} catch (\Throwable $e) {
    error_log('API usuarios Firebase: ' . $e->getMessage());
    responder(500, ['erro' => 'Falha na comunicação com o Firebase. Confira a conta de serviço e as permissões. Consulte o log do PHP para detalhes.']);
}
