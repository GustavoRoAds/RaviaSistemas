<?php

require_once __DIR__ . '/libs/fpdf/fpdf.php';

$pdf = new FPDF();
$pdf->AddPage();

$pdf->SetFont('Arial', 'B', 16);
$pdf->Cell(0, 10, 'RaviaSistemas - Relatorio', 0, 1, 'C');

$pdf->Ln(10);

$pdf->SetFont('Arial', '', 12);
$pdf->Cell(0, 10, 'PDF gerado com sucesso!', 0, 1);

$pdf->Output('I', 'relatorio.pdf');