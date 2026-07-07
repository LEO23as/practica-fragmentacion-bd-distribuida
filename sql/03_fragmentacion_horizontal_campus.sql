
ALTER TABLE pedidos RENAME TO pedidos_centralizado_original;

CREATE TABLE pedidos (
    pedido_id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    monto NUMERIC(8,2) NOT NULL,
    sede VARCHAR(20) NOT NULL
);

-- Solo los pedidos de la sede Campus
INSERT INTO pedidos VALUES (1, 1, 1, '2026-03-01', 0.75, 'Campus');
INSERT INTO pedidos VALUES (3, 3, 2, '2026-03-02', 1.00, 'Campus');
INSERT INTO pedidos VALUES (7, 1, 3, '2026-03-04', 2.50, 'Campus');
