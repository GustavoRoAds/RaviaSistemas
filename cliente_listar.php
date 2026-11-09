<?php
require 'includes/autenticar.php';
require 'includes/header_app.php';
?>

<link rel="stylesheet" href="css/pagina.css">
<link rel="stylesheet" href="css/cliente/cliente_listar.css?v=4">

<div class="topo-pagina topo-destaque">
    <div class="titulo-bloco">
      

        <div>
            <nav class="migalhas">
                <a href="home.php">Início</a>
                <span>/</span>
                <span>Clientes</span>
            </nav>
            <h1>Clientes</h1>
            <p class="subtitulo-pagina" id="contador-clientes">0 clientes cadastrados</p>
        </div>
    </div>

    <a href="cliente_cadastro.php" class="botao-novo">+ Novo Cliente</a>
</div>

<div class="cartao-lista">

    <div class="barra-busca barra-cadastros">
        <div class="campo-busca-cadastro">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.3-4.3"></path>
        </svg>
        <input type="text" id="busca-cliente" class="input-busca" placeholder="Buscar por nome, CPF ou telefone...">
        </div>
        <select id="filtro-situacao" class="filtro-cadastro" aria-label="Filtrar situação"><option value="ativos">Ativos</option><option value="inativos">Inativos</option><option value="todos">Todos</option></select>
        <label class="limite-registros-controle" for="limite-registros">Exibir <select id="limite-registros" aria-label="Quantidade de registros por página"><option value="10">10</option><option value="25">25</option><option value="50" selected>50</option><option value="100">100</option><option value="200">200</option><option value="0">Todos</option></select> registros</label>
    </div>

    <div class="tabela-rolagem">
        <table class="tabela-produtos tabela-clientes">
            <thead>
                <tr>
                    
                    <th>CLIENTE</th>
                    <th>TELEFONE</th>
                    <th>CPF</th>
                    <th class="coluna-acoes">AÇÕES</th>
                </tr>
            </thead>
            <tbody id="corpo-tabela-clientes">
            </tbody>
        </table>
    </div>

</div>

<script src="js/cliente/cliente_listar.js?v=20261108"></script>

<?php require 'includes/footer_app.php'; ?>