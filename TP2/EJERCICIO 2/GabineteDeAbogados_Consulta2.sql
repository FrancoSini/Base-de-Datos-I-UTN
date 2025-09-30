-- ¿Qué clientes han tenido asuntos en los que ha participado el procurador Carlos López?
SELECT 
    c.nombre 
FROM Procuradores p
JOIN Asuntos_Procuradores ap 
     ON p.id_procurador = ap.id_procurador
JOIN Asuntos a 
     ON a.numero_expediente = ap.numero_expediente
JOIN Clientes c 
     ON c.dni_cliente = a.dni_cliente
WHERE p.procurador_nombre = 'Carlos López';