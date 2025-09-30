-- ¿Cuántos asuntos ha gestionado cada procurador?
SELECT 
    p.procurador_nombre AS Procurador, 
    COUNT(ap.numero_expediente) AS Cantidad_Asuntos
FROM Procuradores p
LEFT JOIN Asuntos_Procuradores ap
       ON p.id_procurador = ap.id_procurador
GROUP BY p.procurador_nombre
ORDER BY Cantidad_Asuntos DESC;