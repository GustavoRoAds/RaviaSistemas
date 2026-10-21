<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}

$paginaAtual = 'venda';
require 'includes/header_app.php';
?>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/registrar_venda/registrar_venda.css">

<div class="venda-pagina">

    <div class="topo-pagina">
        <div>
            <h1>Registrar Venda</h1>
            <p class="subtitulo-pagina">Busque produtos para adicionar à venda</p>
        </div>
    </div>

    <section class="venda-card">
        <div class="venda-card-corpo">
            <h2 class="venda-rotulo">Adicionar produto</h2>
            <div class="venda-busca" id="venda-busca-produto">
                <div class="venda-campo">
                    <input type="text" id="busca-produto" placeholder="Buscar produto por nome" autocomplete="off">
                </div>
                <div class="venda-lista" id="lista-produtos"></div>
            </div>
        </div>
    </section>

    <section class="venda-card">
        <h2 class="venda-card-titulo">Itens da Venda</h2>
        <div class="venda-vazio" id="itens-vazio">
            
            <p>Nenhum produto adicionado</p>
        </div>
        <ul class="venda-itens" id="itens-lista"></ul>
    </section>

    <section class="venda-card">
        <div class="venda-card-corpo">
            <h2 class="venda-rotulo">Cliente (opcional)</h2>
            <div class="venda-busca" id="venda-busca-cliente">
                <div class="venda-campo" id="campo-cliente">
                    
                    <input type="text" id="busca-cliente" placeholder="Buscar cliente por nome ou CPF" autocomplete="off">
                </div>
                <div class="venda-lista" id="lista-clientes"></div>
                <div class="venda-chip" id="chip-cliente">
                    <div>
                        <strong id="chip-nome"></strong>
                        <span id="chip-cpf"></span>
                    </div>
                    <button type="button" id="chip-remover" aria-label="Remover cliente">&times;</button>
                </div>
            </div>
        </div>
    </section>

    <div class="venda-aviso" id="venda-aviso"></div>

    <section class="venda-total">
        <div>
            <span class="venda-total-rotulo">Total da venda</span>
            <strong class="venda-total-valor" id="venda-total">R$ 0,00</strong>
        </div>
        <button type="button" class="venda-confirmar" id="btn-confirmar" disabled>Confirmar Venda</button>
    </section>

</div>

<script src="js/registrar_venda/registrar_venda.js"></script>

<?php require 'includes/footer_app.php'; ?>