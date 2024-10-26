/* Ejercicio 4
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI (fk), Legajo, Año_Ingreso)
PROFESOR = (DNI (fk), Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta) */

/* 1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
2014. */

SELECT a.DNI, a.Legajo, p.Apellido
FROM alumno a
INNER JOIN persona p ON (a.DNI = p.DNI)
WHERE (a.Año_Ingreso < 2014)

/* 2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
100 horas de duración. Ordenar por DNI. */

SELECT DISTINCT p.DNI, p.Matricula, per.Apellido, per.nombre
FROM profesor p
INNER JOIN persona per ON (p.dni = per.DNI)
INNER JOIN profesor_curso pc ON (per.DNI = pc.DNI)
INNER JOIN curso c ON (pc.Cod_Curso = c.Cod_Curso)
WHERE (c.Duracion > 100)
ORDER BY p.DNI

/* 3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
curso con nombre “Diseño de Bases de Datos” en 2023. */

SELECT p.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM persona p
WHERE p.DNI IN (
    SELECT aCurso.DNI
    FROM alumno_curso aCurso
    INNER JOIN curso c ON (aCurso.Cod_Curso = c.Cod_Curso)
    WHERE (c.nombre = 'Diseño de Bases de Datos' AND YEAR(aCurso.Año)=2023)
)

/* 4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
estar ordenado por Apellido y nombre. */

SELECT pe.DNI, pe.Apellido, pe.Nombre, aluCurso.Calificación
FROM persona pe
INNER JOIN alumno_curso aluCurso ON pe.DNI = aluCurso.DNI
INNER JOIN profesor_curso profeCurso ON aluCurso.Cod_Curso = profeCurso.Cod_Curso
INNER JOIN persona p ON profeCurso.DNI = p.DNI
WHERE p.Nombre = 'Juan' AND p.Apellido = 'Garcia' AND aluCurso.Calificación > 8
ORDER BY pe.Apellido, pe.Nombre;

/* 5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
Dicho listado deberá estar ordenado por Apellido y Nombre. */

SELECT p.DNI, p.Apellido, p.Nombre, profe.Matricula
FROM profesor profe
INNER JOIN persona p ON (p.DNI = profe.DNI)
INNER JOIN titulo_profesor tit ON (profe.DNI = tit.DNI)
GROUP BY p.DNI, p.Apellido, p.Nombre, profe.Matricula
HAVING COUNT(*) > 3
ORDER BY p.Apellido, p.Nombre

/* 6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta. */

SELECT p.DNI, p.Apellido, p.Nombre, SUM(c.Duracion), AVG(c.Duracion)
FROM profesor profe 
INNER JOIN persona p ON (profe.DNI = p.DNI)
LEFT JOIN profesor_curso pc ON (profe.DNI = pc.DNI)
LEFT JOIN curso c ON (pc.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, p.Apellido, p.Nombre

/* 7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
menos alumnos inscriptos durante 2024. */

SELECT C.Nombre, C.Descripción
FROM CURSO C
WHERE C.Cod_Curso IN (
    SELECT AC.Cod_Curso
    FROM ALUMNO_CURSO AC
    WHERE AC.Año = 2024
    GROUP BY AC.Cod_Curso
    HAVING COUNT(*) = (
        SELECT MAX(Cantidad) FROM (
            SELECT COUNT(*) AS Cantidad
            FROM ALUMNO_CURSO
            WHERE Año = 2024
            GROUP BY Cod_Curso) AS MaxCount
    ) OR COUNT(*) = (
        SELECT MIN(Cantidad) FROM (
            SELECT COUNT(*) AS Cantidad
            FROM ALUMNO_CURSO
            WHERE Año = 2024
            GROUP BY Cod_Curso) AS MinCount
    )
);

/* 8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023. */

SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM persona p
INNER JOIN alumno a ON (p.DNI = a.DNI)
INNER JOIN alumno_curso aluCur ON (p.DNI = aluCur.DNI)
INNER JOIN curso c on (aluCur.Cod_Curso = c.Cod_Curso)
WHERE (c.Nombre LIKE '%BD' AND aluCur.Año = 2023)
EXCEPT
SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM persona p
INNER JOIN alumno a ON (p.DNI = a.DNI)
INNER JOIN alumno_curso aluCur ON (p.DNI = aluCur.DNI)
WHERE (aluCur.Año = 2023)

/* 9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25. */

INSERT INTO persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) 
VALUES (1111111, 'Guaymas', 'Matias', '2005-01-07', 'Soltero', 'M');

INSERT INTO profesor (DNI, Matricula, Nro_Expediente) 
VALUES (1111111, 123, 100);

INSERT INTO titulo_profesor (Cod_Titulo, DNI, Fecha) 
VALUES (25, 1111111, '2023-02-09');

/* 10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado. */

UPDATE persona SET Estado_Civil='Divorciado' WHERE DNI IN (SELECT a.DNI FROM alumno a WHERE a.Legajo='2020/09')

/* 11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
conjunto de relaciones en un estado inconsistente */

DELETE FROM alumno_curso WHERE DNI=30568989;
DELETE FROM alumno WHERE DNI=30568989;
DELETE FROM persona WHERE DNI=30568989;