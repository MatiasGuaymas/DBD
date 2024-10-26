/* Ejercicio 1
Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura (nroTicket, total, fecha, hora, idCliente (fk))
Detalle (nroTicket (fk), idProducto (fk), cantidad, preciounitario)
Producto (idProducto, nombreP, descripcion, precio, stock) */ 

/* 1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI */

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM cliente c
WHERE (c.apellido LIKE 'Pe%')
ORDER BY c.DNI

/* 2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
durante 2017. */

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM cliente c INNER JOIN factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha BETWEEN 2017-01-01 and 2017-12-31)
EXCEPT
SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM cliente c INNER JOIN factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha < 2017-01-01 and f.fecha > 2017-12-31)

/* 3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’. */

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (f.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (c.idCliente = f.idCliente)
WHERE (c.DNI=45789456)
EXCEPT
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (f.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (c.idCliente = f.idCliente)
WHERE (c.apellido='Garcia')

/* 4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre. */

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM producto p
WHERE p.idProducto NOT IN (
SELECT p.idProducto
FROM producto p
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (f.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (c.idCliente = f.idCliente)
WHERE (c.telefono LIKE '221')
)
ORDER BY p.nombreP

/* 5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto. */

SELECT p.nombreP, p.descripcion, p.precio, SUM(d.cantidad) as CantVendida
FROM producto p LEFT JOIN detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio

/* 6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’. */

SELECT c.nombre, c.apellido, c.dni, c.telefono, c.direccion
FROM cliente c
INNER JOIN factura f ON f.idCliente = c.idCliente
INNER JOIN detalle d ON d.nroTicket = f.nroTicket
INNER JOIN producto p ON p.idProducto = d.idProducto
WHERE p.nombreP IN ('prod1', 'prod2')
AND c.idCliente NOT IN (
	SELECT c.idCliente
	FROM cliente c 
	INNER JOIN factura f ON f.idCliente = c.idCliente
	INNER JOIN detalle d ON d.nroTicket = f.nroTicket
	INNER JOIN producto pr ON pr.idProducto = d.idProducto	
	WHERE pr.nombreP = 'prod3'
)
GROUP BY c.idCliente
HAVING COUNT(DISTINCT pr.nombreP) = 2;

/* 7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2019. */

SELECT f.nroTicket, f.total, f.fecha, f.hora, c.DNI
FROM cliente c
INNER JOIN factura f ON f.idCliente = c.idCliente
INNER JOIN detalle d ON d.nroTicket = f.nroTicket
INNER JOIN producto p ON p.idProducto = d.idProducto
WHERE (p.nombreP = 'prod38' OR YEAR(f.fecha) = 2019)

/* 8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe. */

INSERT INTO cliente (idCliente, nombre, apellido, DNI, telefono, direccion) 
VALUES (500002, 'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 y 501 nro:2587')

/* 9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya
comprado el producto ´Z´. */

SELECT f.nroTicket, f.total, f.fecha, f.hora
FROM cliente c
INNER JOIN factura f ON f.idCliente = c.idCliente
INNER JOIN detalle d ON d.nroTicket = f.nroTicket
INNER JOIN producto p ON p.idProducto = d.idProducto
WHERE c.nombre = 'Jorge' AND c.apellido = 'Pérez' AND f.nroTicket NOT IN (
    SELECT d.nroTicket
    FROM detalle d
    INNER JOIN producto p ON p.idProducto = d.idProducto
    WHERE p.nombreP = 'Z'
)

/* 10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $10.000.000. */

SELECT c.DNI, c.apellido, c.nombre
FROM cliente c
INNER JOIN factura f ON (f.idCliente = c.idCliente)
GROUP BY c.idCliente
HAVING SUM(f.total) > 10000000