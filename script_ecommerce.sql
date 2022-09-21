CREATE DATABASE ecommerce;

-- conectando utilizando PostgreSQL
\c ecommerce;

/*
-- MySQL
use ecommerce;
*/

-- criação de enums no SGBD PostgreSQL
CREATE TYPE cpf_cnpj AS ENUM ('cpf', 'cnpj');
CREATE TYPE enum_pagamento AS ENUM('boleto', 'credit');
CREATE TYPE enum_status_pedido AS ENUM('pendente', 'em andamento', 'finalizado');
CREATE TYPE enum_status_entrega AS ENUM('pendente', 'entregue');

/* COMANDOS DDL */

CREATE TABLE cliente(
	/*
	-- MySQL
	id_cliente BIGINT auto_increment PRIMARY KEY,
	*/
	id_cliente BIGSERIAL PRIMARY KEY,
	identificacao VARCHAR(14) UNIQUE NOT NULL,
	tipo_identificacao cpf_cnpj NOT NULL,
	/*
	-- MySQL
	tipo_identificacao ENUM('cpf', 'cnpj') NOT NULL,
	*/
	nome VARCHAR(45) NOT NULL,
	sobrenome VARCHAR(120),
	endereco VARCHAR(150) NOT NULL
);


CREATE TABLE forma_pagamento(
	id_forma_pagamento BIGSERIAL PRIMARY KEY,
	identificacao VARCHAR(45) UNIQUE NOT NULL,
	tipo_pagamento enum_pagamento NOT NULL,
	id_cliente BIGINT REFERENCES cliente(id_cliente) ON DELETE CASCADE
);


CREATE TABLE entrega(
	id_entrega BIGSERIAL PRIMARY KEY,
	status_entrega enum_status_entrega NOT NULL,
	codigo_rastreio CHAR(10) UNIQUE NOT NULL,
	destino VARCHAR(120) NOT NULL
);


CREATE TABLE pedido(
	id_pedido BIGSERIAL PRIMARY KEY,
	status_pedido enum_status_pedido NOT NULL DEFAULT 'pendente',
	frete FLOAT NOT NULL DEFAULT 0,
	id_cliente BIGINT NOT NULL REFERENCES cliente(id_cliente) ON DELETE CASCADE,
	id_entrega BIGINT NOT NULL REFERENCES entrega(id_entrega) ON DELETE CASCADE,
	id_forma_pagamento BIGINT NOT NULL REFERENCES forma_pagamento(id_forma_pagamento) ON DELETE CASCADE,
	UNIQUE(id_cliente, id_entrega)
);


CREATE TABLE produto(
	codigo_produto CHAR(12) UNIQUE NOT NULL,
	descricao VARCHAR(150),
	categoria VARCHAR(20),
	valor FLOAT DEFAULT 0,
	PRIMARY KEY(codigo_produto)
);

CREATE TABLE pedido_possui_produto(
	codigo_produto CHAR(12) REFERENCES produto(codigo_produto) ON DELETE CASCADE,
	id_pedido BIGINT REFERENCES pedido(id_pedido) ON DELETE CASCADE,
	quantidade_produto INT NOT NULL DEFAULT 1,
	PRIMARY KEY(codigo_produto, id_pedido)
);

CREATE TABLE estoque(
	id_estoque BIGSERIAL PRIMARY KEY,
 	local_estoque VARCHAR(60) NOT NULL,
	capacidade INT NOT NULL
);

CREATE TABLE estoque_possui_produto(
	codigo_produto CHAR(12) REFERENCES produto(codigo_produto) ON DELETE CASCADE,
	id_estoque BIGINT REFERENCES estoque(id_estoque) ON DELETE CASCADE,
	quantidade_produto INT NOT NULL DEFAULT 0,
	PRIMARY KEY(codigo_produto, id_estoque)
);

CREATE TABLE fornecedor(
	cnpj_fornecedor CHAR(14) UNIQUE NOT NULL,
	razao_social VARCHAR(45) NOT NULL,
	terceirizado BOOLEAN DEFAULT false,
	endereco VARCHAR(150),
	PRIMARY KEY(cnpj_fornecedor)
);

CREATE TABLE fornecedor_disponibiliza_produto(
	cnpj_fornecedor CHAR(14) REFERENCES fornecedor(cnpj_fornecedor) ON DELETE CASCADE,
	codigo_produto CHAR(12) REFERENCES produto(codigo_produto) ON DELETE CASCADE,
	quantidade_produto INT NOT NULL DEFAULT 0,
	PRIMARY KEY(cnpj_fornecedor, codigo_produto)
);

/* COMANDOS DML */

INSERT INTO cliente(identificacao, tipo_identificacao, nome, sobrenome, endereco)
VALUES
('00000000001', 'cpf', 'Trevor', 'Philips', 'Sandy Shore'),
('00000000002', 'cpf', 'Abigail', 'Mathers', 'Los Santos'),
('00000000003', 'cpf', 'Jonathan', 'Klebitz', 'Sandy Shore'),
('00000000004', 'cpf', 'Berverly', 'Felton', 'Los Santos'),
('00000000005', 'cpf', 'Bradley', 'Snider', 'Ludendorff'),
('00000000006', 'cpf', 'Karen', 'Daniels', 'Liberty City'),
('00000000007', 'cpf', 'Kyle', 'Chavis', 'Los Santos'),
('00000000008', 'cpf', 'Taliana', 'Martinez', 'Blaine Country'),
('00000000009', 'cpf', 'James', 'De Santa', 'Los Santos'),
('00000000010', 'cpf', 'Tanisha', 'Jackson', 'Los Santos'),
('00000000011', 'cpf', 'Hugh', 'Welsh', 'Paleto Bay'),
('00000000012', 'cpf', 'Siemon', 'Yetarian', 'Paleto Bay'),
('00000000013', 'cpf', 'Sacha', 'Yetarian', 'Paleto Bay'),
('00000000014', 'cpf', 'Franklin', 'Clinton', 'Los Santos'),
('00000000015', 'cpf', 'Patricia', 'Madrazo', 'North Yankton'),
('00000000016', 'cpf', 'Miguel', 'Madrazo', 'North Yankton'),
('00000000017', 'cpf', 'Martin', 'Madrazo', 'Los Santos'),
('00000000018', 'cpf', 'Maude', 'Eccles', 'Sandy Shore'),
('00000000019', 'cpf', 'David', 'Norton', 'Liberty City'),
('00000000020', 'cpf', 'Natalia', 'Zverovna', 'Liberty City'),
('00000000021', 'cpf', 'Paige', 'Harris', 'North Yankton'),
('00000000022', 'cpf', 'Chris', 'Formage', 'Paleto Bay'),
('00000000023', 'cpf', 'Cletus', 'Ewing', 'Sandy Shores');

INSERT INTO cliente(identificacao, tipo_identificacao, nome, endereco)
VALUES
('10000000000000', 'cnpj', 'Empresa X', 'Los Santos'),
('20000000000000', 'cnpj', 'Empresa Y', 'Liberty City'),
('30000000000000', 'cnpj', 'Empresa Z', 'Sandy Shores');

INSERT INTO produto(codigo_produto, descricao, categoria, valor)
VALUES
('012345678901', 'Teclado Mecânico', 'informática', 289.90),
('012345678902', 'Mouse Gamer', 'informática', 94.99),
('012345678903', 'Geladeira', 'eletrodomésticos', 2109.99),
('012345678904', 'Lava Louças', 'eletrodomésticos', 1410.15),
('012345678905', 'Cooktop', 'eletrodomésticos', 709.90);

INSERT INTO fornecedor(cnpj_fornecedor, razao_social, terceirizado, endereco)
VALUES
('************01', 'Fornecedor A', false, 'Los Santos'),
('************02', 'Fornecedor B', false, 'Sandy Shores'),
('************03', 'Fornecedor C', true, 'Cayo Perico Island');

/*

# Simulação

## Produtos

- Teclado Mecânico, Mouse Gamer disponibilizado pelo Fornecedor A
- Geladeira, Lava Louças disponibilizado pelo Fornecedor B
- Cooktop disponibilizado pelo Fornecedor C (terceirizado)

## Clientes / Pedido

### ID 1 - Trevor Philips

- Possui como forma de pagamento boleto e dois cartões;
- Comprou uma Geladeira, uma Lava Louças e um Cooktop utilizando o segundo cartão;
- O destino da entrega é Sandy Shore.

### ID 6 - Karen Daniels

- Possui como forma de pagamento cartão e boleto;
- Comprou um cooktop utilizando boleto;
- O destino da entrega é Liberty City.

### ID 12 - Siemon Yetarian

- Possui como forma de pagamento cartão;
- Comprou dois Teclados Mecânico utilizando cartão;
- O destino da entrega é Liberty City.

*/

INSERT INTO fornecedor_disponibiliza_produto(cnpj_fornecedor, codigo_produto, quantidade_produto)
VALUES
('************01', '012345678901', 51),
('************01', '012345678902', 30),
('************02', '012345678903', 27),
('************02', '012345678904', 12),
('************03', '012345678905', 8);

INSERT INTO forma_pagamento(identificacao, tipo_pagamento, id_cliente)
VALUES
/* Trevor */
('12345601', 'boleto', 1),
('12345602', 'credit', 1),
('12345603', 'credit', 1),
/* Karen */
('12345604', 'credit', 6),
('12345605', 'boleto', 6),
/* Siemon */
('12345606', 'credit', 12);

INSERT INTO entrega(status_entrega, codigo_rastreio, destino)
VALUES
('pendente', '1234567890', 'Sandy Shore'),
('entregue', '1234567891', 'Liberty City'),
('pendente', '1234567892', 'Liberty City');

INSERT INTO pedido(status_pedido, frete, id_cliente, id_entrega, id_forma_pagamento)
VALUES
('pendente', 3.14, 4, 1, 3),
('finalizado', 15.99, 6, 2, 5),
('em andamento', 30.99, 12, 3, 6);

INSERT INTO pedido_possui_produto(codigo_produto, id_pedido, quantidade_produto)
VALUES
('012345678903', 1, 1),
('012345678904', 1, 1),
('012345678905', 1, 1),
('012345678905', 2, 1),
('012345678901', 3, 2);

/* COMANDOS DQL */

-- Mostrando o nome dos clientes em ordem descendente
SELECT nome FROM cliente ORDER BY nome DESC;

-- Quais produtos pertencem a categoria informática?
SELECT descricao AS "Description" FROM produto WHERE categoria = 'informática';

-- Quantos produtos há na categoria eletrodomésticos?
SELECT COUNT(*) AS total_de_produtos FROM produto WHERE categoria = 'eletrodomésticos';

-- Quais categorias de produto possuem uma média de preço menor que 1000?
SELECT categoria, COUNT(*) AS total_de_produtos
FROM produto
GROUP BY categoria
HAVING AVG(valor) < 1000;

-- Qual cliente finalizou o pedido com sucesso?
SELECT nome, sobrenome
FROM cliente
WHERE id_cliente = (SELECT id_cliente FROM pedido WHERE status_pedido = 'finalizado');

-- Junção entre tabelas
SELECT * FROM produto
JOIN fornecedor_disponibiliza_produto
ON produto.codigo_produto = fornecedor_disponibiliza_produto.codigo_produto;