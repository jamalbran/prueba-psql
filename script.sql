\echo 'Parte 2 - Creando el modelo en la base de datos'
\echo '1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos. (2 puntos).'

DROP DATABASE biblioteca;
CREATE DATABASE biblioteca;

\c biblioteca;

CREATE TABLE socios(
  rut VARCHAR,
  nombre VARCHAR,
  apellido VARCHAR,
  direccion VARCHAR,
  telefono INT,
  PRIMARY KEY (rut)
);

CREATE TABLE libros(
  isbn VARCHAR,
  titulo VARCHAR,
  paginas INT,
  dias_prestamo INT,
  PRIMARY KEY (isbn)
);

CREATE TABLE autores(
  id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  nacimiento INT,
  muerte INT,
  PRIMARY KEY (id)
);

CREATE TABLE autor_libro(
  id INT,
  id_libro VARCHAR,
  id_autor INT,
  tipo_autor VARCHAR,
  PRIMARY KEY (id),
  FOREIGN KEY (id_libro) REFERENCES libros(isbn),
  FOREIGN KEY (id_autor) REFERENCES autores(id)
);

CREATE TABLE prestamos(
  id INT,
  id_socio VARCHAR,
  id_libro VARCHAR,
  prestamo DATE,
  devolucion DATE,
  PRIMARY KEY (id),
  FOREIGN KEY (id_socio) REFERENCES socios(rut),
  FOREIGN KEY (id_libro) REFERENCES libros(isbn)
);

\echo '2. Se deben insertar los registros en las tablas correspondientes (1 punto).'

INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('1111111-1', 'Juan', 'Soto', 'Avenida 1, Santiago', 911111111);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('2222222-2', 'Ana', 'Perez', 'Pasaje 2, Santiago', 922222222);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('3333333-3', 'Sandra', 'Aguilar', 'Avenida 2, Santiago', 933333333);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('4444444-4', 'Esteban', 'Jerez', 'Avenida 3, Santiago', 944444444);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('5555555-5', 'Silvana', 'Muñoz', 'Pasaje 3, Santiago', 955555555);

INSERT INTO libros (isbn, titulo, paginas, dias_prestamo) VALUES ('111-1111111-111', 'Cuentos de Terror', 344, 7);
INSERT INTO libros (isbn, titulo, paginas, dias_prestamo) VALUES ('222-2222222-222', 'Poesias Contemporaneas', 167, 7);
INSERT INTO libros (isbn, titulo, paginas, dias_prestamo) VALUES ('333-3333333-333', 'Historia de Asia', 511, 14);
INSERT INTO libros (isbn, titulo, paginas, dias_prestamo) VALUES ('444-4444444-444', 'Manual de Mecanica', 298, 14);

INSERT INTO autores (id, nombre, apellido, nacimiento, muerte) VALUES (1, 'Jose', 'Salgado', 1968, 2020);
INSERT INTO autores (id, nombre, apellido, nacimiento) VALUES (2, 'Ana', 'Salgado', 1972);
INSERT INTO autores (id, nombre, apellido, nacimiento) VALUES (3, 'Andres', 'Ulloa', 1982);
INSERT INTO autores (id, nombre, apellido, nacimiento, muerte) VALUES (4, 'Sergio', 'Mardones', 1950, 2012);
INSERT INTO autores (id, nombre, apellido, nacimiento) VALUES (5, 'Martin', 'Porta', 1976);

INSERT INTO autor_libro (id, id_libro, id_autor, tipo_autor) VALUES (1, '111-1111111-111', 1, 'Principal');
INSERT INTO autor_libro (id, id_libro, id_autor, tipo_autor) VALUES (2, '111-1111111-111', 2, 'Coautor');
INSERT INTO autor_libro (id, id_libro, id_autor, tipo_autor) VALUES (3, '222-2222222-222', 3, 'Principal');
INSERT INTO autor_libro (id, id_libro, id_autor, tipo_autor) VALUES (4, '333-3333333-333', 4, 'Principal');
INSERT INTO autor_libro (id, id_libro, id_autor, tipo_autor) VALUES (5, '444-4444444-444', 5, 'Principal');

INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (1, '1111111-1', '111-1111111-111', '2020-01-20', '2020-01-27');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (2, '5555555-5', '222-2222222-222', '2020-01-20', '2020-01-30');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (3, '3333333-3', '333-3333333-333', '2020-01-22', '2020-01-30');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (4, '4444444-4', '444-4444444-444', '2020-01-23', '2020-01-30');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (5, '2222222-2', '111-1111111-111', '2020-01-27', '2020-02-04');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (6, '1111111-1', '444-4444444-444', '2020-01-31', '2020-02-12');
INSERT INTO prestamos (id, id_socio, id_libro, prestamo, devolucion) VALUES (7, '3333333-3', '222-2222222-222', '2020-01-30', '2020-02-12');

\echo '3. Realizar las siguientes consultas:'
\echo 'a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)'

SELECT * FROM libros WHERE paginas < 300;

\echo 'b. Mostrar todos los autores que hayan nacido después del 01-01-1970. (0.5 puntos)'

SELECT * FROM autores WHERE nacimiento > 1970;

\echo 'c. ¿Cuál es el libro más solicitado? (0.5 puntos).'
-- Hay tres libros con la misma cantidad, por lo que deje las cantidades por libro y ordenados considerando esta cantidad.

SELECT l.titulo, COUNT(p.id_libro) as n_solicitudes FROM prestamos p
  LEFT JOIN libros l ON p.id_libro = l.isbn
  GROUP BY 1
  ORDER BY 2 DESC;

\echo 'd. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días. (0.5 puntos)'
-- Se hizo con las reglas definidas en clase, de ver las multas por prestamo que tengan dias de atraso.

SELECT s.nombre, s.apellido, l.titulo, p.prestamo, p.devolucion, l.dias_prestamo,
  (p.devolucion - p.prestamo) AS n_dias_prestamos,
  CASE 
    WHEN (p.devolucion - p.prestamo - l.dias_prestamo) > 0 THEN (p.devolucion - p.prestamo - l.dias_prestamo)
    WHEN (p.devolucion - p.prestamo - l.dias_prestamo) <= 0 THEN 0
  END AS dias_atraso,
  CASE
    WHEN (p.devolucion - p.prestamo - l.dias_prestamo) > 0 THEN ((p.devolucion - p.prestamo - l.dias_prestamo) * 100)
    WHEN (p.devolucion - p.prestamo - l.dias_prestamo) <= 0 THEN 0
  END AS multa
  FROM prestamos p 
  LEFT JOIN socios s on p.id_socio = s.rut
  LEFT JOIN libros l on p.id_libro = l.isbn;
