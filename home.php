<?php
require __DIR__ . '/includes/autenticar.php';

$estoqueBaixo = [];
$erroConsultaEstoque = false;

try {
    require_once __DIR__ . '/config/conexao.php';

    if (!isset($pdo) || !($pdo instanceof PDO)) {
        throw new RuntimeException('Conexão com o banco não disponível.');
    }

    // Busca produtos com estoque menor que 3, sem utilizar API.
    $consultaEstoque = $pdo->query(
        'SELECT id, nome, categoria, estoque
         FROM produto
         WHERE estoque >= 0 AND estoque < 3
         ORDER BY estoque ASC, nome ASC'
    );

    $estoqueBaixo = $consultaEstoque->fetchAll(PDO::FETCH_ASSOC);

} catch (Throwable $erro) {
    $erroConsultaEstoque = true;
}

// Data atual no fuso horário brasileiro.
$fusoHorario = new DateTimeZone('America/Sao_Paulo');
$agora = new DateTimeImmutable('now', $fusoHorario);

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

    if (is_string($dataAtual) && $dataAtual !== '') {
        $dataAtual = ucfirst($dataAtual);
    }
} else {
    $dias = [
        'domingo',
        'segunda-feira',
        'terça-feira',
        'quarta-feira',
        'quinta-feira',
        'sexta-feira',
        'sábado'
    ];

    $meses = [
        1 => 'janeiro',
        'fevereiro',
        'março',
        'abril',
        'maio',
        'junho',
        'julho',
        'agosto',
        'setembro',
        'outubro',
        'novembro',
        'dezembro'
    ];

    $dataAtual = ucfirst($dias[(int) $agora->format('w')])
        . ', ' . $agora->format('j')
        . ' de ' . $meses[(int) $agora->format('n')]
        . ' de ' . $agora->format('Y');
}

// Vendas fictícias: serão integradas futuramente.
$ultimasVendas = [
    [
        'cliente' => 'Ana Paula Ferreira',
        'dias' => 0,
        'valor' => 139.70,
        'status' => 'Pago'
    ],
    [
        'cliente' => 'Carlos Eduardo Souza',
        'dias' => 0,
        'valor' => 149.90,
        'status' => 'Pendente'
    ],
    [
        'cliente' => 'Fernanda Lima',
        'dias' => 1,
        'valor' => 349.70,
        'status' => 'Pago'
    ],
    [
        'cliente' => 'Cliente avulso',
        'dias' => 1,
        'valor' => 149.70,
        'status' => 'Pendente'
    ]
];

foreach ($ultimasVendas as &$venda) {
    $venda['data'] = $agora
        ->modify('-' . $venda['dias'] . ' days')
        ->format('d/m/Y');
}

unset($venda);

// Valores demonstrativos de vendas de hoje.
$valorVendasHoje = 289.60;
$quantidadeVendasHoje = 2;

$quantidadeEstoqueBaixo = count($estoqueBaixo);

// Localiza a tela de registro de vendas.
$candidatosVenda = [
    'views/registrar_venda/registrar_venda.php',
    'views/registrar_venda.php',
    'views/vendas/registrar_venda.php',
    'registrar_venda.php'
];

$paginaVenda = '#';

foreach ($candidatosVenda as $caminho) {
    if (file_exists(__DIR__ . '/' . $caminho)) {
        $paginaVenda = $caminho;
        break;
    }
}

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

// Protege os textos exibidos na página.
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

<link rel="stylesheet" href="css/dashboard/dashboard.css?v=1">

<div class="dashboard-pagina">

    <header class="dashboard-topo topo-pagina topo-destaque">
    <div class="dashboard-cabecalho-conteudo">

        <div class="dashboard-titulo-linha">

            <span class="dashboard-titulo-icone" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                    <path
                        d="M3 10.5 12 3l9 7.5"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    />
                    <path
                        d="M5.5 9v11h13V9M9 20v-6h6v6"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    />
                </svg>
            </span>

            <h1>Dashboard</h1>

        </div>

        <p id="data-atual" class="dashboard-data">
            <?= dashboardEscapar($dataAtual) ?>
        </p>

    </div>
</header>

    <!-- Resumos do sistema -->
    <section class="dashboard-resumos" aria-label="Resumo do sistema">

        <!-- Vendas de hoje: valores fictícios -->
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

            <small><?= (int) $quantidadeVendasHoje ?> vendas</small>
        </article>

        <!-- Estoque consultado no banco -->
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
                <?= $quantidadeEstoqueBaixo ?>
                <?= $quantidadeEstoqueBaixo === 1 ? 'item' : 'itens' ?>
            </strong>

            <span>Estoque Baixo</span>

            <small>Produtos com menos de 3 unidades</small>
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

    <!-- Painéis inferiores -->
    <section class="dashboard-paineis">

        <!-- Últimas vendas fictícias -->
        <article class="dashboard-painel painel-vendas">

            <div class="painel-cabecalho">
                <h2>Últimas Vendas</h2>
            </div>

            <div class="painel-lista">

                <?php foreach ($ultimasVendas as $venda): ?>

                    <div class="venda-linha">

                        <div class="venda-cliente">
                            <strong>
                                <?= dashboardEscapar($venda['cliente']) ?>
                            </strong>

                            <span>
                                <?= dashboardEscapar($venda['data']) ?>
                            </span>
                        </div>

                        <div class="venda-valor-status">

                            <strong>
                                R$ <?= number_format($venda['valor'], 2, ',', '.') ?>
                            </strong>

                            <span class="status-venda <?= $venda['status'] === 'Pago' ? 'status-pago' : 'status-pendente' ?>">
                                <?= dashboardEscapar($venda['status']) ?>
                            </span>

                        </div>

                    </div>

                <?php endforeach; ?>

            </div>
        </article>

        <!-- Produtos com estoque baixo -->
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

                    <?php foreach (array_slice($estoqueBaixo, 0, 5) as $produto): ?>

                        <div class="estoque-linha">

                            <div class="estoque-produto">
                                <strong>
                                    <?= dashboardEscapar($produto['nome'] ?? 'Produto') ?>
                                </strong>

                                <span>
                                    <?= dashboardEscapar($produto['categoria'] ?? 'Sem categoria') ?>
                                </span>
                            </div>

                            <strong class="estoque-quantidade <?= (int) $produto['estoque'] === 0 ? 'estoque-zerado' : '' ?>">

                                <?php if ((int) $produto['estoque'] === 0): ?>
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