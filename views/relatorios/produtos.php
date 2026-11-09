<?php
session_start();
if (!defined('BASE_URL')) define('BASE_URL', '/RaviaSistemas');
if (empty($_SESSION['usuario_id'])) { header('Location: '.BASE_URL.'/index.php'); exit; }
$paginaAtual = 'relatorios';
require __DIR__.'/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?= BASE_URL ?>/css/relatorios/vendas.css">
<div class="topo-pagina topo-destaque"><header class="venda-topo"><div class="venda-topo-titulo"><div><nav class="venda-migalhas"><a href="<?= BASE_URL ?>/home.php">Início</a><span>›</span><span>Relatórios</span><span>›</span><span>Produtos e estoque</span></nav><h1>Produtos e estoque</h1><p class="venda-subtitulo">Filtre produtos e consulte o saldo calculado.</p></div></div></header></div>
<main class="relatorio-area"><section class="relatorio-card">
<h2>Produtos e estoque</h2><p>Saldo atualizado pela função fn_estoque.</p><form method="get" action="<?= BASE_URL ?>/api/relatorios/produtos_pdf.php" target="_blank"><div class="relatorio-campos"><label>Categoria<input name="categoria" type="text" maxlength="100" placeholder="Todas as categorias"></label><label>Situação<select name="situacao"><option value="TODOS">Todos</option><option value="ATIVOS" selected>Ativos</option><option value="INATIVOS">Inativos</option></select></label></div><button type="submit" class="relatorio-gerar">Gerar PDF de produtos</button></form></section></main><?php require __DIR__.'/../../includes/footer_app.php'; ?>