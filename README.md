# Base de Datos en SQL para The Book Store - Esquema + Población ficticia

En este proyecto muestro cómo diseñé desde cero la estructura de la Base de Datos para "The Book Store", creando tablas, atributos y relaciones. También se incluyen algunas vistas utilizadas a diario en el negocio. Actualmente la BD está 100% operativa y es el corazón del análisis de datos en TBS.

## Objetivos del proyecto
- Automatizar los flujos de stock e inventario.
- Mejorar la planificación de la demanda.
- Mejorar y profundizar la calidad del análisis de datos.
- Ahorrar tiempo en tareas operativas.

## Resultados obtenidos
- Cálculos precisos en las predicciones de la demanda y reducciones de Stockouts en un 25%.
- Movimientos de stock completamente automatizados con Claude Code.
- Mejor seguimiento de métricas de rentabilidad del negocio.
- Mejor análisis de categorías, segmentos y SKUs más vendidos.
- Mejor seguimiento de clientes recurrentes.

## Contenido del repositorio
El archivo `thebookstore_portfolio.sql` es un dump completo para MySQL 8.0 (motor InnoDB, charset utf8mb4) e incluye:

- **37 tablas** relacionales (catálogo, ventas, clientes, pedidos a editorial, stock por depósito/Full, forecast de demanda, precios sugeridos, costos, etc.), con sus claves foráneas.
- **8 vistas** analíticas, entre ellas `stockouts` (unidades y ganancia perdida por quiebre de stock), `sobrestocks` (costo diario de capital inmovilizado en exceso de stock), `obsolesencia` (costo de mercadería parada sin ventas) y vistas de estimación de demanda, eventos de demanda, compras por cliente y libros más vendidos.
- **5 triggers** que mantienen consistencia automática (por ejemplo, dar de baja un título del catálogo según su margen, o recalcular totales de un pedido al cargar su detalle).
- **7 stored procedures** y **1 función** para consultas y cálculos recurrentes del negocio (consulta de stock, margen sugerido, top de ventas por categoría, etc.).

## Esquema interactivo en Miro: 
https://miro.com/app/board/uXjVHrGH-eo=/?share_link_id=108733418465

## Nota sobre los datos
En este repositorio, las tablas fueron pobladas mediante IA con datos artificiales para proteger datos sensibles del negocio. En la realidad, las tablas fueron pobladas con datos pre-existentes en MS Excel.
