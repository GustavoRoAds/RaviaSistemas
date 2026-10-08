CREATE TABLE IF NOT EXISTS produto (
    numProduto        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nomeProduto       VARCHAR(60)    NOT NULL,
    descricaoProduto  VARCHAR(200)   NULL,
    valorCusto        DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    valorVenda        DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    quantidadeEstoque INT            NOT NULL DEFAULT 0,
    categoria_id      INT UNSIGNED   NULL,
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (categoria_id) REFERENCES categoria (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;