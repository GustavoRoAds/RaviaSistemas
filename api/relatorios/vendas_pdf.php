<?php
session_start();
if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    exit('Sessão expirada. Faça login novamente.');
}
require_once __DIR__ . '/../../config/conexao.php';
$autoload = __DIR__ . '/../../vendor/autoload.php';
if (!file_exists($autoload)) {
    http_response_code(500);
    exit('Composer não instalado. Execute: composer require dompdf/dompdf');
}
require_once $autoload;
if (!class_exists(\Dompdf\Dompdf::class)) {
    http_response_code(500);
    exit('Dompdf não instalado. Execute: composer require dompdf/dompdf');
}
$inicio = $_GET['inicio'] ?? '';
$fim = $_GET['fim'] ?? '';
$situacao = $_GET['situacao'] ?? 'TODAS';
function dataValida($valor) {
    $d = DateTimeImmutable::createFromFormat('!Y-m-d', $valor);
    return $d && $d->format('Y-m-d') === $valor;
}
if (!dataValida($inicio) || !dataValida($fim) || $inicio > $fim || !in_array($situacao, ['TODAS','ATIVA','CANCELADA'], true)) {
    http_response_code(400);
    exit('Parâmetros inválidos.');
}
$sql = "SELECT v.num_venda, v.data_venda, COALESCE(c.nome, 'Cliente não informado') AS cliente, v.valor_total, v.situacao FROM venda v LEFT JOIN cliente c ON c.codigo = v.num_cliente WHERE v.data_venda >= :inicio AND v.data_venda < DATE_ADD(:fim, INTERVAL 1 DAY)";
$params = [':inicio' => $inicio, ':fim' => $fim];
if ($situacao !== 'TODAS') {
    $sql .= ' AND v.situacao = :situacao';
    $params[':situacao'] = $situacao;
}
$sql .= ' ORDER BY v.data_venda, v.num_venda';
try {
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $vendas = $stmt->fetchAll(PDO::FETCH_ASSOC);
}
catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Erro ao consultar as vendas.');
}
function esc($s) {
    return htmlspecialchars((string)$s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
function moeda($v) {
    return 'R$ ' . number_format((float)$v, 2, ',', '.');
}
$total = 0;
$linhas = '';
foreach ($vendas as $v) {
    $total += (float)$v['valor_total'];
    $data = date('d/m/Y', strtotime($v['data_venda']));
    $linhas .= '<tr><td>'.esc($v['num_venda']).'</td><td>'.esc($data).'</td><td>'.esc($v['cliente']).'</td><td>'.esc($v['situacao']).'</td><td class="numero">'.esc(moeda($v['valor_total'])).'</td></tr>';
}
if (!$vendas) $linhas = '<tr><td colspan="5" class="vazio">Nenhuma venda encontrada para os filtros informados.</td></tr>';
$periodo = date('d/m/Y', strtotime($inicio)).' a '.date('d/m/Y', strtotime($fim));
$html = '<!doctype html><html lang="pt-br"><head><meta charset="UTF-8"><style>@page{margin:22mm 14mm 18mm}body{font-family:DejaVu Sans,sans-serif;font-size:10px;color:#27374a}h1{font-size:19px;color:#174f85;margin:0 0 5px}.sub{color:#60748a;margin-bottom:18px}.meta{margin-bottom:15px}table{width:100%;border-collapse:collapse}th{background:#e9f2fa;color:#1d466d;text-align:left}th,td{padding:8px 7px;border-bottom:1px solid #dde6ee}tr{page-break-inside:avoid}.numero{text-align:right;white-space:nowrap}.vazio{text-align:center;padding:20px}.total{margin-top:18px;text-align:right;font-size:13px;font-weight:bold}.rodape{margin-top:20px;color:#8190a0;font-size:9px}</style></head><body><h1>RaviaSistemas</h1><div class="sub">Relatório de Vendas</div><div class="meta"><strong>Período:</strong> '.esc($periodo).' &nbsp; <strong>Situação:</strong> '.esc($situacao).' &nbsp; <strong>Registros:</strong> '.count($vendas).'</div><table><thead><tr><th>Venda</th><th>Data</th><th>Cliente</th><th>Situação</th><th class="numero">Valor</th></tr></thead><tbody>'.$linhas.'</tbody></table><div class="total">Total geral: '.esc(moeda($total)).'</div><div class="rodape">Gerado em '.date('d/m/Y H:i').'</div></body></html>';
$options = new \Dompdf\Options();
$options->set('isRemoteEnabled', false);
$options->set('defaultFont', 'DejaVu Sans');
$pdf = new \Dompdf\Dompdf($options);
$pdf->loadHtml($html, 'UTF-8');
$pdf->setPaper('A4', 'portrait');
$pdf->render();
$pdf->stream('relatorio_vendas.pdf', ['Attachment' => false]);
