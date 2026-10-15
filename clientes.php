<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}

$paginaAtual = 'clientes';
require 'includes/header_app.php';
?>

<link rel="stylesheet" href="css/clientes.css">

<div class="cli-pagina">

    <!-- TOPO: título + botão Novo Cliente -->
    <div class="topo-pagina cli-topo">
        <div>
            <h1>Clientes</h1>
            <p class="subtitulo-pagina" id="cli-quantidade">0 clientes cadastrados</p>
        </div>
        <button type="button" class="cli-botao-novo" id="btn-novo-cliente">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            Novo Cliente
        </button>
    </div>

    <!-- BUSCA -->
    <div class="cli-busca">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input type="text" id="cli-busca" placeholder="Buscar por nome, CPF ou telefone..." autocomplete="off">
    </div>

    <!-- TABELA DE CLIENTES -->
    <div class="cli-card">
        <div class="cli-rolagem">
            <table class="cli-tabela">
                <thead>
                    <tr>
                        <th>Cliente</th>
                        <th>Telefone</th>
                        <th>CPF</th>
                    </tr>
                </thead>
                <tbody id="cli-corpo"></tbody>
            </table>
        </div>
    </div>

    <!-- JANELA PARA CADASTRAR / EDITAR CLIENTE -->
    <div class="cli-modal" id="cli-modal">
        <div class="cli-modal-caixa">
            <h2 id="cli-modal-titulo">Novo Cliente</h2>

            <form id="cli-form" novalidate>
                <label for="cli-nome">Nome completo</label>
                <input type="text" id="cli-nome" autocomplete="off">

                <label for="cli-telefone">Telefone</label>
                <input type="text" id="cli-telefone" placeholder="(00) 00000-0000" inputmode="numeric" autocomplete="off">

                <label for="cli-cpf">CPF</label>
                <input type="text" id="cli-cpf" placeholder="000.000.000-00" inputmode="numeric" autocomplete="off">

                <p class="cli-erro" id="cli-erro"></p>

                <div class="cli-modal-botoes">
                    <button type="button" class="cli-btn-excluir" id="cli-btn-excluir">Excluir</button>
                    <button type="button" class="cli-btn-cancelar" id="cli-btn-cancelar">Cancelar</button>
                    <button type="submit" class="cli-btn-salvar">Salvar</button>
                </div>
            </form>
        </div>
    </div>

</div>

<script src="js/clientes.js"></script>

<?php require 'includes/footer_app.php'; ?>