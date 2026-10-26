<?php
require 'includes/autenticar.php';
require 'includes/header_app.php';

?>

<h1>Bem Vindo, <?php echo htmlspecialchars($_SESSION['usuario_nome']); ?></h1>


<?php require 'includes/footer_app.php'; ?>