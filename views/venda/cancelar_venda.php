<?php
session_start();
if (!defined('BASE_URL')) define('BASE_URL', '/RaviaSistemas');
if (empty($_SESSION['usuario_id'])) { header('Location: ' . BASE_URL . '/index.php'); exit; }
$paginaAtual = 'cancelar_venda';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/registrar_venda/registrar_venda.css">
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/cancelar_venda/cancelar_venda.css">
<div class="topo-pagina topo-destaque">
  <header class="venda-topo"><div class="venda-topo-titulo"><div class="venda-topo-icone">↩</div>
  <div><nav class="venda-migalhas"><a href="<?php echo BASE_URL; ?>/home.php">Início</a><span>›</span><span>Cancelar venda</span></nav>
  <h1>Cancelamento de Venda</h1><p class="venda-subtitulo">Consulte vendas, devolva o estoque e estorne o recebimento.</p></div></div></header>
</div>
<div class="cancelamento-pagina">
 <section class="venda-card"><div class="venda-card-corpo">
  <label for="busca-vendas">Pesquisar venda por número ou cliente</label>
  <input id="busca-vendas" type="search" placeholder="Pesquisar venda..." autocomplete="off">
  <div id="cancelamento-aviso" role="status"></div>
  <div class="cancelamento-tabela"><table><thead><tr><th>Venda</th><th>Data</th><th>Cliente</th><th>Valor</th><th>Situação</th><th>Ação</th></tr></thead><tbody id="lista-vendas"><tr><td colspan="6">Carregando...</td></tr></tbody></table></div>
 </div></section>
</div>
<div class="cancelamento-modal" id="modal-motivo-cancelamento" hidden>
  <div class="cancelamento-modal-caixa" role="dialog" aria-modal="true" aria-labelledby="titulo-motivo-cancelamento">
    <form id="form-motivo-cancelamento">
      <h2 id="titulo-motivo-cancelamento">Motivo do cancelamento</h2>
      <label for="motivo-cancelamento">Informe o motivo</label>
      <textarea id="motivo-cancelamento" rows="3" maxlength="255" required placeholder="Descreva o motivo do cancelamento"></textarea>
      <div class="cancelamento-modal-acoes">
        <button type="button" id="fechar-motivo" class="cancelamento-voltar">Voltar</button>
        <button type="submit" class="cancelamento-avancar">Continuar</button>
      </div>
    </form>
  </div>
</div>
<script src="<?php echo BASE_URL; ?>/js/cancelar_venda/cancelar_venda.js"></script>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
