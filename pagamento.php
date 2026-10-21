<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}

$paginaAtual = 'pagamento';
require 'includes/header_app.php';
?>

<h1>Paagamentos</h1>

<?php require 'includes/footer_app.php'; ?>