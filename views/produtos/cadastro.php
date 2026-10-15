<?php 
$paginaAtual = 'produto';

require __DIR__ . '/../../includes/header_app.php'; ?>


<div class="topo-pagina">
    <div>
        <h1>Novo Produto</h1>
        <p class="subtitulo-pagina">Preencha os dados do produto</p>
    </div>
</div>

<div class="card-formulario">
    <form action="produto_salvar.php" method="post">
        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" required>

        <label for="descricao">descricao</label>
        <input type="text" id="descricao" name="descricao">

    </form>

</div>



<?php 
require __DIR__ . '/../../includes/footer_app.php'; ?>