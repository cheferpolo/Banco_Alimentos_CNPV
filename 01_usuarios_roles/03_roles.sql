USE [BancoAlimentos_CNPV];
GO
IF DATABASE_PRINCIPAL_ID(N'rol_vendedor') IS NULL CREATE ROLE [rol_vendedor];
IF DATABASE_PRINCIPAL_ID(N'rol_analista') IS NULL CREATE ROLE [rol_analista];
ALTER ROLE [rol_vendedor] ADD MEMBER [banco_vendedor];
ALTER ROLE [rol_analista] ADD MEMBER [banco_analista];

ALTER ROLE [db_owner] ADD MEMBER [banco_admin];
GO
