WITH saldo AS (
    SELECT
        fecha,
        fecha_y_hora,
        saldo,
        row_number() OVER (PARTITION BY last_day(fecha) ORDER BY fecha_y_hora DESC) AS rn
    FROM silver.bajio_movimientos
)

SELECT
    last_day(fecha) AS periodo,
    saldo
FROM saldo
WHERE rn = 1
