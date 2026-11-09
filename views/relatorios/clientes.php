<?php
session_start();
if (!defined('BASE_URL')) define('BASE_URL', '/RaviaSistemas');
if (empty($_SESSION['usuario_id'])) {
    header('Location: ' . BASE_URL . '/index.php');
    exit;
}
$paginaAtual = 'relatorios';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?= BASE_URL ?>/css/relatorios/vendas.css">
<div class="topo-pagina topo-destaque">
    <header class="venda-topo">
        <div class="venda-topo-titulo">
            <div>
                <nav class="venda-migalhas">
                    <a href="<?= BASE_URL ?>/home.php">Início</a>
                    <span>›</span><span>Relatórios</span><span>›</span><span>Relatório de clientes</span>
                </nav>
                <h1>Relatório de clientes</h1>
                <p class="venda-subtitulo">Filtre clientes por nome e situação.</p>
            </div>
        </div>
    </header>
</div>
<main class="relatorio-area">
    <section class="relatorio-card">
        <h2>Relatório de clientes</h2>
        <p>Dados cadastrais e situação dos clientes.</p>
        <form method="get" action="<?= BASE_URL ?>/api/relatorios/clientes_pdf.php" target="_blank">
            <div class="relatorio-campos">
                <label>Cliente
                    <div class="relatorio-busca" data-tipo="cliente">
                        <input type="hidden" name="cliente" value="" class="relatorio-busca-id">
                        <div class="relatorio-busca-campo">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                <circle cx="11" cy="11" r="8"/>
                                <path d="m21 21-4.35-4.35"/>
                            </svg>
                            <input type="text" autocomplete="off" placeholder="Buscar cliente por nome ou CPF" class="relatorio-busca-texto">
                            <button type="button" class="relatorio-busca-limpar" title="Limpar seleção" aria-label="Limpar seleção">×</button>
                        </div>
                        <div class="relatorio-busca-lista"></div>
                    </div>
                </label>
                <label>Situação
                    <select name="situacao">
                        <option value="TODOS">Todos</option>
                        <option value="ATIVOS" selected>Ativos</option>
                        <option value="INATIVOS">Inativos</option>
                    </select>
                </label>
            </div>
            <button type="submit" class="relatorio-gerar">Gerar PDF de clientes</button>
        </form>
    </section>
</main>
<script src="<?= BASE_URL ?>/js/relatorios/pesquisa.js" defer></script>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
