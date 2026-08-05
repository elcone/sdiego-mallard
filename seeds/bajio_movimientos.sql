INSERT INTO silver.bajio_movimientos
SELECT *
FROM read_parquet('silver.bajio_movimientos.parquet')
ORDER BY fecha_y_hora;

INSERT INTO bronze.bajio_movimientos
SELECT
    strftime(fecha, '%d-%B-%Y'),
    fecha_y_hora::TIME,
    recibo,
    descripcion,
    cargos,
    abonos,
    saldo
FROM silver.bajio_movimientos
ORDER BY fecha_y_hora;
