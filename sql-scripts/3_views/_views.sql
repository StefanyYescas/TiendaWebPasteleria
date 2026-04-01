-- Vista productos más vendidos --
CREATE VIEW masVendidos AS
SELECT 
  p.producto_ID,
  p.nombre_producto,
  p.imagen_url,
  p.precio,
  p.descripcion,
  SUM(dp.cantidad) AS total_vendido
FROM Detalle_Pedido dp
JOIN Producto p ON dp.producto_ID = p.producto_ID
GROUP BY p.producto_ID
ORDER BY total_vendido DESC;

select * from masVendidos;

-- Vista todos los productos --
select * from vista_todos_productos;
CREATE OR REPLACE VIEW vista_todos_productos AS
SELECT 
    p.producto_ID,
    p.nombre_producto,
    p.descripcion AS descripcion_producto,
    p.precio,
    p.stock,
    p.imagen_url,
    c.categoria_ID,
    c.nombre_categoria,
    c.descripcion AS descripcion_categoria
FROM 
    Producto p
JOIN 
    Categoria c ON p.categoria_ID = c.categoria_ID;

select * from vista_todos_productos;

-- Vista ticket Backend --
CREATE VIEW ticket AS
SELECT 
    ped.pedido_ID,
    ped.fecha,
    ped.tipo_entrega,
    ped.tipo_pago,
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
    Producto p ON dp.producto_ID = p.producto_ID;
    
DELIMITER $$

-- vista --
CREATE OR REPLACE VIEW vistaTotal AS
SELECT 
    SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
FROM 
    Detalle_Pedido dp
JOIN 
    Pedido p ON dp.pedido_ID = p.pedido_ID
WHERE 
    p.estado = 'listo';



CREATE OR REPLACE VIEW vistaListos AS
SELECT 
    COUNT(*) AS total_pedidos
FROM 
    Pedido
WHERE 
    estado = 'listo';

CREATE OR REPLACE VIEW vistaVendidos AS
SELECT 
    pr.nombre_producto,
    SUM(dp.cantidad) AS total_vendido
FROM 
    Detalle_Pedido dp
JOIN 
    Producto pr ON dp.producto_ID = pr.producto_ID
JOIN 
    Pedido p ON dp.pedido_ID = p.pedido_ID
WHERE 
    p.estado = 'listo'
GROUP BY 
    pr.nombre_producto
ORDER BY 
    total_vendido DESC;

CREATE OR REPLACE VIEW vistaCompracion AS
SELECT 
    tipo_entrega,
    COUNT(*) AS cantidad
FROM 
    Pedido
WHERE 
    estado = 'listo'
GROUP BY 
    tipo_entrega;




SELECT * FROM vistaTotal;
SELECT * FROM vistaListos;
SELECT * FROM vistaVendidos;
SELECT * FROM vistaCompracion;




