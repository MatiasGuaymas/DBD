/* Ejercicio 3
Banda = (codigoB, nombreBanda, genero_musical, año_creacion)
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
Recital = (fecha, hora, nroEscenario (fk), codigoB (fk)) */

/* 1. Listar DNI, nombre, apellido, dirección y email de integrantes nacidos entre 1980 y 1990 y que
hayan realizado algún recital durante 2023. */

SELECT i.DNI, i.nombre, i.apellido, i.direccion
FROM integrante i
WHERE i.fecha_nacimiento BETWEEN 1980-01-01 AND 1990-12-31 AND i.DNI IN (
    SELECT i.DNI
    FROM recital r 
    INNER JOIN banda b ON (r.codiboB = b.codigoB)
    INNER JOIN integrante i ON (b.codigoB = i.codigoB)
    WHERE YEAR(r.fecha) = 2023
)

/* 2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
durante 2023, pero no hayan tocado durante 2022. */

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM banda b
INNER JOIN recital r ON (b.codigoB = r.codigoB)
WHERE YEAR(r.fecha) = 2023
EXCEPT
SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM banda b
INNER JOIN recital r ON (b.codigoB = r.codigoB)
WHERE YEAR(r.fecha) = 2022

/* 3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente. */

SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicacion
FROM banda b
INNER JOIN recital r ON (b.codigoB = r.codigoB)
INNER JOIN escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE r.fecha = '2023-12-04'

/* 4. Listar DNI, nombre, apellido, email de integrantes que hayan tocado en el escenario con nombre
‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’. */ 

SELECT i.DNI, i.nombre, i.apellido, i.email 
FROM integrante i
INNER JOIN banda b ON (i.codigoB = b.codigoB)
INNER JOIN recital r ON (b.codigoB = r.codigoB)
INNER JOIN escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = 'Gustavo Cerati'
INTERSECT
SELECT i.DNI, i.nombre, i.apellido, i.email 
FROM integrante i
INNER JOIN banda b ON (i.codigoB = b.codigoB)
INNER JOIN recital r ON (b.codigoB = r.codigoB)
INNER JOIN escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = 'Carlos Gardel'

/* 5. Reportar nombre, género musical y año de creación de bandas que tengan más de 8 integrantes. */

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM banda b
INNER JOIN integrante i ON (b.codigoB = i.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.año_creacion
HAVING COUNT(*) > 8

/* 6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
con el género musical rock and roll. Ordenar por nombre de escenario */

SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM escenario e
INNER JOIN recital r ON (e.nroEscenario = r.nroEscenario)
INNER JOIN banda b ON (e.codigoB = r.codigoB)
WHERE r.genero_musical = 'rock and roll'
EXCEPT (
SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM escenario e
INNER JOIN recital r ON (e.nroEscenario = r.nroEscenario)
INNER JOIN banda b ON (e.codigoB = r.codigoB)
WHERE r.genero_musical <> 'rock and roll')
ORDER BY e.nombre_escenario

/* 7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
escenarios cubiertos durante 2023.// cubierto es true, false según corresponda */

SELECT DISTINCT b.nombre, b.genero_musical, b.año_creacion
FROM banda b
INNER JOIN recital r ON (b.codigB = r.codigoB)
INNER JOIN escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE (e.cubierto = true) AND (YEAR(r.fecha)=2023)

/* 8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. */
SELECT e.nombre_escenario, COUNT(*) as CantRecitales
FROM escenario e LEFT JOIN recital r ON (e.nroEscenario = r.nroEscenario)
WHERE YEAR(r.fecha) = 2024
GROUP BY e.nroEscenario, e.nombre_escenario

/* 9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. */
UPDATE banda SET nombreBanda='Memphis la Blusera' WHERE nombreBanda='Mempis la Blusera'