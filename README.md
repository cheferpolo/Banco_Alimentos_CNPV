# BancoAlimentos CNPV

Proyecto de seguridad, importación de clientes y análisis para la base SQL Server `BancoAlimentos_CNPV`. Está adaptado al esquema compartido: empresas donantes, alimentos, entregas, organizaciones, clientes corporativos y vistas de reporte. La alternativa elegida para el examen es **Power BI**, documentada en `06_powerbi/`.

La base no registra pagos ni importes monetarios; por eso el dashboard analiza unidades distribuidas e inventario, sin calcular ingresos o ticket promedio. El módulo `06_python/` se conserva como material adicional, pero la entrega analítica seleccionada es Power BI.

## Tecnologías y requisitos

- SQL Server, SSMS, T-SQL y BCP.
- Power BI Desktop y Microsoft ODBC Driver 18 for SQL Server.
- Python 3.10+ solo si se desea conservar/ejecutar el módulo adicional.
- Git y GitHub para publicar el proyecto y evidencias.

## Estructura

```text
BancoAlimentos_CNPV/
├── 01_usuarios_roles/          # logins, users, roles y permisos
├── 02_importacion_exportacion/ # staging, BCP, validación e inserción
├── 03_backups/                 # exportación e importación BACPAC
├── 04_seguridad/               # comprobación de mínimo privilegio
├── 05_reportes/                # consultas sobre entregas e inventario
├── 06_powerbi/                 # conexión, modelo, medidas DAX y dashboard
├── 06_python/                  # alternativa adicional conservada
└── evidencias/                 # capturas reales por completar
```

## Orden de ejecución

1. Confirma que la base `BancoAlimentos_CNPV` y los objetos del script compartido estén instalados.
2. En SSMS, ejecuta `01_usuarios_roles/01_logins.sql` desde `master`. Reemplaza localmente los marcadores por contraseñas seguras y distintas; no las guardes en Git.
3. Ejecuta `02_users.sql`, `03_roles.sql` y `04_permisos.sql` en ese orden. `banco_admin` recibe `db_owner`; vendedor y analista usan permisos limitados.
4. Ejecuta `04_seguridad/pruebas_permisos.sql` y guarda capturas sin contraseñas.
5. Sigue `06_powerbi/README.md` para conectar Power BI con el usuario de solo lectura, cargar las consultas, crear medidas y diseñar el reporte.

## Importación de clientes corporativos

El destino es `CNPV.ClientesCorporativos`: `IdCliente` (máximo 5 caracteres), `NombreEmpresa`, `Ciudad`, `Pais` y `Telefono`. Prepara el CSV con esos encabezados, ajusta ruta y servidor en `02_importacion_exportacion/importacion.sql`, carga al staging, revisa inválidos y duplicados y luego inserta filas nuevas. Prueba primero en una copia de la base.

## Backup y restauración

La evaluación pide exportación `.bacpac`, una exportación lógica de datos y esquema. Sigue `03_backups/backup_full.sql` y `03_backups/restauracion.sql`; adapta las rutas. Mantén los BACPAC fuera de GitHub.

## Power BI

El reporte usa `CNPV.vw_DetalleEntregas` y `CNPV.Alimentos`. Incluye unidades entregadas, número de entregas, organizaciones atendidas, donantes e inventario; gráficos por categoría, periodo, organización y empresa donante; y conclusiones basadas en datos. Completa `evidencias/reporte_powerbi.png` con una captura de tu propio dashboard.

## GitHub y evidencias

`.gitignore` excluye `.env`, entornos virtuales, logs, archivos temporales y backups. Publica el proyecto en GitHub y registra al menos cinco commits que reflejen cambios reales. Completa evidencias de seguridad, backup, repositorio y reporte sin exponer contraseñas.

## Autor

Completar con el nombre del estudiante.
