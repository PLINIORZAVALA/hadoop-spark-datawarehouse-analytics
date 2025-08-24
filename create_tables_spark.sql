-- Create database
CREATE DATABASE IF NOT EXISTS superventas_dw;
USE superventas_dw;

-- Create external table for clientes
CREATE TABLE raw_clientes (
  id_cliente STRING,
  nombre STRING,
  segmento STRING,
  ciudad STRING
)
USING CSV
OPTIONS (
  path '/datalake/raw/superventas/clientes/',
  header 'true'
);

-- Create external table for productos
CREATE TABLE raw_productos (
  id_producto STRING,
  nombre STRING,
  categoria STRING,
  precio_lista DECIMAL(10,2)
)
USING CSV
OPTIONS (
  path '/datalake/raw/superventas/productos/',
  header 'true'
);

-- Create external table for sucursales
CREATE TABLE raw_sucursales (
  id_sucursal STRING,
  nombre STRING,
  region STRING,
  ciudad STRING
)
USING CSV
OPTIONS (
  path '/datalake/raw/superventas/sucursales/',
  header 'true'
);

-- Create external table for ventas
CREATE TABLE raw_ventas (
  id_cliente STRING,
  id_producto STRING,
  id_sucursal STRING,
  fecha_venta DATE,
  cantidad INT,
  precio_unit DECIMAL(10,2)
)
USING CSV
OPTIONS (
  path '/datalake/raw/superventas/ventas/',
  header 'true'
);

-- Show tables to verify creation
SHOW TABLES;

-- Test queries to verify data
SELECT COUNT(*) as total_clientes FROM raw_clientes;
SELECT COUNT(*) as total_productos FROM raw_productos;
SELECT COUNT(*) as total_sucursales FROM raw_sucursales;
SELECT COUNT(*) as total_ventas FROM raw_ventas;
