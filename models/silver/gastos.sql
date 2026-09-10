SELECT
    last_day(movimiento.fecha) AS periodo,
    movimiento.recibo,
    movimiento.importe,
    CASE
        WHEN movimiento.es_comision_bancaria = TRUE THEN 'Comisiones bancarias'
        ELSE coalesce(gasto.categoria, 'No especificado')
    END AS tipo_gasto,
    gasto.concepto,
    movimiento.descripcion AS concepto_banco
FROM silver.bajio_movimientos AS movimiento
LEFT JOIN bronze.gsheets_gastos AS gasto
    ON movimiento.recibo = gasto.recibo_bancario
    AND movimiento.es_comision_bancaria = FALSE
WHERE movimiento.tipo = 'EGRESO'
