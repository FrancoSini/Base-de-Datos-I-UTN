-- Poblar la tabla Clientes
delete from asuntos_procuradores where id_procurador>0;
delete from asuntos where numero_expediente!='';
delete from clientes where dni_cliente>0;
delete from procuradores where id_procurador>0;

INSERT INTO clientes (dni_cliente, nombre, direccion)
VALUES
(123456789, 'Juan Pérez', 'Calle Pueyrredón 3498, Buenos Aires'),
(987654321, 'Ana García', 'Calle 5 323, La Plata'),
(456123789, 'Luis Fernández', 'Avenida de Gral. Paz 1056, Bahía Blanca');

-- Poblar la tabla Asuntos
INSERT INTO Asuntos (numero_expediente, dni_cliente, fecha_inicio, fecha_fin, estado)
VALUES
(1, 123456789, '2023-01-15', '2023-07-20', 'Cerrado'),
(2, 987654321, '2023-05-10', NULL, 'Abierto'),
(3, 456123789, '2023-06-01', '2023-09-10', 'Cerrado');

-- Poblar la tabla Procuradores
INSERT INTO Procuradores (id_procurador, procurador_nombre, direccion)
VALUES
(1, 'Laura Sánchez', 'Calle Soler 3765, Buenos Aires'),
(2, 'Carlos López', 'Calle Estrellas 8, Mar del Plata'),
(3, 'Marta Díaz', 'Calle Estación 12, Olavarria'),
(4, 'Pepe Barrera', 'Calle Soler 3765, Buenos Aires'),
(5, 'Joaco Martinez', 'Calle Estrellas 8, Mar del Plata'),
(6, 'Luciana Lopilato', 'Calle Estación 12, Olavarria');

-- Poblar la tabla Asuntos_Procuradores
INSERT INTO Asuntos_Procuradores (numero_expediente, id_procurador)
VALUES
(1, 1),
(2, 2),
(3, 3),
(2, 1);  -- Un asunto puede tener varios procuradores