/* Poner en uso la base de datos */
USE dbCOMPUTECH;

/* Configurar idioma español en el servidor */
SET LANGUAGE Español
GO
SELECT @@language AS 'Idioma'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

/* Insertar datos en la tabla client */
INSERT INTO client (names, last_name, number_document, date_birth, email)
VALUES
    ('Eugenio', 'BARRIOS PALOMINO', '78451211', '1990-01-01', 'eugenio@yahoo.com'),
    ('Carolina', 'TARAZONA MEZA', '78451212', '1995-02-15', 'carolina.tarazona@yahoo.com'),
    ('Roberto', 'MARTINEZ CAMPOS', '74125898', '1988-05-10', 'roberto.martinez@gmail.com'),
    ('Claudia', 'RODRIGUEZ GUERRA', '15253698', '1992-09-20', 'claudia.rodriguez@outlook.com'),
    ('Julio', 'HUAMAN PEREZ', '45123698', '1997-04-08', 'julio.huaman@gmail.com'),
    ('Marco', 'MANCO AVILA', '45781236', '1993-12-03', 'marcos.manco@yahoo.com'),
    ('Micaela', 'TAIPE ORMEÑO', '45127733', '1991-07-18', 'micaela.taipe@gmail.com'),
    ('Pedro', 'ORE VASQUEZ', '15253398', '1994-03-25', 'pedro.ore@gmail.com'),
    ('Yolanda', 'PALOMINO FARFAN', '15223364', '1989-11-12', 'yolanda.palomino@outlook.com'),
    ('Luisa', 'SANCHEZ ROMERO', '11223365', '1996-06-30', 'luisa.sanchez@gmail.com');

-- Obtener todos los registros
SELECT * FROM client;

-- Consulta para mostrar información de la tabla client con nombres de columna modificados
SELECT 
    CONCAT('C', RIGHT('00' + CAST(id AS varchar), 2)) AS Código,
    CONCAT(last_name, ', ', names) AS Cliente,
    number_document AS DNI,
    email AS Email
FROM client;


/* Insertar datos en la tabla employee */
INSERT INTO employee (names, last_name, type_employee, status_civil, email, sex, num_hours, active, pay_hour)
VALUES
    ('Eulaio', 'MARTINEZ OCARES', 'V', 'S', 'eulalio.martinez@laempresa.com', 'M', '120', 'A', 11.00),
    ('María', 'LOMBARDI GUERRA', 'V', 'C', 'maria.lombardi@laempresa.com', 'F', '110', 'A', 10.00),
    ('Bruno', 'RODRIGUEZ ROJAS', 'A', 'S', 'bruno.rodriguez@laempresa.com', 'M', '160', 'A', 12.00),
    ('Bernardo', 'PARRA GRAU', 'A', 'C', 'bernardo.parra@laempresa.com', 'M', '160', 'A', 12.00),
    ('Yolanda', 'BENAVIDES CENTENO', 'V', 'C', 'yolanda.benavides@laempresa.com', 'F', '100', 'A', 8.00),
    ('Fabiana', 'OSCORIMA PEÑA', 'V', 'S', 'fabiana.oscorima@laempresa.com', 'F', '125', 'A', 8.00);

-- Obtener todos los registros
SELECT * FROM employee;

-- Consulta para mostrar información de la tabla employee con nombres de columna modificados
SELECT 
    CONCAT('E', RIGHT('00' + CAST(id AS varchar), 2)) AS Código,
    CONCAT(last_name, ', ', names) AS EMPLEADO,
    CASE type_employee
        WHEN 'V' THEN 'Vendedor'
        WHEN 'A' THEN 'Administrador'
    END AS 'TIPO EMPLEADO',
    CASE status_civil
        WHEN 'S' THEN 'Soltero'
        WHEN 'C' THEN 'Casado'
        WHEN 'D' THEN 'Divorciado'
    END AS 'ESTADO CIVIL',
    email AS EMAIL,
    CASE sex
        WHEN 'M' THEN 'Masculino'
        WHEN 'F' THEN 'Femenino'
    END AS SEXO,
    num_hours AS 'NUM. HORAS',
    CASE active
        WHEN 'A' THEN 'Activo'
        WHEN 'I' THEN 'Inactivo'
    END AS ESTADO,
    pay_hour AS 'PAG. X HORA'
FROM employee;


-- Insertar datos en la tabla product
INSERT INTO product (name, mark, color, stock, price, description)
VALUES ('Camisa', 'Nike', 'Azul', '10', 29.99, 'Camisa deportiva de manga corta'),
       ('Pantalón', 'Adidas', 'Negro', '5', 49.99, 'Pantalón deportivo de tela'),
       ('Zapatillas', 'Reebok', 'Blanco', '15', 79.99, 'Zapatillas deportivas'),
       ('Sudadera', 'Puma', 'Gris', '8', 39.99, 'Sudadera con capucha'),
       ('Shorts', 'Under Armour', 'Rojo', '12', 34.99, 'Shorts de entrenamiento'),
       ('Calcetines', 'New Balance', 'Negro', '20', 9.99, 'Calcetines deportivos'),
       ('Gorra', 'Vans', 'Azul', '3', 19.99, 'Gorra con logo'),
       ('Chaqueta', 'The North Face', 'Verde', '6', 89.99, 'Chaqueta impermeable');

-- Obtener todos los registros
SELECT * FROM product;

-- Consulta para mostrar la información deseada de la tabla product
SELECT 
    id_formatted AS 'CÓDIGO',
    CONCAT(name, ' - ', mark) AS 'PRODUCTO',
    mark AS 'MARCA',
    color AS 'COLOR',
    stock AS 'STOCK',
    price AS 'PRECIO',
    description AS 'DESCRIPCIÓN',
    CASE 
        WHEN active = 'A' THEN 'ACTIVO'
        WHEN active = 'I' THEN 'INACTIVO'
    END AS 'ESTADO'
FROM product;

-- Insertar datos en la tabla "sale"
INSERT INTO sale (client_id, employee_id, date, type_payment, active)
VALUES (1, 1, GETDATE(), 'E', 'A'),
       (2, 1, GETDATE(), 'T', 'A'),
       (3, 2, GETDATE(), 'Y', 'A'),
       (4, 3, GETDATE(), 'E', 'A');

-- Obtener todos los registros
SELECT * FROM sale;

-- Consulta para mostrar la información deseada de la tabla sale
SELECT s.id AS CODIGO, s.date AS FECHA,
       CONCAT(c.last_name, ', ', c.names) AS CLIENTE,
       CONCAT(e.last_name, ', ', e.names) AS VENDEDOR,
       CASE s.type_payment
           WHEN 'E' THEN 'Efectivo'
           WHEN 'T' THEN 'Transferencia'
           WHEN 'Y' THEN 'Yape'
           ELSE 'Desconocido'
       END AS 'TIPO PAGO',
       CASE
           WHEN s.active = 'A' THEN 'Activo'
           WHEN s.active = 'I' THEN 'Inactivo'
           ELSE 'Desconocido'
       END AS 'ESTADO'
FROM sale s
JOIN client c ON s.client_id = c.id
JOIN employee e ON s.employee_id = e.id;

-- Insertar datos en la tabla sale_detail
INSERT INTO sale_detail (product_id, sale_id, names, quantity)
VALUES (1, 1, 'Producto A', '3'),
       (2, 1, 'Producto B', '2'),
       (3, 2, 'Producto C', '1'),
       (4, 3, 'Producto D', '3'),
       (5, 3, 'Producto E', '2'),
       (6, 3, 'Producto F', '5');

-- Obtener todos los registros
SELECT * FROM sale_detail;

-- Consulta para mostrar la información requerida
SELECT sd.sale_id AS "ID. VENTA",
       sd.id AS "ID. VENTA DETALLE",
       p.name AS "PRODUCTO",
       sd.quantity AS "CANTIDAD"
FROM sale_detail sd
INNER JOIN product p ON sd.product_id = p.id;