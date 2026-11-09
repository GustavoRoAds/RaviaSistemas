<?php
session_start();
if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    exit('Sessao expirada.');
}
require_once __DIR__ . '/../../config/conexao.php';
require_once __DIR__ . '/../../libs/fpdf/fpdf.php';
function pdfText($v)
{
    return iconv('UTF-8', 'windows-1252//TRANSLIT', (string)$v) ?: '';
}
function money($v)
{
    return 'R$ ' . number_format((float)$v, 2, ',', '.');
}
function validDate($v)
{
    $d = DateTimeImmutable::createFromFormat('!Y-m-d', $v);
    return $d && $d->format('Y-m-d') === $v;
}
function dateBR($v)
{
    return $v ? date('d/m/Y', strtotime($v)) : '-';
}
function getInt($name)
{
    $v = $_GET[$name] ?? '';
    return $v !== '' && ctype_digit((string)$v) && (int)$v > 0 ? (int)$v : null;
}
class RaviaPDF extends FPDF
{
    public $heading = '';
    public $criteria = '';
    function Header()
    {
        $this->SetXY(14, 12);
        $this->SetFont('Arial', 'B', 15);
        $this->SetTextColor(35, 35, 35);
        $this->Cell(0, 8, pdfText('RaviaSistemas - ' . $this->heading), 0, 1);
        $this->SetXY(14, 22);
        $this->SetFont('Arial', '', 8);
        $this->SetTextColor(105, 105, 105);
        $this->Cell(0, 5, pdfText($this->criteria), 0, 1);
        $this->SetDrawColor(190, 190, 190);
        $this->Line(10, 32, $this->GetPageWidth() - 10, 32);
        $this->SetY(37);
    }
    function Footer()
    {
        $this->SetY(-14);
        $this->SetFont('Arial', '', 8);
        $this->SetTextColor(115, 115, 115);
        $this->Cell(0, 7, pdfText('Gerado em ' . date('d/m/Y H:i')), 0, 0, 'L');
        $this->Cell(0, 7, pdfText('Pagina ' . $this->PageNo() . '/{nb}'), 0, 0, 'R');
    }
    function headingLine($text)
    {
        if ($this->GetY() > $this->GetPageHeight() - 35) $this->AddPage();
        $this->SetTextColor(35, 35, 35);
        $this->SetFont('Arial', 'B', 10);
        $this->Cell(0, 8, pdfText($text), 0, 1, 'L');
        $this->SetDrawColor(190, 190, 190);
        $this->Line(10, $this->GetY(), $this->GetPageWidth() - 10, $this->GetY());
    }
    function lineText($text, $h = 6)
    {
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(0, $h, pdfText($text));
    }
}
function startPdf($title, $criteria, $landscape = false)
{
    $pdf = new RaviaPDF($landscape ? 'L' : 'P', 'mm', 'A4');
    $pdf->heading = $title;
    $pdf->criteria = $criteria;
    $pdf->AliasNbPages();
    $pdf->SetAutoPageBreak(true, 18);
    $pdf->AddPage();
    return $pdf;
}
