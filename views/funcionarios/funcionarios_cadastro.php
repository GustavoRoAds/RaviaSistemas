<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}

require __DIR__ . '/../../includes/header_app.php';

$cliente_id = $_GET['id'] ?? null;

?>

<link rel="stylesheet" href="css/funcionarios/funcionarios_cadastro.css">

<div class="topo-pagina topo-cadastro">
    <div class="titulo-bloco">
        <span class="titulo-icone">
            <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <line x1="19" x2="19" y1="8" y2="14"></line>
                <line x1="22" x2="16" y1="11" y2="11"></line>
            </svg>
        </span>

        <div>
            <nav class="migalhas">
                <a href="cliente_listar.php">Funcionarios</a>
                <span>/</span>
                <span>Novo Funcionario</span>
            </nav>
            <h1>Novo Funcionario</h1>
            <p class="subtitulo-pagina">Preencha os dados para cadastrar</p>
        </div>
    </div>

    <a href="cliente_listar.php" class="botao-voltar">← Voltar</a>
</div>

<form id="form-cliente" class="cartao-formulario" novalidate>

    <section class="secao">
        <h2 class="secao-titulo">Dados pessoais</h2>

        <div class="grade">
            <div class="campo col-2">
                <label for="codigo">Código</label>
                <input type="text" id="codigo" maxlength="25">
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
        <button type="submit" class="botao-novo botao-salvar">Salvar funcionario</button>
        <a href="cliente_listar.php" class="botao-cancelar">Cancelar</a>
        <button type="button" class="botao-limpar" id="limpar">Limpar</button>
    </div>

</form>


<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
