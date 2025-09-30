USE club_nautico;

-- 1) Nombres de socios con barcos cuyo número de amarre > 10
SELECT s.nombre
FROM Socios s
JOIN Barcos b ON s.id_socio = b.id_socio
WHERE b.numero_amarre > 10;

-- 2) Nombre y cuota de los barcos cuyo socio es 'Juan Pérez'
SELECT b.nombre, b.cuota
FROM Barcos b
JOIN Socios s ON b.id_socio = s.id_socio
WHERE s.nombre = 'Juan Pérez';

-- 3) Cantidad de salidas de un barco con matrícula 'ABC123'
SELECT COUNT(sa.matricula) AS cantidad_de_salidas
FROM Salidas sa
JOIN Barcos b ON sa.matricula = b.matricula
WHERE b.matricula = 'ABC123';

-- 4) Nombre del barco y su socio cuando la cuota > 500
SELECT b.nombre AS barco, s.nombre AS socio
FROM Barcos b
JOIN Socios s ON b.id_socio = s.id_socio
WHERE b.cuota > 500;

-- 5) Nombres de barcos que han salido con destino 'Mallorca'
SELECT DISTINCT b.nombre
FROM Barcos b
JOIN Salidas sa ON b.matricula = sa.matricula
WHERE sa.destino = 'Mallorca';

-- 6) Nombre y dirección de los patrones de salidas de barcos
-- cuyo socio vive en Barcelona
SELECT sa.patron_nombre, sa.patron_direccion
FROM Salidas sa
JOIN Barcos b ON sa.matricula = b.matricula
JOIN Socios s ON b.id_socio = s.id_socio
WHERE s.direccion LIKE '%Barcelona%';
