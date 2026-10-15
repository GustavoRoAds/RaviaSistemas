<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}
require 'includes/header_app.php';
?>

<link rel="stylesheet" href="css/pagina.css">
<link rel="stylesheet" href="css/cliente/cliente_listar.css">

<div class="topo-pagina topo-destaque">
    <div class="titulo-bloco">
        <span class="titulo-icone">
            <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
        </span>

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

    <div class="barra-busca">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.3-4.3"></path>
        </svg>
        <input type="text" id="busca-cliente" class="input-busca" placeholder="Buscar por nome, CPF ou telefone...">
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

<script src="js/cliente/cliente_listar.js"></script>

<?php require 'includes/footer_app.php'; ?>