const BASE = '/RaviaSistemas';

const inputProduto  = document.getElementById('busca-produto');
const listaProdutos = document.getElementById('lista-produtos');
const elItensLista  = document.getElementById('itens-lista');
const elItensVazio  = document.getElementById('itens-vazio');
const elDescValor   = document.getElementById('desconto-valor');
const elDescPerc    = document.getElementById('desconto-percentual');
const elAcrescimo   = document.getElementById('acrescimo');
const elBtnConfirma = document.getElementById('btn-confirmar');

const itens = [];
let timer;

function moeda(v) {
    return Number(v).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

function lerNumero(texto) {
    const n = parseFloat(String(texto).replace(/\./g, '').replace(',', '.'));
    return isNaN(n) ? 0 : n;
}

let controle = null;

async function buscarProdutos(q) {
    if (controle) controle.abort();
    controle = new AbortController();

    try {
        const resp = await fetch(
            BASE + '/api/produto/produtos.php?busca=' + encodeURIComponent(q),
            { signal: controle.signal }
        );
        const produtos = await resp.json();

        if (!resp.ok || !Array.isArray(produtos)) {
            throw new Error('Resposta inválida');
        }
        mostrarProdutos(produtos);

    } catch (e) {
        if (e.name === 'AbortError') return;
        listaProdutos.innerHTML = '<div class="venda-sem-resultado">Erro ao buscar</div>';
        listaProdutos.classList.add('aberta');
    }
}

inputProduto.addEventListener('focus', () => {
    buscarProdutos(inputProduto.value.trim());
});

inputProduto.addEventListener('click', () => {
    if (!listaProdutos.classList.contains('aberta')) {
        buscarProdutos(inputProduto.value.trim());
    }
});

inputProduto.addEventListener('input', () => {
    clearTimeout(timer);
    timer = setTimeout(() => buscarProdutos(inputProduto.value.trim()), 150);
});

function mostrarProdutos(produtos) {
    listaProdutos.innerHTML = '';

    if (!produtos.length) {
        listaProdutos.innerHTML = '<div class="venda-sem-resultado">Nenhum produto encontrado</div>';
    } else {
        produtos.slice(0, 30).forEach(p => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'venda-opcao';
            btn.innerHTML = '<span></span><span class="venda-opcao-detalhe"></span>';
            btn.children[0].textContent = p.nome;
            btn.children[1].textContent = moeda(p.valor_venda);
            btn.addEventListener('click', () => {
                adicionarItem(p);
                inputProduto.value = '';
                listaProdutos.classList.remove('aberta');
            });
            listaProdutos.appendChild(btn);
        });
    }
    listaProdutos.classList.add('aberta');
}

document.addEventListener('click', (e) => {
    if (!e.target.closest('#venda-busca-produto')) {
        listaProdutos.classList.remove('aberta');
    }
});

function adicionarItem(produto) {
    const id = Number(produto.id);
    const existente = itens.find(i => i.id === id);

    if (existente) {
        existente.qtd += 1;
    } else {
        itens.push({
            id: id,
            nome: produto.nome,
            preco: Number(produto.valor_venda),
            qtd: 1
        });
    }
    desenharItens();
}

function removerItem(id) {
    const pos = itens.findIndex(i => i.id === id);
    if (pos >= 0) itens.splice(pos, 1);
    desenharItens();
}

function mudarQtd(id, qtd) {
    const item = itens.find(i => i.id === id);
    if (!item) return;
    item.qtd = Math.max(1, parseInt(qtd, 10) || 1);
    desenharItens();
}

function desenharItens() {
    elItensLista.innerHTML = '';
    elItensVazio.style.display = itens.length ? 'none' : 'flex';

    itens.forEach(item => {
        const li = document.createElement('li');
        li.className = 'venda-item';

        const info = document.createElement('div');
        info.className = 'venda-item-info';
        const nome = document.createElement('span');
        nome.className = 'venda-item-nome';
        nome.textContent = item.nome;
        const unit = document.createElement('span');
        unit.className = 'venda-item-unit';
        unit.textContent = moeda(item.preco) + ' un.';
        info.append(nome, unit);

        const qtdBox = document.createElement('div');
        qtdBox.className = 'venda-item-qtd';

        const menos = document.createElement('button');
        menos.type = 'button';
        menos.className = 'venda-qtd-btn';
        menos.textContent = '−';
        menos.addEventListener('click', () => mudarQtd(item.id, item.qtd - 1));

        const campo = document.createElement('input');
        campo.type = 'text';
        campo.className = 'venda-qtd-input';
        campo.inputMode = 'numeric';
        campo.value = item.qtd;
        campo.addEventListener('change', () => mudarQtd(item.id, campo.value));

        const mais = document.createElement('button');
        mais.type = 'button';
        mais.className = 'venda-qtd-btn';
        mais.textContent = '+';
        mais.addEventListener('click', () => mudarQtd(item.id, item.qtd + 1));

        qtdBox.append(menos, campo, mais);

        const sub = document.createElement('div');
        sub.className = 'venda-item-subtotal';
        sub.textContent = moeda(item.preco * item.qtd);

        const remover = document.createElement('button');
        remover.type = 'button';
        remover.className = 'venda-item-remover';
        remover.setAttribute('aria-label', 'Remover item');
        remover.innerHTML = '&times;';
        remover.addEventListener('click', () => removerItem(item.id));

        li.append(info, qtdBox, sub, remover);
        elItensLista.appendChild(li);
    });

    atualizarResumo();
}

function atualizarResumo() {
    const subtotal = itens.reduce((s, i) => s + i.preco * i.qtd, 0);

    const perc = lerNumero(elDescPerc.value);
    let desconto = perc > 0 ? subtotal * (perc / 100) : lerNumero(elDescValor.value);
    desconto = Math.min(desconto, subtotal);

    const acrescimo = lerNumero(elAcrescimo.value);
    const total = subtotal - desconto + acrescimo;

    document.getElementById('resumo-subtotal').textContent  = moeda(subtotal);
    document.getElementById('resumo-desconto').textContent  = '- ' + moeda(desconto);
    document.getElementById('resumo-acrescimo').textContent = '+ ' + moeda(acrescimo);
    document.getElementById('venda-total').textContent      = moeda(total);

    elBtnConfirma.disabled = itens.length === 0;
}

[elDescValor, elDescPerc, elAcrescimo].forEach(el =>
    el.addEventListener('input', atualizarResumo)
);

desenharItens();