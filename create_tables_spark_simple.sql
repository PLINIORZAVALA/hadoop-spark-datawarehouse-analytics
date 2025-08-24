-- Create temporary views from CSV files (without Hive metastore)
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

-- Test queries to verify data
SELECT 'Clientes' as tabla, COUNT(*) as total FROM raw_clientes
UNION ALL
SELECT 'Productos' as tabla, COUNT(*) as total FROM raw_productos
UNION ALL
SELECT 'Sucursales' as tabla, COUNT(*) as total FROM raw_sucursales
UNION ALL
SELECT 'Ventas' as tabla, COUNT(*) as total FROM raw_ventas;

-- Show sample data
SELECT 'CLIENTES SAMPLE:' as info;
SELECT * FROM raw_clientes LIMIT 3;

SELECT 'PRODUCTOS SAMPLE:' as info;
SELECT * FROM raw_productos LIMIT 3;

SELECT 'VENTAS SAMPLE:' as info;
SELECT * FROM raw_ventas LIMIT 3;
