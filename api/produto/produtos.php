<?php
// =====================================================
//  API DE PRODUTOS
//
//  GET  api/produtos.php          -> lista todos os produtos
//  GET  api/produtos.php?id=5     -> busca um produto pelo código
//  POST api/produtos.php          -> cadastra um produto novo
//  PUT  api/produtos.php?id=5     -> altera um produto que já existe
//
//  Os dados do POST e do PUT são enviados em JSON:
//  { "nome": "Sutiã", "descricao": "...", "custo": 22.5, "valor": 49.9, "categoria_id": 1 }
//  (obrigatórios: nome e valor)
// =====================================================

session_start();
header('Content-Type: application/json; charset=utf-8');

// true  = quando der erro no banco, a resposta mostra o motivo (bom para testar)
// false = mostra só uma mensagem genérica (use quando o sistema for para o ar)
$MODO_DEBUG = true;

// erros do PHP não podem aparecer na resposta, senão quebram o JSON
ini_set('display_errors', '0');


// ----- função que envia a resposta e encerra -----
function responder(int $status, array $corpo): void
{
    http_response_code($status);
    echo json_encode($corpo, JSON_UNESCAPED_UNICODE);
    exit;
}

// ----- só quem está logado pode usar a API -----
if (!isset($_SESSION['usuario_id'])) {
    responder(401, ['erro' => 'Não autorizado. Faça login.']);
}

require __DIR__ . '/../config/conexao.php';
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);   // erros do banco viram exceção (capturamos lá embaixo)


// ----- confere os dados enviados e devolve já limpos e prontos para salvar -----
function lerDadosDoProduto(PDO $pdo, array $dados): array
{
    // nome (obrigatório)
    $nome = isset($dados['nome']) && is_scalar($dados['nome']) ? trim((string) $dados['nome']) : '';
    if ($nome === '') {
        responder(400, ['erro' => 'Informe o nome do produto.']);
    }

    // valor de venda (obrigatório, maior que zero). Aceita "valor" (o certo) ou "preco" (nome antigo)
    $valor = $dados['valor'] ?? $dados['preco'] ?? null;
    if (!is_numeric($valor) || (float) $valor <= 0) {
        responder(400, ['erro' => 'Informe um valor de venda maior que zero.']);
    }

    // custo (opcional)
    $custo = $dados['custo'] ?? null;
    if ($custo === '') {
        $custo = null;
    }
    if ($custo !== null && (!is_numeric($custo) || (float) $custo < 0)) {
        responder(400, ['erro' => 'O custo precisa ser um número igual ou maior que zero.']);
    }

    // descrição (opcional)
    $descricao = isset($dados['descricao']) && is_scalar($dados['descricao']) ? trim((string) $dados['descricao']) : '';
    if ($descricao === '') {
        $descricao = null;
    }

    // categoria (opcional, mas se for informada precisa existir)
    $categoriaId = $dados['categoria_id'] ?? null;
    if ($categoriaId === '') {
        $categoriaId = null;
    }
    if ($categoriaId !== null) {
        if (!is_numeric($categoriaId)) {
            responder(400, ['erro' => 'Categoria inválida.']);
        }
        $categoriaId = (int) $categoriaId;

        $stmt = $pdo->prepare('SELECT id FROM categoria WHERE id = :id');
        $stmt->execute([':id' => $categoriaId]);
        if (!$stmt->fetch(PDO::FETCH_ASSOC)) {
            responder(400, ['erro' => 'Categoria não encontrada.']);
        }
    }

    return [
        ':nomeProduto'      => $nome,
        ':descricaoProduto' => $descricao,
        ':valorCusto'       => $custo === null ? null : round((float) $custo, 2),
        ':valorVenda'       => round((float) $valor, 2),
        ':categoria_id'     => $categoriaId,
    ];
}


// ----- lendo o pedido -----
$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;

$dados = [];
if ($metodo === 'POST' || $metodo === 'PUT') {
    $dados = json_decode(file_get_contents('php://input'), true);
    if (!is_array($dados)) {
        responder(400, ['erro' => 'Envie os dados em formato JSON.']);
    }
}


try {

    switch ($metodo) {

        // ---------- GET: listar ou buscar um ----------
        case 'GET':
            if ($id > 0) {
                $stmt = $pdo->prepare('SELECT * FROM produtos WHERE codigo = :codigo');
                $stmt->execute([':codigo' => $id]);
                $produto = $stmt->fetch(PDO::FETCH_ASSOC);

                if (!$produto) {
                    responder(404, ['erro' => 'Produto não encontrado.']);
                }
                responder(200, $produto);
            }

            $stmt = $pdo->query('SELECT * FROM produtos ORDER BY codigo DESC');
            responder(200, $stmt->fetchAll(PDO::FETCH_ASSOC));
            break;

        // ---------- POST: cadastrar ----------
        case 'POST':
            $valores = lerDadosDoProduto($pdo, $dados);

            $stmt = $pdo->prepare('
                INSERT INTO produtos
                    (nomeProduto, descricaoProduto, valorCusto, valorVenda, categoria_id)
                VALUES
                    (:nomeProduto, :descricaoProduto, :valorCusto, :valorVenda, :categoria_id)
            ');
            $stmt->execute($valores);

            responder(201, ['id' => (int) $pdo->lastInsertId()]);
            break;

        // ---------- PUT: alterar ----------
        case 'PUT':
            if ($id <= 0) {
                responder(400, ['erro' => 'Informe o código do produto na URL (?id=).']);
            }

            // confere se o produto existe
            $stmt = $pdo->prepare('SELECT codigo FROM produtos WHERE codigo = :codigo');
            $stmt->execute([':codigo' => $id]);
            if (!$stmt->fetch(PDO::FETCH_ASSOC)) {
                responder(404, ['erro' => 'Produto não encontrado.']);
            }

            $valores = lerDadosDoProduto($pdo, $dados);
            $valores[':codigo'] = $id;





        $stmt = $pdo->prepare('
            UPDATE produtos SET
                nomeProduto = :nomeProduto,
                descricaoProduto = :descricaoProduto,
                valorCusto = :valorCusto,
                valorVenda = :valorVenda,
                categoria_id = :categoria_id
            WHERE codigo = :codigo');

        $stmt->execute([
            ':nomeProduto'      => $dados['nome'],
            ':descricaoProduto' => $dados['descricao'] ?? null,
            ':valorCusto'       => $dados['custo'] ?? null,
            ':valorVenda'       => $dados['valor'],
            ':categoria_id'     => $dados['categoria_id'] ?? null,
            ':codigo'           => $id,
        ]);

            responder(200, ['ok' => true]);
            break;







        // ---------- qualquer outro método ----------
        default:
            header('Allow: GET, POST, PUT');
            responder(405, ['erro' => 'Método não permitido.']);
    }

} catch (PDOException $e) {
    // erro no banco de dados: guarda no log do servidor e responde em JSON
    error_log('[api/produtos.php] ' . $e->getMessage());

    $resposta = ['erro' => 'Erro ao acessar o banco de dados.'];
    if ($MODO_DEBUG) {
        $resposta['detalhe'] = $e->getMessage();
    }
    responder(500, $resposta);
}