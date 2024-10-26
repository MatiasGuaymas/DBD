/* Ejercicio 5
AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje */

/* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
teléfono. */

SELECT a.RAZON_SOCIAL, a.direccion, a.telef
FROM agencia a
INNER JOIN viaje v ON (a.RAZON_SOCIAL = v.razon_social)
INNER JOIN ciudad c ON (v.cpOrigen = c.CODIGOPOSTAL)
INNER JOIN cliente cli ON (cli.DNI = v.DNI)
WHERE (c.nombreCiudad = 'La Plata' AND cli.apellido = 'Roma')
ORDER BY a.RAZON_SOCIAL, a.telef

/* 2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’. */

SELECT v.FECHA, v.HORA, c.DNI, c.nombre, c.apellido, c.telefono, c.direccion, origen.nombreCiudad, destino.nombreCiudad
FROM viaje v
INNER JOIN cliente c ON (c.DNI = v.DNI)
INNER JOIN ciudad origen ON (origen.CODIGOPOSTAL = v.cpOrigen)
INNER JOIN ciudad destino ON (destino.CODIGOPOSTAL = v.cpDestino)
WHERE (v.FECHA BETWEEN '2019-01-01' AND '2019-31-01') AND (v.descripcion LIKE '%demorado%')

/* 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
mail que termine con ‘@jmail.com’. */

SELECT DISTINCT a.RAZON_SOCIAL, a.direccion, a.telef, a.email
FROM agencia a
INNER JOIN viaje v ON (v.razon_social = a.RAZON_SOCIAL)
WHERE (a.email LIKE '%@jmail.com') OR (YEAR(v.fecha) = 2019)

/* 4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’ */ 

SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
FROM cliente c INNER JOIN viaje v ON (c.DNI = v.DNI)
INNER JOIN ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
WHERE ciu.nombreCiudad = 'Coronel Brandsen'
EXCEPT
SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
FROM cliente c INNER JOIN viaje v ON (c.DNI = v.DNI)
INNER JOIN ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
WHERE ciu.nombreCiudad <> "Coronel Brandsen"

/* 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */

SELECT COUNT(*) AS CantViajes
FROM agencia a
INNER JOIN viaje v ON (a.RAZON_SOCIAL = v.razon_social)
INNER JOIN ciudad c ON (v.cpDestino = c.CODIGOPOSTAL)
WHERE a.RAZON_SOCIAL = 'TAXI Y' AND c.nombreCiudad = 'Villa Elisa'

/* 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM cliente c
WHERE NOT EXIST (
    SELECT *
    FROM agencia a
    WHERE NOT EXIST (
        SELECT *
        FROM viaje v 
        WHERE (a.razon_social = v.razon_social) AND (v.DNI = c.DNI)
    )
)

/* 7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’. */

UPDATE cliente SET telefono="221-4400897" WHERE DNI=38495444

/* 8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
realizados. */

SELECT a.RAZON_SOCIAL, a.direccion, a.telef
FROM agencia a INNER JOIN viaje v ON (a.RAZON_SOCIAL = v.RAZON_SOCIAL)
GROUP BY v.RAZON_SOCIAL, v.direccion, v.telef
/* Buscar maximo */
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM VIAJE v
    GROUP BY v.RAZON_SOCIAL
)

/* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes. */

SELECT c.nombre, c.apellido, c.telefono, c.direccion
FROM cliente c
INNER JOIN viaje v ON (c.DNI = v.DNI)
GROUP BY c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
HAVING COUNT(*) >= 10

/* 10. Borrar al cliente con DNI 40325692. */

DELETE FROM viaje WHERE DNI=40325692
DELETE FROM cliente WHERE DNI=40325692