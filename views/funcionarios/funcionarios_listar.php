<?php
require __DIR__ . '/../../includes/autenticar.php';
require __DIR__ . '/../../includes/header_app.php';
?>

<link rel="stylesheet" href="../../css/pagina.css">
<link rel="stylesheet" href="../../css/funcionarios/funcionarios_listar.css?v=4">

<div class="topo-pagina topo-destaque">
    <div class="titulo-bloco">
        <span class="titulo-icone">
            <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="8" r="5"></circle>
                <path d="M20 21a8 8 0 0 0-16 0"></path>
            </svg>
        </span>

        <div>
            <nav class="migalhas">
                <a href="../../home.php">Início</a>
                <span>/</span>
                <span>Funcionários</span>
            </nav>

            <h1>Funcionários</h1>

            <p class="subtitulo-pagina" id="contador-funcionarios">
                0 funcionários cadastrados
            </p>
        </div>
    </div>

    <a href="funcionarios_cadastro.php" class="botao-novo">
    + Novo Funcionário
    </a>
</div>

<div class="cartao-lista">

    <div class="barra-busca barra-cadastros">
        <div class="campo-busca-cadastro">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.3-4.3"></path>
        </svg>

        <input
            type="text"
            id="busca-funcionario"
            class="input-busca"
            placeholder="Buscar por nome, CPF ou telefone..."
            autocomplete="off"
        >
        </div>
        <select id="filtro-situacao" class="filtro-cadastro" aria-label="Filtrar situação"><option value="ativos">Ativos</option><option value="inativos">Inativos</option><option value="todos">Todos</option></select>
    </div>

    <div class="tabela-rolagem">
        <table class="tabela-produtos tabela-funcionarios">
            <thead>
                <tr>
                    <th>FUNCIONÁRIO</th>
                    <th>TELEFONE</th>
                    <th>CPF</th>
                    <th class="coluna-acoes">AÇÕES</th>
                </tr>
            </thead>

            <tbody id="corpo-tabela-funcionarios">
                <tr>
                    <td colspan="4">Carregando funcionários...</td>
                </tr>
            </tbody>
        </table>
    </div>

</div>

<script src="../../js/funcionarios/funcionarios_listar.js?v=4"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>