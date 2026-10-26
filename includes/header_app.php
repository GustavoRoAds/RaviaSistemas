<?php
if (!defined('BASE_URL')) {
    define('BASE_URL', '/RaviaSistemas');
}

$nomeUsuario = $_SESSION['usuario_nome'] ?? 'Usuário';
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RAVIA Sistemas</title>
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/style.css">
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/notificacao.css">
</head>
<body>
    <div class="app-wrapper">

        <aside class="menu-lateral">

            <div class="bloco-logo">
                <div class="icone-quadrado">
                    <img src="<?php echo BASE_URL; ?>/img/logo/ravia_sistemas_logo_3.png" alt="RAVIA Sistemas">
                </div>
            </div>


    <div
    class="bloco-usuario"
    role="link"
    tabindex="0"
    onclick="window.location.href='/RaviaSistemas/home.php'"
    onkeydown="if(event.key === 'Enter' || event.key === ' '){event.preventDefault();window.location.href='/RaviaSistemas/home.php';}"
    style="cursor: pointer;"
>
    <div class="icone-redondo">
        <?php echo htmlspecialchars(mb_substr($nomeUsuario, 0, 1)); ?>
    </div>

    <div class="textos">
        <strong><?php echo htmlspecialchars($nomeUsuario); ?></strong>
    </div>
</div>
        

            <p class="titulo-secao">Menu</p>

            <nav class="links-menu">
                
                <a href="<?php echo BASE_URL; ?>/registrar_venda.php" class="item">
                    <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
                    <span>Registrar Venda</span>
                </a>

                <a href="<?php echo BASE_URL; ?>/cliente_listar.php" class="item">
                    <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <span>Clientes</span>
                </a>

                <a href="<?php echo BASE_URL; ?>/pagamento.php" class="item">
                    <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                    <span>Receber Pagamento</span>
                </a>

                <a href="<?php echo BASE_URL; ?>/views/produtos/produto_listar.php" class="item">
                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m12 3 9 5-9 5-9-5 9-5Z"></path>
                        <path d="M3 8v8l9 5 9-5V8"></path>
                        <path d="M12 13v8"></path>
                    </svg>
                    <span>Produto</span>
                </a>

                <a href="<?php echo BASE_URL; ?>/views/funcionarios/funcionarios_listar.php" class="item">
                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="8" r="5"></circle>
                        <path d="M20 21a8 8 0 0 0-16 0"></path>
                    </svg>
                    <span>Funcionario</span>
                </a>

            </nav>

            <div class="botao-sair">
                <a href="<?php echo BASE_URL; ?>/logout.php">
                    <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    <span>Sair</span>
                </a>
            </div>

        </aside>

        <!-- Marca em azul o item do menu da página aberta -->
        <script>
            var caminhoAtual = location.pathname.toLowerCase();
            var links = document.querySelectorAll('.links-menu .item');
            for (var i = 0; i < links.length; i++) {
                if (links[i].pathname.toLowerCase() === caminhoAtual) {
                    links[i].classList.add('ativo');
                }
            }
        </script>

        <main class="conteudo">