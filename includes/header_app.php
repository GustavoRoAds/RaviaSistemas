<?php $paginaAtual = $paginaAtual ?? ''; ?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>RAVIA Sistemas</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-wrapper">


       <aside class="menu-lateral">
            
            <div class="bloco-logo">
                <div class="icone-quadrado"><img src="img/logo/ravia_sistemas_logo_3.png" alt=""></div>
                <div class="textos"> </div>
            </div>

            <div class="bloco-usuario">
                <div class="icone-redondo"></div>
                <div class="textos">
                    <strong>Usuario</strong>
                </div>
            </div>

          <nav class="links-menu">
            <a href="registrar_venda.php" class="item <?= $paginaAtual === 'venda' ? 'ativo' : '' ?>">Registrar Venda</a>
            <a href="clientes.php" class="item <?= $paginaAtual === 'clientes' ? 'ativo' : '' ?>">Clientes</a>
            <a href="pagamento.php" class="item <?= $paginaAtual === 'pagamento' ? 'ativo' : '' ?>">Receber Pagamento</a>
            <a href="produto_cadastro.php" class="item <?= $paginaAtual === 'produto' ? 'ativo' : '' ?>">produto</a>
        </nav>

            <div class="botao-sair">
                <a href="logout.php">Sair</a>
            </div>

        </aside>


        <main class="conteudo">