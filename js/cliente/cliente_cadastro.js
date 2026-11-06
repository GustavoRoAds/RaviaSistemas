const API = 'api/cliente/cliente.php';

const form = document.getElementById('form-cliente');
const mensagem = document.getElementById('mensagem');

function mascaraDocumento(valor) {
    const n = somenteNumeros(valor).slice(0, 14);
    if (n.length <= 11) return n.replace(/(\d{3})(\d)/, '$1.$2').replace(/(\d{3})(\d)/, '$1.$2').replace(/(\d{3})(\d{1,2})$/, '$1-$2');
    return n.replace(/^(\d{2})(\d)/, '$1.$2').replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3').replace(/\.(\d{3})(\d)/, '.$1/$2').replace(/(\d{4})(\d)/, '$1-$2');
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

function mascaraCep(valor) {
    return somenteNumeros(valor)
        .slice(0, 8)
        .replace(/(\d{5})(\d)/, '$1-$2');      
}

function somenteNumeros(valor) {
    return valor.replace(/\D/g, '');
}

function cpfValido(cpf) {
    if (cpf.length !== 11) return false;

    if (/^(\d)\1{10}$/.test(cpf)) return false;

    let soma = 0;
    for (let i = 0; i < 9; i++) {
        soma += parseInt(cpf[i]) * (10 - i);
    }
    let digito1 = (soma * 10) % 11;
    if (digito1 === 10) digito1 = 0;
    if (digito1 !== parseInt(cpf[9])) return false;

    soma = 0;
    for (let i = 0; i < 10; i++) {
        soma += parseInt(cpf[i]) * (11 - i);
    }
    let digito2 = (soma * 10) % 11;
    if (digito2 === 10) digito2 = 0;

    return digito2 === parseInt(cpf[10]);
}

function cnpjValido(cnpj) {
    if (!/^\d{14}$/.test(cnpj) || /^(\d)\1{13}$/.test(cnpj)) return false;
    const digito = (base, pesos) => {
        const soma = [...base].reduce((total, n, i) => total + Number(n) * pesos[i], 0);
        return String((11 - soma % 11) % 11 % 10);
    };
    const primeiro = digito(cnpj.slice(0, 12), [5,4,3,2,9,8,7,6,5,4,3,2]);
    const segundo = digito(cnpj.slice(0, 12) + primeiro, [6,5,4,3,2,9,8,7,6,5,4,3,2]);
    return cnpj.slice(12) === primeiro + segundo;
}

function validar(cliente) {
    if (cliente.nome === '') {
        return { campo: 'nome', texto: 'Informe o nome.' };
    }
    if (cliente.cpf === '') {
        return { campo: 'cpf', texto: 'Informe o CPF ou CNPJ.' };
    }
    if (!(cpfValido(cliente.cpf) || cnpjValido(cliente.cpf))) {
        return { campo: 'cpf', texto: 'CPF ou CNPJ inválido.' };
    }
    if (cliente.telefone !== '' && cliente.telefone.length < 10) {
        return { campo: 'telefone', texto: 'Telefone incompleto. Informe DDD e número.' };
    }
    if (cliente.cep !== '' && cliente.cep.length !== 8) {
        return { campo: 'cep', texto: 'CEP deve ter 8 números.' };
    }
    if (cliente.email !== '' && !/^\S+@\S+\.\S+$/.test(cliente.email)) {
        return { campo: 'email', texto: 'E-mail inválido.' };
    }
    return null;
}

function limpandoCampos(){
    document.getElementById('codigo').value =  '';
    document.getElementById('nome').value =  '';
    document.getElementById('cpf').value = '';
    document.getElementById('telefone').value = '';
    document.getElementById('email').value = '';
    document.getElementById('cep').value = '';
    document.getElementById('endereco').value = '';
    document.getElementById('numero').value =  '';
    document.getElementById('bairro').value = '';
    document.getElementById('cidade').value = '';
}


async function salvar(id){
    const cliente = {
        codigo:   id,
        nome:     document.getElementById('nome').value.trim(),
        cpf:      somenteNumeros(document.getElementById('cpf').value),
        telefone: somenteNumeros(document.getElementById('telefone').value),
        email:    document.getElementById('email').value.trim(),
        cep:      somenteNumeros(document.getElementById('cep').value),
        endereco: document.getElementById('endereco').value.trim(),
        numero:   document.getElementById('numero').value.trim(),
        bairro:   document.getElementById('bairro').value.trim(),
        cidade:   document.getElementById('cidade').value.trim()
    };

    mensagem.textContent = '';

    const problema = validar(cliente);
    if (problema) {
        mensagem.textContent = problema.texto;
        document.getElementById(problema.campo).focus();   
        return;                                            
    }

    if ((id) && (id > 0)) {
        try {
            const resposta = await fetch('api/cliente/'+id, { 
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(cliente)
            });

            const dados = await resposta.json();

            if (resposta.status == 201){
                Notificacao.sucesso('Cliente atualizado com Sucesso.');
                limpandoCampos();
            }else {
                Notificacao.erro('Não foi possível falar com o servidor.', { titulo: 'Falha de conexão' });
            }
        
        } catch (erro) {
            mensagem.textContent = 'Não foi possivel falar com o servidor.';
            console.error(erro);
        }

        
    }else {
        try {
            const resposta = await fetch(API, { 
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(cliente)
            });

            const dados = await resposta.json();

            if (resposta.status == 201){
                Notificacao.sucesso('Cliente Cadastrado com Sucesso.');
                limpandoCampos();
            }else {
                Notificacao.erro('Não foi possível falar com o servidor.', { titulo: 'Falha de conexão' });
            }
        
        } catch (erro) {
            mensagem.textContent = 'Não foi possivel falar com o servidor.';
            console.error(erro);
        }

    }
}


function carregarCliente(origem){

    if (origem === 1) {   
        const param = new URLSearchParams(window.location.search); 
        const cliente_id = param.get('id');

        document.getElementById('codigo').value = cliente_id;
    }
    
    if ((document.getElementById('codigo').value) && (document.getElementById('codigo').value > 0)){
        let url = 'api/cliente/cliente.php?id='+ encodeURIComponent(document.getElementById('codigo').value);
        fetch(url)
            .then(resposta => resposta.json())
            .then(cliente_res => {
                console.log(cliente_res);
                
                document.getElementById('nome').value = cliente_res.nome ?? '';
                document.getElementById('cpf').value = mascaraDocumento(cliente_res.cpf ?? '');
                document.getElementById('telefone').value = mascaraTelefone(cliente_res.telefone ?? '');
                document.getElementById('email').value = cliente_res.email ?? '';
                document.getElementById('cep').value = mascaraCep(cliente_res.cep ?? '');
                document.getElementById('endereco').value = cliente_res.endereco ?? '';
                document.getElementById('numero').value = cliente_res.numero ?? '';
                document.getElementById('bairro').value = cliente_res.bairro ?? '';
                document.getElementById('cidade').value = cliente_res.cidade ?? '';


            if (cliente_res.erro) {
                Notificacao.atencao('Cliente não encontrado.');
            }
        });
        
    }else {
        document.getElementById('codigo').value = '';
    }
}

async function excluirCliente() {
    const codigo = document.getElementById('codigo').value;
    const mensagem = document.getElementById('mensagem');

    if (!codigo) {
        Notificacao.atencao('Informe o código do cliente para excluir');
        return;
    }

    const salvar = await mostrarConfirmacao({
        titulo: 'Excluir',
        mensagem: 'Tem certeza que deseja excluir este cliente?',
        textoSim: 'Sim',
        textoNao: 'Não',
        focoInicial: 'nao'
    });

    if (salvar){
        const url = 'api/cliente/cliente.php?id=' + encodeURIComponent(codigo);
    
        fetch(url, { method: 'DELETE' })
            .then(resposta => resposta.json().then(dados => ({ ok: resposta.ok, dados })))
            .then(({ ok, dados }) => {
                if (!ok) {
                    Notificacao.erro(dados.erro || 'Erro ao excluir cliente');
                    return;
                }
    
                Notificacao.sucesso('Cliente inativado com sucesso');            
    
                limpandoCampos();
            })
            .catch(erro => {
                console.error(erro);
                Notificacao.erro('Não foi possível conectar ao servidor');                            
            });
    }

    
}

function aplicarMascara(idcampo, funcao) {
    const campo = document.getElementById(idcampo);

    campo.addEventListener('input', function () {
        campo.value = funcao(campo.value);
    });
}

aplicarMascara('cpf', mascaraDocumento);
aplicarMascara('telefone', mascaraTelefone);
aplicarMascara('cep', mascaraCep);



carregarCliente(1);


const codigo_inp = document.getElementById('codigo');
codigo_inp.addEventListener('keydown', function(evento){
    if (evento.key === 'Enter' ){
        evento.preventDefault();
        carregarCliente(0);
    }
});

const botaoExcluir = document.getElementById('excluir');
botaoExcluir.addEventListener('click', excluirCliente);

form.addEventListener('submit', async function (evento) {
    evento.preventDefault();
    const id = Number(document.getElementById('codigo').value);

    salvar(id);
});

const limpar = document.getElementById('limpar');
limpar.addEventListener('click', function() {
    limpandoCampos();
});


// Consultas opcionais: nao impedem o cadastro se o servico estiver indisponivel.
let ultimaConsultaCep = '';
let ultimaConsultaCnpj = '';

async function consultarCep() {
    const cep = somenteNumeros(document.getElementById('cep').value);
    if (cep.length !== 8) { Notificacao.atencao('Informe um CEP com 8 dígitos.'); return; }
    ultimaConsultaCep = cep;
    try {
        const resposta = await fetch(`https://viacep.com.br/ws/${cep}/json/`);
        if (!resposta.ok) throw new Error('Falha ao consultar CEP');
        const dados = await resposta.json();
        if (dados.erro) { Notificacao.atencao('CEP não encontrado.'); return; }
        if (somenteNumeros(document.getElementById('cep').value) !== cep) return;
        document.getElementById('endereco').value = dados.logradouro || '';
        document.getElementById('bairro').value = dados.bairro || '';
        document.getElementById('cidade').value = dados.localidade || '';
        // O formulario atual nao possui campo UF.
    } catch (erro) {
        console.error('Consulta CEP:', erro);
        ultimaConsultaCep = '';
        Notificacao.atencao('Não foi possível consultar o CEP. Preencha o endereço manualmente.');
    }
}

async function consultarCnpj() {
    const documento = somenteNumeros(document.getElementById('cpf').value);
    if (documento.length !== 14 || !cnpjValido(documento)) { Notificacao.atencao('Informe um CNPJ válido para consultar.'); return; }
    ultimaConsultaCnpj = documento;
    try {
        const resposta = await fetch(`https://brasilapi.com.br/api/cnpj/v1/${documento}`);
        if (!resposta.ok) throw new Error(`Consulta CNPJ: HTTP ${resposta.status}`);
        const dados = await resposta.json();
        if (somenteNumeros(document.getElementById('cpf').value) !== documento) return;
        const nome = document.getElementById('nome');
        nome.value = dados.razao_social || dados.nome_fantasia || nome.value;
        document.getElementById('telefone').value = mascaraTelefone(dados.ddd_telefone_1 || '');
        document.getElementById('cep').value = mascaraCep(dados.cep || '');
        document.getElementById('endereco').value = [dados.descricao_tipo_de_logradouro, dados.logradouro].filter(Boolean).join(' ');
        document.getElementById('numero').value = dados.numero || '';
        document.getElementById('bairro').value = dados.bairro || '';
        document.getElementById('cidade').value = dados.municipio || '';
    } catch (erro) {
        console.error('Consulta CNPJ:', erro);
        ultimaConsultaCnpj = '';
        Notificacao.atencao('Não foi possível consultar o CNPJ. Preencha os dados manualmente.');
    }
}

document.getElementById('consultar-cep').addEventListener('click', consultarCep);
document.getElementById('consultar-cpf').addEventListener('click', consultarCnpj);
