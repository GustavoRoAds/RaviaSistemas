<?php
require_once __DIR__ . '/../models/Produto.php';

class ProdutoService
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    public function listarTodos()
    {
        $stmt = $this->pdo->query("SELECT * FROM produto ORDER BY id DESC");
        $linhas = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $produtos = [];
        foreach ($linhas as $linha) {
            $produtos[] = new Produto($linha);
        }
        return $produtos;
    }

    public function salvar($dados)
    {
        $stmt = $this->pdo->prepare("INSERT INTO produto (nome, descricao, categoria, valor_custo, valor_venda, estoque)
                                      VALUES (:nome, :descricao, :categoria, :valor_custo, :valor_venda, :estoque)");
        return $stmt->execute([
            'nome' => $dados['nome'],
            'descricao' => $dados['descricao'],
            'categoria' => $dados['categoria'],
            'valor_custo' => $dados['valor_custo'],
            'valor_venda' => $dados['valor_venda'],
            'estoque' => $dados['estoque']
        ]);
    }
}