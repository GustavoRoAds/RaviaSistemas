-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 06-Nov-2026 às 00:09
-- Versão do servidor: 10.4.27-MariaDB
-- versão do PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `ravia_db`
--

DELIMITER $$
--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_estoque` (`p_produto_id` INT) RETURNS INT(11) READS SQL DATA BEGIN
 DECLARE v_entradas INT DEFAULT 0;
 DECLARE v_saidas INT DEFAULT 0;
 DECLARE v_acertos INT DEFAULT 0;
 SELECT COALESCE(SUM(quantidade),0) INTO v_entradas FROM entrada_estoque WHERE produto_id=p_produto_id;
 SELECT COALESCE(SUM(i.quantidade),0) INTO v_saidas FROM item_venda i INNER JOIN venda v ON v.num_venda=i.num_venda WHERE i.num_produto=p_produto_id AND v.situacao='ATIVA';
 SELECT COALESCE(SUM(quantidade),0) INTO v_acertos FROM acerto_estoque_item WHERE produto_id=p_produto_id;
 RETURN v_entradas+v_acertos-v_saidas;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `acerto_estoque`
--

CREATE TABLE `acerto_estoque` (
  `id` int(11) NOT NULL,
  `data_emissao` date NOT NULL,
  `usuario_id` varchar(128) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `acerto_estoque`
--

INSERT INTO `acerto_estoque` (`id`, `data_emissao`, `usuario_id`, `criado_em`) VALUES
(1, '2026-11-05', 'g6qJfPuX9HN4zalYwrHbl1TTDcp2', '2026-11-05 19:56:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `acerto_estoque_item`
--

CREATE TABLE `acerto_estoque_item` (
  `id` int(11) NOT NULL,
  `acerto_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `acerto_estoque_item`
--

INSERT INTO `acerto_estoque_item` (`id`, `acerto_id`, `produto_id`, `quantidade`) VALUES
(1, 1, 1, 15);

-- --------------------------------------------------------

--
-- Estrutura da tabela `cliente`
--

CREATE TABLE `cliente` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(60) NOT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cep` varchar(9) DEFAULT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `bairro` varchar(60) DEFAULT NULL,
  `cidade` varchar(60) DEFAULT NULL,
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `cliente`
--

INSERT INTO `cliente` (`codigo`, `nome`, `telefone`, `cpf`, `email`, `cep`, `endereco`, `numero`, `bairro`, `cidade`, `usuario_id`, `ativo`) VALUES
(1, 'Ana Paula Ferreira', '(44) 99123-4567', '123.456.789-00', 'ana.ferreira@email.com', '87200-000', 'Rua das Flores', '120', 'Centro', 'Cianorte', NULL, 1),
(2, 'Bruno Carvalho Lima', '(44) 98877-2211', '234.567.890-11', 'bruno.lima@email.com', '87203-150', 'Avenida Brasil', '845', 'Jardim América', 'Cianorte', NULL, 1),
(3, 'Carla Souza Martins', '(44) 99654-3322', '345.678.901-22', 'carla.martins@email.com', '87200-310', 'Rua Paraná', '45', 'Vila Rica', 'Cianorte', NULL, 1),
(4, 'Diego Oliveira Santos', '(44) 98765-4321', '456.789.012-33', 'diego.santos@email.com', '87205-700', 'Rua Minas Gerais', '301', 'Industrial', 'Cianorte', NULL, 1),
(5, 'Fernanda Costa Rocha', '(44) 99988-7766', '567.890.123-44', 'fernanda.rocha@email.com', '87200-480', 'Rua Goiás', '78', 'Centro', 'Cianorte', NULL, 1),
(9, 'Patrícia Gomes Ribeiro', '(44) 99234-5566', '901.234.567-88', 'patricia.ribeiro@email.com', '87200-610', 'Avenida Pioneiros', '99', 'Alvorada', 'Cianorte', NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `entrada_estoque`
--

CREATE TABLE `entrada_estoque` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `data_entrada` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `cargo` varchar(60) DEFAULT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `data_admissao` date DEFAULT NULL,
  `salario` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `funcionario`
--

INSERT INTO `funcionario` (`id`, `nome`, `cpf`, `cargo`, `telefone`, `email`, `data_admissao`, `salario`, `ativo`, `criado_em`, `usuario_id`) VALUES
(1, 'Lucas Martins Pereira', '111.222.333-44', 'Gerente', '(44) 99111-2233', 'lucas.pereira@ravia.com', '2024-03-04', '4500.00', 1, '2026-10-20 23:27:50', NULL),
(2, 'Mariana Alves Costa', '222.333.444-55', 'Vendedora', '(44) 98822-3344', 'mariana.costa@ravia.com', '2024-08-12', '2200.00', 1, '2026-10-20 23:27:50', NULL),
(3, 'Thiago Ramos Silva', '333.444.555-66', 'Vendedor', '(44) 99933-4455', 'thiago.silva@ravia.com', '2025-01-20', '2200.00', 0, '2026-10-20 23:27:50', NULL),
(4, 'Camila Rodrigues Lopes', '444.555.666-77', 'Caixa', '(44) 98744-5566', 'camila.lopes@ravia.com', '2025-06-02', '1950.00', 0, '2026-10-20 23:27:50', NULL),
(5, 'Eduardo Santos Barros', '555.666.777-88', 'Estoquista', '(44) 99655-6677', 'eduardo.barros@ravia.com', '2025-11-17', '1850.00', 0, '2026-10-20 23:27:50', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `item_venda`
--

CREATE TABLE `item_venda` (
  `num_venda` int(11) NOT NULL,
  `num_produto` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `desconto_valor` decimal(10,2) NOT NULL DEFAULT 0.00,
  `desconto_percentual` decimal(5,2) NOT NULL DEFAULT 0.00,
  `acrescimo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal_item` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `item_venda`
--

INSERT INTO `item_venda` (`num_venda`, `num_produto`, `quantidade`, `preco_unitario`, `desconto_valor`, `desconto_percentual`, `acrescimo`, `subtotal_item`) VALUES
(1, 1, 1, '49.90', '0.00', '0.00', '0.00', '49.90');

--
-- Acionadores `item_venda`
--
DELIMITER $$
CREATE TRIGGER `trg_item_venda_baixa_estoque` BEFORE INSERT ON `item_venda` FOR EACH ROW BEGIN
 DECLARE v_id INT DEFAULT NULL;
 DECLARE v_saldo INT DEFAULT 0;
 IF NEW.quantidade<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantidade deve ser maior que zero'; END IF;
 SELECT id INTO v_id FROM produto WHERE id=NEW.num_produto FOR UPDATE;
 IF v_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Produto inexistente'; END IF;
 SET v_saldo=fn_estoque(NEW.num_produto);
 IF v_saldo<NEW.quantidade THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Estoque insuficiente'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `movimento_estoque`
--

CREATE TABLE `movimento_estoque` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `tipo` enum('E','S') NOT NULL,
  `quantidade` int(11) NOT NULL,
  `origem` varchar(30) NOT NULL,
  `referencia_id` int(11) DEFAULT NULL,
  `data_movimento` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `movimento_financeiro`
--

CREATE TABLE `movimento_financeiro` (
  `id` int(11) NOT NULL,
  `num_venda` int(11) NOT NULL,
  `tipo` enum('ENTRADA','SAIDA') NOT NULL,
  `forma_pagamento` varchar(50) NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `data_movimento` date NOT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `movimento_financeiro`
--

INSERT INTO `movimento_financeiro` (`id`, `num_venda`, `tipo`, `forma_pagamento`, `valor`, `data_movimento`, `criado_em`) VALUES
(1, 1, 'ENTRADA', 'PIX', '49.90', '2026-11-05', '2026-11-05 22:57:46');

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto`
--

CREATE TABLE `produto` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `valor_custo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `valor_venda` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estoque` int(11) NOT NULL DEFAULT 0,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `produto`
--

INSERT INTO `produto` (`id`, `nome`, `descricao`, `categoria`, `valor_custo`, `valor_venda`, `estoque`, `criado_em`, `usuario_id`, `ativo`) VALUES
(1, 'Camiseta Básica P', 'Camiseta 100% algodão tamanho P', 'Vestuário', '22.00', '49.90', 47, '2026-10-20 23:27:50', NULL, 1),
(2, 'Camiseta Básica M', 'Camiseta 100% algodão tamanho M', 'Vestuário', '22.00', '49.90', 3, '2026-10-20 23:27:50', NULL, 1),
(3, 'Calça Jeans Slim 38', 'Calça jeans slim fit cintura 38', 'Vestuário', '68.00', '149.90', 12, '2026-10-20 23:27:50', NULL, 1),
(4, 'Tênis Casual Branco 40', 'Tênis casual unissex n°40', 'Calçados', '95.00', '219.90', 8, '2026-10-20 23:27:50', NULL, 1),
(5, 'Mochila Escolar Azul', 'Mochila resistente 30L', 'Acessórios', '55.00', '119.90', 2, '2026-10-20 23:27:50', NULL, 1),
(6, 'Boné Strapback Preto', 'Boné aba reta ajustável', 'Acessórios', '18.00', '39.90', 22, '2026-10-20 23:27:50', NULL, 1),
(7, 'Meias Kit c/6 pares', 'Kit com 6 pares de meias cano curto', 'Vestuário', '12.00', '28.90', 0, '2026-10-20 23:27:50', NULL, 1),
(8, 'Vestido Floral P', 'Vestido estampado verão tamanho P', 'Vestuário', '45.00', '99.90', 6, '2026-10-20 23:27:50', NULL, 1),
(9, 'Shorts Tactel M', 'Shorts tactel masculino tamanho M', 'Vestuário', '28.00', '64.90', 15, '2026-10-20 23:27:50', NULL, 1),
(10, 'Óculos de Sol Wayfarer', 'Óculos com lente UV400', 'Acessórios', '35.00', '79.90', 4, '2026-10-20 23:27:50', NULL, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `email`, `senha`, `criado_em`) VALUES
(1, 'Usuário Teste', 'teste@ravia.com', '$2y$10$BtZezl2WfoHdYpmKWMghMOfx6.Oi7bFZ9cswOHfVI5aeA7PoJNCMa', '2026-10-20 23:27:50');

-- --------------------------------------------------------

--
-- Estrutura da tabela `venda`
--

CREATE TABLE `venda` (
  `num_venda` int(11) NOT NULL,
  `data_venda` datetime NOT NULL DEFAULT current_timestamp(),
  `num_cliente` int(11) DEFAULT NULL,
  `desconto_valor` decimal(10,2) NOT NULL DEFAULT 0.00,
  `desconto_percentual` decimal(5,2) NOT NULL DEFAULT 0.00,
  `acrescimo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `valor_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `observacao` varchar(500) DEFAULT NULL,
  `situacao` enum('ATIVA','CANCELADA') NOT NULL DEFAULT 'ATIVA',
  `cancelada_em` datetime DEFAULT NULL,
  `cancelada_por` varchar(128) DEFAULT NULL,
  `motivo_cancelamento` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `venda`
--

INSERT INTO `venda` (`num_venda`, `data_venda`, `num_cliente`, `desconto_valor`, `desconto_percentual`, `acrescimo`, `valor_total`, `observacao`, `situacao`, `cancelada_em`, `cancelada_por`, `motivo_cancelamento`) VALUES
(1, '2026-11-05 00:00:00', 9, '0.00', '0.00', '0.00', '49.90', '', 'ATIVA', NULL, NULL, NULL);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `acerto_estoque`
--
ALTER TABLE `acerto_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_acerto_data` (`data_emissao`);

--
-- Índices para tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_acerto_produto` (`produto_id`),
  ADD KEY `fk_acerto_item_acerto` (`acerto_id`);

--
-- Índices para tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `idx_cliente_usuario` (`usuario_id`);

--
-- Índices para tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices para tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_funcionario_cpf` (`cpf`),
  ADD KEY `idx_funcionario_usuario` (`usuario_id`);

--
-- Índices para tabela `item_venda`
--
ALTER TABLE `item_venda`
  ADD PRIMARY KEY (`num_venda`,`num_produto`),
  ADD KEY `fk_item_venda_produto` (`num_produto`);

--
-- Índices para tabela `movimento_estoque`
--
ALTER TABLE `movimento_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_movimento_produto` (`produto_id`);

--
-- Índices para tabela `movimento_financeiro`
--
ALTER TABLE `movimento_financeiro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_financeiro_venda` (`num_venda`);

--
-- Índices para tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_produto_usuario` (`usuario_id`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices para tabela `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`num_venda`),
  ADD KEY `fk_venda_cliente` (`num_cliente`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acerto_estoque`
--
ALTER TABLE `acerto_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `funcionario`
--
ALTER TABLE `funcionario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `movimento_estoque`
--
ALTER TABLE `movimento_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `movimento_financeiro`
--
ALTER TABLE `movimento_financeiro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `venda`
--
ALTER TABLE `venda`
  MODIFY `num_venda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  ADD CONSTRAINT `fk_acerto_item_acerto` FOREIGN KEY (`acerto_id`) REFERENCES `acerto_estoque` (`id`),
  ADD CONSTRAINT `fk_acerto_item_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Limitadores para a tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  ADD CONSTRAINT `entrada_estoque_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Limitadores para a tabela `item_venda`
--
ALTER TABLE `item_venda`
  ADD CONSTRAINT `fk_item_venda_produto` FOREIGN KEY (`num_produto`) REFERENCES `produto` (`id`),
  ADD CONSTRAINT `fk_item_venda_venda` FOREIGN KEY (`num_venda`) REFERENCES `venda` (`num_venda`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `movimento_estoque`
--
ALTER TABLE `movimento_estoque`
  ADD CONSTRAINT `fk_movimento_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Limitadores para a tabela `movimento_financeiro`
--
ALTER TABLE `movimento_financeiro`
  ADD CONSTRAINT `fk_financeiro_venda` FOREIGN KEY (`num_venda`) REFERENCES `venda` (`num_venda`);

--
-- Limitadores para a tabela `venda`
--
ALTER TABLE `venda`
  ADD CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`num_cliente`) REFERENCES `cliente` (`codigo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
