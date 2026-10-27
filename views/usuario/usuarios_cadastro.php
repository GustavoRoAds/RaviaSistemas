<?php
require __DIR__ . '/../../includes/autenticar.php';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="../../css/funcionarios/funcionarios_cadastro.css?v=1">
<link rel="stylesheet" href="../../css/usuario/usuarios_cadastro.css?v=1">
<div class="topo-pagina topo-cadastro">
    <div class="titulo-bloco"><span class="titulo-icone"><svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="5"/><path d="M20 21a8 8 0 0 0-16 0"/><path d="M19 4v6m-3-3h6"/></svg></span>
        <div><nav class="migalhas"><a href="usuarios_listar.php">Usuários</a><span>/</span><span>Novo usuário</span></nav><h1>Novo Usuário</h1><p class="subtitulo-pagina">Preencha os dados para cadastrar</p></div>
    </div><a href="usuarios_listar.php" class="botao-voltar">← Voltar</a>
</div>
<form id="form-usuario" class="cartao-formulario" novalidate>
    <section class="secao"><h2 class="secao-titulo">Dados do usuário</h2><div class="grade">
        <div class="campo col-6"><label for="nome">Nome completo <span class="obrigatorio">*</span></label><input type="text" id="nome" maxlength="100" autocomplete="name" placeholder="Nome completo" required></div>
        <div class="campo col-6"><label for="email">E-mail <span class="obrigatorio">*</span></label><input type="email" id="email" maxlength="254" autocomplete="email" placeholder="nome@exemplo.com" required></div>
    </div></section>
    <section class="secao"><h2 class="secao-titulo">Dados de acesso</h2><div class="grade">
        <div class="campo col-6"><label for="senha">Senha <span class="obrigatorio">*</span></label><input type="password" id="senha" minlength="6" autocomplete="new-password" placeholder="Mínimo de 6 caracteres" required></div>
        <div class="campo col-6"><label for="confirmar-senha">Confirmar senha <span class="obrigatorio">*</span></label><input type="password" id="confirmar-senha" minlength="6" autocomplete="new-password" placeholder="Repita a senha" required></div>
    </div><p class="usuario-ajuda">O cadastro cria uma conta de acesso no Firebase Authentication.</p></section>
    <div id="mensagem-usuario" role="alert" aria-live="polite"></div>
    <div class="acoes-formulario"><button type="submit" class="botao-novo botao-salvar" id="salvar">Salvar usuário</button><a href="usuarios_listar.php" class="botao-cancelar">Cancelar</a><button type="reset" class="botao-limpar">Limpar</button></div>
</form>
<script src="../../js/usuario/usuarios_cadastro.js?v=1"></script>
<?php require __DIR__ . '/../../includes/footer_app.php'; ?>
