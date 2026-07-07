-- Fragmentacion mixta de clientes: corte horizontal por ciudad (Babahoyo o Ventanas)
-- + corte vertical (datos publicos)
-- Ejecutar en pg-ventanas

CREATE TABLE clientes_mixta_bv_publicos (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes_mixta_bv_publicos VALUES
    (2, 'Luis Cedeno', 'Babahoyo'),
    (4, 'Jose Mendoza', 'Ventanas'),
    (5, 'Carla Zambrano', 'Ventanas'),
    (6, 'Pedro Suarez', 'Babahoyo');
