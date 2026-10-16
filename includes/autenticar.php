<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}


if (time() >= ($_SESSION['fb_expira_em'] ?? 0)) {
    require_once __DIR__ . '/../services/FirebaseAuthService.php';
    $config = require __DIR__ . '/../config/firebase.php';

    $firebase  = new FirebaseAuthService($config['api_key']);
    $resultado = $firebase->renovar($_SESSION['fb_refresh_token'] ?? '');

    if (!$resultado['ok']) {
        session_unset();
        session_destroy();
        header('Location: index.php?erro=1');
        exit;
    }

    $d = $resultado['dados'];
    $_SESSION['fb_id_token']      = $d['id_token'];
    $_SESSION['fb_refresh_token'] = $d['refresh_token'];
    $_SESSION['fb_expira_em']     = time() + (int)$d['expires_in'] - 60;
}