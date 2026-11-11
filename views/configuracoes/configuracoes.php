<?php
session_start();
if (empty($_SESSION['usuario_id'])) {
    header('Location: /RaviaSistemas/index.php');
    exit;
}
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="/RaviaSistemas/css/configuracoes.css">
<div class="topo-pagina topo-destaque">
    <nav class="config-migalhas"><a href="/RaviaSistemas/home.php">Início</a> › Configurações</nav>
    <h1>Configurações do Sistema</h1>
    <p>Defina os parâmetros utilizados no sistema.</p>
</div>
<section class="config-card">
    <div class="config-cabecalho">
        <div class="config-icone">⚙</div>
        <div><h2>Configurações de venda</h2><p>Cliente selecionado automaticamente ao registrar uma nova venda.</p></div>
    </div>
    <label for="config-busca">Cliente padrão</label>
    <div class="config-busca-container">
        <input id="config-busca" type="text" placeholder="Pesquisar cliente por nome ou CPF" autocomplete="off">
        <div id="config-resultados" class="config-resultados" hidden></div>
    </div>
    <div id="config-selecionado" class="config-selecionado" hidden>
        <span id="config-nome"></span>
        <button type="button" id="config-remover" title="Remover cliente padrão">×</button>
    </div>
    <p class="config-ajuda">Deixe sem cliente para selecionar manualmente em cada venda.</p>
    <button type="button" id="config-salvar" class="config-salvar">Salvar configurações</button>
    <p id="config-mensagem" role="status"></p>
</section>
<script src="/RaviaSistemas/js/configuracoes.js"></script>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
