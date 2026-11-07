<?php
require __DIR__ . '/../../includes/autenticar.php';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="../../css/pagina.css">
<link rel="stylesheet" href="../../css/funcionarios/funcionarios_listar.css?v=2">
<link rel="stylesheet" href="../../css/usuario/usuarios_listar.css?v=1">
<div class="topo-pagina topo-destaque">
    <div class="titulo-bloco">
        
        <div><nav class="migalhas"><a href="../../home.php">Início</a><span>/</span><span>Usuários</span></nav>
        <h1>Usuários</h1><p class="subtitulo-pagina" id="contador-usuarios">Carregando usuários...</p></div>
    </div>
    <a href="usuarios_cadastro.php" class="botao-novo">+ Novo Usuário</a>
</div>
<div class="cartao-lista">
    <div class="barra-busca">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
        <input type="search" id="busca-usuario" class="input-busca" placeholder="Buscar por nome ou e-mail..." autocomplete="off">
    </div>
    <div class="tabela-rolagem"><table class="tabela-produtos tabela-funcionarios tabela-usuarios"><thead><tr><th>USUÁRIO</th><th>E-MAIL</th><th>IDENTIFICADOR</th><th>SITUAÇÃO</th></tr></thead><tbody id="corpo-tabela-usuarios"><tr><td colspan="4">Carregando usuários...</td></tr></tbody></table></div>
</div>
<script src="../../js/usuario/usuarios_listar.js?v=1"></script>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
