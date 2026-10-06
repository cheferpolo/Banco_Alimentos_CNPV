USE [BancoAlimentos_CNPV];
GO

EXECUTE AS USER = N'banco_analista';
SELECT
    HAS_PERMS_BY_NAME(N'CNPV.Alimentos', N'OBJECT', N'SELECT') AS puede_consultar_alimentos,
    HAS_PERMS_BY_NAME(N'CNPV.Entregas', N'OBJECT', N'SELECT') AS puede_consultar_entregas,
    HAS_PERMS_BY_NAME(N'CNPV.Alimentos', N'OBJECT', N'INSERT') AS puede_insertar,
    HAS_PERMS_BY_NAME(N'CNPV.Alimentos', N'OBJECT', N'UPDATE') AS puede_actualizar,
    HAS_PERMS_BY_NAME(N'CNPV.Alimentos', N'OBJECT', N'DELETE') AS puede_eliminar;
SELECT TOP (0) * FROM CNPV.vw_DetalleEntregas; -- Debe permitirse
REVERT;
GO

SELECT r.name AS rol, p.permission_name, p.state_desc, o.name AS objeto
FROM sys.database_permissions AS p
JOIN sys.objects AS o ON o.object_id = p.major_id
JOIN sys.database_principals AS r ON r.principal_id = p.grantee_principal_id
WHERE r.name IN (N'rol_analista', N'rol_vendedor')
  AND o.name IN (N'Alimentos', N'Entregas', N'EmpresasDonantes', N'Organizaciones')
ORDER BY r.name, o.name, p.permission_name;
GO
