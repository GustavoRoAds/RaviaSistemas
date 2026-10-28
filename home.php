<?php
require __DIR__ . '/includes/autenticar.php';

$fusoHorario = new DateTimeZone('America/Sao_Paulo');
$agora = new DateTimeImmutable('now', $fusoHorario);
$dataHoje = $agora->format('Y-m-d');

$estoqueBaixo = [];
$ultimasVendas = [];

$valorVendasHoje = 0;
$quantidadeVendasHoje = 0;

$erroConsultaEstoque = false;
$erroConsultaVendas = false;

require_once __DIR__ . '/config/conexao.php';

// Data atual em português.
if (class_exists('IntlDateFormatter')) {
    $formatadorData = new IntlDateFormatter(
        'pt_BR',
        IntlDateFormatter::FULL,
        IntlDateFormatter::NONE,
        'America/Sao_Paulo',
        IntlDateFormatter::GREGORIAN,
        "EEEE, d 'de' MMMM 'de' y"
    );

    $dataAtual = $formatadorData->format($agora);

    if (!is_string($dataAtual) || $dataAtual === '') {
        $dataAtual = $agora->format('d/m/Y');
    } else {
        $dataAtual = mb_convert_case(
            $dataAtual,
            MB_CASE_TITLE,
            'UTF-8'
        );
    }
} else {
    $dataAtual = $agora->format('d/m/Y');
}

// Consulta todos os produtos com estoque igual ou menor que 3.
try {
    $consultaEstoque = $pdo->query(
        'SELECT id, nome, categoria, estoque
         FROM produto
         WHERE estoque <= 3
         ORDER BY estoque ASC, nome ASC'
    );

    $estoqueBaixo = $consultaEstoque->fetchAll(PDO::FETCH_ASSOC);

} catch (Throwable $erro) {
    $erroConsultaEstoque = true;
    error_log('Erro ao consultar estoque do dashboard: ' . $erro->getMessage());
}

// Consulta o total e a quantidade de vendas feitas hoje.
try {
    $consultaResumo = $pdo->prepare(
        'SELECT
            COALESCE(SUM(valor_total), 0) AS total_vendas,
            COUNT(*) AS quantidade_vendas
         FROM venda
         WHERE data_venda >= :inicio_dia
           AND data_venda < :inicio_proximo_dia'
    );

    $inicioDia = $agora->setTime(0, 0, 0);
    $inicioProximoDia = $inicioDia->modify('+1 day');

    $consultaResumo->execute([
        ':inicio_dia' => $inicioDia->format('Y-m-d H:i:s'),
        ':inicio_proximo_dia' => $inicioProximoDia->format('Y-m-d H:i:s')
    ]);

    $resumo = $consultaResumo->fetch(PDO::FETCH_ASSOC);

    if ($resumo) {
        $valorVendasHoje = (float) $resumo['total_vendas'];
        $quantidadeVendasHoje = (int) $resumo['quantidade_vendas'];
    }

    // Busca as cinco vendas mais recentes que realmente foram registradas.
    $consultaVendas = $pdo->query(
        'SELECT
            v.num_venda,
            v.data_venda,
            v.valor_total,
            c.nome AS nome_cliente
         FROM venda v
         LEFT JOIN cliente c ON c.codigo = v.num_cliente
         ORDER BY v.data_venda DESC, v.num_venda DESC
         LIMIT 5'
    );

    $ultimasVendas = $consultaVendas->fetchAll(PDO::FETCH_ASSOC);

} catch (Throwable $erro) {
    $erroConsultaVendas = true;
    error_log('Erro ao consultar vendas do dashboard: ' . $erro->getMessage());
}

$paginaVenda = '/RaviaSistemas/views/venda/registrar_venda.php';

// Localiza a tela de listagem de produtos.
$candidatosProdutos = [
    'views/produtos/produto_listar.php',
    'views/produto/produto_listar.php',
    'produto_listar.php'
];

$paginaProdutos = '#';

foreach ($candidatosProdutos as $caminho) {
    if (file_exists(__DIR__ . '/' . $caminho)) {
        $paginaProdutos = $caminho;
        break;
    }
}

// Protege os textos apresentados na página.
function dashboardEscapar($valor): string
{
    return htmlspecialchars(
        (string) $valor,
        ENT_QUOTES,
        'UTF-8'
    );
}

require __DIR__ . '/includes/header_app.php';
?>

<link rel="stylesheet" href="css/dashboard/dashboard.css?v=2">

<div class="dashboard-pagina">

    <!-- Cabeçalho -->
    <header class="dashboard-topo topo-pagina topo-destaque">

        <div class="dashboard-cabecalho-conteudo">

            <div class="dashboard-titulo-linha">

                <span class="dashboard-titulo-icone" aria-hidden="true">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.8"
                         stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M3 10.5 12 3l9 7.5"/>
                        <path d="M5.5 9v11h13V9M9 20v-6h6v6"/>
                    </svg>
                </span>

                <h1>Dashboard</h1>

            </div>

            <p id="data-atual" class="dashboard-data">
                <?= dashboardEscapar($dataAtual) ?>
            </p>

        </div>

    </header>

    <!-- Resumo -->
    <section class="dashboard-resumos" aria-label="Resumo do sistema">

        <!-- Vendas de hoje, consultadas no banco -->
        <article class="resumo-card resumo-vendas">

            <div class="resumo-icone" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                    <path
                        d="M3 4h2l2.1 10.1a2 2 0 0 0 2 1.6h7.8a2 2 0 0 0 1.9-1.4L21 8H6"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    />
                    <circle cx="10" cy="20" r="1.4" fill="currentColor"/>
                    <circle cx="18" cy="20" r="1.4" fill="currentColor"/>
                </svg>
            </div>

            <strong>
                R$ <?= number_format($valorVendasHoje, 2, ',', '.') ?>
            </strong>

            <span>Vendas Hoje</span>

            <small>
                <?= $quantidadeVendasHoje ?>
                <?= $quantidadeVendasHoje === 1 ? 'venda' : 'vendas' ?>
            </small>

        </article>

        <!-- Estoque baixo, consultado no banco -->
        <article class="resumo-card resumo-estoque">

            <div class="resumo-icone" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                    <path
                        d="M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18Z"
                        stroke="currentColor"
                        stroke-width="1.8"
                    />
                    <path
                        d="M12 7v10m-4-4 4 4 4-4"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    />
                </svg>
            </div>

            <strong>
                <?= count($estoqueBaixo) ?>
                <?= count($estoqueBaixo) === 1 ? 'item' : 'itens' ?>
            </strong>

            <span>Estoque Baixo</span>

            <small>Produtos com até 3 unidades</small>

        </article>

    </section>

    <!-- Ação rápida -->
    <section class="dashboard-acoes" aria-label="Ações rápidas">

        <a
            class="dashboard-botao-nova-venda"
            href="<?= dashboardEscapar($paginaVenda) ?>"
        >
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <path
                    d="M3 4h2l2.1 10.1a2 2 0 0 0 2 1.6h7.8a2 2 0 0 0 1.9-1.4L21 8H6"
                    stroke="currentColor"
                    stroke-width="1.8"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
                <circle cx="10" cy="20" r="1.4" fill="currentColor"/>
                <circle cx="18" cy="20" r="1.4" fill="currentColor"/>
            </svg>

            Nova Venda
        </a>

    </section>

    <!-- Painéis -->
    <section class="dashboard-paineis">

        <!-- Últimas vendas reais -->
        <article class="dashboard-painel painel-vendas">

            <div class="painel-cabecalho">
                <h2>Últimas Vendas</h2>
            </div>

            <div class="painel-lista">

                <?php if ($erroConsultaVendas): ?>

                    <div class="estoque-vazio">
                        Não foi possível consultar as vendas.
                    </div>

                <?php elseif (count($ultimasVendas) === 0): ?>

                    <div class="estoque-vazio">
                        Nenhuma venda registrada ainda.
                    </div>

                <?php else: ?>

                    <?php foreach ($ultimasVendas as $venda): ?>

                        <?php
                        $nomeCliente = $venda['nome_cliente'] ?? '';

                        if (trim($nomeCliente) === '') {
                            $nomeCliente = 'Cliente não encontrado';
                        }

                        $dataVendaFormatada = 'Data não disponível';

                        if (!empty($venda['data_venda'])) {
                            try {
                                $dataVenda = new DateTimeImmutable(
                                    $venda['data_venda'],
                                    $fusoHorario
                                );

                                $dataVendaFormatada = $dataVenda->format('d/m/Y');

                            } catch (Throwable $erro) {
                                $dataVendaFormatada = 'Data não disponível';
                            }
                        }
                        ?>

                        <div class="venda-linha">

                            <div class="venda-cliente">

                                <strong>
                                    <?= dashboardEscapar($nomeCliente) ?>
                                </strong>

                                <span>
                                    Venda #<?= (int) $venda['num_venda'] ?>
                                    - <?= dashboardEscapar($dataVendaFormatada) ?>
                                </span>

                            </div>

                            <div class="venda-valor-status">

                                <strong>
                                    R$ <?= number_format(
                                        (float) $venda['valor_total'],
                                        2,
                                        ',',
                                        '.'
                                    ) ?>
                                </strong>

                            </div>

                        </div>

                    <?php endforeach; ?>

                <?php endif; ?>

            </div>

        </article>

        <!-- Todos os produtos com estoque baixo -->
        <article class="dashboard-painel painel-estoque">

            <div class="painel-cabecalho">

                <h2>Estoque Baixo</h2>

                <?php if ($paginaProdutos !== '#'): ?>

                    <a
                        href="<?= dashboardEscapar($paginaProdutos) ?>"
                        class="painel-link"
                    >
                        Gerenciar <span aria-hidden="true">›</span>
                    </a>

                <?php endif; ?>

            </div>

            <div class="painel-lista">

                <?php if ($erroConsultaEstoque): ?>

                    <div class="estoque-vazio">
                        Não foi possível consultar o estoque.
                        Confira a conexão com o banco de dados.
                    </div>

                <?php elseif (count($estoqueBaixo) === 0): ?>

                    <div class="estoque-vazio">
                        Nenhum produto com estoque baixo.
                    </div>

                <?php else: ?>

                    <?php foreach ($estoqueBaixo as $produto): ?>

                        <div class="estoque-linha">

                            <div class="estoque-produto">

                                <strong>
                                    <?= dashboardEscapar(
                                        $produto['nome'] ?? 'Produto'
                                    ) ?>
                                </strong>

                                <span>
                                    <?= dashboardEscapar(
                                        $produto['categoria'] ?? 'Sem categoria'
                                    ) ?>
                                </span>

                            </div>

                            <strong class="estoque-quantidade <?= (int) $produto['estoque'] <= 0 ? 'estoque-zerado' : '' ?>">

                                <?php if ((int) $produto['estoque'] <= 0): ?>

                                    Zerado

                                <?php else: ?>

                                    <?= (int) $produto['estoque'] ?> un.

                                <?php endif; ?>

                            </strong>

                        </div>

                    <?php endforeach; ?>

                <?php endif; ?>

            </div>

        </article>

    </section>

</div>

<script src="js/dashboard/dashboard.js?v=1"></script>

<?php require __DIR__ . '/includes/footer_app.php'; ?>