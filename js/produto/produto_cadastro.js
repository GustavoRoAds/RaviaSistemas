const paginaCadastroProduto = document.querySelector('.prod-pagina');
const formularioProduto = document.getElementById('prod-form');
const mensagemProduto = document.getElementById('prod-erro');
const botaoSalvarProduto = document.getElementById('prod-btn-salvar');
const campoCategoriaProduto = document.getElementById('prod-categoria');

const API_PRODUTOS_CADASTRO = paginaCadastroProduto?.dataset.apiUrl;
const API_CATEGORIAS_CADASTRO = paginaCadastroProduto?.dataset.categoriasUrl;

function mostrarMensagemProduto(texto, sucesso = false) {
    mensagemProduto.textContent = texto;
    mensagemProduto.classList.toggle('sucesso', sucesso);
}

function obterIdCategoria(categoria) {
    return categoria.id
        ?? categoria.categoria_id
        ?? categoria.idCategoria
        ?? categoria.codigo
        ?? '';
}

function obterNomeCategoria(categoria) {
    return categoria.nomeCategoria
        ?? categoria.nome
        ?? categoria.descricaoCategoria
        ?? categoria.descricao
        ?? categoria.categoria
        ?? categoria.titulo
        ?? '';
}

async function carregarCategoriasProduto() {
    try {
        const resposta = await fetch(API_CATEGORIAS_CADASTRO);
        const dados = await resposta.json();

        if (!resposta.ok || !Array.isArray(dados)) {
            throw new Error(dados?.erro || 'Não foi possível carregar as categorias.');
        }

        campoCategoriaProduto.innerHTML = '<option value="">Sem categoria</option>';

        dados.forEach(categoria => {
            const id = obterIdCategoria(categoria);
            const nome = obterNomeCategoria(categoria);

            if (id === '' || nome === '') {
                return;
            }

            const opcao = document.createElement('option');
            opcao.value = id;
            opcao.textContent = nome;

            campoCategoriaProduto.appendChild(opcao);
        });
    } catch (erro) {
        console.error('Erro ao carregar categorias:', erro);
        mostrarMensagemProduto(
            'Não foi possível carregar as categorias. Você ainda pode cadastrar o produto sem categoria.'
        );
    }
}

function converterValorProduto(valor) {
    let texto = String(valor ?? '')
        .trim()
        .replace(/\s/g, '')
        .replace(/^R\$/i, '');

    if (texto.includes(',')) {
        texto = texto.replace(/\./g, '').replace(',', '.');
    }

    if (texto === '') {
        return null;
    }

    const numero = Number(texto);

    return Number.isFinite(numero) ? numero : NaN;
}

function limparFormularioProduto() {
    formularioProduto.reset();
    mensagemProduto.textContent = '';
    mensagemProduto.classList.remove('sucesso');
}

formularioProduto.addEventListener('submit', async function (evento) {
    evento.preventDefault();

    mensagemProduto.textContent = '';
    mensagemProduto.classList.remove('sucesso');

    const nome = document.getElementById('prod-nome').value.trim();
    const descricao = document.getElementById('prod-descricao').value.trim();
    const custoTexto = document.getElementById('prod-custo').value.trim();
    const vendaTexto = document.getElementById('prod-venda').value.trim();
    const categoriaId = campoCategoriaProduto.value;

    if (nome === '') {
        mostrarMensagemProduto('Informe o nome do produto.');
        document.getElementById('prod-nome').focus();
        return;
    }

    if (vendaTexto === '') {
        mostrarMensagemProduto('Informe o valor de venda.');
        document.getElementById('prod-venda').focus();
        return;
    }

    const valorVenda = converterValorProduto(vendaTexto);
    const valorCusto = converterValorProduto(custoTexto);

    if (valorVenda === null || !Number.isFinite(valorVenda) || valorVenda < 0) {
        mostrarMensagemProduto('Informe um valor de venda válido.');
        document.getElementById('prod-venda').focus();
        return;
    }

    if (custoTexto !== '' &&
        (valorCusto === null || !Number.isFinite(valorCusto) || valorCusto < 0)) {
        mostrarMensagemProduto('Informe um valor de custo válido.');
        document.getElementById('prod-custo').focus();
        return;
    }

    const produto = {
        nome: nome,
        descricao: descricao || null,
        custo: valorCusto,
        valor: valorVenda,
        preco: valorVenda
    };

    if (categoriaId !== '') {
        produto.categoria_id = categoriaId;
    }

    botaoSalvarProduto.disabled = true;
    botaoSalvarProduto.textContent = 'Salvando...';

    try {
        const resposta = await fetch(API_PRODUTOS_CADASTRO, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(produto)
        });

        const dados = await resposta.json();

        if (resposta.status === 201) {
            mostrarMensagemProduto(
                `Produto cadastrado com sucesso. Código: ${dados.id}.`,
                true
            );

            formularioProduto.reset();
        } else {
            mostrarMensagemProduto(
                dados?.erro || 'Não foi possível cadastrar o produto.'
            );
        }
    } catch (erro) {
        console.error('Erro ao cadastrar produto:', erro);
        mostrarMensagemProduto('Não foi possível conectar à API de produtos.');
    } finally {
        botaoSalvarProduto.disabled = false;
        botaoSalvarProduto.textContent = 'Salvar produto';
    }
});

document.getElementById('prod-limpar').addEventListener('click', function () {
    limparFormularioProduto();
});

carregarCategoriasProduto();