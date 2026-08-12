USE Ventas_Tech_DB;
GO

/* =========================================================
   PRE-ENTREGA M4 - CONSULTAS SQL DE NEGOCIO
   TechStore / RetailPro
   Autor: Lucila Pedrozo
   ========================================================= */


/* =========================================================
   CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
   Total facturado, cantidad de pedidos y ticket promedio
   ========================================================= */

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


/* =========================================================
   CONSULTA 2 - RANKING DE PRODUCTOS
   Top 5 por total facturado
   ========================================================= */

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


/* =========================================================
   CONSULTA 3 - CLIENTES RECURRENTES
   Clientes con más de un pedido
   ========================================================= */

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


/* =========================================================
   CONSULTA 4 - MESES POR ENCIMA O DEBAJO DEL PROMEDIO
   ========================================================= */

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;
GO


/* =========================================================
   HALLAZGOS
   =========================================================

-- 1. El producto con ID 1 es el que genera la mayor facturación,
--    con un total de 3600.

-- 2. Los clientes registrados realizaron más de una compra,
--    por lo que aparecen como clientes recurrentes.

-- 3. Los datos cargados actualmente corresponden únicamente
--    al mes de marzo de 2024, por lo que todavía no es posible
--    realizar una comparación real entre diferentes meses.

*/
