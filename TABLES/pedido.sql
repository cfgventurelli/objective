CREATE TABLE pedido
(
  id_pedido          INTEGER GENERATED ALWAYS AS IDENTITY,
  id_cliente         INTEGER NOT NULL,
  id_produto         INTEGER NOT NULL,
  data_pedido        DATE NOT NULL,
  quantidade         NUMBER NOT NULL,
  id_pedido_status   INTEGER NOT NULL,
  valor_total        NUMBER NOT NULL
)
/

CREATE UNIQUE INDEX pedido_pk ON pedido (id_pedido)
/
CREATE INDEX pedido_fk1 ON pedido (id_cliente)
/
CREATE INDEX pedido_fk2 ON pedido (id_produto)
/
CREATE BITMAP INDEX pedido_fk3 ON pedido (id_pedido_status)
/

ALTER TABLE pedido
  ADD (CONSTRAINT pedido_pk PRIMARY KEY (id_pedido) USING INDEX pedido_pk,
       CONSTRAINT pedido_fk1 FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
       CONSTRAINT pedido_fk2 FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
       CONSTRAINT pedido_fk3 FOREIGN KEY (id_pedido_status) REFERENCES pedido_status (id_pedido_status))
/

COMMENT ON TABLE pedido IS 'Armazena todos os pedidos'
/
COMMENT ON COLUMN pedido.id_pedido IS 'Indentificador unico do pedido'
/
COMMENT ON COLUMN pedido.id_cliente IS 'Identificador do cliente'
/
COMMENT ON COLUMN pedido.id_produto IS 'Identificador do produto'
/
COMMENT ON COLUMN pedido.data_pedido IS 'Data do pedido'
/
COMMENT ON COLUMN pedido.quantidade IS 'Quantidade do produto no pedido'
/
COMMENT ON COLUMN pedido.id_pedido_status IS 'Status do pedido'
/
COMMENT ON COLUMN pedido.valor_total IS 'Valor total do pedido'
/
