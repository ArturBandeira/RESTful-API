DROP DATABASE IF EXISTS db1;
CREATE DATABASE db1;
USE db1;

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Clientes;

CREATE TABLE Clientes(
    id INT AUTO_INCREMENT,
    nome VARCHAR (255) NOT NULL,
    idade INT NOT NULL,
    cpf VARCHAR (11) NOT NULL,
    email VARCHAR (255) NOT NULL,
    PRIMARY KEY (id)
);

DELIMITER //
CREATE PROCEDURE adicionar_cliente (IN nome_in VARCHAR(255), IN idade_in INT, IN cpf_in VARCHAR(11), IN email_in VARCHAR(255))
BEGIN
IF NOT EXISTS (SELECT 1 FROM Clientes WHERE nome = nome_in) THEN
INSERT INTO Clientes (nome, idade, cpf, email) 
VALUES (nome_in, idade_in, cpf_in, email_in);
END IF;
END //

CREATE PROCEDURE apagar_cliente (IN nome_in VARCHAR (11))
BEGIN
IF EXISTS (SELECT 1 FROM Clientes WHERE Clientes.nome = nome_in) THEN
DELETE FROM Clientes WHERE nome = nome_in;
END IF;
END //

CREATE PROCEDURE atualizar_cliente (IN nome_in VARCHAR(255), IN idade_in INT, IN cpf_in VARCHAR(11), IN email_in VARCHAR(255))
BEGIN
IF EXISTS (SELECT 1 FROM Clientes WHERE nome = nome_in) THEN
UPDATE Clientes 
SET idade = idade_in, cpf = cpf_in, email = email_in
WHERE nome = nome_in;
END IF;
END //

CREATE PROCEDURE ler_cliente (IN nome_in VARCHAR(255))
BEGIN
SELECT * FROM CLientes WHERE nome = nome_in;
END //
DELIMITER ;