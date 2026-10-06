# Reportes Python del Banco de Alimentos

El script usa el esquema real `CNPV` y la vista `CNPV.vw_DetalleEntregas`. Lee también inventario desde `CNPV.Alimentos` y categorías desde `CNPV.CategoriaAlimento`. Como el esquema no registra pagos o importes monetarios, los indicadores son cantidades distribuidas y disponibles.

Configura `.env` con una cuenta de solo lectura, instala las dependencias y ejecuta `python app.py`. El archivo `reportes/reporte.html` incluye indicadores, cinco gráficos, tablas y conclusiones calculadas a partir de los registros consultados.
