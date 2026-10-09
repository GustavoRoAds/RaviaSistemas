fetch('api/cliente/cliente.php')
    .then(resposta => resposta.json())
    .then(clientes => {
        const corpoTabela = document.getElementById('corpo-tabela-clientes');

        clientes.forEach(cliente => {
            const linha = `
                <tr>
                    <td>${cliente.nome}</td>
                    <td>${cliente.telefone}</td>
                    <td>${cliente.cpf}</td>
                </tr>
            `;
            corpoTabela.innerHTML += linha;
        });
    });