-- ¿Cuál es el nombre y la dirección de los procuradores que han trabajado en un asunto abierto?
SELECT procurador_nombre, direccion , A.numero_expediente
FROM (Procuradores p JOIN Asuntos_Procuradores ap ON p.id_procurador =ap.id_procurador) 
JOIN Asuntos A ON A.numero_expediente=ap.numero_expediente
WHERE A.estado ='Abierto';
