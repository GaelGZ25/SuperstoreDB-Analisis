# Análisis de Ventas — Superstore (SQL Server)

## Objetivo

Proyecto de práctica que consiste en diseñar una base de datos relacional normalizada a partir de un dataset plano y construir consultas de análisis de negocio en SQL Server.

## Dataset

- **Nombre:** Sample Superstore (Furniture)
- **Fuente:** Kaggle
- **Registros originales:** 2,122 filas (ventas individuales), enfocado en la categoría Furniture
- **Columnas originales:** información de pedido, cliente, producto y venta en una sola tabla plana

## Diseño de la base de datos

El dataset original venía como una única tabla con toda la información mezclada. Se normalizó en 4 tablas relacionadas para evitar redundancia y reflejar las relaciones reales del negocio:

| Tabla          | Descripción                               | Llave primaria | Llaves foráneas                            |
| -------------- | ----------------------------------------- | -------------- | ------------------------------------------ |
| `Customers`    | Clientes únicos                           | `CustomerID`   | —                                          |
| `Products`     | Productos únicos                          | `ProductID`    | —                                          |
| `Orders`       | Pedidos únicos                            | `OrderID`      | `CustomerID` → Customers                   |
| `OrderDetails` | Detalle de cada venta (producto + pedido) | `RowID`        | `OrderID` → Orders, `ProductID` → Products |

**Relaciones:** un cliente puede tener muchos pedidos; un pedido puede incluir varios productos..

**Criterio de NULL / NOT NULL:** los campos esenciales para que un registro tenga sentido se definieron como `NOT NULL`. Los campos secundarios o que podrían no capturarse siempre se dejaron como `NULL`.

Todas las llaves primarias y foráneas se definieron con `CONSTRAINT` nombrados explícitamente para mayor claridad y mantenibilidad.

## Proceso

1. **Staging:** el CSV se importó primero a una tabla temporal (`stores_sales_forecasting`) con todas las columnas en texto, para evitar errores de conversión durante la importación.
2. **Normalización y limpieza:** al repartir los datos hacia las 4 tablas finales se detectaron registros duplicados. Se resolvió usando `ROW_NUMBER() OVER (PARTITION BY)` para quedarse con un solo registro por entidad.
3. **Conversión segura de tipos:** se usaron `TRY_CONVERT` y `TRY_CAST` para las fechas y campos numéricos, evitando que un solo dato inconsistente detuviera toda la carga.
4. **Resultado final:**
   - `Customers`: clientes únicos
   - `Products`: productos únicos
   - `Orders`: 1,764 pedidos únicos
   - `OrderDetails`: 2,121 registros de venta

## Consultas incluidas

| Archivo                        | Consulta                                | Descripción                                                  |
| ------------------------------ | --------------------------------------- | ------------------------------------------------------------ |
| `03_consultas_analisis.sql`    | JOIN simple                             | Detalle completo de cada venta (cliente, producto, fecha)    |
| `03_consultas_analisis.sql`    | GROUP BY                                | Total de ventas, ganancia y unidades por subcategoría        |
| `03_consultas_analisis.sql`    | TOP N                                   | Los 5 productos más vendidos por unidades con su monto total |
| `03_consultas_analisis.sql`    | Subconsulta                             | Clientes cuyo total de compra supera el promedio general     |
| `04_vista_y_procedimiento.sql` | Vista (`VentasSubCategoria`)            | Resumen de ventas por subcategoría, reutilizable como tabla  |
| `04_vista_y_procedimiento.sql` | Procedimiento (`sp_ventasSubCategoria`) | Desglose de ventas por producto, filtrado por subcategoría   |

## Tecnologías

- SQL Server
- SQL Server Management Studio (SSMS)
