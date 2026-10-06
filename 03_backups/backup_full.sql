/* Entrega solicitada: exportación completa .bacpac. Usar SSMS > Tasks > Export Data-tier Application,
   o SqlPackage /Action:Export. Esto requiere permisos y acceso a tu instancia local. */
/* Ejemplo de SqlPackage (actualiza ruta y servidor; autentícate de forma segura):
SqlPackage /Action:Export /SourceServerName:"SERVIDOR" /SourceDatabaseName:"BancoAlimentos_CNPV" /TargetFile:"C:\\Backups\\BancoAlimentos_CNPV_Full.bacpac" /SourceTrustServerCertificate:True
*/
/* No almacenes el BACPAC en Git. La ruta es específica de cada equipo. */
