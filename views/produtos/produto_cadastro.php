<?php
// require __DIR__ . '/../../includes/autenticar.php';

$paginaAtual = 'produto';

require __DIR__ . '/../../includes/header_app.php';

?>

<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/produto/produto_cadastro.css">

<div class="prod-pagina">

    <!-- TOPO: título + botão Novo Produto -->
    <div class="topo-pagina prod-topo">
        <div>
            <h1>Produtos</h1>
            <p class="subtitulo-pagina" id="prod-quantidade">0 produtos cadastrados</p>
        </div>
        <button type="button" class="prod-botao-novo" id="btn-novo-produto">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            Novo Produto
        </button>
    </div>

    <!-- BUSCA -->
    <div class="prod-busca">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input type="text" id="prod-busca" placeholder="Buscar por nome ou categoria..." autocomplete="off">
    </div>

    <!-- TABELA DE PRODUTOS -->
    <div class="prod-card">
        <div class="prod-rolagem">
            <table class="prod-tabela">
                <thead>
                    <tr>
                        <th>Produto</th>
                        <th>Categoria</th>
                        <th>Custo</th>
                        <th>Venda</th>
                        <th>Estoque</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="prod-corpo">
                    <tr><td colspan="6" class="prod-vazio">Carregando...</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- JANELA PARA CADASTRAR / EDITAR PRODUTO -->
    <div class="prod-modal" id="prod-modal">
        <div class="prod-modal-caixa">
            <h2 id="prod-modal-titulo">Novo Produto</h2>

            <form id="prod-form" novalidate>
                <label for="prod-nome">Nome do produto</label>
                <input type="text" id="prod-nome" autocomplete="off">

                <label for="prod-descricao">Descrição</label>
                <input type="text" id="prod-descricao" autocomplete="off">

                <label for="prod-categoria">Categoria</label>
                <select id="prod-categoria">
                    <option value="">Sem categoria</option>
                </select>

                <div class="prod-linha-dupla">
                    <div>
                        <label for="prod-custo">Custo (R$)</label>
                        <input type="text" id="prod-custo" placeholder="0,00" inputmode="numeric" autocomplete="off">
                    </div>
                    <div>
                        <label for="prod-venda">Valor de venda (R$)</label>
                        <input type="text" id="prod-venda" placeholder="0,00" inputmode="numeric" autocomplete="off">
                    </div>
                </div>

                <p class="prod-erro" id="prod-erro"></p>

                <div class="prod-modal-botoes">
                    <button type="button" class="prod-btn-cancelar" id="prod-btn-cancelar">Cancelar</button>
                    <button type="submit" class="prod-btn-salvar" id="prod-btn-salvar">Salvar</button>
                </div>
            </form>
        </div>
    </div>

</div>

<script src="<?php echo BASE_URL; ?>/js/produto/produto_cadastro.js"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>