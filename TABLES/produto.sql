CREATE TABLE produto
(
  id_produto    INTEGER GENERATED ALWAYS AS IDENTITY,
  nome          VARCHAR2(100) NOT NULL,
  descricao     VARCHAR2(300),
  preco         NUMBER NOT NULL,
  qtd_estoque   NUMBER NOT NULL
)
/

CREATE UNIQUE INDEX produto_pk ON produto (id_produto)
/

ALTER TABLE produto
  ADD CONSTRAINT produto_pk PRIMARY KEY (id_produto)
USING INDEX produto_pk
/

COMMENT ON TABLE produto IS 'Armazena todos os produtos'
/
COMMENT ON COLUMN produto.id_produto IS 'Indentificador unico do produto'
/
COMMENT ON COLUMN produto.nome IS 'Nome do produto'
/
COMMENT ON COLUMN produto.descricao IS 'Descrição do produto'
/
COMMENT ON COLUMN produto.preco IS 'Preço de venda do produto'
/
COMMENT ON COLUMN produto.qtd_estoque IS 'Quantidade atual do produto em estoque'
/
