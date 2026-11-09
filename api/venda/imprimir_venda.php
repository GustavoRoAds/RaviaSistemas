<?php
// Comprovante individual da venda, incluindo as canceladas.
require_once __DIR__ . '/../relatorios/_pdf_base.php';

$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    http_response_code(400);
    exit('Numero de venda invalido.');
}

try {
    $consulta = $pdo->prepare('SELECT v.*, c.nome AS cliente_nome, c.cpf AS cliente_documento,
        f.nome AS funcionario_nome
        FROM venda v
        LEFT JOIN cliente c ON c.codigo = v.num_cliente
        LEFT JOIN funcionario f ON f.id = v.num_funcionario
        WHERE v.num_venda = :id');
    $consulta->execute([':id' => $id]);
    $venda = $consulta->fetch(PDO::FETCH_ASSOC);
    if (!$venda) {
        http_response_code(404);
        exit('Venda nao encontrada.');
    }

    $consultaItens = $pdo->prepare('SELECT i.*, p.nome AS produto_nome
        FROM item_venda i
        LEFT JOIN produto p ON p.id = i.num_produto
        WHERE i.num_venda = :id ORDER BY i.num_produto');
    $consultaItens->execute([':id' => $id]);
    $itens = $consultaItens->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $erro) {
    error_log('Impressao de venda: ' . $erro->getMessage());
    http_response_code(500);
    exit('Nao foi possivel gerar a impressao da venda.');
}

$pdf = startPdf('Comprovante de venda', 'Venda #' . $id . ' | ' . dateBR($venda['data_venda']));
$pdf->SetTextColor(30, 45, 65);
$pdf->headingLine('Venda #' . $id . '  |  ' . ($venda['situacao'] === 'CANCELADA' ? 'CANCELADA' : 'ATIVA'));
$pdf->lineText('Data: ' . date('d/m/Y H:i', strtotime($venda['data_venda'])));
$pdf->lineText('Cliente: ' . ($venda['cliente_nome'] ?: 'Nao informado'));
$pdf->lineText('Funcionario: ' . ($venda['funcionario_nome'] ?: 'Nao vinculado'));
$pdf->Ln(4);
$pdf->headingLine('Produtos');
$pdf->SetFont('Arial', 'B', 9);
$pdf->Cell(16, 8, 'Cod.', 0, 0);
$pdf->Cell(93, 8, 'Descricao', 0, 0);
$pdf->Cell(17, 8, 'Qtd.', 0, 0, 'R');
$pdf->Cell(30, 8, 'Unitario', 0, 0, 'R');
$pdf->Cell(34, 8, 'Subtotal', 0, 1, 'R');
$pdf->SetDrawColor(205, 215, 225);
$pdf->Line(10, $pdf->GetY(), 200, $pdf->GetY());

foreach ($itens as $item) {
    $pdf->SetFont('Arial', '', 9);
    $nome = pdfText($item['produto_nome'] ?: 'Produto nao encontrado');
    $nome = strlen($nome) > 49 ? substr($nome, 0, 46) . '...' : $nome;
    $pdf->Cell(16, 8, (string)$item['num_produto'], 0, 0);
    $pdf->Cell(93, 8, $nome, 0, 0);
    $pdf->Cell(17, 8, (string)$item['quantidade'], 0, 0, 'R');
    $pdf->Cell(30, 8, pdfText(money($item['preco_unitario'])), 0, 0, 'R');
    $pdf->Cell(34, 8, pdfText(money($item['subtotal_item'])), 0, 1, 'R');
}
if (!$itens) $pdf->lineText('Nenhum item cadastrado nesta venda.');

$pdf->Ln(5);
$pdf->Line(10, $pdf->GetY(), 200, $pdf->GetY());
$pdf->Ln(3);
$pdf->lineText('Desconto em valor: ' . money($venda['desconto_valor']) . ' | Desconto percentual: ' . $venda['desconto_percentual'] . '%');
$pdf->lineText('Acrescimo: ' . money($venda['acrescimo']));
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(0, 11, pdfText('TOTAL: ' . money($venda['valor_total'])), 0, 1, 'R');
if ($venda['situacao'] === 'CANCELADA') {
    $pdf->headingLine('Dados do cancelamento');
    $pdf->lineText('Cancelada em: ' . ($venda['cancelada_em'] ? date('d/m/Y H:i', strtotime($venda['cancelada_em'])) : '-'));
    $pdf->lineText('Motivo: ' . ($venda['motivo_cancelamento'] ?: 'Nao informado'));
}
if (trim((string)$venda['observacao']) !== '') {
    $pdf->Ln(3);
    $pdf->lineText('Observacoes: ' . $venda['observacao']);
}
$pdf->Output('I', 'venda_' . $id . '.pdf');
