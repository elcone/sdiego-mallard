SELECT
    last_day(movimiento.fecha) AS periodo,
    movimiento.recibo,
    movimiento.importe,
    CASE
        WHEN cuota.casa IS NOT NULL THEN 'Cuotas'
        ELSE 'No especificado'
    END AS tipo_ingreso,
    movimiento.descripcion AS concepto_banco
FROM silver.bajio_movimientos AS movimiento
LEFT JOIN bronze.gsheets_cuotas AS cuota ON cuota.recibo_bancario = movimiento.recibo
WHERE movimiento.tipo = 'INGRESO'
