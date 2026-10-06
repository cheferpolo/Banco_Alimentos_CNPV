
USE [BancoAlimentos_CNPV];
GO
IF OBJECT_ID(N'CNPV.ClientesCorporativos_Importacion', N'U') IS NULL
BEGIN
    CREATE TABLE CNPV.ClientesCorporativos_Importacion (
        IdCliente nvarchar(50) NULL,
        NombreEmpresa nvarchar(200) NULL,
        Ciudad nvarchar(100) NULL,
        Pais nvarchar(100) NULL,
        Telefono nvarchar(100) NULL
    );
END;
GO
TRUNCATE TABLE CNPV.ClientesCorporativos_Importacion;
GO

SELECT * FROM CNPV.ClientesCorporativos_Importacion
WHERE NULLIF(LTRIM(RTRIM(IdCliente)), '') IS NULL
   OR LEN(LTRIM(RTRIM(IdCliente))) > 5;

SELECT LTRIM(RTRIM(IdCliente)) AS IdCliente, COUNT(*) AS repeticiones
FROM CNPV.ClientesCorporativos_Importacion
GROUP BY LTRIM(RTRIM(IdCliente))
HAVING COUNT(*) > 1;

/* Duplicados que ya existen en la tabla de destino. */
SELECT s.*, c.NombreEmpresa AS EmpresaExistente
FROM CNPV.ClientesCorporativos_Importacion AS s
JOIN CNPV.ClientesCorporativos AS c
  ON c.IdCliente = LTRIM(RTRIM(s.IdCliente));

/* Inserta solo filas válidas y nuevas. Ejecuta primero en una copia de la base. */
SET XACT_ABORT ON;
BEGIN TRANSACTION;
INSERT INTO CNPV.ClientesCorporativos
    (IdCliente, NombreEmpresa, Ciudad, Pais, Telefono)
SELECT
    CONVERT(nchar(5), LTRIM(RTRIM(s.IdCliente))),
    NULLIF(LTRIM(RTRIM(s.NombreEmpresa)), ''),
    NULLIF(LTRIM(RTRIM(s.Ciudad)), ''),
    NULLIF(LTRIM(RTRIM(s.Pais)), ''),
    NULLIF(LTRIM(RTRIM(s.Telefono)), '')
FROM CNPV.ClientesCorporativos_Importacion AS s
WHERE NULLIF(LTRIM(RTRIM(s.IdCliente)), '') IS NOT NULL
  AND LEN(LTRIM(RTRIM(s.IdCliente))) <= 5
  AND NOT EXISTS (
      SELECT 1 FROM CNPV.ClientesCorporativos AS c
      WHERE c.IdCliente = LTRIM(RTRIM(s.IdCliente))
  )
  AND (SELECT COUNT(*) FROM CNPV.ClientesCorporativos_Importacion AS d
       WHERE LTRIM(RTRIM(d.IdCliente)) = LTRIM(RTRIM(s.IdCliente))) = 1;
SELECT @@ROWCOUNT AS registros_insertados;
COMMIT TRANSACTION;
GO
