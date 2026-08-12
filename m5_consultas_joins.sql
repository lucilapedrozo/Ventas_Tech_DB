-- ══════════════════════════════════════════
-- M5 - Consultas con JOINs para el proyecto
-- RetailPro
-- Autor: Lucila Pedrozo
-- ══════════════════════════════════════════


-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- INNER JOIN

SELECT
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    c.region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- CONSULTA 2: CLIENTES SIN VENTAS
-- LEFT JOIN

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;


-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- LEFT JOIN

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;


-- CONSULTA 4: CONSOLIDADO POR CANAL
-- UNION ALL

SELECT
    v.id_venta,
    v.fecha_venta,
    v.id_cliente,
    v.id_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    'Online' AS canal
FROM ventas v
WHERE v.canal = 'Online'

UNION ALL

SELECT
    v.id_venta,
    v.fecha_venta,
    v.id_cliente,
    v.id_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    'Presencial' AS canal
FROM ventas v
WHERE v.canal = 'Presencial';


-- TOTAL DE VENTAS POR CANAL

SELECT
    canal,
    SUM(cantidad * precio_unitario) AS total_por_canal
FROM ventas
GROUP BY canal;
