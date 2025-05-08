DROP DATABASE IF EXISTS db1;
CREATE DATABASE db1;
USE db1;

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Enderecos;

CREATE TABLE Clientes(
    id INT AUTO_INCREMENT,
    nome VARCHAR (255) NOT NULL,
    idade INT NOT NULL,
    cpf VARCHAR (11) NOT NULL,
    email VARCHAR (255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Enderecos(
	id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    cep VARCHAR(50),
    cidade VARCHAR(50),
    rua VARCHAR(50),
    numero INT,
    ap INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES Clientes(id) ON DELETE CASCADE
);

DELIMITER //
CREATE PROCEDURE adicionar_cliente (IN nome_in VARCHAR(255), IN idade_in INT, IN cpf_in VARCHAR(11), IN email_in VARCHAR(255))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Clientes WHERE nome = nome_in) THEN
		INSERT INTO Clientes (nome, idade, cpf, email) 
		VALUES (nome_in, idade_in, cpf_in, email_in);
	END IF;
END //

CREATE PROCEDURE apagar_cliente (IN id_in INT)
BEGIN
	IF EXISTS (SELECT 1 FROM Clientes WHERE id = id_in) THEN
		DELETE FROM Clientes WHERE id = id_in;
	END IF;
END //

CREATE PROCEDURE atualizar_cliente (IN id_in INT, IN nome_in VARCHAR(255), IN idade_in INT, IN cpf_in VARCHAR(11), IN email_in VARCHAR(255))
BEGIN
	IF EXISTS (SELECT 1 FROM Clientes WHERE id = id_in) THEN
		UPDATE Clientes 
		SET nome = nome_in, idade = idade_in, cpf = cpf_in, email = email_in
		WHERE id = id_in;
	END IF;
END //

CREATE PROCEDURE ler_cliente (IN id_in INT)
BEGIN
	SELECT * FROM Clientes WHERE id = id_in;
END //

CREATE PROCEDURE ler_clientes ()
BEGIN
	SELECT * FROM Clientes;
END //

CREATE PROCEDURE adicionar_endereco (IN user_id_in INT, IN cep_in VARCHAR(50), IN cidade_in VARCHAR(50), IN rua_in VARCHAR(50), IN numero_in INT, IN ap_in INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Clientes INNER JOIN Enderecos ON Clientes.id = Enderecos.user_id WHERE Clientes.id = user_id_in AND Enderecos.cep = cep_in AND Enderecos.cidade = cidade_in AND Enderecos.rua = rua_in AND Enderecos.numero = numero_in AND Enderecos.ap = ap_in) THEN
		INSERT INTO Enderecos (user_id, cep, cidade, rua, numero, ap)
		SELECT id, cep_in, cidade_in, rua_in, numero_in, ap_in FROM Clientes WHERE id = user_id_in;
    END IF;
END //

CREATE PROCEDURE apagar_endereco (IN id_in INT)
BEGIN
	IF EXISTS (SELECT 1 FROM Enderecos WHERE id = id_in) THEN
		DELETE FROM Enderecos WHERE id = id_in;
    END IF;
END //

CREATE PROCEDURE ler_endereco (IN id_in INT)
BEGIN
	SELECT * FROM Enderecos WHERE id = id_in;
END // 

CREATE PROCEDURE ler_enderecos ()
BEGIN	
		SELECT * FROM Enderecos;
END //

CREATE PROCEDURE atualizar_endereco (IN id_in INT, IN cep_in VARCHAR(50), IN cidade_in VARCHAR(50), IN rua_in VARCHAR(50), IN numero_in INT, IN ap_in INT) 
BEGIN
	IF EXISTS (SELECT 1 FROM Enderecos WHERE id = id_in) THEN
		UPDATE Enderecos
        SET cep = cep_in, cidade = cidade_in, rua = rua_in, numero = numero_in, ap = ap_in
        WHERE id = id_in;
    END IF;
END //

DELIMITER ;