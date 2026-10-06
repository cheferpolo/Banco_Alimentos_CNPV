USE [BancoAlimentos_CNPV];
GO
/* Consultas para el esquema existente. vw_DetalleEntregas expone:
   Empresa, Categoria, Alimento, Organizacion, CantidadEntregada, FechaEntrega. */
SELECT COUNT(*) AS TotalEntregas,
       SUM(CantidadEntregada) AS TotalAlimentosEntregados,
       COUNT(DISTINCT Organizacion) AS OrganizacionesAtendidas,
       COUNT(DISTINCT Empresa) AS EmpresasDonantes
FROM CNPV.vw_DetalleEntregas;

SELECT Categoria, SUM(CantidadEntregada) AS CantidadEntregada
FROM CNPV.vw_DetalleEntregas
GROUP BY Categoria ORDER BY CantidadEntregada DESC;

SELECT CONVERT(char(7), FechaEntrega, 126) AS Periodo,
       COUNT(*) AS Entregas, SUM(CantidadEntregada) AS CantidadEntregada
FROM CNPV.vw_DetalleEntregas
GROUP BY CONVERT(char(7), FechaEntrega, 126) ORDER BY Periodo;

SELECT TOP (10) Organizacion,
       SUM(CantidadEntregada) AS CantidadRecibida,
       COUNT(*) AS NumeroEntregas
FROM CNPV.vw_DetalleEntregas
GROUP BY Organizacion ORDER BY CantidadRecibida DESC;

SELECT Empresa, SUM(CantidadEntregada) AS CantidadDonada
FROM CNPV.vw_DetalleEntregas
GROUP BY Empresa ORDER BY CantidadDonada DESC;

SELECT C.NombreCategoria AS Categoria, SUM(A.Cantidad) AS StockDisponible
FROM CNPV.Alimentos AS A
JOIN CNPV.CategoriaAlimento AS C ON C.IdCategoria = A.IdCategoria
GROUP BY C.NombreCategoria ORDER BY StockDisponible DESC;
GO
