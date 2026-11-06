<?php
header('Content-Type: application/json; charset=utf-8');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once __DIR__ . '/../../config/conexao.php';

function documentoValido($valor) {
    $n = preg_replace('/\D/', '', (string)$valor);
    if (!in_array(strlen($n), [11, 14], true) || preg_match('/^(\d)\1+$/', $n)) return false;
    if (strlen($n) === 11) {
        for ($t = 9; $t < 11; $t++) {
            $soma = 0;
            for ($i = 0; $i < $t; $i++) $soma += (int)$n[$i] * ($t + 1 - $i);
            $dig = (11 - $soma % 11) % 11 % 10;
            if ($dig !== (int)$n[$t]) return false;
        }
        return true;
    }
    foreach ([[5,4,3,2,9,8,7,6,5,4,3,2], [6,5,4,3,2,9,8,7,6,5,4,3,2]] as $pesos) {
        $soma = 0;
        foreach ($pesos as $i => $peso) $soma += (int)$n[$i] * $peso;
        $dig = (11 - $soma % 11) % 11 % 10;
        if ($dig !== (int)$n[count($pesos)]) return false;
    }
    return true;
}

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
            $stmt = $pdo->prepare('SELECT * FROM cliente WHERE codigo = :codigo');
            $stmt->execute([':codigo' => $id]);
            $cliente = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$cliente) {
                http_response_code(404);
                echo json_encode(['erro' => 'cliente não encontrado']);
                break;
            }
            echo json_encode($cliente);
        } else {
             
            if ($busca) {
                $stmt = $pdo->prepare('SELECT * FROM cliente WHERE ' . $filtroAtivo . '(nome LIKE :busca OR cpf LIKE :busca OR telefone LIKE :busca)');
                $stmt->execute([':busca' => '%' . $busca . '%']);
                $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($resultados);      

            }else {
                $stmt = $pdo->query('SELECT * FROM cliente WHERE ' . ($situacao === 'todos' ? '1=1' : ($situacao === 'inativos' ? 'ativo = 0' : 'ativo = 1')) . ' ORDER BY codigo DESC');
                echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            }

        }
        break;

        
    case 'POST':
        if (!documentoValido($dados['cpf'] ?? '')) { http_response_code(400); echo json_encode(['erro' => 'CPF ou CNPJ inválido']); break; }
        if (empty($dados['cpf']) || !isset($dados['nome'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe CPF/CNPJ e nome']);
            break;
        }


        $stmt = $pdo->prepare('
                INSERT INTO cliente 
                    (
                        nome, telefone, cpf, email, cep,
                        endereco, numero, bairro, cidade, usuario_id
                    ) 
                    VALUES 
                    (
                        :nome, :telefone, :cpf, :email, :cep, 
                        :endereco, :numero, :bairro, :cidade, :usuario_id 
                    )');
    
        $stmt->execute([
            ':nome'  => $dados['nome'],
            ':telefone' => $dados['telefone'] ?? null,
            ':cpf' => $dados['cpf'],
            ':email' => $dados['email'] ?? null,
            ':cep' => $dados['cep'] ?? null,
            ':endereco' => $dados['endereco'] ?? null,
            ':numero' => $dados['numero'] ?? null,
            ':bairro' => $dados['bairro'] ?? null,
            ':cidade' => $dados['cidade'] ?? null,
            ':usuario_id' => $_SESSION['usuario_id']
        ]);    

        http_response_code(201);
        echo json_encode(['id' => $pdo->lastInsertId()]);
        break;

    case 'PUT':
        if (!documentoValido($dados['cpf'] ?? '')) { http_response_code(400); echo json_encode(['erro' => 'CPF ou CNPJ inválido']); break; }
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM cliente WHERE codigo = :codigo');
            $stmt->execute([':codigo' => $id]);
            $cliente = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$cliente) {
                http_response_code(404);
                echo json_encode(['erro' => 'cliente não encontrado']);
                break;
            }

            $stmt = $pdo->prepare('
                UPDATE cliente SET 
                    nome = :nome,
                    telefone = :telefone,
                    cpf = :cpf,
                    email = :email,
                    cep = :cep,
                    endereco = :endereco,
                    numero = :numero,
                    bairro = :bairro,
                    cidade = :cidade
                WHERE codigo = :codigo
            ');
            $stmt->execute([
                ':codigo'  => $id,
                ':nome'  => $dados['nome'],
                ':telefone' => $dados['telefone'] ?? null,
                ':cpf' => $dados['cpf'],
                ':email' => $dados['email'] ?? null,
                ':cep' => $dados['cep'] ?? null,
                ':endereco' => $dados['endereco'] ?? null,
                ':numero' => $dados['numero'] ?? null,
                ':bairro' => $dados['bairro'] ?? null,
                ':cidade' => $dados['cidade'] ?? null,
            ]); 
            
            http_response_code(201);
            echo json_encode(['id' => $pdo->lastInsertId()]);
            break;
            
        } else {
            http_response_code(404);
            echo json_encode(['erro' => 'codigo não encontrado']);
        }
        break;
    case 'PATCH':
        if (!$id || !isset($dados['ativo']) || !in_array($dados['ativo'], [0, 1, true, false], true)) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe o código e a situação']);
            break;
        }
        $stmt = $pdo->prepare('UPDATE cliente SET ativo = :ativo WHERE codigo = :id');
        $stmt->execute([':ativo' => (int)$dados['ativo'], ':id' => $id]);
        $verificar = $pdo->prepare('SELECT ativo FROM cliente WHERE codigo = :id');
        $verificar->execute([':id' => $id]);
        $registro = $verificar->fetch(PDO::FETCH_ASSOC);
        if (!$registro) { http_response_code(404); echo json_encode(['erro' => 'Cadastro não encontrado']); break; }
        echo json_encode(['sucesso' => true, 'ativo' => (int)$registro['ativo']]);
        break;

    case 'DELETE':
            if ($id) {
                $stmt = $pdo->prepare('SELECT * FROM cliente WHERE codigo = :codigo');
                $stmt->execute([':codigo' => $id]);
                $cliente = $stmt->fetch(PDO::FETCH_ASSOC);
    
                if (!$cliente) {
                    http_response_code(404);
                    echo json_encode(['erro' => 'cliente não encontrado']);
                    break;
                };
    
                $stmt = $pdo->prepare('UPDATE cliente SET ativo = 0 WHERE codigo = :codigo');
                $stmt->execute([':codigo' => $id]);

                echo json_encode(['sucesso' => true, 'mensagem' => 'Cliente inativado com sucesso']);
            }
            break;
    

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}