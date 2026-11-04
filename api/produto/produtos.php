<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;
$busca = $_GET['busca'] ?? null;
$situacao = $_GET['situacao'] ?? 'ativos';
if (!in_array($situacao, ['ativos', 'inativos', 'todos'], true)) { http_response_code(400); echo json_encode(['erro' => 'Filtro inválido']); exit; }
$filtroAtivo = $situacao === 'todos' ? '' : ($situacao === 'inativos' ? 'ativo = 0 AND ' : 'ativo = 1 AND ');
$dados = json_decode(file_get_contents('php://input'), true);

switch ($metodo) {

    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare('SELECT p.*, fn_estoque(p.id) AS estoque FROM produto p WHERE p.id = :codigo');
            $stmt->execute([':codigo' => $id]);
            $produto = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$produto) {
                http_response_code(404);
                echo json_encode(['erro' => 'Produto não encontrado']);
                break;
            }
            echo json_encode($produto);
        } else {
            if ($busca) {
                $stmt = $pdo->prepare('SELECT p.*, fn_estoque(p.id) AS estoque FROM produto p WHERE ' . str_replace('ativo', 'p.ativo', $filtroAtivo) . 'p.nome LIKE :busca ');
                $stmt->execute([':busca' => '%' . $busca . '%']);
                $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($resultados);      
            }else {
                $stmt = $pdo->query('SELECT p.*, fn_estoque(p.id) AS estoque FROM produto p WHERE ' . ($situacao === 'todos' ? '1=1' : ($situacao === 'inativos' ? 'p.ativo = 0' : 'p.ativo = 1')) . ' ORDER BY p.id DESC');
                echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            }
        }
        break;

        
    case 'POST':
        if (empty($dados['nome']) || !isset($dados['preco'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe nome e preco']);
            break;
        }


        // if (!empty($dados['categoria_id'])) {
        //     $stmt = $pdo->prepare('SELECT id FROM categoria WHERE id = :id');
        //     $stmt->execute([
        //         ':id' => $dados['categoria_id']
        //     ]);
            
        //     $categoria = $stmt->fetch(PDO::FETCH_ASSOC);
            
        //     if (!$categoria) {
        //         http_response_code(400);
        //         echo json_encode(['erro' => 'categoria não encontrada']);
        //         break;
        //     }
        // }

      $stmt = $pdo->prepare('
    INSERT INTO produto
        (
            nome, descricao, categoria,
            valor_custo, valor_venda
        )
        VALUES
        (
            :nomeProduto, :descricaoProduto, :categoria,
            :valorCusto, :valorVenda
        )
');

$stmt->execute([
    ':nomeProduto' => $dados['nome'],
    ':descricaoProduto' => $dados['descricao'] ?? null,
    ':categoria' => $dados['categoria'] ?? null,
    ':valorCusto' => $dados['custo'] ?? 0,
    ':valorVenda' => $dados['valor']
]);

        http_response_code(201);
        echo json_encode(['id' => $pdo->lastInsertId()]);
        break;

        case 'PUT':
    if (!$id) {
        http_response_code(400);
        echo json_encode(['erro' => 'Informe o ID do produto.']);
        break;
    }

    if (empty($dados['nome']) || !isset($dados['valor'])) {
        http_response_code(400);
        echo json_encode(['erro' => 'Informe nome e valor de venda.']);
        break;
    }

    $verificar = $pdo->prepare(
        'SELECT id FROM produto WHERE id = :id'
    );
    $verificar->execute([':id' => $id]);

    if (!$verificar->fetch(PDO::FETCH_ASSOC)) {
        http_response_code(404);
        echo json_encode(['erro' => 'Produto não encontrado.']);
        break;
    }

    $stmt = $pdo->prepare('
        UPDATE produto
        SET
            nome = :nome,
            descricao = :descricao,
            categoria = :categoria,
            valor_custo = :custo,
            valor_venda = :valor
        WHERE id = :id
    ');

    $stmt->execute([
        ':nome' => $dados['nome'],
        ':descricao' => $dados['descricao'] ?? null,
        ':categoria' => $dados['categoria'] ?? null,
        ':custo' => $dados['custo'] ?? 0,
        ':valor' => $dados['valor'],
        ':id' => $id
    ]);

    http_response_code(200);
    echo json_encode([
        'id' => $id,
        'mensagem' => 'Produto atualizado com sucesso.'
    ]);
    break;

    case 'PATCH':
        if (!$id || !isset($dados['ativo']) || !in_array($dados['ativo'], [0, 1, true, false], true)) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o código e a situação']);
            break;
        }
        $stmt = $pdo->prepare('UPDATE produto SET ativo = :ativo WHERE id = :id');
        $stmt->execute([':ativo' => (int)$dados['ativo'], ':id' => $id]);
        $verificar = $pdo->prepare('SELECT ativo FROM produto WHERE id = :id');
        $verificar->execute([':id' => $id]);
        $registro = $verificar->fetch(PDO::FETCH_ASSOC);
        if (!$registro) { http_response_code(404); echo json_encode(['erro' => 'Cadastro não encontrado']); break; }
        echo json_encode(['sucesso' => true, 'ativo' => (int)$registro['ativo']]);
        break;

    case 'DELETE':
        if (!$id || $id < 1) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o código do produto']);
            break;
        }
        $stmt = $pdo->prepare('UPDATE produto SET ativo = 0 WHERE id = :id AND ativo = 1');
        $stmt->execute([':id' => $id]);
        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['erro' => 'Produto não encontrado ou já inativo']);
            break;
        }
        echo json_encode(['sucesso' => true, 'mensagem' => 'Produto inativado com sucesso']);
        break;

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}