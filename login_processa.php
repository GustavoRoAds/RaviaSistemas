<?php
session_start();

require_once 'config/conexao.php';

$email = $_POST['email'] ?? '';
$senha = $_POST['senha'] ?? '';

$stmt = $pdo->prepare("SELECT id, nome, senha FROM usuario WHERE email = :email");
$stmt->execute(['email' => $email]);

$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if ($usuario && password_verify($senha, $usuario['senha'])) {
    $_SESSION['usuario_id'] = $usuario['id'];
    $_SESSION['usuario_nome'] = $usuario['nome'];
    header('Location: home.php'); //aqui chama a tela se tudo de certo no login 
    exit;
} else {
    header('Location: index.php?erro=1');
    exit;
}

 ?>

 