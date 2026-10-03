<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}
require_once 'config/conexao.php';
require_once 'controllers/ProdutoController.php';

$controller = new ProdutoController($pdo);
$controller->exibirFormulario();