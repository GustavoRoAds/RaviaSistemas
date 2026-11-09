<?php
require_once __DIR__ . '/_pdf_base.php';

$situacao = $_GET['situacao'] ?? 'TODOS';
$cliente = getInt('cliente');

if (!in_array($situacao, ['TODOS', 'ATIVOS', 'INATIVOS'], true)) {
    http_response_code(400);
    exit('Filtros invalidos.');
}

$where = [];
$params = [];

if ($situacao !== 'TODOS') {
    $where[] = 'ativo = ' . ($situacao === 'ATIVOS' ? '1' : '0');
}

if ($cliente !== null) {
    $where[] = 'codigo = :cliente';
    $params[':cliente'] = $cliente;
}

$sql = 'SELECT codigo, nome, cpf, telefone, cidade, ativo FROM cliente'
    . ($where ? ' WHERE ' . implode(' AND ', $where) : '')
    . ' ORDER BY nome, codigo';

try {
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Erro ao consultar clientes.');
}

$pdf = startPdf(
    'Relatorio de clientes',
    'Cliente: ' . ($cliente ?? 'Todos') . ' | Situacao: ' . $situacao,
    true
);

$columns = [
    ['Cod.', 19],
    ['Cliente', 80],
    ['CPF/CNPJ', 42],
    ['Telefone', 40],
    ['Cidade', 62],
    ['Situacao', 27],
];

$pdf->SetDrawColor(205, 205, 205);
$pdf->SetTextColor(35, 35, 35);
$pdf->SetFont('Arial', 'B', 9);

foreach ($columns as [$title, $width]) {
    $pdf->Cell($width, 8, pdfText($title), 'B');
}
$pdf->Ln();

foreach ($rows as $row) {
    $pdf->SetFont('Arial', '', 8);

    $values = [
        [$row['codigo'], 19],
        [$row['nome'], 80],
        [$row['cpf'], 42],
        [$row['telefone'], 40],
        [$row['cidade'], 62],
        [$row['ativo'] ? 'Ativo' : 'Inativo', 27],
    ];

    foreach ($values as [$value, $width]) {
        $text = mb_strimwidth(pdfText($value ?? ''), 0, max(5, (int) ($width / 1.8)), '...');
        $pdf->Cell($width, 8, $text, 'B');
    }

    $pdf->Ln();
}

$pdf->Ln(6);
$pdf->lineText('Total de clientes: ' . count($rows));
$pdf->Output('I', 'relatorio_clientes.pdf');
