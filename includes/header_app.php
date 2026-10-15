<?php $paginaAtual = $paginaAtual ?? ''; ?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RAVIA Sistemas</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/notificacao.css">
</head>
<body>
    <div class="app-wrapper">

        <aside class="menu-lateral">

            <div class="bloco-logo">
                <div class="icone-quadrado">
                    <img src="img/logo/ravia_sistemas_logo_3.png" alt="RAVIA Sistemas">
                </div>
            </div>

            <div class="bloco-usuario">
                <div class="icone-redondo">U</div>
                <div class="textos">
                    <strong>Usuario</strong>
                </div>
            </div>

<<<<<<< HEAD
          <nav class="links-menu">
            <a href="registrar_venda.php" class="item <?= $paginaAtual === 'venda' ? 'ativo' : '' ?>">Registrar Venda</a>
            <a href="clientes.php" class="item <?= $paginaAtual === 'clientes' ? 'ativo' : '' ?>">Clientes</a>
            <a href="pagamento.php" class="item <?= $paginaAtual === 'pagamento' ? 'ativo' : '' ?>">Receber Pagamento</a>
            <a href="produto_cadastro.php" class="item <?= $paginaAtual === 'produto' ? 'ativo' : '' ?>">produto</a>
        </nav>
=======
            <p class="titulo-secao">Menu</p>

            <nav class="links-menu">
                <a href="registrar_venda.php" class="item">
                    <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
                    <span>Registrar Venda</span>
                </a>
                <a href="cliente_listar.php" class="item">
                    <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <span>Clientes</span>
                </a>
                <a href="#" class="item">
                    <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                    <span>Receber Pagamento</span>
                </a>
            </nav>
>>>>>>> 07a8b8af25026826b43b09f49cf14f86b2db9231

            <div class="botao-sair">
                <a href="logout.php">
                    <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    <span>Sair</span>
                </a>
            </div>

        </aside>

        <!-- Marca em azul o item do menu da página aberta -->
        <script>
            var paginaAberta = location.pathname.split('/').pop();
            var links = document.querySelectorAll('.links-menu .item');
            for (var i = 0; i < links.length; i++) {
                if (links[i].getAttribute('href') === paginaAberta) {
                    links[i].classList.add('ativo');
                }
            }
        </script>

        <main class="conteudo">