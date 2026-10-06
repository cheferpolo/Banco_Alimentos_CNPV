"""Genera indicadores y un reporte HTML de inventario y entregas."""
import os
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd
import pyodbc
from dotenv import load_dotenv

load_dotenv()
ROOT = Path(__file__).resolve().parent
OUT = ROOT / "reportes"


def connect():
    required = ["DB_SERVER", "DB_DATABASE", "DB_USER", "DB_PASSWORD", "DB_DRIVER"]
    missing = [key for key in required if not os.getenv(key)]
    if missing:
        raise RuntimeError("Completa estas variables en .env: " + ", ".join(missing))
    conn_str = (
        f"DRIVER={{{os.environ['DB_DRIVER']}}};SERVER={os.environ['DB_SERVER']};"
        f"DATABASE={os.environ['DB_DATABASE']};UID={os.environ['DB_USER']};"
        f"PWD={os.environ['DB_PASSWORD']};Encrypt=yes;"
        f"TrustServerCertificate={os.getenv('DB_TRUST_SERVER_CERTIFICATE', 'yes')};"
    )
    return pyodbc.connect(conn_str)


def bar_chart(series, title, ylabel, filename):
    fig, ax = plt.subplots(figsize=(9, 4.5))
    if len(series):
        series.plot(kind="bar", ax=ax, color="#18836b")
    else:
        ax.text(.5, .5, "Sin datos disponibles", ha="center", va="center")
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.set_xlabel("")
    ax.tick_params(axis="x", labelrotation=30)
    fig.tight_layout()
    fig.savefig(OUT / filename, dpi=140)
    plt.close(fig)


def main():
    OUT.mkdir(exist_ok=True)
    with connect() as conn:
        deliveries = pd.read_sql_query(
            "SELECT Empresa, Categoria, Alimento, Organizacion, "
            "CantidadEntregada, FechaEntrega FROM CNPV.vw_DetalleEntregas", conn
        )
        stock = pd.read_sql_query(
            "SELECT A.Nombre AS Alimento, C.NombreCategoria AS Categoria, "
            "A.Cantidad, A.UnidadMedida, A.FechaVencimiento "
            "FROM CNPV.Alimentos AS A "
            "LEFT JOIN CNPV.CategoriaAlimento AS C ON C.IdCategoria=A.IdCategoria", conn
        )

    deliveries["FechaEntrega"] = pd.to_datetime(deliveries["FechaEntrega"], errors="coerce")
    deliveries["CantidadEntregada"] = pd.to_numeric(
        deliveries["CantidadEntregada"], errors="coerce"
    ).fillna(0)
    stock["Cantidad"] = pd.to_numeric(stock["Cantidad"], errors="coerce").fillna(0)

    total_deliveries = len(deliveries)
    quantity_delivered = deliveries["CantidadEntregada"].sum()
    organizations = deliveries["Organizacion"].nunique()
    donors = deliveries["Empresa"].nunique()
    food_types = deliveries["Alimento"].nunique()
    current_stock = stock["Cantidad"].sum()

    by_category = deliveries.groupby("Categoria")["CantidadEntregada"].sum().sort_values(ascending=False)
    by_period = (deliveries.dropna(subset=["FechaEntrega"])
                 .assign(Periodo=lambda d: d["FechaEntrega"].dt.to_period("M").astype(str))
                 .groupby("Periodo")["CantidadEntregada"].sum())
    by_organization = deliveries.groupby("Organizacion")["CantidadEntregada"].sum().nlargest(10)
    by_donor = deliveries.groupby("Empresa")["CantidadEntregada"].sum().nlargest(10)
    by_food = stock.groupby("Alimento")["Cantidad"].sum().nlargest(10)

    charts = [
        (by_category, "Alimentos entregados por categoría", "Cantidad", "entregas_categoria.png"),
        (by_period, "Cantidad entregada por periodo", "Cantidad", "entregas_periodo.png"),
        (by_organization, "Top 10 organizaciones por cantidad recibida", "Cantidad", "top_organizaciones.png"),
        (by_donor, "Top 10 empresas donantes por cantidad entregada", "Cantidad", "top_donantes.png"),
        (by_food, "Stock disponible por alimento (top 10)", "Cantidad en inventario", "stock_alimentos.png"),
    ]
    for series, title, ylabel, filename in charts:
        bar_chart(series, title, ylabel, filename)

    conclusions = [
        f"Se registran {total_deliveries:,} entregas, con {quantity_delivered:,.0f} unidades distribuidas.",
        f"Las entregas atendieron a {organizations:,} organizaciones y participaron {donors:,} empresas donantes.",
        f"El inventario actual suma {current_stock:,.0f} unidades entre {stock['Alimento'].nunique():,} alimentos.",
        (f"La categoría con mayor cantidad entregada es {by_category.index[0]} "
         f"({by_category.iloc[0]:,.0f} unidades)." if len(by_category) else "No hay entregas para comparar categorías."),
        (f"El periodo con más unidades entregadas es {by_period.idxmax()} "
         f"({by_period.max():,.0f} unidades)." if len(by_period) else "No hay fechas de entrega válidas para comparar periodos."),
        (f"La organización que recibió más alimentos es {by_organization.index[0]} "
         f"({by_organization.iloc[0]:,.0f} unidades)." if len(by_organization) else "No hay organizaciones con entregas registradas."),
        f"El catálogo de entregas consultado incluye {food_types:,} alimentos distintos.",
    ]
    kpis = pd.DataFrame({
        "Indicador": ["Entregas", "Cantidad distribuida", "Organizaciones atendidas", "Empresas donantes", "Alimentos distintos", "Stock actual"],
        "Valor": [f"{total_deliveries:,}", f"{quantity_delivered:,.0f}", f"{organizations:,}", f"{donors:,}", f"{food_types:,}", f"{current_stock:,.0f}"],
    })
    html = [
        "<!doctype html><html lang='es'><meta charset='utf-8'><title>Reporte del Banco de Alimentos</title>",
        "<style>body{font:16px Arial;max-width:1100px;margin:2rem auto;color:#19372f}table{border-collapse:collapse}td,th{padding:.55rem;border:1px solid #bbb}img{max-width:100%}section{margin:1.5rem 0}</style>",
        "<h1>Reporte de inventario y entregas</h1><h2>Indicadores</h2>", kpis.to_html(index=False), "<h2>Gráficos</h2>",
    ]
    for _, title, _, filename in charts:
        html.append(f"<section><h3>{title}</h3><img src='{filename}' alt='{title}'></section>")
    html += ["<h2>Conclusiones</h2><ol>" + "".join(f"<li>{item}</li>" for item in conclusions) + "</ol>",
             "<h2>Detalle de entregas</h2>", deliveries.head(200).to_html(index=False, border=0),
             "<h2>Inventario</h2>", stock.head(200).to_html(index=False, border=0), "</html>"]
    (OUT / "reporte.html").write_text("\n".join(html), encoding="utf-8")
    print(f"Reporte generado: {OUT / 'reporte.html'}")


if __name__ == "__main__":
    main()
