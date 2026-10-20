<?php
session_start();
require 'services/FirebaseAuthService.php';

$config = require 'config/firebase.php';

$email = trim($_POST['email'] ?? '');
$senha = $_POST['senha'] ?? '';

$firebase  = new FirebaseAuthService($config['api_key']);
$resultado = $firebase->login($email, $senha);

if (!$resultado['ok']) {
    header('Location: index.php?erro=1');
    exit;
}

$d = $resultado['dados'];

// Nome de exibição: displayName do Firebase, se houver; senão, a parte do e-mail antes do @
$nome = $d['displayName'] ?? '';
if ($nome === '') {
    $nome = ucfirst(explode('@', $d['email'])[0]);
}

session_regenerate_id(true);

$_SESSION['usuario_id']       = $d['localId'];
$_SESSION['usuario_nome']     = $nome;
$_SESSION['fb_id_token']      = $d['idToken'];
$_SESSION['fb_refresh_token'] = $d['refreshToken'];
$_SESSION['fb_expira_em']     = time() + (int)$d['expiresIn'] - 60;

header('Location: home.php');
exit;