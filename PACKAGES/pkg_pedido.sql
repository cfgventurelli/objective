CREATE OR REPLACE PACKAGE pkg_pedido
AS
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE criar_pedido(p_id_cliente    IN     pedido.id_cliente%TYPE,
                         p_id_produto    IN     pedido.id_produto%TYPE,
                         p_data_pedido   IN     pedido.data_pedido%TYPE,
                         p_quantidade    IN     pedido.quantidade%TYPE,
                         p_id_pedido        OUT pedido.id_pedido%TYPE);

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE atualizar_pedido(p_id_pedido     IN pedido.id_pedido%TYPE,
                             p_id_produto    IN pedido.id_produto%TYPE,
                             p_data_pedido   IN pedido.data_pedido%TYPE,
                             p_quantidade    IN pedido.quantidade%TYPE);

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION calcular_total_pedido(p_id_pedido IN pedido.id_pedido%TYPE)
    RETURN pedido.valor_total%TYPE;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE cancelar_pedido(p_id_pedido IN pedido.id_pedido%TYPE);

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION historico_pedidos_cliente(p_id_cliente IN pedido.id_cliente%TYPE)
    RETURN CLOB;
END pkg_pedido;
/
SHOW ERRORS PACKAGE pkg_pedido


CREATE OR REPLACE PACKAGE BODY pkg_pedido
AS
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE criar_pedido(p_id_cliente    IN     pedido.id_cliente%TYPE,
                         p_id_produto    IN     pedido.id_produto%TYPE,
                         p_data_pedido   IN     pedido.data_pedido%TYPE,
                         p_quantidade    IN     pedido.quantidade%TYPE,
                         p_id_pedido        OUT pedido.id_pedido%TYPE)
  AS
  BEGIN
    pkg_produto.decrementar_estoque(p_id_produto => p_id_produto,
                                    p_quantidade => p_quantidade);

    INSERT
      INTO pedido p (p.id_cliente,
                     p.id_produto,
                     p.data_pedido,
                     p.quantidade,
                     p.id_pedido_status,
                     p.valor_total)
    VALUES (p_id_cliente,
            p_id_produto,
            p_data_pedido,
            p_quantidade,
            pkg_pedido_status.EM_PROCESSAMENTO,
            p_quantidade * pkg_produto.get_preco(p_id_produto))
    RETURN p.id_pedido
      INTO p_id_pedido;
  END criar_pedido;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE atualizar_pedido(p_id_pedido     IN pedido.id_pedido%TYPE,
                             p_id_produto    IN pedido.id_produto%TYPE,
                             p_data_pedido   IN pedido.data_pedido%TYPE,
                             p_quantidade    IN pedido.quantidade%TYPE)
  AS
    v_old_id_produto   pedido.id_produto%TYPE;
    v_old_quantidade   pedido.quantidade%TYPE;
  BEGIN
    pkg_produto.decrementar_estoque(p_id_produto => p_id_produto,
                                    p_quantidade => p_quantidade);

    SELECT p.id_produto
          ,p.quantidade
      INTO v_old_id_produto
          ,v_old_quantidade
      FROM pedido p
     WHERE p.id_pedido = p_id_pedido;

    pkg_produto.incrementar_estoque(p_id_produto => v_old_id_produto,
                                    p_quantidade => v_old_quantidade);

    UPDATE pedido p
       SET p.id_produto  = p_id_produto,
           p.data_pedido = p_data_pedido,
           p.quantidade  = p_quantidade,
           p.valor_total = p_quantidade * pkg_produto.get_preco(p_id_produto)
     WHERE p.id_pedido   = p_id_pedido;
  END atualizar_pedido;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION calcular_total_pedido(p_id_pedido IN pedido.id_pedido%TYPE)
    RETURN pedido.valor_total%TYPE
  AS
    v_valor_total   pedido.valor_total%TYPE;
  BEGIN
    SELECT p.valor_total
      INTO v_valor_total
      FROM pedido p
     WHERE p.id_pedido = p_id_pedido;

    RETURN v_valor_total;
  END calcular_total_pedido;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  PROCEDURE cancelar_pedido(p_id_pedido IN pedido.id_pedido%TYPE)
  AS
    v_id_produto   pedido.id_produto%TYPE;
    v_quantidade   pedido.quantidade%TYPE;
  BEGIN
    UPDATE pedido p
       SET p.id_pedido_status = pkg_pedido_status.CANCELADO
     WHERE p.id_pedido     = p_id_pedido
    RETURN p.id_produto
          ,p.quantidade
      INTO v_id_produto
          ,v_quantidade;

    pkg_produto.incrementar_estoque(p_id_produto => v_id_produto,
                                    p_quantidade => v_quantidade);
  END cancelar_pedido;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  FUNCTION historico_pedidos_cliente(p_id_cliente IN pedido.id_cliente%TYPE)
    RETURN CLOB
  AS
    v_pedido    JSON_OBJECT_T;
    v_pedidos   JSON_ARRAY_T;
    v_payload   JSON_OBJECT_T;
  BEGIN
    v_pedidos := NEW JSON_ARRAY_T();
    FOR reg
     IN (SELECT p.id_pedido     AS id_pedido
               ,p.data_pedido   AS data_pedido
               ,ps.nome         AS pedido_status
               ,p.valor_total   AS valor_total
           FROM pedido p
           JOIN pedido_status ps ON ps.id_pedido_status = p.id_pedido_status
          WHERE p.id_cliente = p_id_cliente
          ORDER BY p.data_pedido)
    LOOP
      v_pedido := NEW JSON_OBJECT_T();
      v_pedido.put('idPedido', reg.id_pedido);
      v_pedido.put('dataPedido', reg.data_pedido);
      v_pedido.put('pedidoStatus', reg.pedido_status);
      v_pedido.put('valorTotal', reg.valor_total);

      v_pedidos.append(v_pedido);
    END LOOP;

    v_payload := NEW JSON_OBJECT_T();
    v_payload.put('idCliente', p_id_cliente);
    v_payload.put('pedidos', v_pedidos);

    RETURN v_payload.to_string();
  END historico_pedidos_cliente;
END pkg_pedido;
/
SHOW ERRORS PACKAGE BODY pkg_pedido
