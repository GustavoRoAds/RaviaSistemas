const API_USUARIO = '/RaviaSistemas/api/usuario/usuario.php';
const formularioUsuario = document.getElementById('form-usuario');
const botaoSalvar = document.getElementById('salvar');
const mensagemUsuario = document.getElementById('mensagem-usuario');
formularioUsuario.addEventListener('submit', async event => {
    event.preventDefault();
    mensagemUsuario.textContent = '';
    const nome = document.getElementById('nome').value.trim();
    const email = document.getElementById('email').value.trim();
    const senha = document.getElementById('senha').value;
    const confirmacao = document.getElementById('confirmar-senha').value;
    if (!nome || !email || !senha || !confirmacao) { mensagemUsuario.textContent = 'Preencha todos os campos obrigatórios.'; return; }
    if (!document.getElementById('email').checkValidity()) { mensagemUsuario.textContent = 'Informe um e-mail válido.'; return; }
    if (senha.length < 6) { mensagemUsuario.textContent = 'A senha deve ter pelo menos 6 caracteres.'; return; }
    if (senha !== confirmacao) { mensagemUsuario.textContent = 'As senhas não coincidem.'; return; }
    botaoSalvar.disabled = true;
    try {
        const resposta = await fetch(API_USUARIO, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'Accept':'application/json'},
            body: JSON.stringify({nome, email, senha})
        });
        const dados = await resposta.json();
        if (!resposta.ok) throw new Error(dados.erro || 'Não foi possível cadastrar o usuário.');
        if (typeof Notificacao !== 'undefined' && Notificacao.sucesso) Notificacao.sucesso('Usuário cadastrado com sucesso!');
        window.location.href = 'usuarios_listar.php';
    } catch (erro) {
        mensagemUsuario.textContent = erro.message;
        console.error('Erro ao cadastrar usuário:', erro);
    } finally {
        botaoSalvar.disabled = false;
    }
});
