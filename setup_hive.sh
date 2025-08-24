#!/bin/bash

# Start Hive in embedded mode and execute commands
hive << 'EOF'
CREATE DATABASE IF NOT EXISTS superventas_dw;
USE superventas_dw;

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

SHOW TABLES;
EOF
