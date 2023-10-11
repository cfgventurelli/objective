CREATE OR REPLACE PACKAGE pkg_pedido_status
AS
  EM_PROCESSAMENTO   CONSTANT pedido_status.id_pedido_status%TYPE := POWER(2, 0);
  ENTREGUE           CONSTANT pedido_status.id_pedido_status%TYPE := POWER(2, 1);
  CANCELADO          CONSTANT pedido_status.id_pedido_status%TYPE := POWER(2, 2);
END pkg_pedido_status;
/
SHOW ERRORS PACKAGE pkg_pedido_status
