-- Lista los números de expediente y fechas de inicio de los asuntos de los clientes que viven en Buenos Aires.
SELECT 
    a.numero_expediente,
    a.fecha_inicio
FROM Asuntos a
JOIN Clientes c
     ON a.dni_cliente = c.dni_cliente
WHERE c.direccion LIKE '%Buenos Aires%';