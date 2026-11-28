-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 28/11/2026 às 17:27
-- Versão do servidor: 10.11.19-MariaDB
-- Versão do PHP: 8.3.37

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

    -- Entradas de estoque
    SELECT COALESCE(SUM(quantidade), 0)
    INTO v_entradas
    FROM entrada_estoque
    WHERE produto_id = p_produto_id;

    -- Saídas somente de vendas ativas
    SELECT COALESCE(SUM(iv.quantidade), 0)
    INTO v_saidas
    FROM item_venda iv
    INNER JOIN venda v
        ON v.num_venda = iv.num_venda
    WHERE iv.num_produto = p_produto_id
      AND v.situacao = 'ATIVA';

    -- Acertos de estoque
    SELECT COALESCE(SUM(quantidade), 0)
    INTO v_acertos
    FROM acerto_estoque_item
    WHERE produto_id = p_produto_id;

    RETURN v_entradas + v_acertos - v_saidas;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `acerto_estoque`
--

CREATE TABLE `acerto_estoque` (
  `id` int(11) NOT NULL,
  `data_emissao` date NOT NULL,
  `usuario_id` varchar(128) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `acerto_estoque`
--

INSERT INTO `acerto_estoque` (`id`, `data_emissao`, `usuario_id`, `criado_em`) VALUES
(4, '2026-11-28', 'xBW3E0jhAec0iBvwGX3nlLHRluw2', '2026-11-28 12:30:22');

-- --------------------------------------------------------

--
-- Estrutura para tabela `acerto_estoque_item`
--

CREATE TABLE `acerto_estoque_item` (
  `id` int(11) NOT NULL,
  `acerto_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `acerto_estoque_item`
--

INSERT INTO `acerto_estoque_item` (`id`, `acerto_id`, `produto_id`, `quantidade`) VALUES
(4, 4, 45, 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`codigo`, `descricao`) VALUES
(1, 'Calcinhas'),
(6, 'Camisolas'),
(3, 'Conjuntos'),
(4, 'Cuecas'),
(5, 'Pijamas'),
(2, 'Sutiãs');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
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
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`codigo`, `nome`, `telefone`, `cpf`, `email`, `cep`, `endereco`, `numero`, `bairro`, `cidade`, `usuario_id`, `ativo`) VALUES
(1, 'Ana Almeida Ferreira', '(44) 99000-1000', NULL, 'cadastro001@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(2, 'Bruno Barbosa Lima', '(44) 99071-1037', NULL, 'cadastro002@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(3, 'Camila Cardoso Oliveira', '(44) 99142-1074', NULL, 'cadastro003@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(4, 'Daniel Dias Ribeiro', '(44) 99213-1111', NULL, 'cadastro004@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(5, 'Eduarda Esteves Vieira', '(44) 99284-1148', NULL, 'cadastro005@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(6, 'Felipe Ferreira Almeida', '(44) 99355-1185', NULL, 'cadastro006@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(7, 'Gabriela Gomes Dias', '(44) 99426-1222', NULL, 'cadastro007@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(8, 'Henrique Henriques Gomes', '(44) 99497-1259', NULL, 'cadastro008@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(9, 'Isabela Lima Martins', '(44) 99568-1296', NULL, 'cadastro009@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(10, 'João Martins Pereira', '(44) 99639-1333', NULL, 'cadastro010@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(11, 'Karina Nascimento Santos', '(44) 99710-1370', NULL, 'cadastro011@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(12, 'Lucas Oliveira Costa', '(44) 99781-1407', NULL, 'cadastro012@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(13, 'Mariana Pereira Barbosa', '(44) 99852-1444', NULL, 'cadastro013@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(14, 'Nicolas Queiroz Esteves', '(44) 99923-1481', NULL, 'cadastro014@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(15, 'Olívia Ribeiro Henriques', '(44) 99994-1518', NULL, 'cadastro015@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(16, 'Paulo Santos Nascimento', '(44) 910065-155', NULL, 'cadastro016@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(17, 'Renata Teixeira Queiroz', '(44) 910136-159', NULL, 'cadastro017@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(18, 'Samuel Vieira Teixeira', '(44) 910207-162', NULL, 'cadastro018@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(19, 'Tatiane Costa Rocha', '(44) 910278-166', NULL, 'cadastro019@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(20, 'Vinícius Rocha Cardoso', '(44) 910349-170', NULL, 'cadastro020@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(21, 'Aline Almeida Ferreira', '(44) 910420-174', NULL, 'cadastro021@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(22, 'Caio Barbosa Lima', '(44) 910491-177', NULL, 'cadastro022@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(23, 'Débora Cardoso Oliveira', '(44) 910562-181', NULL, 'cadastro023@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(24, 'Elias Dias Ribeiro', '(44) 910633-185', NULL, 'cadastro024@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(25, 'Fernanda Esteves Vieira', '(44) 910704-188', NULL, 'cadastro025@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(26, 'Gustavo Ferreira Almeida', '(44) 910775-192', NULL, 'cadastro026@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(27, 'Helena Gomes Dias', '(44) 910846-196', NULL, 'cadastro027@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(28, 'Igor Henriques Gomes', '(44) 910917-199', NULL, 'cadastro028@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(29, 'Juliana Lima Martins', '(44) 910988-203', NULL, 'cadastro029@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(30, 'Leonardo Martins Pereira', '(44) 911059-207', NULL, 'cadastro030@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(31, 'Ana Vieira Santos', '(44) 911130-211', NULL, 'cadastro031@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(32, 'Bruno Costa Costa', '(44) 911201-214', NULL, 'cadastro032@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(33, 'Camila Rocha Barbosa', '(44) 911272-218', NULL, 'cadastro033@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(34, 'Daniel Almeida Esteves', '(44) 911343-222', NULL, 'cadastro034@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(35, 'Eduarda Barbosa Henriques', '(44) 911414-225', NULL, 'cadastro035@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(36, 'Felipe Cardoso Nascimento', '(44) 911485-229', NULL, 'cadastro036@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(37, 'Gabriela Dias Queiroz', '(44) 911556-233', NULL, 'cadastro037@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(38, 'Henrique Esteves Teixeira', '(44) 911627-236', NULL, 'cadastro038@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(39, 'Isabela Ferreira Rocha', '(44) 911698-240', NULL, 'cadastro039@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(40, 'João Gomes Cardoso', '(44) 911769-244', NULL, 'cadastro040@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(41, 'Karina Henriques Ferreira', '(44) 911840-248', NULL, 'cadastro041@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(42, 'Lucas Lima Lima', '(44) 911911-251', NULL, 'cadastro042@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(43, 'Mariana Martins Oliveira', '(44) 911982-255', NULL, 'cadastro043@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(44, 'Nicolas Nascimento Ribeiro', '(44) 912053-259', NULL, 'cadastro044@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(45, 'Olívia Oliveira Vieira', '(44) 912124-262', NULL, 'cadastro045@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(46, 'Paulo Pereira Almeida', '(44) 912195-266', NULL, 'cadastro046@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(47, 'Renata Queiroz Dias', '(44) 912266-270', NULL, 'cadastro047@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(48, 'Samuel Ribeiro Gomes', '(44) 912337-273', NULL, 'cadastro048@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(49, 'Tatiane Santos Martins', '(44) 912408-277', NULL, 'cadastro049@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(50, 'Vinícius Teixeira Pereira', '(44) 912479-281', NULL, 'cadastro050@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(51, 'Aline Vieira Santos', '(44) 912550-285', NULL, 'cadastro051@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(52, 'Caio Costa Costa', '(44) 912621-288', NULL, 'cadastro052@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(53, 'Débora Rocha Barbosa', '(44) 912692-292', NULL, 'cadastro053@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(54, 'Elias Almeida Esteves', '(44) 912763-296', NULL, 'cadastro054@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(55, 'Fernanda Barbosa Henriques', '(44) 912834-299', NULL, 'cadastro055@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(56, 'Gustavo Cardoso Nascimento', '(44) 912905-303', NULL, 'cadastro056@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(57, 'Helena Dias Queiroz', '(44) 912976-307', NULL, 'cadastro057@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(58, 'Igor Esteves Teixeira', '(44) 913047-310', NULL, 'cadastro058@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(59, 'Juliana Ferreira Rocha', '(44) 913118-314', NULL, 'cadastro059@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(60, 'Leonardo Gomes Cardoso', '(44) 913189-318', NULL, 'cadastro060@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(61, 'Ana Ribeiro Ferreira', '(44) 913260-322', NULL, 'cadastro061@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(62, 'Bruno Santos Lima', '(44) 913331-325', NULL, 'cadastro062@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(63, 'Camila Teixeira Oliveira', '(44) 913402-329', NULL, 'cadastro063@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(64, 'Daniel Vieira Ribeiro', '(44) 913473-333', NULL, 'cadastro064@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(65, 'Eduarda Costa Vieira', '(44) 913544-336', NULL, 'cadastro065@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(66, 'Felipe Rocha Almeida', '(44) 913615-340', NULL, 'cadastro066@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(67, 'Gabriela Almeida Dias', '(44) 913686-344', NULL, 'cadastro067@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(68, 'Henrique Barbosa Gomes', '(44) 913757-347', NULL, 'cadastro068@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(69, 'Isabela Cardoso Martins', '(44) 913828-351', NULL, 'cadastro069@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(70, 'João Dias Pereira', '(44) 913899-355', NULL, 'cadastro070@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(71, 'Karina Esteves Santos', '(44) 913970-359', NULL, 'cadastro071@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(72, 'Lucas Ferreira Costa', '(44) 914041-362', NULL, 'cadastro072@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(73, 'Mariana Gomes Barbosa', '(44) 914112-366', NULL, 'cadastro073@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(74, 'Nicolas Henriques Esteves', '(44) 914183-370', NULL, 'cadastro074@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(75, 'Olívia Lima Henriques', '(44) 914254-373', NULL, 'cadastro075@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(76, 'Paulo Martins Nascimento', '(44) 914325-377', NULL, 'cadastro076@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(77, 'Renata Nascimento Queiroz', '(44) 914396-381', NULL, 'cadastro077@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(78, 'Samuel Oliveira Teixeira', '(44) 914467-384', NULL, 'cadastro078@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(79, 'Tatiane Pereira Rocha', '(44) 914538-388', NULL, 'cadastro079@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(80, 'Vinícius Queiroz Cardoso', '(44) 914609-392', NULL, 'cadastro080@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(81, 'Aline Ribeiro Ferreira', '(44) 914680-396', NULL, 'cadastro081@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(82, 'Caio Santos Lima', '(44) 914751-399', NULL, 'cadastro082@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(83, 'Débora Teixeira Oliveira', '(44) 914822-403', NULL, 'cadastro083@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(84, 'Elias Vieira Ribeiro', '(44) 914893-407', NULL, 'cadastro084@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(85, 'Fernanda Costa Vieira', '(44) 914964-410', NULL, 'cadastro085@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(86, 'Gustavo Rocha Almeida', '(44) 915035-414', NULL, 'cadastro086@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(87, 'Helena Almeida Dias', '(44) 915106-418', NULL, 'cadastro087@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(88, 'Igor Barbosa Gomes', '(44) 915177-421', NULL, 'cadastro088@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(89, 'Juliana Cardoso Martins', '(44) 915248-425', NULL, 'cadastro089@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(90, 'Leonardo Dias Pereira', '(44) 915319-429', NULL, 'cadastro090@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(91, 'Ana Almeida Ferreira', '(44) 99000-1000', NULL, 'cadastro001@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(92, 'Bruno Barbosa Lima', '(44) 99071-1037', NULL, 'cadastro002@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(93, 'Camila Cardoso Oliveira', '(44) 99142-1074', NULL, 'cadastro003@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(94, 'Daniel Dias Ribeiro', '(44) 99213-1111', NULL, 'cadastro004@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(95, 'Eduarda Esteves Vieira', '(44) 99284-1148', NULL, 'cadastro005@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(96, 'Felipe Ferreira Almeida', '(44) 99355-1185', NULL, 'cadastro006@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(97, 'Gabriela Gomes Dias', '(44) 99426-1222', NULL, 'cadastro007@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(98, 'Henrique Henriques Gomes', '(44) 99497-1259', NULL, 'cadastro008@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(99, 'Isabela Lima Martins', '(44) 99568-1296', NULL, 'cadastro009@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(100, 'João Martins Pereira', '(44) 99639-1333', NULL, 'cadastro010@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(101, 'Karina Nascimento Santos', '(44) 99710-1370', NULL, 'cadastro011@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(102, 'Lucas Oliveira Costa', '(44) 99781-1407', NULL, 'cadastro012@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(103, 'Mariana Pereira Barbosa', '(44) 99852-1444', NULL, 'cadastro013@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(104, 'Nicolas Queiroz Esteves', '(44) 99923-1481', NULL, 'cadastro014@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(105, 'Olívia Ribeiro Henriques', '(44) 99994-1518', NULL, 'cadastro015@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(106, 'Paulo Santos Nascimento', '(44) 910065-155', NULL, 'cadastro016@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(107, 'Renata Teixeira Queiroz', '(44) 910136-159', NULL, 'cadastro017@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(108, 'Samuel Vieira Teixeira', '(44) 910207-162', NULL, 'cadastro018@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(109, 'Tatiane Costa Rocha', '(44) 910278-166', NULL, 'cadastro019@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(110, 'Vinícius Rocha Cardoso', '(44) 910349-170', NULL, 'cadastro020@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(111, 'Aline Almeida Ferreira', '(44) 910420-174', NULL, 'cadastro021@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(112, 'Caio Barbosa Lima', '(44) 910491-177', NULL, 'cadastro022@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(113, 'Débora Cardoso Oliveira', '(44) 910562-181', NULL, 'cadastro023@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(114, 'Elias Dias Ribeiro', '(44) 910633-185', NULL, 'cadastro024@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(115, 'Fernanda Esteves Vieira', '(44) 910704-188', NULL, 'cadastro025@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(116, 'Gustavo Ferreira Almeida', '(44) 910775-192', NULL, 'cadastro026@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(117, 'Helena Gomes Dias', '(44) 910846-196', NULL, 'cadastro027@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(118, 'Igor Henriques Gomes', '(44) 910917-199', NULL, 'cadastro028@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(119, 'Juliana Lima Martins', '(44) 910988-203', NULL, 'cadastro029@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(120, 'Leonardo Martins Pereira', '(44) 911059-207', NULL, 'cadastro030@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(121, 'Ana Vieira Santos', '(44) 911130-211', NULL, 'cadastro031@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(122, 'Bruno Costa Costa', '(44) 911201-214', NULL, 'cadastro032@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(123, 'Camila Rocha Barbosa', '(44) 911272-218', NULL, 'cadastro033@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(124, 'Daniel Almeida Esteves', '(44) 911343-222', NULL, 'cadastro034@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(125, 'Eduarda Barbosa Henriques', '(44) 911414-225', NULL, 'cadastro035@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(126, 'Felipe Cardoso Nascimento', '(44) 911485-229', NULL, 'cadastro036@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(127, 'Gabriela Dias Queiroz', '(44) 911556-233', NULL, 'cadastro037@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(128, 'Henrique Esteves Teixeira', '(44) 911627-236', NULL, 'cadastro038@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(129, 'Isabela Ferreira Rocha', '(44) 911698-240', NULL, 'cadastro039@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(130, 'João Gomes Cardoso', '(44) 911769-244', NULL, 'cadastro040@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(131, 'Karina Henriques Ferreira', '(44) 911840-248', NULL, 'cadastro041@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(132, 'Lucas Lima Lima', '(44) 911911-251', NULL, 'cadastro042@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(133, 'Mariana Martins Oliveira', '(44) 911982-255', NULL, 'cadastro043@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(134, 'Nicolas Nascimento Ribeiro', '(44) 912053-259', NULL, 'cadastro044@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(135, 'Olívia Oliveira Vieira', '(44) 912124-262', NULL, 'cadastro045@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(136, 'Paulo Pereira Almeida', '(44) 912195-266', NULL, 'cadastro046@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(137, 'Renata Queiroz Dias', '(44) 912266-270', NULL, 'cadastro047@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(138, 'Samuel Ribeiro Gomes', '(44) 912337-273', NULL, 'cadastro048@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(139, 'Tatiane Santos Martins', '(44) 912408-277', NULL, 'cadastro049@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(140, 'Vinícius Teixeira Pereira', '(44) 912479-281', NULL, 'cadastro050@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(141, 'Aline Vieira Santos', '(44) 912550-285', NULL, 'cadastro051@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(142, 'Caio Costa Costa', '(44) 912621-288', NULL, 'cadastro052@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(143, 'Débora Rocha Barbosa', '(44) 912692-292', NULL, 'cadastro053@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(144, 'Elias Almeida Esteves', '(44) 912763-296', NULL, 'cadastro054@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(145, 'Fernanda Barbosa Henriques', '(44) 912834-299', NULL, 'cadastro055@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(146, 'Gustavo Cardoso Nascimento', '(44) 912905-303', NULL, 'cadastro056@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(147, 'Helena Dias Queiroz', '(44) 912976-307', NULL, 'cadastro057@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(148, 'Igor Esteves Teixeira', '(44) 913047-310', NULL, 'cadastro058@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(149, 'Juliana Ferreira Rocha', '(44) 913118-314', NULL, 'cadastro059@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(150, 'Leonardo Gomes Cardoso', '(44) 913189-318', NULL, 'cadastro060@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(151, 'Ana Ribeiro Ferreira', '(44) 913260-322', NULL, 'cadastro061@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(152, 'Bruno Santos Lima', '(44) 913331-325', NULL, 'cadastro062@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(153, 'Camila Teixeira Oliveira', '(44) 913402-329', NULL, 'cadastro063@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(154, 'Daniel Vieira Ribeiro', '(44) 913473-333', NULL, 'cadastro064@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(155, 'Eduarda Costa Vieira', '(44) 913544-336', NULL, 'cadastro065@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(156, 'Felipe Rocha Almeida', '(44) 913615-340', NULL, 'cadastro066@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(157, 'Gabriela Almeida Dias', '(44) 913686-344', NULL, 'cadastro067@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(158, 'Henrique Barbosa Gomes', '(44) 913757-347', NULL, 'cadastro068@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(159, 'Isabela Cardoso Martins', '(44) 913828-351', NULL, 'cadastro069@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(160, 'João Dias Pereira', '(44) 913899-355', NULL, 'cadastro070@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(161, 'Karina Esteves Santos', '(44) 913970-359', NULL, 'cadastro071@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(162, 'Lucas Ferreira Costa', '(44) 914041-362', NULL, 'cadastro072@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(163, 'Mariana Gomes Barbosa', '(44) 914112-366', NULL, 'cadastro073@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(164, 'Nicolas Henriques Esteves', '(44) 914183-370', NULL, 'cadastro074@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(165, 'Olívia Lima Henriques', '(44) 914254-373', NULL, 'cadastro075@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(166, 'Paulo Martins Nascimento', '(44) 914325-377', NULL, 'cadastro076@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(167, 'Renata Nascimento Queiroz', '(44) 914396-381', NULL, 'cadastro077@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(168, 'Samuel Oliveira Teixeira', '(44) 914467-384', NULL, 'cadastro078@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(169, 'Tatiane Pereira Rocha', '(44) 914538-388', NULL, 'cadastro079@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(170, 'Vinícius Queiroz Cardoso', '(44) 914609-392', NULL, 'cadastro080@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(171, 'Aline Ribeiro Ferreira', '(44) 914680-396', NULL, 'cadastro081@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(172, 'Caio Santos Lima', '(44) 914751-399', NULL, 'cadastro082@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(173, 'Débora Teixeira Oliveira', '(44) 914822-403', NULL, 'cadastro083@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(174, 'Elias Vieira Ribeiro', '(44) 914893-407', NULL, 'cadastro084@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(175, 'Fernanda Costa Vieira', '(44) 914964-410', NULL, 'cadastro085@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(176, 'Gustavo Rocha Almeida', '(44) 915035-414', NULL, 'cadastro086@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(177, 'Helena Almeida Dias', '(44) 915106-418', NULL, 'cadastro087@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(178, 'Igor Barbosa Gomes', '(44) 915177-421', NULL, 'cadastro088@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(179, 'Juliana Cardoso Martins', '(44) 915248-425', NULL, 'cadastro089@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(180, 'Leonardo Dias Pereira', '(44) 915319-429', NULL, 'cadastro090@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(181, 'Ana Almeida Ferreira', '(44) 99000-1000', NULL, 'cadastro001@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(182, 'Bruno Barbosa Lima', '(44) 99071-1037', NULL, 'cadastro002@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(183, 'Camila Cardoso Oliveira', '(44) 99142-1074', NULL, 'cadastro003@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(184, 'Daniel Dias Ribeiro', '(44) 99213-1111', NULL, 'cadastro004@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(185, 'Eduarda Esteves Vieira', '(44) 99284-1148', NULL, 'cadastro005@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(186, 'Felipe Ferreira Almeida', '(44) 99355-1185', NULL, 'cadastro006@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(187, 'Gabriela Gomes Dias', '(44) 99426-1222', NULL, 'cadastro007@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(188, 'Henrique Henriques Gomes', '(44) 99497-1259', NULL, 'cadastro008@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(189, 'Isabela Lima Martins', '(44) 99568-1296', NULL, 'cadastro009@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(190, 'João Martins Pereira', '(44) 99639-1333', NULL, 'cadastro010@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(191, 'Karina Nascimento Santos', '(44) 99710-1370', NULL, 'cadastro011@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(192, 'Lucas Oliveira Costa', '(44) 99781-1407', NULL, 'cadastro012@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(193, 'Mariana Pereira Barbosa', '(44) 99852-1444', NULL, 'cadastro013@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(194, 'Nicolas Queiroz Esteves', '(44) 99923-1481', NULL, 'cadastro014@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(195, 'Olívia Ribeiro Henriques', '(44) 99994-1518', NULL, 'cadastro015@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(196, 'Paulo Santos Nascimento', '(44) 910065-155', NULL, 'cadastro016@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(197, 'Renata Teixeira Queiroz', '(44) 910136-159', NULL, 'cadastro017@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(198, 'Samuel Vieira Teixeira', '(44) 910207-162', NULL, 'cadastro018@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(199, 'Tatiane Costa Rocha', '(44) 910278-166', NULL, 'cadastro019@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(200, 'Vinícius Rocha Cardoso', '(44) 910349-170', NULL, 'cadastro020@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(201, 'Aline Almeida Ferreira', '(44) 910420-174', NULL, 'cadastro021@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(202, 'Caio Barbosa Lima', '(44) 910491-177', NULL, 'cadastro022@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(203, 'Débora Cardoso Oliveira', '(44) 910562-181', NULL, 'cadastro023@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(204, 'Elias Dias Ribeiro', '(44) 910633-185', NULL, 'cadastro024@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(205, 'Fernanda Esteves Vieira', '(44) 910704-188', NULL, 'cadastro025@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(206, 'Gustavo Ferreira Almeida', '(44) 910775-192', NULL, 'cadastro026@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(207, 'Helena Gomes Dias', '(44) 910846-196', NULL, 'cadastro027@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(208, 'Igor Henriques Gomes', '(44) 910917-199', NULL, 'cadastro028@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(209, 'Juliana Lima Martins', '(44) 910988-203', NULL, 'cadastro029@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(210, 'Leonardo Martins Pereira', '(44) 911059-207', NULL, 'cadastro030@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(211, 'Ana Vieira Santos', '(44) 911130-211', NULL, 'cadastro031@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(212, 'Bruno Costa Costa', '(44) 911201-214', NULL, 'cadastro032@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(213, 'Camila Rocha Barbosa', '(44) 911272-218', NULL, 'cadastro033@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(214, 'Daniel Almeida Esteves', '(44) 911343-222', NULL, 'cadastro034@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(215, 'Eduarda Barbosa Henriques', '(44) 911414-225', NULL, 'cadastro035@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(216, 'Felipe Cardoso Nascimento', '(44) 911485-229', NULL, 'cadastro036@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(217, 'Gabriela Dias Queiroz', '(44) 911556-233', NULL, 'cadastro037@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(218, 'Henrique Esteves Teixeira', '(44) 911627-236', NULL, 'cadastro038@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(219, 'Isabela Ferreira Rocha', '(44) 911698-240', NULL, 'cadastro039@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(220, 'João Gomes Cardoso', '(44) 911769-244', NULL, 'cadastro040@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(221, 'Karina Henriques Ferreira', '(44) 911840-248', NULL, 'cadastro041@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(222, 'Lucas Lima Lima', '(44) 911911-251', NULL, 'cadastro042@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(223, 'Mariana Martins Oliveira', '(44) 911982-255', NULL, 'cadastro043@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(224, 'Nicolas Nascimento Ribeiro', '(44) 912053-259', NULL, 'cadastro044@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(225, 'Olívia Oliveira Vieira', '(44) 912124-262', NULL, 'cadastro045@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(226, 'Paulo Pereira Almeida', '(44) 912195-266', NULL, 'cadastro046@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(227, 'Renata Queiroz Dias', '(44) 912266-270', NULL, 'cadastro047@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(228, 'Samuel Ribeiro Gomes', '(44) 912337-273', NULL, 'cadastro048@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(229, 'Tatiane Santos Martins', '(44) 912408-277', NULL, 'cadastro049@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(230, 'Vinícius Teixeira Pereira', '(44) 912479-281', NULL, 'cadastro050@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(231, 'Aline Vieira Santos', '(44) 912550-285', NULL, 'cadastro051@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(232, 'Caio Costa Costa', '(44) 912621-288', NULL, 'cadastro052@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(233, 'Débora Rocha Barbosa', '(44) 912692-292', NULL, 'cadastro053@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(234, 'Elias Almeida Esteves', '(44) 912763-296', NULL, 'cadastro054@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(235, 'Fernanda Barbosa Henriques', '(44) 912834-299', NULL, 'cadastro055@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(236, 'Gustavo Cardoso Nascimento', '(44) 912905-303', NULL, 'cadastro056@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(237, 'Helena Dias Queiroz', '(44) 912976-307', NULL, 'cadastro057@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(238, 'Igor Esteves Teixeira', '(44) 913047-310', NULL, 'cadastro058@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(239, 'Juliana Ferreira Rocha', '(44) 913118-314', NULL, 'cadastro059@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(240, 'Leonardo Gomes Cardoso', '(44) 913189-318', NULL, 'cadastro060@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(241, 'Ana Ribeiro Ferreira', '(44) 913260-322', NULL, 'cadastro061@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(242, 'Bruno Santos Lima', '(44) 913331-325', NULL, 'cadastro062@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(243, 'Camila Teixeira Oliveira', '(44) 913402-329', NULL, 'cadastro063@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(244, 'Daniel Vieira Ribeiro', '(44) 913473-333', NULL, 'cadastro064@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(245, 'Eduarda Costa Vieira', '(44) 913544-336', NULL, 'cadastro065@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(246, 'Felipe Rocha Almeida', '(44) 913615-340', NULL, 'cadastro066@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(247, 'Gabriela Almeida Dias', '(44) 913686-344', NULL, 'cadastro067@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(248, 'Henrique Barbosa Gomes', '(44) 913757-347', NULL, 'cadastro068@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(249, 'Isabela Cardoso Martins', '(44) 913828-351', NULL, 'cadastro069@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(250, 'João Dias Pereira', '(44) 913899-355', NULL, 'cadastro070@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(251, 'Karina Esteves Santos', '(44) 913970-359', NULL, 'cadastro071@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(252, 'Lucas Ferreira Costa', '(44) 914041-362', NULL, 'cadastro072@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(253, 'Mariana Gomes Barbosa', '(44) 914112-366', NULL, 'cadastro073@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(254, 'Nicolas Henriques Esteves', '(44) 914183-370', NULL, 'cadastro074@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(255, 'Olívia Lima Henriques', '(44) 914254-373', NULL, 'cadastro075@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(256, 'Paulo Martins Nascimento', '(44) 914325-377', NULL, 'cadastro076@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(257, 'Renata Nascimento Queiroz', '(44) 914396-381', NULL, 'cadastro077@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(258, 'Samuel Oliveira Teixeira', '(44) 914467-384', NULL, 'cadastro078@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(259, 'Tatiane Pereira Rocha', '(44) 914538-388', NULL, 'cadastro079@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(260, 'Vinícius Queiroz Cardoso', '(44) 914609-392', NULL, 'cadastro080@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(261, 'Aline Ribeiro Ferreira', '(44) 914680-396', NULL, 'cadastro081@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(262, 'Caio Santos Lima', '(44) 914751-399', NULL, 'cadastro082@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(263, 'Débora Teixeira Oliveira', '(44) 914822-403', NULL, 'cadastro083@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(264, 'Elias Vieira Ribeiro', '(44) 914893-407', NULL, 'cadastro084@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(265, 'Fernanda Costa Vieira', '(44) 914964-410', NULL, 'cadastro085@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(266, 'Gustavo Rocha Almeida', '(44) 915035-414', NULL, 'cadastro086@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(267, 'Helena Almeida Dias', '(44) 915106-418', NULL, 'cadastro087@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(268, 'Igor Barbosa Gomes', '(44) 915177-421', NULL, 'cadastro088@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(269, 'Juliana Cardoso Martins', '(44) 915248-425', NULL, 'cadastro089@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(270, 'Leonardo Dias Pereira', '(44) 915319-429', NULL, 'cadastro090@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(271, 'Ana Almeida Ferreira', '(44) 99000-1000', NULL, 'cadastro001@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(272, 'Bruno Barbosa Lima', '(44) 99071-1037', NULL, 'cadastro002@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(273, 'Camila Cardoso Oliveira', '(44) 99142-1074', NULL, 'cadastro003@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(274, 'Daniel Dias Ribeiro', '(44) 99213-1111', NULL, 'cadastro004@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(275, 'Eduarda Esteves Vieira', '(44) 99284-1148', NULL, 'cadastro005@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(276, 'Felipe Ferreira Almeida', '(44) 99355-1185', NULL, 'cadastro006@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(277, 'Gabriela Gomes Dias', '(44) 99426-1222', NULL, 'cadastro007@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(278, 'Henrique Henriques Gomes', '(44) 99497-1259', NULL, 'cadastro008@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(279, 'Isabela Lima Martins', '(44) 99568-1296', NULL, 'cadastro009@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(280, 'João Martins Pereira', '(44) 99639-1333', NULL, 'cadastro010@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(281, 'Karina Nascimento Santos', '(44) 99710-1370', NULL, 'cadastro011@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(282, 'Lucas Oliveira Costa', '(44) 99781-1407', NULL, 'cadastro012@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(283, 'Mariana Pereira Barbosa', '(44) 99852-1444', NULL, 'cadastro013@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(284, 'Nicolas Queiroz Esteves', '(44) 99923-1481', NULL, 'cadastro014@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(285, 'Olívia Ribeiro Henriques', '(44) 99994-1518', NULL, 'cadastro015@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(286, 'Paulo Santos Nascimento', '(44) 910065-155', NULL, 'cadastro016@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(287, 'Renata Teixeira Queiroz', '(44) 910136-159', NULL, 'cadastro017@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(288, 'Samuel Vieira Teixeira', '(44) 910207-162', NULL, 'cadastro018@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(289, 'Tatiane Costa Rocha', '(44) 910278-166', NULL, 'cadastro019@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(290, 'Vinícius Rocha Cardoso', '(44) 910349-170', NULL, 'cadastro020@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(291, 'Aline Almeida Ferreira', '(44) 910420-174', NULL, 'cadastro021@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(292, 'Caio Barbosa Lima', '(44) 910491-177', NULL, 'cadastro022@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(293, 'Débora Cardoso Oliveira', '(44) 910562-181', NULL, 'cadastro023@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(294, 'Elias Dias Ribeiro', '(44) 910633-185', NULL, 'cadastro024@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(295, 'Fernanda Esteves Vieira', '(44) 910704-188', NULL, 'cadastro025@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(296, 'Gustavo Ferreira Almeida', '(44) 910775-192', NULL, 'cadastro026@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(297, 'Helena Gomes Dias', '(44) 910846-196', NULL, 'cadastro027@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(298, 'Igor Henriques Gomes', '(44) 910917-199', NULL, 'cadastro028@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(299, 'Juliana Lima Martins', '(44) 910988-203', NULL, 'cadastro029@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(300, 'Leonardo Martins Pereira', '(44) 911059-207', NULL, 'cadastro030@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(301, 'Ana Vieira Santos', '(44) 911130-211', NULL, 'cadastro031@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(302, 'Bruno Costa Costa', '(44) 911201-214', NULL, 'cadastro032@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(303, 'Camila Rocha Barbosa', '(44) 911272-218', NULL, 'cadastro033@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(304, 'Daniel Almeida Esteves', '(44) 911343-222', NULL, 'cadastro034@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(305, 'Eduarda Barbosa Henriques', '(44) 911414-225', NULL, 'cadastro035@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(306, 'Felipe Cardoso Nascimento', '(44) 911485-229', NULL, 'cadastro036@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(307, 'Gabriela Dias Queiroz', '(44) 911556-233', NULL, 'cadastro037@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(308, 'Henrique Esteves Teixeira', '(44) 911627-236', NULL, 'cadastro038@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(309, 'Isabela Ferreira Rocha', '(44) 911698-240', NULL, 'cadastro039@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(310, 'João Gomes Cardoso', '(44) 911769-244', NULL, 'cadastro040@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(311, 'Karina Henriques Ferreira', '(44) 911840-248', NULL, 'cadastro041@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(312, 'Lucas Lima Lima', '(44) 911911-251', NULL, 'cadastro042@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(313, 'Mariana Martins Oliveira', '(44) 911982-255', NULL, 'cadastro043@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(314, 'Nicolas Nascimento Ribeiro', '(44) 912053-259', NULL, 'cadastro044@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(315, 'Olívia Oliveira Vieira', '(44) 912124-262', NULL, 'cadastro045@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(316, 'Paulo Pereira Almeida', '(44) 912195-266', NULL, 'cadastro046@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(317, 'Renata Queiroz Dias', '(44) 912266-270', NULL, 'cadastro047@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(318, 'Samuel Ribeiro Gomes', '(44) 912337-273', NULL, 'cadastro048@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(319, 'Tatiane Santos Martins', '(44) 912408-277', NULL, 'cadastro049@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(320, 'Vinícius Teixeira Pereira', '(44) 912479-281', NULL, 'cadastro050@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(321, 'Aline Vieira Santos', '(44) 912550-285', NULL, 'cadastro051@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(322, 'Caio Costa Costa', '(44) 912621-288', NULL, 'cadastro052@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(323, 'Débora Rocha Barbosa', '(44) 912692-292', NULL, 'cadastro053@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(324, 'Elias Almeida Esteves', '(44) 912763-296', NULL, 'cadastro054@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(325, 'Fernanda Barbosa Henriques', '(44) 912834-299', NULL, 'cadastro055@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(326, 'Gustavo Cardoso Nascimento', '(44) 912905-303', NULL, 'cadastro056@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(327, 'Helena Dias Queiroz', '(44) 912976-307', NULL, 'cadastro057@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(328, 'Igor Esteves Teixeira', '(44) 913047-310', NULL, 'cadastro058@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(329, 'Juliana Ferreira Rocha', '(44) 913118-314', NULL, 'cadastro059@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(330, 'Leonardo Gomes Cardoso', '(44) 913189-318', NULL, 'cadastro060@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(331, 'Ana Ribeiro Ferreira', '(44) 913260-322', NULL, 'cadastro061@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(332, 'Bruno Santos Lima', '(44) 913331-325', NULL, 'cadastro062@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(333, 'Camila Teixeira Oliveira', '(44) 913402-329', NULL, 'cadastro063@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(334, 'Daniel Vieira Ribeiro', '(44) 913473-333', NULL, 'cadastro064@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(335, 'Eduarda Costa Vieira', '(44) 913544-336', NULL, 'cadastro065@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(336, 'Felipe Rocha Almeida', '(44) 913615-340', NULL, 'cadastro066@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(337, 'Gabriela Almeida Dias', '(44) 913686-344', NULL, 'cadastro067@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(338, 'Henrique Barbosa Gomes', '(44) 913757-347', NULL, 'cadastro068@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(339, 'Isabela Cardoso Martins', '(44) 913828-351', NULL, 'cadastro069@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(340, 'João Dias Pereira', '(44) 913899-355', NULL, 'cadastro070@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(341, 'Karina Esteves Santos', '(44) 913970-359', NULL, 'cadastro071@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(342, 'Lucas Ferreira Costa', '(44) 914041-362', NULL, 'cadastro072@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(343, 'Mariana Gomes Barbosa', '(44) 914112-366', NULL, 'cadastro073@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(344, 'Nicolas Henriques Esteves', '(44) 914183-370', NULL, 'cadastro074@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(345, 'Olívia Lima Henriques', '(44) 914254-373', NULL, 'cadastro075@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(346, 'Paulo Martins Nascimento', '(44) 914325-377', NULL, 'cadastro076@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(347, 'Renata Nascimento Queiroz', '(44) 914396-381', NULL, 'cadastro077@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(348, 'Samuel Oliveira Teixeira', '(44) 914467-384', NULL, 'cadastro078@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(349, 'Tatiane Pereira Rocha', '(44) 914538-388', NULL, 'cadastro079@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(350, 'Vinícius Queiroz Cardoso', '(44) 914609-392', NULL, 'cadastro080@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(351, 'Aline Ribeiro Ferreira', '(44) 914680-396', NULL, 'cadastro081@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(352, 'Caio Santos Lima', '(44) 914751-399', NULL, 'cadastro082@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(353, 'Débora Teixeira Oliveira', '(44) 914822-403', NULL, 'cadastro083@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(354, 'Elias Vieira Ribeiro', '(44) 914893-407', NULL, 'cadastro084@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(355, 'Fernanda Costa Vieira', '(44) 914964-410', NULL, 'cadastro085@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(356, 'Gustavo Rocha Almeida', '(44) 915035-414', NULL, 'cadastro086@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(357, 'Helena Almeida Dias', '(44) 915106-418', NULL, 'cadastro087@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(358, 'Igor Barbosa Gomes', '(44) 915177-421', NULL, 'cadastro088@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(359, 'Juliana Cardoso Martins', '(44) 915248-425', NULL, 'cadastro089@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(360, 'Leonardo Dias Pereira', '(44) 915319-429', NULL, 'cadastro090@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(361, 'Ana Almeida Ferreira', '(44) 99000-1000', NULL, 'cadastro001@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(362, 'Bruno Barbosa Lima', '(44) 99071-1037', NULL, 'cadastro002@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(363, 'Camila Cardoso Oliveira', '(44) 99142-1074', NULL, 'cadastro003@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(364, 'Daniel Dias Ribeiro', '(44) 99213-1111', NULL, 'cadastro004@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(365, 'Eduarda Esteves Vieira', '(44) 99284-1148', NULL, 'cadastro005@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(366, 'Felipe Ferreira Almeida', '(44) 99355-1185', NULL, 'cadastro006@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(367, 'Gabriela Gomes Dias', '(44) 99426-1222', NULL, 'cadastro007@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(368, 'Henrique Henriques Gomes', '(44) 99497-1259', NULL, 'cadastro008@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(369, 'Isabela Lima Martins', '(44) 99568-1296', NULL, 'cadastro009@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(370, 'João Martins Pereira', '(44) 99639-1333', NULL, 'cadastro010@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(371, 'Karina Nascimento Santos', '(44) 99710-1370', NULL, 'cadastro011@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(372, 'Lucas Oliveira Costa', '(44) 99781-1407', NULL, 'cadastro012@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(373, 'Mariana Pereira Barbosa', '(44) 99852-1444', NULL, 'cadastro013@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(374, 'Nicolas Queiroz Esteves', '(44) 99923-1481', NULL, 'cadastro014@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(375, 'Olívia Ribeiro Henriques', '(44) 99994-1518', NULL, 'cadastro015@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(376, 'Paulo Santos Nascimento', '(44) 910065-155', NULL, 'cadastro016@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(377, 'Renata Teixeira Queiroz', '(44) 910136-159', NULL, 'cadastro017@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(378, 'Samuel Vieira Teixeira', '(44) 910207-162', NULL, 'cadastro018@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(379, 'Tatiane Costa Rocha', '(44) 910278-166', NULL, 'cadastro019@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(380, 'Vinícius Rocha Cardoso', '(44) 910349-170', NULL, 'cadastro020@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1);
INSERT INTO `cliente` (`codigo`, `nome`, `telefone`, `cpf`, `email`, `cep`, `endereco`, `numero`, `bairro`, `cidade`, `usuario_id`, `ativo`) VALUES
(381, 'Aline Almeida Ferreira', '(44) 910420-174', NULL, 'cadastro021@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(382, 'Caio Barbosa Lima', '(44) 910491-177', NULL, 'cadastro022@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(383, 'Débora Cardoso Oliveira', '(44) 910562-181', NULL, 'cadastro023@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(384, 'Elias Dias Ribeiro', '(44) 910633-185', NULL, 'cadastro024@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(385, 'Fernanda Esteves Vieira', '(44) 910704-188', NULL, 'cadastro025@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(386, 'Gustavo Ferreira Almeida', '(44) 910775-192', NULL, 'cadastro026@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(387, 'Helena Gomes Dias', '(44) 910846-196', NULL, 'cadastro027@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(388, 'Igor Henriques Gomes', '(44) 910917-199', NULL, 'cadastro028@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(389, 'Juliana Lima Martins', '(44) 910988-203', NULL, 'cadastro029@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(390, 'Leonardo Martins Pereira', '(44) 911059-207', NULL, 'cadastro030@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(391, 'Ana Vieira Santos', '(44) 911130-211', NULL, 'cadastro031@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(392, 'Bruno Costa Costa', '(44) 911201-214', NULL, 'cadastro032@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(393, 'Camila Rocha Barbosa', '(44) 911272-218', NULL, 'cadastro033@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(394, 'Daniel Almeida Esteves', '(44) 911343-222', NULL, 'cadastro034@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(395, 'Eduarda Barbosa Henriques', '(44) 911414-225', NULL, 'cadastro035@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(396, 'Felipe Cardoso Nascimento', '(44) 911485-229', NULL, 'cadastro036@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(397, 'Gabriela Dias Queiroz', '(44) 911556-233', NULL, 'cadastro037@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(398, 'Henrique Esteves Teixeira', '(44) 911627-236', NULL, 'cadastro038@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(399, 'Isabela Ferreira Rocha', '(44) 911698-240', NULL, 'cadastro039@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(400, 'João Gomes Cardoso', '(44) 911769-244', NULL, 'cadastro040@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(401, 'Karina Henriques Ferreira', '(44) 911840-248', NULL, 'cadastro041@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(402, 'Lucas Lima Lima', '(44) 911911-251', NULL, 'cadastro042@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(403, 'Mariana Martins Oliveira', '(44) 911982-255', NULL, 'cadastro043@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(404, 'Nicolas Nascimento Ribeiro', '(44) 912053-259', NULL, 'cadastro044@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(405, 'Olívia Oliveira Vieira', '(44) 912124-262', NULL, 'cadastro045@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(406, 'Paulo Pereira Almeida', '(44) 912195-266', NULL, 'cadastro046@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(407, 'Renata Queiroz Dias', '(44) 912266-270', NULL, 'cadastro047@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(408, 'Samuel Ribeiro Gomes', '(44) 912337-273', NULL, 'cadastro048@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(409, 'Tatiane Santos Martins', '(44) 912408-277', NULL, 'cadastro049@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(410, 'Vinícius Teixeira Pereira', '(44) 912479-281', NULL, 'cadastro050@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(411, 'Aline Vieira Santos', '(44) 912550-285', NULL, 'cadastro051@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(412, 'Caio Costa Costa', '(44) 912621-288', NULL, 'cadastro052@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(413, 'Débora Rocha Barbosa', '(44) 912692-292', NULL, 'cadastro053@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(414, 'Elias Almeida Esteves', '(44) 912763-296', NULL, 'cadastro054@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(415, 'Fernanda Barbosa Henriques', '(44) 912834-299', NULL, 'cadastro055@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(416, 'Gustavo Cardoso Nascimento', '(44) 912905-303', NULL, 'cadastro056@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(417, 'Helena Dias Queiroz', '(44) 912976-307', NULL, 'cadastro057@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(418, 'Igor Esteves Teixeira', '(44) 913047-310', NULL, 'cadastro058@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(419, 'Juliana Ferreira Rocha', '(44) 913118-314', NULL, 'cadastro059@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(420, 'Leonardo Gomes Cardoso', '(44) 913189-318', NULL, 'cadastro060@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(421, 'Ana Ribeiro Ferreira', '(44) 913260-322', NULL, 'cadastro061@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(422, 'Bruno Santos Lima', '(44) 913331-325', NULL, 'cadastro062@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(423, 'Camila Teixeira Oliveira', '(44) 913402-329', NULL, 'cadastro063@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(424, 'Daniel Vieira Ribeiro', '(44) 913473-333', NULL, 'cadastro064@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(425, 'Eduarda Costa Vieira', '(44) 913544-336', NULL, 'cadastro065@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(426, 'Felipe Rocha Almeida', '(44) 913615-340', NULL, 'cadastro066@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(427, 'Gabriela Almeida Dias', '(44) 913686-344', NULL, 'cadastro067@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(428, 'Henrique Barbosa Gomes', '(44) 913757-347', NULL, 'cadastro068@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(429, 'Isabela Cardoso Martins', '(44) 913828-351', NULL, 'cadastro069@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(430, 'João Dias Pereira', '(44) 913899-355', NULL, 'cadastro070@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(431, 'Karina Esteves Santos', '(44) 913970-359', NULL, 'cadastro071@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(432, 'Lucas Ferreira Costa', '(44) 914041-362', NULL, 'cadastro072@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(433, 'Mariana Gomes Barbosa', '(44) 914112-366', NULL, 'cadastro073@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(434, 'Nicolas Henriques Esteves', '(44) 914183-370', NULL, 'cadastro074@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(435, 'Olívia Lima Henriques', '(44) 914254-373', NULL, 'cadastro075@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(436, 'Paulo Martins Nascimento', '(44) 914325-377', NULL, 'cadastro076@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(437, 'Renata Nascimento Queiroz', '(44) 914396-381', NULL, 'cadastro077@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(438, 'Samuel Oliveira Teixeira', '(44) 914467-384', NULL, 'cadastro078@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(439, 'Tatiane Pereira Rocha', '(44) 914538-388', NULL, 'cadastro079@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 0),
(440, 'Vinícius Queiroz Cardoso', '(44) 914609-392', NULL, 'cadastro080@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(441, 'Aline Ribeiro Ferreira', '(44) 914680-396', NULL, 'cadastro081@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(442, 'Caio Santos Lima', '(44) 914751-399', NULL, 'cadastro082@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(443, 'Débora Teixeira Oliveira', '(44) 914822-403', NULL, 'cadastro083@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(444, 'Elias Vieira Ribeiro', '(44) 914893-407', NULL, 'cadastro084@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(445, 'Fernanda Costa Vieira', '(44) 914964-410', NULL, 'cadastro085@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(446, 'Gustavo Rocha Almeida', '(44) 915035-414', NULL, 'cadastro086@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(447, 'Helena Almeida Dias', '(44) 915106-418', NULL, 'cadastro087@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(448, 'Igor Barbosa Gomes', '(44) 915177-421', NULL, 'cadastro088@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(449, 'Juliana Cardoso Martins', '(44) 915248-425', NULL, 'cadastro089@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1),
(450, 'Leonardo Dias Pereira', '44915319429', '13801502996', 'cadastro090@example.invalid', '', '', '', '', 'Cianorte', NULL, 1),
(451, 'ELITON R AGUERA LTDA', '4491854141', '24088883000100', '', '87204000', 'AVENIDA ILHA DO MEL', '390', 'JARDIM UNIVERSIDADE II', 'CIANORTE', 'xBW3E0jhAec0iBvwGX3nlLHRluw2', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `configuracao_sistema`
--

CREATE TABLE `configuracao_sistema` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `cliente_padrao_codigo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `configuracao_sistema`
--

INSERT INTO `configuracao_sistema` (`id`, `cliente_padrao_codigo`) VALUES
(1, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `entrada_estoque`
--

CREATE TABLE `entrada_estoque` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `data_entrada` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `entrada_estoque`
--

INSERT INTO `entrada_estoque` (`id`, `produto_id`, `quantidade`, `data_entrada`) VALUES
(271, 1, 15, '2026-11-28 12:24:22'),
(272, 2, 20, '2026-11-28 12:24:22'),
(273, 3, 25, '2026-11-28 12:24:22'),
(274, 4, 30, '2026-11-28 12:24:22'),
(275, 5, 15, '2026-11-28 12:24:22'),
(276, 6, 20, '2026-11-28 12:24:22'),
(277, 7, 25, '2026-11-28 12:24:22'),
(278, 8, 30, '2026-11-28 12:24:22'),
(279, 9, 15, '2026-11-28 12:24:22'),
(280, 10, 20, '2026-11-28 12:24:22'),
(281, 11, 25, '2026-11-28 12:24:22'),
(282, 12, 30, '2026-11-28 12:24:22'),
(283, 13, 15, '2026-11-28 12:24:22'),
(284, 14, 20, '2026-11-28 12:24:22'),
(285, 15, 25, '2026-11-28 12:24:22'),
(286, 16, 30, '2026-11-28 12:24:22'),
(287, 17, 15, '2026-11-28 12:24:22'),
(288, 18, 20, '2026-11-28 12:24:22'),
(289, 19, 25, '2026-11-28 12:24:22'),
(290, 20, 30, '2026-11-28 12:24:22'),
(291, 21, 15, '2026-11-28 12:24:22'),
(292, 22, 20, '2026-11-28 12:24:22'),
(293, 23, 25, '2026-11-28 12:24:22'),
(294, 24, 30, '2026-11-28 12:24:22'),
(295, 25, 15, '2026-11-28 12:24:22'),
(296, 26, 20, '2026-11-28 12:24:22'),
(297, 27, 25, '2026-11-28 12:24:22'),
(298, 28, 30, '2026-11-28 12:24:22'),
(299, 29, 15, '2026-11-28 12:24:22'),
(300, 30, 20, '2026-11-28 12:24:22'),
(301, 31, 25, '2026-11-28 12:24:22'),
(302, 32, 30, '2026-11-28 12:24:22'),
(303, 33, 15, '2026-11-28 12:24:22'),
(304, 34, 20, '2026-11-28 12:24:22'),
(305, 35, 25, '2026-11-28 12:24:22'),
(306, 36, 30, '2026-11-28 12:24:22'),
(307, 37, 15, '2026-11-28 12:24:22'),
(308, 38, 20, '2026-11-28 12:24:22'),
(309, 39, 25, '2026-11-28 12:24:22'),
(310, 40, 30, '2026-11-28 12:24:22'),
(311, 41, 15, '2026-11-28 12:24:22'),
(312, 42, 20, '2026-11-28 12:24:22'),
(313, 43, 25, '2026-11-28 12:24:22'),
(314, 44, 30, '2026-11-28 12:24:22'),
(315, 45, 15, '2026-11-28 12:24:22');

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
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
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  `cep` varchar(10) DEFAULT NULL,
  `endereco` varchar(200) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`id`, `nome`, `cpf`, `cargo`, `telefone`, `email`, `data_admissao`, `salario`, `ativo`, `criado_em`, `usuario_id`, `cep`, `endereco`, `numero`, `bairro`, `cidade`) VALUES
(1, 'Lucas Martins Pereira', '111.222.333-44', 'Gerente', '(44) 99111-2233', 'lucas.pereira@ravia.com', '2024-03-04', 4500.00, 1, '2026-10-20 23:27:50', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Mariana Alves Costa', '222.333.444-55', 'Vendedora', '(44) 98822-3344', 'mariana.costa@ravia.com', '2024-08-12', 2200.00, 1, '2026-10-20 23:27:50', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Thiago Ramos Silva', '333.444.555-66', 'Vendedor', '(44) 99933-4455', 'thiago.silva@ravia.com', '2025-01-20', 2200.00, 1, '2026-10-20 23:27:50', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'Camila Rodrigues Lopes', '13801502996', 'Caixa', '44987445566', 'camila.lopes@ravia.com', '2025-06-02', 1950.00, 1, '2026-10-20 23:27:50', NULL, '', '', '', '', ''),
(5, 'Eduardo Santos Barros', '555.666.777-88', 'Estoquista', '(44) 99655-6677', 'eduardo.barros@ravia.com', '2025-11-17', 1850.00, 0, '2026-10-20 23:27:50', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `item_venda`
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
-- Despejando dados para a tabela `item_venda`
--

INSERT INTO `item_venda` (`num_venda`, `num_produto`, `quantidade`, `preco_unitario`, `desconto_valor`, `desconto_percentual`, `acrescimo`, `subtotal_item`) VALUES
(220, 45, 1, 69.90, 0.00, 0.00, 0.00, 69.90),
(221, 44, 1, 69.90, 0.00, 0.00, 0.00, 69.90),
(222, 41, 2, 79.90, 0.00, 0.00, 0.00, 159.80),
(223, 29, 1, 89.90, 0.00, 0.00, 0.00, 89.90);

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
-- Estrutura para tabela `movimento_estoque`
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
-- Estrutura para tabela `movimento_financeiro`
--

CREATE TABLE `movimento_financeiro` (
  `id` int(11) NOT NULL,
  `num_venda` int(11) NOT NULL,
  `tipo` enum('ENTRADA','SAIDA') NOT NULL,
  `forma_pagamento` enum('DINHEIRO','PIX','CARTAO_DEBITO','CARTAO_CREDITO') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `data_movimento` date NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `movimento_financeiro`
--

INSERT INTO `movimento_financeiro` (`id`, `num_venda`, `tipo`, `forma_pagamento`, `valor`, `data_movimento`, `criado_em`) VALUES
(2, 220, 'ENTRADA', 'DINHEIRO', 69.90, '2026-11-28', '2026-11-28 12:25:51'),
(3, 220, 'SAIDA', 'DINHEIRO', 69.90, '2026-11-28', '2026-11-28 12:31:07'),
(4, 221, 'ENTRADA', 'PIX', 27.90, '2026-11-28', '2026-11-28 13:05:29'),
(5, 222, 'ENTRADA', 'DINHEIRO', 139.80, '2026-11-28', '2026-11-28 13:08:49'),
(6, 223, 'ENTRADA', 'DINHEIRO', 89.90, '2026-11-28', '2026-11-28 13:09:19');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `valor_custo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `valor_venda` decimal(10,2) NOT NULL DEFAULT 0.00,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` varchar(128) DEFAULT NULL COMMENT 'UID do usuário do Firebase que cadastrou',
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`id`, `nome`, `descricao`, `categoria`, `valor_custo`, `valor_venda`, `criado_em`, `usuario_id`, `ativo`) VALUES
(1, 'Calcinha de Algodão Preta P', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(2, 'Calcinha de Algodão Preta M', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(3, 'Calcinha de Algodão Preta G', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(4, 'Calcinha de Algodão Bege P', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(5, 'Calcinha de Algodão Bege M', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(6, 'Calcinha de Algodão Bege G', 'Algodão confortável para uso diário', 'Calcinhas', 8.00, 19.90, '2026-11-28 15:24:22', NULL, 1),
(7, 'Calcinha de Renda Preta P', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(8, 'Calcinha de Renda Preta M', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(9, 'Calcinha de Renda Preta G', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(10, 'Calcinha de Renda Vermelha P', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(11, 'Calcinha de Renda Vermelha M', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(12, 'Calcinha de Renda Vermelha G', 'Renda macia com forro de algodão', 'Calcinhas', 12.00, 29.90, '2026-11-28 15:24:22', NULL, 1),
(13, 'Calcinha Sem Costura Bege P', 'Microfibra sem costura', 'Calcinhas', 10.00, 24.90, '2026-11-28 15:24:22', NULL, 1),
(14, 'Calcinha Sem Costura Bege M', 'Microfibra sem costura', 'Calcinhas', 10.00, 24.90, '2026-11-28 15:24:22', NULL, 1),
(15, 'Calcinha Sem Costura Bege G', 'Microfibra sem costura', 'Calcinhas', 10.00, 24.90, '2026-11-28 15:24:22', NULL, 1),
(16, 'Sutiã com Bojo Preto P', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(17, 'Sutiã com Bojo Preto M', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(18, 'Sutiã com Bojo Preto G', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(19, 'Sutiã com Bojo Bege P', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(20, 'Sutiã com Bojo Bege M', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(21, 'Sutiã com Bojo Bege G', 'Bojo e alças reguláveis', 'Sutiãs', 24.00, 59.90, '2026-11-28 15:24:22', NULL, 1),
(22, 'Sutiã sem Bojo Branco P', 'Modelo leve sem bojo', 'Sutiãs', 19.00, 44.90, '2026-11-28 15:24:22', NULL, 1),
(23, 'Sutiã sem Bojo Branco M', 'Modelo leve sem bojo', 'Sutiãs', 19.00, 44.90, '2026-11-28 15:24:22', NULL, 1),
(24, 'Sutiã sem Bojo Branco G', 'Modelo leve sem bojo', 'Sutiãs', 19.00, 44.90, '2026-11-28 15:24:22', NULL, 1),
(25, 'Conjunto de Lingerie Preto P', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(26, 'Conjunto de Lingerie Preto M', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(27, 'Conjunto de Lingerie Preto G', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(28, 'Conjunto de Lingerie Rosa P', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(29, 'Conjunto de Lingerie Rosa M', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(30, 'Conjunto de Lingerie Rosa G', 'Sutiã e calcinha em renda', 'Conjuntos', 35.00, 89.90, '2026-11-28 15:24:22', NULL, 1),
(31, 'Cueca Boxer Preta P', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(32, 'Cueca Boxer Preta M', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(33, 'Cueca Boxer Preta G', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(34, 'Cueca Boxer Cinza P', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(35, 'Cueca Boxer Cinza M', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(36, 'Cueca Boxer Cinza G', 'Algodão com elastano', 'Cuecas', 13.00, 32.90, '2026-11-28 15:24:22', NULL, 1),
(37, 'Cueca Slip Azul P', 'Algodão com elástico confortável', 'Cuecas', 9.00, 22.90, '2026-11-28 15:24:22', NULL, 1),
(38, 'Cueca Slip Azul M', 'Algodão com elástico confortável', 'Cuecas', 9.00, 22.90, '2026-11-28 15:24:22', NULL, 1),
(39, 'Cueca Slip Azul G', 'Algodão com elástico confortável', 'Cuecas', 9.00, 22.90, '2026-11-28 15:24:22', NULL, 1),
(40, 'Pijama Feminino Curto Rosa P', 'Conjunto de camiseta e short', 'Pijamas', 32.00, 79.90, '2026-11-28 15:24:22', NULL, 1),
(41, 'Pijama Feminino Curto Rosa M', 'Conjunto de camiseta e short', 'Pijamas', 32.00, 79.90, '2026-11-28 15:24:22', NULL, 1),
(42, 'Pijama Feminino Curto Rosa G', 'Conjunto de camiseta e short', 'Pijamas', 32.00, 79.90, '2026-11-28 15:24:22', NULL, 1),
(43, 'Camisola de Cetim Preta P', 'Cetim leve com alças reguláveis', 'Camisolas', 29.00, 69.90, '2026-11-28 15:24:22', NULL, 1),
(44, 'Camisola de Cetim Preta M', 'Cetim leve com alças reguláveis', 'Calcinhas', 32.32, 69.90, '2026-11-28 15:24:22', NULL, 1),
(45, 'Camisola de Cetim Preta G', 'Cetim leve com alças reguláveis', 'Camisolas', 29.00, 69.90, '2026-11-28 15:24:22', NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `email`, `senha`, `criado_em`) VALUES
(1, 'Usuário Teste', 'teste@ravia.com', '$2y$10$BtZezl2WfoHdYpmKWMghMOfx6.Oi7bFZ9cswOHfVI5aeA7PoJNCMa', '2026-10-20 23:27:50');

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda`
--

CREATE TABLE `venda` (
  `num_venda` int(11) NOT NULL,
  `data_venda` datetime NOT NULL DEFAULT current_timestamp(),
  `num_cliente` int(11) DEFAULT NULL,
  `num_funcionario` int(11) DEFAULT NULL,
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
-- Despejando dados para a tabela `venda`
--

INSERT INTO `venda` (`num_venda`, `data_venda`, `num_cliente`, `num_funcionario`, `desconto_valor`, `desconto_percentual`, `acrescimo`, `valor_total`, `observacao`, `situacao`, `cancelada_em`, `cancelada_por`, `motivo_cancelamento`) VALUES
(220, '2026-11-28 00:00:00', 446, 4, 0.00, 0.00, 0.00, 69.90, '', 'CANCELADA', '2026-11-28 12:31:07', 'xBW3E0jhAec0iBvwGX3nlLHRluw2', 'teste'),
(221, '2026-11-28 00:00:00', 446, 4, 42.00, 0.00, 0.00, 27.90, 'teste', 'ATIVA', NULL, NULL, NULL),
(222, '2026-11-28 00:00:00', 446, 1, 20.00, 0.00, 0.00, 139.80, '', 'ATIVA', NULL, NULL, NULL),
(223, '2026-11-28 00:00:00', 447, 4, 0.00, 0.00, 0.00, 89.90, '', 'ATIVA', NULL, NULL, NULL);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `acerto_estoque`
--
ALTER TABLE `acerto_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_acerto_data` (`data_emissao`);

--
-- Índices de tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_acerto_item_acerto` (`acerto_id`),
  ADD KEY `idx_acerto_produto` (`produto_id`);

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `descricao` (`descricao`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `idx_cliente_usuario` (`usuario_id`);

--
-- Índices de tabela `configuracao_sistema`
--
ALTER TABLE `configuracao_sistema`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_funcionario_cpf` (`cpf`),
  ADD KEY `idx_funcionario_usuario` (`usuario_id`);

--
-- Índices de tabela `item_venda`
--
ALTER TABLE `item_venda`
  ADD PRIMARY KEY (`num_venda`,`num_produto`),
  ADD KEY `fk_item_venda_produto` (`num_produto`);

--
-- Índices de tabela `movimento_estoque`
--
ALTER TABLE `movimento_estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_movimento_produto` (`produto_id`);

--
-- Índices de tabela `movimento_financeiro`
--
ALTER TABLE `movimento_financeiro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_financeiro_data` (`data_movimento`),
  ADD KEY `idx_financeiro_venda` (`num_venda`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_produto_usuario` (`usuario_id`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`num_venda`),
  ADD KEY `fk_venda_cliente` (`num_cliente`),
  ADD KEY `idx_venda_funcionario` (`num_funcionario`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acerto_estoque`
--
ALTER TABLE `acerto_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=452;

--
-- AUTO_INCREMENT de tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=316;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=271;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `venda`
--
ALTER TABLE `venda`
  MODIFY `num_venda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=224;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  ADD CONSTRAINT `fk_acerto_item_acerto` FOREIGN KEY (`acerto_id`) REFERENCES `acerto_estoque` (`id`),
  ADD CONSTRAINT `fk_acerto_item_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Restrições para tabelas `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  ADD CONSTRAINT `entrada_estoque_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Restrições para tabelas `item_venda`
--
ALTER TABLE `item_venda`
  ADD CONSTRAINT `fk_item_venda_produto` FOREIGN KEY (`num_produto`) REFERENCES `produto` (`id`),
  ADD CONSTRAINT `fk_item_venda_venda` FOREIGN KEY (`num_venda`) REFERENCES `venda` (`num_venda`) ON DELETE CASCADE;

--
-- Restrições para tabelas `movimento_estoque`
--
ALTER TABLE `movimento_estoque`
  ADD CONSTRAINT `fk_movimento_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Restrições para tabelas `movimento_financeiro`
--
ALTER TABLE `movimento_financeiro`
  ADD CONSTRAINT `fk_financeiro_venda` FOREIGN KEY (`num_venda`) REFERENCES `venda` (`num_venda`);

--
-- Restrições para tabelas `venda`
--
ALTER TABLE `venda`
  ADD CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`num_cliente`) REFERENCES `cliente` (`codigo`),
  ADD CONSTRAINT `fk_venda_funcionario` FOREIGN KEY (`num_funcionario`) REFERENCES `funcionario` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
