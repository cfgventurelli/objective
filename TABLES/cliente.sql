CREATE TABLE cliente
(
  id_cliente   INTEGER GENERATED ALWAYS AS IDENTITY,
  nome         VARCHAR2(100) NOT NULL,
  endereco     VARCHAR2(300),
  email        VARCHAR2(100),
  telefone     VARCHAR2(14)
)
/

CREATE UNIQUE INDEX cliente_pk ON cliente (id_cliente)
/

ALTER TABLE cliente
  ADD CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
USING INDEX cliente_pk
/

COMMENT ON TABLE cliente IS 'Armazena todos os clientes'
/
COMMENT ON COLUMN cliente.id_cliente IS 'Indentificador unico do cliente'
/
COMMENT ON COLUMN cliente.nome IS 'Nome do cliente'
/
COMMENT ON COLUMN cliente.endereco IS 'Endereço do cliente'
/
COMMENT ON COLUMN cliente.email IS 'Email de contato do cliente'
/
COMMENT ON COLUMN cliente.telefone IS 'Telefone de contato do cliente'
/
