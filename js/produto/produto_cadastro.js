// ----- ENDEREÇOS DA API -----
const URL_PRODUTOS = "api/produto/produtos.php";
const URL_CATEGORIAS = "api/categorias/categorias.php";

// ----- DADOS DA TELA -----
let produtos = [];       // produtos que vieram da API
let categorias = [];     // categorias que vieram da API
let idEmEdicao = null;   // código do produto que está sendo editado (vazio = produto novo)

// ícone do lápis (botão de editar)
const ICONE_EDITAR = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>';

// ----- PEGANDO OS ELEMENTOS DA TELA (pelos ids do HTML) -----
const textoQuantidade = document.getElementById("prod-quantidade");
const inputBusca      = document.getElementById("prod-busca");
const corpoTabela     = document.getElementById("prod-corpo");
const botaoNovo       = document.getElementById("btn-novo-produto");

const modal           = document.getElementById("prod-modal");
const modalTitulo     = document.getElementById("prod-modal-titulo");
const formulario      = document.getElementById("prod-form");
const inputNome       = document.getElementById("prod-nome");
const inputDescricao  = document.getElementById("prod-descricao");
const selectCategoria = document.getElementById("prod-categoria");
const inputCusto      = document.getElementById("prod-custo");
const inputVenda      = document.getElementById("prod-venda");
const textoErro       = document.getElementById("prod-erro");
const botaoSalvar     = document.getElementById("prod-btn-salvar");
const botaoCancelar   = document.getElementById("prod-btn-cancelar");


// =====================================================
//  FUNÇÕES AJUDANTES
// =====================================================

// tira acentos e letras maiúsculas (assim "calca" encontra "Calça")
function tirarAcentos(texto) {
    return texto.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

// evita que um nome com < > " quebre a página
function escapar(texto) {
    return texto.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

// deixa o valor no formato R$ 0,00
function formatarDinheiro(valor) {
    return valor.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

// se o valor veio vazio do banco, devolve null; senão, devolve como número
function numeroOuNulo(valor) {
    if (valor === null || valor === undefined || valor === "") {
        return null;
    }
    return Number(valor);
}

// "49,90" (do campo) -> 49.9 (número).   Campo vazio -> null
function campoParaNumero(texto) {
    if (texto.trim() === "") {
        return null;
    }
    return Number(texto.replace(/\./g, "").replace(",", "."));
}

// 49.9 (número) -> "49,90" (para colocar no campo)
function numeroParaCampo(valor) {
    if (valor === null) {
        return "";
    }
    return valor.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// máscara de dinheiro: vai formatando enquanto digita (digitou 4990 -> 49,90)
function mascaraDinheiro(texto) {
    const n = texto.replace(/\D/g, "").slice(0, 9);   // só os números

    if (n === "") {
        return "";
    }
    return numeroParaCampo(parseInt(n, 10) / 100);
}


// =====================================================
//  TRADUZINDO O QUE VEM DA API
//  A API manda os nomes das colunas do banco (nomeProduto, valorVenda...).
//  Aqui a gente converte para os nomes que a tela usa.
//  Se alguma coluna do seu banco tiver outro nome, é só ajustar AQUI.
// =====================================================
function converterProduto(linha) {
    return {
        id: Number(linha.codigo),
        nome: String(linha.nomeProduto || ""),
        descricao: String(linha.descricaoProduto || ""),
        custo: numeroOuNulo(linha.valorCusto),
        venda: Number(linha.valorVenda),
        categoriaId: numeroOuNulo(linha.categoria_id),
        estoque: numeroOuNulo(linha.estoque)   // se a tabela não tiver estoque, fica vazio (—)
    };
}

function converterCategoria(linha) {
    return {
        id: Number(linha.id),
        // tenta os nomes de coluna mais comuns para o nome da categoria
        nome: String(linha.nomeCategoria || linha.nome || linha.descricao || ("Categoria " + linha.id))
    };
}

// devolve o nome da categoria pelo id (ou vazio se não tiver)
function nomeDaCategoria(id) {
    for (let i = 0; i < categorias.length; i++) {
        if (categorias[i].id === id) {
            return categorias[i].nome;
        }
    }
    return "";
}


// =====================================================
//  BUSCANDO DADOS NA API
// =====================================================
async function carregarCategorias() {
    try {
        const resposta = await fetch(URL_CATEGORIAS);
        if (!resposta.ok) {
            throw new Error("Erro " + resposta.status);
        }

        const linhas = await resposta.json();
        categorias = [];
        for (let i = 0; i < linhas.length; i++) {
            categorias.push(converterCategoria(linhas[i]));
        }
    } catch (erro) {
        // se falhar, a tela continua funcionando (só sem os nomes das categorias)
        console.log("Não foi possível carregar as categorias:", erro);
    }

    // coloca as categorias na lista da janela de cadastro
    let html = '<option value="">Sem categoria</option>';
    for (let i = 0; i < categorias.length; i++) {
        html += '<option value="' + categorias[i].id + '">' + escapar(categorias[i].nome) + '</option>';
    }
    selectCategoria.innerHTML = html;
}

async function carregarProdutos() {
    try {
        const resposta = await fetch(URL_PRODUTOS);
        if (!resposta.ok) {
            throw new Error("Erro " + resposta.status);
        }

        const linhas = await resposta.json();
        produtos = [];
        for (let i = 0; i < linhas.length; i++) {
            produtos.push(converterProduto(linhas[i]));
        }

        mostrarProdutos();
    } catch (erro) {
        console.log("Não foi possível carregar os produtos:", erro);
        corpoTabela.innerHTML = '<tr><td colspan="6" class="prod-vazio">Não foi possível carregar os produtos.</td></tr>';
    }
}


// =====================================================
//  MOSTRAR A LISTA (com a busca)
// =====================================================

// estoque: 0 fica vermelho, 5 ou menos fica laranja
function htmlEstoque(estoque) {
    if (estoque === null) {
        return '<span class="prod-sem-dado">—</span>';
    }

    let classe = "prod-estoque";
    if (estoque === 0) {
        classe = classe + " prod-estoque-zero";
    } else if (estoque <= 5) {
        classe = classe + " prod-estoque-baixo";
    }
    return '<span class="' + classe + '">' + estoque + '</span>';
}

function mostrarProdutos() {
    const texto = tirarAcentos(inputBusca.value.trim());

    let html = "";

    for (let i = 0; i < produtos.length; i++) {
        const p = produtos[i];
        const nomeCategoria = nomeDaCategoria(p.categoriaId);

        const achouNome = tirarAcentos(p.nome).includes(texto);
        const achouCategoria = tirarAcentos(nomeCategoria).includes(texto);

        if (achouNome || achouCategoria) {
            const categoria = nomeCategoria !== "" ? escapar(nomeCategoria) : '<span class="prod-sem-dado">—</span>';
            const custo = p.custo !== null ? formatarDinheiro(p.custo) : '<span class="prod-sem-dado">—</span>';

            html += '<tr>';
            html += '  <td>';
            html += '    <div class="prod-nome">' + escapar(p.nome) + '</div>';
            html += '    <div class="prod-descricao">' + escapar(p.descricao) + '</div>';
            html += '  </td>';
            html += '  <td class="prod-categoria">' + categoria + '</td>';
            html += '  <td class="prod-custo">' + custo + '</td>';
            html += '  <td class="prod-venda">' + formatarDinheiro(p.venda) + '</td>';
            html += '  <td>' + htmlEstoque(p.estoque) + '</td>';
            html += '  <td><button type="button" class="prod-editar" onclick="editarProduto(' + p.id + ')" title="Editar" aria-label="Editar produto">' + ICONE_EDITAR + '</button></td>';
            html += '</tr>';
        }
    }

    if (html === "") {
        if (produtos.length === 0) {
            html = '<tr><td colspan="6" class="prod-vazio">Nenhum produto cadastrado ainda</td></tr>';
        } else {
            html = '<tr><td colspan="6" class="prod-vazio">Nenhum produto encontrado</td></tr>';
        }
    }

    corpoTabela.innerHTML = html;

    // texto "10 produtos cadastrados" (conta todos, não só os da busca)
    if (produtos.length === 1) {
        textoQuantidade.textContent = "1 produto cadastrado";
    } else {
        textoQuantidade.textContent = produtos.length + " produtos cadastrados";
    }
}

// toda vez que digitar na busca, atualiza a lista
inputBusca.addEventListener("input", mostrarProdutos);


// =====================================================
//  JANELA DE CADASTRAR / EDITAR
// =====================================================

// botão "Novo Produto"
function abrirNovoProduto() {
    idEmEdicao = null;
    modalTitulo.textContent = "Novo Produto";

    inputNome.value = "";
    inputDescricao.value = "";
    selectCategoria.value = "";
    inputCusto.value = "";
    inputVenda.value = "";
    textoErro.textContent = "";

    modal.classList.add("aberto");
    inputNome.focus();
}

// botão do lápis em cada linha
function editarProduto(id) {
    for (let i = 0; i < produtos.length; i++) {
        if (produtos[i].id === id) {
            const p = produtos[i];

            idEmEdicao = id;
            modalTitulo.textContent = "Editar Produto";

            inputNome.value = p.nome;
            inputDescricao.value = p.descricao;
            selectCategoria.value = p.categoriaId === null ? "" : String(p.categoriaId);
            inputCusto.value = numeroParaCampo(p.custo);
            inputVenda.value = numeroParaCampo(p.venda);
            textoErro.textContent = "";

            modal.classList.add("aberto");
            inputNome.focus();
        }
    }
}

function fecharModal() {
    modal.classList.remove("aberto");
}

// botão "Salvar" (ou apertar Enter)
async function salvarProduto() {
    const nome = inputNome.value.trim();
    const descricao = inputDescricao.value.trim();
    const custo = campoParaNumero(inputCusto.value);
    const venda = campoParaNumero(inputVenda.value);

    // ----- conferindo o que foi digitado -----
    if (nome === "") {
        textoErro.textContent = "Digite o nome do produto.";
        return;
    }
    if (venda === null || venda <= 0) {
        textoErro.textContent = "Digite o valor de venda.";
        return;
    }

    // ----- montando os dados no formato que a API espera -----
    const dados = {
        nome: nome,
        descricao: descricao === "" ? null : descricao,
        custo: custo,
        valor: venda,
        preco: venda,   // a API confere o campo "preco" antes de salvar (mas grava o "valor"), por isso mandamos os dois
        categoria_id: selectCategoria.value === "" ? null : Number(selectCategoria.value)
    };

    // novo produto = POST ;  produto que já existia = PUT (com o código na URL)
    let url = URL_PRODUTOS;
    let metodo = "POST";
    if (idEmEdicao !== null) {
        url = URL_PRODUTOS + "?id=" + idEmEdicao;
        metodo = "PUT";
    }

    // ----- enviando para a API -----
    botaoSalvar.disabled = true;   // evita clicar duas vezes
    textoErro.textContent = "";

    try {
        const resposta = await fetch(url, {
            method: metodo,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(dados)
        });

        if (!resposta.ok) {
            let mensagem = "Não foi possível salvar o produto.";

            if (resposta.status === 405) {
                mensagem = "A API ainda não aceita editar produtos (falta o método PUT).";
            } else {
                // tenta ler a mensagem de erro que a API mandou
                try {
                    const erro = await resposta.json();
                    if (erro.erro) {
                        mensagem = erro.erro;
                    }
                } catch (e) {
                    // a resposta não era JSON, fica a mensagem padrão
                }
            }

            textoErro.textContent = mensagem;
            return;
        }

        fecharModal();
        await carregarProdutos();   // busca a lista de novo, já com a alteração
    } catch (erro) {
        console.log(erro);
        textoErro.textContent = "Erro de conexão. Tente novamente.";
    } finally {
        botaoSalvar.disabled = false;
    }
}


// =====================================================
//  LIGANDO OS BOTÕES E CAMPOS
// =====================================================
botaoNovo.addEventListener("click", abrirNovoProduto);
botaoCancelar.addEventListener("click", fecharModal);

// salvar (clique no botão ou Enter dentro do formulário)
formulario.addEventListener("submit", function (e) {
    e.preventDefault();   // impede a página de recarregar
    salvarProduto();
});

// máscaras de dinheiro: formatam enquanto digita
inputCusto.addEventListener("input", function () {
    inputCusto.value = mascaraDinheiro(inputCusto.value);
});
inputVenda.addEventListener("input", function () {
    inputVenda.value = mascaraDinheiro(inputVenda.value);
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


// =====================================================
//  COMEÇANDO
// =====================================================
async function iniciar() {
    await carregarCategorias();   // primeiro as categorias, para os nomes aparecerem na tabela
    await carregarProdutos();
}

iniciar();