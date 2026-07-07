SELECT COUNT(*) AS total_pedidos_global FROM pedidos_global;

SELECT sede, SUM(monto) AS total_monto
FROM pedidos_global
GROUP BY sede
ORDER BY sede;

SELECT sede, SUM(monto) AS total_monto
FROM pedidos_centralizado_original
GROUP BY sede
ORDER BY sede;


SELECT pedido_id, COUNT(*)
FROM pedidos_global
GROUP BY pedido_id
HAVING COUNT(*) > 1;
