const campoBusca = document.getElementById('busca-cliente'); 

function somenteNumeros(valor) {
    return valor.replace(/\D/g, '');
}
function mascaraCpf(valor) {
    return somenteNumeros(valor)
        .slice(0, 11)
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
}

function mascaraTelefone(valor) {
    const n = somenteNumeros(valor).slice(0, 11);

    if (n.length <= 10) {
        return n.replace(/(\d{2})(\d)/, '($1) $2')
                .replace(/(\d{4})(\d)/, '$1-$2');
    }
    return n.replace(/(\d{2})(\d)/, '($1) $2')
            .replace(/(\d{5})(\d)/, '$1-$2');
}

function carregarClientes(busca) 
{ 
    
    let url = 'api/cliente/cliente.php';
    if (busca) {
        url += '?busca='+ encodeURIComponent(busca); 
    }

    console.log(url);
    fetch(url)
        .then(resposta => resposta.json())
        .then(clientes => {

            const corpoTabela = document.getElementById('corpo-tabela-clientes');

            corpoTabela.innerHTML = '';
            
            document.getElementById('contador-clientes').textContent = clientes.length + ' clientes cadastrados';

            clientes.forEach(cliente => {
                const linha = `
                    <tr>
                        <td>
                            <span class="avatar-cliente">${cliente.nome.charAt(0).toUpperCase()}</span>
                            ${cliente.codigo} - ${cliente.nome}
                        </td>
                        <td>${mascaraTelefone(cliente.telefone)}</td>
                        <td>${mascaraCpf(cliente.cpf)}</td>
                        <td>
                            <a href="cliente_cadastro.php?id=${cliente.codigo}" class="botao-editar">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                    <path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z"></path>
                                </svg>
                            </a>
                        </td>
                    </tr>
                `;
                corpoTabela.innerHTML += linha;
            });
        });
}



campoBusca.addEventListener('input', function() {
    // console.log('Digitou:', campoBusca.value);
    carregarClientes(campoBusca.value);

});

carregarClientes('');


    