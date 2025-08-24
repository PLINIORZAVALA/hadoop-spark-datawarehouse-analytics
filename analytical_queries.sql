-- Load the dimensional tables for analytical queries
CREATE OR REPLACE TEMPORARY VIEW dim_cliente
USING PARQUET
OPTIONS (
  path 'hdfs://localhost:9000/datalake/processed/superventas/dim_cliente'
);

CREATE OR REPLACE TEMPORARY VIEW dim_producto
USING PARQUET
OPTIONS (
  path 'hdfs://localhost:9000/datalake/processed/superventas/dim_producto'
);

CREATE OR REPLACE TEMPORARY VIEW dim_sucursal
USING PARQUET
OPTIONS (
  path 'hdfs://localhost:9000/datalake/processed/superventas/dim_sucursal'
);

CREATE OR REPLACE TEMPORARY VIEW dim_tiempo
USING PARQUET
OPTIONS (
  path 'hdfs://localhost:9000/datalake/processed/superventas/dim_tiempo'
);

CREATE OR REPLACE TEMPORARY VIEW fact_ventas
USING PARQUET
OPTIONS (
  path 'hdfs://localhost:9000/datalake/processed/superventas/fact_ventas'
);

-- CONSULTA 1: Ventas por año y categoría
SELECT '=== VENTAS POR AÑO Y CATEGORÍA ===' as consulta;

SELECT 
  t.anio, 
  p.categoria, 
  SUM(f.total_linea) AS ventas_total,
  COUNT(*) as num_transacciones
FROM fact_ventas f
JOIN dim_producto p ON f.sk_producto = p.sk_producto
JOIN dim_tiempo t ON f.sk_tiempo = t.sk_tiempo
GROUP BY t.anio, p.categoria
ORDER BY t.anio, ventas_total DESC;

-- CONSULTA 2: Top 5 clientes por monto
SELECT '=== TOP 5 CLIENTES POR MONTO ===' as consulta;

SELECT 
  c.nombre, 
  c.segmento,
  c.ciudad,
  SUM(f.total_linea) AS monto_total,
  COUNT(*) as num_compras
FROM fact_ventas f
JOIN dim_cliente c ON f.sk_cliente = c.sk_cliente
GROUP BY c.nombre, c.segmento, c.ciudad
ORDER BY monto_total DESC
LIMIT 5;

-- CONSULTA 3: Ventas totales por región
SELECT '=== VENTAS TOTALES POR REGIÓN ===' as consulta;

SELECT 
  s.region, 
  SUM(f.total_linea) AS ventas_total,
  COUNT(*) as num_transacciones,
  AVG(f.total_linea) as venta_promedio
FROM fact_ventas f
JOIN dim_sucursal s ON f.sk_sucursal = s.sk_sucursal
GROUP BY s.region
ORDER BY ventas_total DESC;

-- CONSULTA ADICIONAL 4: Análisis por mes
SELECT '=== VENTAS POR MES ===' as consulta;

SELECT 
  t.anio,
  t.mes,
  SUM(f.total_linea) AS ventas_mes,
  COUNT(*) as transacciones_mes
FROM fact_ventas f
JOIN dim_tiempo t ON f.sk_tiempo = t.sk_tiempo
GROUP BY t.anio, t.mes
ORDER BY t.anio, t.mes;

-- CONSULTA ADICIONAL 5: Productos más vendidos
SELECT '=== TOP 5 PRODUCTOS MÁS VENDIDOS ===' as consulta;

SELECT 
  p.nombre as producto,
  p.categoria,
  SUM(f.cantidad) as cantidad_total_vendida,
  SUM(f.total_linea) as ingresos_totales,
  COUNT(*) as num_ventas
FROM fact_ventas f
JOIN dim_producto p ON f.sk_producto = p.sk_producto
GROUP BY p.nombre, p.categoria
ORDER BY cantidad_total_vendida DESC
LIMIT 5;
