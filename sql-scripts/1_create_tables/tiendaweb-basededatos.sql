-- Crear base de datos y usarla
DROP DATABASE IF EXISTS pasteleria;
CREATE DATABASE tiendawebpasteleria;
USE tiendawebpasteleria;
show tables;
-- Tabla: Usuario
CREATE TABLE Usuario (
    usuario_ID INT auto_increment,  
    correo VARCHAR(100) NOT NULL UNIQUE,  
    contraseña VARCHAR(255) NOT NULL,
    rol ENUM('cliente', 'admin') NOT NULL DEFAULT 'cliente',
    CONSTRAINT pk_usuario PRIMARY KEY (usuario_ID)
);


-- Tabla: Categoria
CREATE TABLE Categoria (
    categoria_ID INT AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    CONSTRAINT pk_categoria PRIMARY KEY (categoria_ID)
);

-- Tabla: Producto
CREATE TABLE Producto (
    producto_ID INT AUTO_INCREMENT,
    categoria_ID INT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    imagen_url VARCHAR(255),
    CONSTRAINT pk_producto PRIMARY KEY (producto_ID),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria_ID) REFERENCES Categoria(categoria_ID),
    CONSTRAINT chk_precio_producto CHECK (precio >= 0),
    CONSTRAINT chk_stock_producto CHECK (stock >= 0)
);


-- Tabla: Cliente
CREATE TABLE Cliente (
    cliente_ID INT AUTO_INCREMENT,
    usuario_ID INT NOT NULL,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100),
    telefono VARCHAR(20),
    CONSTRAINT pk_cliente PRIMARY KEY (cliente_ID),
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_ID) REFERENCES Usuario(usuario_ID)
);

-- Tabla: Pedido
CREATE TABLE Pedido (
    pedido_ID INT AUTO_INCREMENT,
    cliente_ID INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo_entrega ENUM('local', 'domicilio') NOT NULL DEFAULT 'local',
    direccion_entrega VARCHAR(255),
    estado ENUM('pendiente', 'listo') DEFAULT 'pendiente',
    CONSTRAINT pk_pedido PRIMARY KEY (pedido_ID),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_ID) REFERENCES Cliente(cliente_ID)
);

-- Tabla: Detalle_Pedido
CREATE TABLE Detalle_Pedido (
    detalle_ID INT AUTO_INCREMENT,
    pedido_ID INT NOT NULL,
    producto_ID INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_detalle_pedido PRIMARY KEY (detalle_ID),
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (pedido_ID) REFERENCES Pedido(pedido_ID),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_ID) REFERENCES Producto(producto_ID),
    CONSTRAINT chk_cantidad CHECK (cantidad > 0)
);

create table Proveedor(
proveedor_ID INT AUTO_INCREMENT,
nombre_proveedor VARCHAR(100) NOT NULL,
apellido_proveedor VARCHAR(100) NOT NULL,
correo VARCHAR(100)NOT NULL,
telefono VARCHAR(100)NOT NULL,
direccion VARCHAR(100)NOT NULL,
CONSTRAINT pk_proveedor primary key (proveedor_ID)
);

create table Compra (
compra_ID INT AUTO_INCREMENT,
proveedor_ID INT NOT NULL,
metodo_pago ENUM('transferencia', 'efectivo') NOT NULL DEFAULT 'efectivo',
fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT pk_compra primary key (compra_ID),
CONSTRAINT fk_compra_proveedor FOREIGN KEY (proveedor_ID) REFERENCES Proveedor(proveedor_ID) ON UPDATE CASCADE
); 

desc Proveedor;

create table Detalle_Compra (
detalle_compra_ID INT AUTO_INCREMENT,
compra_ID INT NOT NULL,
producto_ID INT NOT NULL,
precio_prove DECIMAL(10,2) NOT NULL,
cantidad  INT NOT NULL,
CONSTRAINT pk_detalle_compra PRIMARY KEY (detalle_compra_ID),
CONSTRAINT fk_detalle_producto_compra FOREIGN KEY (compra_ID) REFERENCES Compra(compra_ID),
CONSTRAINT fk_detalle_pedido_compra FOREIGN KEY (producto_ID) REFERENCES Producto(producto_ID),
CONSTRAINT chk_cantidad_compra CHECK (cantidad > 0)

);

-- Modificaciones que le hice a las tablas haciendo pruebas --
select * from Usuario;
ALTER TABLE Detalle_Compra
ADD CONSTRAINT chk_precio_compra CHECK (precio_prove >= 0);
ALTER TABLE Detalle_Pedido
ADD COLUMN precio_venta DECIMAL(10,2) NOT NULL DEFAULT 0;
ALTER TABLE Detalle_Pedido
ADD CONSTRAINT chk_precio_venta CHECK (precio_venta >= 0);
ALTER TABLE Detalle_Compra
ADD CONSTRAINT chk_precio_compra CHECK (precio_prove >= 0);
ALTER TABLE Usuario
ADD COLUMN nombre_usuario VARCHAR(100) NOT NULL;
ALTER TABLE Cliente
ADD direccion VARCHAR(255);
ALTER TABLE Pedido
ADD COLUMN direccion_entrega VARCHAR(255);
ALTER TABLE Detalle_Pedido
ADD COLUMN precio_unitario DECIMAL(10,2) NOT NULL;
ALTER TABLE Pedido
ADD COLUMN 	tipo_pago ENUM('transferencia', 'efectivo') NOT NULL DEFAULT 'efectivo';
ALTER TABLE Usuario
ADD COLUMN rol ENUM('cliente', 'admin') NOT NULL DEFAULT 'cliente';
ALTER TABLE Proveedor CHANGE dirección direccion VARCHAR(100) NOT NULL;
ALTER TABLE Pedido
ADD estado ENUM('pendiente', 'listo') DEFAULT 'pendiente';



select * from Proveedor;
select * from Compra;
select * from Detalle_Compra;
select * from Producto;
select * from Usuario;
select * from Cliente;
select * from Pedido;
select * from Detalle_Pedido;

DELETE FROM Usuario;  -- Borra todos los registros
ALTER TABLE Usuario AUTO_INCREMENT = 1;  -- Reinicia el contador de ID a 1

SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO Usuario (nombre_usuario, correo, contraseña, rol) 
VALUES ('Admin', 'admin@gmail.com', 'Administrador20', 'admin');
