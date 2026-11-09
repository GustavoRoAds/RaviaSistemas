<?php
session_start();
if (!defined('BASE_URL')) define('BASE_URL', '/RaviaSistemas');
if (empty($_SESSION['usuario_id'])) { header('Location: '.BASE_URL.'/index.php'); exit; }
$paginaAtual = 'relatorios';
require __DIR__.'/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?= BASE_URL ?>/css/relatorios/vendas.css">
<div class="topo-pagina topo-destaque"><header class="venda-topo"><div class="venda-topo-titulo"><div><nav class="venda-migalhas"><a href="<?= BASE_URL ?>/home.php">Início</a><span>›</span><span>Relatórios</span><span>›</span><span>Relatório de vendas</span></nav><h1>Relatório de vendas</h1><p class="venda-subtitulo">Configure os filtros do relatório completo de vendas.</p></div></div></header></div>
<main class="relatorio-area"><section class="relatorio-card">
<h2>Relatório completo de vendas</h2><p>Vendas, produtos, clientes, responsáveis, descontos e totais.</p>
<form method="get" action="<?= BASE_URL ?>/api/relatorios/vendas_pdf.php" target="_blank"><div class="relatorio-campos">
<label>Data inicial<input type="date" name="inicio" value="<?= date('Y-m-01') ?>" required></label>
<label>Data final<input type="date" name="fim" value="<?= date('Y-m-d') ?>" required></label>
<label>Situação<select name="situacao"><option value="TODAS">Todas</option><option value="ATIVA" selected>Faturadas / Ativas</option><option value="CANCELADA">Canceladas</option></select></label>
<label>Cliente<div class="relatorio-busca" data-tipo="cliente">
  <input type="hidden" name="cliente" value="" class="relatorio-busca-id">
  <div class="relatorio-busca-campo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" autocomplete="off" placeholder="Buscar cliente por nome ou CPF" class="relatorio-busca-texto"><button type="button" class="relatorio-busca-limpar" title="Limpar seleção" aria-label="Limpar seleção">×</button></div>
  <div class="relatorio-busca-lista"></div>
</div></label>
<label>Produto<div class="relatorio-busca" data-tipo="produto">
  <input type="hidden" name="produto" value="" class="relatorio-busca-id">
  <div class="relatorio-busca-campo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" autocomplete="off" placeholder="Buscar produto por nome" class="relatorio-busca-texto"><button type="button" class="relatorio-busca-limpar" title="Limpar seleção" aria-label="Limpar seleção">×</button></div>
  <div class="relatorio-busca-lista"></div>
</div></label>
<label>Funcionário<div class="relatorio-busca" data-tipo="funcionario">
  <input type="hidden" name="funcionario" value="" class="relatorio-busca-id">
  <div class="relatorio-busca-campo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" autocomplete="off" placeholder="Buscar funcionário por nome" class="relatorio-busca-texto"><button type="button" class="relatorio-busca-limpar" title="Limpar seleção" aria-label="Limpar seleção">×</button></div>
  <div class="relatorio-busca-lista"></div>
</div></label>
<label>Ordenar por<select name="ordem"><option value="codigo">Código da venda</option><option value="cliente">Nome do cliente</option></select></label>
</div><button type="submit" class="relatorio-gerar">Gerar PDF de vendas</button></form>
<script src="<?= BASE_URL ?>/js/relatorios/pesquisa.js" defer></script>
</section></main><?php require __DIR__.'/../../includes/footer_app.php'; ?>