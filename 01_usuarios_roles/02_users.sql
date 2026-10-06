USE [BancoAlimentos_CNPV];
GO
IF DATABASE_PRINCIPAL_ID(N'banco_admin') IS NULL CREATE USER [banco_admin] FOR LOGIN [banco_admin];
IF DATABASE_PRINCIPAL_ID(N'banco_vendedor') IS NULL CREATE USER [banco_vendedor] FOR LOGIN [banco_vendedor];
IF DATABASE_PRINCIPAL_ID(N'banco_analista') IS NULL CREATE USER [banco_analista] FOR LOGIN [banco_analista];
GO
