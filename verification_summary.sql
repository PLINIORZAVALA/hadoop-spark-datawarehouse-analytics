-- Final verification of the Data Warehouse
-- Load all dimensional tables
CREATE OR REPLACE TEMPORARY VIEW dim_cliente
USING PARQUET
OPTIONS (path 'hdfs://localhost:9000/datalake/processed/superventas/dim_cliente');

CREATE OR REPLACE TEMPORARY VIEW dim_producto
USING PARQUET
OPTIONS (path 'hdfs://localhost:9000/datalake/processed/superventas/dim_producto');

CREATE OR REPLACE TEMPORARY VIEW dim_sucursal
USING PARQUET
OPTIONS (path 'hdfs://localhost:9000/datalake/processed/superventas/dim_sucursal');

CREATE OR REPLACE TEMPORARY VIEW dim_tiempo
USING PARQUET
OPTIONS (path 'hdfs://localhost:9000/datalake/processed/superventas/dim_tiempo');

CREATE OR REPLACE TEMPORARY VIEW fact_ventas
USING PARQUET
OPTIONS (path 'hdfs://localhost:9000/datalake/processed/superventas/fact_ventas');

-- Data Warehouse Summary
SELECT '=== RESUMEN DEL DATA WAREHOUSE ===' as info;

SELECT 'TABLAS CREADAS:' as seccion;
SELECT 'dim_cliente' as tabla, COUNT(*) as registros FROM dim_cliente
UNION ALL
SELECT 'dim_producto' as tabla, COUNT(*) as registros FROM dim_producto
UNION ALL
SELECT 'dim_sucursal' as tabla, COUNT(*) as registros FROM dim_sucursal
UNION ALL
SELECT 'dim_tiempo' as tabla, COUNT(*) as registros FROM dim_tiempo
UNION ALL
SELECT 'fact_ventas' as tabla, COUNT(*) as registros FROM fact_ventas;

SELECT 'ESTRUCTURA DE DATOS:' as seccion;
DESCRIBE dim_cliente;
DESCRIBE fact_ventas;
