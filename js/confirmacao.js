function mostrarConfirmacao(opcoes = {}) {
    const config = {
        titulo: 'Confirmação',
        mensagem: 'Deseja continuar?',
        textoSim: 'Sim',
        textoNao: 'Não',
        classeSim: '',          // classe extra para o botão Sim
        classeNao: '',          // classe extra para o botão Não
        perigo: false,          // true = botão Sim vermelho
        focoInicial: 'nao',     // 'sim' ou 'nao'
        fecharNoFundo: true,    // clicar fora = Não
        ...opcoes
    };

    return new Promise(resolve => {
        const focoAnterior = document.activeElement;

        // fundo escuro
        const fundo = document.createElement('div');
        fundo.className = 'modal-fundo';

        // caixa
        const caixa = document.createElement('div');
        caixa.className = 'modal-caixa';
        caixa.setAttribute('role', 'dialog');
        caixa.setAttribute('aria-modal', 'true');

        const titulo = document.createElement('h2');
        titulo.className = 'modal-titulo';
        titulo.textContent = config.titulo;

        const mensagem = document.createElement('p');
        mensagem.className = 'modal-mensagem';
        mensagem.textContent = config.mensagem;

        // botões
        const acoes = document.createElement('div');
        acoes.className = 'modal-acoes';

        const botaoNao = document.createElement('button');
        botaoNao.type = 'button';
        botaoNao.className = ('modal-botao modal-botao-nao ' + config.classeNao).trim();
        botaoNao.textContent = config.textoNao;

        const botaoSim = document.createElement('button');
        botaoSim.type = 'button';
        botaoSim.className = ('modal-botao modal-botao-sim ' + config.classeSim).trim();
        if (config.perigo) botaoSim.classList.add('modal-botao-perigo');
        botaoSim.textContent = config.textoSim;

        acoes.append(botaoNao, botaoSim);
        caixa.append(titulo, mensagem, acoes);
        fundo.appendChild(caixa);
        document.body.appendChild(fundo);

        // fecha e devolve a resposta
        function fechar(resposta) {
            document.removeEventListener('keydown', aoTeclar);
            fundo.classList.add('saindo');
            setTimeout(() => {
                fundo.remove();
                if (focoAnterior && focoAnterior.focus) focoAnterior.focus();
                resolve(resposta);
            }, 150);
        }

        function aoTeclar(evento) {
            if (evento.key === 'Escape') {
                fechar(false);
            } else if (evento.key === 'Tab') {
                // mantém o foco dentro do modal
                evento.preventDefault();
                const alvo = document.activeElement === botaoSim ? botaoNao : botaoSim;
                alvo.focus();
            }
        }

        botaoSim.addEventListener('click', () => fechar(true));
        botaoNao.addEventListener('click', () => fechar(false));

        fundo.addEventListener('click', evento => {
            if (config.fecharNoFundo && evento.target === fundo) fechar(false);
        });

        document.addEventListener('keydown', aoTeclar);

        (config.focoInicial === 'sim' ? botaoSim : botaoNao).focus();
    });
}