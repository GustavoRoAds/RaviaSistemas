<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}

$paginaAtual = 'venda';
require 'includes/header_app.php';
?>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/registrar_venda/registrar_venda.css">

<div class="venda-pagina">

    <header class="venda-topo">
        <div class="venda-topo-titulo">
            <div class="venda-topo-icone">
                <svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"/>
                    <circle cx="20" cy="21" r="1"/>
                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                </svg>
            </div>
            <div>
                <nav class="venda-migalhas">
                    <a href="index.php">Início</a>
                    <span>/</span>
                    <span>Registrar venda</span>
                </nav>
                <h1>Registrar Venda</h1>
                <p class="venda-subtitulo">Busque produtos para adicionar à venda</p>
            </div>
        </div>
    </header>

    <div class="venda-layout">

        <!-- COLUNA PRINCIPAL -->
        <div class="venda-coluna">

            <section class="venda-card">
                <div class="venda-card-corpo">
                    <h2 class="venda-rotulo">Adicionar produto</h2>
                    <div class="venda-busca" id="venda-busca-produto">
                        <div class="venda-campo">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"/>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                            </svg>
                            <input type="text" id="busca-produto" placeholder="Buscar produto por nome" autocomplete="off">
                        </div>
                        <div class="venda-lista" id="lista-produtos"></div>
                    </div>
                </div>
            </section>

            <section class="venda-card">
                <h2 class="venda-card-titulo">Itens da venda</h2>
                <div class="venda-vazio" id="itens-vazio">
                    <svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/>
                        <polyline points="3.27 6.96 12 12.01 20.73 6.96"/>
                        <line x1="12" y1="22.08" x2="12" y2="12"/>
                    </svg>
                    <p>Nenhum produto adicionado</p>
                </div>
                <ul class="venda-itens" id="itens-lista"></ul>
            </section>

        </div>

        <!-- COLUNA LATERAL -->
        <aside class="venda-coluna">

            <section class="venda-card">
                <div class="venda-card-corpo">
                    <h2 class="venda-rotulo">Cliente (opcional)</h2>
                    <div class="venda-busca" id="venda-busca-cliente">
                        <div class="venda-campo" id="campo-cliente">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"/>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                            </svg>
                            <input type="text" id="busca-cliente" placeholder="Buscar por nome ou CPF" autocomplete="off">
                        </div>
                        <div class="venda-lista" id="lista-clientes"></div>
                        <div class="venda-chip" id="chip-cliente">
                            <div>
                                <strong id="chip-nome"></strong>
                                <span id="chip-cpf"></span>
                            </div>
                            <button type="button" id="chip-remover" aria-label="Remover cliente">&times;</button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="venda-card">
                <div class="venda-card-corpo">
                    <h2 class="venda-rotulo">Ajustes e observação</h2>

                    <div class="venda-ajustes-grade">
                        <div class="venda-ajuste">
                            <label for="desconto-valor">Desconto (R$)</label>
                            <div class="venda-input-grupo">
                                <span class="venda-input-prefixo">R$</span>
                                <input type="text" id="desconto-valor" inputmode="decimal" placeholder="0,00" autocomplete="off">
                            </div>
                        </div>

                        <div class="venda-ajuste">
                            <label for="desconto-percentual">Desconto (%)</label>
                            <div class="venda-input-grupo">
                                <input type="text" id="desconto-percentual" inputmode="decimal" placeholder="0" autocomplete="off">
                                <span class="venda-input-sufixo">%</span>
                            </div>
                        </div>

                        <div class="venda-ajuste venda-ajuste-full">
                            <label for="acrescimo">Acréscimo (R$)</label>
                            <div class="venda-input-grupo">
                                <span class="venda-input-prefixo">R$</span>
                                <input type="text" id="acrescimo" inputmode="decimal" placeholder="0,00" autocomplete="off">
                            </div>
                        </div>

                        <div class="venda-ajuste venda-ajuste-full">
                            <label for="observacao">Observação</label>
                            <textarea id="observacao" rows="3" maxlength="500" placeholder="Ex.: entrega combinada, troca, forma de pagamento..."></textarea>
                        </div>
                    </div>
                </div>
            </section>

            <div class="venda-aviso" id="venda-aviso"></div>

            <section class="venda-card venda-resumo">
                <div class="venda-card-corpo">
                    <div class="venda-resumo-linha">
                        <span>Subtotal</span>
                        <strong id="resumo-subtotal">R$ 0,00</strong>
                    </div>
                    <div class="venda-resumo-linha venda-resumo-desconto">
                        <span>Desconto</span>
                        <strong id="resumo-desconto">- R$ 0,00</strong>
                    </div>
                    <div class="venda-resumo-linha">
                        <span>Acréscimo</span>
                        <strong id="resumo-acrescimo">+ R$ 0,00</strong>
                    </div>

                    <div class="venda-resumo-total">
                        <span class="venda-total-rotulo">Total da venda</span>
                        <strong class="venda-total-valor" id="venda-total">R$ 0,00</strong>
                    </div>

                    <button type="button" class="venda-confirmar" id="btn-confirmar" disabled>Confirmar Venda</button>
                </div>
            </section>

        </aside>
    </div>
</div>

<script src="js/registrar_venda/registrar_venda.js"></script>

<?php require 'includes/footer_app.php'; ?>