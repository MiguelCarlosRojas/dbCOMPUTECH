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
    id_formatted AS 'C' + RIGHT('00' + CAST(id AS varchar(2)), 2) PERSISTED,
    names varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    number_document char(8)  NOT NULL,
    date_birth date  NOT NULL,
    email varchar(80)  NOT NULL,
    active bit DEFAULT (1)  NOT NULL,
    CONSTRAINT client_pk PRIMARY KEY  (id),
    CONSTRAINT client_id_format CHECK (id_formatted LIKE 'C[0-9][0-9]'),
    CONSTRAINT client_number_document_unique UNIQUE (number_document),
    CONSTRAINT client_email_unique UNIQUE (email),
    CONSTRAINT client_number_document_length CHECK (LEN(number_document) = 8),
    CONSTRAINT client_number_document_numeric CHECK (number_document LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT client_email_valid CHECK (email LIKE '%@%._%')
);

/* Ver estructura de tabla client */
EXEC sp_columns @table_name = 'client';

/* Crear tabla employee */
CREATE TABLE employee (
    id int identity(1,1)  NOT NULL,
    id_formatted AS 'E' + RIGHT('00' + CAST(id AS varchar(2)), 2) PERSISTED,
    names varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    type_employee char(1)  NOT NULL,
    status_civil char(1) NOT NULL,
    email varchar(80) NOT NULL,
    sex char(1) NOT NULL,
    num_hours char(3) NOT NULL,
    active char(1) DEFAULT ('A') NOT NULL,
    pay_hour decimal(6,2) NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY  (id),
    CONSTRAINT type_employee_check CHECK (type_employee IN ('V', 'A')),
    CONSTRAINT status_civil_check CHECK (status_civil IN ('S', 'C', 'D')),
    CONSTRAINT sex_check CHECK (sex IN ('M', 'F')),
    CONSTRAINT email_unique UNIQUE (email),
    CONSTRAINT email_valid_check CHECK (email LIKE '%@%.%'),
    CONSTRAINT active_check CHECK (active IN ('A', 'I')),
    CONSTRAINT num_hours_check CHECK (CAST(num_hours AS int) <= 160),
    CONSTRAINT pay_hour_check CHECK (pay_hour <= 12.00)
);

/* Ver estructura de tabla employee */
EXEC sp_columns @table_name = 'employee';

-- Crear tabla product */
CREATE TABLE product (
    id int identity(1,1) NOT NULL,
    id_formatted AS ('P' + RIGHT('00' + CAST(id AS varchar(2)), 2)) PERSISTED,
    name varchar(60) NOT NULL,
    mark varchar(20) NOT NULL,
    color varchar(20) NOT NULL,
    stock char(200) NOT NULL DEFAULT ('0'),
    price decimal(6,2) NOT NULL DEFAULT (0),
    description varchar(100) NOT NULL,
    active char(1) DEFAULT ('A') NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (id),
    CONSTRAINT product_stock_not_null CHECK (stock IS NOT NULL),
    CONSTRAINT product_price_not_null CHECK (price IS NOT NULL),
    CONSTRAINT product_active_allowed CHECK (active IN ('A', 'I'))
);

/* Ver estructura de tabla product */
EXEC sp_columns @table_name = 'product';

/* Crear tabla sale */
CREATE TABLE sale (
    id int identity(1,1)  NOT NULL,
    client_id int  NOT NULL,
    employee_id int  NOT NULL,
    date date DEFAULT GETDATE() NOT NULL,
    type_payment char(1)  NOT NULL,
    active char(1) DEFAULT ('A') NOT NULL,
    CONSTRAINT sale_pk PRIMARY KEY  (id),
    CONSTRAINT sale_client_fk FOREIGN KEY (client_id)
        REFERENCES client (id),
    CONSTRAINT sale_employee_fk FOREIGN KEY (employee_id)
        REFERENCES employee (id),
    CONSTRAINT sale_type_payment_ck CHECK (type_payment IN ('E', 'T', 'Y')),
    CONSTRAINT sale_active_ck CHECK (active IN ('A', 'I'))
);

/* Ver estructura de tabla sale */
EXEC sp_columns @table_name = 'sale';

-- Crear tabla sale_detail
CREATE TABLE sale_detail (
    id int identity(100,1) NOT NULL,
    product_id int NOT NULL,
    sale_id int NOT NULL,
    names varchar(60) NOT NULL,
    quantity char(2) NOT NULL,
    CONSTRAINT sale_detail_pk PRIMARY KEY (id),
    CONSTRAINT sale_detail_product_fk FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT sale_detail_quantity_check CHECK (quantity >= '1')
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