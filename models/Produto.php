<?php
class Produto
{
    public $id;
    public $nome;
    public $descricao;
    public $categoria;
    public $valor_custo;
    public $valor_venda;
    public $estoque;

    public function __construct($dados = [])
    {
        $this->id = $dados['id'] ?? null;
        $this->nome = $dados['nome'] ?? '';
        $this->descricao = $dados['descricao'] ?? '';
        $this->categoria = $dados['categoria'] ?? '';
        $this->valor_custo = $dados['valor_custo'] ?? 0;
        $this->valor_venda = $dados['valor_venda'] ?? 0;
        $this->estoque = $dados['estoque'] ?? 0;
    }
}