<?php
session_start();

if (!isset($_SESSION['usuario_id'])) {
    header('Location: ../../index.php');
    exit;
}

$paginaAtual = 'produto';

require __DIR__ . '/../../includes/header_app.php';
?>

<link rel="stylesheet" href="<?php echo rtrim(BASE_URL, '/'); ?>/css/pagina.css">
<link rel="stylesheet" href="<?php echo rtrim(BASE_URL, '/'); ?>/css/produto/produto_listar.css?v=2">

<div class="prod-pagina"
     data-api-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/produto/produtos.php', ENT_QUOTES, 'UTF-8'); ?>"
     data-categorias-url="<?php echo htmlspecialchars(rtrim(BASE_URL, '/') . '/api/categorias/categorias.php', ENT_QUOTES, 'UTF-8'); ?>">

    <div class="topo-pagina topo-destaque prod-topo">
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
                    <a href="<?php echo rtrim(BASE_URL, '/'); ?>/home.php">Início</a>
                    <span>/</span>
                    <span>Produtos</span>
                </nav>

                <h1>Produtos</h1>

                <p class="subtitulo-pagina" id="prod-quantidade">
                    0 produtos cadastrados
                </p>
            </div>
        </div>

        <a href="<?php echo rtrim(BASE_URL, '/'); ?>/views/produtos/produto_cadastro.php"
           class="botao-novo">
            + Novo Produto
        </a>
    </div>

    <div class="cartao-lista prod-lista-card">
        <div class="barra-busca prod-busca">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle>
                <path d="m21 21-4.3-4.3"></path>
            </svg>

            <input type="text"
                   id="prod-busca"
                   class="input-busca"
                   placeholder="Buscar por nome ou categoria..."
                   autocomplete="off">
        </div>

        <div class="tabela-rolagem prod-rolagem">
            <table class="tabela-produtos prod-tabela">
                <thead>
                    <tr>
                        <th>PRODUTO</th>
                        <th>CATEGORIA</th>
                        <th>CUSTO</th>
                        <th>VENDA</th>
                        <th>ESTOQUE</th>
                        <th class="coluna-acoes">AÇÕES</th>
                    </tr>
                </thead>

                <tbody id="prod-corpo">
                    <tr>
                        <td colspan="6" class="prod-vazio">Carregando produtos...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="<?php echo rtrim(BASE_URL, '/'); ?>/js/produto/produto_listar.js?v=3"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>