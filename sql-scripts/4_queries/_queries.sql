-- PRACTICA 1 -- 
-- (Vistas estan en viws) --

-- PRACTICA 2 --
-- Listado de productos en existencia y proveedores --

SELECT 
  p.nombre_producto,
  p.stock AS existencia,
  pr.nombre_proveedor
FROM 
  Producto p
JOIN 
  Detalle_Compra dc ON p.producto_ID = dc.producto_ID
JOIN 
  Compra c ON dc.compra_ID = c.compra_ID
JOIN 
  Proveedor pr ON c.proveedor_ID = pr.proveedor_ID;
  select * from Proveedor;
  select * from Compra;
  select * from detalle_compra;
-- Consulta por orden de Compra --
SELECT 
    c.compra_ID, 
    p.nombre_producto, 
    dc.precio_prove, 
    dc.cantidad, 
    (dc.precio_prove * dc.cantidad) AS total_compra, 
    pr.nombre_proveedor
FROM 
    Compra c
JOIN 
    Detalle_Compra dc ON c.compra_ID = dc.compra_ID
JOIN 
    Producto p ON dc.producto_ID = p.producto_ID
JOIN 
    Proveedor pr ON c.proveedor_ID = pr.proveedor_ID
WHERE 
    c.compra_ID = 1  
ORDER BY 
    c.compra_ID;
    
-- Producto mas vendido --
SELECT 
    p.nombre_producto, 
    SUM(dp.cantidad) AS total_vendido
FROM 
    Detalle_Pedido dp
JOIN 
    Producto p ON dp.producto_ID = p.producto_ID
GROUP BY 
    p.producto_ID
ORDER BY 
    total_vendido DESC
LIMIT 3;  -- Esto obtiene el producto más vendido

-- Consulta de ticket de venta --
SELECT * FROM Vista_Ticket_Detallado WHERE pedido_ID = 2;
SELECT 
    ped.pedido_ID,
    ped.fecha,
    p.nombre_producto,
    dp.cantidad,
    p.precio,
    (dp.cantidad * p.precio) AS subtotal,
    SUM(dp.cantidad * p.precio) OVER(PARTITION BY ped.pedido_ID) AS total
FROM 
    Detalle_Pedido dp
JOIN 
    Pedido ped ON dp.pedido_ID = ped.pedido_ID
JOIN 
    Producto p ON dp.producto_ID = p.producto_ID
WHERE 
    ped.pedido_ID = 9;



-- PRACTICA 3 --
CREATE USER 'usuarioprueba'@'localhost' IDENTIFIED BY 'clave123';
GRANT SELECT, INSERT, UPDATE, DELETE ON tiendawebpasteleria.* TO 'usuarioprueba'@'localhost';
FLUSH PRIVILEGES;

-- PRACTICA 4 --
SET autocommit = 0;

START TRANSACTION;

INSERT INTO Pedido (cliente_ID, tipo_entrega)
VALUES (1, 'domicilio');

SET @lastPedidoID = LAST_INSERT_ID();
SELECT @lastPedidoID;

select * from Detalle_Pedido;
INSERT INTO Detalle_Pedido (pedido_ID, producto_ID, cantidad)
VALUES 
(@lastPedidoID, 2, 1);

UPDATE Producto SET stock = stock - 1 WHERE producto_ID = 2;

commit;
rollback;
select * from Producto;

DELETE FROM Pedido WHERE pedido_ID = 1;
DELETE FROM Detalle_Pedido WHERE pedido_ID = 1;

DELIMITER $$

-- PRACTICA 5 --
CREATE PROCEDURE obtener_productos_por_categoria(IN nombreCat VARCHAR(50))
BEGIN
    SELECT p.producto_ID, p.nombre_producto, p.descripcion, p.precio, p.stock, c.nombre_categoria
    FROM Producto p
    INNER JOIN Categoria c ON p.categoria_ID = c.categoria_ID
    WHERE c.nombre_categoria = nombreCat;
END$$

DELIMITER ;

CALL obtener_productos_por_categoria('Pasteles');

-- PRACTICA 6 --

-- Automatiza la resta del stock cuando se agregua un producto al pedido.
DELIMITER //

CREATE TRIGGER restar_stock_venta
AFTER INSERT ON Detalle_Pedido
FOR EACH ROW
BEGIN
  UPDATE Producto
  SET stock = stock - NEW.cantidad
  WHERE producto_ID = NEW.producto_ID;
END;
//

DELIMITER ;

-- Ingreso antes mi Usuario
select * from Usuario;
INSERT INTO Usuario (nombre_usuario, correo, contraseña)
VALUES ('Soto', 'soto@correo.com', '12345');

-- Cliente 
select * from Cliente;
desc Cliente;
INSERT INTO Cliente (usuario_ID, nombre_cliente, apellido_cliente, telefono)
VALUES (last_insert_id(), 'Soto', 'Soto', '5551234567');

-- Pedido
select * from Pedido;
INSERT INTO Pedido (cliente_ID, tipo_entrega)
VALUES (last_insert_id(), 'domicilio');

-- Detalle_Pedido
INSERT INTO Detalle_Pedido (pedido_ID, producto_ID, cantidad)
VALUES (6, 3, 2);  

SELECT nombre_producto, stock FROM Producto WHERE producto_ID = 1;


select * from Producto;
SELECT nombre_producto, stock FROM Producto WHERE producto_ID = 1;
SHOW TRIGGERS LIKE 'Detalle_Pedido';

-- Automatizar para detalle_compra
DROP TRIGGER IF EXISTS aumentar_stock_compra;

DELIMITER //

CREATE TRIGGER aumentar_stock_compra
AFTER INSERT ON Detalle_Compra
FOR EACH ROW
BEGIN
  -- Aumentar el stock del producto después de realizar una compra
  UPDATE Producto
  SET stock = stock + NEW.cantidad
  WHERE producto_ID = NEW.producto_ID;
END;
//

DELIMITER ;

-- Insertar Proveedor
desc Proveedor;
INSERT INTO Proveedor (nombre_proveedor, apellido_proveedor, correo, telefono, dirección)
VALUES ('Proveedor2', 'Apellido2', 'proveedor2@correo.com', '234', 'Dirección1');

select * from Compra;
-- Insertar Compra
INSERT INTO Compra (proveedor_ID, metodo_pago)
VALUES (last_insert_id(), 'transferencia'); 
 
 select * from Detalle_Compra;
 -- Aumentara la compra
INSERT INTO Detalle_Compra (compra_ID, producto_ID, precio_prove, cantidad)
VALUES (6, 1, 100.00, 2);  

SELECT producto_ID, nombre_producto, stock
FROM Producto;
