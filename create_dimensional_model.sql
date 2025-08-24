-- First, create the raw views again
CREATE OR REPLACE TEMPORARY VIEW raw_clientes
USING CSV
OPTIONS (
  path 'hdfs://localhost:9000/datalake/raw/superventas/clientes/',
  header 'true',
  inferSchema 'true'
);

CREATE OR REPLACE TEMPORARY VIEW raw_productos
USING CSV
OPTIONS (
  path 'hdfs://localhost:9000/datalake/raw/superventas/productos/',
  header 'true',
  inferSchema 'true'
);

CREATE OR REPLACE TEMPORARY VIEW raw_sucursales
USING CSV
OPTIONS (
  path 'hdfs://localhost:9000/datalake/raw/superventas/sucursales/',
  header 'true',
  inferSchema 'true'
);

CREATE OR REPLACE TEMPORARY VIEW raw_ventas
USING CSV
OPTIONS (
  path 'hdfs://localhost:9000/datalake/raw/superventas/ventas/',
  header 'true',
  inferSchema 'true'
);

-- Create HDFS directories for dimensional tables
-- (This will be done via hdfs commands separately)

-- Create dimension tables in Parquet format

-- 1. Dimension Cliente
CREATE TABLE dim_cliente
USING PARQUET
LOCATION 'hdfs://localhost:9000/datalake/processed/superventas/dim_cliente'
AS
SELECT
  md5(id_cliente) AS sk_cliente,
  id_cliente,
  nombre,
  segmento,
  ciudad
FROM raw_clientes;

-- 2. Dimension Producto
CREATE TABLE dim_producto
USING PARQUET
LOCATION 'hdfs://localhost:9000/datalake/processed/superventas/dim_producto'
AS
SELECT
  md5(id_producto) AS sk_producto,
  id_producto,
  nombre,
  categoria,
  precio_lista
FROM raw_productos;

-- 3. Dimension Sucursal
CREATE TABLE dim_sucursal
USING PARQUET
LOCATION 'hdfs://localhost:9000/datalake/processed/superventas/dim_sucursal'
AS
SELECT
  md5(id_sucursal) AS sk_sucursal,
  id_sucursal,
  nombre,
  region,
  ciudad
FROM raw_sucursales;

-- 4. Dimension Tiempo (generated from ventas dates)
CREATE TABLE dim_tiempo
USING PARQUET
LOCATION 'hdfs://localhost:9000/datalake/processed/superventas/dim_tiempo'
AS
SELECT DISTINCT
  md5(cast(fecha_venta as string)) AS sk_tiempo,
  fecha_venta,
  year(fecha_venta) AS anio,
  month(fecha_venta) AS mes,
  dayofmonth(fecha_venta) AS dia,
  quarter(fecha_venta) AS trimestre,
  dayofweek(fecha_venta) AS dia_semana,
  weekofyear(fecha_venta) AS semana_anio
FROM raw_ventas
WHERE fecha_venta IS NOT NULL;

-- 5. Fact Table - Ventas
CREATE TABLE fact_ventas
USING PARQUET
LOCATION 'hdfs://localhost:9000/datalake/processed/superventas/fact_ventas'
AS
SELECT
  md5(v.id_cliente) AS sk_cliente,
  md5(v.id_producto) AS sk_producto,
  md5(v.id_sucursal) AS sk_sucursal,
  md5(cast(v.fecha_venta as string)) AS sk_tiempo,
  v.fecha_venta,
  v.cantidad,
  v.precio_unit,
  v.cantidad * v.precio_unit AS total_linea
FROM raw_ventas v
WHERE v.fecha_venta IS NOT NULL;

-- Verify the dimensional model
SELECT 'DIMENSION TABLES CREATED' as status;

SELECT 'dim_cliente' as tabla, COUNT(*) as registros FROM dim_cliente
UNION ALL
SELECT 'dim_producto' as tabla, COUNT(*) as registros FROM dim_producto
UNION ALL
SELECT 'dim_sucursal' as tabla, COUNT(*) as registros FROM dim_sucursal
UNION ALL
SELECT 'dim_tiempo' as tabla, COUNT(*) as registros FROM dim_tiempo
UNION ALL
SELECT 'fact_ventas' as tabla, COUNT(*) as registros FROM fact_ventas;
