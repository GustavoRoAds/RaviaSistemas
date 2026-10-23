const API = '../../api/funcionario/funcionario.php';

const form = document.getElementById('form-funcionario');
const mensagem = document.getElementById('mensagem');
const codigoInput = document.getElementById('codigo');
const botaoSalvar = document.getElementById('salvar');
const botaoExcluir = document.getElementById('excluir');

function mostrarMensagem(texto, sucesso = false) {
    mensagem.textContent = texto;
    mensagem.classList.toggle('sucesso', sucesso);
}

function notificar(tipo, texto, opcoes = {}) {
    mostrarMensagem(texto, tipo === 'sucesso');
}

function somenteNumeros(valor) {
    return String(valor ?? '').replace(/\D/g, '');
}

function escaparHTML(valor) {
    return String(valor ?? '').replace(/[&<>"']/g, caractere => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    })[caractere]);
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
        return n
            .replace(/(\d{2})(\d)/, '($1) $2')
            .replace(/(\d{4})(\d)/, '$1-$2');
    }

    return n
        .replace(/(\d{2})(\d)/, '($1) $2')
        .replace(/(\d{5})(\d)/, '$1-$2');
}

function mascaraCep(valor) {
    return somenteNumeros(valor)
        .slice(0, 8)
        .replace(/(\d{5})(\d)/, '$1-$2');
}

function cpfValido(cpf) {
    if (cpf.length !== 11) {
        return false;
    }

    if (/^(\d)\1{10}$/.test(cpf)) {
        return false;
    }

    let soma = 0;

    for (let i = 0; i < 9; i++) {
        soma += Number(cpf[i]) * (10 - i);
    }

    let digito1 = (soma * 10) % 11;

    if (digito1 === 10) {
        digito1 = 0;
    }

    if (digito1 !== Number(cpf[9])) {
        return false;
    }

    soma = 0;

    for (let i = 0; i < 10; i++) {
        soma += Number(cpf[i]) * (11 - i);
    }

    let digito2 = (soma * 10) % 11;

    if (digito2 === 10) {
        digito2 = 0;
    }

    return digito2 === Number(cpf[10]);
}

function validar(funcionario) {
    if (funcionario.nome === '') {
        return {
            campo: 'nome',
            texto: 'Informe o nome.'
        };
    }

    if (funcionario.cpf === '') {
        return {
            campo: 'cpf',
            texto: 'Informe o CPF.'
        };
    }

    if (!cpfValido(funcionario.cpf)) {
        return {
            campo: 'cpf',
            texto: 'CPF inválido.'
        };
    }

    if (
        funcionario.telefone !== '' &&
        funcionario.telefone.length < 10
    ) {
        return {
            campo: 'telefone',
            texto: 'Telefone incompleto. Informe DDD e número.'
        };
    }

    if (
        funcionario.cep !== '' &&
        funcionario.cep.length !== 8
    ) {
        return {
            campo: 'cep',
            texto: 'CEP deve ter 8 números.'
        };
    }

    if (
        funcionario.email !== '' &&
        !/^\S+@\S+\.\S+$/.test(funcionario.email)
    ) {
        return {
            campo: 'email',
            texto: 'E-mail inválido.'
        };
    }

    return null;
}

function limpandoCampos() {
    document.getElementById('codigo').value = '';
    document.getElementById('nome').value = '';
    document.getElementById('cpf').value = '';
    document.getElementById('telefone').value = '';
    document.getElementById('email').value = '';
    document.getElementById('cep').value = '';
    document.getElementById('endereco').value = '';
    document.getElementById('numero').value = '';
    document.getElementById('bairro').value = '';
    document.getElementById('cidade').value = '';

    mensagem.textContent = '';
    mensagem.classList.remove('sucesso');

    definirModoEdicao(false);
}

function definirModoEdicao(ativo) {
    botaoExcluir.hidden = !ativo;

    document.getElementById('titulo-cadastro').textContent =
        ativo ? 'Editar Funcionário' : 'Novo Funcionário';

    document.getElementById('titulo-migalha').textContent =
        ativo ? 'Editar funcionário' : 'Novo funcionário';

    botaoSalvar.textContent =
        ativo ? 'Salvar alterações' : 'Salvar funcionário';
}

function obterDadosFormulario() {
    return {
        nome: document.getElementById('nome').value.trim(),
        cpf: somenteNumeros(document.getElementById('cpf').value),
        telefone: somenteNumeros(document.getElementById('telefone').value),
        email: document.getElementById('email').value.trim(),
        cep: somenteNumeros(document.getElementById('cep').value),
        endereco: document.getElementById('endereco').value.trim(),
        numero: document.getElementById('numero').value.trim(),
        bairro: document.getElementById('bairro').value.trim(),
        cidade: document.getElementById('cidade').value.trim()
    };
}

async function salvar(id) {
    const funcionario = obterDadosFormulario();

    mensagem.textContent = '';
    mensagem.classList.remove('sucesso');

    const problema = validar(funcionario);

    if (problema) {
        mostrarMensagem(problema.texto);
        document.getElementById(problema.campo).focus();
        return;
    }

    const editando = Number(id) > 0;

    const url = editando
        ? `${API}?id=${encodeURIComponent(id)}`
        : API;

    botaoSalvar.disabled = true;
    botaoSalvar.textContent = editando
        ? 'Salvando alterações...'
        : 'Salvando...';

    try {
        const resposta = await fetch(url, {
            method: editando ? 'PUT' : 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(funcionario)
        });

        const dados = await resposta.json();

        if (!resposta.ok || dados.erro) {
            notificar(
                'erro',
                dados.erro || 'Não foi possível salvar o funcionário.',
                { titulo: 'Falha ao salvar' }
            );
            return;
        }

        const textoSucesso = editando
            ? 'Funcionário atualizado com sucesso.'
            : `Funcionário cadastrado com sucesso. Código: ${dados.id}.`;

            limpandoCampos();
            notificar('sucesso', textoSucesso);

       
    } catch (erro) {
        console.error('Erro ao salvar funcionário:', erro);
        mostrarMensagem('Não foi possível conectar à API de funcionários.');
    } finally {
        botaoSalvar.disabled = false;
        botaoSalvar.textContent = 'Salvar funcionário';
    }
}

async function carregarFuncionario(origem = 0) {
    if (origem === 1) {
        const parametros = new URLSearchParams(window.location.search);
        const idUrl = parametros.get('id');

        if (idUrl) {
            codigoInput.value = idUrl;
        }
    }

    const id = codigoInput.value.trim();

    if (!id || !/^\d+$/.test(id) || Number(id) <= 0) {
        if (origem === 1) {
            codigoInput.value = '';
        }

        definirModoEdicao(false);
        return;
    }

    try {
        const resposta = await fetch(
            `${API}?id=${encodeURIComponent(id)}`
        );

        const funcionario = await resposta.json();

        if (!resposta.ok || funcionario.erro) {
            notificar(
                'atencao',
                funcionario.erro || 'Funcionário não encontrado.'
            );

            definirModoEdicao(false);
            return;
        }

        codigoInput.value = funcionario.id ?? id;
        document.getElementById('nome').value = funcionario.nome ?? '';
        document.getElementById('cpf').value = mascaraCpf(funcionario.cpf ?? '');
        document.getElementById('telefone').value = mascaraTelefone(funcionario.telefone ?? '');
        document.getElementById('email').value = funcionario.email ?? '';
        document.getElementById('cep').value = mascaraCep(funcionario.cep ?? '');
        document.getElementById('endereco').value = funcionario.endereco ?? '';
        document.getElementById('numero').value = funcionario.numero ?? '';
        document.getElementById('bairro').value = funcionario.bairro ?? '';
        document.getElementById('cidade').value = funcionario.cidade ?? '';

        definirModoEdicao(true);
        mostrarMensagem('Funcionário carregado para edição.', true);
    } catch (erro) {
        console.error('Erro ao carregar funcionário:', erro);
        mostrarMensagem('Não foi possível consultar a API de funcionários.');
    }
}

async function excluirFuncionario() {
    const codigo = codigoInput.value.trim();

    if (!codigo) {
        notificar('atencao', 'Informe o código do funcionário para excluir.');
        return;
    }

    let confirmado = false;

    if (typeof window.mostrarConfirmacao === 'function') {
        confirmado = await window.mostrarConfirmacao({
            titulo: 'Excluir funcionário',
            mensagem: 'Tem certeza que deseja excluir este funcionário?',
            textoSim: 'Sim',
            textoNao: 'Não',
            focoInicial: 'nao'
        });
    } else {
        confirmado = window.confirm(
            'Tem certeza que deseja excluir este funcionário?'
        );
    }

    if (!confirmado) {
        return;
    }

    try {
        const resposta = await fetch(
            `${API}?id=${encodeURIComponent(codigo)}`,
            { method: 'DELETE' }
        );

        const dados = await resposta.json();

        if (!resposta.ok || dados.erro) {
            notificar(
                'erro',
                dados.erro || 'Erro ao excluir funcionário.'
            );
            return;
        }

        notificar('sucesso', 'Funcionário excluído com sucesso.');
        limpandoCampos();
    } catch (erro) {
        console.error('Erro ao excluir funcionário:', erro);
        notificar('erro', 'Não foi possível conectar ao servidor.');
    }
}

function aplicarMascara(idCampo, funcao) {
    const campo = document.getElementById(idCampo);

    campo.addEventListener('input', function () {
        campo.value = funcao(campo.value);
    });
}

aplicarMascara('cpf', mascaraCpf);
aplicarMascara('telefone', mascaraTelefone);
aplicarMascara('cep', mascaraCep);

codigoInput.addEventListener('keydown', function (evento) {
    if (evento.key === 'Enter') {
        evento.preventDefault();
        carregarFuncionario(0);
    }
});

botaoExcluir.addEventListener('click', excluirFuncionario);

form.addEventListener('submit', function (evento) {
    evento.preventDefault();

    const id = Number(codigoInput.value);

    salvar(id);
});

document.getElementById('limpar').addEventListener('click', function () {
    limpandoCampos();
});

carregarFuncionario(1);