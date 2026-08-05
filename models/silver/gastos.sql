SELECT
    last_day(movimiento.fecha) AS periodo,
    movimiento.recibo,
    movimiento.importe,
    coalesce(gasto.categoria, 'No especificado') AS tipo_gasto,
    gasto.concepto,
    movimiento.descripcion AS concepto_banco
FROM silver.bajio_movimientos AS movimiento
LEFT JOIN bronze.gsheets_gastos AS gasto ON movimiento.recibo = gasto.recibo_bancario
WHERE movimiento.tipo = 'EGRESO'
