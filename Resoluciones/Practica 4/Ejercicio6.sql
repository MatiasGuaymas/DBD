/* Ejercicio 6
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas. */

/* 1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio. */
SELECT r.nombre, r.stock, r.precio
FROM repuesto r
ORDER BY r.precio

/* 2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
se usaron en reparaciones del técnico ‘José Gonzalez’. */

SELECT DISTINCT r.nombre, r.stock, r.precio
FROM repuesto r 
INNER JOIN repuestoreparacion repu ON (r.codRep = repu.codRep)
INNER JOIN reparacion repa ON (repa.nroReparac = repu.nroReparac)
WHERE YEAR(repa.fecha) = 2023
EXCEPT
SELECT r.nombre, r.stock, r.precio
FROM repuesto r 
INNER JOIN repuestoreparacion repu ON (r.codRep = repu.codRep)
INNER JOIN reparacion repa ON (repa.nroReparac = repu.nroReparac)
INNER JOIN tecnico t ON (t.codTec = repa.codTec)
WHERE t.nombre = 'José Gonzalez'

/* 3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
por nombre ascendentemente. */

SELECT t.nombre, t.especialidad
FROM tecnico t
WHERE NOT EXISTS (
    SELECT *
    FROM reparacion r
    WHERE (t.codTec = r.codTec)
)
ORDER BY t.nombre

/* 4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
durante 2022. */ 

SELECT DISTINCT t.nombre, t.especialidad
FROM tecnico t
INNER JOIN reparacion r ON (t.codTec = r.codTec)
WHERE YEAR(r.fecha) = 2022
EXCEPT
SELECT t.nombre, t.especialidad
FROM tecnico t
INNER JOIN reparacion r ON (t.codTec = r.codTec)
WHERE NOT (r.fecha BETWEEN '2022-01-01' AND '2022-12-31')

/* 5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
repuesto no participó en alguna reparación igual debe aparecer en dicho listado. */

SELECT rep.nombre, rep.stock, COUNT(DISTINCT reparacion.codTec) as CantUsados
FROM repuesto rep
LEFT JOIN repuestoreparacion r ON (rep.codRep= r.codRep)
INNER JOIN Reparacion reparacion ON (r.nroReparac = reparacion.nroReparac)
GROUP BY rep.codRep, rep.nombre, rep.stock

/* 6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
técnico con menor cantidad de reparaciones. */

SELECT t.nombre, t.especialidad
FROM tecnico t
INNER JOIN reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM reparacion r
    GROUP BY r.codTec
);

SELECT t.nombre, t.especialidad
FROM tecnico t
INNER JOIN reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) <= ALL (
    SELECT COUNT(*)
    FROM reparacion r
    GROUP BY r.codTec
)

/* 7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
no haya estado en reparaciones con un precio total superior a $10000. */

SELECT r.nombre, r.stock, r.precio
WHERE r.stock > 0 AND r.codRep NOT IN (
    SELECT rep.codRep
    FROM repuestoreparacion rep
    WHERE rep.precio > 10000
)

/* 8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
con precio en el momento de la reparación mayor a $10000 y menor a $15000. */

SELECT r.nroReparac, r.fecha, r.precio_total
FROM reparacion r 
INNER JOIN repuestoreparacion rep ON (r.nroReparac = rep.nroReparac)
WHERE (rep.precio BETWEEN 10000 AND 15000)

/* 9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos. */

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON r.codRep = rr.codRep
INNER JOIN Reparacion rep ON rr.nroReparac = rep.nroReparac
GROUP BY r.codRep, r.nombre, r.stock, r.precio
HAVING COUNT(DISTINCT rep.codTec) = (SELECT COUNT(*) FROM Tecnico);

/* 10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10
repuestos distintos. */

SELECT r.fecha, t.nombre, r.precio_total
FROM reparacion r
INNER JOIN repuestoreparacion rep ON (r.nroReparac = rep.nroReparac)
INNER JOIN tecnico t ON (t.codTec = r.codTec)
GROUP BY r.nroReparac, r.fecha, t.nombre, r.precio_total
HAVING COUNT(*) >= 10