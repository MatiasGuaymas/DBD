/* Ejercicio 2
Localidad = (codigoPostal, nombreL, descripcion, #habitantes)
Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk)) */

/* 1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
el podador ‘Jose Garcia’. */

(SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM localidad l 
INNER JOIN arbol a ON (l.codigoPostal = a.codigoPostal)
INNER JOIN poda pod ON (pod.nroArbol = a.nroArbol)
INNER JOIN podador p ON (p.DNI = pod.DNI)
WHERE (p.nombre = 'Juan' and p.apellido = 'Perez'))
INTERSECT
(SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM localidad l 
INNER JOIN arbol a ON (l.codigoPostal = a.codigoPostal)
INNER JOIN poda pod ON (pod.nroArbol = a.nroArbol)
INNER JOIN podador p ON (p.DNI = pod.DNI)
WHERE (p.nombre = 'Jose' and p.apellido = 'Garcia'))

/* 2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores que tengan podas realizadas durante 2023. */

SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac, l.nombreL
FROM podador p 
INNER JOIN poda pod ON (p.DNI = pod.DNI)
INNER JOIN localidad l ON (l.codigoPostal = p.codigoPostalVive)
WHERE YEAR(pod.fecha) = 2023

/* 3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca. */

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM arbol a
INNER JOIN localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT p.nroArbol
    FROM arbol a
    INNER JOIN poda p ON (a.nroArbol = p.nroArbol)
) 

/* 4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y no
fueron podados durante 2023. */

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM arbol a INNER JOIN localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN poda po ON (a.nroArbol = po.nroArbol)
WHERE YEAR(po.fecha) = 2022
EXCEPT (
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM arbol a INNER JOIN localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN poda po ON (a.nroArbol = po.nroArbol)
WHERE YEAR(po.fecha) = 2023) 

/* 5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
2024. Ordenar por apellido y nombre. */

SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM podador p 
INNER JOIN localidad l ON (l.codigoPostal = p.codigoPostalVive)
WHERE p.apellido LIKE '%ata' AND p.DNI IN (
    SELECT pod.DNI
    FROM poda pod 
    WHERE YEAR(pod.fecha)=2024
) 
ORDER BY p.apellido, p.nombre

/* 6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
árboles de especie ‘Coníferas’. */

SELECT p.DNI, p.apellido, p.nombre, p.telefono, p.fnac
FROM podador p 
INNER JOIN poda pod ON (p.DNI = pod.DNI)
INNER JOIN arbol a ON (a.nroArbol = pod.nroArbol)
WHERE a.especie = 'Coníferas'
EXCEPT
SELECT p.DNI, p.apellido, p.nombre, p.telefono, p.fnac
FROM podador p 
INNER JOIN poda pod ON (p.DNI = pod.DNI)
INNER JOIN arbol a ON (a.nroArbol = pod.nroArbol)
WHERE a.especie <> 'Coníferas'

/* 7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
localidad de ‘Salta’. */

SELECT a.especie
FROM arbol a
INNER JOIN localidad l ON (l.codigoPostal = a.codigoPostal)
WHERE l.nombreL = 'La Plata'
INTERSECT
SELECT a.especie
FROM arbol a
INNER JOIN localidad l ON (l.codigoPostal = a.codigoPostal)
WHERE l.nombreL = 'Salta'

/* 8. Eliminar el podador con DNI 22234566. */

DELETE FROM podador WHERE DNI = 22234566

/* 9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100
árboles. */

SELECT l.nombreL, l.descripcion, l.habitantes
FROM localidad l
INNER JOIN arbol a ON (l.codigoPostal = a.codigoPostal)
GROUP BY l.codigoPostal, l.nombreL, l.descripcion, l.habitantes
HAVING COUNT(*) > 100