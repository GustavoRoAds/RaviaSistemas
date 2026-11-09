-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Tempo de geração: 08-Nov-2026 às 20:09
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
(1, '2026-11-03', 'g6qJfPuX9HN4zalYwrHbl1TTDcp2', '2026-11-03 21:47:10'),
(2, '2026-11-03', 'g6qJfPuX9HN4zalYwrHbl1TTDcp2', '2026-11-03 21:58:32'),
(3, '2026-11-03', 'g6qJfPuX9HN4zalYwrHbl1TTDcp2', '2026-11-03 22:38:56');

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
(450, 'Leonardo Dias Pereira', '(44) 915319-429', NULL, 'cadastro090@example.invalid', NULL, NULL, NULL, NULL, 'Cianorte', NULL, 1);

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

--
-- Extraindo dados da tabela `entrada_estoque`
--

INSERT INTO `entrada_estoque` (`id`, `produto_id`, `quantidade`, `data_entrada`) VALUES
(1, 1, 500, '2026-01-02 09:00:00'),
(2, 2, 500, '2026-01-02 09:00:00'),
(3, 3, 500, '2026-01-02 09:00:00'),
(4, 4, 500, '2026-01-02 09:00:00'),
(5, 5, 500, '2026-01-02 09:00:00'),
(6, 6, 500, '2026-01-02 09:00:00'),
(7, 7, 500, '2026-01-02 09:00:00'),
(8, 8, 500, '2026-01-02 09:00:00'),
(9, 9, 500, '2026-01-02 09:00:00'),
(10, 10, 500, '2026-01-02 09:00:00'),
(11, 11, 500, '2026-01-02 09:00:00'),
(12, 12, 500, '2026-01-02 09:00:00'),
(13, 13, 500, '2026-01-02 09:00:00'),
(14, 14, 500, '2026-01-02 09:00:00'),
(15, 15, 500, '2026-01-02 09:00:00'),
(16, 16, 500, '2026-01-02 09:00:00'),
(17, 17, 500, '2026-01-02 09:00:00'),
(18, 18, 500, '2026-01-02 09:00:00'),
(19, 19, 500, '2026-01-02 09:00:00'),
(20, 20, 500, '2026-01-02 09:00:00'),
(21, 21, 500, '2026-01-02 09:00:00'),
(22, 22, 500, '2026-01-02 09:00:00'),
(23, 23, 500, '2026-01-02 09:00:00'),
(24, 24, 500, '2026-01-02 09:00:00'),
(25, 25, 500, '2026-01-02 09:00:00'),
(26, 26, 500, '2026-01-02 09:00:00'),
(27, 27, 500, '2026-01-02 09:00:00'),
(28, 28, 500, '2026-01-02 09:00:00'),
(29, 29, 500, '2026-01-02 09:00:00'),
(30, 30, 500, '2026-01-02 09:00:00'),
(31, 31, 500, '2026-01-02 09:00:00'),
(32, 32, 500, '2026-01-02 09:00:00'),
(33, 33, 500, '2026-01-02 09:00:00'),
(34, 34, 500, '2026-01-02 09:00:00'),
(35, 35, 500, '2026-01-02 09:00:00'),
(36, 36, 500, '2026-01-02 09:00:00'),
(37, 37, 500, '2026-01-02 09:00:00'),
(38, 38, 500, '2026-01-02 09:00:00'),
(39, 39, 500, '2026-01-02 09:00:00'),
(40, 40, 500, '2026-01-02 09:00:00'),
(41, 41, 500, '2026-01-02 09:00:00'),
(42, 42, 500, '2026-01-02 09:00:00'),
(43, 43, 500, '2026-01-02 09:00:00'),
(44, 44, 500, '2026-01-02 09:00:00'),
(45, 45, 500, '2026-01-02 09:00:00'),
(46, 46, 500, '2026-01-02 09:00:00'),
(47, 47, 500, '2026-01-02 09:00:00'),
(48, 48, 500, '2026-01-02 09:00:00'),
(49, 49, 500, '2026-01-02 09:00:00'),
(50, 50, 500, '2026-01-02 09:00:00'),
(51, 51, 500, '2026-01-02 09:00:00'),
(52, 52, 500, '2026-01-02 09:00:00'),
(53, 53, 500, '2026-01-02 09:00:00'),
(54, 54, 500, '2026-01-02 09:00:00'),
(55, 55, 500, '2026-01-02 09:00:00'),
(56, 56, 500, '2026-01-02 09:00:00'),
(57, 57, 500, '2026-01-02 09:00:00'),
(58, 58, 500, '2026-01-02 09:00:00'),
(59, 59, 500, '2026-01-02 09:00:00'),
(60, 60, 500, '2026-01-02 09:00:00'),
(61, 61, 500, '2026-01-02 09:00:00'),
(62, 62, 500, '2026-01-02 09:00:00'),
(63, 63, 500, '2026-01-02 09:00:00'),
(64, 64, 500, '2026-01-02 09:00:00'),
(65, 65, 500, '2026-01-02 09:00:00'),
(66, 66, 500, '2026-01-02 09:00:00'),
(67, 67, 500, '2026-01-02 09:00:00'),
(68, 68, 500, '2026-01-02 09:00:00'),
(69, 69, 500, '2026-01-02 09:00:00'),
(70, 70, 500, '2026-01-02 09:00:00'),
(71, 71, 500, '2026-01-02 09:00:00'),
(72, 72, 500, '2026-01-02 09:00:00'),
(73, 73, 500, '2026-01-02 09:00:00'),
(74, 74, 500, '2026-01-02 09:00:00'),
(75, 75, 500, '2026-01-02 09:00:00'),
(76, 76, 500, '2026-01-02 09:00:00'),
(77, 77, 500, '2026-01-02 09:00:00'),
(78, 78, 500, '2026-01-02 09:00:00'),
(79, 79, 500, '2026-01-02 09:00:00'),
(80, 80, 500, '2026-01-02 09:00:00'),
(81, 81, 500, '2026-01-02 09:00:00'),
(82, 82, 500, '2026-01-02 09:00:00'),
(83, 83, 500, '2026-01-02 09:00:00'),
(84, 84, 500, '2026-01-02 09:00:00'),
(85, 85, 500, '2026-01-02 09:00:00'),
(86, 86, 500, '2026-01-02 09:00:00'),
(87, 87, 500, '2026-01-02 09:00:00'),
(88, 88, 500, '2026-01-02 09:00:00'),
(89, 89, 500, '2026-01-02 09:00:00'),
(90, 90, 500, '2026-01-02 09:00:00'),
(91, 91, 500, '2026-01-02 09:00:00'),
(92, 92, 500, '2026-01-02 09:00:00'),
(93, 93, 500, '2026-01-02 09:00:00'),
(94, 94, 500, '2026-01-02 09:00:00'),
(95, 95, 500, '2026-01-02 09:00:00'),
(96, 96, 500, '2026-01-02 09:00:00'),
(97, 97, 500, '2026-01-02 09:00:00'),
(98, 98, 500, '2026-01-02 09:00:00'),
(99, 99, 500, '2026-01-02 09:00:00'),
(100, 100, 500, '2026-01-02 09:00:00'),
(101, 101, 500, '2026-01-02 09:00:00'),
(102, 102, 500, '2026-01-02 09:00:00'),
(103, 103, 500, '2026-01-02 09:00:00'),
(104, 104, 500, '2026-01-02 09:00:00'),
(105, 105, 500, '2026-01-02 09:00:00'),
(106, 106, 500, '2026-01-02 09:00:00'),
(107, 107, 500, '2026-01-02 09:00:00'),
(108, 108, 500, '2026-01-02 09:00:00'),
(109, 109, 500, '2026-01-02 09:00:00'),
(110, 110, 500, '2026-01-02 09:00:00'),
(111, 111, 500, '2026-01-02 09:00:00'),
(112, 112, 500, '2026-01-02 09:00:00'),
(113, 113, 500, '2026-01-02 09:00:00'),
(114, 114, 500, '2026-01-02 09:00:00'),
(115, 115, 500, '2026-01-02 09:00:00'),
(116, 116, 500, '2026-01-02 09:00:00'),
(117, 117, 500, '2026-01-02 09:00:00'),
(118, 118, 500, '2026-01-02 09:00:00'),
(119, 119, 500, '2026-01-02 09:00:00'),
(120, 120, 500, '2026-01-02 09:00:00'),
(121, 121, 500, '2026-01-02 09:00:00'),
(122, 122, 500, '2026-01-02 09:00:00'),
(123, 123, 500, '2026-01-02 09:00:00'),
(124, 124, 500, '2026-01-02 09:00:00'),
(125, 125, 500, '2026-01-02 09:00:00'),
(126, 126, 500, '2026-01-02 09:00:00'),
(127, 127, 500, '2026-01-02 09:00:00'),
(128, 128, 500, '2026-01-02 09:00:00'),
(129, 129, 500, '2026-01-02 09:00:00'),
(130, 130, 500, '2026-01-02 09:00:00'),
(131, 131, 500, '2026-01-02 09:00:00'),
(132, 132, 500, '2026-01-02 09:00:00'),
(133, 133, 500, '2026-01-02 09:00:00'),
(134, 134, 500, '2026-01-02 09:00:00'),
(135, 135, 500, '2026-01-02 09:00:00'),
(136, 136, 500, '2026-01-02 09:00:00'),
(137, 137, 500, '2026-01-02 09:00:00'),
(138, 138, 500, '2026-01-02 09:00:00'),
(139, 139, 500, '2026-01-02 09:00:00'),
(140, 140, 500, '2026-01-02 09:00:00'),
(141, 141, 500, '2026-01-02 09:00:00'),
(142, 142, 500, '2026-01-02 09:00:00'),
(143, 143, 500, '2026-01-02 09:00:00'),
(144, 144, 500, '2026-01-02 09:00:00'),
(145, 145, 500, '2026-01-02 09:00:00'),
(146, 146, 500, '2026-01-02 09:00:00'),
(147, 147, 500, '2026-01-02 09:00:00'),
(148, 148, 500, '2026-01-02 09:00:00'),
(149, 149, 500, '2026-01-02 09:00:00'),
(150, 150, 500, '2026-01-02 09:00:00'),
(151, 151, 500, '2026-01-02 09:00:00'),
(152, 152, 500, '2026-01-02 09:00:00'),
(153, 153, 500, '2026-01-02 09:00:00'),
(154, 154, 500, '2026-01-02 09:00:00'),
(155, 155, 500, '2026-01-02 09:00:00'),
(156, 156, 500, '2026-01-02 09:00:00'),
(157, 157, 500, '2026-01-02 09:00:00'),
(158, 158, 500, '2026-01-02 09:00:00'),
(159, 159, 500, '2026-01-02 09:00:00'),
(160, 160, 500, '2026-01-02 09:00:00'),
(161, 161, 500, '2026-01-02 09:00:00'),
(162, 162, 500, '2026-01-02 09:00:00'),
(163, 163, 500, '2026-01-02 09:00:00'),
(164, 164, 500, '2026-01-02 09:00:00'),
(165, 165, 500, '2026-01-02 09:00:00'),
(166, 166, 500, '2026-01-02 09:00:00'),
(167, 167, 500, '2026-01-02 09:00:00'),
(168, 168, 500, '2026-01-02 09:00:00'),
(169, 169, 500, '2026-01-02 09:00:00'),
(170, 170, 500, '2026-01-02 09:00:00'),
(171, 171, 500, '2026-01-02 09:00:00'),
(172, 172, 500, '2026-01-02 09:00:00'),
(173, 173, 500, '2026-01-02 09:00:00'),
(174, 174, 500, '2026-01-02 09:00:00'),
(175, 175, 500, '2026-01-02 09:00:00'),
(176, 176, 500, '2026-01-02 09:00:00'),
(177, 177, 500, '2026-01-02 09:00:00'),
(178, 178, 500, '2026-01-02 09:00:00'),
(179, 179, 500, '2026-01-02 09:00:00'),
(180, 180, 500, '2026-01-02 09:00:00'),
(181, 181, 500, '2026-01-02 09:00:00'),
(182, 182, 500, '2026-01-02 09:00:00'),
(183, 183, 500, '2026-01-02 09:00:00'),
(184, 184, 500, '2026-01-02 09:00:00'),
(185, 185, 500, '2026-01-02 09:00:00'),
(186, 186, 500, '2026-01-02 09:00:00'),
(187, 187, 500, '2026-01-02 09:00:00'),
(188, 188, 500, '2026-01-02 09:00:00'),
(189, 189, 500, '2026-01-02 09:00:00'),
(190, 190, 500, '2026-01-02 09:00:00'),
(191, 191, 500, '2026-01-02 09:00:00'),
(192, 192, 500, '2026-01-02 09:00:00'),
(193, 193, 500, '2026-01-02 09:00:00'),
(194, 194, 500, '2026-01-02 09:00:00'),
(195, 195, 500, '2026-01-02 09:00:00'),
(196, 196, 500, '2026-01-02 09:00:00'),
(197, 197, 500, '2026-01-02 09:00:00'),
(198, 198, 500, '2026-01-02 09:00:00'),
(199, 199, 500, '2026-01-02 09:00:00'),
(200, 200, 500, '2026-01-02 09:00:00'),
(201, 201, 500, '2026-01-02 09:00:00'),
(202, 202, 500, '2026-01-02 09:00:00'),
(203, 203, 500, '2026-01-02 09:00:00'),
(204, 204, 500, '2026-01-02 09:00:00'),
(205, 205, 500, '2026-01-02 09:00:00'),
(206, 206, 500, '2026-01-02 09:00:00'),
(207, 207, 500, '2026-01-02 09:00:00'),
(208, 208, 500, '2026-01-02 09:00:00'),
(209, 209, 500, '2026-01-02 09:00:00'),
(210, 210, 500, '2026-01-02 09:00:00'),
(211, 211, 500, '2026-01-02 09:00:00'),
(212, 212, 500, '2026-01-02 09:00:00'),
(213, 213, 500, '2026-01-02 09:00:00'),
(214, 214, 500, '2026-01-02 09:00:00'),
(215, 215, 500, '2026-01-02 09:00:00'),
(216, 216, 500, '2026-01-02 09:00:00'),
(217, 217, 500, '2026-01-02 09:00:00'),
(218, 218, 500, '2026-01-02 09:00:00'),
(219, 219, 500, '2026-01-02 09:00:00'),
(220, 220, 500, '2026-01-02 09:00:00'),
(221, 221, 500, '2026-01-02 09:00:00'),
(222, 222, 500, '2026-01-02 09:00:00'),
(223, 223, 500, '2026-01-02 09:00:00'),
(224, 224, 500, '2026-01-02 09:00:00'),
(225, 225, 500, '2026-01-02 09:00:00'),
(226, 226, 500, '2026-01-02 09:00:00'),
(227, 227, 500, '2026-01-02 09:00:00'),
(228, 228, 500, '2026-01-02 09:00:00'),
(229, 229, 500, '2026-01-02 09:00:00'),
(230, 230, 500, '2026-01-02 09:00:00'),
(231, 231, 500, '2026-01-02 09:00:00'),
(232, 232, 500, '2026-01-02 09:00:00'),
(233, 233, 500, '2026-01-02 09:00:00'),
(234, 234, 500, '2026-01-02 09:00:00'),
(235, 235, 500, '2026-01-02 09:00:00'),
(236, 236, 500, '2026-01-02 09:00:00'),
(237, 237, 500, '2026-01-02 09:00:00'),
(238, 238, 500, '2026-01-02 09:00:00'),
(239, 239, 500, '2026-01-02 09:00:00'),
(240, 240, 500, '2026-01-02 09:00:00'),
(241, 241, 500, '2026-01-02 09:00:00'),
(242, 242, 500, '2026-01-02 09:00:00'),
(243, 243, 500, '2026-01-02 09:00:00'),
(244, 244, 500, '2026-01-02 09:00:00'),
(245, 245, 500, '2026-01-02 09:00:00'),
(246, 246, 500, '2026-01-02 09:00:00'),
(247, 247, 500, '2026-01-02 09:00:00'),
(248, 248, 500, '2026-01-02 09:00:00'),
(249, 249, 500, '2026-01-02 09:00:00'),
(250, 250, 500, '2026-01-02 09:00:00'),
(251, 251, 500, '2026-01-02 09:00:00'),
(252, 252, 500, '2026-01-02 09:00:00'),
(253, 253, 500, '2026-01-02 09:00:00'),
(254, 254, 500, '2026-01-02 09:00:00'),
(255, 255, 500, '2026-01-02 09:00:00'),
(256, 256, 500, '2026-01-02 09:00:00'),
(257, 257, 500, '2026-01-02 09:00:00'),
(258, 258, 500, '2026-01-02 09:00:00'),
(259, 259, 500, '2026-01-02 09:00:00'),
(260, 260, 500, '2026-01-02 09:00:00'),
(261, 261, 500, '2026-01-02 09:00:00'),
(262, 262, 500, '2026-01-02 09:00:00'),
(263, 263, 500, '2026-01-02 09:00:00'),
(264, 264, 500, '2026-01-02 09:00:00'),
(265, 265, 500, '2026-01-02 09:00:00'),
(266, 266, 500, '2026-01-02 09:00:00'),
(267, 267, 500, '2026-01-02 09:00:00'),
(268, 268, 500, '2026-01-02 09:00:00'),
(269, 269, 500, '2026-01-02 09:00:00'),
(270, 270, 500, '2026-01-02 09:00:00');

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
(1, 'Lucas Martins Pereira', '111.222.333-44', 'Gerente', '(44) 99111-2233', 'lucas.pereira@ravia.com', '2024-03-04', 4500.00, 1, '2026-10-20 23:27:50', NULL),
(2, 'Mariana Alves Costa', '222.333.444-55', 'Vendedora', '(44) 98822-3344', 'mariana.costa@ravia.com', '2024-08-12', 2200.00, 1, '2026-10-20 23:27:50', NULL),
(3, 'Thiago Ramos Silva', '333.444.555-66', 'Vendedor', '(44) 99933-4455', 'thiago.silva@ravia.com', '2025-01-20', 2200.00, 1, '2026-10-20 23:27:50', NULL),
(4, 'Camila Rodrigues Lopes', '444.555.666-77', 'Caixa', '(44) 98744-5566', 'camila.lopes@ravia.com', '2025-06-02', 1950.00, 1, '2026-10-20 23:27:50', NULL),
(5, 'Eduardo Santos Barros', '555.666.777-88', 'Estoquista', '(44) 99655-6677', 'eduardo.barros@ravia.com', '2025-11-17', 1850.00, 1, '2026-10-20 23:27:50', NULL);

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
(19, 1, 1, 27.75, 0.00, 0.00, 0.00, 27.75),
(19, 32, 1, 133.20, 0.00, 0.00, 0.00, 133.20),
(20, 2, 2, 40.70, 0.00, 0.00, 0.00, 81.40),
(20, 33, 1, 146.15, 0.00, 0.00, 0.00, 146.15),
(21, 3, 3, 53.65, 0.00, 0.00, 0.00, 160.95),
(21, 34, 1, 159.10, 0.00, 0.00, 0.00, 159.10),
(22, 4, 1, 66.60, 0.00, 0.00, 0.00, 66.60),
(22, 35, 2, 172.05, 0.00, 0.00, 0.00, 344.10),
(23, 5, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(23, 36, 2, 37.00, 0.00, 0.00, 0.00, 74.00),
(24, 6, 3, 92.50, 0.00, 0.00, 0.00, 277.50),
(24, 37, 2, 49.95, 0.00, 0.00, 0.00, 99.90),
(25, 7, 1, 105.45, 0.00, 0.00, 0.00, 105.45),
(25, 38, 1, 62.90, 0.00, 0.00, 0.00, 62.90),
(26, 8, 2, 118.40, 0.00, 0.00, 0.00, 236.80),
(26, 39, 1, 75.85, 0.00, 0.00, 0.00, 75.85),
(27, 9, 3, 131.35, 0.00, 0.00, 0.00, 394.05),
(27, 40, 1, 88.80, 0.00, 0.00, 0.00, 88.80),
(28, 10, 1, 144.30, 0.00, 0.00, 0.00, 144.30),
(28, 41, 2, 101.75, 0.00, 0.00, 0.00, 203.50),
(29, 11, 2, 157.25, 0.00, 0.00, 0.00, 314.50),
(29, 42, 2, 114.70, 0.00, 0.00, 0.00, 229.40),
(30, 12, 3, 170.20, 0.00, 0.00, 0.00, 510.60),
(30, 43, 2, 127.65, 0.00, 0.00, 0.00, 255.30),
(31, 13, 1, 35.15, 0.00, 0.00, 0.00, 35.15),
(31, 44, 1, 140.60, 0.00, 0.00, 0.00, 140.60),
(32, 14, 2, 48.10, 0.00, 0.00, 0.00, 96.20),
(32, 45, 1, 153.55, 0.00, 0.00, 0.00, 153.55),
(33, 15, 3, 61.05, 0.00, 0.00, 0.00, 183.15),
(33, 46, 1, 166.50, 0.00, 0.00, 0.00, 166.50),
(34, 16, 1, 74.00, 0.00, 0.00, 0.00, 74.00),
(34, 47, 2, 31.45, 0.00, 0.00, 0.00, 62.90),
(35, 17, 2, 86.95, 0.00, 0.00, 0.00, 173.90),
(35, 48, 2, 44.40, 0.00, 0.00, 0.00, 88.80),
(36, 18, 3, 99.90, 0.00, 0.00, 0.00, 299.70),
(36, 49, 2, 57.35, 0.00, 0.00, 0.00, 114.70),
(37, 19, 1, 112.85, 0.00, 0.00, 0.00, 112.85),
(37, 50, 1, 70.30, 0.00, 0.00, 0.00, 70.30),
(38, 20, 2, 125.80, 0.00, 0.00, 0.00, 251.60),
(38, 51, 1, 83.25, 0.00, 0.00, 0.00, 83.25),
(39, 21, 3, 138.75, 0.00, 0.00, 0.00, 416.25),
(39, 52, 1, 96.20, 0.00, 0.00, 0.00, 96.20),
(40, 22, 1, 151.70, 0.00, 0.00, 0.00, 151.70),
(40, 53, 2, 109.15, 0.00, 0.00, 0.00, 218.30),
(41, 23, 2, 164.65, 0.00, 0.00, 0.00, 329.30),
(41, 54, 2, 122.10, 0.00, 0.00, 0.00, 244.20),
(42, 24, 3, 29.60, 0.00, 0.00, 0.00, 88.80),
(42, 55, 2, 135.05, 0.00, 0.00, 0.00, 270.10),
(43, 25, 1, 42.55, 0.00, 0.00, 0.00, 42.55),
(43, 56, 1, 148.00, 0.00, 0.00, 0.00, 148.00),
(44, 26, 2, 55.50, 0.00, 0.00, 0.00, 111.00),
(44, 57, 1, 160.95, 0.00, 0.00, 0.00, 160.95),
(45, 27, 3, 68.45, 0.00, 0.00, 0.00, 205.35),
(45, 58, 1, 173.90, 0.00, 0.00, 0.00, 173.90),
(46, 28, 1, 81.40, 0.00, 0.00, 0.00, 81.40),
(46, 59, 2, 38.85, 0.00, 0.00, 0.00, 77.70),
(47, 29, 2, 94.35, 0.00, 0.00, 0.00, 188.70),
(47, 60, 2, 51.80, 0.00, 0.00, 0.00, 103.60),
(48, 30, 3, 107.30, 0.00, 0.00, 0.00, 321.90),
(48, 61, 2, 64.75, 0.00, 0.00, 0.00, 129.50),
(49, 31, 1, 120.25, 0.00, 0.00, 0.00, 120.25),
(49, 62, 1, 77.70, 0.00, 0.00, 0.00, 77.70),
(50, 32, 2, 133.20, 0.00, 0.00, 0.00, 266.40),
(50, 63, 1, 90.65, 0.00, 0.00, 0.00, 90.65),
(51, 33, 3, 146.15, 0.00, 0.00, 0.00, 438.45),
(51, 64, 1, 103.60, 0.00, 0.00, 0.00, 103.60),
(52, 34, 1, 159.10, 0.00, 0.00, 0.00, 159.10),
(52, 65, 2, 116.55, 0.00, 0.00, 0.00, 233.10),
(53, 35, 2, 172.05, 0.00, 0.00, 0.00, 344.10),
(53, 66, 2, 129.50, 0.00, 0.00, 0.00, 259.00),
(54, 36, 3, 37.00, 0.00, 0.00, 0.00, 111.00),
(54, 67, 2, 142.45, 0.00, 0.00, 0.00, 284.90),
(55, 37, 1, 49.95, 0.00, 0.00, 0.00, 49.95),
(55, 68, 1, 155.40, 0.00, 0.00, 0.00, 155.40),
(56, 38, 2, 62.90, 0.00, 0.00, 0.00, 125.80),
(56, 69, 1, 168.35, 0.00, 0.00, 0.00, 168.35),
(57, 39, 3, 75.85, 0.00, 0.00, 0.00, 227.55),
(57, 70, 1, 33.30, 0.00, 0.00, 0.00, 33.30),
(58, 40, 1, 88.80, 0.00, 0.00, 0.00, 88.80),
(58, 71, 2, 46.25, 0.00, 0.00, 0.00, 92.50),
(59, 41, 2, 101.75, 0.00, 0.00, 0.00, 203.50),
(59, 72, 2, 59.20, 0.00, 0.00, 0.00, 118.40),
(60, 42, 3, 114.70, 0.00, 0.00, 0.00, 344.10),
(60, 73, 2, 72.15, 0.00, 0.00, 0.00, 144.30),
(61, 43, 1, 127.65, 0.00, 0.00, 0.00, 127.65),
(61, 74, 1, 85.10, 0.00, 0.00, 0.00, 85.10),
(62, 44, 2, 140.60, 0.00, 0.00, 0.00, 281.20),
(62, 75, 1, 98.05, 0.00, 0.00, 0.00, 98.05),
(63, 45, 3, 153.55, 0.00, 0.00, 0.00, 460.65),
(63, 76, 1, 111.00, 0.00, 0.00, 0.00, 111.00),
(64, 46, 1, 166.50, 0.00, 0.00, 0.00, 166.50),
(64, 77, 2, 123.95, 0.00, 0.00, 0.00, 247.90),
(65, 47, 2, 31.45, 0.00, 0.00, 0.00, 62.90),
(65, 78, 2, 136.90, 0.00, 0.00, 0.00, 273.80),
(66, 48, 3, 44.40, 0.00, 0.00, 0.00, 133.20),
(66, 79, 2, 149.85, 0.00, 0.00, 0.00, 299.70),
(67, 49, 1, 57.35, 0.00, 0.00, 0.00, 57.35),
(67, 80, 1, 162.80, 0.00, 0.00, 0.00, 162.80),
(68, 50, 2, 70.30, 0.00, 0.00, 0.00, 140.60),
(68, 81, 1, 27.75, 0.00, 0.00, 0.00, 27.75),
(69, 51, 3, 83.25, 0.00, 0.00, 0.00, 249.75),
(69, 82, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(70, 52, 1, 96.20, 0.00, 0.00, 0.00, 96.20),
(70, 83, 2, 53.65, 0.00, 0.00, 0.00, 107.30),
(71, 53, 2, 109.15, 0.00, 0.00, 0.00, 218.30),
(71, 84, 2, 66.60, 0.00, 0.00, 0.00, 133.20),
(72, 54, 3, 122.10, 0.00, 0.00, 0.00, 366.30),
(72, 85, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(73, 55, 1, 135.05, 0.00, 0.00, 0.00, 135.05),
(73, 86, 1, 92.50, 0.00, 0.00, 0.00, 92.50),
(74, 56, 2, 148.00, 0.00, 0.00, 0.00, 296.00),
(74, 87, 1, 105.45, 0.00, 0.00, 0.00, 105.45),
(75, 57, 3, 160.95, 0.00, 0.00, 0.00, 482.85),
(75, 88, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(76, 58, 1, 173.90, 0.00, 0.00, 0.00, 173.90),
(76, 89, 2, 131.35, 0.00, 0.00, 0.00, 262.70),
(77, 59, 2, 38.85, 0.00, 0.00, 0.00, 77.70),
(77, 90, 2, 144.30, 0.00, 0.00, 0.00, 288.60),
(78, 1, 2, 27.75, 0.00, 0.00, 0.00, 55.50),
(78, 60, 3, 51.80, 0.00, 0.00, 0.00, 155.40),
(79, 2, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(79, 61, 1, 64.75, 0.00, 0.00, 0.00, 64.75),
(80, 3, 1, 53.65, 0.00, 0.00, 0.00, 53.65),
(80, 62, 2, 77.70, 0.00, 0.00, 0.00, 155.40),
(81, 4, 1, 66.60, 0.00, 0.00, 0.00, 66.60),
(81, 63, 3, 90.65, 0.00, 0.00, 0.00, 271.95),
(82, 5, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(82, 64, 1, 103.60, 0.00, 0.00, 0.00, 103.60),
(83, 6, 2, 92.50, 0.00, 0.00, 0.00, 185.00),
(83, 65, 2, 116.55, 0.00, 0.00, 0.00, 233.10),
(84, 7, 2, 105.45, 0.00, 0.00, 0.00, 210.90),
(84, 66, 3, 129.50, 0.00, 0.00, 0.00, 388.50),
(85, 8, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(85, 67, 1, 142.45, 0.00, 0.00, 0.00, 142.45),
(86, 9, 1, 131.35, 0.00, 0.00, 0.00, 131.35),
(86, 68, 2, 155.40, 0.00, 0.00, 0.00, 310.80),
(87, 10, 1, 144.30, 0.00, 0.00, 0.00, 144.30),
(87, 69, 3, 168.35, 0.00, 0.00, 0.00, 505.05),
(88, 11, 2, 157.25, 0.00, 0.00, 0.00, 314.50),
(88, 70, 1, 33.30, 0.00, 0.00, 0.00, 33.30),
(89, 12, 2, 170.20, 0.00, 0.00, 0.00, 340.40),
(89, 71, 2, 46.25, 0.00, 0.00, 0.00, 92.50),
(90, 13, 2, 35.15, 0.00, 0.00, 0.00, 70.30),
(90, 72, 3, 59.20, 0.00, 0.00, 0.00, 177.60),
(91, 14, 1, 48.10, 0.00, 0.00, 0.00, 48.10),
(91, 73, 1, 72.15, 0.00, 0.00, 0.00, 72.15),
(92, 15, 1, 61.05, 0.00, 0.00, 0.00, 61.05),
(92, 74, 2, 85.10, 0.00, 0.00, 0.00, 170.20),
(93, 16, 1, 74.00, 0.00, 0.00, 0.00, 74.00),
(93, 75, 3, 98.05, 0.00, 0.00, 0.00, 294.15),
(94, 17, 2, 86.95, 0.00, 0.00, 0.00, 173.90),
(94, 76, 1, 111.00, 0.00, 0.00, 0.00, 111.00),
(95, 18, 2, 99.90, 0.00, 0.00, 0.00, 199.80),
(95, 77, 2, 123.95, 0.00, 0.00, 0.00, 247.90),
(96, 19, 2, 112.85, 0.00, 0.00, 0.00, 225.70),
(96, 78, 3, 136.90, 0.00, 0.00, 0.00, 410.70),
(97, 20, 1, 125.80, 0.00, 0.00, 0.00, 125.80),
(97, 79, 1, 149.85, 0.00, 0.00, 0.00, 149.85),
(98, 21, 1, 138.75, 0.00, 0.00, 0.00, 138.75),
(98, 80, 2, 162.80, 0.00, 0.00, 0.00, 325.60),
(99, 22, 1, 151.70, 0.00, 0.00, 0.00, 151.70),
(99, 81, 3, 27.75, 0.00, 0.00, 0.00, 83.25),
(100, 23, 2, 164.65, 0.00, 0.00, 0.00, 329.30),
(100, 82, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(101, 24, 2, 29.60, 0.00, 0.00, 0.00, 59.20),
(101, 83, 2, 53.65, 0.00, 0.00, 0.00, 107.30),
(102, 25, 2, 42.55, 0.00, 0.00, 0.00, 85.10),
(102, 84, 3, 66.60, 0.00, 0.00, 0.00, 199.80),
(103, 26, 1, 55.50, 0.00, 0.00, 0.00, 55.50),
(103, 85, 1, 79.55, 0.00, 0.00, 0.00, 79.55),
(104, 27, 1, 68.45, 0.00, 0.00, 0.00, 68.45),
(104, 86, 2, 92.50, 0.00, 0.00, 0.00, 185.00),
(105, 28, 1, 81.40, 0.00, 0.00, 0.00, 81.40),
(105, 87, 3, 105.45, 0.00, 0.00, 0.00, 316.35),
(106, 29, 2, 94.35, 0.00, 0.00, 0.00, 188.70),
(106, 88, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(107, 30, 2, 107.30, 0.00, 0.00, 0.00, 214.60),
(107, 89, 2, 131.35, 0.00, 0.00, 0.00, 262.70),
(108, 31, 2, 120.25, 0.00, 0.00, 0.00, 240.50),
(108, 90, 3, 144.30, 0.00, 0.00, 0.00, 432.90),
(109, 1, 1, 27.75, 0.00, 0.00, 0.00, 27.75),
(109, 32, 1, 133.20, 0.00, 0.00, 0.00, 133.20),
(110, 2, 2, 40.70, 0.00, 0.00, 0.00, 81.40),
(110, 33, 1, 146.15, 0.00, 0.00, 0.00, 146.15),
(111, 3, 3, 53.65, 0.00, 0.00, 0.00, 160.95),
(111, 34, 1, 159.10, 0.00, 0.00, 0.00, 159.10),
(112, 4, 1, 66.60, 0.00, 0.00, 0.00, 66.60),
(112, 35, 2, 172.05, 0.00, 0.00, 0.00, 344.10),
(113, 5, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(113, 36, 2, 37.00, 0.00, 0.00, 0.00, 74.00),
(114, 6, 3, 92.50, 0.00, 0.00, 0.00, 277.50),
(114, 37, 2, 49.95, 0.00, 0.00, 0.00, 99.90),
(115, 7, 1, 105.45, 0.00, 0.00, 0.00, 105.45),
(115, 38, 1, 62.90, 0.00, 0.00, 0.00, 62.90),
(116, 8, 2, 118.40, 0.00, 0.00, 0.00, 236.80),
(116, 39, 1, 75.85, 0.00, 0.00, 0.00, 75.85),
(117, 9, 3, 131.35, 0.00, 0.00, 0.00, 394.05),
(117, 40, 1, 88.80, 0.00, 0.00, 0.00, 88.80),
(118, 10, 1, 144.30, 0.00, 0.00, 0.00, 144.30),
(118, 41, 2, 101.75, 0.00, 0.00, 0.00, 203.50),
(119, 11, 2, 157.25, 0.00, 0.00, 0.00, 314.50),
(119, 42, 2, 114.70, 0.00, 0.00, 0.00, 229.40),
(120, 12, 3, 170.20, 0.00, 0.00, 0.00, 510.60),
(120, 43, 2, 127.65, 0.00, 0.00, 0.00, 255.30),
(121, 13, 1, 35.15, 0.00, 0.00, 0.00, 35.15),
(121, 44, 1, 140.60, 0.00, 0.00, 0.00, 140.60),
(122, 14, 2, 48.10, 0.00, 0.00, 0.00, 96.20),
(122, 45, 1, 153.55, 0.00, 0.00, 0.00, 153.55),
(123, 15, 3, 61.05, 0.00, 0.00, 0.00, 183.15),
(123, 46, 1, 166.50, 0.00, 0.00, 0.00, 166.50),
(124, 16, 1, 74.00, 0.00, 0.00, 0.00, 74.00),
(124, 47, 2, 31.45, 0.00, 0.00, 0.00, 62.90),
(125, 17, 2, 86.95, 0.00, 0.00, 0.00, 173.90),
(125, 48, 2, 44.40, 0.00, 0.00, 0.00, 88.80),
(126, 18, 3, 99.90, 0.00, 0.00, 0.00, 299.70),
(126, 49, 2, 57.35, 0.00, 0.00, 0.00, 114.70),
(127, 19, 1, 112.85, 0.00, 0.00, 0.00, 112.85),
(127, 50, 1, 70.30, 0.00, 0.00, 0.00, 70.30),
(128, 20, 2, 125.80, 0.00, 0.00, 0.00, 251.60),
(128, 51, 1, 83.25, 0.00, 0.00, 0.00, 83.25),
(129, 21, 3, 138.75, 0.00, 0.00, 0.00, 416.25),
(129, 52, 1, 96.20, 0.00, 0.00, 0.00, 96.20),
(130, 22, 1, 151.70, 0.00, 0.00, 0.00, 151.70),
(130, 53, 2, 109.15, 0.00, 0.00, 0.00, 218.30),
(131, 23, 2, 164.65, 0.00, 0.00, 0.00, 329.30),
(131, 54, 2, 122.10, 0.00, 0.00, 0.00, 244.20),
(132, 24, 3, 29.60, 0.00, 0.00, 0.00, 88.80),
(132, 55, 2, 135.05, 0.00, 0.00, 0.00, 270.10),
(133, 25, 1, 42.55, 0.00, 0.00, 0.00, 42.55),
(133, 56, 1, 148.00, 0.00, 0.00, 0.00, 148.00),
(134, 26, 2, 55.50, 0.00, 0.00, 0.00, 111.00),
(134, 57, 1, 160.95, 0.00, 0.00, 0.00, 160.95),
(135, 27, 3, 68.45, 0.00, 0.00, 0.00, 205.35),
(135, 58, 1, 173.90, 0.00, 0.00, 0.00, 173.90),
(136, 28, 1, 81.40, 0.00, 0.00, 0.00, 81.40),
(136, 59, 2, 38.85, 0.00, 0.00, 0.00, 77.70),
(137, 29, 2, 94.35, 0.00, 0.00, 0.00, 188.70),
(137, 60, 2, 51.80, 0.00, 0.00, 0.00, 103.60),
(138, 30, 3, 107.30, 0.00, 0.00, 0.00, 321.90),
(138, 61, 2, 64.75, 0.00, 0.00, 0.00, 129.50),
(139, 31, 1, 120.25, 0.00, 0.00, 0.00, 120.25),
(139, 62, 1, 77.70, 0.00, 0.00, 0.00, 77.70),
(140, 32, 2, 133.20, 0.00, 0.00, 0.00, 266.40),
(140, 63, 1, 90.65, 0.00, 0.00, 0.00, 90.65),
(141, 33, 3, 146.15, 0.00, 0.00, 0.00, 438.45),
(141, 64, 1, 103.60, 0.00, 0.00, 0.00, 103.60),
(142, 34, 1, 159.10, 0.00, 0.00, 0.00, 159.10),
(142, 65, 2, 116.55, 0.00, 0.00, 0.00, 233.10),
(143, 35, 2, 172.05, 0.00, 0.00, 0.00, 344.10),
(143, 66, 2, 129.50, 0.00, 0.00, 0.00, 259.00),
(144, 36, 3, 37.00, 0.00, 0.00, 0.00, 111.00),
(144, 67, 2, 142.45, 0.00, 0.00, 0.00, 284.90),
(145, 37, 1, 49.95, 0.00, 0.00, 0.00, 49.95),
(145, 68, 1, 155.40, 0.00, 0.00, 0.00, 155.40),
(146, 38, 2, 62.90, 0.00, 0.00, 0.00, 125.80),
(146, 69, 1, 168.35, 0.00, 0.00, 0.00, 168.35),
(147, 39, 3, 75.85, 0.00, 0.00, 0.00, 227.55),
(147, 70, 1, 33.30, 0.00, 0.00, 0.00, 33.30),
(148, 40, 1, 88.80, 0.00, 0.00, 0.00, 88.80),
(148, 71, 2, 46.25, 0.00, 0.00, 0.00, 92.50),
(149, 41, 2, 101.75, 0.00, 0.00, 0.00, 203.50),
(149, 72, 2, 59.20, 0.00, 0.00, 0.00, 118.40),
(150, 42, 3, 114.70, 0.00, 0.00, 0.00, 344.10),
(150, 73, 2, 72.15, 0.00, 0.00, 0.00, 144.30),
(151, 43, 1, 127.65, 0.00, 0.00, 0.00, 127.65),
(151, 74, 1, 85.10, 0.00, 0.00, 0.00, 85.10),
(152, 44, 2, 140.60, 0.00, 0.00, 0.00, 281.20),
(152, 75, 1, 98.05, 0.00, 0.00, 0.00, 98.05),
(153, 45, 3, 153.55, 0.00, 0.00, 0.00, 460.65),
(153, 76, 1, 111.00, 0.00, 0.00, 0.00, 111.00),
(154, 46, 1, 166.50, 0.00, 0.00, 0.00, 166.50),
(154, 77, 2, 123.95, 0.00, 0.00, 0.00, 247.90),
(155, 47, 2, 31.45, 0.00, 0.00, 0.00, 62.90),
(155, 78, 2, 136.90, 0.00, 0.00, 0.00, 273.80),
(156, 48, 3, 44.40, 0.00, 0.00, 0.00, 133.20),
(156, 79, 2, 149.85, 0.00, 0.00, 0.00, 299.70),
(157, 49, 1, 57.35, 0.00, 0.00, 0.00, 57.35),
(157, 80, 1, 162.80, 0.00, 0.00, 0.00, 162.80),
(158, 50, 2, 70.30, 0.00, 0.00, 0.00, 140.60),
(158, 81, 1, 27.75, 0.00, 0.00, 0.00, 27.75),
(159, 51, 3, 83.25, 0.00, 0.00, 0.00, 249.75),
(159, 82, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(160, 52, 1, 96.20, 0.00, 0.00, 0.00, 96.20),
(160, 83, 2, 53.65, 0.00, 0.00, 0.00, 107.30),
(161, 53, 2, 109.15, 0.00, 0.00, 0.00, 218.30),
(161, 84, 2, 66.60, 0.00, 0.00, 0.00, 133.20),
(162, 54, 3, 122.10, 0.00, 0.00, 0.00, 366.30),
(162, 85, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(163, 55, 1, 135.05, 0.00, 0.00, 0.00, 135.05),
(163, 86, 1, 92.50, 0.00, 0.00, 0.00, 92.50),
(164, 56, 2, 148.00, 0.00, 0.00, 0.00, 296.00),
(164, 87, 1, 105.45, 0.00, 0.00, 0.00, 105.45),
(165, 57, 3, 160.95, 0.00, 0.00, 0.00, 482.85),
(165, 88, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(166, 58, 1, 173.90, 0.00, 0.00, 0.00, 173.90),
(166, 89, 2, 131.35, 0.00, 0.00, 0.00, 262.70),
(167, 59, 2, 38.85, 0.00, 0.00, 0.00, 77.70),
(167, 90, 2, 144.30, 0.00, 0.00, 0.00, 288.60),
(168, 1, 2, 27.75, 0.00, 0.00, 0.00, 55.50),
(168, 60, 3, 51.80, 0.00, 0.00, 0.00, 155.40),
(169, 2, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(169, 61, 1, 64.75, 0.00, 0.00, 0.00, 64.75),
(170, 3, 1, 53.65, 0.00, 0.00, 0.00, 53.65),
(170, 62, 2, 77.70, 0.00, 0.00, 0.00, 155.40),
(171, 4, 1, 66.60, 0.00, 0.00, 0.00, 66.60),
(171, 63, 3, 90.65, 0.00, 0.00, 0.00, 271.95),
(172, 5, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(172, 64, 1, 103.60, 0.00, 0.00, 0.00, 103.60),
(173, 6, 2, 92.50, 0.00, 0.00, 0.00, 185.00),
(173, 65, 2, 116.55, 0.00, 0.00, 0.00, 233.10),
(174, 7, 2, 105.45, 0.00, 0.00, 0.00, 210.90),
(174, 66, 3, 129.50, 0.00, 0.00, 0.00, 388.50),
(175, 8, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(175, 67, 1, 142.45, 0.00, 0.00, 0.00, 142.45),
(176, 9, 1, 131.35, 0.00, 0.00, 0.00, 131.35),
(176, 68, 2, 155.40, 0.00, 0.00, 0.00, 310.80),
(177, 10, 1, 144.30, 0.00, 0.00, 0.00, 144.30),
(177, 69, 3, 168.35, 0.00, 0.00, 0.00, 505.05),
(178, 11, 2, 157.25, 0.00, 0.00, 0.00, 314.50),
(178, 70, 1, 33.30, 0.00, 0.00, 0.00, 33.30),
(179, 12, 2, 170.20, 0.00, 0.00, 0.00, 340.40),
(179, 71, 2, 46.25, 0.00, 0.00, 0.00, 92.50),
(180, 13, 2, 35.15, 0.00, 0.00, 0.00, 70.30),
(180, 72, 3, 59.20, 0.00, 0.00, 0.00, 177.60),
(181, 14, 1, 48.10, 0.00, 0.00, 0.00, 48.10),
(181, 73, 1, 72.15, 0.00, 0.00, 0.00, 72.15),
(182, 15, 1, 61.05, 0.00, 0.00, 0.00, 61.05),
(182, 74, 2, 85.10, 0.00, 0.00, 0.00, 170.20),
(183, 16, 1, 74.00, 0.00, 0.00, 0.00, 74.00),
(183, 75, 3, 98.05, 0.00, 0.00, 0.00, 294.15),
(184, 17, 2, 86.95, 0.00, 0.00, 0.00, 173.90),
(184, 76, 1, 111.00, 0.00, 0.00, 0.00, 111.00),
(185, 18, 2, 99.90, 0.00, 0.00, 0.00, 199.80),
(185, 77, 2, 123.95, 0.00, 0.00, 0.00, 247.90),
(186, 19, 2, 112.85, 0.00, 0.00, 0.00, 225.70),
(186, 78, 3, 136.90, 0.00, 0.00, 0.00, 410.70),
(187, 20, 1, 125.80, 0.00, 0.00, 0.00, 125.80),
(187, 79, 1, 149.85, 0.00, 0.00, 0.00, 149.85),
(188, 21, 1, 138.75, 0.00, 0.00, 0.00, 138.75),
(188, 80, 2, 162.80, 0.00, 0.00, 0.00, 325.60),
(189, 22, 1, 151.70, 0.00, 0.00, 0.00, 151.70),
(189, 81, 3, 27.75, 0.00, 0.00, 0.00, 83.25),
(190, 23, 2, 164.65, 0.00, 0.00, 0.00, 329.30),
(190, 82, 1, 40.70, 0.00, 0.00, 0.00, 40.70),
(191, 24, 2, 29.60, 0.00, 0.00, 0.00, 59.20),
(191, 83, 2, 53.65, 0.00, 0.00, 0.00, 107.30),
(192, 25, 2, 42.55, 0.00, 0.00, 0.00, 85.10),
(192, 84, 3, 66.60, 0.00, 0.00, 0.00, 199.80),
(193, 26, 1, 55.50, 0.00, 0.00, 0.00, 55.50),
(193, 85, 1, 79.55, 0.00, 0.00, 0.00, 79.55),
(194, 27, 1, 68.45, 0.00, 0.00, 0.00, 68.45),
(194, 86, 2, 92.50, 0.00, 0.00, 0.00, 185.00),
(195, 28, 1, 81.40, 0.00, 0.00, 0.00, 81.40),
(195, 87, 3, 105.45, 0.00, 0.00, 0.00, 316.35),
(196, 29, 2, 94.35, 0.00, 0.00, 0.00, 188.70),
(196, 88, 1, 118.40, 0.00, 0.00, 0.00, 118.40),
(197, 30, 2, 107.30, 0.00, 0.00, 0.00, 214.60),
(197, 89, 2, 131.35, 0.00, 0.00, 0.00, 262.70),
(198, 31, 2, 120.25, 0.00, 0.00, 0.00, 240.50),
(198, 90, 3, 144.30, 0.00, 0.00, 0.00, 432.90),
(199, 1, 1, 27.75, 0.00, 0.00, 0.00, 27.75),
(199, 32, 1, 133.20, 0.00, 0.00, 0.00, 133.20),
(200, 2, 2, 40.70, 0.00, 0.00, 0.00, 81.40),
(200, 33, 1, 146.15, 0.00, 0.00, 0.00, 146.15),
(201, 3, 3, 53.65, 0.00, 0.00, 0.00, 160.95),
(201, 34, 1, 159.10, 0.00, 0.00, 0.00, 159.10),
(202, 4, 1, 66.60, 0.00, 0.00, 0.00, 66.60),
(202, 35, 2, 172.05, 0.00, 0.00, 0.00, 344.10),
(203, 5, 2, 79.55, 0.00, 0.00, 0.00, 159.10),
(203, 36, 2, 37.00, 0.00, 0.00, 0.00, 74.00),
(204, 6, 3, 92.50, 0.00, 0.00, 0.00, 277.50),
(204, 37, 2, 49.95, 0.00, 0.00, 0.00, 99.90),
(205, 7, 1, 105.45, 0.00, 0.00, 0.00, 105.45),
(205, 38, 1, 62.90, 0.00, 0.00, 0.00, 62.90),
(206, 8, 2, 118.40, 0.00, 0.00, 0.00, 236.80),
(206, 39, 1, 75.85, 0.00, 0.00, 0.00, 75.85),
(207, 9, 3, 131.35, 0.00, 0.00, 0.00, 394.05),
(207, 40, 1, 88.80, 0.00, 0.00, 0.00, 88.80),
(208, 10, 1, 144.30, 0.00, 0.00, 0.00, 144.30),
(208, 41, 2, 101.75, 0.00, 0.00, 0.00, 203.50),
(209, 11, 2, 157.25, 0.00, 0.00, 0.00, 314.50),
(209, 42, 2, 114.70, 0.00, 0.00, 0.00, 229.40),
(210, 12, 3, 170.20, 0.00, 0.00, 0.00, 510.60),
(210, 43, 2, 127.65, 0.00, 0.00, 0.00, 255.30),
(211, 13, 1, 35.15, 0.00, 0.00, 0.00, 35.15),
(211, 44, 1, 140.60, 0.00, 0.00, 0.00, 140.60),
(212, 14, 2, 48.10, 0.00, 0.00, 0.00, 96.20),
(212, 45, 1, 153.55, 0.00, 0.00, 0.00, 153.55),
(213, 15, 3, 61.05, 0.00, 0.00, 0.00, 183.15),
(213, 46, 1, 166.50, 0.00, 0.00, 0.00, 166.50),
(214, 16, 1, 74.00, 0.00, 0.00, 0.00, 74.00),
(214, 47, 2, 31.45, 0.00, 0.00, 0.00, 62.90),
(215, 17, 2, 86.95, 0.00, 0.00, 0.00, 173.90),
(215, 48, 2, 44.40, 0.00, 0.00, 0.00, 88.80),
(216, 18, 3, 99.90, 0.00, 0.00, 0.00, 299.70),
(216, 49, 2, 57.35, 0.00, 0.00, 0.00, 114.70),
(217, 19, 1, 112.85, 0.00, 0.00, 0.00, 112.85),
(217, 50, 1, 70.30, 0.00, 0.00, 0.00, 70.30),
(218, 20, 2, 125.80, 0.00, 0.00, 0.00, 251.60),
(218, 51, 1, 83.25, 0.00, 0.00, 0.00, 83.25);

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
  `forma_pagamento` enum('DINHEIRO','PIX','CARTAO_DEBITO','CARTAO_CREDITO') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `data_movimento` date NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'Camiseta Básica Preto P - Ref 001', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:03:45', NULL, 0),
(2, 'Camiseta Polo Preto M - Ref 002', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:03:45', NULL, 1),
(3, 'Camisa Social Preto G - Ref 003', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:03:45', NULL, 1),
(4, 'Calça Jeans Preto GG - Ref 004', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:03:45', NULL, 1),
(5, 'Calça Sarja Preto Único - Ref 005', 'Produto novo para pronta entrega', 'Vestuário', 43.00, 79.55, 0, '2026-11-08 19:03:45', NULL, 1),
(6, 'Bermuda Jeans Preto P - Ref 006', 'Produto novo para pronta entrega', 'Vestuário', 50.00, 92.50, 0, '2026-11-08 19:03:45', NULL, 1),
(7, 'Bermuda Moletom Preto M - Ref 007', 'Produto novo para pronta entrega', 'Vestuário', 57.00, 105.45, 0, '2026-11-08 19:03:45', NULL, 1),
(8, 'Jaqueta Corta-Vento Preto G - Ref 008', 'Produto novo para pronta entrega', 'Vestuário', 64.00, 118.40, 0, '2026-11-08 19:03:45', NULL, 1),
(9, 'Moletom Canguru Preto GG - Ref 009', 'Produto novo para pronta entrega', 'Vestuário', 71.00, 131.35, 0, '2026-11-08 19:03:45', NULL, 1),
(10, 'Vestido Midi Preto Único - Ref 010', 'Produto novo para pronta entrega', 'Vestuário', 78.00, 144.30, 0, '2026-11-08 19:03:45', NULL, 1),
(11, 'Blusa Tricot Preto P - Ref 011', 'Produto novo para pronta entrega', 'Vestuário', 85.00, 157.25, 0, '2026-11-08 19:03:45', NULL, 1),
(12, 'Saia Jeans Preto M - Ref 012', 'Produto novo para pronta entrega', 'Vestuário', 92.00, 170.20, 0, '2026-11-08 19:03:45', NULL, 1),
(13, 'Tênis Casual Preto G - Ref 013', 'Produto novo para pronta entrega', 'Calçados', 19.00, 35.15, 0, '2026-11-08 19:03:45', NULL, 1),
(14, 'Tênis Esportivo Preto GG - Ref 014', 'Produto novo para pronta entrega', 'Calçados', 26.00, 48.10, 0, '2026-11-08 19:03:45', NULL, 1),
(15, 'Chinelo Slide Preto Único - Ref 015', 'Produto novo para pronta entrega', 'Calçados', 33.00, 61.05, 0, '2026-11-08 19:03:45', NULL, 1),
(16, 'Sandália Rasteira Preto P - Ref 016', 'Produto novo para pronta entrega', 'Calçados', 40.00, 74.00, 0, '2026-11-08 19:03:45', NULL, 1),
(17, 'Boné Aba Curva Preto M - Ref 017', 'Produto novo para pronta entrega', 'Acessórios', 47.00, 86.95, 0, '2026-11-08 19:03:45', NULL, 1),
(18, 'Cinto Sintético Preto G - Ref 018', 'Produto novo para pronta entrega', 'Acessórios', 54.00, 99.90, 0, '2026-11-08 19:03:45', NULL, 0),
(19, 'Camiseta Básica Branco GG - Ref 019', 'Produto novo para pronta entrega', 'Vestuário', 61.00, 112.85, 0, '2026-11-08 19:03:45', NULL, 1),
(20, 'Camiseta Polo Branco Único - Ref 020', 'Produto novo para pronta entrega', 'Vestuário', 68.00, 125.80, 0, '2026-11-08 19:03:45', NULL, 1),
(21, 'Camisa Social Branco P - Ref 021', 'Produto novo para pronta entrega', 'Vestuário', 75.00, 138.75, 0, '2026-11-08 19:03:45', NULL, 1),
(22, 'Calça Jeans Branco M - Ref 022', 'Produto novo para pronta entrega', 'Vestuário', 82.00, 151.70, 0, '2026-11-08 19:03:45', NULL, 1),
(23, 'Calça Sarja Branco G - Ref 023', 'Produto novo para pronta entrega', 'Vestuário', 89.00, 164.65, 0, '2026-11-08 19:03:45', NULL, 1),
(24, 'Bermuda Jeans Branco GG - Ref 024', 'Produto novo para pronta entrega', 'Vestuário', 16.00, 29.60, 0, '2026-11-08 19:03:45', NULL, 1),
(25, 'Bermuda Moletom Branco Único - Ref 025', 'Produto novo para pronta entrega', 'Vestuário', 23.00, 42.55, 0, '2026-11-08 19:03:45', NULL, 1),
(26, 'Jaqueta Corta-Vento Branco P - Ref 026', 'Produto novo para pronta entrega', 'Vestuário', 30.00, 55.50, 0, '2026-11-08 19:03:45', NULL, 1),
(27, 'Moletom Canguru Branco M - Ref 027', 'Produto novo para pronta entrega', 'Vestuário', 37.00, 68.45, 0, '2026-11-08 19:03:45', NULL, 1),
(28, 'Vestido Midi Branco G - Ref 028', 'Produto novo para pronta entrega', 'Vestuário', 44.00, 81.40, 0, '2026-11-08 19:03:45', NULL, 1),
(29, 'Blusa Tricot Branco GG - Ref 029', 'Produto novo para pronta entrega', 'Vestuário', 51.00, 94.35, 0, '2026-11-08 19:03:45', NULL, 1),
(30, 'Saia Jeans Branco Único - Ref 030', 'Produto novo para pronta entrega', 'Vestuário', 58.00, 107.30, 0, '2026-11-08 19:03:45', NULL, 1),
(31, 'Tênis Casual Branco P - Ref 031', 'Produto novo para pronta entrega', 'Calçados', 65.00, 120.25, 0, '2026-11-08 19:03:45', NULL, 1),
(32, 'Tênis Esportivo Branco M - Ref 032', 'Produto novo para pronta entrega', 'Calçados', 72.00, 133.20, 0, '2026-11-08 19:03:45', NULL, 1),
(33, 'Chinelo Slide Branco G - Ref 033', 'Produto novo para pronta entrega', 'Calçados', 79.00, 146.15, 0, '2026-11-08 19:03:45', NULL, 1),
(34, 'Sandália Rasteira Branco GG - Ref 034', 'Produto novo para pronta entrega', 'Calçados', 86.00, 159.10, 0, '2026-11-08 19:03:45', NULL, 1),
(35, 'Boné Aba Curva Branco Único - Ref 035', 'Produto novo para pronta entrega', 'Acessórios', 93.00, 172.05, 0, '2026-11-08 19:03:45', NULL, 0),
(36, 'Cinto Sintético Branco P - Ref 036', 'Produto novo para pronta entrega', 'Acessórios', 20.00, 37.00, 0, '2026-11-08 19:03:45', NULL, 1),
(37, 'Camiseta Básica Azul M - Ref 037', 'Produto novo para pronta entrega', 'Vestuário', 27.00, 49.95, 0, '2026-11-08 19:03:45', NULL, 1),
(38, 'Camiseta Polo Azul G - Ref 038', 'Produto novo para pronta entrega', 'Vestuário', 34.00, 62.90, 0, '2026-11-08 19:03:45', NULL, 1),
(39, 'Camisa Social Azul GG - Ref 039', 'Produto novo para pronta entrega', 'Vestuário', 41.00, 75.85, 0, '2026-11-08 19:03:45', NULL, 1),
(40, 'Calça Jeans Azul Único - Ref 040', 'Produto novo para pronta entrega', 'Vestuário', 48.00, 88.80, 0, '2026-11-08 19:03:45', NULL, 1),
(41, 'Calça Sarja Azul P - Ref 041', 'Produto novo para pronta entrega', 'Vestuário', 55.00, 101.75, 0, '2026-11-08 19:03:45', NULL, 1),
(42, 'Bermuda Jeans Azul M - Ref 042', 'Produto novo para pronta entrega', 'Vestuário', 62.00, 114.70, 0, '2026-11-08 19:03:45', NULL, 1),
(43, 'Bermuda Moletom Azul G - Ref 043', 'Produto novo para pronta entrega', 'Vestuário', 69.00, 127.65, 0, '2026-11-08 19:03:45', NULL, 1),
(44, 'Jaqueta Corta-Vento Azul GG - Ref 044', 'Produto novo para pronta entrega', 'Vestuário', 76.00, 140.60, 0, '2026-11-08 19:03:45', NULL, 1),
(45, 'Moletom Canguru Azul Único - Ref 045', 'Produto novo para pronta entrega', 'Vestuário', 83.00, 153.55, 0, '2026-11-08 19:03:45', NULL, 1),
(46, 'Vestido Midi Azul P - Ref 046', 'Produto novo para pronta entrega', 'Vestuário', 90.00, 166.50, 0, '2026-11-08 19:03:45', NULL, 1),
(47, 'Blusa Tricot Azul M - Ref 047', 'Produto novo para pronta entrega', 'Vestuário', 17.00, 31.45, 0, '2026-11-08 19:03:45', NULL, 1),
(48, 'Saia Jeans Azul G - Ref 048', 'Produto novo para pronta entrega', 'Vestuário', 24.00, 44.40, 0, '2026-11-08 19:03:45', NULL, 1),
(49, 'Tênis Casual Azul GG - Ref 049', 'Produto novo para pronta entrega', 'Calçados', 31.00, 57.35, 0, '2026-11-08 19:03:45', NULL, 1),
(50, 'Tênis Esportivo Azul Único - Ref 050', 'Produto novo para pronta entrega', 'Calçados', 38.00, 70.30, 0, '2026-11-08 19:03:45', NULL, 1),
(51, 'Chinelo Slide Azul P - Ref 051', 'Produto novo para pronta entrega', 'Calçados', 45.00, 83.25, 0, '2026-11-08 19:03:45', NULL, 1),
(52, 'Sandália Rasteira Azul M - Ref 052', 'Produto novo para pronta entrega', 'Calçados', 52.00, 96.20, 0, '2026-11-08 19:03:45', NULL, 0),
(53, 'Boné Aba Curva Azul G - Ref 053', 'Produto novo para pronta entrega', 'Acessórios', 59.00, 109.15, 0, '2026-11-08 19:03:46', NULL, 1),
(54, 'Cinto Sintético Azul GG - Ref 054', 'Produto novo para pronta entrega', 'Acessórios', 66.00, 122.10, 0, '2026-11-08 19:03:46', NULL, 1),
(55, 'Camiseta Básica Cinza Único - Ref 055', 'Produto novo para pronta entrega', 'Vestuário', 73.00, 135.05, 0, '2026-11-08 19:03:46', NULL, 1),
(56, 'Camiseta Polo Cinza P - Ref 056', 'Produto novo para pronta entrega', 'Vestuário', 80.00, 148.00, 0, '2026-11-08 19:03:46', NULL, 1),
(57, 'Camisa Social Cinza M - Ref 057', 'Produto novo para pronta entrega', 'Vestuário', 87.00, 160.95, 0, '2026-11-08 19:03:46', NULL, 1),
(58, 'Calça Jeans Cinza G - Ref 058', 'Produto novo para pronta entrega', 'Vestuário', 94.00, 173.90, 0, '2026-11-08 19:03:46', NULL, 1),
(59, 'Calça Sarja Cinza GG - Ref 059', 'Produto novo para pronta entrega', 'Vestuário', 21.00, 38.85, 0, '2026-11-08 19:03:46', NULL, 1),
(60, 'Bermuda Jeans Cinza Único - Ref 060', 'Produto novo para pronta entrega', 'Vestuário', 28.00, 51.80, 0, '2026-11-08 19:03:46', NULL, 1),
(61, 'Bermuda Moletom Cinza P - Ref 061', 'Produto novo para pronta entrega', 'Vestuário', 35.00, 64.75, 0, '2026-11-08 19:03:46', NULL, 1),
(62, 'Jaqueta Corta-Vento Cinza M - Ref 062', 'Produto novo para pronta entrega', 'Vestuário', 42.00, 77.70, 0, '2026-11-08 19:03:46', NULL, 1),
(63, 'Moletom Canguru Cinza G - Ref 063', 'Produto novo para pronta entrega', 'Vestuário', 49.00, 90.65, 0, '2026-11-08 19:03:46', NULL, 1),
(64, 'Vestido Midi Cinza GG - Ref 064', 'Produto novo para pronta entrega', 'Vestuário', 56.00, 103.60, 0, '2026-11-08 19:03:46', NULL, 1),
(65, 'Blusa Tricot Cinza Único - Ref 065', 'Produto novo para pronta entrega', 'Vestuário', 63.00, 116.55, 0, '2026-11-08 19:03:46', NULL, 1),
(66, 'Saia Jeans Cinza P - Ref 066', 'Produto novo para pronta entrega', 'Vestuário', 70.00, 129.50, 0, '2026-11-08 19:03:46', NULL, 1),
(67, 'Tênis Casual Cinza M - Ref 067', 'Produto novo para pronta entrega', 'Calçados', 77.00, 142.45, 0, '2026-11-08 19:03:46', NULL, 1),
(68, 'Tênis Esportivo Cinza G - Ref 068', 'Produto novo para pronta entrega', 'Calçados', 84.00, 155.40, 0, '2026-11-08 19:03:46', NULL, 1),
(69, 'Chinelo Slide Cinza GG - Ref 069', 'Produto novo para pronta entrega', 'Calçados', 91.00, 168.35, 0, '2026-11-08 19:03:46', NULL, 0),
(70, 'Sandália Rasteira Cinza Único - Ref 070', 'Produto novo para pronta entrega', 'Calçados', 18.00, 33.30, 0, '2026-11-08 19:03:46', NULL, 1),
(71, 'Boné Aba Curva Cinza P - Ref 071', 'Produto novo para pronta entrega', 'Acessórios', 25.00, 46.25, 0, '2026-11-08 19:03:46', NULL, 1),
(72, 'Cinto Sintético Cinza M - Ref 072', 'Produto novo para pronta entrega', 'Acessórios', 32.00, 59.20, 0, '2026-11-08 19:03:46', NULL, 1),
(73, 'Camiseta Básica Bege G - Ref 073', 'Produto novo para pronta entrega', 'Vestuário', 39.00, 72.15, 0, '2026-11-08 19:03:46', NULL, 1),
(74, 'Camiseta Polo Bege GG - Ref 074', 'Produto novo para pronta entrega', 'Vestuário', 46.00, 85.10, 0, '2026-11-08 19:03:46', NULL, 1),
(75, 'Camisa Social Bege Único - Ref 075', 'Produto novo para pronta entrega', 'Vestuário', 53.00, 98.05, 0, '2026-11-08 19:03:46', NULL, 1),
(76, 'Calça Jeans Bege P - Ref 076', 'Produto novo para pronta entrega', 'Vestuário', 60.00, 111.00, 0, '2026-11-08 19:03:46', NULL, 1),
(77, 'Calça Sarja Bege M - Ref 077', 'Produto novo para pronta entrega', 'Vestuário', 67.00, 123.95, 0, '2026-11-08 19:03:46', NULL, 1),
(78, 'Bermuda Jeans Bege G - Ref 078', 'Produto novo para pronta entrega', 'Vestuário', 74.00, 136.90, 0, '2026-11-08 19:03:46', NULL, 1),
(79, 'Bermuda Moletom Bege GG - Ref 079', 'Produto novo para pronta entrega', 'Vestuário', 81.00, 149.85, 0, '2026-11-08 19:03:46', NULL, 1),
(80, 'Jaqueta Corta-Vento Bege Único - Ref 080', 'Produto novo para pronta entrega', 'Vestuário', 88.00, 162.80, 0, '2026-11-08 19:03:46', NULL, 1),
(81, 'Moletom Canguru Bege P - Ref 081', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:03:46', NULL, 1),
(82, 'Vestido Midi Bege M - Ref 082', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:03:46', NULL, 1),
(83, 'Blusa Tricot Bege G - Ref 083', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:03:46', NULL, 1),
(84, 'Saia Jeans Bege GG - Ref 084', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:03:46', NULL, 1),
(85, 'Tênis Casual Bege Único - Ref 085', 'Produto novo para pronta entrega', 'Calçados', 43.00, 79.55, 0, '2026-11-08 19:03:46', NULL, 1),
(86, 'Tênis Esportivo Bege P - Ref 086', 'Produto novo para pronta entrega', 'Calçados', 50.00, 92.50, 0, '2026-11-08 19:03:46', NULL, 0),
(87, 'Chinelo Slide Bege M - Ref 087', 'Produto novo para pronta entrega', 'Calçados', 57.00, 105.45, 0, '2026-11-08 19:03:46', NULL, 1),
(88, 'Sandália Rasteira Bege G - Ref 088', 'Produto novo para pronta entrega', 'Calçados', 64.00, 118.40, 0, '2026-11-08 19:03:46', NULL, 1),
(89, 'Boné Aba Curva Bege GG - Ref 089', 'Produto novo para pronta entrega', 'Acessórios', 71.00, 131.35, 0, '2026-11-08 19:03:46', NULL, 1),
(90, 'Cinto Sintético Bege Único - Ref 090', 'Produto novo para pronta entrega', 'Acessórios', 78.00, 144.30, 0, '2026-11-08 19:03:46', NULL, 1),
(91, 'Camiseta Básica Preto P - Ref 001', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:04:08', NULL, 0),
(92, 'Camiseta Polo Preto M - Ref 002', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:04:08', NULL, 1),
(93, 'Camisa Social Preto G - Ref 003', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:04:08', NULL, 1),
(94, 'Calça Jeans Preto GG - Ref 004', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:04:08', NULL, 1),
(95, 'Calça Sarja Preto Único - Ref 005', 'Produto novo para pronta entrega', 'Vestuário', 43.00, 79.55, 0, '2026-11-08 19:04:08', NULL, 1),
(96, 'Bermuda Jeans Preto P - Ref 006', 'Produto novo para pronta entrega', 'Vestuário', 50.00, 92.50, 0, '2026-11-08 19:04:08', NULL, 1),
(97, 'Bermuda Moletom Preto M - Ref 007', 'Produto novo para pronta entrega', 'Vestuário', 57.00, 105.45, 0, '2026-11-08 19:04:08', NULL, 1),
(98, 'Jaqueta Corta-Vento Preto G - Ref 008', 'Produto novo para pronta entrega', 'Vestuário', 64.00, 118.40, 0, '2026-11-08 19:04:08', NULL, 1),
(99, 'Moletom Canguru Preto GG - Ref 009', 'Produto novo para pronta entrega', 'Vestuário', 71.00, 131.35, 0, '2026-11-08 19:04:08', NULL, 1),
(100, 'Vestido Midi Preto Único - Ref 010', 'Produto novo para pronta entrega', 'Vestuário', 78.00, 144.30, 0, '2026-11-08 19:04:08', NULL, 1),
(101, 'Blusa Tricot Preto P - Ref 011', 'Produto novo para pronta entrega', 'Vestuário', 85.00, 157.25, 0, '2026-11-08 19:04:08', NULL, 1),
(102, 'Saia Jeans Preto M - Ref 012', 'Produto novo para pronta entrega', 'Vestuário', 92.00, 170.20, 0, '2026-11-08 19:04:08', NULL, 1),
(103, 'Tênis Casual Preto G - Ref 013', 'Produto novo para pronta entrega', 'Calçados', 19.00, 35.15, 0, '2026-11-08 19:04:08', NULL, 1),
(104, 'Tênis Esportivo Preto GG - Ref 014', 'Produto novo para pronta entrega', 'Calçados', 26.00, 48.10, 0, '2026-11-08 19:04:08', NULL, 1),
(105, 'Chinelo Slide Preto Único - Ref 015', 'Produto novo para pronta entrega', 'Calçados', 33.00, 61.05, 0, '2026-11-08 19:04:08', NULL, 1),
(106, 'Sandália Rasteira Preto P - Ref 016', 'Produto novo para pronta entrega', 'Calçados', 40.00, 74.00, 0, '2026-11-08 19:04:08', NULL, 1),
(107, 'Boné Aba Curva Preto M - Ref 017', 'Produto novo para pronta entrega', 'Acessórios', 47.00, 86.95, 0, '2026-11-08 19:04:08', NULL, 1),
(108, 'Cinto Sintético Preto G - Ref 018', 'Produto novo para pronta entrega', 'Acessórios', 54.00, 99.90, 0, '2026-11-08 19:04:08', NULL, 0),
(109, 'Camiseta Básica Branco GG - Ref 019', 'Produto novo para pronta entrega', 'Vestuário', 61.00, 112.85, 0, '2026-11-08 19:04:08', NULL, 1),
(110, 'Camiseta Polo Branco Único - Ref 020', 'Produto novo para pronta entrega', 'Vestuário', 68.00, 125.80, 0, '2026-11-08 19:04:08', NULL, 1),
(111, 'Camisa Social Branco P - Ref 021', 'Produto novo para pronta entrega', 'Vestuário', 75.00, 138.75, 0, '2026-11-08 19:04:08', NULL, 1),
(112, 'Calça Jeans Branco M - Ref 022', 'Produto novo para pronta entrega', 'Vestuário', 82.00, 151.70, 0, '2026-11-08 19:04:08', NULL, 1),
(113, 'Calça Sarja Branco G - Ref 023', 'Produto novo para pronta entrega', 'Vestuário', 89.00, 164.65, 0, '2026-11-08 19:04:08', NULL, 1),
(114, 'Bermuda Jeans Branco GG - Ref 024', 'Produto novo para pronta entrega', 'Vestuário', 16.00, 29.60, 0, '2026-11-08 19:04:08', NULL, 1),
(115, 'Bermuda Moletom Branco Único - Ref 025', 'Produto novo para pronta entrega', 'Vestuário', 23.00, 42.55, 0, '2026-11-08 19:04:08', NULL, 1),
(116, 'Jaqueta Corta-Vento Branco P - Ref 026', 'Produto novo para pronta entrega', 'Vestuário', 30.00, 55.50, 0, '2026-11-08 19:04:08', NULL, 1),
(117, 'Moletom Canguru Branco M - Ref 027', 'Produto novo para pronta entrega', 'Vestuário', 37.00, 68.45, 0, '2026-11-08 19:04:08', NULL, 1),
(118, 'Vestido Midi Branco G - Ref 028', 'Produto novo para pronta entrega', 'Vestuário', 44.00, 81.40, 0, '2026-11-08 19:04:08', NULL, 1),
(119, 'Blusa Tricot Branco GG - Ref 029', 'Produto novo para pronta entrega', 'Vestuário', 51.00, 94.35, 0, '2026-11-08 19:04:08', NULL, 1),
(120, 'Saia Jeans Branco Único - Ref 030', 'Produto novo para pronta entrega', 'Vestuário', 58.00, 107.30, 0, '2026-11-08 19:04:08', NULL, 1),
(121, 'Tênis Casual Branco P - Ref 031', 'Produto novo para pronta entrega', 'Calçados', 65.00, 120.25, 0, '2026-11-08 19:04:08', NULL, 1),
(122, 'Tênis Esportivo Branco M - Ref 032', 'Produto novo para pronta entrega', 'Calçados', 72.00, 133.20, 0, '2026-11-08 19:04:08', NULL, 1),
(123, 'Chinelo Slide Branco G - Ref 033', 'Produto novo para pronta entrega', 'Calçados', 79.00, 146.15, 0, '2026-11-08 19:04:08', NULL, 1),
(124, 'Sandália Rasteira Branco GG - Ref 034', 'Produto novo para pronta entrega', 'Calçados', 86.00, 159.10, 0, '2026-11-08 19:04:08', NULL, 1),
(125, 'Boné Aba Curva Branco Único - Ref 035', 'Produto novo para pronta entrega', 'Acessórios', 93.00, 172.05, 0, '2026-11-08 19:04:08', NULL, 0),
(126, 'Cinto Sintético Branco P - Ref 036', 'Produto novo para pronta entrega', 'Acessórios', 20.00, 37.00, 0, '2026-11-08 19:04:08', NULL, 1),
(127, 'Camiseta Básica Azul M - Ref 037', 'Produto novo para pronta entrega', 'Vestuário', 27.00, 49.95, 0, '2026-11-08 19:04:08', NULL, 1),
(128, 'Camiseta Polo Azul G - Ref 038', 'Produto novo para pronta entrega', 'Vestuário', 34.00, 62.90, 0, '2026-11-08 19:04:08', NULL, 1),
(129, 'Camisa Social Azul GG - Ref 039', 'Produto novo para pronta entrega', 'Vestuário', 41.00, 75.85, 0, '2026-11-08 19:04:08', NULL, 1),
(130, 'Calça Jeans Azul Único - Ref 040', 'Produto novo para pronta entrega', 'Vestuário', 48.00, 88.80, 0, '2026-11-08 19:04:08', NULL, 1),
(131, 'Calça Sarja Azul P - Ref 041', 'Produto novo para pronta entrega', 'Vestuário', 55.00, 101.75, 0, '2026-11-08 19:04:08', NULL, 1),
(132, 'Bermuda Jeans Azul M - Ref 042', 'Produto novo para pronta entrega', 'Vestuário', 62.00, 114.70, 0, '2026-11-08 19:04:08', NULL, 1),
(133, 'Bermuda Moletom Azul G - Ref 043', 'Produto novo para pronta entrega', 'Vestuário', 69.00, 127.65, 0, '2026-11-08 19:04:08', NULL, 1),
(134, 'Jaqueta Corta-Vento Azul GG - Ref 044', 'Produto novo para pronta entrega', 'Vestuário', 76.00, 140.60, 0, '2026-11-08 19:04:08', NULL, 1),
(135, 'Moletom Canguru Azul Único - Ref 045', 'Produto novo para pronta entrega', 'Vestuário', 83.00, 153.55, 0, '2026-11-08 19:04:08', NULL, 1),
(136, 'Vestido Midi Azul P - Ref 046', 'Produto novo para pronta entrega', 'Vestuário', 90.00, 166.50, 0, '2026-11-08 19:04:08', NULL, 1),
(137, 'Blusa Tricot Azul M - Ref 047', 'Produto novo para pronta entrega', 'Vestuário', 17.00, 31.45, 0, '2026-11-08 19:04:08', NULL, 1),
(138, 'Saia Jeans Azul G - Ref 048', 'Produto novo para pronta entrega', 'Vestuário', 24.00, 44.40, 0, '2026-11-08 19:04:08', NULL, 1),
(139, 'Tênis Casual Azul GG - Ref 049', 'Produto novo para pronta entrega', 'Calçados', 31.00, 57.35, 0, '2026-11-08 19:04:08', NULL, 1),
(140, 'Tênis Esportivo Azul Único - Ref 050', 'Produto novo para pronta entrega', 'Calçados', 38.00, 70.30, 0, '2026-11-08 19:04:08', NULL, 1),
(141, 'Chinelo Slide Azul P - Ref 051', 'Produto novo para pronta entrega', 'Calçados', 45.00, 83.25, 0, '2026-11-08 19:04:08', NULL, 1),
(142, 'Sandália Rasteira Azul M - Ref 052', 'Produto novo para pronta entrega', 'Calçados', 52.00, 96.20, 0, '2026-11-08 19:04:08', NULL, 0),
(143, 'Boné Aba Curva Azul G - Ref 053', 'Produto novo para pronta entrega', 'Acessórios', 59.00, 109.15, 0, '2026-11-08 19:04:08', NULL, 1),
(144, 'Cinto Sintético Azul GG - Ref 054', 'Produto novo para pronta entrega', 'Acessórios', 66.00, 122.10, 0, '2026-11-08 19:04:08', NULL, 1),
(145, 'Camiseta Básica Cinza Único - Ref 055', 'Produto novo para pronta entrega', 'Vestuário', 73.00, 135.05, 0, '2026-11-08 19:04:08', NULL, 1),
(146, 'Camiseta Polo Cinza P - Ref 056', 'Produto novo para pronta entrega', 'Vestuário', 80.00, 148.00, 0, '2026-11-08 19:04:08', NULL, 1),
(147, 'Camisa Social Cinza M - Ref 057', 'Produto novo para pronta entrega', 'Vestuário', 87.00, 160.95, 0, '2026-11-08 19:04:08', NULL, 1),
(148, 'Calça Jeans Cinza G - Ref 058', 'Produto novo para pronta entrega', 'Vestuário', 94.00, 173.90, 0, '2026-11-08 19:04:08', NULL, 1),
(149, 'Calça Sarja Cinza GG - Ref 059', 'Produto novo para pronta entrega', 'Vestuário', 21.00, 38.85, 0, '2026-11-08 19:04:08', NULL, 1),
(150, 'Bermuda Jeans Cinza Único - Ref 060', 'Produto novo para pronta entrega', 'Vestuário', 28.00, 51.80, 0, '2026-11-08 19:04:08', NULL, 1),
(151, 'Bermuda Moletom Cinza P - Ref 061', 'Produto novo para pronta entrega', 'Vestuário', 35.00, 64.75, 0, '2026-11-08 19:04:08', NULL, 1),
(152, 'Jaqueta Corta-Vento Cinza M - Ref 062', 'Produto novo para pronta entrega', 'Vestuário', 42.00, 77.70, 0, '2026-11-08 19:04:08', NULL, 1),
(153, 'Moletom Canguru Cinza G - Ref 063', 'Produto novo para pronta entrega', 'Vestuário', 49.00, 90.65, 0, '2026-11-08 19:04:08', NULL, 1),
(154, 'Vestido Midi Cinza GG - Ref 064', 'Produto novo para pronta entrega', 'Vestuário', 56.00, 103.60, 0, '2026-11-08 19:04:08', NULL, 1),
(155, 'Blusa Tricot Cinza Único - Ref 065', 'Produto novo para pronta entrega', 'Vestuário', 63.00, 116.55, 0, '2026-11-08 19:04:08', NULL, 1),
(156, 'Saia Jeans Cinza P - Ref 066', 'Produto novo para pronta entrega', 'Vestuário', 70.00, 129.50, 0, '2026-11-08 19:04:08', NULL, 1),
(157, 'Tênis Casual Cinza M - Ref 067', 'Produto novo para pronta entrega', 'Calçados', 77.00, 142.45, 0, '2026-11-08 19:04:08', NULL, 1),
(158, 'Tênis Esportivo Cinza G - Ref 068', 'Produto novo para pronta entrega', 'Calçados', 84.00, 155.40, 0, '2026-11-08 19:04:08', NULL, 1),
(159, 'Chinelo Slide Cinza GG - Ref 069', 'Produto novo para pronta entrega', 'Calçados', 91.00, 168.35, 0, '2026-11-08 19:04:08', NULL, 0),
(160, 'Sandália Rasteira Cinza Único - Ref 070', 'Produto novo para pronta entrega', 'Calçados', 18.00, 33.30, 0, '2026-11-08 19:04:08', NULL, 1),
(161, 'Boné Aba Curva Cinza P - Ref 071', 'Produto novo para pronta entrega', 'Acessórios', 25.00, 46.25, 0, '2026-11-08 19:04:08', NULL, 1),
(162, 'Cinto Sintético Cinza M - Ref 072', 'Produto novo para pronta entrega', 'Acessórios', 32.00, 59.20, 0, '2026-11-08 19:04:08', NULL, 1),
(163, 'Camiseta Básica Bege G - Ref 073', 'Produto novo para pronta entrega', 'Vestuário', 39.00, 72.15, 0, '2026-11-08 19:04:08', NULL, 1),
(164, 'Camiseta Polo Bege GG - Ref 074', 'Produto novo para pronta entrega', 'Vestuário', 46.00, 85.10, 0, '2026-11-08 19:04:08', NULL, 1),
(165, 'Camisa Social Bege Único - Ref 075', 'Produto novo para pronta entrega', 'Vestuário', 53.00, 98.05, 0, '2026-11-08 19:04:08', NULL, 1),
(166, 'Calça Jeans Bege P - Ref 076', 'Produto novo para pronta entrega', 'Vestuário', 60.00, 111.00, 0, '2026-11-08 19:04:08', NULL, 1),
(167, 'Calça Sarja Bege M - Ref 077', 'Produto novo para pronta entrega', 'Vestuário', 67.00, 123.95, 0, '2026-11-08 19:04:08', NULL, 1),
(168, 'Bermuda Jeans Bege G - Ref 078', 'Produto novo para pronta entrega', 'Vestuário', 74.00, 136.90, 0, '2026-11-08 19:04:08', NULL, 1),
(169, 'Bermuda Moletom Bege GG - Ref 079', 'Produto novo para pronta entrega', 'Vestuário', 81.00, 149.85, 0, '2026-11-08 19:04:08', NULL, 1),
(170, 'Jaqueta Corta-Vento Bege Único - Ref 080', 'Produto novo para pronta entrega', 'Vestuário', 88.00, 162.80, 0, '2026-11-08 19:04:08', NULL, 1),
(171, 'Moletom Canguru Bege P - Ref 081', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:04:08', NULL, 1),
(172, 'Vestido Midi Bege M - Ref 082', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:04:08', NULL, 1),
(173, 'Blusa Tricot Bege G - Ref 083', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:04:08', NULL, 1),
(174, 'Saia Jeans Bege GG - Ref 084', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:04:08', NULL, 1),
(175, 'Tênis Casual Bege Único - Ref 085', 'Produto novo para pronta entrega', 'Calçados', 43.00, 79.55, 0, '2026-11-08 19:04:08', NULL, 1),
(176, 'Tênis Esportivo Bege P - Ref 086', 'Produto novo para pronta entrega', 'Calçados', 50.00, 92.50, 0, '2026-11-08 19:04:08', NULL, 0),
(177, 'Chinelo Slide Bege M - Ref 087', 'Produto novo para pronta entrega', 'Calçados', 57.00, 105.45, 0, '2026-11-08 19:04:08', NULL, 1),
(178, 'Sandália Rasteira Bege G - Ref 088', 'Produto novo para pronta entrega', 'Calçados', 64.00, 118.40, 0, '2026-11-08 19:04:08', NULL, 1),
(179, 'Boné Aba Curva Bege GG - Ref 089', 'Produto novo para pronta entrega', 'Acessórios', 71.00, 131.35, 0, '2026-11-08 19:04:08', NULL, 1),
(180, 'Cinto Sintético Bege Único - Ref 090', 'Produto novo para pronta entrega', 'Acessórios', 78.00, 144.30, 0, '2026-11-08 19:04:08', NULL, 1),
(181, 'Camiseta Básica Preto P - Ref 001', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:05:13', NULL, 0),
(182, 'Camiseta Polo Preto M - Ref 002', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:05:13', NULL, 1),
(183, 'Camisa Social Preto G - Ref 003', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:05:13', NULL, 1),
(184, 'Calça Jeans Preto GG - Ref 004', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:05:13', NULL, 1),
(185, 'Calça Sarja Preto Único - Ref 005', 'Produto novo para pronta entrega', 'Vestuário', 43.00, 79.55, 0, '2026-11-08 19:05:13', NULL, 1),
(186, 'Bermuda Jeans Preto P - Ref 006', 'Produto novo para pronta entrega', 'Vestuário', 50.00, 92.50, 0, '2026-11-08 19:05:13', NULL, 1),
(187, 'Bermuda Moletom Preto M - Ref 007', 'Produto novo para pronta entrega', 'Vestuário', 57.00, 105.45, 0, '2026-11-08 19:05:13', NULL, 1),
(188, 'Jaqueta Corta-Vento Preto G - Ref 008', 'Produto novo para pronta entrega', 'Vestuário', 64.00, 118.40, 0, '2026-11-08 19:05:13', NULL, 1),
(189, 'Moletom Canguru Preto GG - Ref 009', 'Produto novo para pronta entrega', 'Vestuário', 71.00, 131.35, 0, '2026-11-08 19:05:13', NULL, 1),
(190, 'Vestido Midi Preto Único - Ref 010', 'Produto novo para pronta entrega', 'Vestuário', 78.00, 144.30, 0, '2026-11-08 19:05:13', NULL, 1),
(191, 'Blusa Tricot Preto P - Ref 011', 'Produto novo para pronta entrega', 'Vestuário', 85.00, 157.25, 0, '2026-11-08 19:05:13', NULL, 1),
(192, 'Saia Jeans Preto M - Ref 012', 'Produto novo para pronta entrega', 'Vestuário', 92.00, 170.20, 0, '2026-11-08 19:05:13', NULL, 1),
(193, 'Tênis Casual Preto G - Ref 013', 'Produto novo para pronta entrega', 'Calçados', 19.00, 35.15, 0, '2026-11-08 19:05:13', NULL, 1),
(194, 'Tênis Esportivo Preto GG - Ref 014', 'Produto novo para pronta entrega', 'Calçados', 26.00, 48.10, 0, '2026-11-08 19:05:13', NULL, 1),
(195, 'Chinelo Slide Preto Único - Ref 015', 'Produto novo para pronta entrega', 'Calçados', 33.00, 61.05, 0, '2026-11-08 19:05:13', NULL, 1),
(196, 'Sandália Rasteira Preto P - Ref 016', 'Produto novo para pronta entrega', 'Calçados', 40.00, 74.00, 0, '2026-11-08 19:05:13', NULL, 1),
(197, 'Boné Aba Curva Preto M - Ref 017', 'Produto novo para pronta entrega', 'Acessórios', 47.00, 86.95, 0, '2026-11-08 19:05:13', NULL, 1),
(198, 'Cinto Sintético Preto G - Ref 018', 'Produto novo para pronta entrega', 'Acessórios', 54.00, 99.90, 0, '2026-11-08 19:05:13', NULL, 0),
(199, 'Camiseta Básica Branco GG - Ref 019', 'Produto novo para pronta entrega', 'Vestuário', 61.00, 112.85, 0, '2026-11-08 19:05:13', NULL, 1),
(200, 'Camiseta Polo Branco Único - Ref 020', 'Produto novo para pronta entrega', 'Vestuário', 68.00, 125.80, 0, '2026-11-08 19:05:13', NULL, 1),
(201, 'Camisa Social Branco P - Ref 021', 'Produto novo para pronta entrega', 'Vestuário', 75.00, 138.75, 0, '2026-11-08 19:05:13', NULL, 1),
(202, 'Calça Jeans Branco M - Ref 022', 'Produto novo para pronta entrega', 'Vestuário', 82.00, 151.70, 0, '2026-11-08 19:05:13', NULL, 1),
(203, 'Calça Sarja Branco G - Ref 023', 'Produto novo para pronta entrega', 'Vestuário', 89.00, 164.65, 0, '2026-11-08 19:05:13', NULL, 1),
(204, 'Bermuda Jeans Branco GG - Ref 024', 'Produto novo para pronta entrega', 'Vestuário', 16.00, 29.60, 0, '2026-11-08 19:05:13', NULL, 1),
(205, 'Bermuda Moletom Branco Único - Ref 025', 'Produto novo para pronta entrega', 'Vestuário', 23.00, 42.55, 0, '2026-11-08 19:05:13', NULL, 1),
(206, 'Jaqueta Corta-Vento Branco P - Ref 026', 'Produto novo para pronta entrega', 'Vestuário', 30.00, 55.50, 0, '2026-11-08 19:05:13', NULL, 1),
(207, 'Moletom Canguru Branco M - Ref 027', 'Produto novo para pronta entrega', 'Vestuário', 37.00, 68.45, 0, '2026-11-08 19:05:13', NULL, 1),
(208, 'Vestido Midi Branco G - Ref 028', 'Produto novo para pronta entrega', 'Vestuário', 44.00, 81.40, 0, '2026-11-08 19:05:13', NULL, 1),
(209, 'Blusa Tricot Branco GG - Ref 029', 'Produto novo para pronta entrega', 'Vestuário', 51.00, 94.35, 0, '2026-11-08 19:05:13', NULL, 1),
(210, 'Saia Jeans Branco Único - Ref 030', 'Produto novo para pronta entrega', 'Vestuário', 58.00, 107.30, 0, '2026-11-08 19:05:13', NULL, 1),
(211, 'Tênis Casual Branco P - Ref 031', 'Produto novo para pronta entrega', 'Calçados', 65.00, 120.25, 0, '2026-11-08 19:05:13', NULL, 1),
(212, 'Tênis Esportivo Branco M - Ref 032', 'Produto novo para pronta entrega', 'Calçados', 72.00, 133.20, 0, '2026-11-08 19:05:13', NULL, 1),
(213, 'Chinelo Slide Branco G - Ref 033', 'Produto novo para pronta entrega', 'Calçados', 79.00, 146.15, 0, '2026-11-08 19:05:13', NULL, 1),
(214, 'Sandália Rasteira Branco GG - Ref 034', 'Produto novo para pronta entrega', 'Calçados', 86.00, 159.10, 0, '2026-11-08 19:05:13', NULL, 1),
(215, 'Boné Aba Curva Branco Único - Ref 035', 'Produto novo para pronta entrega', 'Acessórios', 93.00, 172.05, 0, '2026-11-08 19:05:13', NULL, 0),
(216, 'Cinto Sintético Branco P - Ref 036', 'Produto novo para pronta entrega', 'Acessórios', 20.00, 37.00, 0, '2026-11-08 19:05:13', NULL, 1),
(217, 'Camiseta Básica Azul M - Ref 037', 'Produto novo para pronta entrega', 'Vestuário', 27.00, 49.95, 0, '2026-11-08 19:05:13', NULL, 1),
(218, 'Camiseta Polo Azul G - Ref 038', 'Produto novo para pronta entrega', 'Vestuário', 34.00, 62.90, 0, '2026-11-08 19:05:13', NULL, 1),
(219, 'Camisa Social Azul GG - Ref 039', 'Produto novo para pronta entrega', 'Vestuário', 41.00, 75.85, 0, '2026-11-08 19:05:13', NULL, 1),
(220, 'Calça Jeans Azul Único - Ref 040', 'Produto novo para pronta entrega', 'Vestuário', 48.00, 88.80, 0, '2026-11-08 19:05:13', NULL, 1),
(221, 'Calça Sarja Azul P - Ref 041', 'Produto novo para pronta entrega', 'Vestuário', 55.00, 101.75, 0, '2026-11-08 19:05:13', NULL, 1),
(222, 'Bermuda Jeans Azul M - Ref 042', 'Produto novo para pronta entrega', 'Vestuário', 62.00, 114.70, 0, '2026-11-08 19:05:13', NULL, 1),
(223, 'Bermuda Moletom Azul G - Ref 043', 'Produto novo para pronta entrega', 'Vestuário', 69.00, 127.65, 0, '2026-11-08 19:05:13', NULL, 1),
(224, 'Jaqueta Corta-Vento Azul GG - Ref 044', 'Produto novo para pronta entrega', 'Vestuário', 76.00, 140.60, 0, '2026-11-08 19:05:13', NULL, 1),
(225, 'Moletom Canguru Azul Único - Ref 045', 'Produto novo para pronta entrega', 'Vestuário', 83.00, 153.55, 0, '2026-11-08 19:05:13', NULL, 1),
(226, 'Vestido Midi Azul P - Ref 046', 'Produto novo para pronta entrega', 'Vestuário', 90.00, 166.50, 0, '2026-11-08 19:05:13', NULL, 1),
(227, 'Blusa Tricot Azul M - Ref 047', 'Produto novo para pronta entrega', 'Vestuário', 17.00, 31.45, 0, '2026-11-08 19:05:13', NULL, 1),
(228, 'Saia Jeans Azul G - Ref 048', 'Produto novo para pronta entrega', 'Vestuário', 24.00, 44.40, 0, '2026-11-08 19:05:13', NULL, 1),
(229, 'Tênis Casual Azul GG - Ref 049', 'Produto novo para pronta entrega', 'Calçados', 31.00, 57.35, 0, '2026-11-08 19:05:13', NULL, 1),
(230, 'Tênis Esportivo Azul Único - Ref 050', 'Produto novo para pronta entrega', 'Calçados', 38.00, 70.30, 0, '2026-11-08 19:05:13', NULL, 1),
(231, 'Chinelo Slide Azul P - Ref 051', 'Produto novo para pronta entrega', 'Calçados', 45.00, 83.25, 0, '2026-11-08 19:05:13', NULL, 1),
(232, 'Sandália Rasteira Azul M - Ref 052', 'Produto novo para pronta entrega', 'Calçados', 52.00, 96.20, 0, '2026-11-08 19:05:13', NULL, 0),
(233, 'Boné Aba Curva Azul G - Ref 053', 'Produto novo para pronta entrega', 'Acessórios', 59.00, 109.15, 0, '2026-11-08 19:05:13', NULL, 1),
(234, 'Cinto Sintético Azul GG - Ref 054', 'Produto novo para pronta entrega', 'Acessórios', 66.00, 122.10, 0, '2026-11-08 19:05:13', NULL, 1),
(235, 'Camiseta Básica Cinza Único - Ref 055', 'Produto novo para pronta entrega', 'Vestuário', 73.00, 135.05, 0, '2026-11-08 19:05:13', NULL, 1),
(236, 'Camiseta Polo Cinza P - Ref 056', 'Produto novo para pronta entrega', 'Vestuário', 80.00, 148.00, 0, '2026-11-08 19:05:13', NULL, 1),
(237, 'Camisa Social Cinza M - Ref 057', 'Produto novo para pronta entrega', 'Vestuário', 87.00, 160.95, 0, '2026-11-08 19:05:13', NULL, 1),
(238, 'Calça Jeans Cinza G - Ref 058', 'Produto novo para pronta entrega', 'Vestuário', 94.00, 173.90, 0, '2026-11-08 19:05:13', NULL, 1),
(239, 'Calça Sarja Cinza GG - Ref 059', 'Produto novo para pronta entrega', 'Vestuário', 21.00, 38.85, 0, '2026-11-08 19:05:13', NULL, 1),
(240, 'Bermuda Jeans Cinza Único - Ref 060', 'Produto novo para pronta entrega', 'Vestuário', 28.00, 51.80, 0, '2026-11-08 19:05:13', NULL, 1),
(241, 'Bermuda Moletom Cinza P - Ref 061', 'Produto novo para pronta entrega', 'Vestuário', 35.00, 64.75, 0, '2026-11-08 19:05:13', NULL, 1),
(242, 'Jaqueta Corta-Vento Cinza M - Ref 062', 'Produto novo para pronta entrega', 'Vestuário', 42.00, 77.70, 0, '2026-11-08 19:05:13', NULL, 1),
(243, 'Moletom Canguru Cinza G - Ref 063', 'Produto novo para pronta entrega', 'Vestuário', 49.00, 90.65, 0, '2026-11-08 19:05:13', NULL, 1),
(244, 'Vestido Midi Cinza GG - Ref 064', 'Produto novo para pronta entrega', 'Vestuário', 56.00, 103.60, 0, '2026-11-08 19:05:13', NULL, 1),
(245, 'Blusa Tricot Cinza Único - Ref 065', 'Produto novo para pronta entrega', 'Vestuário', 63.00, 116.55, 0, '2026-11-08 19:05:13', NULL, 1),
(246, 'Saia Jeans Cinza P - Ref 066', 'Produto novo para pronta entrega', 'Vestuário', 70.00, 129.50, 0, '2026-11-08 19:05:13', NULL, 1),
(247, 'Tênis Casual Cinza M - Ref 067', 'Produto novo para pronta entrega', 'Calçados', 77.00, 142.45, 0, '2026-11-08 19:05:13', NULL, 1),
(248, 'Tênis Esportivo Cinza G - Ref 068', 'Produto novo para pronta entrega', 'Calçados', 84.00, 155.40, 0, '2026-11-08 19:05:13', NULL, 1),
(249, 'Chinelo Slide Cinza GG - Ref 069', 'Produto novo para pronta entrega', 'Calçados', 91.00, 168.35, 0, '2026-11-08 19:05:13', NULL, 0),
(250, 'Sandália Rasteira Cinza Único - Ref 070', 'Produto novo para pronta entrega', 'Calçados', 18.00, 33.30, 0, '2026-11-08 19:05:13', NULL, 1),
(251, 'Boné Aba Curva Cinza P - Ref 071', 'Produto novo para pronta entrega', 'Acessórios', 25.00, 46.25, 0, '2026-11-08 19:05:13', NULL, 1),
(252, 'Cinto Sintético Cinza M - Ref 072', 'Produto novo para pronta entrega', 'Acessórios', 32.00, 59.20, 0, '2026-11-08 19:05:13', NULL, 1),
(253, 'Camiseta Básica Bege G - Ref 073', 'Produto novo para pronta entrega', 'Vestuário', 39.00, 72.15, 0, '2026-11-08 19:05:13', NULL, 1),
(254, 'Camiseta Polo Bege GG - Ref 074', 'Produto novo para pronta entrega', 'Vestuário', 46.00, 85.10, 0, '2026-11-08 19:05:13', NULL, 1),
(255, 'Camisa Social Bege Único - Ref 075', 'Produto novo para pronta entrega', 'Vestuário', 53.00, 98.05, 0, '2026-11-08 19:05:13', NULL, 1),
(256, 'Calça Jeans Bege P - Ref 076', 'Produto novo para pronta entrega', 'Vestuário', 60.00, 111.00, 0, '2026-11-08 19:05:13', NULL, 1),
(257, 'Calça Sarja Bege M - Ref 077', 'Produto novo para pronta entrega', 'Vestuário', 67.00, 123.95, 0, '2026-11-08 19:05:13', NULL, 1),
(258, 'Bermuda Jeans Bege G - Ref 078', 'Produto novo para pronta entrega', 'Vestuário', 74.00, 136.90, 0, '2026-11-08 19:05:13', NULL, 1),
(259, 'Bermuda Moletom Bege GG - Ref 079', 'Produto novo para pronta entrega', 'Vestuário', 81.00, 149.85, 0, '2026-11-08 19:05:13', NULL, 1),
(260, 'Jaqueta Corta-Vento Bege Único - Ref 080', 'Produto novo para pronta entrega', 'Vestuário', 88.00, 162.80, 0, '2026-11-08 19:05:13', NULL, 1),
(261, 'Moletom Canguru Bege P - Ref 081', 'Produto novo para pronta entrega', 'Vestuário', 15.00, 27.75, 0, '2026-11-08 19:05:13', NULL, 1),
(262, 'Vestido Midi Bege M - Ref 082', 'Produto novo para pronta entrega', 'Vestuário', 22.00, 40.70, 0, '2026-11-08 19:05:14', NULL, 1),
(263, 'Blusa Tricot Bege G - Ref 083', 'Produto novo para pronta entrega', 'Vestuário', 29.00, 53.65, 0, '2026-11-08 19:05:14', NULL, 1),
(264, 'Saia Jeans Bege GG - Ref 084', 'Produto novo para pronta entrega', 'Vestuário', 36.00, 66.60, 0, '2026-11-08 19:05:14', NULL, 1),
(265, 'Tênis Casual Bege Único - Ref 085', 'Produto novo para pronta entrega', 'Calçados', 43.00, 79.55, 0, '2026-11-08 19:05:14', NULL, 1),
(266, 'Tênis Esportivo Bege P - Ref 086', 'Produto novo para pronta entrega', 'Calçados', 50.00, 92.50, 0, '2026-11-08 19:05:14', NULL, 0),
(267, 'Chinelo Slide Bege M - Ref 087', 'Produto novo para pronta entrega', 'Calçados', 57.00, 105.45, 0, '2026-11-08 19:05:14', NULL, 1),
(268, 'Sandália Rasteira Bege G - Ref 088', 'Produto novo para pronta entrega', 'Calçados', 64.00, 118.40, 0, '2026-11-08 19:05:14', NULL, 1),
(269, 'Boné Aba Curva Bege GG - Ref 089', 'Produto novo para pronta entrega', 'Acessórios', 71.00, 131.35, 0, '2026-11-08 19:05:14', NULL, 1),
(270, 'Cinto Sintético Bege Único - Ref 090', 'Produto novo para pronta entrega', 'Acessórios', 78.00, 144.30, 0, '2026-11-08 19:05:14', NULL, 1);

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
-- Extraindo dados da tabela `venda`
--

INSERT INTO `venda` (`num_venda`, `data_venda`, `num_cliente`, `num_funcionario`, `desconto_valor`, `desconto_percentual`, `acrescimo`, `valor_total`, `observacao`, `situacao`, `cancelada_em`, `cancelada_por`, `motivo_cancelamento`) VALUES
(1, '2026-01-05 09:00:00', 1, 1, 0.00, 0.00, 0.00, 160.95, 'Pedido realizado na loja', 'CANCELADA', NULL, NULL, NULL),
(19, '2026-01-05 09:00:00', 1, 1, 0.00, 0.00, 0.00, 160.95, 'Pedido realizado na loja', 'CANCELADA', NULL, NULL, NULL),
(20, '2026-01-12 10:00:00', 8, 2, 0.00, 0.00, 0.00, 227.55, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(21, '2026-01-19 11:00:00', 15, 3, 0.00, 0.00, 0.00, 320.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(22, '2026-01-26 12:00:00', 22, 4, 0.00, 0.00, 0.00, 410.70, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(23, '2026-02-02 13:00:00', 29, 5, 0.00, 0.00, 0.00, 233.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(24, '2026-02-09 14:00:00', 36, 1, 0.00, 0.00, 0.00, 377.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(25, '2026-02-16 15:00:00', 43, 2, 0.00, 0.00, 0.00, 168.35, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(26, '2026-02-23 16:00:00', 50, 3, 0.00, 0.00, 0.00, 312.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(27, '2026-03-02 17:00:00', 57, 4, 0.00, 0.00, 0.00, 482.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(28, '2026-03-09 09:00:00', 64, 5, 0.00, 0.00, 0.00, 347.80, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(29, '2026-03-16 10:00:00', 71, 1, 0.00, 0.00, 0.00, 543.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(30, '2026-03-23 11:00:00', 78, 2, 0.00, 0.00, 0.00, 765.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(31, '2026-03-30 12:00:00', 85, 3, 0.00, 0.00, 0.00, 175.75, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(32, '2026-04-06 13:00:00', 2, 4, 0.00, 0.00, 0.00, 249.75, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(33, '2026-04-13 14:00:00', 9, 5, 0.00, 0.00, 0.00, 349.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(34, '2026-04-20 15:00:00', 16, 1, 0.00, 0.00, 0.00, 136.90, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(35, '2026-04-27 16:00:00', 23, 2, 0.00, 0.00, 0.00, 262.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(36, '2026-05-04 17:00:00', 30, 3, 0.00, 0.00, 0.00, 414.40, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(37, '2026-05-11 09:00:00', 37, 4, 0.00, 0.00, 0.00, 183.15, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(38, '2026-05-18 10:00:00', 44, 5, 0.00, 0.00, 0.00, 334.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(39, '2026-05-25 11:00:00', 51, 1, 0.00, 0.00, 0.00, 512.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(40, '2026-06-01 12:00:00', 58, 2, 0.00, 0.00, 0.00, 370.00, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(41, '2026-06-08 13:00:00', 65, 3, 0.00, 0.00, 0.00, 573.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(42, '2026-06-15 14:00:00', 72, 4, 0.00, 0.00, 0.00, 358.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(43, '2026-06-22 15:00:00', 79, 5, 0.00, 0.00, 0.00, 190.55, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(44, '2026-06-29 16:00:00', 86, 1, 0.00, 0.00, 0.00, 271.95, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(45, '2026-07-06 17:00:00', 3, 2, 0.00, 0.00, 0.00, 379.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(46, '2026-07-13 09:00:00', 10, 3, 0.00, 0.00, 0.00, 159.10, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(47, '2026-07-20 10:00:00', 17, 4, 0.00, 0.00, 0.00, 292.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(48, '2026-07-27 11:00:00', 24, 5, 0.00, 0.00, 0.00, 451.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(49, '2026-08-03 12:00:00', 31, 1, 0.00, 0.00, 0.00, 197.95, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(50, '2026-08-10 13:00:00', 38, 2, 0.00, 0.00, 0.00, 357.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(51, '2026-08-17 14:00:00', 45, 3, 0.00, 0.00, 0.00, 542.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(52, '2026-08-24 15:00:00', 52, 4, 0.00, 0.00, 0.00, 392.20, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(53, '2026-08-31 16:00:00', 59, 5, 0.00, 0.00, 0.00, 603.10, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(54, '2026-09-07 17:00:00', 66, 1, 0.00, 0.00, 0.00, 395.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(55, '2026-09-14 09:00:00', 73, 2, 0.00, 0.00, 0.00, 205.35, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(56, '2026-09-21 10:00:00', 80, 3, 0.00, 0.00, 0.00, 294.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(57, '2026-09-28 11:00:00', 87, 4, 0.00, 0.00, 0.00, 260.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(58, '2026-10-05 12:00:00', 4, 5, 0.00, 0.00, 0.00, 181.30, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(59, '2026-10-12 13:00:00', 11, 1, 0.00, 0.00, 0.00, 321.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(60, '2026-10-19 14:00:00', 18, 2, 0.00, 0.00, 0.00, 488.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(61, '2026-10-26 15:00:00', 25, 3, 0.00, 0.00, 0.00, 212.75, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(62, '2026-01-11 16:00:00', 32, 4, 0.00, 0.00, 0.00, 379.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(63, '2026-01-18 17:00:00', 39, 5, 0.00, 0.00, 0.00, 571.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(64, '2026-01-25 09:00:00', 46, 1, 0.00, 0.00, 0.00, 414.40, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(65, '2026-02-01 10:00:00', 53, 2, 0.00, 0.00, 0.00, 336.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(66, '2026-02-08 11:00:00', 60, 3, 0.00, 0.00, 0.00, 432.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(67, '2026-02-15 12:00:00', 67, 4, 0.00, 0.00, 0.00, 220.15, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(68, '2026-02-22 13:00:00', 74, 5, 0.00, 0.00, 0.00, 168.35, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(69, '2026-03-01 14:00:00', 81, 1, 0.00, 0.00, 0.00, 290.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(70, '2026-03-08 15:00:00', 88, 2, 0.00, 0.00, 0.00, 203.50, 'Pedido realizado na loja', 'CANCELADA', NULL, NULL, NULL),
(71, '2026-03-15 16:00:00', 5, 3, 0.00, 0.00, 0.00, 351.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(72, '2026-03-22 17:00:00', 12, 4, 0.00, 0.00, 0.00, 525.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(73, '2026-03-29 09:00:00', 19, 5, 0.00, 0.00, 0.00, 227.55, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(74, '2026-04-05 10:00:00', 26, 1, 0.00, 0.00, 0.00, 401.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(75, '2026-04-12 11:00:00', 33, 2, 0.00, 0.00, 0.00, 601.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(76, '2026-04-19 12:00:00', 40, 3, 0.00, 0.00, 0.00, 436.60, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(77, '2026-04-26 13:00:00', 47, 4, 0.00, 0.00, 0.00, 366.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(78, '2026-05-03 14:00:00', 54, 5, 0.00, 0.00, 0.00, 210.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(79, '2026-05-10 15:00:00', 61, 1, 0.00, 0.00, 0.00, 105.45, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(80, '2026-05-17 16:00:00', 68, 2, 0.00, 0.00, 0.00, 209.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(81, '2026-05-24 17:00:00', 75, 3, 0.00, 0.00, 0.00, 338.55, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(82, '2026-05-31 09:00:00', 82, 4, 0.00, 0.00, 0.00, 262.70, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(83, '2026-06-07 10:00:00', 89, 5, 0.00, 0.00, 0.00, 418.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(84, '2026-06-14 11:00:00', 6, 1, 0.00, 0.00, 0.00, 599.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(85, '2026-06-21 12:00:00', 13, 2, 0.00, 0.00, 0.00, 260.85, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(86, '2026-06-28 13:00:00', 20, 3, 0.00, 0.00, 0.00, 442.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(87, '2026-07-05 14:00:00', 27, 4, 0.00, 0.00, 0.00, 649.35, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(88, '2026-07-12 15:00:00', 34, 5, 0.00, 0.00, 0.00, 347.80, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(89, '2026-07-19 16:00:00', 41, 1, 0.00, 0.00, 0.00, 432.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(90, '2026-07-26 17:00:00', 48, 2, 0.00, 0.00, 0.00, 247.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(91, '2026-08-02 09:00:00', 55, 3, 0.00, 0.00, 0.00, 120.25, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(92, '2026-08-09 10:00:00', 62, 4, 0.00, 0.00, 0.00, 231.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(93, '2026-08-16 11:00:00', 69, 5, 0.00, 0.00, 0.00, 368.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(94, '2026-08-23 12:00:00', 76, 1, 0.00, 0.00, 0.00, 284.90, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(95, '2026-08-30 13:00:00', 83, 2, 0.00, 0.00, 0.00, 447.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(96, '2026-09-06 14:00:00', 90, 3, 0.00, 0.00, 0.00, 636.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(97, '2026-09-13 15:00:00', 7, 4, 0.00, 0.00, 0.00, 275.65, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(98, '2026-09-20 16:00:00', 14, 5, 0.00, 0.00, 0.00, 464.35, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(99, '2026-09-27 17:00:00', 21, 1, 0.00, 0.00, 0.00, 234.95, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(100, '2026-10-04 09:00:00', 28, 2, 0.00, 0.00, 0.00, 370.00, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(101, '2026-10-11 10:00:00', 35, 3, 0.00, 0.00, 0.00, 166.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(102, '2026-10-18 11:00:00', 42, 4, 0.00, 0.00, 0.00, 284.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(103, '2026-10-25 12:00:00', 49, 5, 0.00, 0.00, 0.00, 135.05, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(104, '2026-01-10 13:00:00', 56, 1, 0.00, 0.00, 0.00, 253.45, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(105, '2026-01-17 14:00:00', 63, 2, 0.00, 0.00, 0.00, 397.75, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(106, '2026-01-24 15:00:00', 70, 3, 0.00, 0.00, 0.00, 307.10, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(107, '2026-01-31 16:00:00', 77, 4, 0.00, 0.00, 0.00, 477.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(108, '2026-02-07 17:00:00', 84, 5, 0.00, 0.00, 0.00, 673.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(109, '2026-02-14 09:00:00', 1, 1, 0.00, 0.00, 0.00, 160.95, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(110, '2026-02-21 10:00:00', 8, 2, 0.00, 0.00, 0.00, 227.55, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(111, '2026-02-28 11:00:00', 15, 3, 0.00, 0.00, 0.00, 320.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(112, '2026-03-07 12:00:00', 22, 4, 0.00, 0.00, 0.00, 410.70, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(113, '2026-03-14 13:00:00', 29, 5, 0.00, 0.00, 0.00, 233.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(114, '2026-03-21 14:00:00', 36, 1, 0.00, 0.00, 0.00, 377.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(115, '2026-03-28 15:00:00', 43, 2, 0.00, 0.00, 0.00, 168.35, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(116, '2026-04-04 16:00:00', 50, 3, 0.00, 0.00, 0.00, 312.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(117, '2026-04-11 17:00:00', 57, 4, 0.00, 0.00, 0.00, 482.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(118, '2026-04-18 09:00:00', 64, 5, 0.00, 0.00, 0.00, 347.80, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(119, '2026-04-25 10:00:00', 71, 1, 0.00, 0.00, 0.00, 543.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(120, '2026-05-02 11:00:00', 78, 2, 0.00, 0.00, 0.00, 765.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(121, '2026-05-09 12:00:00', 85, 3, 0.00, 0.00, 0.00, 175.75, 'Pedido realizado na loja', 'CANCELADA', NULL, NULL, NULL),
(122, '2026-05-16 13:00:00', 2, 4, 0.00, 0.00, 0.00, 249.75, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(123, '2026-05-23 14:00:00', 9, 5, 0.00, 0.00, 0.00, 349.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(124, '2026-05-30 15:00:00', 16, 1, 0.00, 0.00, 0.00, 136.90, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(125, '2026-06-06 16:00:00', 23, 2, 0.00, 0.00, 0.00, 262.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(126, '2026-06-13 17:00:00', 30, 3, 0.00, 0.00, 0.00, 414.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(127, '2026-06-20 09:00:00', 37, 4, 0.00, 0.00, 0.00, 183.15, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(128, '2026-06-27 10:00:00', 44, 5, 0.00, 0.00, 0.00, 334.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(129, '2026-07-04 11:00:00', 51, 1, 0.00, 0.00, 0.00, 512.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(130, '2026-07-11 12:00:00', 58, 2, 0.00, 0.00, 0.00, 370.00, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(131, '2026-07-18 13:00:00', 65, 3, 0.00, 0.00, 0.00, 573.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(132, '2026-07-25 14:00:00', 72, 4, 0.00, 0.00, 0.00, 358.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(133, '2026-08-01 15:00:00', 79, 5, 0.00, 0.00, 0.00, 190.55, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(134, '2026-08-08 16:00:00', 86, 1, 0.00, 0.00, 0.00, 271.95, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(135, '2026-08-15 17:00:00', 3, 2, 0.00, 0.00, 0.00, 379.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(136, '2026-08-22 09:00:00', 10, 3, 0.00, 0.00, 0.00, 159.10, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(137, '2026-08-29 10:00:00', 17, 4, 0.00, 0.00, 0.00, 292.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(138, '2026-09-05 11:00:00', 24, 5, 0.00, 0.00, 0.00, 451.40, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(139, '2026-09-12 12:00:00', 31, 1, 0.00, 0.00, 0.00, 197.95, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(140, '2026-09-19 13:00:00', 38, 2, 0.00, 0.00, 0.00, 357.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(141, '2026-09-26 14:00:00', 45, 3, 0.00, 0.00, 0.00, 542.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(142, '2026-10-03 15:00:00', 52, 4, 0.00, 0.00, 0.00, 392.20, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(143, '2026-10-10 16:00:00', 59, 5, 0.00, 0.00, 0.00, 603.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(144, '2026-10-17 17:00:00', 66, 1, 0.00, 0.00, 0.00, 395.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(145, '2026-10-24 09:00:00', 73, 2, 0.00, 0.00, 0.00, 205.35, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(146, '2026-01-09 10:00:00', 80, 3, 0.00, 0.00, 0.00, 294.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(147, '2026-01-16 11:00:00', 87, 4, 0.00, 0.00, 0.00, 260.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(148, '2026-01-23 12:00:00', 4, 5, 0.00, 0.00, 0.00, 181.30, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(149, '2026-01-30 13:00:00', 11, 1, 0.00, 0.00, 0.00, 321.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(150, '2026-02-06 14:00:00', 18, 2, 0.00, 0.00, 0.00, 488.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(151, '2026-02-13 15:00:00', 25, 3, 0.00, 0.00, 0.00, 212.75, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(152, '2026-02-20 16:00:00', 32, 4, 0.00, 0.00, 0.00, 379.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(153, '2026-02-27 17:00:00', 39, 5, 0.00, 0.00, 0.00, 571.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(154, '2026-03-06 09:00:00', 46, 1, 0.00, 0.00, 0.00, 414.40, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(155, '2026-03-13 10:00:00', 53, 2, 0.00, 0.00, 0.00, 336.70, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(156, '2026-03-20 11:00:00', 60, 3, 0.00, 0.00, 0.00, 432.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(157, '2026-03-27 12:00:00', 67, 4, 0.00, 0.00, 0.00, 220.15, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(158, '2026-04-03 13:00:00', 74, 5, 0.00, 0.00, 0.00, 168.35, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(159, '2026-04-10 14:00:00', 81, 1, 0.00, 0.00, 0.00, 290.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(160, '2026-04-17 15:00:00', 88, 2, 0.00, 0.00, 0.00, 203.50, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(161, '2026-04-24 16:00:00', 5, 3, 0.00, 0.00, 0.00, 351.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(162, '2026-05-01 17:00:00', 12, 4, 0.00, 0.00, 0.00, 525.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(163, '2026-05-08 09:00:00', 19, 5, 0.00, 0.00, 0.00, 227.55, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(164, '2026-05-15 10:00:00', 26, 1, 0.00, 0.00, 0.00, 401.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(165, '2026-05-22 11:00:00', 33, 2, 0.00, 0.00, 0.00, 601.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(166, '2026-05-29 12:00:00', 40, 3, 0.00, 0.00, 0.00, 436.60, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(167, '2026-06-05 13:00:00', 47, 4, 0.00, 0.00, 0.00, 366.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(168, '2026-06-12 14:00:00', 54, 5, 0.00, 0.00, 0.00, 210.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(169, '2026-06-19 15:00:00', 61, 1, 0.00, 0.00, 0.00, 105.45, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(170, '2026-06-26 16:00:00', 68, 2, 0.00, 0.00, 0.00, 209.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(171, '2026-07-03 17:00:00', 75, 3, 0.00, 0.00, 0.00, 338.55, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(172, '2026-07-10 09:00:00', 82, 4, 0.00, 0.00, 0.00, 262.70, 'Pedido realizado na loja', 'CANCELADA', NULL, NULL, NULL),
(173, '2026-07-17 10:00:00', 89, 5, 0.00, 0.00, 0.00, 418.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(174, '2026-07-24 11:00:00', 6, 1, 0.00, 0.00, 0.00, 599.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(175, '2026-07-31 12:00:00', 13, 2, 0.00, 0.00, 0.00, 260.85, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(176, '2026-08-07 13:00:00', 20, 3, 0.00, 0.00, 0.00, 442.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(177, '2026-08-14 14:00:00', 27, 4, 0.00, 0.00, 0.00, 649.35, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(178, '2026-08-21 15:00:00', 34, 5, 0.00, 0.00, 0.00, 347.80, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(179, '2026-08-28 16:00:00', 41, 1, 0.00, 0.00, 0.00, 432.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(180, '2026-09-04 17:00:00', 48, 2, 0.00, 0.00, 0.00, 247.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(181, '2026-09-11 09:00:00', 55, 3, 0.00, 0.00, 0.00, 120.25, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(182, '2026-09-18 10:00:00', 62, 4, 0.00, 0.00, 0.00, 231.25, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(183, '2026-09-25 11:00:00', 69, 5, 0.00, 0.00, 0.00, 368.15, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(184, '2026-10-02 12:00:00', 76, 1, 0.00, 0.00, 0.00, 284.90, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(185, '2026-10-09 13:00:00', 83, 2, 0.00, 0.00, 0.00, 447.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(186, '2026-10-16 14:00:00', 90, 3, 0.00, 0.00, 0.00, 636.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(187, '2026-10-23 15:00:00', 7, 4, 0.00, 0.00, 0.00, 275.65, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(188, '2026-01-08 16:00:00', 14, 5, 0.00, 0.00, 0.00, 464.35, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(189, '2026-01-15 17:00:00', 21, 1, 0.00, 0.00, 0.00, 234.95, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(190, '2026-01-22 09:00:00', 28, 2, 0.00, 0.00, 0.00, 370.00, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(191, '2026-01-29 10:00:00', 35, 3, 0.00, 0.00, 0.00, 166.50, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(192, '2026-02-05 11:00:00', 42, 4, 0.00, 0.00, 0.00, 284.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(193, '2026-02-12 12:00:00', 49, 5, 0.00, 0.00, 0.00, 135.05, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(194, '2026-02-19 13:00:00', 56, 1, 0.00, 0.00, 0.00, 253.45, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(195, '2026-02-26 14:00:00', 63, 2, 0.00, 0.00, 0.00, 397.75, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(196, '2026-03-05 15:00:00', 70, 3, 0.00, 0.00, 0.00, 307.10, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(197, '2026-03-12 16:00:00', 77, 4, 0.00, 0.00, 0.00, 477.30, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(198, '2026-03-19 17:00:00', 84, 5, 0.00, 0.00, 0.00, 673.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(199, '2026-03-26 09:00:00', 1, 1, 0.00, 0.00, 0.00, 160.95, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(200, '2026-04-02 10:00:00', 8, 2, 0.00, 0.00, 0.00, 227.55, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(201, '2026-04-09 11:00:00', 15, 3, 0.00, 0.00, 0.00, 320.05, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(202, '2026-04-16 12:00:00', 22, 4, 0.00, 0.00, 0.00, 410.70, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(203, '2026-04-23 13:00:00', 29, 5, 0.00, 0.00, 0.00, 233.10, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(204, '2026-04-30 14:00:00', 36, 1, 0.00, 0.00, 0.00, 377.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(205, '2026-05-07 15:00:00', 43, 2, 0.00, 0.00, 0.00, 168.35, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(206, '2026-05-14 16:00:00', 50, 3, 0.00, 0.00, 0.00, 312.65, 'Venda balcão', 'CANCELADA', NULL, NULL, NULL),
(207, '2026-05-21 17:00:00', 57, 4, 0.00, 0.00, 0.00, 482.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(208, '2026-05-28 09:00:00', 64, 5, 0.00, 0.00, 0.00, 347.80, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(209, '2026-06-04 10:00:00', 71, 1, 0.00, 0.00, 0.00, 543.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(210, '2026-06-11 11:00:00', 78, 2, 0.00, 0.00, 0.00, 765.90, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(211, '2026-06-18 12:00:00', 85, 3, 0.00, 0.00, 0.00, 175.75, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(212, '2026-06-25 13:00:00', 2, 4, 0.00, 0.00, 0.00, 249.75, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(213, '2026-07-02 14:00:00', 9, 5, 0.00, 0.00, 0.00, 349.65, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(214, '2026-07-09 15:00:00', 16, 1, 0.00, 0.00, 0.00, 136.90, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(215, '2026-07-16 16:00:00', 23, 2, 0.00, 0.00, 0.00, 262.70, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(216, '2026-07-23 17:00:00', 30, 3, 0.00, 0.00, 0.00, 414.40, 'Venda balcão', 'ATIVA', NULL, NULL, NULL),
(217, '2026-07-30 09:00:00', 37, 4, 0.00, 0.00, 0.00, 183.15, 'Pedido realizado na loja', 'ATIVA', NULL, NULL, NULL),
(218, '2026-08-06 10:00:00', 44, 5, 0.00, 0.00, 0.00, 334.85, 'Venda balcão', 'ATIVA', NULL, NULL, NULL);

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
  ADD KEY `fk_acerto_item_acerto` (`acerto_id`),
  ADD KEY `idx_acerto_produto` (`produto_id`);

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
  ADD KEY `idx_financeiro_data` (`data_movimento`),
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
  ADD KEY `fk_venda_cliente` (`num_cliente`),
  ADD KEY `idx_venda_funcionario` (`num_funcionario`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acerto_estoque`
--
ALTER TABLE `acerto_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `acerto_estoque_item`
--
ALTER TABLE `acerto_estoque_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=451;

--
-- AUTO_INCREMENT de tabela `entrada_estoque`
--
ALTER TABLE `entrada_estoque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=271;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `num_venda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=219;

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
  ADD CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`num_cliente`) REFERENCES `cliente` (`codigo`),
  ADD CONSTRAINT `fk_venda_funcionario` FOREIGN KEY (`num_funcionario`) REFERENCES `funcionario` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
