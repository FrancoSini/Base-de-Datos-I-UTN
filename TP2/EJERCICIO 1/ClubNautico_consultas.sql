use club_nautico;
SELECT nombre 
FROM Socios
WHERE id_socio IN(SELECT id_socio 
				  FROM Barcos
                  WHERE numero_amarre>10);
                  
SELECT nombre,cuota
FROM Barcos
WHERE id_socio IN (SELECT id_socio
                    FROM Socios
                    WHERE nombre='Juan Pérez');
                    
SELECT COUNT(nombre) AS cantidad_de_salidas
FROM Barcos
WHERE matricula=(SELECT matricula
                FROM Salidas
                WHERE matricula='ABC123');
                
SELECT b.nombre AS barco, (SELECT s.nombre
                          FROM Socios s
                          where s.id_socio=b.id_socio)AS socio 

FROM Barcos b
WHERE cuota>500 ;

SELECT nombre
FROM Barcos
WHERE matricula IN(SELECT matricula
                   FROM Salidas
                   WHERE destino='Mallorca');

SELECT patron_nombre, patron_direccion
FROM Salidas
WHERE matricula IN(SELECT matricula
                FROM Barcos
                WHERE id_socio IN(SELECT id_socio
                                  FROM Socios
                                  WHERE direccion LIKE '%Barcelona%' ));