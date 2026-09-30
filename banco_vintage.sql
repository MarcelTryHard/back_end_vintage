CREATE DATABASE IF NOT EXISTS trabalho_vintage CHARACTER SET utf8mb4;
USE trabalho_vintage;
 
CREATE TABLE IF NOT EXISTS conta (
  id_conta INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(30) NOT NULL UNIQUE,            -- RFN 01.01
  saldo DECIMAL(12,2) NOT NULL DEFAULT 0
) ENGINE=InnoDB;                                  -- RFN 03.01 (ACID)
 
CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,                -- RFN 01.01
  email VARCHAR(255),
  telefone VARCHAR(20),
  id_conta INT NOT NULL,
  FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS loja (
  id_loja INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  tipo ENUM('Física','Online') NOT NULL DEFAULT 'Física',
  endereco VARCHAR(255),
  id_conta INT NOT NULL,
  FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18) NOT NULL UNIQUE,               -- RN03
  email VARCHAR(255),
  telefone VARCHAR(20)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  tendencia TINYINT(1) NOT NULL DEFAULT 0,
  novidade TINYINT(1) NOT NULL DEFAULT 0,
  preco DECIMAL(10,2) NOT NULL,
  id_categoria INT NOT NULL,
  id_loja INT NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
  FOREIGN KEY (id_loja) REFERENCES loja(id_loja),
  INDEX idx_produto_categoria (id_categoria)      -- RFN 02.01
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  id_fornecedor INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
  FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS venda (
  id_venda INT AUTO_INCREMENT PRIMARY KEY,        -- RFN 04.01
  data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  valor_total DECIMAL(12,2) NOT NULL,
  canal VARCHAR(30) NOT NULL,
  status ENUM('ABERTA','CONCLUIDO') NOT NULL DEFAULT 'ABERTA',
  id_cliente INT NOT NULL,
  id_loja INT NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_loja) REFERENCES loja(id_loja)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS item_venda (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  id_produto INT NOT NULL,
  id_estoque INT NOT NULL,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
  FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
) ENGINE=InnoDB;
 
CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  forma ENUM('PIX','Cartão','Boleto') NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'CONCLUIDO',
  data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
) ENGINE=InnoDB;
 
-- Dados iniciais (opcionais)
INSERT IGNORE INTO conta (id_conta, numero) VALUES (1,'C-0001'),(2,'C-0002'),(3,'L-0001'),(4,'L-0002');
INSERT IGNORE INTO cliente VALUES (1,'João da Silva','123.456.789-00','joao@email.com','(41) 99999-1111',1),
 (2,'Maria Oliveira','987.654.321-00','maria@email.com','(41) 98888-2222',2);
INSERT IGNORE INTO loja VALUES (1,'Loja Centro','Física','Rua Principal, 100',3),(2,'OmniStore Online','Online','E-commerce',4);
INSERT IGNORE INTO categoria VALUES (1,'Eletrônicos','Produtos eletrônicos'),(2,'Acessórios','Acessórios diversos'),(3,'Informática','Produtos de informática');
INSERT IGNORE INTO fornecedor VALUES (1,'Fornecedor Exemplo LTDA','12.345.678/0001-00','contato@fornecedor.com','(41) 3333-4444');
INSERT IGNORE INTO produto VALUES (1,'Mouse sem fio',1,0,79.90,3,1),(2,'Teclado mecânico',1,1,199.90,3,1),(3,'Fone Bluetooth',0,1,129.90,2,2);
INSERT IGNORE INTO estoque VALUES (1,1,1,15),(2,2,1,4),(3,3,1,8);

USE trabalho_vintage;

CREATE TABLE IF NOT EXISTS usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  login VARCHAR(50) NOT NULL UNIQUE,
  senha_hash VARCHAR(200) NOT NULL,
  perfil ENUM('ADMIN','OPERADOR','CLIENTE') NOT NULL,
  id_cliente INT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;



CREATE TABLE IF NOT EXISTS conta (
  id_conta INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(30) NOT NULL UNIQUE,            
  saldo DECIMAL(12,2) NOT NULL DEFAULT 0
) ENGINE=InnoDB;                                  

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,               
  email VARCHAR(255),
  telefone VARCHAR(20),
  id_conta INT NOT NULL,
  FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS loja (
  id_loja INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  tipo ENUM('Física','Online') NOT NULL DEFAULT 'Física',
  endereco VARCHAR(255),
  id_conta INT NOT NULL,
  FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18) NOT NULL UNIQUE,              
  email VARCHAR(255),
  telefone VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  tendencia TINYINT(1) NOT NULL DEFAULT 0,
  novidade TINYINT(1) NOT NULL DEFAULT 0,
  preco DECIMAL(10,2) NOT NULL,
  id_categoria INT NOT NULL,
  id_loja INT NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
  FOREIGN KEY (id_loja) REFERENCES loja(id_loja),
  INDEX idx_produto_categoria (id_categoria)     
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  id_fornecedor INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
  FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS venda (
  id_venda INT AUTO_INCREMENT PRIMARY KEY,        
  data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  valor_total DECIMAL(12,2) NOT NULL,
  canal VARCHAR(30) NOT NULL,
  status ENUM('ABERTA','CONCLUIDO') NOT NULL DEFAULT 'ABERTA',
  id_cliente INT NOT NULL,
  id_loja INT NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_loja) REFERENCES loja(id_loja)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS item_venda (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  id_produto INT NOT NULL,
  id_estoque INT NOT NULL,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
  FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  forma ENUM('PIX','Cartão','Boleto') NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'CONCLUIDO',
  data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
) ENGINE=InnoDB;

SHOW COLUMNS FROM cliente LIKE 'id_conta';
DESCRIBE cliente;



INSERT INTO conta (numero)
SELECT CONCAT('C-MIG-', id_cliente) FROM cliente WHERE id_conta IS NULL;

UPDATE cliente
SET id_conta = (SELECT id_conta FROM conta WHERE numero = CONCAT('C-MIG-', cliente.id_cliente))
WHERE id_conta IS NULL;

USE trabalho_vintage;

ALTER TABLE usuario
MODIFY COLUMN perfil ENUM(
    'ADMIN',
    'OPERADOR',
    'VENDEDOR',
    'LOJISTA',
    'CLIENTE'
) NOT NULL;




