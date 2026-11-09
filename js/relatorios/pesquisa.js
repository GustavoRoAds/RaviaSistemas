(() => {
    const BASE = '/RaviaSistemas';
    const config = {
        cliente: { url: BASE + '/api/cliente/cliente.php?situacao=todos&busca=', id: 'codigo', label: 'nome', detail: 'cpf' },
        produto: { url: BASE + '/api/produto/produtos.php?busca=', id: 'id', label: 'nome', detail: 'categoria' },
        funcionario: { url: BASE + '/api/funcionario/funcionario.php?busca=', id: 'id', label: 'nome', detail: '' }
    };
    document.querySelectorAll('.relatorio-busca').forEach(wrapper => {
        const cfg = config[wrapper.dataset.tipo], input = wrapper.querySelector('.relatorio-busca-texto'), hidden = wrapper.querySelector('.relatorio-busca-id'), list = wrapper.querySelector('.relatorio-busca-lista'), clear = wrapper.querySelector('.relatorio-busca-limpar');
        let timer, controller;
        const close = () => { list.classList.remove('aberta'); list.replaceChildren() };
        const select = (item) => { hidden.value = item[cfg.id]; input.value = item[cfg.id] + ' - ' + item[cfg.label]; wrapper.classList.add('selecionado'); close() };
        const search = async () => {
            controller?.abort(); controller = new AbortController();
            try {
                const response = await fetch(cfg.url + encodeURIComponent(input.value.trim()), { signal: controller.signal });
                if (!response.ok) throw new Error('Falha na consulta');
                const result = await response.json(); if (!Array.isArray(result)) throw new Error('Formato inesperado');
                list.replaceChildren();
                result.slice(0, 30).forEach(item => {
                    if (!item[cfg.id] || !item[cfg.label]) return;
                    const btn = document.createElement('button'); btn.type = 'button'; btn.className = 'relatorio-opcao';
                    const name = document.createElement('span'); name.textContent = item[cfg.id] + ' - ' + item[cfg.label]; btn.append(name);
                    if (cfg.detail && item[cfg.detail]) { const detail = document.createElement('small'); detail.textContent = item[cfg.detail]; btn.append(detail) }
                    btn.addEventListener('click', () => select(item)); list.append(btn)
                });
                if (!list.children.length) { const empty = document.createElement('div'); empty.className = 'relatorio-vazio'; empty.textContent = 'Nenhum resultado encontrado'; list.append(empty) }
                list.classList.add('aberta');
            } catch (e) { if (e.name !== 'AbortError') { close(); console.error('Erro na pesquisa', e) } }
        };
        input.addEventListener('input', () => { hidden.value = ''; wrapper.classList.remove('selecionado'); clearTimeout(timer); timer = setTimeout(search, 220) });
        input.addEventListener('focus', () => { if (!hidden.value) search() });
        clear.addEventListener('click', () => { input.value = ''; hidden.value = ''; wrapper.classList.remove('selecionado'); close(); input.focus() });
        document.addEventListener('click', event => { if (!wrapper.contains(event.target)) close() });
        wrapper.closest('form').addEventListener('submit', event => { if (input.value.trim() && !hidden.value) { event.preventDefault(); input.focus(); input.setCustomValidity('Selecione uma opção na lista.'); input.reportValidity(); setTimeout(() => input.setCustomValidity(''), 2000) } });
    });
})();