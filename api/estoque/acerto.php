<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
if (empty($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['erro'=>'Não autenticado']);
    exit;
}
require_once __DIR__ . '/../../config/conexao.php';
$metodo = $_SERVER['REQUEST_METHOD'];
try {
    if ($metodo === 'GET') {
        $data = $_GET['data'] ?? date('Y-m-d');
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $data) || !checkdate((int)substr($data,5,2),(int)substr($data,8,2),(int)substr($data,0,4))) throw new InvalidArgumentException('Data inválida');
        $stmt=$pdo->prepare('SELECT id, data_emissao FROM acerto_estoque WHERE data_emissao = :data ORDER BY id DESC');
        $stmt->execute([':data'=>$data]);
        $acertos=$stmt->fetchAll(PDO::FETCH_ASSOC);
        $itensStmt=$pdo->prepare('SELECT i.produto_id, p.nome, i.quantidade FROM acerto_estoque_item i JOIN produto p ON p.id=i.produto_id WHERE i.acerto_id=:id ORDER BY i.id');
        foreach($acertos as &$acerto) {
            $itensStmt->execute([':id'=>$acerto['id']]);
            $acerto['itens']=$itensStmt->fetchAll(PDO::FETCH_ASSOC);
        }
        unset($acerto);
        echo json_encode($acertos);
        exit;
    }
    if ($metodo !== 'POST') {
        http_response_code(405);
        header('Allow: GET, POST');
        echo json_encode(['erro'=>'Método não permitido']);
        exit;
    }
    $dados=json_decode(file_get_contents('php://input'),true);
    $data=$dados['data_emissao']??'';
    $itens=$dados['itens']??null;
    if (!is_string($data)||!preg_match('/^\d{4}-\d{2}-\d{2}$/',$data)||!checkdate((int)substr($data,5,2),(int)substr($data,8,2),(int)substr($data,0,4))||!is_array($itens)||!count($itens)) throw new InvalidArgumentException('Informe data e produtos válidos');
    $agrupados=[];
    foreach($itens as $item) {
        $id=filter_var($item['produto_id']??null,FILTER_VALIDATE_INT);
        $q=filter_var($item['quantidade']??null,FILTER_VALIDATE_INT);
        if(!$id||$id<1||$q===false||$q===0)throw new InvalidArgumentException('Produto ou quantidade inválida');
        $agrupados[$id]=($agrupados[$id]??0)+$q;
    }
    ksort($agrupados,SORT_NUMERIC);
    $pdo->beginTransaction();
    $inserir=$pdo->prepare('INSERT INTO acerto_estoque (data_emissao, usuario_id) VALUES (:data,:usuario)');
    $inserir->execute([':data'=>$data,':usuario'=>(string)$_SESSION['usuario_id']]);
    $acertoId=(int)$pdo->lastInsertId();
    $bloquear=$pdo->prepare('SELECT id FROM produto WHERE id=:id FOR UPDATE');
    $saldo=$pdo->prepare('SELECT fn_estoque(:id)');
    $itemStmt=$pdo->prepare('INSERT INTO acerto_estoque_item (acerto_id, produto_id, quantidade) VALUES (:acerto,:produto,:quantidade)');
    foreach($agrupados as $id=>$q) {
        if($q===0)continue;
        $bloquear->execute([':id'=>$id]);
        if(!$bloquear->fetch())throw new InvalidArgumentException('Produto '.$id.' não encontrado');
        $saldo->execute([':id'=>$id]);
        $atual=(int)$saldo->fetchColumn();
        if($atual+$q<0)throw new InvalidArgumentException('Estoque insuficiente para o produto '.$id);
        $itemStmt->execute([':acerto'=>$acertoId,':produto'=>$id,':quantidade'=>$q]);
    }
    $pdo->commit();
    http_response_code(201);
    echo json_encode(['id'=>$acertoId,'mensagem'=>'Acerto salvo com sucesso']);
} catch (Throwable $e) {
    if($pdo->inTransaction())$pdo->rollBack();
    http_response_code($e instanceof InvalidArgumentException?400:500);
    echo json_encode(['erro'=>$e instanceof InvalidArgumentException?$e->getMessage():'Erro ao processar acerto de estoque']);
}
