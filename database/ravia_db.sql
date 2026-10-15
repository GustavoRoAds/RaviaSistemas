-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Tempo de geração: 09-Out-2026 às 02:13
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.0.30

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
  `cidade` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `cliente`
--

INSERT INTO `cliente` (`codigo`, `nome`, `telefone`, `cpf`, `email`, `cep`, `endereco`, `numero`, `bairro`, `cidade`) VALUES
(1, 'Ana Paula Ferreira', '(44) 99123-4567', '123.456.789-00', 'ana.ferreira@email.com', '87200-000', 'Rua das Flores', '120', 'Centro', 'Cianorte'),
(2, 'Bruno Carvalho Lima', '(44) 98877-2211', '234.567.890-11', 'bruno.lima@email.com', '87203-150', 'Avenida Brasil', '845', 'Jardim América', 'Cianorte'),
(3, 'Carla Souza Martins', '(44) 99654-3322', '345.678.901-22', 'carla.martins@email.com', '87200-310', 'Rua Paraná', '45', 'Vila Rica', 'Cianorte'),
(4, 'Diego Oliveira Santos', '(44) 98765-4321', '456.789.012-33', 'diego.santos@email.com', '87205-700', 'Rua Minas Gerais', '301', 'Industrial', 'Cianorte'),
(5, 'Fernanda Costa Rocha', '(44) 99988-7766', '567.890.123-44', 'fernanda.rocha@email.com', '87200-480', 'Rua Goiás', '78', 'Centro', 'Cianorte'),
(6, 'Gustavo Henrique Alves', '(44) 98123-9988', '678.901.234-55', 'gustavo.alves@email.com', '87204-220', 'Avenida Paraná', '560', 'Novo Horizonte', 'Cianorte'),
(7, 'Juliana Pereira Dias', '(44) 99345-6677', '789.012.345-66', 'juliana.dias@email.com', '87200-910', 'Rua São Paulo', '12', 'Centro', 'Cianorte'),
(8, 'Marcos Vinícius Nunes', '(44) 98456-1234', '890.123.456-77', 'marcos.nunes@email.com', '87206-330', 'Rua Santa Catarina', '233', 'Jardim Primavera', 'Cianorte'),
(9, 'Patrícia Gomes Ribeiro', '(44) 99234-5566', '901.234.567-88', 'patricia.ribeiro@email.com', '87200-610', 'Avenida Pioneiros', '99', 'Alvorada', 'Cianorte'),
(10, 'Rafael Augusto Teixeira', '(44) 98567-8899', '012.345.678-99', 'rafael.teixeira@email.com', '87203-010', 'Rua Rio de Janeiro', '410', 'Centro', 'Cianorte');

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
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `produto`
--

INSERT INTO `produto` (`id`, `nome`, `descricao`, `categoria`, `valor_custo`, `valor_venda`, `estoque`, `criado_em`) VALUES
(1, 'Camiseta Básica P', 'Camiseta 100% algodão tamanho P', 'Vestuário', 22.00, 49.90, 47, '2026-09-28 00:46:17'),
(2, 'Camiseta Básica M', 'Camiseta 100% algodão tamanho M', 'Vestuário', 22.00, 49.90, 3, '2026-09-28 00:46:17'),
(3, 'Calça Jeans Slim 38', 'Calça jeans slim fit cintura 38', 'Vestuário', 68.00, 149.90, 12, '2026-09-28 00:46:17'),
(4, 'Tênis Casual Branco 40', 'Tênis casual unissex n°40', 'Calçados', 95.00, 219.90, 8, '2026-09-28 00:46:17'),
(5, 'Mochila Escolar Azul', 'Mochila resistente 30L', 'Acessórios', 55.00, 119.90, 2, '2026-09-28 00:46:17'),
(6, 'Boné Strapback Preto', 'Boné aba reta ajustável', 'Acessórios', 18.00, 39.90, 22, '2026-09-28 00:46:17'),
(7, 'Meias Kit c/6 pares', 'Kit com 6 pares de meias cano curto', 'Vestuário', 12.00, 28.90, 0, '2026-09-28 00:46:17'),
(8, 'Vestido Floral P', 'Vestido estampado verão tamanho P', 'Vestuário', 45.00, 99.90, 6, '2026-09-28 00:46:17'),
(9, 'Shorts Tactel M', 'Shorts tactel masculino tamanho M', 'Vestuário', 28.00, 64.90, 15, '2026-09-28 00:46:17'),
(10, 'Óculos de Sol Wayfarer', 'Óculos com lente UV400', 'Acessórios', 35.00, 79.90, 4, '2026-09-28 00:46:17');

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
(1, 'Usuário Teste', 'teste@ravia.com', '$2y$10$BtZezl2WfoHdYpmKWMghMOfx6.Oi7bFZ9cswOHfVI5aeA7PoJNCMa', '2026-09-20 20:55:59');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
