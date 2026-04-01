
-- Crear Cuenta --
DELIMITER //

CREATE PROCEDURE creaarCuenta (
  IN p_nombre_usuario VARCHAR(30),
  IN p_correo VARCHAR(100),
  IN p_contraseña VARCHAR(255),
  IN p_rol VARCHAR(50)
)
BEGIN
  -- Verificar si ya existe un usuario con ese correo o nombre de usuario
  IF EXISTS (
    SELECT 1 FROM Usuario 
    WHERE correo = p_correo OR nombre_usuario = p_nombre_usuario
  ) THEN
    -- Si el usuario o correo ya existe, lanzar un error
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El nombre de usuario o correo ya están registrados';
  ELSE
    -- Si no existe, insertar el nuevo usuario
    INSERT INTO Usuario (nombre_usuario, correo, contraseña, rol)
    VALUES (p_nombre_usuario, p_correo, p_contraseña, p_rol);
  END IF;
END //

DELIMITER ;

-- Insertar Cliente --
DELIMITER $$

CREATE PROCEDURE insertarCliente(
    IN p_usuario_ID INT,
    IN p_nombre_cliente VARCHAR(100),
    IN p_apellido_cliente VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(255),
    OUT p_cliente_ID INT
)
BEGIN
    -- Insertar nuevo registro de cliente
    INSERT INTO Cliente (usuario_ID, nombre_cliente, apellido_cliente, telefono, direccion)
    VALUES (p_usuario_ID, p_nombre_cliente, p_apellido_cliente, p_telefono, p_direccion);

    -- Devolver el nuevo cliente_ID
    SET p_cliente_ID = LAST_INSERT_ID();
END $$

DELIMITER ;


DELIMITER $$
 -- Nuevo indesrtar Pedido --
 DELIMITER $$

CREATE PROCEDURE insertarPedido (
    IN p_cliente_ID INT,
    IN p_tipo_entrega ENUM('local', 'domicilio'),
    IN p_direccion_entrega VARCHAR(255),
    IN p_tipo_pago ENUM('transferencia', 'efectivo'),
    IN p_estado ENUM('pendiente', 'listo'),
    OUT p_pedido_ID INT
)
BEGIN
    INSERT INTO Pedido (cliente_ID, tipo_entrega, direccion_entrega, tipo_pago, estado)
    VALUES (
        p_cliente_ID,
        p_tipo_entrega,
        IF(p_tipo_entrega = 'domicilio', p_direccion_entrega, NULL),
        p_tipo_pago,
        p_estado
    );

    SET p_pedido_ID = LAST_INSERT_ID();
END $$

DELIMITER ;


-- Insertar (Detalle_Pedido) Producto --
DELIMITER //

CREATE PROCEDURE insertarProducto (
    IN p_pedido_ID INT,
    IN p_producto_ID INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE precio_unitario DECIMAL(10,2);

    -- Obtener precio actual del producto
    SELECT precio INTO precio_unitario
    FROM Producto
    WHERE producto_ID = p_producto_ID;

    -- Insertar en Detalle_Pedido con ese precio
    INSERT INTO Detalle_Pedido (pedido_ID, producto_ID, cantidad, precio_unitario)
    VALUES (p_pedido_ID, p_producto_ID, p_cantidad, precio_unitario);
END //

DELIMITER ;

-- CRUD DE categoriasCrudController --
DELIMITER $$

CREATE PROCEDURE sp_crearCategoria (
  IN p_nombre VARCHAR(50),
  IN p_descripcion TEXT
)
BEGIN
  INSERT INTO Categoria (nombre_categoria, descripcion)
  VALUES (p_nombre, p_descripcion);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE crearCategoria (
  IN p_nombre VARCHAR(50),
  IN p_descripcion TEXT
)
BEGIN
  INSERT INTO Categoria (nombre_categoria, descripcion)
  VALUES (p_nombre, p_descripcion);
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_obtenerCategorias ()
BEGIN
  SELECT * FROM Categoria;
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_editarCategoria (
  IN p_id INT,
  IN p_nombre VARCHAR(50),
  IN p_descripcion TEXT
)
BEGIN
  UPDATE Categoria
  SET nombre_categoria = p_nombre,
      descripcion = p_descripcion
  WHERE categoria_ID = p_id;
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_eliminarCategoria (
  IN p_id INT
)
BEGIN
  DELETE FROM Categoria WHERE categoria_ID = p_id;
END $$

DELIMITER ;

-- CRUD de productosController --
DELIMITER $$

CREATE PROCEDURE sp_crearProducto (
  IN p_categoria_ID INT,
  IN p_nombre_producto VARCHAR(100),
  IN p_descripcion TEXT,
  IN p_precio DECIMAL(10,2),
  IN p_stock INT,
  IN p_imagen_url VARCHAR(255)
)
BEGIN
  INSERT INTO Producto (
    categoria_ID,
    nombre_producto,
    descripcion,
    precio,
    stock,
    imagen_url
  )
  VALUES (
    p_categoria_ID,
    p_nombre_producto,
    p_descripcion,
    p_precio,
    p_stock,
    p_imagen_url
  );
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_obtenerProductos()
BEGIN
  SELECT * FROM producto;  
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_editarProducto (
  IN p_producto_ID INT,
  IN p_categoria_ID INT,
  IN p_nombre_producto VARCHAR(100),
  IN p_descripcion TEXT,
  IN p_precio DECIMAL(10,2),
  IN p_stock INT,
  IN p_imagen_url VARCHAR(255)
)
BEGIN
  UPDATE Producto
  SET 
    categoria_ID = p_categoria_ID,
    nombre_producto = p_nombre_producto,
    descripcion = p_descripcion,
    precio = p_precio,
    stock = p_stock,
    imagen_url = p_imagen_url
  WHERE producto_ID = p_producto_ID;
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_eliminarProducto (
  IN p_producto_ID INT
)
BEGIN
  DELETE FROM Producto WHERE producto_ID = p_producto_ID;
END $$

DELIMITER ;


-- CRUD CLIENTES --
DELIMITER //
CREATE PROCEDURE sp_obtenerClientes()
BEGIN
  SELECT * FROM Cliente;
END //
DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_eliminarCliente(IN p_cliente_ID INT)
BEGIN
    DELETE FROM Cliente
    WHERE cliente_ID = p_cliente_ID;
END $$

DELIMITER ;
call sp_obtenerClientes;
call sp_eliminarCliente;

-- Crud Proveedores --
DELIMITER //

-- 1. Obtener todos los proveedores
CREATE PROCEDURE sp_obtenerProveedores()
BEGIN
  SELECT * FROM Proveedor;
END //

-- 2. Crear un proveedor
CREATE PROCEDURE sp_crearProveedor(
  IN p_nombre_proveedor VARCHAR(100),
  IN p_apellido_proveedor VARCHAR(100),
  IN p_correo VARCHAR(100),
  IN p_telefono VARCHAR(100),
  IN p_direccion VARCHAR(100)
)
BEGIN
  INSERT INTO Proveedor (nombre_proveedor, apellido_proveedor, correo, telefono, dirección)
  VALUES (p_nombre_proveedor, p_apellido_proveedor, p_correo, p_telefono, p_direccion);
END //

-- 3. Editar un proveedor
CREATE PROCEDURE sp_editarProveedor(
  IN p_proveedor_ID INT,
  IN p_nombre_proveedor VARCHAR(100),
  IN p_apellido_proveedor VARCHAR(100),
  IN p_correo VARCHAR(100),
  IN p_telefono VARCHAR(100),
  IN p_direccion VARCHAR(100)
)
BEGIN
  UPDATE Proveedor
  SET nombre_proveedor = p_nombre_proveedor,
      apellido_proveedor = p_apellido_proveedor,
      correo = p_correo,
      telefono = p_telefono,
      dirección = p_direccion
  WHERE proveedor_ID = p_proveedor_ID;
END //

-- 4. Eliminar un proveedor
CREATE PROCEDURE sp_eliminarProveedor(
  IN p_proveedor_ID INT
)
BEGIN
  DELETE FROM Proveedor WHERE proveedor_ID = p_proveedor_ID;
END //

-- Regresar al delimitador por defecto
DELIMITER ;

CALL sp_editarProveedor(6, 'Dulces Gaby', 'Gomez', 'Av. Principal 123', 'contacto@dulcesgaby.com','555-1234');
select * from Proveedor;
CALL sp_eliminarProveedor(6);

--  Pedido --
DELIMITER //

CREATE PROCEDURE sp_obtenerPedidosPorEstado(IN p_estado ENUM('pendiente', 'listo'))
BEGIN
  SELECT 
      ped.pedido_ID,
      ped.fecha,
      cli.nombre_cliente,
      cli.apellido_cliente,
      ped.tipo_entrega,
      ped.direccion_entrega,
      SUM(dp.cantidad * p.precio) AS total_pedido,  -- ⬅️ ahora aquí
      ped.estado,
      GROUP_CONCAT(CONCAT(dp.cantidad, ' x ', p.nombre_producto) SEPARATOR ', ') AS productos
  FROM 
      Pedido ped
  JOIN 
      Cliente cli ON ped.cliente_ID = cli.cliente_ID
  JOIN 
      Detalle_Pedido dp ON ped.pedido_ID = dp.pedido_ID
  JOIN 
      Producto p ON dp.producto_ID = p.producto_ID
  WHERE 
      ped.estado = p_estado
  GROUP BY 
      ped.pedido_ID
  ORDER BY 
      ped.fecha ASC;
END; //

DELIMITER ;
-- Nuevo --
DELIMITER $$

CREATE PROCEDURE obtenerProduFiltrados()
BEGIN
    SELECT 
        p.nombre_producto,
        p.stock,
        c.nombre_categoria,
        pr.nombre_proveedor,
        SUM(dc.cantidad) AS total_comprado_al_proveedor
    FROM producto p
    INNER JOIN categoria c ON p.categoria_ID = c.categoria_ID
    INNER JOIN detalle_compra dc ON p.producto_ID = dc.producto_ID
    INNER JOIN compra co ON dc.compra_ID = co.compra_ID
    INNER JOIN proveedor pr ON co.proveedor_ID = pr.proveedor_ID
    WHERE p.stock > 0
    GROUP BY p.producto_ID, pr.proveedor_ID, p.nombre_producto, p.stock, c.nombre_categoria, pr.nombre_proveedor
    ORDER BY c.nombre_categoria, p.nombre_producto, pr.nombre_proveedor;
END $$

DELIMITER ;
  
-- Administrador --
-- Insertar Detalle Compra --
DELIMITER $$

CREATE PROCEDURE insertarProCompra(
    IN p_compra_ID INT,
    IN p_producto_ID INT,
    IN p_precio_prove DECIMAL(10,2),
    IN p_cantidad INT
)
BEGIN
    INSERT INTO Detalle_Compra(compra_ID, producto_ID, precio_prove, cantidad)
    VALUES (p_compra_ID, p_producto_ID, p_precio_prove, p_cantidad);
END $$

DELIMITER ;

-- Insertar Compra--
DELIMITER $$

CREATE PROCEDURE insertarCompra(
    IN p_proveedor_ID INT,
    IN p_metodo_pago ENUM('transferencia', 'efectivo'),
    IN p_fecha DATETIME,
    OUT p_compra_ID INT
)
BEGIN
    INSERT INTO Compra(proveedor_ID, metodo_pago, fecha)
    VALUES (p_proveedor_ID, p_metodo_pago, p_fecha);

    SET p_compra_ID = LAST_INSERT_ID();
END $$

DELIMITER ;


-- Insertar Proveedor --
DELIMITER $$

CREATE PROCEDURE insertarProveedor(
    IN p_nombre_proveedor VARCHAR(100),
    IN p_apellido_proveedor VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(100),
    IN p_direccion VARCHAR(100),
    OUT p_proveedor_ID INT
)
BEGIN
    INSERT INTO Proveedor(nombre_proveedor, apellido_proveedor, correo, telefono, direccion)
    VALUES (p_nombre_proveedor, p_apellido_proveedor, p_correo, p_telefono, p_direccion);

    SET p_proveedor_ID = LAST_INSERT_ID();
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE historialProve(
    IN p_proveedor_ID INT,
    IN p_nombre VARCHAR(100)
)
BEGIN
    SELECT
        c.compra_ID,
        c.fecha,
        pr.nombre_proveedor,
        pr.apellido_proveedor,
        c.metodo_pago,
        p.nombre_producto,
        dc.cantidad,
        dc.precio_prove,
        (dc.cantidad * dc.precio_prove) AS subtotal,
        (
            SELECT SUM(dc2.precio_prove * dc2.cantidad)
            FROM Detalle_Compra dc2
            WHERE dc2.compra_ID = c.compra_ID
        ) AS total_compra
    FROM Compra c
    JOIN Proveedor pr ON c.proveedor_ID = pr.proveedor_ID
    JOIN Detalle_Compra dc ON c.compra_ID = dc.compra_ID
    JOIN Producto p ON dc.producto_ID = p.producto_ID
    WHERE 
        (p_proveedor_ID IS NULL OR p_proveedor_ID = 0 OR c.proveedor_ID = p_proveedor_ID)
        AND (p_nombre IS NULL OR p_nombre = '' OR pr.nombre_proveedor LIKE CONCAT('%', p_nombre, '%'))
    ORDER BY c.compra_ID, c.fecha DESC;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE historialPedi (
    IN filtro_pedido_ID INT,
    IN filtro_nombre_cliente VARCHAR(100)
)
BEGIN
    SELECT
        p.pedido_ID,
        p.fecha,
        p.tipo_entrega,
        p.direccion_entrega,
        p.estado,
        pr.nombre_producto,
        dp.cantidad,
        dp.precio_unitario,
        (dp.cantidad * dp.precio_unitario) AS subtotal,
        c.nombre_cliente,
        c.apellido_cliente,
        totales.total_pedido
    FROM Pedido p
    INNER JOIN Detalle_Pedido dp ON p.pedido_ID = dp.pedido_ID
    INNER JOIN Producto pr ON dp.producto_ID = pr.producto_ID
    INNER JOIN Cliente c ON p.cliente_ID = c.cliente_ID
    INNER JOIN (
        SELECT pedido_ID, SUM(cantidad * precio_unitario) AS total_pedido
        FROM Detalle_Pedido
        GROUP BY pedido_ID
    ) AS totales ON p.pedido_ID = totales.pedido_ID
    WHERE p.estado = 'listo'
      AND (filtro_pedido_ID IS NULL OR p.pedido_ID = filtro_pedido_ID)
      AND (filtro_nombre_cliente IS NULL OR c.nombre_cliente LIKE CONCAT('%', filtro_nombre_cliente, '%'))
    ORDER BY p.pedido_ID DESC;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE reporteVentas(
  IN fecha_inicio DATE,
  IN fecha_fin DATE,
  IN tipo_entrega_param VARCHAR(50)
)
BEGIN
    SELECT
      DATE(p.fecha) AS fecha_venta,
      COUNT(DISTINCT p.pedido_ID) AS total_pedidos,
      SUM(dp.cantidad) AS total_productos_vendidos,
      SUM(dp.cantidad * dp.precio_unitario) AS total_ventas,
      ROUND(SUM(dp.cantidad * dp.precio_unitario) / COUNT(DISTINCT p.pedido_ID), 2) AS promedio_venta_por_pedido,
      p.tipo_entrega,
      p.estado
    FROM Pedido p
    INNER JOIN Detalle_Pedido dp ON p.pedido_ID = dp.pedido_ID
    WHERE p.estado = 'listo' -- Solo pedidos completados
      AND (fecha_inicio IS NULL OR DATE(p.fecha) >= fecha_inicio)
      AND (fecha_fin IS NULL OR DATE(p.fecha) <= fecha_fin)
      AND (tipo_entrega_param IS NULL OR p.tipo_entrega = tipo_entrega_param)
    GROUP BY DATE(p.fecha), p.tipo_entrega, p.estado
    ORDER BY fecha_venta DESC, p.tipo_entrega;
END $$

DELIMITER ;
 call reporteVentas;
CALL reporteVentas(NULL, NULL, 'recoger');
CALL reporteVentas('2025-05-01', '2025-05-28', 'domicilio');
CALL reporteVentas(NULL, NULL, NULL);
CALL reporteVentas('2025-05-01', '2025-05-28', 'domicilio');



