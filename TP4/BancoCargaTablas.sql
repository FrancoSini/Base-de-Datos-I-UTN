CREATE DATABASE IF NOT EXISTS BancoFinal;
use BancoFinal;

-- Creacion de tablas

CREATE TABLE clientes(
numero_cliente int primary key,
dni INT NOT NULL,
apellido VARCHAR(60) NOT NULL,
nombre varchar(60) NOT NULL
);

CREATE TABLE cuentas(
numero_cuenta int primary key,
numero_cliente int not null,
saldo decimal(10,2) not null,
constraint fk_numero_cliente foreign key(numero_cliente) references clientes(numero_cliente)
);

CREATE TABLE movimientos(
numero_movimiento int primary key auto_increment,
numero_cuenta int not null,
fecha date not null,
tipo ENUM('Credito','Debito')not null,
importe decimal (10,2)not null,
constraint fk_numero_cuenta foreign key (numero_cuenta) references cuentas(numero_cuenta)
);

CREATE TABLE historial_movimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero_cuenta INT NOT NULL,
  numero_movimiento INT NOT NULL,
  saldo_anterior DECIMAL(10,2) NOT NULL,
  saldo_actual DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_numeroCuenta FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta),
  CONSTRAINT fk_numero_movimiento FOREIGN KEY (numero_movimiento) REFERENCES movimientos(numero_movimiento)
);
