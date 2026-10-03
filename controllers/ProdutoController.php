<?php
require_once __DIR__ . '/../services/ProdutoService.php';

class ProdutoController
{
    private $service;

    public function __construct($pdo)
    {
        $this->service = new ProdutoService($pdo);
    }

    public function listar()
    {
        $produtos = $this->service->listarTodos();
        require __DIR__ . '/../views/produtos/listar.php';
    }

    public function salvar($dadosPost)
    {
        $this->service->salvar($dadosPost);
        header('Location: produtos_listar.php');
        exit;
    }

    public function exibirFormulario()
    {
        require __DIR__ . '/../views/produtos/cadastro.php';
    }
}