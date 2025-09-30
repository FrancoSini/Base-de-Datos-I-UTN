-- 🔹 Borrar la base de datos si existe y volver a crearlabarcos
CREATE DATABASE IF NOT EXISTS gabinete_abogado;
USE gabinete_abogado;

-- 🔹 Crear tabla Clientes
CREATE TABLE Clientes (
    dni_cliente INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(255)
);

-- 🔹 Crear tabla Asuntos
CREATE TABLE Asuntos (
    numero_expediente INTEGER PRIMARY KEY,
    estado VARCHAR(10) NOT NULL,
    dni_cliente INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    FOREIGN KEY (dni_cliente) REFERENCES Clientes(dni_cliente)
);

-- 🔹 Crear tabla Procuradores
CREATE TABLE Procuradores (
    id_procurador INTEGER PRIMARY KEY,
    procurador_nombre VARCHAR(100),
    direccion VARCHAR(100)
);

-- 🔹 Crear tabla intermedia Asuntos_Procuradores
CREATE TABLE Asuntos_Procuradores (
    id_procurador INT,
    numero_expediente INTEGER,
    PRIMARY KEY (id_procurador, numero_expediente),
    FOREIGN KEY (id_procurador) REFERENCES Procuradores(id_procurador),
    FOREIGN KEY (numero_expediente) REFERENCES Asuntos(numero_expediente)
);
