<?php
require __DIR__ . '/../../includes/autenticar.php';
require __DIR__ . '/../../includes/header_app.php';
?>
<link rel="stylesheet" href="<?php echo BASE_URL; ?>/css/estoque/acerto_estoque.css">
<div class="topo-pagina topo-destaque">
    <div class="acerto-titulo">
        <div>
            <nav>
                <a href="<?php echo BASE_URL; ?>/home.php">Início</a> › Estoque › Acerto</nav>
                    <h1>Acerto de Estoque</h1>
                    <p>Registre entradas e retiradas de produtos por data.</p>
                </div>
            </div>
        </div>
        <div class="acerto-pagina">
            <section class="acerto-card">
                <h2>Lançamento</h2>
                <div class="acerto-data">
                    <label for="data-emissao">Emissão</label>
                    <input id="data-emissao" type="date">
                </div>
                <div class="acerto-campos">
                    <div class="acerto-codigo">
                        <label for="produto-codigo">Código</label>
                        <input id="produto-codigo" type="number" min="1" placeholder="Código">
                    </div>
                    <div class="acerto-nome">
                        <label for="produto-busca">Produto</label>
                        <input id="produto-busca" type="text" placeholder="Pesquise pelo nome" autocomplete="off">
                        <div id="produto-resultados" class="acerto-resultados" hidden>
                        </div>
                    </div>
                    <div class="acerto-saldo">
                        <label>Saldo atual</label>
                        <strong id="produto-saldo">0</strong>
                    </div>
                    <div class="acerto-qtd">
                        <label for="quantidade">Quantidade (+ / -)</label>
                        <input id="quantidade" type="number" step="1" placeholder="Ex.: 2 ou -2">
                    </div>
                    <button id="adicionar" class="acerto-adicionar" type="button" title="Adicionar produto">＋</button>
                </div>
            </section>
            <section class="acerto-card">
                <div class="acerto-cabecalho">
                    <h2>Produtos lançados</h2>
                    <span id="contador">0 produtos</span>
                </div>
                <div class="acerto-tabela-wrap">
                    <table class="acerto-tabela">
                        <thead>
                            <tr>
                                <th>Cód. Produto</th>
                                <th>Nome</th>
                                <th>Quantidade</th>
                                <th class="acerto-acao">
                                </th>
                            </tr>
                        </thead>
                        <tbody id="itens-acerto">
                            <tr>
                                <td colspan="4" class="acerto-vazio">Nenhum produto lançado.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
            <div class="acerto-rodape">
                <button id="limpar" type="button" class="acerto-secundario">Limpar</button>
                <button id="salvar" type="button" class="acerto-salvar">Salvar acerto</button>
            </div>
            <section class="acerto-card">
                <div class="acerto-cabecalho">
                    <h2>Acertos da data</h2>
                    <button type="button" id="atualizar-historico" class="acerto-secundario">Atualizar</button>
                </div>
                <div id="historico" class="acerto-historico">Selecione uma data para consultar.</div>
            </section>
        </div>
        <script>const BASE_ACERTO = <?php echo json_encode(BASE_URL); ?>;</script>
        <script src="<?php echo BASE_URL; ?>/js/estoque/acerto_estoque.js">
        </script>
        <?php require __DIR__ . '/../../includes/footer_app.php'; ?>
