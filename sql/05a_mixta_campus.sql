
CREATE TABLE clientes_mixta_quevedo_publicos (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes_mixta_quevedo_publicos VALUES
    (1, 'Maria Alvarado', 'Quevedo'),
    (3, 'Ana Vera', 'Quevedo');
