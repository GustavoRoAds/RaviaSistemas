const campoBusca = document.getElementById('busca-funcionario');
const corpoTabela = document.getElementById('corpo-tabela-funcionarios');
const contador = document.getElementById('contador-funcionarios');

const API = '../../api/funcionario/funcionario.php';

function escaparHTML(valor) {
    return String(valor ?? '').replace(/[&<>"']/g, caractere => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    })[caractere]);
}

function somenteNumeros(valor) {
    return String(valor ?? '').replace(/\D/g, '');
}

function mascaraCpf(valor) {
    return somenteNumeros(valor)
        .slice(0, 11)
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
}

function mascaraTelefone(valor) {
    const n = somenteNumeros(valor).slice(0, 11);

    if (n.length <= 10) {
        return n.replace(/(\d{2})(\d)/, '($1) $2')
                .replace(/(\d{4})(\d)/, '$1-$2');
    }

    return n.replace(/(\d{2})(\d)/, '($1) $2')
            .replace(/(\d{5})(\d)/, '$1-$2');
}

function carregarFuncionarios(busca = '') {
    let url = API;

    if (busca.trim() !== '') {
        url += '?busca=' + encodeURIComponent(busca.trim());
    }

    fetch(url)
        .then(async resposta => {
            const dados = await resposta.json();

            if (!resposta.ok) {
                throw new Error(dados.erro || 'Não foi possível carregar os funcionários.');
            }

            return dados;
        })
        .then(funcionarios => {
            if (!Array.isArray(funcionarios)) {
                throw new Error('A API não retornou uma lista de funcionários.');
            }

            corpoTabela.innerHTML = '';

            contador.textContent =
                `${funcionarios.length} ${funcionarios.length === 1
                    ? 'funcionário cadastrado'
                    : 'funcionários cadastrados'}`;

            if (funcionarios.length === 0) {
                corpoTabela.innerHTML = `
                    <tr>
                        <td colspan="4">Nenhum funcionário encontrado.</td>
                    </tr>
                `;
                return;
            }

            funcionarios.forEach(funcionario => {
                const id = funcionario.id;
                const nome = funcionario.nome ?? '';
                const telefone = mascaraTelefone(funcionario.telefone ?? '');
                const cpf = mascaraCpf(funcionario.cpf ?? '');
                const inicial = nome.trim().charAt(0).toUpperCase() || '?';

                const linha = document.createElement('tr');

                linha.innerHTML = `
                    <td>
                        <span class="avatar-funcionario">${escaparHTML(inicial)}</span>
                        ${escaparHTML(id)} - ${escaparHTML(nome)}
                    </td>

                    <td>${escaparHTML(telefone)}</td>

                    <td>${escaparHTML(cpf)}</td>

                    <td>
                        <a href="funcionarios_cadastro.php?id=${encodeURIComponent(id)}"
                           class="botao-editar"
                           title="Editar funcionário"
                           aria-label="Editar funcionário">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z"></path>
                            </svg>
                        </a>
                    </td>
                `;

                corpoTabela.appendChild(linha);
            });
        })
        .catch(erro => {
            console.error('Erro ao carregar funcionários:', erro);
            contador.textContent = 'Erro ao carregar funcionários';

            corpoTabela.innerHTML = `
                <tr>
                    <td colspan="4">Não foi possível carregar os funcionários. Verifique a API.</td>
                </tr>
            `;
        });
}

campoBusca.addEventListener('input', function () {
    carregarFuncionarios(campoBusca.value);
});

carregarFuncionarios();