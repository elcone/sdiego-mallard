-- Backup silver.bajio_movimientos
-- CREATE SCHEMA IF NOT EXISTS backups;
-- CREATE OR REPLACE TABLE backups.silver_bajio_movimientos_<BACKUP_DATE> AS
-- SELECT * FROM silver.bajio_movimientos;

TRUNCATE TABLE staging.bajio_movimientos;

INSERT INTO staging.bajio_movimientos
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
)

SELECT
    row_number() OVER (),
    strftime(fecha, '%d-')
        || meses.mes
        || strftime(fecha, '-%Y')
    AS fecha_movimiento,
    strftime(fecha_y_hora, '%H:%M:%S') AS hora,
    recibo,
    descripcion,
    cargos,
    abonos,
    saldo,
    NULL,
    NULL,
    NULL
FROM silver.bajio_movimientos AS movimiento
LEFT JOIN meses ON month(fecha) = meses.numero;
