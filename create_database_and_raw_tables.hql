-- Create database
CREATE DATABASE IF NOT EXISTS superventas_dw;
USE superventas_dw;

-- Create external table for clientes
CREATE EXTERNAL TABLE raw_clientes (
  id_cliente STRING,
  nombre STRING,
  segmento STRING,
  ciudad STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/datalake/raw/superventas/clientes/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Create external table for productos
CREATE EXTERNAL TABLE raw_productos (
  id_producto STRING,
  nombre STRING,
  categoria STRING,
  precio_lista DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/datalake/raw/superventas/productos/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Create external table for sucursales
CREATE EXTERNAL TABLE raw_sucursales (
  id_sucursal STRING,
  nombre STRING,
  region STRING,
  ciudad STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/datalake/raw/superventas/sucursales/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Create external table for ventas
CREATE EXTERNAL TABLE raw_ventas (
  id_cliente STRING,
  id_producto STRING,
  id_sucursal STRING,
  fecha_venta DATE,
  cantidad INT,
  precio_unit DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/datalake/raw/superventas/ventas/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Show tables to verify creation
SHOW TABLES;
