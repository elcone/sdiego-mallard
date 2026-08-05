WITH aplicacion_recibo AS (
    SELECT DISTINCT casa, recibo_bancario AS recibo
    FROM bronze.gsheets_cuotas
    WHERE recibo_bancario IS NOT NULL
)

SELECT
    pago.fecha,
    pago.fecha_y_hora,
    pago.recibo,
    aplicacion.casa,
    pago.importe
FROM silver.bajio_movimientos AS pago
LEFT JOIN aplicacion_recibo AS aplicacion ON aplicacion.recibo = pago.recibo
WHERE pago.tipo = 'INGRESO'
