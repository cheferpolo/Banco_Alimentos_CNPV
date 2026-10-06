/* Un BACPAC se importa como una nueva base desde SSMS > Import Data-tier Application
   o SqlPackage /Action:Import. El destino debe ser un nombre nuevo o una base vacía.
   Verifica permisos, espacio disponible, tablas, conteos y usuarios después de importar. */
/* Ejemplo:
SqlPackage /Action:Import /TargetServerName:"SERVIDOR" /TargetDatabaseName:"BancoAlimentos_CNPV_Restaurada" /SourceFile:"C:\\Backups\\BancoAlimentos_CNPV_Full.bacpac" /TargetTrustServerCertificate:True
*/
