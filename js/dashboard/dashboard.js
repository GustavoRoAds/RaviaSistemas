(() => {
    const campoData = document.getElementById('data-atual');

    function atualizarData() {
        if (!campoData) {
            return;
        }

        const agora = new Date();

        const texto = new Intl.DateTimeFormat('pt-BR', {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            timeZone: 'America/Sao_Paulo'
        }).format(agora);

        campoData.textContent =
            texto.charAt(0).toLocaleUpperCase('pt-BR') + texto.slice(1);
    }

    atualizarData();

    window.setInterval(atualizarData, 60 * 1000);
})();