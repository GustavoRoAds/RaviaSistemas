<?php
require __DIR__ . '/../../includes/autenticar.php';
require __DIR__ . '/../../includes/header_app.php';

$funcionario_id = $_GET['id'] ?? null;
?>

<link rel="stylesheet" href="../../css/funcionarios/funcionarios_cadastro.css?v=1">

<div class="topo-pagina topo-cadastro">
    <div class="titulo-bloco">
        <span class="titulo-icone">
            <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="8" r="5"></circle>
                <path d="M20 21a8 8 0 0 0-16 0"></path>
            </svg>
        </span>

        <div>
            <nav class="migalhas">
                <a href="funcionarios_listar.php">Funcionários</a>
                <span>/</span>
                <span id="titulo-migalha">Novo funcionário</span>
            </nav>

            <h1 id="titulo-cadastro">Novo Funcionário</h1>

            <p class="subtitulo-pagina">Preencha os dados para cadastrar</p>
        </div>
    </div>

    <a href="funcionarios_listar.php" class="botao-voltar">← Voltar</a>
</div>

<form id="form-funcionario" class="cartao-formulario" novalidate>

    <section class="secao">
        <h2 class="secao-titulo">Dados pessoais</h2>

        <div class="grade">
            <div class="campo col-2">
                <label for="codigo">Código</label>
                <input type="text" id="codigo" maxlength="25" inputmode="numeric">
            </div>

            <div class="campo col-6">
                <label for="nome">Nome <span class="obrigatorio">*</span></label>
                <input type="text" id="nome" maxlength="100" placeholder="Nome completo">
            </div>

            <div class="campo col-3">
                <label for="cpf">CPF <span class="obrigatorio">*</span></label>
                <input type="text" id="cpf" maxlength="14" inputmode="numeric" placeholder="000.000.000-00">
            </div>

            <div class="campo col-3">
                <label for="telefone">Telefone</label>
                <input type="text" id="telefone" maxlength="15" inputmode="tel" placeholder="(00) 00000-0000">
            </div>
        </div>
    </section>

    <section class="secao">
        <h2 class="secao-titulo">Contato</h2>

        <div class="grade">
            <div class="campo col-6">
                <label for="email">E-mail</label>
                <input type="email" id="email" maxlength="100" placeholder="nome@exemplo.com">
            </div>
        </div>
    </section>

    <section class="secao">
        <h2 class="secao-titulo">Endereço</h2>

        <div class="grade">
            <div class="campo campo-cep col-2">
                <label for="cep">CEP</label>
                <input type="text" id="cep" maxlength="9" inputmode="numeric" placeholder="00000-000">
            </div>

            <div class="campo col-4">
                <label for="endereco">Endereço</label>
                <input type="text" id="endereco" maxlength="100" placeholder="Rua, avenida...">
            </div>

            <div class="campo campo-numero col-2">
                <label for="numero">Número</label>
                <input type="text" id="numero" maxlength="10">
            </div>

            <div class="campo col-2">
                <label for="bairro">Bairro</label>
                <input type="text" id="bairro" maxlength="60">
            </div>

            <div class="campo col-2">
                <label for="cidade">Cidade</label>
                <input type="text" id="cidade" maxlength="60">
            </div>
        </div>
    </section>

    <div id="mensagem" role="alert" aria-live="polite"></div>

    <div class="acoes-formulario">
        <button type="submit" class="botao-novo botao-salvar" id="salvar">
            Salvar funcionário
        </button>

        <a href="funcionarios_listar.php" class="botao-cancelar">
            Cancelar
        </a>

        <button type="button" class="botao-limpar" id="limpar">
            Limpar
        </button>

        <button type="button" class="botao-excluir" id="excluir" hidden>
            Excluir
        </button>
    </div>

</form>

<script src="../../js/confirmacao.js?v=2"></script>
<script src="../../js/funcionarios/funcionarios_cadastro.js?v=3"></script>

<?php require __DIR__ . '/../../includes/footer_app.php'; ?>