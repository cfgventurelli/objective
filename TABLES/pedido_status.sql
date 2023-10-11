CREATE TABLE pedido_status
(
  id_pedido_status   INTEGER,
  nome               VARCHAR2(30) NOT NULL,
  CONSTRAINT pedido_status_pk PRIMARY KEY (id_pedido_status)
)
ORGANIZATION INDEX
/

COMMENT ON TABLE pedido_status IS 'Armazena todos os status do pedidos'
/
COMMENT ON COLUMN pedido_status.id_pedido_status IS 'Indentificador unico do status'
/
COMMENT ON COLUMN pedido_status.nome IS 'Nome do status'
/

INSERT ALL
  INTO pedido_status (id_pedido_status, nome) VALUES (POWER(2, 0), 'EM PROCESSAMENTO')
  INTO pedido_status (id_pedido_status, nome) VALUES (POWER(2, 1), 'ENTREGUE')
  INTO pedido_status (id_pedido_status, nome) VALUES (POWER(2, 2), 'CANCELADO')
SELECT *
  FROM dual;
COMMIT;
