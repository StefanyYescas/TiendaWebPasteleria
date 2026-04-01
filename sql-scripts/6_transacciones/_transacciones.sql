Drop Procedure completoPedido;
-- Procedimiento y transaccion --
select * from Pedido;
DELIMITER $$

CREATE PROCEDURE completoPedido(
    IN p_usuario_ID INT,
    IN p_nombre_cliente VARCHAR(100),
    IN p_apellido_cliente VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(255),
    IN p_tipo_entrega ENUM('local', 'domicilio'),
    IN p_direccion_entrega VARCHAR(255),
    IN p_tipo_pago ENUM('transferencia', 'efectivo'),
    IN p_estado ENUM('pendiente', 'listo'),  -- nuevo parámetro
    IN productos_json JSON  -- JSON con lista de productos: [{"producto_ID":1,"cantidad":2},...]
)
BEGIN
    DECLARE v_cliente_ID INT;
    DECLARE v_pedido_ID INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_producto_ID INT;
    DECLARE v_cantidad INT;
    
    DECLARE cur CURSOR FOR
        SELECT producto_ID, cantidad FROM JSON_TABLE(productos_json, '$[*]' COLUMNS (
            producto_ID INT PATH '$.producto_ID',
            cantidad INT PATH '$.cantidad'
        )) AS jt;
     
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
     
    -- Manejador para errores que haga rollback y termine el procedimiento
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL; -- Para propagar el error a quien llame el procedimiento
    END;

    START TRANSACTION;

    -- Insertar cliente
    CALL insertarCliente(p_usuario_ID, p_nombre_cliente, p_apellido_cliente, p_telefono, p_direccion, v_cliente_ID);

    -- Insertar pedido con estado
    CALL insertarPedido(v_cliente_ID, p_tipo_entrega, p_direccion_entrega, p_tipo_pago, p_estado, v_pedido_ID);

    -- Insertar productos
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_producto_ID, v_cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL insertarProducto(v_pedido_ID, v_producto_ID, v_cantidad);
    END LOOP;
    CLOSE cur;

    COMMIT;

    -- Devolver IDs para confirmar éxito
    SELECT v_cliente_ID AS cliente_ID, v_pedido_ID AS pedido_ID;

END $$

DELIMITER ;

-- Completo Compra --
-- Procedimiento completoCompra corregido --
DELIMITER $$

CREATE PROCEDURE completoCompra(
    IN p_nombre_proveedor VARCHAR(100),
    IN p_apellido_proveedor VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_metodo_pago ENUM('transferencia', 'efectivo'),
    IN p_fecha DATETIME,
    IN productos_json JSON  -- [{"producto_ID":1,"cantidad":10,"precio_prove":45.00},...]
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_producto_ID INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio_prove DECIMAL(10,2);
    DECLARE v_proveedor_ID INT;
    DECLARE v_compra_ID INT;

    DECLARE cur CURSOR FOR
        SELECT producto_ID, cantidad, precio_prove
        FROM JSON_TABLE(productos_json, '$[*]' COLUMNS (
            producto_ID INT PATH '$.producto_ID',
            cantidad INT PATH '$.cantidad',
            precio_prove DECIMAL(10,2) PATH '$.precio_prove'
        )) AS jt;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Usa variables de sesión para capturar IDs OUT
    CALL insertarProveedor(p_nombre_proveedor, p_apellido_proveedor, p_correo, p_telefono, p_direccion, @prov_id);
    SELECT @prov_id INTO v_proveedor_ID;

    CALL insertarCompra(v_proveedor_ID, p_metodo_pago, p_fecha, @compra_id);
    SELECT @compra_id INTO v_compra_ID;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_producto_ID, v_cantidad, v_precio_prove;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL insertarProCompra(v_compra_ID, v_producto_ID, v_precio_prove, v_cantidad);
    END LOOP;
    CLOSE cur;

    COMMIT;

    SELECT v_proveedor_ID AS proveedor_ID, v_compra_ID AS compra_ID;

END $$

DELIMITER ;
