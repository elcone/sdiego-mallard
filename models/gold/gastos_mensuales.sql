WITH cte_gastos AS (
    SELECT
        periodo,
        tipo_gasto,
        sum(importe) AS importe
    FROM silver.gastos
    GROUP BY
        periodo,
        tipo_gasto
)

SELECT
    periodo,
    tipo_gasto,
    importe,
    lag(importe) OVER (PARTITION BY tipo_gasto ORDER BY periodo) AS "importe_periodo_anterior",
    importe - "importe_periodo_anterior" AS "importe_delta",
    "importe_delta" / "importe_periodo_anterior" AS porc_delta
FROM cte_gastos
