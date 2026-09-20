<?php
session_start();

require_once 'config/conexao.php';

$email = $_POST['email'] ?? ''; //$_POST pega dados enviados de forma "escondida" (corpo da requisição);                                         
$senha = $_POST['senha'] ?? ''; //$_GET pega dados que vêm na própria
                                

//stmt basicamente serve como um objeto para poder executar qualquer comando do SQL. o pdo basicamenteé quem faz a conexão com o banco de dados                            
$stmt = $pdo->prepare("SELECT id, nome, senha FROM usuario WHERE email = :email");
$stmt->execute(['email' => $email]);

$usuario = $stmt->fetch(PDO::FETCH_ASSOC);// o var usuario recebe o resultado do SELECT em array 

if ($usuario && password_verify($senha, $usuario['senha'])) { // aqui testa se a senha que digitou bate com que esta dentro do array
    $_SESSION['usuario_id'] = $usuario['id']; 
    $_SESSION['usuario_nome'] = $usuario['nome'];
    header('Location: home.php'); //aqui chama a tela se tudo de certo no login 
    exit;
} else {
    header('Location: index.php?erro=1');
    exit;
}

 ?>

 