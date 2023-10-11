CREATE OR REPLACE PACKAGE pkg_produto
AS
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE decrementar_estoque(p_id_produto   IN produto.id_produto%TYPE,
                                p_quantidade   IN INTEGER);

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE incrementar_estoque(p_id_produto   IN produto.id_produto%TYPE,
                                p_quantidade   IN INTEGER);

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION get_preco(p_id_produto IN produto.id_produto%TYPE)
    RETURN produto.preco%TYPE;
END pkg_produto;
/
SHOW ERRORS PACKAGE pkg_produto


CREATE OR REPLACE PACKAGE BODY pkg_produto
AS
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE decrementar_estoque(p_id_produto   IN produto.id_produto%TYPE,
                                p_quantidade   IN INTEGER)
  AS
    v_nova_qtd_estoque   produto.qtd_estoque%TYPE;
  BEGIN
    UPDATE produto p
       SET p.qtd_estoque = p.qtd_estoque - p_quantidade
     WHERE p.id_produto = p_id_produto
    RETURN p.qtd_estoque
      INTO v_nova_qtd_estoque;

    IF v_nova_qtd_estoque < 0 THEN
      RAISE_APPLICATION_ERROR(-20000, 'Estoque insuficiente');
    END IF;
  END decrementar_estoque;
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE incrementar_estoque(p_id_produto   IN produto.id_produto%TYPE,
                                p_quantidade   IN INTEGER)
  AS
  BEGIN
    UPDATE produto p
       SET p.qtd_estoque = p.qtd_estoque + p_quantidade
     WHERE p.id_produto = p_id_produto;
  END incrementar_estoque;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION get_preco(p_id_produto IN produto.id_produto%TYPE)
    RETURN produto.preco%TYPE
  AS
    v_preco   produto.preco%TYPE;
  BEGIN
    SELECT p.preco
      INTO v_preco
      FROM produto p
     WHERE p.id_produto = p_id_produto;
    
    RETURN v_preco;
  END get_preco;
END pkg_produto;
/
SHOW ERRORS PACKAGE BODY pkg_produto
