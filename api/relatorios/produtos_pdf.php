<?php
require_once __DIR__ . '/_pdf_base.php';

$situacao = $_GET['situacao'] ?? 'TODOS';
$produto = getInt('produto');

if (!in_array($situacao, ['TODOS', 'ATIVOS', 'INATIVOS'], true)) {
    http_response_code(400);
    exit('Filtros invalidos.');
}

$where = [];
$params = [];

if ($situacao !== 'TODOS') {
    $where[] = 'p.ativo = ' . ($situacao === 'ATIVOS' ? '1' : '0');
}

if ($produto !== null) {
    $where[] = 'p.id = :produto';
    $params[':produto'] = $produto;
}

$sql = 'SELECT p.id, p.nome, p.valor_venda, p.ativo, fn_estoque(p.id) AS saldo
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
    'Produto: ' . ($produto ?? 'Todos') . ' | Situacao: ' . $situacao,
    true
);

$columns = [
    ['Cod.', 25, 'L'],
    ['Produto', 140, 'L'],
    ['Preco', 45, 'R'],
    ['Saldo', 35, 'R'],
    ['Situacao', 32, 'L'],
];

$pdf->SetDrawColor(205, 205, 205);
$pdf->SetTextColor(35, 35, 35);
$pdf->SetFont('Arial', 'B', 9);

foreach ($columns as [$title, $width, $align]) {
    $pdf->Cell($width, 8, pdfText($title), 'B', 0, $align);
}
$pdf->Ln();

$saldo = 0;

foreach ($rows as $row) {
    $pdf->SetFont('Arial', '', 8);
    $pdf->Cell(25, 8, $row['id'], 'B');
    $pdf->Cell(140, 8, mb_strimwidth(pdfText($row['nome']), 0, 85, '...'), 'B');
    $pdf->Cell(45, 8, pdfText(money($row['valor_venda'])), 'B', 0, 'R');
    $pdf->Cell(35, 8, (string) $row['saldo'], 'B', 0, 'R');
    $pdf->Cell(32, 8, $row['ativo'] ? 'Ativo' : 'Inativo', 'B', 1);
    $saldo += (float) $row['saldo'];
}

$pdf->Ln(6);
$pdf->lineText('Produtos: ' . count($rows) . ' | Saldo total em unidades: ' . $saldo);
$pdf->Output('I', 'relatorio_produtos.pdf');
