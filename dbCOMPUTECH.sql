-- Base de datos
/* Poner en uso base de datos master */
USE master;

/* Si la base de datos ya existe la eliminamos */
DROP DATABASE dbCOMPUTECH;

/* Crear base de datos grow up */
CREATE DATABASE dbCOMPUTECH;

/* Poner en uso la base de datos */
USE dbCOMPUTECH;

/* Crear tabla client */
CREATE TABLE client (
    id int identity(1,1)  NOT NULL,
    names varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    number_document char(8)  NOT NULL,
    date_birth date  NOT NULL,
    email varchar(80)  NOT NULL,
    active bit DEFAULT (1)  NOT NULL,
    CONSTRAINT client_pk PRIMARY KEY  (id)
);

/* Ver estructura de tabla client */
EXEC sp_columns @table_name = 'client';

/* Crear tabla employee */
CREATE TABLE employee (
    id int identity(1,1)  NOT NULL,
    names varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    type_employee char(1)  NOT NULL,
    status_civil char(1)  NOT NULL,
    email varchar(80)  NOT NULL,
    sex char(1)  NOT NULL,
    num_hours char(3)  NOT NULL,
    active bit DEFAULT (1)  NOT NULL,
    pay_hour decimal(6,2)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY  (id)
);

/* Ver estructura de tabla employee */
EXEC sp_columns @table_name = 'employee';

/* Crear tabla product */
CREATE TABLE product (
    id int  NOT NULL,
    name varchar(60)  NOT NULL,
    mark varchar(20)  NOT NULL,
    color varchar(20)  NOT NULL,
    stock char(200)  NOT NULL,
    price decimal(6,2)  NOT NULL,
    description varchar(100)  NOT NULL,
    active bit DEFAULT (1)  NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY  (id)
);

/* Ver estructura de tabla product */
EXEC sp_columns @table_name = 'product';

/* Crear tabla sale */
CREATE TABLE sale (
    id int  NOT NULL,
    client_id int  NOT NULL,
    employee_id int  NOT NULL,
    type_payment char(1)  NOT NULL,
    active bit DEFAULT (1)  NOT NULL,
    CONSTRAINT sale_pk PRIMARY KEY  (id)
);

/* Ver estructura de tabla sale */
EXEC sp_columns @table_name = 'sale';

/* Crear tabla sale_detail */
CREATE TABLE sale_detail (
    id int  NOT NULL,
    product_id int  NOT NULL,
    sale_id int  NOT NULL,
    names varchar(60)  NOT NULL,
    quantity char(2)  NOT NULL,
    CONSTRAINT sale_detail_pk PRIMARY KEY  (id)
);

/* Ver estructura de tabla sale_detail */
EXEC sp_columns @table_name = 'sale_detail';

-- Relaciones
/* Relacionar tabla sale_client con tabla sale */
ALTER TABLE sale 
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
    REFERENCES client (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* Relacionar tabla sale_detail_product con tabla sale_detail */
ALTER TABLE sale_detail 
	ADD CONSTRAINT sale_detail_product FOREIGN KEY (product_id)
    REFERENCES product (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* Relacionar tabla sale_detail_sale con tabla sale_detail */
ALTER TABLE sale_detail 
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
    REFERENCES sale (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* Relacionar tabla sale_employee con tabla sale */
ALTER TABLE sale 
	ADD CONSTRAINT sale_employee FOREIGN KEY (employee_id)
    REFERENCES employee (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* Ver relaciones creadas entre las tablas de la base de datos */
SELECT 
    fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO


-- fin