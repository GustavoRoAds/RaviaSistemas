<?php
session_start();

if (!isset($_SESSION['usuario_id'])) {
    header('Location: ../../index.php');
    exit;
}

$paginaAtual = 'produto';

require __DIR__ . '/../../includes/header_app.php';
?>

<link rel="stylesheet" href="<?php echo rtrim(BASE_URL, '/'); ?>/css/produto/produto_cadastro.css?v=20261128cat4">

<div class="prod-pagina"
     data-api-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/produto/produtos.php', ENT_QUOTES, 'UTF-8'); ?>"
     data-categorias-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/categorias/categorias.php', ENT_QUOTES, 'UTF-8'); ?>">

    <div class="topo-pagina topo-cadastro prod-topo">
        <div class="titulo-bloco">
            

            <div>
                <nav class="migalhas">
                    <a href="<?php echo rtrim(BASE_URL, '/'); ?>/views/produtos/produto_listar.php">Produtos</a>
                    <span>/</span>
                    <span>Novo produto</span>
                </nav>

                <h1>Novo Produto</h1>

                <p class="subtitulo-pagina">Preencha os dados para cadastrar</p>
            </div>
        </div>

        <a href="<?php echo rtrim(BASE_URL, '/'); ?>/views/produtos/produto_listar.php"
           class="botao-voltar">
            ← Voltar
        </a>
    </div>

    <form id="prod-form" class="cartao-formulario" novalidate>

    <section class="secao">
        <h2 class="secao-titulo">Dados do produto</h2>

        <div class="grade">
    <div class="campo col-2">
        <label for="prod-id">Código</label>
        <input type="text" id="prod-id" maxlength="25"
               inputmode="numeric" placeholder="ID do produto"
               autocomplete="off">
    </div>

    <div class="campo col-4">
        <label for="prod-nome">Nome do produto <span class="obrigatorio">*</span></label>
        <input type="text" id="prod-nome" maxlength="150"
               placeholder="Nome do produto" autocomplete="off" required>
    </div>

    <div class="campo col-6">
        <label for="prod-descricao">Descrição</label>
        <input type="text" id="prod-descricao" maxlength="255"
               placeholder="Descrição do produto" autocomplete="off">
    </div>

    <div class="campo col-6">
        <label for="prod-categoria">Categoria</label>
        <div class="categoria-linha"><select id="prod-categoria">
            <option value="">Sem categoria</option>
        </select><button type="button" id="categoria-abrir" class="categoria-adicionar" aria-label="Cadastrar categoria" title="Cadastrar categoria">+</button></div>
    </div>
</div>


    </section>

    <section class="secao">
        <h2 class="secao-titulo">Valores</h2>

        <div class="grade">
            <div class="campo col-2">
                <label for="prod-custo">Custo (R$)</label>
                <input type="text" id="prod-custo" placeholder="0,00"
                       inputmode="decimal" autocomplete="off">
            </div>

            <div class="campo col-2">
                <label for="prod-venda">Valor de venda (R$) <span class="obrigatorio">*</span></label>
                <input type="text" id="prod-venda" placeholder="0,00"
                       inputmode="decimal" autocomplete="off" required>
            </div>
        </div>
    </section>


    <div class="acoes-formulario">
        <button type="submit" class="botao-novo botao-salvar" id="prod-btn-salvar">
            Salvar produto
        </button>

        <a href="<?php echo rtrim(BASE_URL, '/'); ?>/views/produtos/produto_listar.php"
           class="botao-cancelar" id="prod-btn-cancelar">
            Cancelar
        </a>

        <div class="acoes-secundarias-produto">
            <button type="button" class="botao-limpar" id="prod-limpar">
                Limpar
            </button>

            <button type="button" class="botao-excluir-produto" id="prod-btn-excluir">
                Excluir
            </button>
        </div>
    </div>

</form>
<dialog id="categoria-modal" class="categoria-modal">
<form id="categoria-form">
<h2>Cadastro de categoria</h2>
<div class="campo"><label for="categoria-codigo">Código</label><div class="categoria-linha"><input id="categoria-codigo" type="number" min="1" max="2147483647" placeholder="Automático ou consulte pelo código"><button type="button" id="categoria-consultar" class="categoria-adicionar" title="Consultar categorias" aria-label="Consultar categorias"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 5 5"/></svg></button></div></div>
<div class="campo"><label for="categoria-descricao">Descrição</label><input id="categoria-descricao" maxlength="100" required></div>
<div class="acoes-formulario"><button type="submit" class="botao-novo botao-salvar" id="categoria-salvar">Salvar categoria</button><button type="button" class="botao-cancelar" id="categoria-cancelar">Cancelar</button><button type="button" class="botao-limpar" id="categoria-limpar">Limpar</button><button type="button" class="botao-excluir-produto" id="categoria-excluir" disabled>Excluir</button></div>
</form></dialog>
<dialog id="categoria-lista-modal" class="categoria-modal categoria-lista-modal">
<div class="categoria-lista-topo"><h2>Consultar categorias</h2><button type="button" class="botao-cancelar" id="categoria-lista-fechar">Voltar</button></div>
<div class="campo"><label for="categoria-pesquisa">Pesquisar por código ou nome</label><input id="categoria-pesquisa" type="search" placeholder="Pesquisar categoria..."></div>
<div class="categoria-tabela-wrap"><table class="categoria-tabela"><thead><tr><th>Código</th><th>Nome</th><th>Ação</th></tr></thead><tbody id="categoria-lista-corpo"></tbody></table></div>
</dialog>



</div>

<script src="<?php echo rtrim(BASE_URL, '/'); ?>/js/produto/produto_cadastro.js?v=20261128cat4"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>