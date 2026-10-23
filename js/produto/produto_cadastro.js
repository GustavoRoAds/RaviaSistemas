const paginaCadastroProduto = document.querySelector('.prod-pagina');
const formularioProduto = document.getElementById('prod-form');
const mensagemProduto = document.getElementById('prod-erro');
const botaoSalvarProduto = document.getElementById('prod-btn-salvar');

const campoIdProduto = document.getElementById('prod-id');
const campoNomeProduto = document.getElementById('prod-nome');
const campoDescricaoProduto = document.getElementById('prod-descricao');
const campoCategoriaProduto = document.getElementById('prod-categoria');
const campoCustoProduto = document.getElementById('prod-custo');
const campoVendaProduto = document.getElementById('prod-venda');
const campoEstoqueProduto = document.getElementById('prod-estoque');

const API_PRODUTOS_CADASTRO = paginaCadastroProduto?.dataset.apiUrl;
const API_CATEGORIAS_CADASTRO = paginaCadastroProduto?.dataset.categoriasUrl;

let modoEdicaoProduto = false;
let produtoExistenteConsultado = false;
let categoriasProduto = [];

function mostrarMensagemProduto(texto, sucesso = false) {
    mensagemProduto.textContent = texto;
    mensagemProduto.classList.toggle('sucesso', sucesso);
}

function limparMensagemProduto() {
    mensagemProduto.textContent = '';
    mensagemProduto.classList.remove('sucesso');
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

function formatarCampoMoeda(valor) {
    if (valor === '' || valor === null || valor === undefined) {
        return '';
    }

    const numero = Number(String(valor).replace(',', '.'));

    if (!Number.isFinite(numero)) {
        return '';
    }

    return numero.toLocaleString('pt-BR', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function aplicarMascaraMoeda(campo) {
    campo.addEventListener('input', function () {
        const numeros = campo.value.replace(/\D/g, '');

        if (numeros === '') {
            campo.value = '';
            return;
        }

        const valor = Number(numeros) / 100;

        campo.value = valor.toLocaleString('pt-BR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    });
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

        categoriasProduto = dados;

        campoCategoriaProduto.innerHTML =
            '<option value="">Sem categoria</option>';

        dados.forEach(categoria => {
            const id = obterIdCategoria(categoria);
            const nome = obterNomeCategoria(categoria);

            if (id === '' || nome === '') {
                return;
            }

            const opcao = document.createElement('option');
            opcao.value = String(id);
            opcao.textContent = nome;

            campoCategoriaProduto.appendChild(opcao);
        });
    } catch (erro) {
        console.error('Erro ao carregar categorias:', erro);
        mostrarMensagemProduto(
            'Não foi possível carregar as categorias. Confira a conexão com a API de categorias.'
        );
    }
}

function preencherCategoriaProduto(valorCategoria) {
    if (valorCategoria === '' || valorCategoria === null || valorCategoria === undefined) {
        campoCategoriaProduto.value = '';
        return;
    }

    const valor = String(valorCategoria);

    let opcao = Array.from(campoCategoriaProduto.options).find(item =>
        item.value === valor || item.textContent.trim() === valor
    );

    if (!opcao) {
        const categoriaEncontrada = categoriasProduto.find(item =>
            String(obterIdCategoria(item)) === valor ||
            obterNomeCategoria(item).trim() === valor
        );

        if (categoriaEncontrada) {
            opcao = Array.from(campoCategoriaProduto.options).find(item =>
                item.value === String(obterIdCategoria(categoriaEncontrada))
            );
        }
    }

    if (opcao) {
        campoCategoriaProduto.value = opcao.value;
    } else {
        const novaOpcao = document.createElement('option');
        novaOpcao.value = valor;
        novaOpcao.textContent = valor;
        campoCategoriaProduto.appendChild(novaOpcao);
        campoCategoriaProduto.value = valor;
    }
}

function preencherFormularioProduto(produto) {
    campoIdProduto.value = produto.id ?? '';
    campoNomeProduto.value = produto.nome ?? '';
    campoDescricaoProduto.value = produto.descricao ?? '';

    preencherCategoriaProduto(produto.categoria ?? '');

    campoCustoProduto.value = formatarCampoMoeda(produto.valor_custo ?? 0);
    campoVendaProduto.value = formatarCampoMoeda(produto.valor_venda ?? 0);
    campoEstoqueProduto.value = produto.estoque ?? 0;
}

function definirModoEdicaoProduto(ativo) {
    modoEdicaoProduto = ativo;
    campoIdProduto.readOnly = ativo;

    document.querySelector('.prod-topo h1').textContent =
        ativo ? 'Editar Produto' : 'Novo Produto';

    document.querySelector('.prod-topo .migalhas span:last-child').textContent =
        ativo ? 'Editar produto' : 'Novo produto';

    botaoSalvarProduto.textContent =
        ativo ? 'Salvar alterações' : 'Salvar produto';
}

async function consultarProdutoPorId(id, edicao = false) {
    if (!id || !/^\d+$/.test(String(id))) {
        mostrarMensagemProduto('Informe um código numérico válido.');
        return false;
    }

    try {
        const resposta = await fetch(
            `${API_PRODUTOS_CADASTRO}?id=${encodeURIComponent(id)}`
        );

        const produto = await resposta.json();

        if (!resposta.ok || produto.erro) {
            produtoExistenteConsultado = false;

            if (edicao) {
                mostrarMensagemProduto('Produto não encontrado.');
            } else {
                mostrarMensagemProduto(
                    'Não existe produto com esse código. Para cadastrar um novo produto, deixe o campo Código vazio.'
                );
            }

            return false;
        }

        preencherFormularioProduto(produto);
        produtoExistenteConsultado = true;

        definirModoEdicaoProduto(edicao);

        if (edicao) {
            mostrarMensagemProduto('Produto carregado para edição.', true);
        } else {
            mostrarMensagemProduto(
                `O produto com código ${produto.id} já existe. Os dados foram carregados apenas para consulta. Para alterá-lo, use o botão Editar na listagem.`
            );
        }

        return true;
    } catch (erro) {
        console.error('Erro ao consultar produto:', erro);
        mostrarMensagemProduto('Não foi possível consultar a API de produtos.');
        return false;
    }
}

campoIdProduto.addEventListener('keydown', async function (evento) {
    if (evento.key === 'Enter') {
        evento.preventDefault();

        if (modoEdicaoProduto) {
            return;
        }

        limparMensagemProduto();

        const id = campoIdProduto.value.trim();

        if (id !== '') {
            await consultarProdutoPorId(id, false);
        }
    }
});

formularioProduto.addEventListener('submit', async function (evento) {
    evento.preventDefault();
    limparMensagemProduto();

    const nome = campoNomeProduto.value.trim();
    const descricao = campoDescricaoProduto.value.trim();
    const custoTexto = campoCustoProduto.value.trim();
    const vendaTexto = campoVendaProduto.value.trim();
    const estoqueTexto = campoEstoqueProduto.value.trim();
    const estoque = Number(estoqueTexto);
    const codigoDigitado = campoIdProduto.value.trim();

    if (nome === '') {
        mostrarMensagemProduto('Informe o nome do produto.');
        campoNomeProduto.focus();
        return;
    }

    if (vendaTexto === '') {
        mostrarMensagemProduto('Informe o valor de venda.');
        campoVendaProduto.focus();
        return;
    }

    const valorVenda = converterValorProduto(vendaTexto);
    const valorCusto = converterValorProduto(custoTexto);

    if (valorVenda === null || !Number.isFinite(valorVenda) || valorVenda < 0) {
        mostrarMensagemProduto('Informe um valor de venda válido.');
        campoVendaProduto.focus();
        return;
    }

    if (custoTexto !== '' &&
        (valorCusto === null || !Number.isFinite(valorCusto) || valorCusto < 0)) {
        mostrarMensagemProduto('Informe um valor de custo válido.');
        campoCustoProduto.focus();
        return;
    }

    if (
        estoqueTexto === '' ||
        !Number.isInteger(estoque) ||
        estoque < 0
    ) {
        mostrarMensagemProduto(
            'Informe uma quantidade inteira de estoque, igual ou maior que zero.'
        );
        campoEstoqueProduto.focus();
        return;
    }

    // O ID é gerado automaticamente pelo banco ao cadastrar.
    // Se houver um código digitado em modo de cadastro, ele não pode ser reutilizado.
    if (!modoEdicaoProduto && codigoDigitado !== '') {
    let encontrado = produtoExistenteConsultado;

    if (!encontrado) {
        encontrado = await consultarProdutoPorId(codigoDigitado, false);
    }

    if (encontrado) {
        mostrarMensagemProduto(
            `O código ${codigoDigitado} já existe. Para alterar esse produto, use o botão Editar na listagem. Para cadastrar um novo produto, limpe o campo Código.`
        );
    } else {
        mostrarMensagemProduto(
            `Não foi encontrado um produto com o código ${codigoDigitado}. Para cadastrar um produto novo, deixe o campo Código vazio, pois o banco gera o ID automaticamente.`
        );
    }

    campoIdProduto.focus();
    return;
}

    const categoriaSelecionada =
        campoCategoriaProduto.selectedOptions[0]?.textContent.trim() ?? '';

    const produto = {
        nome: nome,
        descricao: descricao || null,
        categoria: categoriaSelecionada === 'Sem categoria' ? null : categoriaSelecionada,
        custo: valorCusto ?? 0,
        valor: valorVenda,
        preco: valorVenda,
        estoque: estoque
    };

    botaoSalvarProduto.disabled = true;
    botaoSalvarProduto.textContent = modoEdicaoProduto
        ? 'Salvando alterações...'
        : 'Salvando...';

    try {
        const url = modoEdicaoProduto
            ? `${API_PRODUTOS_CADASTRO}?id=${encodeURIComponent(campoIdProduto.value)}`
            : API_PRODUTOS_CADASTRO;

        const resposta = await fetch(url, {
            method: modoEdicaoProduto ? 'PUT' : 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(produto)
        });

        const dados = await resposta.json();

        if (resposta.status === 201 && !modoEdicaoProduto) {
            const novoId = dados.id;

            formularioProduto.reset();
            campoIdProduto.value = '';
            produtoExistenteConsultado = false;

            mostrarMensagemProduto(
                `Produto cadastrado com sucesso. Código: ${novoId}.`,
                true
            );
        } else if (resposta.ok && modoEdicaoProduto) {
            mostrarMensagemProduto('Produto atualizado com sucesso.', true);
        } else {
            mostrarMensagemProduto(
                dados?.erro || 'Não foi possível salvar o produto.'
            );
        }
    } catch (erro) {
        console.error('Erro ao salvar produto:', erro);
        mostrarMensagemProduto('Não foi possível conectar à API de produtos.');
    } finally {
        botaoSalvarProduto.disabled = false;
        botaoSalvarProduto.textContent = modoEdicaoProduto
            ? 'Salvar alterações'
            : 'Salvar produto';
    }
});

document.getElementById('prod-limpar').addEventListener('click', function () {
    if (modoEdicaoProduto) {
        window.location.href = 'produto_cadastro.php';
        return;
    }

    formularioProduto.reset();
    campoIdProduto.readOnly = false;
    produtoExistenteConsultado = false;
    limparMensagemProduto();
    definirModoEdicaoProduto(false);
});

async function iniciarCadastroProduto() {
    await carregarCategoriasProduto();

    const parametros = new URLSearchParams(window.location.search);
    const id = parametros.get('id');

    if (id) {
        await consultarProdutoPorId(id, true);
    } else {
        definirModoEdicaoProduto(false);
    }
}

aplicarMascaraMoeda(campoCustoProduto);
aplicarMascaraMoeda(campoVendaProduto);

iniciarCadastroProduto();