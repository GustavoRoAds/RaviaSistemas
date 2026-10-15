// =====================================================
//  TELA DE CLIENTES
// =====================================================

// ----- CLIENTES DE EXEMPLO -----
// (por enquanto a lista fica só na memória: se recarregar a página, ela volta ao começo.
//  Quando tiver o banco de dados, isso passa a vir de lá e a ser salvo de verdade)
/*let clientes = [
    { id: 1, nome: "Ana Paula Ferreira",    telefone: "(11) 99832-4471", cpf: "342.891.029-10" },
    { id: 2, nome: "Carlos Eduardo Souza",  telefone: "(11) 97654-3210", cpf: "561.230.874-55" },
    { id: 3, nome: "Fernanda Lima",         telefone: "(21) 98765-1234", cpf: "789.012.345-67" },
    { id: 4, nome: "Roberto Alves Neto",    telefone: "(11) 96543-8800", cpf: "234.567.890-12" },
    { id: 5, nome: "Juliana Mendes Costa",  telefone: "(31) 99123-4567", cpf: "123.456.789-00" },
    { id: 6, nome: "Marcos Antônio Dias",   telefone: "(11) 98888-7777", cpf: "987.654.321-09" },
    { id: 7, nome: "Camila Rocha Barbosa",  telefone: "(41) 99456-7890", cpf: "654.321.098-76" }
];*/





let proximoId = 8;           // id que o próximo cliente cadastrado vai receber
let idEmEdicao = null;       // id do cliente que está sendo editado (vazio = cliente novo)

// ----- PEGANDO OS ELEMENTOS DA TELA (pelos ids do HTML) -----
const textoQuantidade = document.getElementById("cli-quantidade");
const inputBusca      = document.getElementById("cli-busca");
const corpoTabela     = document.getElementById("cli-corpo");
const botaoNovo       = document.getElementById("btn-novo-cliente");

const modal           = document.getElementById("cli-modal");
const modalTitulo     = document.getElementById("cli-modal-titulo");
const formulario      = document.getElementById("cli-form");
const inputNome       = document.getElementById("cli-nome");
const inputTelefone   = document.getElementById("cli-telefone");
const inputCpf        = document.getElementById("cli-cpf");
const textoErro       = document.getElementById("cli-erro");
const botaoExcluir    = document.getElementById("cli-btn-excluir");
const botaoCancelar   = document.getElementById("cli-btn-cancelar");


// =====================================================
//  FUNÇÕES AJUDANTES
// =====================================================

// tira acentos e letras maiúsculas (assim "joao" encontra "João")
function tirarAcentos(texto) {
    return texto.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

// evita que um nome com < > " quebre a página
function escapar(texto) {
    return texto.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

// deixa o CPF no formato 000.000.000-00 enquanto a pessoa digita
function formatarCpf(valor) {
    const n = valor.replace(/\D/g, "").slice(0, 11);   // só os números, no máximo 11

    if (n.length > 9) {
        return n.slice(0, 3) + "." + n.slice(3, 6) + "." + n.slice(6, 9) + "-" + n.slice(9);
    }
    if (n.length > 6) {
        return n.slice(0, 3) + "." + n.slice(3, 6) + "." + n.slice(6);
    }
    if (n.length > 3) {
        return n.slice(0, 3) + "." + n.slice(3);
    }
    return n;
}

// deixa o telefone no formato (00) 00000-0000 enquanto a pessoa digita
function formatarTelefone(valor) {
    const n = valor.replace(/\D/g, "").slice(0, 11);

    if (n.length > 10) {
        return "(" + n.slice(0, 2) + ") " + n.slice(2, 7) + "-" + n.slice(7);
    }
    if (n.length > 6) {
        return "(" + n.slice(0, 2) + ") " + n.slice(2, 6) + "-" + n.slice(6);
    }
    if (n.length > 2) {
        return "(" + n.slice(0, 2) + ") " + n.slice(2);
    }
    if (n.length > 0) {
        return "(" + n;
    }
    return "";
}


// =====================================================
//  MOSTRAR A LISTA (com a busca)
// =====================================================
function mostrarClientes() {
    const texto = tirarAcentos(inputBusca.value.trim());
    const soNumeros = inputBusca.value.replace(/\D/g, "");   // para buscar por CPF ou telefone

    let html = "";

    for (let i = 0; i < clientes.length; i++) {
        const c = clientes[i];

        const achouNome = tirarAcentos(c.nome).includes(texto);
        const achouCpf = soNumeros !== "" && c.cpf.replace(/\D/g, "").includes(soNumeros);
        const achouTelefone = soNumeros !== "" && c.telefone.replace(/\D/g, "").includes(soNumeros);

        if (achouNome || achouCpf || achouTelefone) {
            const telefone = c.telefone !== "" ? escapar(c.telefone) : '<span class="cli-sem-dado">—</span>';
            const cpf = c.cpf !== "" ? escapar(c.cpf) : '<span class="cli-sem-dado">—</span>';

            html += '<tr class="cli-linha" onclick="editarCliente(' + c.id + ')">';
            html += '  <td>';
            html += '    <div class="cli-pessoa">';
            html += '      <span class="cli-avatar">' + escapar(c.nome.charAt(0).toUpperCase()) + '</span>';
            html += '      <span class="cli-nome">' + escapar(c.nome) + '</span>';
            html += '    </div>';
            html += '  </td>';
            html += '  <td class="cli-telefone">' + telefone + '</td>';
            html += '  <td class="cli-cpf">' + cpf + '</td>';
            html += '</tr>';
        }
    }

    if (html === "") {
        if (clientes.length === 0) {
            html = '<tr><td colspan="3" class="cli-vazio">Nenhum cliente cadastrado ainda</td></tr>';
        } else {
            html = '<tr><td colspan="3" class="cli-vazio">Nenhum cliente encontrado</td></tr>';
        }
    }

    corpoTabela.innerHTML = html;

    // texto "7 clientes cadastrados" (conta todos, não só os da busca)
    if (clientes.length === 1) {
        textoQuantidade.textContent = "1 cliente cadastrado";
    } else {
        textoQuantidade.textContent = clientes.length + " clientes cadastrados";
    }
}

// toda vez que digitar na busca, atualiza a lista
inputBusca.addEventListener("input", mostrarClientes);


// =====================================================
//  JANELA DE CADASTRAR / EDITAR
// =====================================================

// botão "Novo Cliente"
function abrirNovoCliente() {
    idEmEdicao = null;
    modalTitulo.textContent = "Novo Cliente";

    inputNome.value = "";
    inputTelefone.value = "";
    inputCpf.value = "";
    textoErro.textContent = "";
    botaoExcluir.style.display = "none";   // cliente novo não tem o que excluir

    modal.classList.add("aberto");
    inputNome.focus();
}

// clicar numa linha da tabela
function editarCliente(id) {
    for (let i = 0; i < clientes.length; i++) {
        if (clientes[i].id === id) {
            idEmEdicao = id;
            modalTitulo.textContent = "Editar Cliente";

            inputNome.value = clientes[i].nome;
            inputTelefone.value = clientes[i].telefone;
            inputCpf.value = clientes[i].cpf;
            textoErro.textContent = "";
            botaoExcluir.style.display = "";   // mostra o botão Excluir

            modal.classList.add("aberto");
            inputNome.focus();
        }
    }
}

function fecharModal() {
    modal.classList.remove("aberto");
}

// botão "Salvar" (ou apertar Enter)
function salvarCliente() {
    const nome = inputNome.value.trim();
    const telefone = inputTelefone.value.trim();
    const cpf = inputCpf.value.trim();

    // ----- conferindo o que foi digitado -----
    if (nome === "") {
        textoErro.textContent = "Digite o nome do cliente.";
        return;
    }

    const numerosTelefone = telefone.replace(/\D/g, "");
    if (telefone !== "" && numerosTelefone.length < 10) {
        textoErro.textContent = "Telefone incompleto. Use DDD + número.";
        return;
    }

    const numerosCpf = cpf.replace(/\D/g, "");
    if (cpf !== "" && numerosCpf.length !== 11) {
        textoErro.textContent = "CPF incompleto. Ele precisa ter 11 números.";
        return;
    }

    // não deixa cadastrar dois clientes com o mesmo CPF
    if (cpf !== "") {
        for (let i = 0; i < clientes.length; i++) {
            if (clientes[i].cpf === cpf && clientes[i].id !== idEmEdicao) {
                textoErro.textContent = "Já existe um cliente com este CPF.";
                return;
            }
        }
    }

    // ----- salvando -----
    // AQUI, no futuro, os dados serão enviados ao banco
    if (idEmEdicao === null) {
        // cliente novo
        clientes.push({ id: proximoId, nome: nome, telefone: telefone, cpf: cpf });
        proximoId = proximoId + 1;
    } else {
        // cliente que já existia: atualiza os dados
        for (let i = 0; i < clientes.length; i++) {
            if (clientes[i].id === idEmEdicao) {
                clientes[i].nome = nome;
                clientes[i].telefone = telefone;
                clientes[i].cpf = cpf;
            }
        }
    }

    fecharModal();
    mostrarClientes();
}

// botão "Excluir"
function excluirCliente() {
    if (!confirm("Tem certeza que deseja excluir este cliente?")) {
        return;
    }

    // AQUI, no futuro, o cliente será apagado do banco
    for (let i = 0; i < clientes.length; i++) {
        if (clientes[i].id === idEmEdicao) {
            clientes.splice(i, 1);   // tira 1 cliente daquela posição
            break;
        }
    }

    fecharModal();
    mostrarClientes();
}


// =====================================================
//  LIGANDO OS BOTÕES E CAMPOS
// =====================================================
botaoNovo.addEventListener("click", abrirNovoCliente);
botaoCancelar.addEventListener("click", fecharModal);
botaoExcluir.addEventListener("click", excluirCliente);

// salvar (clique no botão ou Enter dentro do formulário)
formulario.addEventListener("submit", function (e) {
    e.preventDefault();   // impede a página de recarregar
    salvarCliente();
});

// máscaras: formatam enquanto digita
inputTelefone.addEventListener("input", function () {
    inputTelefone.value = formatarTelefone(inputTelefone.value);
});
inputCpf.addEventListener("input", function () {
    inputCpf.value = formatarCpf(inputCpf.value);
});

// clicar no fundo escuro (fora da caixa branca) fecha a janela
modal.addEventListener("click", function (e) {
    if (e.target === modal) {
        fecharModal();
    }
});

// tecla Esc fecha a janela
document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
        fecharModal();
    }
});

// desenha a lista pela primeira vez
mostrarClientes();