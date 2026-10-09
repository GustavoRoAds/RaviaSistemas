<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}
require 'includes/header_app.php';
?>

<div class="topo-pagina">
    <div>
        <h1>Clientes</h1>
        <p class="subtitulo-pagina" id="contador-clientes">0 clientes cadastrados</p>
    </div>
    <a href="cliente_cadastro.php" class="botao-novo">+ Novo Cliente</a>
</div>

<input type="text" id="busca-cliente" class="input-busca" placeholder="Buscar por nome, CPF ou telefone...">

<table class="tabela-produtos">
    <thead>
        <tr>
            <th>CLIENTE</th>
            <th>TELEFONE</th>
            <th>CPF</th>
        </tr>
    </thead>
    <tbody id="corpo-tabela-clientes">
    </tbody>
</table>

<script src="js/cliente_listar.js"></script>

<?php require 'includes/footer_app.php'; ?>