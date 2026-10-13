const Notificacao = (function () {
    const CHAVE = 'notificacao_pendente';
    const DURACAO_PADRAO = 4000;

    const TIPOS = {
        sucesso: { icone: '✓', titulo: 'Sucesso' },
        erro:    { icone: '✕', titulo: 'Erro' },
        atencao: { icone: '!', titulo: 'Atenção' },
        info:    { icone: 'i', titulo: 'Informação' }
    };

    let container = null;

    function obterContainer() {
        if (!container) {
            container = document.createElement('div');
            container.id = 'notificacoes';
            container.setAttribute('aria-live', 'polite');
            document.body.appendChild(container);
        }
        return container;
    }

    function criarElemento(tag, classe, texto) {
        const elemento = document.createElement(tag);
        elemento.className = classe;
        if (texto !== undefined) {
            elemento.textContent = texto;
        }
        return elemento;
    }

    function fechar(notificacao) {
        if (notificacao.dataset.fechando) return;

        notificacao.dataset.fechando = '1';
        notificacao.classList.add('notificacao-saindo');

        setTimeout(function () {
            notificacao.remove();
        }, 200);
    }

    function mostrar(tipo, texto, opcoes) {
        const tipoValido = TIPOS[tipo] ? tipo : 'info';
        const config = TIPOS[tipoValido];
        const op = opcoes || {};
        const duracao = op.duracao !== undefined ? op.duracao : DURACAO_PADRAO;

        const notificacao = criarElemento('div', 'notificacao notificacao-' + tipoValido);
        notificacao.setAttribute('role', tipoValido === 'erro' ? 'alert' : 'status');

        const icone = criarElemento('span', 'notificacao-icone', config.icone);

        const corpo = criarElemento('div', 'notificacao-corpo');
        corpo.appendChild(criarElemento('strong', 'notificacao-titulo', op.titulo || config.titulo));
        corpo.appendChild(criarElemento('span', 'notificacao-texto', texto));

        const botaoFechar = criarElemento('button', 'notificacao-fechar', '×');
        botaoFechar.type = 'button';
        botaoFechar.setAttribute('aria-label', 'Fechar');
        botaoFechar.addEventListener('click', function () {
            fechar(notificacao);
        });

        notificacao.appendChild(icone);
        notificacao.appendChild(corpo);
        notificacao.appendChild(botaoFechar);

        if (duracao > 0) {
            const barra = criarElemento('div', 'notificacao-barra');
            barra.style.animationDuration = duracao + 'ms';
            barra.addEventListener('animationend', function () {
                fechar(notificacao);
            });
            notificacao.appendChild(barra);
        }

        obterContainer().appendChild(notificacao);
        return notificacao;
    }

    function agendar(tipo, texto, opcoes) {
        try {
            sessionStorage.setItem(CHAVE, JSON.stringify({ tipo: tipo, texto: texto, opcoes: opcoes }));
        } catch (erro) {
            console.error(erro);
        }
    }

    function exibirPendente() {
        try {
            const bruto = sessionStorage.getItem(CHAVE);
            if (!bruto) return;

            sessionStorage.removeItem(CHAVE);

            const pendente = JSON.parse(bruto);
            mostrar(pendente.tipo, pendente.texto, pendente.opcoes);
        } catch (erro) {
            console.error(erro);
        }
    }

    function limpar() {
        if (container) {
            container.innerHTML = '';
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', exibirPendente);
    } else {
        exibirPendente();
    }

    return {
        mostrar: mostrar,
        sucesso: function (texto, opcoes) { return mostrar('sucesso', texto, opcoes); },
        erro:    function (texto, opcoes) { return mostrar('erro', texto, opcoes); },
        atencao: function (texto, opcoes) { return mostrar('atencao', texto, opcoes); },
        info:    function (texto, opcoes) { return mostrar('info', texto, opcoes); },
        agendar: agendar,
        limpar: limpar
    };
})();
