<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}
require 'includes/header_app.php';
?>

<h1>Bem Vindo, <?php echo htmlspecialchars($_SESSION['usuario_nome']); ?></h1>
<a href="logout.php">Sair</a>

<?php require 'includes/footer_app.php'; ?>