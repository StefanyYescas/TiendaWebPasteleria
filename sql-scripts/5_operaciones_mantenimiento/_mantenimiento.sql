SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Usuario AUTO_INCREMENT = 1;
DELETE FROM Usuario WHERE usuario_ID = 1;

TRUNCATE TABLE Detalle_Pedido;
TRUNCATE TABLE Pedido;
TRUNCATE TABLE Cliente;
TRUNCATE TABLE Producto;
TRUNCATE TABLE Categoria;
TRUNCATE TABLE Usuario;


select * from Compra;
select * from proveedor;
select * from Producto;
select * from Usuario;
select * from Cliente;
select * from pedido;
select * from Detalle_Pedido;
select * from Detalle_Compra;


ALTER USER 'root'@'localhost' IDENTIFIED BY '182904*';
FLUSH PRIVILEGES;




