<?php
require_once __DIR__.'/_pdf_base.php';
$inicio=$_GET['inicio']??'';
$fim=$_GET['fim']??'';
if(!validDate($inicio)||!validDate($fim)||$inicio>$fim) {
    http_response_code(400);
    exit('Periodo invalido.');
}
$situacao=$_GET['situacao']??'TODAS';
$ordem=$_GET['ordem']??'codigo';
if(!in_array($situacao,['TODAS','ATIVA','CANCELADA'],true)||!in_array($ordem,['codigo','cliente'],true)) {
    http_response_code(400);
    exit('Filtro invalido.');
}
$produto=getInt('produto');
$cliente=getInt('cliente');
$funcionario=getInt('funcionario');
$where=['v.data_venda >= :inicio','v.data_venda < DATE_ADD(:fim, INTERVAL 1 DAY)'];
$params=[':inicio'=>$inicio,':fim'=>$fim];
if($situacao!=='TODAS') {
    $where[]='v.situacao = :situacao';
    $params[':situacao']=$situacao;
}
if($cliente) {
    $where[]='v.num_cliente = :cliente';
    $params[':cliente']=$cliente;
}
if($funcionario) {
    $where[]='v.num_funcionario = :funcionario';
    $params[':funcionario']=$funcionario;
}
if($produto) {
    $where[]='EXISTS(SELECT 1 FROM item_venda filtro WHERE filtro.num_venda=v.num_venda AND filtro.num_produto=:produto)';
    $params[':produto']=$produto;
}
$order=$ordem==='cliente'?'c.nome ASC, v.num_venda ASC':'v.num_venda ASC';
$sql='SELECT v.*,c.nome cliente_nome,f.nome funcionario_nome FROM venda v LEFT JOIN cliente c ON c.codigo=v.num_cliente LEFT JOIN funcionario f ON f.id=v.num_funcionario WHERE '.implode(' AND ',$where).' ORDER BY '.$order;
try {
    $st=$pdo->prepare($sql);
    $st->execute($params);
    $vendas=$st->fetchAll(PDO::FETCH_ASSOC);
    $itemSt=$pdo->prepare('SELECT iv.*,p.nome produto_nome FROM item_venda iv LEFT JOIN produto p ON p.id=iv.num_produto WHERE iv.num_venda=:venda ORDER BY p.nome,iv.num_produto');
}
catch(Throwable $e) {
    error_log('Relatorio vendas: '.$e->getMessage());
    http_response_code(500);
    exit('Erro ao consultar vendas. Confira se executou a atualizacao SQL do funcionario.');
}
$pdf=startPdf('Relatorio completo de vendas',dateBR($inicio).' a '.dateBR($fim).' | Situacao: '.$situacao.' | Ordem: '.$ordem,true);
$pdf->SetFont('Arial','',9);
$pdf->Cell(0,7,pdfText('Vendas encontradas: '.count($vendas)),0,1);
$totalAtivo=0;
$totalCancelado=0;
$qtdItens=0;
foreach($vendas as $v) {
    $pdf->headingLine('Venda #'.$v['num_venda'].' | '.dateBR($v['data_venda']).' | '.($v['situacao']==='ATIVA'?'FATURADA / ATIVA':'CANCELADA').' | '.money($v['valor_total']));
    $pdf->lineText('Cliente: '.($v['cliente_nome']??'Nao informado').' Funcionario: '.($v['funcionario_nome']??'Nao vinculado'));
    $pdf->SetFont('Arial','B',8);
    $pdf->SetDrawColor(210,210,210);
    $pdf->Cell(22,7,'Codigo','B',0,'L');
    $pdf->Cell(144,7,'Produto','B',0,'L');
    $pdf->Cell(20,7,'Qtd.','B',0,'R');
    $pdf->Cell(32,7,'Unitario','B',0,'R');
    $pdf->Cell(39,7,'Subtotal','B',1,'R');
    $itemSt->execute([':venda'=>$v['num_venda']]);
    $items=$itemSt->fetchAll(PDO::FETCH_ASSOC);
    foreach($items as $it) {
        $qtdItens+=(int)$it['quantidade'];
        $pdf->SetFont('Arial','',8);
        $pdf->Cell(22,7,$it['num_produto'],'B');
        $nome=pdfText($it['produto_nome']??'Produto removido');
        $pdf->Cell(144,7,mb_strimwidth($nome,0,78,'...'),'B');
        $pdf->Cell(20,7,$it['quantidade'],'B',0,'R');
        $pdf->Cell(32,7,pdfText(money($it['preco_unitario'])),'B',0,'R');
        $pdf->Cell(39,7,pdfText(money($it['subtotal_item'])),'B',1,'R');
    }
    $pdf->SetFont('Arial','',8);
    $pdf->Cell(0,6,pdfText('Desconto valor: '.money($v['desconto_valor']).' | Desconto %: '.$v['desconto_percentual'].'% | Acrescimo: '.money($v['acrescimo'])),0,1);
    if($v['situacao']==='CANCELADA') {
        $totalCancelado+=(float)$v['valor_total'];
        $pdf->lineText('Cancelamento: '.dateBR($v['cancelada_em']).' | Motivo: '.($v['motivo_cancelamento']??'-'),5);
    }
    else {
        $totalAtivo+=(float)$v['valor_total'];
    }
    if(trim((string)$v['observacao'])!=='')$pdf->lineText('Observacao: '.$v['observacao'],5);
    $pdf->Ln(5);
}
if(!$vendas)$pdf->lineText('Nenhuma venda encontrada para os filtros selecionados.');
$pdf->headingLine('Resumo');
$pdf->lineText('Quantidade de vendas: '.count($vendas).' | Unidades vendidas (incluindo canceladas): '.$qtdItens);
$pdf->lineText('Total faturado (ativas): '.money($totalAtivo).' | Total cancelado: '.money($totalCancelado));
$pdf->Output('I','relatorio_vendas.pdf');
