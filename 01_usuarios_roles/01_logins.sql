USE [master];
GO
/* Reemplaza cada marcador por una contraseña segura y distinta antes de ejecutar.
   No publiques las contraseñas reales. */
IF SUSER_ID(N'banco_admin') IS NULL
    CREATE LOGIN [banco_admin] WITH PASSWORD = N'REEMPLAZAR_CON_CLAVE_SEGURA_ADMIN', CHECK_POLICY = ON;
GO
IF SUSER_ID(N'banco_vendedor') IS NULL
    CREATE LOGIN [banco_vendedor] WITH PASSWORD = N'REEMPLAZAR_CON_CLAVE_SEGURA_VENDEDOR', CHECK_POLICY = ON;
GO
IF SUSER_ID(N'banco_analista') IS NULL
    CREATE LOGIN [banco_analista] WITH PASSWORD = N'REEMPLAZAR_CON_CLAVE_SEGURA_ANALISTA', CHECK_POLICY = ON;
GO
