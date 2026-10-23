const paginaProdutos = document.querySelector('.prod-pagina');
const campoBuscaProduto = document.getElementById('prod-busca');
const corpoTabelaProdutos = document.getElementById('prod-corpo');
const contadorProdutos = document.getElementById('prod-quantidade');

const API_PRODUTOS = paginaProdutos?.dataset.apiUrl;
const API_CATEGORIAS = paginaProdutos?.dataset.categoriasUrl;

let produtos = [];
let categorias = [];

// Obtém o primeiro campo existente no objeto.
function obterCampo(objeto, nomes, padrao = '') {
    for (const nome of nomes) {
        if (
            objeto &&
            objeto[nome] !== undefined &&
            objeto[nome] !== null
        ) {
            return objeto[nome];
        }
    }

    return padrao;
}

// Evita que textos vindos do banco sejam interpretados como HTML.
function escaparHTML(valor) {
    return String(valor ?? '').replace(/[&<>"']/g, caractere => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    })[caractere]);
}

// Dados do produto.
function idProduto(produto) {
    return obterCampo(produto, ['id', 'codigo'], '');
}

function nomeProduto(produto) {
    return obterCampo(
        produto,
        ['nome', 'nomeProduto', 'nome_produto'],
        'Sem nome'
    );
}

function descricaoProduto(produto) {
    return obterCampo(
        produto,
        ['descricao', 'descricaoProduto', 'descricao_produto'],
        ''
    );
}

function custoProduto(produto) {
    return obterCampo(
        produto,
        ['valor_custo', 'valorCusto', 'custo', 'precoCusto'],
        ''
    );
}

function vendaProduto(produto) {
    return obterCampo(
        produto,
        ['valor_venda', 'valorVenda', 'valor', 'preco', 'precoVenda'],
        ''
    );
}

function estoqueProduto(produto) {
    return obterCampo(
        produto,
        ['estoque', 'quantidadeEstoque', 'qtdEstoque', 'quantidade'],
        '—'
    );
}

// Dados das categorias.
function idCategoria(categoria) {
    return obterCampo(
        categoria,
        ['id', 'categoria_id', 'idCategoria', 'codigo'],
        ''
    );
}

function nomeCategoria(categoria) {
    return obterCampo(
        categoria,
        [
            'nomeCategoria',
            'nome',
            'descricaoCategoria',
            'descricao',
            'categoria',
            'titulo'
        ],
        ''
    );
}

function categoriaProduto(produto) {
    const categoria = obterCampo(
        produto,
        ['categoria', 'nomeCategoria', 'categoriaNome', 'categoria_id'],
        ''
    );

    if (categoria === '') {
        return '—';
    }

    // Se a API já retornar o nome da categoria, usa esse nome.
    if (
        typeof categoria === 'string' &&
        !/^\d+$/.test(categoria)
    ) {
        return categoria;
    }

    // Se retornar o ID, tenta localizar o nome da categoria.
    const encontrada = categorias.find(item =>
        String(idCategoria(item)) === String(categoria)
    );

    return encontrada
        ? nomeCategoria(encontrada) || '—'
        : '—';
}

// Formata valores monetários para reais.
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

// Monta a tabela de produtos.
function renderizarProdutos(lista) {
    corpoTabelaProdutos.innerHTML = '';

    contadorProdutos.textContent =
        `${lista.length} ${lista.length === 1
            ? 'produto cadastrado'
            : 'produtos cadastrados'}`;

    if (lista.length === 0) {
        corpoTabelaProdutos.innerHTML = `
            <tr>
                <td colspan="6" class="prod-vazio">
                    Nenhum produto encontrado.
                </td>
            </tr>
        `;
        return;
    }

    lista.forEach(produto => {
        const id = idProduto(produto);
        const nome = nomeProduto(produto);
        const descricao = descricaoProduto(produto);
        const categoria = categoriaProduto(produto);
        const custo = custoProduto(produto);
        const venda = vendaProduto(produto);
        const estoque = estoqueProduto(produto);

        const inicial = String(nome).trim().charAt(0).toUpperCase();

        const linha = document.createElement('tr');

        linha.innerHTML = `
            <td>
                <div class="produto-identificacao">
                    <span class="avatar-produto">
                        ${escaparHTML(inicial || 'P')}
                    </span>

                    <div class="produto-textos">
                        <span class="prod-nome">
                            ${escaparHTML(id)} - ${escaparHTML(nome)}
                        </span>

                        ${descricao ? `
                            <span class="prod-descricao">
                                ${escaparHTML(descricao)}
                            </span>
                        ` : ''}
                    </div>
                </div>
            </td>

            <td>${escaparHTML(categoria)}</td>

            <td class="prod-custo">
                ${escaparHTML(formatarMoeda(custo))}
            </td>

            <td class="prod-venda">
                ${escaparHTML(formatarMoeda(venda))}
            </td>

            <td class="prod-estoque">
                ${escaparHTML(estoque)}
            </td>

            <td class="coluna-acoes">
                <a
                    href="produto_cadastro.php?id=${encodeURIComponent(id)}"
                    class="botao-editar"
                    title="Editar produto"
                    aria-label="Editar ${escaparHTML(nome)}"
                >
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="16"
                        height="16"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >
                        <path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z"></path>
                    </svg>
                </a>
            </td>
        `;

        corpoTabelaProdutos.appendChild(linha);
    });
}

// Filtra os produtos enquanto a pessoa digita.
function filtrarProdutos() {
    const busca = campoBuscaProduto.value
        .trim()
        .toLocaleLowerCase('pt-BR');

    if (!busca) {
        renderizarProdutos(produtos);
        return;
    }

    const filtrados = produtos.filter(produto => {
        const texto = [
            idProduto(produto),
            nomeProduto(produto),
            descricaoProduto(produto),
            categoriaProduto(produto)
        ]
            .join(' ')
            .toLocaleLowerCase('pt-BR');

        return texto.includes(busca);
    });

    renderizarProdutos(filtrados);
}

// Carrega as categorias para exibir seus nomes quando disponíveis.
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
        } else {
            console.error(
                'Não foi possível carregar as categorias:',
                dados
            );
        }
    } catch (erro) {
        console.error(
            'Erro ao carregar categorias:',
            erro
        );

        categorias = [];
    }
}

// Carrega os produtos diretamente da API.
async function carregarProdutos() {
    try {
        const resposta = await fetch(API_PRODUTOS);
        const dados = await resposta.json();

        if (!resposta.ok || !Array.isArray(dados)) {
            throw new Error(
                dados?.erro || 'Resposta inválida da API.'
            );
        }

        produtos = dados;

        await carregarCategorias();

        filtrarProdutos();
    } catch (erro) {
        console.error('Erro ao carregar produtos:', erro);

        contadorProdutos.textContent =
            'Não foi possível carregar os produtos';

        corpoTabelaProdutos.innerHTML = `
            <tr>
                <td colspan="6" class="prod-vazio">
                    Não foi possível carregar os produtos.
                    Verifique a conexão com a API.
                </td>
            </tr>
        `;
    }
}

// Eventos e inicialização.
campoBuscaProduto.addEventListener('input', filtrarProdutos);

carregarProdutos();