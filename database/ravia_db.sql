-- RAVIA - Script do banco de dados (corrigido)
-- Host: 127.0.0.1:3307 | MariaDB 10.4.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- UID do usuário do Firebase usado nos registros de exemplo.
-- Troque NULL pelo UID real (Firebase > Authentication > Usuários > "UID de usuário"),
-- entre aspas simples. Exemplo: SET @uid_teste = 'AbC123...';
SET @uid_teste = NULL;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `ravia_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ravia_db`;

-- --------------------------------------------------------
-- Tabela `cliente`
-- --------------------------------------------------------

CREATE TABLE `cliente` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`codigo`),
  KEY `idx_cliente_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `cliente` (`nome`, `telefone`, `cpf`, `email`, `cep`, `endereco`, `numero`, `bairro`, `cidade`, `usuario_id`) VALUES
('Ana Paula Ferreira', '(44) 99123-4567', '123.456.789-00', 'ana.ferreira@email.com', '87200-000', 'Rua das Flores', '120', 'Centro', 'Cianorte', @uid_teste),
('Bruno Carvalho Lima', '(44) 98877-2211', '234.567.890-11', 'bruno.lima@email.com', '87203-150', 'Avenida Brasil', '845', 'Jardim América', 'Cianorte', @uid_teste),
('Carla Souza Martins', '(44) 99654-3322', '345.678.901-22', 'carla.martins@email.com', '87200-310', 'Rua Paraná', '45', 'Vila Rica', 'Cianorte', @uid_teste),
('Diego Oliveira Santos', '(44) 98765-4321', '456.789.012-33', 'diego.santos@email.com', '87205-700', 'Rua Minas Gerais', '301', 'Industrial', 'Cianorte', @uid_teste),
('Fernanda Costa Rocha', '(44) 99988-7766', '567.890.123-44', 'fernanda.rocha@email.com', '87200-480', 'Rua Goiás', '78', 'Centro', 'Cianorte', @uid_teste),
('Gustavo Henrique Alves', '(44) 98123-9988', '678.901.234-55', 'gustavo.alves@email.com', '87204-220', 'Avenida Paraná', '560', 'Novo Horizonte', 'Cianorte', @uid_teste),
('Juliana Pereira Dias', '(44) 99345-6677', '789.012.345-66', 'juliana.dias@email.com', '87200-910', 'Rua São Paulo', '12', 'Centro', 'Cianorte', @uid_teste),
('Marcos Vinícius Nunes', '(44) 98456-1234', '890.123.456-77', 'marcos.nunes@email.com', '87206-330', 'Rua Santa Catarina', '233', 'Jardim Primavera', 'Cianorte', @uid_teste),
('Patrícia Gomes Ribeiro', '(44) 99234-5566', '901.234.567-88', 'patricia.ribeiro@email.com', '87200-610', 'Avenida Pioneiros', '99', 'Alvorada', 'Cianorte', @uid_teste),
('Rafael Augusto Teixeira', '(44) 98567-8899', '012.345.678-99', 'rafael.teixeira@email.com', '87203-010', 'Rua Rio de Janeiro', '410', 'Centro', 'Cianorte', @uid_teste);

-- --------------------------------------------------------
-- Tabela `produto`
-- --------------------------------------------------------

CREATE TABLE `produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `valor_custo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `valor_venda` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estoque` int(11) NOT NULL DEFAULT 0,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  PRIMARY KEY (`id`),
  KEY `idx_produto_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `produto` (`nome`, `descricao`, `categoria`, `valor_custo`, `valor_venda`, `estoque`, `usuario_id`) VALUES
('Camiseta Básica P', 'Camiseta 100% algodão tamanho P', 'Vestuário', 22.00, 49.90, 47, @uid_teste),
('Camiseta Básica M', 'Camiseta 100% algodão tamanho M', 'Vestuário', 22.00, 49.90, 3, @uid_teste),
('Calça Jeans Slim 38', 'Calça jeans slim fit cintura 38', 'Vestuário', 68.00, 149.90, 12, @uid_teste),
('Tênis Casual Branco 40', 'Tênis casual unissex n°40', 'Calçados', 95.00, 219.90, 8, @uid_teste),
('Mochila Escolar Azul', 'Mochila resistente 30L', 'Acessórios', 55.00, 119.90, 2, @uid_teste),
('Boné Strapback Preto', 'Boné aba reta ajustável', 'Acessórios', 18.00, 39.90, 22, @uid_teste),
('Meias Kit c/6 pares', 'Kit com 6 pares de meias cano curto', 'Vestuário', 12.00, 28.90, 0, @uid_teste),
('Vestido Floral P', 'Vestido estampado verão tamanho P', 'Vestuário', 45.00, 99.90, 6, @uid_teste),
('Shorts Tactel M', 'Shorts tactel masculino tamanho M', 'Vestuário', 28.00, 64.90, 15, @uid_teste),
('Óculos de Sol Wayfarer', 'Óculos com lente UV400', 'Acessórios', 35.00, 79.90, 4, @uid_teste);

-- --------------------------------------------------------
-- Tabela `funcionario` (NOVA)
-- --------------------------------------------------------

CREATE TABLE `funcionario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `cargo` varchar(60) DEFAULT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `data_admissao` date DEFAULT NULL,
  `salario` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_funcionario_cpf` (`cpf`),
  KEY `idx_funcionario_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `funcionario` (`nome`, `cpf`, `cargo`, `telefone`, `email`, `data_admissao`, `salario`, `ativo`, `usuario_id`) VALUES
('Lucas Martins Pereira', '111.222.333-44', 'Gerente', '(44) 99111-2233', 'lucas.pereira@ravia.com', '2024-03-04', 4500.00, 1, @uid_teste),
('Mariana Alves Costa', '222.333.444-55', 'Vendedora', '(44) 98822-3344', 'mariana.costa@ravia.com', '2024-08-12', 2200.00, 1, @uid_teste),
('Thiago Ramos Silva', '333.444.555-66', 'Vendedor', '(44) 99933-4455', 'thiago.silva@ravia.com', '2025-01-20', 2200.00, 1, @uid_teste),
('Camila Rodrigues Lopes', '444.555.666-77', 'Caixa', '(44) 98744-5566', 'camila.lopes@ravia.com', '2025-06-02', 1950.00, 1, @uid_teste),
('Eduardo Santos Barros', '555.666.777-88', 'Estoquista', '(44) 99655-6677', 'eduardo.barros@ravia.com', '2025-11-17', 1850.00, 1, @uid_teste);

-- --------------------------------------------------------
-- Tabela `usuario`
-- (não é mais usada no login: a autenticação agora é feita pelo Firebase)
-- --------------------------------------------------------

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `usuario` (`nome`, `email`, `senha`) VALUES
('Usuário Teste', 'teste@ravia.com', '$2y$10$BtZezl2WfoHdYpmKWMghMOfx6.Oi7bFZ9cswOHfVI5aeA7PoJNCMa');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;