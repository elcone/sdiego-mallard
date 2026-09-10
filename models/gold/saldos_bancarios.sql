WITH ultimos_movimientos AS (
    SELECT
        last_day(fecha_y_hora) AS mes,
        max(fecha_y_hora) AS fecha_y_hora
    FROM silver.bajio_movimientos
    GROUP BY 1
)

SELECT
    mes,
    saldo
FROM ultimos_movimientos AS ult_mov
INNER JOIN silver.bajio_movimientos AS movimiento ON ult_mov.fecha_y_hora = movimiento.fecha_y_hora
WHERE movimiento.es_comision_bancaria = FALSE
