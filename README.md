# Practica de Fragmentacion de Base de Datos Distribuida

Aplicaciones Distribuidas - ISR-701 - UTEQ

## Descripcion

Simulacion de un esquema de base de datos distribuida para una cadena de
cafeterias con 3 sedes (Campus, Babahoyo, Ventanas), usando PostgreSQL en
Docker. Se aplican fragmentacion horizontal, vertical y mixta sobre las
tablas `clientes` y `pedidos`, y se reconstruyen los datos con vistas
globales usando `postgres_fdw`.

## Arquitectura

| Nodo         | Contenedor    | Puerto host | Rol                              |
|--------------|---------------|-------------|-----------------------------------|
| Campus       | pg-campus     | 5433        | Nodo coordinador / fragmentos     |
| Babahoyo     | pg-babahoyo   | 5434        | Fragmento Babahoyo                |
| Ventanas     | pg-ventanas   | 5435        | Fragmento Ventanas                |

Base de datos: `cafeteria`
Usuario: `admin`
Password: `admin123`

## Requisitos

- Docker y Docker Compose
- Cliente psql (opcional, se puede usar el que trae cada contenedor)

## 1. Levantar los contenedores

```powershell
docker compose up -d
```

## 2. Esquema y datos base

Se ejecutan en `pg-campus`:

```powershell
Get-Content sql\01_esquema_central.sql | docker exec -i pg-campus psql -U admin -d cafeteria
Get-Content sql\02_datos.sql | docker exec -i pg-campus psql -U admin -d cafeteria
```

## 3. Fragmentacion horizontal de pedidos (por sede)

```powershell
Get-Content sql\03_fragmentacion_horizontal.sql | docker exec -i pg-babahoyo psql -U admin -d cafeteria
Get-Content sql\03_fragmentacion_horizontal_campus.sql | docker exec -i pg-campus psql -U admin -d cafeteria
Get-Content sql\03_fragmentacion_horizontal_ventanas.sql | docker exec -i pg-ventanas psql -U admin -d cafeteria
```

## 4. Fragmentacion vertical de clientes

```powershell
Get-Content sql\04a_vertical_publicos.sql | docker exec -i pg-campus psql -U admin -d cafeteria
Get-Content sql\04b_vertical_contacto.sql | docker exec -i pg-babahoyo psql -U admin -d cafeteria
```

## 5. Fragmentacion mixta de clientes (ciudad + sensibilidad de datos)

```powershell
Get-Content sql\05a_mixta_campus.sql | docker exec -i pg-campus psql -U admin -d cafeteria
Get-Content sql\05b_mixta_ventanas.sql | docker exec -i pg-ventanas psql -U admin -d cafeteria
Get-Content sql\05c_mixta_babahoyo.sql | docker exec -i pg-babahoyo psql -U admin -d cafeteria
```

## 6. Vistas globales (postgres_fdw)

```powershell
Get-Content sql\06_vistas_globales.sql | docker exec -i pg-campus psql -U admin -d cafeteria
```

## 7. Verificacion

```powershell
Get-Content sql\07_verificacion.sql | docker exec -i pg-campus psql -U admin -d cafeteria
```

Se comprueba:

1. Completitud: el total de filas en `pedidos_global` debe ser igual al total original (8).
2. Reconstruccion: la suma de `monto` agrupada por `sede` en `pedidos_global` debe coincidir con la de `pedidos_centralizado_original`.
3. Disyuncion: ningun `pedido_id` debe repetirse en `pedidos_global`.

## Estructura de carpetas

```
sql/
  01_esquema_central.sql
  02_datos.sql
  03_fragmentacion_horizontal.sql          (Babahoyo)
  03_fragmentacion_horizontal_campus.sql
  03_fragmentacion_horizontal_ventanas.sql
  04a_vertical_publicos.sql                (Campus)
  04b_vertical_contacto.sql                (Babahoyo)
  05a_mixta_campus.sql
  05b_mixta_ventanas.sql
  05c_mixta_babahoyo.sql
  06_vistas_globales.sql                   (Campus)
  07_verificacion.sql                      (Campus)
docker-compose.yml
```
