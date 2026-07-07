-- Vistas globales con postgres_fdw
-- Ejecutar en pg-campus

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Servidores foraneos (los 3 contenedores comparten la red de docker-compose,
-- por eso se usa el nombre del contenedor como host y el puerto interno 5432)
CREATE SERVER server_babahoyo
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'pg-babahoyo', port '5432', dbname 'cafeteria');

CREATE SERVER server_ventanas
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'pg-ventanas', port '5432', dbname 'cafeteria');

-- Mapeo de usuario para autenticarse en los servidores remotos
CREATE USER MAPPING FOR admin
    SERVER server_babahoyo
    OPTIONS (user 'admin', password 'admin123');

CREATE USER MAPPING FOR admin
    SERVER server_ventanas
    OPTIONS (user 'admin', password 'admin123');

-- Foreign tables hacia los fragmentos horizontales de pedidos
CREATE FOREIGN TABLE pedidos_babahoyo (
    pedido_id INTEGER,
    cliente_id INTEGER,
    producto_id INTEGER,
    fecha DATE,
    monto NUMERIC(8,2),
    sede VARCHAR(20)
) SERVER server_babahoyo OPTIONS (schema_name 'public', table_name 'pedidos');

CREATE FOREIGN TABLE pedidos_ventanas (
    pedido_id INTEGER,
    cliente_id INTEGER,
    producto_id INTEGER,
    fecha DATE,
    monto NUMERIC(8,2),
    sede VARCHAR(20)
) SERVER server_ventanas OPTIONS (schema_name 'public', table_name 'pedidos');

-- Vista global de pedidos: union de los 3 fragmentos horizontales
CREATE VIEW pedidos_global AS
    SELECT * FROM pedidos
    UNION ALL
    SELECT * FROM pedidos_babahoyo
    UNION ALL
    SELECT * FROM pedidos_ventanas;

-- Foreign table hacia el fragmento vertical de contacto (en pg-babahoyo)
CREATE FOREIGN TABLE clientes_contacto_fdw (
    cliente_id INTEGER,
    email VARCHAR(120),
    telefono VARCHAR(20)
) SERVER server_babahoyo OPTIONS (schema_name 'public', table_name 'clientes_contacto');

-- Vista global de clientes: join de los 2 fragmentos verticales
CREATE VIEW clientes_global AS
    SELECT p.cliente_id, p.nombre, p.ciudad, c.email, c.telefono
    FROM clientes_publicos p
    JOIN clientes_contacto_fdw c ON p.cliente_id = c.cliente_id;
