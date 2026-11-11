const configAPI = '/RaviaSistemas/api/configuracoes/configuracoes.php';
const buscaConfig = document.getElementById('config-busca');
const resultadosConfig = document.getElementById('config-resultados');
const selecionadoConfig = document.getElementById('config-selecionado');
const mensagemConfig = document.getElementById('config-mensagem');
let codigoConfig = null;
let timerConfig;
function escolherConfig(cliente) {
    codigoConfig = Number(cliente.codigo);
    document.getElementById('config-nome').textContent = cliente.nome + (cliente.cpf ? ' — ' + cliente.cpf : '');
    selecionadoConfig.hidden = false;
    buscaConfig.value = '';
    buscaConfig.hidden = true;
    resultadosConfig.hidden = true;
}
function removerConfig() {
    codigoConfig = null;
    selecionadoConfig.hidden = true;
    buscaConfig.hidden = false;
    buscaConfig.value = '';
}
document.getElementById('config-remover').addEventListener('click', removerConfig);
async function pesquisarConfig() {
    try {
        const resposta = await fetch('/RaviaSistemas/api/cliente/cliente.php?busca=' + encodeURIComponent(buscaConfig.value.trim()));
        if (!resposta.ok) throw new Error('Erro na pesquisa');
        const clientes = await resposta.json();
        resultadosConfig.replaceChildren();
        clientes.forEach(cliente => {
            const botao = document.createElement('button');
            botao.type = 'button';
            botao.textContent = cliente.nome + (cliente.cpf ? ' — ' + cliente.cpf : '');
            botao.addEventListener('click', () => escolherConfig(cliente));
            resultadosConfig.appendChild(botao);
        });
        resultadosConfig.hidden = clientes.length === 0;
    } catch (erro) { mensagemConfig.textContent = 'Erro ao pesquisar clientes.'; }
}
buscaConfig.addEventListener('input', () => { clearTimeout(timerConfig); timerConfig = setTimeout(pesquisarConfig, 200); });
buscaConfig.addEventListener('focus', pesquisarConfig);
document.addEventListener('click', evento => {
    if (!evento.target.closest('.config-busca-container')) resultadosConfig.hidden = true;
});
document.getElementById('config-salvar').addEventListener('click', async () => {
    mensagemConfig.textContent = '';
    try {
        const resposta = await fetch(configAPI, {
            method: 'PUT', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ cliente_padrao_codigo: codigoConfig })
        });
        const dados = await resposta.json();
        if (!resposta.ok) throw new Error(dados.erro || 'Erro ao salvar');
        mensagemConfig.textContent = 'Configurações salvas com sucesso.';
    } catch (erro) { mensagemConfig.textContent = erro.message; }
});
(async () => {
    try {
        const resposta = await fetch(configAPI);
        const dados = await resposta.json();
        if (!resposta.ok) throw new Error(dados.erro || 'Erro ao carregar');
        if (dados.cliente_padrao_codigo && dados.nome) escolherConfig({ codigo: dados.cliente_padrao_codigo, nome: dados.nome, cpf: dados.cpf });
    } catch (erro) { mensagemConfig.textContent = erro.message; }
})();
