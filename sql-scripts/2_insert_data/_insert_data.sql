-- INSERTS --

desc Usuario;
select * from Usuario;
-- Insertar usuarios --
INSERT INTO Usuario (correo, contraseña)
VALUES ('stefanyyescas20@gmail.com', 'rinrin');
INSERT INTO Usuario (correo, contraseña)
VALUES ('fatimanicolev@hotmail.com', 'bruce');

desc Cliente;
select * from Cliente;
-- Insertar clientes
INSERT INTO Cliente (usuario_ID, nombre_cliente, apellido_cliente, telefono)
VALUES 
(1, 'Fatima Nicole', 'Yescas Vargas', '2291328099'),
(2,'Stefany Catharin', 'Yescas Vargas', '2294122560'),
(3,'Eva Gabriela', 'Lopez Martinez', '2291595504');
INSERT INTO Cliente (usuario_ID, nombre_cliente, apellido_cliente, telefono)
VALUES 
(last_insert_id(), 'Mar Antoine', 'Amoros Martínez', '2292540299');

desc Categoria;
select * from Categoria;
-- Insertar categorías
INSERT INTO Categoria (nombre_categoria, descripcion)
VALUES 
('Pasteles', 'Pasteles de distintos sabores'),
('Bebidas', 'Bebidas frías y calientes');
INSERT INTO Categoria (nombre_categoria, descripcion)
VALUES 
('Brownies', 'Brownies horneados hechos de base de chocolate.'),
('Pays', 'Pays compuestas por una base de galleta o masa.'),
('Gelatinas', 'Postres fríos, elaborados a base de grenetina.');


desc Producto;
select * from Producto;
-- Insertar productos
INSERT INTO Producto (categoria_ID, nombre_producto, descripcion, precio, stock, imagen_url)
VALUES 
(1, 'Pastel de Chocolate', 'Delicioso pastel con cobertura de chocolate', 250.00, 10, 'img/pastel_chocolate.jpg'),
(2, 'Café Americano', 'Café negro caliente', 30.00, 50, 'img/cafe.jpg');
Insert into Producto (categoria_ID, nombre_producto, descripcion, precio, stock, imagen_url)
values
(1, 'Pastel de Fresa', 'Rico pastel dulce y esponjoso, compuesto por capas suaves de fresas frescas y crema batida.', 250.00, 10, 'img/pastel_fresa.jpg'),
(2, 'Café Expresso', 'Café concentrado con un sabor intenso y delicioso.', 30.00, 50, 'img/cafe_expresso.jpg'),
(3, 'Brownie de Chookies', 'Rico brownie con trocitos de chocolate y galleta encima.', 25.00, 30, 'img/brownie_chookies.jpg'),
(3, 'Brownie de Oreo', 'Exquisito brownie con trocitos de chocolate y crujienete galleta Oreo.', 25.00, 30, 'img/brownie_oreo.jpg'),
(4, 'Pay de Queso', 'Pay suave y cremoso, elaborado con una base crujiente de galleta.', 260.00, 30, 'img/pay_queso.jpg'),
(4, 'Pay de Fresa', 'Pay con una capa generosa de fresas frescas y cema batida.', 260.00, 30, 'img/pay_fresa.jpg'),
(5, 'Gelatina de Mosaico', 'Cubito de diferentes sabores y colores de gelatina.', 130.00, 25, 'img/gelatina_mosaico.jpg'),
(5, 'Gelatina de leche', 'Postre cremoso y suave, preparado con una mezcla de leches.', 130.00, 25, 'img/gelatina_leche.jpg');


desc Pedido;
select * from Pedido;
-- Insertar pedido
INSERT INTO Pedido (cliente_ID, tipo_entrega)
VALUES 
(1, 'domicilio');
INSERT INTO Pedido (cliente_ID, tipo_entrega)
VALUES 
(4, 'local');


desc Detalle_Pedido;
select * from Detalle_Pedido;
-- Insertar detalle de pedido
INSERT INTO Detalle_Pedido (pedido_ID, producto_ID, cantidad, precio_venta)
VALUES 
(1, 5, 2, 250.00),
(2, 3, 3, 250.00),
(3, 1, 2, 250.00);











