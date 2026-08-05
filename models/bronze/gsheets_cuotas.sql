SELECT
    strptime(Periodo, '%d/%m/%Y')::date AS periodo,
    "Número de casa"::INTEGER AS casa,
    try_cast(
        regexp_replace("Cuota", '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS cuota,
    try_cast(
        regexp_replace(Recargos, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS recargos,
    try_cast(
        regexp_replace(Pagos, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS pagos,
    try_cast(
        regexp_replace(Saldo, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS saldo,
    upper(Estado) AS estado,
    strptime("Fecha de pago", '%d/%m/%Y')::date AS fecha_pago,
    "Comprobante de pago" AS comprobante_pago,
    try_cast(
        regexp_replace("Recaudación", '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS importe_recaudado,
    "Conciliado con banco" AS conciliado_con_banco,
    "Recibo bancario" AS recibo_bancario,
    "Comentarios" AS comentarios,
    CASE
        WHEN strptime(Periodo, '%d/%m/%Y') <= current_date THEN 'VENCIDO'
        WHEN last_day(strptime(Periodo, '%d/%m/%Y')) = last_day(current_date) THEN 'POR VENCER'
        ELSE 'PENDIENTE'
    END AS vencimiento
FROM staging.gsheets_cuotas
