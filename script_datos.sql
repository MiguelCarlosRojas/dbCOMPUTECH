/* Poner en uso la base de datos */
USE dbCOMPUTECH;

/* Configurar idioma espa�ol en el servidor */
SET LANGUAGE Espa�ol
GO
SELECT @@language AS 'Idioma'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

/* Tabla client */

/* Eliminar columna number_document de tabla client */
ALTER TABLE client
	DROP COLUMN number_document
GO

/* El n�mero de documento s�lo debe permitir d�gitos de 0 - 9 */
ALTER TABLE client
	ADD number_document char(8)
	CONSTRAINT number_document_client
	CHECK (number_document like '[0-8][0-8][0-8][0-8][0-8][0-8][0-8][0-8][^A-Z]')
GO

/* Eliminar columna email de tabla person */
ALTER TABLE client
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE client
	ADD email varchar(80)
	CONSTRAINT email_client
	CHECK(email LIKE '%@%._%')
GO

-- fin