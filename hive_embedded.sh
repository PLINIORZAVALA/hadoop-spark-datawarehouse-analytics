#!/bin/bash

# Set Hive to use embedded mode
export HIVE_OPTS="$HIVE_OPTS -hiveconf javax.jdo.option.ConnectionURL=jdbc:derby:;databaseName=metastore_db;create=true"

# Execute Hive commands using the CLI
$HIVE_HOME/bin/hive --config $HIVE_HOME/conf << 'EOF'
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
DESCRIBE raw_clientes;
SELECT COUNT(*) FROM raw_clientes;
EOF
