-- Executar uma única vez no banco ravia_db, após fazer backup.
-- As entradas já existentes em entrada_estoque continuam contando no saldo.
CREATE TABLE IF NOT EXISTS acerto_estoque (
 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 data_emissao DATE NOT NULL,
 usuario_id VARCHAR(128) NULL,
 criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_acerto_data (data_emissao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS acerto_estoque_item (
 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 acerto_id INT NOT NULL,
 produto_id INT NOT NULL,
 quantidade INT NOT NULL,
 CONSTRAINT fk_acerto_item_acerto FOREIGN KEY (acerto_id) REFERENCES acerto_estoque(id),
 CONSTRAINT fk_acerto_item_produto FOREIGN KEY (produto_id) REFERENCES produto(id),
 INDEX idx_acerto_produto (produto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DROP FUNCTION IF EXISTS fn_estoque;
DELIMITER $$
CREATE FUNCTION fn_estoque(p_produto_id INT) RETURNS INT READS SQL DATA
BEGIN
 DECLARE v_entradas INT DEFAULT 0;
 DECLARE v_saidas INT DEFAULT 0;
 DECLARE v_acertos INT DEFAULT 0;
 SELECT COALESCE(SUM(quantidade),0) INTO v_entradas FROM entrada_estoque WHERE produto_id=p_produto_id;
 SELECT COALESCE(SUM(quantidade),0) INTO v_saidas FROM item_venda WHERE num_produto=p_produto_id;
 SELECT COALESCE(SUM(quantidade),0) INTO v_acertos FROM acerto_estoque_item WHERE produto_id=p_produto_id;
 RETURN v_entradas+v_acertos-v_saidas;
END$$
DELIMITER ;
-- A venda deve validar a mesma função, sem baixar novamente o campo produto.estoque.
DROP TRIGGER IF EXISTS trg_item_venda_baixa_estoque;
DELIMITER $$
CREATE TRIGGER trg_item_venda_baixa_estoque BEFORE INSERT ON item_venda FOR EACH ROW
BEGIN
 DECLARE v_id INT DEFAULT NULL;
 DECLARE v_saldo INT DEFAULT 0;
 IF NEW.quantidade<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantidade deve ser maior que zero'; END IF;
 SELECT id INTO v_id FROM produto WHERE id=NEW.num_produto FOR UPDATE;
 IF v_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Produto inexistente'; END IF;
 SET v_saldo=fn_estoque(NEW.num_produto);
 IF v_saldo<NEW.quantidade THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Estoque insuficiente'; END IF;
END$$
DELIMITER ;
-- IMPORTANTE: produto.estoque deixa de ser usado como saldo oficial.
-- Antes de usar em produção, confira os saldos iniciais da tabela entrada_estoque.
