WITH cargo AS (
    SELECT
        casa,
        max(periodo) AS ultimo_periodo,
        sum(cuota) + sum(coalesce(recargos, 0)) AS total_cargos,
    FROM bronze.gsheets_cuotas AS cargo
    WHERE last_day(periodo) <= last_day(current_date)
    GROUP BY casa
),

pago AS (
    SELECT
        casa,
        sum(importe) AS total_pagos
    FROM silver.pagos_de_casas
    GROUP BY casa
)

SELECT
    cargo.casa,
    cargo.ultimo_periodo,
    cargo.total_cargos,
    pago.total_pagos,
    total_cargos - total_pagos AS saldo
FROM cargo
LEFT JOIN pago ON pago.casa = cargo.casa
