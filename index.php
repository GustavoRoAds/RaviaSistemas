<?php
session_start();
if (isset($_SESSION['usuario_id'])) {
    header('Location: home.php');
    exit;
}
require 'includes/header.php';
?>
    <div class="login-wrapper">
        <img src="./img/logo/ravia_sistemas_logo_3.png" alt="Ravia Sistemas" class="logo-completa">
        <p class="subtitulo-sistema">Gestão de varejo simplificada</p>

        <div class="login-container">
            
            <?php if (isset($_GET['erro'])): ?>
                <p class="erro">E-mail ou senha inválidos.</p>
            <?php endif; ?>

            <form action="login_processa.php" method="POST">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" placeholder="seu@email.com" required>

                <label for="senha">Senha</label>
                <input type="password" id="senha" name="senha" placeholder="••••••••" required>

                <button type="submit">Entrar</button>
            </form>
        </div>
    </div>
    
<?php require 'includes/footer.php'; ?>