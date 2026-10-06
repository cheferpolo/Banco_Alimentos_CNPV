# Dashboard Power BI del Banco de Alimentos

Esta es la alternativa Power BI elegida para el examen. Se conecta a `BancoAlimentos_CNPV` y analiza entregas de alimentos, empresas donantes, organizaciones y stock. El script de la base no registra pagos ni valores monetarios, así que no corresponde mostrar ingresos ni ticket promedio; los indicadores usan cantidades físicas.

## 1. Conectar Power BI a SQL Server

1. Abre Power BI Desktop y selecciona **Obtener datos > SQL Server**.
2. Escribe el nombre de tu servidor (el mismo que usas en SSMS) y la base `BancoAlimentos_CNPV`.
3. Elige **Importar** para este trabajo y pulsa **Aceptar**.
4. En autenticación selecciona **Base de datos** e inicia con `banco_analista` y la contraseña que configuraste. No marques ni guardes credenciales en capturas.
5. En el navegador selecciona `CNPV.vw_DetalleEntregas`, `CNPV.Alimentos`, `CNPV.CategoriaAlimento`, `CNPV.EmpresasDonantes` y `CNPV.Organizaciones`; elige **Transformar datos**.
6. En Power Query renombra las consultas a `FactEntregas`, `Inventario`, `Donantes` y `Organizaciones`. Para combinar Alimentos con CategoriaAlimento, usa la consulta M de `Consultas_M.txt` o expande `IdCategoria` a `NombreCategoria`.
7. Revisa los tipos: `FechaEntrega` y `FechaVencimiento` como Fecha; `CantidadEntregada` y `Cantidad` como Número entero; después selecciona **Cerrar y aplicar**.

Si las tablas no aparecen, confirma que el usuario `banco_analista` tiene `SELECT` en ellas y que la vista existe. No escribas la contraseña en una consulta, archivo M, captura o repositorio.

## 2. Modelo

Usa `FactEntregas` como tabla de hechos, alimentada por la vista existente `CNPV.vw_DetalleEntregas`. Crea la tabla calendario pegando `Calendario.dax` en **Modelado > Nueva tabla**; relaciona `DimFecha[Date]` (lado 1) con `FactEntregas[FechaEntrega]` (lado muchos). Marca `DimFecha` como tabla de fechas.

`Inventario`, `Donantes` y `Organizaciones` dan contexto para sus KPI y visuales. La vista de entregas no expone IDs de empresa u organización; por eso no fuerces relaciones por nombres que podrían repetirse. Usa los campos de nombre desde `FactEntregas` en sus gráficos y segmentadores. Ordena `DimFecha[Mes]` por `DimFecha[MesNumero]`.

## 3. Medidas e indicadores

Crea cada medida de `Medidas.dax` por separado desde **Modelado > Nueva medida**. Incluye cantidad y número de entregas, organizaciones alcanzadas, donantes con entregas, donantes registrados, alimentos diferentes, stock y stock vencido. Usa cuatro tarjetas principales: **Cantidad distribuida**, **Entregas**, **Organizaciones atendidas** y **Stock disponible**.

## 4. Página del dashboard

- Tarjetas: cantidad distribuida, total de entregas, organizaciones atendidas y stock actual.
- Columnas: cantidad entregada por categoría.
- Línea: cantidad entregada por mes.
- Barras horizontales: top 10 organizaciones por cantidad recibida.
- Barras horizontales: top 10 empresas por cantidad entregada.
- Tabla de inventario: alimento, categoría, cantidad, unidad de medida y fecha de vencimiento; aplica formato condicional a productos vencidos o próximos a vencer.
- Segmentadores: periodo, categoría, empresa donante y organización.

## 5. Conclusiones y evidencia

Redacta al menos cinco conclusiones con los valores visibles en tu informe: periodo con más unidades entregadas, categoría más distribuida, organización que recibió más alimentos, empresa con mayor aporte y productos vencidos o próximos a vencer. Evita afirmaciones genéricas: indica cifras y periodo que aparecen en tus datos.

Guarda el archivo como `BancoAlimentos_CNPV.pbix`. Exporta una captura del dashboard a `../evidencias/reporte_powerbi.png` y documenta en esta carpeta el origen SQL, el modelo, las medidas, las visualizaciones y los resultados observados. Oculta servidor sensible, nombres de usuario si corresponde y cualquier contraseña en capturas.
