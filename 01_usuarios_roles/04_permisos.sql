USE [BancoAlimentos_CNPV];
GO
/* Permisos ajustados al esquema real del script entregado.
   Vendedor: consulta y registra donantes/alimentos; registra entregas mediante
   el procedimiento que también descuenta stock, preservando la integridad.
   No se concede UPDATE ni DELETE directo. */
GRANT SELECT, INSERT ON OBJECT::CNPV.EmpresasDonantes TO rol_vendedor;
GRANT SELECT, INSERT ON OBJECT::CNPV.Alimentos TO rol_vendedor;
GRANT SELECT ON OBJECT::CNPV.Entregas TO rol_vendedor;
GRANT SELECT ON OBJECT::CNPV.Organizaciones TO rol_vendedor;
GRANT SELECT ON OBJECT::CNPV.CategoriaAlimento TO rol_vendedor;
GRANT SELECT, INSERT ON OBJECT::CNPV.ClientesCorporativos TO rol_vendedor;
GRANT EXECUTE ON OBJECT::CNPV.sp_RegistrarEmpresa TO rol_vendedor;
GRANT EXECUTE ON OBJECT::CNPV.sp_RegistrarAlimento TO rol_vendedor;
GRANT EXECUTE ON OBJECT::CNPV.sp_RegistrarEntrega TO rol_vendedor;
GRANT EXECUTE ON OBJECT::CNPV.sp_ConsultarStock TO rol_vendedor;

/* Analista: solo lectura para consultar donaciones, stock y distribución. */
GRANT SELECT ON OBJECT::CNPV.EmpresasDonantes TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.Alimentos TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.Entregas TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.Organizaciones TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.CategoriaAlimento TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.CategoriaEmpresa TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.ClientesCorporativos TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.vw_DetalleEntregas TO rol_analista;
GRANT SELECT ON OBJECT::CNPV.vw_EmpresasActivas TO rol_analista;
GO
