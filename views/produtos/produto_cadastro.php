<?php
session_start();

if (!isset($_SESSION['usuario_id'])) {
    header('Location: ../../index.php');
    exit;
}

$paginaAtual = 'produto';

require __DIR__ . '/../../includes/header_app.php';
?>

<link rel="stylesheet" href="<?php echo rtrim(BASE_URL, '/'); ?>/css/produto/produto_cadastro.css?v=1">

<div class="prod-pagina"
     data-api-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/produto/produtos.php', ENT_QUOTES, 'UTF-8'); ?>"
     data-categorias-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/categorias/categorias.php', ENT_QUOTES, 'UTF-8'); ?>">

    <div class="topo-pagina topo-cadastro prod-topo">
        <div class="titulo-bloco">
            <span class="titulo-icone">
                <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="m12 3 9 5-9 5-9-5 9-5Z"></path>
                    <path d="M3 8v8l9 5 9-5V8"></path>
                    <path d="M12 13v8"></path>
                </svg>
            </span>

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
        <select id="prod-categoria">
            <option value="">Sem categoria</option>
        </select>
    </div>
</div>


    </section>

    <section class="secao">
        <h2 class="secao-titulo">Valores e estoque</h2>

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

            <div class="campo col-2">
                <label for="prod-estoque">Quantidade em estoque <span class="obrigatorio">*</span></label>
                <input type="number" id="prod-estoque" min="0" step="1"
                       value="0" required>
            </div>
        </div>
    </section>

    <p class="prod-erro" id="prod-erro" role="alert" aria-live="polite"></p>

    <div class="acoes-formulario">
        <button type="submit" class="botao-novo botao-salvar" id="prod-btn-salvar">
            Salvar produto
        </button>

        <a href="<?php echo rtrim(BASE_URL, '/'); ?>/views/produtos/produto_listar.php"
           class="botao-cancelar" id="prod-btn-cancelar">
            Cancelar
        </a>

        <button type="button" class="botao-limpar" id="prod-limpar">
            Limpar
        </button>
    </div>

</form>



</div>

<script src="<?php echo rtrim(BASE_URL, '/'); ?>/js/produto/produto_cadastro.js?v=1"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>