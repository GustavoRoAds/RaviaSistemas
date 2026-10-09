<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/conexao.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;
$busca = $_GET['busca'] ?? null;

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
                $stmt = $pdo->prepare('SELECT * FROM cliente WHERE nome LIKE :busca OR cpf LIKE :busca OR telefone LIKE :busca');
                $stmt->execute([':busca' => '%' . $busca . '%']);
                $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($resultados);      

            }else {
                $stmt = $pdo->query('SELECT * FROM cliente ORDER BY codigo DESC');
                echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            }

        }
        break;

        
    case 'POST':
        if (empty($dados['cpf']) || !isset($dados['nome'])) {
            http_response_code(400);
            echo json_encode(['erro' => 'Informe CPF e nome']);
            break;
        }


        $stmt = $pdo->prepare('
                INSERT INTO cliente 
                    (
                        nome, telefone, cpf, email, cep,
                        endereco, numero, bairro, cidade
                    ) 
                    VALUES 
                    (
                        :nome, :telefone, :cpf, :email, :cep, 
                        :endereco, : numero, :bairro, :cidade 
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
        ]);    

        http_response_code(201);
        echo json_encode(['id' => $pdo->lastInsertId()]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['erro' => 'Método não permitido']);
}