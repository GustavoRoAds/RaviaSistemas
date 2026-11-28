<?php
require_once __DIR__ . '/_pdf_base.php';

$situacao = $_GET['situacao'] ?? 'TODOS';
$produto = getInt('produto');

if (!in_array($situacao, ['TODOS', 'ATIVOS', 'INATIVOS'], true)) {
    http_response_code(400);
    exit('Filtros invalidos.');
}

$categoria = trim((string) ($_GET['categoria'] ?? ''));
$where = [];
$params = [];

if ($categoria !== '') {
    $where[] = 'p.categoria = :categoria';
    $params[':categoria'] = $categoria;
}

if ($situacao !== 'TODOS') {
    $where[] = 'p.ativo = ' . ($situacao === 'ATIVOS' ? '1' : '0');
}

if ($produto !== null) {
    $where[] = 'p.id = :produto';
    $params[':produto'] = $produto;
}

$sql = 'SELECT p.id, p.nome, p.valor_venda, p.ativo, COALESCE(fn_estoque(p.id), 0) AS estoque
        FROM produto p'
    . ($where ? ' WHERE ' . implode(' AND ', $where) : '')
    . ' ORDER BY p.nome, p.id';

try {
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Erro ao consultar produtos.');
}

$pdf = startPdf(
    'Produtos e estoque',
    'Produto: ' . ($produto ?? 'Todos') . ' | Categoria: ' . ($categoria ?: 'Todas') . ' | Situação: ' . $situacao,
    true
);

$columns = [
    ['Cod.', 25, 'L'],
    ['Produto', 140, 'L'],
    ['Preço', 45, 'R'],
    ['Estoque (un.)', 35, 'R'],
    ['Situação', 32, 'L'],
];

$cabecalho = function () use ($pdf, $columns) {
    $pdf->SetDrawColor(205, 205, 205);
    $pdf->SetTextColor(35, 35, 35);
    $pdf->SetFont('Arial', 'B', 9);
    foreach ($columns as [$title, $width, $align]) {
        $pdf->Cell($width, 8, pdfText($title), 'B', 0, $align);
    }
    $pdf->Ln();
};
$cabecalho();

$saldo = 0;

foreach ($rows as $row) {
    if ($pdf->GetY() + 8 > $pdf->GetPageHeight() - 18) {
        $pdf->AddPage();
        $cabecalho();
    }
    $pdf->SetFont('Arial', '', 8);
    $pdf->Cell(25, 8, $row['id'], 'B');
    $pdf->Cell(140, 8, pdfText(mb_strimwidth((string) $row['nome'], 0, 85, '...', 'UTF-8')), 'B');
    $pdf->Cell(45, 8, pdfText(money($row['valor_venda'])), 'B', 0, 'R');
    $pdf->Cell(35, 8, number_format((int) $row['estoque'], 0, ',', '.'), 'B', 0, 'R');
    $pdf->Cell(32, 8, $row['ativo'] ? 'Ativo' : 'Inativo', 'B', 1);
    $saldo += (float) $row['estoque'];
}

$pdf->Ln(6);
$pdf->lineText('Produtos: ' . count($rows) . ' | Estoque total em unidades: ' . $saldo);
$pdf->Output('I', 'relatorio_produtos.pdf');
