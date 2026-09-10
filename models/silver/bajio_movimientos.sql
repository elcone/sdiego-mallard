WITH meses AS (
    SELECT *
    FROM (
        VALUES
            ('Ene', 1),
            ('Feb', 2),
            ('Mar', 3),
            ('Abr', 4),
            ('May', 5),
            ('Jun', 6),
            ('Jul', 7),
            ('Ago', 8),
            ('Sep', 9),
            ('Oct', 10),
            ('Nov', 11),
            ('Dic', 12)
    ) AS meses (mes, numero)
),

movimientos AS (
    SELECT
        movimiento.hora,
        movimiento.recibo,
        movimiento.descripcion,
        movimiento.cargos,
        movimiento.abonos,
        movimiento.saldo,
        make_date(
            split_part(movimiento.fecha_movimiento, '-', 3)::integer,
            mes.numero,
            split_part(movimiento.fecha_movimiento, '-', 1)::integer
        ) AS fecha,
        CASE
            WHEN movimiento.cargos IS NOT NULL THEN 'EGRESO'
            WHEN movimiento.abonos IS NOT NULL THEN 'INGRESO'
        END AS tipo,
        CASE
            WHEN movimiento.descripcion LIKE 'IVA Comisión por Transferencia%' THEN TRUE
            WHEN movimiento.descripcion LIKE 'Comisión por Transferencia%' THEN TRUE
            WHEN movimiento.descripcion LIKE 'IVA Comisión por Administración%' THEN TRUE
            WHEN movimiento.descripcion LIKE 'Comisión por Administración%' THEN TRUE
            ELSE FALSE
        END AS es_comision_bancaria,
        CASE
            WHEN movimiento.descripcion LIKE 'Devolución de SPEI%' THEN TRUE
            ELSE FALSE
        END AS es_devolucion_spei,
        CASE
            WHEN movimiento.cargos IS NOT NULL THEN movimiento.cargos
            WHEN movimiento.abonos IS NOT NULL THEN movimiento.abonos
        END AS importe,
        try_cast(regexp_extract(movimiento.descripcion, '6\d{3}\b') AS int) AS casa,
        CASE
            WHEN tipo = 'INGRESO' THEN
            nullif(regexp_extract(descripcion, 'Concepto del Pago:\s*(.*?)\s*\|', 1), '')
        END AS concepto
    FROM bronze.bajio_movimientos AS movimiento
    LEFT JOIN meses AS mes ON mes.mes = split_part(movimiento.fecha_movimiento, '-', 2)
    WHERE EXISTS (
        SELECT 1
        FROM staging.bajio_movimientos
        WHERE recibo = movimiento.recibo
    )
)

SELECT
    fecha,
    fecha + hora AS fecha_y_hora,
    tipo,
    es_comision_bancaria,
    es_devolucion_spei,
    importe,
    recibo,
    descripcion,
    cargos,
    abonos,
    saldo,
    CASE
        WHEN tipo = 'INGRESO' THEN
            coalesce(
                try_cast(regexp_extract(concepto, '6\d{3}\b') AS int),
                casa
            )
    END AS casa,
    CASE
        WHEN tipo = 'INGRESO' THEN
        nullif(regexp_extract(descripcion, 'Institucion contraparte:\s*(.*?)\s*Ordenante:', 1), '')
    END AS banco_origen,
    CASE
        WHEN tipo = 'INGRESO' THEN
        nullif(regexp_extract(descripcion, 'Ordenante:\s*(.*?)\s*Cuenta Ordenante:', 1), '')
    END AS ordenante,
    CASE
        WHEN tipo = 'INGRESO' THEN
        nullif(regexp_extract(descripcion, 'Cuenta Ordenante:\s*(\d+)', 1), '')
    END AS cuenta_ordenante,
    CASE
        WHEN tipo = 'INGRESO' THEN
        nullif(regexp_extract(descripcion, 'RFC Ordenante:\s*([A-Z0-9]+)', 1), '')
    END AS rfc_ordenante,
    CASE
        WHEN tipo = 'INGRESO' THEN
        nullif(regexp_extract(descripcion, 'Clave de Rastreo:\s*(.*?)\s*Concepto del Pago:', 1), '')
    END AS clave_rastreo
FROM movimientos
