<?php
session_start();
if (!defined('BASE_URL')) define('BASE_URL', '/RaviaSistemas');
if (empty($_SESSION['usuario_id'])) { header('Location: ' . BASE_URL . '/index.php'); exit; }
$paginaAtual = 'relatorio_vendas';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/relatorios/vendas.css">
<div class="topo-pagina topo-destaque">
 <header class="venda-topo"><div class="venda-topo-titulo"><div class="venda-topo-icone">▤</div><div>
 <nav class="venda-migalhas"><a href="<?php echo BASE_URL; ?>/home.php">Início</a><span>›</span><span>Relatório de vendas</span></nav>
 <h1>Relatório de Vendas</h1><p class="venda-subtitulo">Selecione os filtros para visualizar ou imprimir o PDF.</p>
 </div></div></header>
</div>
<main class="relatorio-area"><section class="relatorio-card">
 <h2>Parâmetros do relatório</h2>
 <form method="get" action="<?php echo BASE_URL; ?>/api/relatorios/vendas_pdf.php" target="_blank">
  <div class="relatorio-campos">
   <label>Data inicial<input type="date" name="inicio" value="<?php echo date('Y-m-01'); ?>" required></label>
   <label>Data final<input type="date" name="fim" value="<?php echo date('Y-m-d'); ?>" required></label>
   <label>Situação<select name="situacao"><option value="TODAS">Todas</option><option value="ATIVA">Ativas</option><option value="CANCELADA">Canceladas</option></select></label>
  </div>
  <button type="submit" class="relatorio-gerar">Gerar PDF</button>
 </form>
 </section></main>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
