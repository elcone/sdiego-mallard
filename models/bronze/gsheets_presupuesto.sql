SELECT
    strptime(Periodo, '%d/%m/%Y')::date AS periodo,
    "Categoría" AS categoria,
    try_cast(
        regexp_replace(Importe, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS importe,
    try_cast(
        regexp_replace(Ejercido, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS ejercido,
    try_cast(
        regexp_replace(Diferencia, '[\$,]', '', 'g')
        AS decimal(12,2)
    ) AS diferencia
FROM staging.gsheets_presupuesto
