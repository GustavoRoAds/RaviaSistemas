const paginaProdutos = document.querySelector('.prod-pagina');
const campoBuscaProduto = document.getElementById('prod-busca');
const corpoTabelaProdutos = document.getElementById('prod-corpo');
const contadorProdutos = document.getElementById('prod-quantidade');

const API_PRODUTOS = paginaProdutos?.dataset.apiUrl;
const API_CATEGORIAS = paginaProdutos?.dataset.categoriasUrl;

let produtos = [];
let categorias = [];

function obterCampo(objeto, nomes, padrao = '') {
    for (const nome of nomes) {
        if (objeto && objeto[nome] !== undefined && objeto[nome] !== null) {
            return objeto[nome];
        }
    }

    return padrao;
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

function nomeProduto(produto) {
    return obterCampo(produto, [
        'nomeProduto',
        'nome',
        'nome_produto'
    ], 'Sem nome');
}

function descricaoProduto(produto) {
    return obterCampo(produto, [
        'descricaoProduto',
        'descricao',
        'descricao_produto'
    ], '');
}

function idCategoria(categoria) {
    return obterCampo(categoria, [
        'id',
        'categoria_id',
        'idCategoria',
        'codigo'
    ], '');
}

function nomeCategoria(categoria) {
    return obterCampo(categoria, [
        'nomeCategoria',
        'nome',
        'descricaoCategoria',
        'descricao',
        'categoria',
        'titulo'
    ], '');
}

function categoriaProduto(produto) {
    const nomeDireto = obterCampo(produto, [
        'nomeCategoria',
        'categoriaNome',
        'descricaoCategoria'
    ], '');

    if (nomeDireto !== '') {
        return nomeDireto;
    }

    const categoriaDireta = obterCampo(produto, [
        'categoria',
        'categoria_id',
        'categoriaId',
        'idCategoria'
    ], '');

    if (categoriaDireta === '' || categoriaDireta === null) {
        return '—';
    }

    if (typeof categoriaDireta === 'string' && !/^\d+$/.test(categoriaDireta)) {
        return categoriaDireta;
    }

    const categoriaEncontrada = categorias.find(categoria =>
        String(idCategoria(categoria)) === String(categoriaDireta)
    );

    return categoriaEncontrada ? nomeCategoria(categoriaEncontrada) || '—' : '—';
}

function formatarMoeda(valor) {
    if (valor === '' || valor === null || valor === undefined) {
        return '—';
    }

    const numero = Number(String(valor).replace(',', '.'));

    if (!Number.isFinite(numero)) {
        return '—';
    }

    return numero.toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL'
    });
}

function custoProduto(produto) {
    return obterCampo(produto, [
        'valorCusto',
        'custo',
        'valor_custo',
        'precoCusto'
    ], '');
}

function vendaProduto(produto) {
    return obterCampo(produto, [
        'valorVenda',
        'valor',
        'preco',
        'valor_venda',
        'precoVenda'
    ], '');
}

function estoqueProduto(produto) {
    return obterCampo(produto, [
        'estoque',
        'quantidadeEstoque',
        'qtdEstoque',
        'quantidade'
    ], '—');
}

function renderizarProdutos(lista) {
    corpoTabelaProdutos.innerHTML = '';

    contadorProdutos.textContent =
        `${lista.length} ${lista.length === 1 ? 'produto cadastrado' : 'produtos cadastrados'}`;

    if (lista.length === 0) {
        corpoTabelaProdutos.innerHTML = `
            <tr>
                <td colspan="5" class="prod-vazio">
                    Nenhum produto encontrado.
                </td>
            </tr>
        `;
        return;
    }

    lista.forEach(produto => {
        const nome = nomeProduto(produto);
        const descricao = descricaoProduto(produto);
        const categoria = categoriaProduto(produto);
        const custo = custoProduto(produto);
        const venda = vendaProduto(produto);
        const estoque = estoqueProduto(produto);

        const linha = document.createElement('tr');

        linha.innerHTML = `
            <td>
                <span class="prod-nome">${escaparHTML(nome)}</span>
                ${descricao ? `<span class="prod-descricao">${escaparHTML(descricao)}</span>` : ''}
            </td>
            <td>${escaparHTML(categoria)}</td>
            <td class="prod-custo">${escaparHTML(formatarMoeda(custo))}</td>
            <td class="prod-venda">${escaparHTML(formatarMoeda(venda))}</td>
            <td class="prod-estoque">${escaparHTML(estoque)}</td>
        `;

        corpoTabelaProdutos.appendChild(linha);
    });
}

function filtrarProdutos() {
    const busca = campoBuscaProduto.value.trim().toLocaleLowerCase('pt-BR');

    if (!busca) {
        renderizarProdutos(produtos);
        return;
    }

    const filtrados = produtos.filter(produto => {
        const nome = nomeProduto(produto);
        const descricao = descricaoProduto(produto);
        const categoria = categoriaProduto(produto);

        return `${nome} ${descricao} ${categoria}`
            .toLocaleLowerCase('pt-BR')
            .includes(busca);
    });

    renderizarProdutos(filtrados);
}

async function carregarCategorias() {
    if (!API_CATEGORIAS) {
        categorias = [];
        return;
    }

    try {
        const resposta = await fetch(API_CATEGORIAS);
        const dados = await resposta.json();

        if (resposta.ok && Array.isArray(dados)) {
            categorias = dados;
        }
    } catch (erro) {
        console.error('Não foi possível carregar as categorias:', erro);
        categorias = [];
    }
}

async function carregarProdutos() {
    try {
        const resposta = await fetch(API_PRODUTOS);
        const dados = await resposta.json();

        if (!resposta.ok || !Array.isArray(dados)) {
            throw new Error(dados?.erro || 'Resposta inválida da API.');
        }

        produtos = dados;

        await carregarCategorias();
        filtrarProdutos();
    } catch (erro) {
        console.error('Erro ao carregar produtos:', erro);

        contadorProdutos.textContent = 'Não foi possível carregar os produtos';

        corpoTabelaProdutos.innerHTML = `
            <tr>
                <td colspan="5" class="prod-vazio">
                    Não foi possível carregar os produtos. Verifique a conexão com a API.
                </td>
            </tr>
        `;
    }
}

campoBuscaProduto.addEventListener('input', filtrarProdutos);

carregarProdutos();