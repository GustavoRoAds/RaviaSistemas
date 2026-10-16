// =====================================================
//  TELA DE REGISTRAR VENDA
// =====================================================

// ----- DE ONDE VÊM OS PRODUTOS E CLIENTES -----
// true  = usa as listas de exemplo logo abaixo (serve para testar sem banco de dados)
// false = busca de verdade no banco, usando os arquivos da pasta api/
const USAR_EXEMPLOS = true;

/*const produtosExemplo = [
    { id: 1,  nome: "Calcinha Algodão Básica",           preco: 14.90 },
    { id: 2,  nome: "Calcinha Renda Fio Dental",         preco: 19.90 },
    { id: 3,  nome: "Sutiã com Bojo Renda",              preco: 49.90 },
    { id: 4,  nome: "Sutiã Sem Costura Tomara que Caia", preco: 44.90 },
    { id: 5,  nome: "Conjunto Lingerie Renda",           preco: 79.90 },
    { id: 6,  nome: "Body Renda Manga Curta",            preco: 89.90 },
    { id: 7,  nome: "Camisola Cetim",                    preco: 69.90 },
    { id: 8,  nome: "Short Doll Algodão",                preco: 59.90 },
    { id: 9,  nome: "Pijama Longo Feminino",             preco: 99.90 },
    { id: 10, nome: "Pijama Curto Feminino",             preco: 74.90 },
    { id: 11, nome: "Meia Soquete (par)",                preco: 9.90 },
    { id: 12, nome: "Meia-Calça Fio 20",                 preco: 24.90 },
    { id: 13, nome: "Cueca Boxer Algodão",               preco: 24.90 },
    { id: 14, nome: "Cinta Modeladora",                  preco: 89.90 }
];

const clientesExemplo = [
    { id: 1, nome: "Maria Silva",   cpf: "123.456.789-00" },
    { id: 2, nome: "João Pereira",  cpf: "987.654.321-00" },
    { id: 3, nome: "Ana Costa",     cpf: "111.222.333-44" },
    { id: 4, nome: "Carlos Souza",  cpf: "555.666.777-88" },
    { id: 5, nome: "Fernanda Lima", cpf: "222.333.444-55" }
];*/

// ----- A VENDA ATUAL -----
let itens = [];               // lista dos produtos que estão na venda
let clienteEscolhido = null;  // cliente da venda (pode ficar vazio)

let produtosDaBusca = [];     // resultado da última busca de produto
let clientesDaBusca = [];     // resultado da última busca de cliente

// ----- PEGANDO OS ELEMENTOS DA TELA (pelos ids do HTML) -----
const inputProduto  = document.getElementById("busca-produto");
const listaProdutos = document.getElementById("lista-produtos");

const itensVazio = document.getElementById("itens-vazio");
const listaItens = document.getElementById("itens-lista");

const inputCliente  = document.getElementById("busca-cliente");
const listaClientes = document.getElementById("lista-clientes");
const caixaBusca    = document.getElementById("campo-cliente");
const chipCliente   = document.getElementById("chip-cliente");
const chipNome      = document.getElementById("chip-nome");
const chipCpf       = document.getElementById("chip-cpf");

const totalVenda      = document.getElementById("venda-total");
const botaoConfirmar  = document.getElementById("btn-confirmar");
const aviso           = document.getElementById("venda-aviso");


// =====================================================
//  FUNÇÕES AJUDANTES
// =====================================================

// deixa o valor no formato R$ 0,00
function formatarDinheiro(valor) {
    return valor.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

// tira acentos e letras maiúsculas (assim "sutia" encontra "Sutiã")
function tirarAcentos(texto) {
    return texto.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}


// =====================================================
//  BUSCANDO OS DADOS (exemplos ou banco)
//  É AQUI que a tela decide de onde vêm os produtos e clientes.
// =====================================================

// procura produtos pelo nome
// precisa devolver uma lista assim: [ { id: 1, nome: "Sutiã", preco: 49.90 }, ... ]
async function buscarProdutos(texto) {
    let lista = [];

    if (USAR_EXEMPLOS) {
        for (let i = 0; i < produtosExemplo.length; i++) {
            if (tirarAcentos(produtosExemplo[i].nome).includes(tirarAcentos(texto))) {
                lista.push(produtosExemplo[i]);
            }
        }
        return lista;
    }

    // busca no banco, pelo arquivo api/produtos.php
    const resposta = await fetch("api/produtos.php?busca=" + encodeURIComponent(texto));
    if (!resposta.ok) {
        throw new Error("Erro ao buscar produtos");
    }
    lista = await resposta.json();

    // o banco costuma mandar números como texto ("49.90"), aqui voltamos para número
    for (let i = 0; i < lista.length; i++) {
        lista[i].id = Number(lista[i].id);
        lista[i].preco = Number(lista[i].preco);
    }
    return lista;
}

// procura clientes pelo nome ou CPF
// precisa devolver uma lista assim: [ { id: 1, nome: "Maria", cpf: "123.456.789-00" }, ... ]
async function buscarClientes(texto) {
    let lista = [];

    if (USAR_EXEMPLOS) {
        const soNumeros = texto.replace(/\D/g, "");   // para buscar pelo CPF

        for (let i = 0; i < clientesExemplo.length; i++) {
            const c = clientesExemplo[i];
            const achouPeloNome = tirarAcentos(c.nome).includes(tirarAcentos(texto));
            const achouPeloCpf = soNumeros !== "" && c.cpf.replace(/\D/g, "").includes(soNumeros);

            if (achouPeloNome || achouPeloCpf) {
                lista.push(c);
            }
        }
        return lista;
    }

    // busca no banco, pelo arquivo api/clientes.php
    const resposta = await fetch("api/clientes.php?busca=" + encodeURIComponent(texto));
    if (!resposta.ok) {
        throw new Error("Erro ao buscar clientes");
    }
    lista = await resposta.json();

    for (let i = 0; i < lista.length; i++) {
        lista[i].id = Number(lista[i].id);
    }
    return lista;
}


// =====================================================
//  BUSCAR E ADICIONAR PRODUTO
// =====================================================

// toda vez que digitar no campo de produto
inputProduto.addEventListener("input", async function () {
    const texto = inputProduto.value.trim();

    // campo vazio: fecha a lista
    if (texto === "") {
        listaProdutos.classList.remove("aberta");
        return;
    }

    let encontrados = [];
    try {
        encontrados = await buscarProdutos(texto);
    } catch (erro) {
        console.log(erro);
        listaProdutos.innerHTML = '<div class="venda-sem-resultado">Não foi possível buscar os produtos</div>';
        listaProdutos.classList.add("aberta");
        return;
    }

    // se a pessoa já digitou outra coisa enquanto esperava, ignora esta resposta
    if (inputProduto.value.trim() !== texto) {
        return;
    }

    produtosDaBusca = encontrados;

    let html = "";

    // mostra no máximo 6 resultados
    for (let i = 0; i < produtosDaBusca.length && i < 6; i++) {
        const p = produtosDaBusca[i];
        html += '<button type="button" class="venda-opcao" onclick="adicionarProduto(' + p.id + ')">';
        html += '<span>' + p.nome + '</span>';
        html += '<span class="venda-opcao-detalhe">' + formatarDinheiro(p.preco) + '</span>';
        html += '</button>';
    }

    if (html === "") {
        html = '<div class="venda-sem-resultado">Nenhum produto encontrado</div>';
    }

    listaProdutos.innerHTML = html;
    listaProdutos.classList.add("aberta");
});

// chamada quando clica num produto da lista
function adicionarProduto(id) {
    // 1) vê se o produto já está na venda
    let itemDaVenda = null;
    for (let i = 0; i < itens.length; i++) {
        if (itens[i].id === id) {
            itemDaVenda = itens[i];
        }
    }

    if (itemDaVenda !== null) {
        // já estava: só aumenta a quantidade
        itemDaVenda.qtd = itemDaVenda.qtd + 1;
    } else {
        // não estava: procura nos resultados da busca e coloca na venda
        for (let i = 0; i < produtosDaBusca.length; i++) {
            if (produtosDaBusca[i].id === id) {
                itens.push({
                    id: id,
                    nome: produtosDaBusca[i].nome,
                    preco: produtosDaBusca[i].preco,
                    qtd: 1
                });
            }
        }
    }

    // 2) limpa o campo de busca e fecha a lista
    inputProduto.value = "";
    listaProdutos.classList.remove("aberta");
    inputProduto.focus();

    mostrarItens();
}


// =====================================================
//  ITENS DA VENDA
// =====================================================

// desenha a lista de itens na tela
function mostrarItens() {
    let html = "";

    for (let i = 0; i < itens.length; i++) {
        const item = itens[i];

        html += '<li class="venda-item">';
        html += '  <div class="venda-item-info">';
        html += '    <span class="venda-item-nome">' + item.nome + '</span>';
        html += '    <span class="venda-item-unit">' + formatarDinheiro(item.preco) + ' un.</span>';
        html += '  </div>';
        html += '  <div class="venda-item-qtd">';
        html += '    <button type="button" class="venda-qtd-btn" onclick="menosUm(' + i + ')">−</button>';
        html += '    <input type="text" inputmode="numeric" class="venda-qtd-input" id="qtd-' + i + '" value="' + item.qtd + '" onchange="digitarQtd(' + i + ', this.value)">';
        html += '    <button type="button" class="venda-qtd-btn" onclick="maisUm(' + i + ')">+</button>';
        html += '  </div>';
        html += '  <span class="venda-item-subtotal" id="subtotal-' + i + '">' + formatarDinheiro(item.preco * item.qtd) + '</span>';
        html += '  <button type="button" class="venda-item-remover" onclick="removerItem(' + i + ')">✕</button>';
        html += '</li>';
    }

    listaItens.innerHTML = html;

    // mostra o "Nenhum produto adicionado" só quando a venda está vazia
    if (itens.length === 0) {
        itensVazio.style.display = "";
    } else {
        itensVazio.style.display = "none";
    }

    atualizarTotal();
}

// atualiza só uma linha (quantidade e subtotal) sem redesenhar a lista toda
function atualizarLinha(posicao) {
    const item = itens[posicao];
    document.getElementById("qtd-" + posicao).value = item.qtd;
    document.getElementById("subtotal-" + posicao).textContent = formatarDinheiro(item.preco * item.qtd);
    atualizarTotal();
}

// botão +
function maisUm(posicao) {
    if (itens[posicao].qtd < 9999) {
        itens[posicao].qtd = itens[posicao].qtd + 1;
    }
    atualizarLinha(posicao);
}

// botão −  (não deixa passar de 1, para tirar o item use o ✕)
function menosUm(posicao) {
    if (itens[posicao].qtd > 1) {
        itens[posicao].qtd = itens[posicao].qtd - 1;
    }
    atualizarLinha(posicao);
}

// quando a pessoa digita a quantidade no campo
function digitarQtd(posicao, valorDigitado) {
    let qtd = parseInt(valorDigitado);

    if (isNaN(qtd) || qtd < 1) {
        qtd = 1;
    }
    if (qtd > 9999) {
        qtd = 9999;
    }

    itens[posicao].qtd = qtd;
    atualizarLinha(posicao);
}

// botão ✕
function removerItem(posicao) {
    itens.splice(posicao, 1);   // tira 1 item daquela posição
    mostrarItens();
}

// soma tudo e atualiza o total e o botão de confirmar
function atualizarTotal() {
    let total = 0;

    for (let i = 0; i < itens.length; i++) {
        total = total + itens[i].preco * itens[i].qtd;
    }

    totalVenda.textContent = formatarDinheiro(total);

    // o botão só funciona se tiver pelo menos 1 item
    botaoConfirmar.disabled = (itens.length === 0);
}


// =====================================================
//  CLIENTE (OPCIONAL)
// =====================================================

// toda vez que digitar no campo de cliente
inputCliente.addEventListener("input", async function () {
    const texto = inputCliente.value.trim();

    if (texto === "") {
        listaClientes.classList.remove("aberta");
        return;
    }

    let encontrados = [];
    try {
        encontrados = await buscarClientes(texto);
    } catch (erro) {
        console.log(erro);
        listaClientes.innerHTML = '<div class="venda-sem-resultado">Não foi possível buscar os clientes</div>';
        listaClientes.classList.add("aberta");
        return;
    }

    // se a pessoa já digitou outra coisa enquanto esperava, ignora esta resposta
    if (inputCliente.value.trim() !== texto) {
        return;
    }

    clientesDaBusca = encontrados;

    let html = "";

    for (let i = 0; i < clientesDaBusca.length && i < 6; i++) {
        const c = clientesDaBusca[i];
        html += '<button type="button" class="venda-opcao" onclick="escolherCliente(' + c.id + ')">';
        html += '<span>' + c.nome + '</span>';
        html += '<span class="venda-opcao-detalhe">' + c.cpf + '</span>';
        html += '</button>';
    }

    if (html === "") {
        html = '<div class="venda-sem-resultado">Nenhum cliente encontrado</div>';
    }

    listaClientes.innerHTML = html;
    listaClientes.classList.add("aberta");
});

// chamada quando clica num cliente da lista
function escolherCliente(id) {
    for (let i = 0; i < clientesDaBusca.length; i++) {
        if (clientesDaBusca[i].id === id) {
            clienteEscolhido = clientesDaBusca[i];
        }
    }

    chipNome.textContent = clienteEscolhido.nome;
    chipCpf.textContent = clienteEscolhido.cpf;

    caixaBusca.style.display = "none";    // esconde o campo de busca
    chipCliente.style.display = "flex";   // mostra o cliente escolhido

    inputCliente.value = "";
    listaClientes.classList.remove("aberta");
}

// botão × do cliente escolhido
function tirarCliente() {
    clienteEscolhido = null;
    chipCliente.style.display = "none";
    caixaBusca.style.display = "";
}

document.getElementById("chip-remover").addEventListener("click", tirarCliente);


// =====================================================
//  CONFIRMAR VENDA
// =====================================================
botaoConfirmar.addEventListener("click", function () {
    if (itens.length === 0) {
        return;
    }

    // AQUI, no futuro, os dados da venda (itens + cliente) serão enviados ao banco

    // limpa a venda para começar outra
    itens = [];
    tirarCliente();
    mostrarItens();

    // mostra a mensagem de sucesso por 4 segundos
    aviso.textContent = "Venda registrada com sucesso!";
    aviso.className = "venda-aviso mostrar sucesso";
    setTimeout(function () {
        aviso.className = "venda-aviso";
    }, 4000);
});


// =====================================================
//  FECHAR AS LISTAS AO CLICAR FORA
// =====================================================
document.addEventListener("click", function (e) {
    if (!e.target.closest("#venda-busca-produto")) {
        listaProdutos.classList.remove("aberta");
    }
    if (!e.target.closest("#venda-busca-cliente")) {
        listaClientes.classList.remove("aberta");
    }
});