SELECT
    strptime(Fecha, '%d/%m/%Y')::date AS fecha,
    "Categoría" AS categoria,
    Concepto AS concepto,
    try_cast(
        regexp_replace(Importe, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS importe,
    upper(Estado) AS estado,
    Comprobante AS comprobante_gasto,
    Pago AS comprobante_pago,
    Comentarios AS comentarios,
    "Recibo bancario" AS recibo_bancario
FROM staging.gsheets_gastos
WHERE Fecha IS NOT NULL
