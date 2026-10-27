const API_USUARIOS = '/RaviaSistemas/api/usuario/usuario.php';
const buscaUsuario = document.getElementById('busca-usuario');
const tabelaUsuarios = document.getElementById('corpo-tabela-usuarios');
const contadorUsuarios = document.getElementById('contador-usuarios');
let usuarios = [];
function celula(texto, classe = '') {
    const td = document.createElement('td');
    td.textContent = texto ?? '';
    if (classe) td.className = classe;
    return td;
}
function avisoUsuarios(texto) {
    tabelaUsuarios.replaceChildren();
    const tr = document.createElement('tr');
    const td = celula(texto, 'usuario-mensagem');
    td.colSpan = 4;
    tr.append(td);
    tabelaUsuarios.append(tr);
}
function desenharUsuarios() {
    const q = buscaUsuario.value.trim().toLocaleLowerCase('pt-BR');
    const filtrados = usuarios.filter(u =>
        String(u.displayName ?? u.nome ?? '').toLocaleLowerCase('pt-BR').includes(q) ||
        String(u.email ?? '').toLocaleLowerCase('pt-BR').includes(q)
    );

    contadorUsuarios.textContent = `${usuarios.length} usuário(s) cadastrado(s)`;
    tabelaUsuarios.replaceChildren();
    if (!filtrados.length) { avisoUsuarios('Nenhum usuário encontrado.'); return; }
    for (const u of filtrados) {
        const tr = document.createElement('tr');
        tr.append(celula(u.displayName ?? u.nome ?? 'Sem nome', 'usuario-nome'));
        tr.append(celula(u.email ?? '—'));
        tr.append(celula(u.uid ?? '—', 'usuario-uid'));
        const td = document.createElement('td');
        const status = document.createElement('span');
        const inativo = u.disabled === true || u.ativo === false;
        status.className = 'usuario-status' + (inativo ? ' inativo' : '');
        status.textContent = inativo ? 'Desativado' : 'Ativo';
        td.append(status); tr.append(td); tabelaUsuarios.append(tr);
    }
}
async function carregarUsuarios() {
    try {
        const resposta = await fetch(API_USUARIOS, {headers: {'Accept':'application/json'}});
       
        const texto = await resposta.text();

        console.log('Status HTTP:', resposta.status);
        console.log('Resposta PHP:', texto);

        if (!resposta.ok) {
            throw new Error('Erro na API: ' + resposta.status);
        }

        const dados = JSON.parse(texto);

        if (!resposta.ok) throw new Error(dados.erro || `Erro HTTP ${resposta.status}`);
        if (!Array.isArray(dados)) throw new Error('A API deve retornar um array de usuários no GET.');
        usuarios = dados;
        desenharUsuarios();
    } catch (erro) {
        contadorUsuarios.textContent = 'Não foi possível carregar os usuários';
        avisoUsuarios(erro.message);
        console.error('Erro ao listar usuários:', erro);
    }
}
buscaUsuario.addEventListener('input', desenharUsuarios);
carregarUsuarios();
