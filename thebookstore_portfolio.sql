-- =====================================================================
-- The Book Store -- dump de portfolio
-- Estructura 100% real de la base de produccion (tablas, FKs, triggers,
-- funciones, stored procedures y una seleccion de vistas analiticas).
-- Los DATOS (catalogo, ventas, clientes, pedidos, stock, costos, etc.)
-- son SINTETICOS/FICTICIOS, generados para esta publicacion: los libros
-- citados existen realmente pero esta NO es la base de datos real del
-- negocio (precios, margenes, ventas, clientes y stock son de ejemplo).
-- =====================================================================


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `thebookstore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `thebookstore`;
DROP TABLE IF EXISTS `ajustes_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ajustes_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_catalogo_SKU` smallint NOT NULL,
  `fecha` date DEFAULT NULL,
  `ubicacion` enum('deposito','full') NOT NULL DEFAULT 'deposito',
  `cantidad` smallint NOT NULL,
  `tipo` enum('retiro_personal','correccion_inventario','otro') NOT NULL,
  `fk_compras_id` int DEFAULT NULL,
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_compras_id_ajustes` (`fk_compras_id`),
  KEY `fk_catalogo_SKU_ajustes` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_ajustes` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_compras_id_ajustes` FOREIGN KEY (`fk_compras_id`) REFERENCES `pedidos_editorial` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `autores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autores` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre_autor` varchar(100) NOT NULL,
  `seguidores_goodreads` int DEFAULT NULL,
  `comentarios` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `catalogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogo` (
  `SKU` smallint NOT NULL AUTO_INCREMENT,
  `ISBN` char(13) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `subtitulo` varchar(100) DEFAULT NULL,
  `fk_margenes_id` varchar(3) NOT NULL,
  `fk_autores_id` smallint NOT NULL,
  `formato` enum('Blanda','Dura','Pocket','N/A') NOT NULL,
  `idioma` enum('Inglés','Español','N/A') NOT NULL,
  `es_un_kit` tinyint(1) NOT NULL DEFAULT '0',
  `con_proteccion` tinyint(1) NOT NULL DEFAULT '0',
  `fk_sellos_editoriales_id` smallint NOT NULL,
  `fk_subcategorias_id` smallint NOT NULL,
  `precio_lista` decimal(5,2) NOT NULL,
  `descuento_proveedor` decimal(4,2) NOT NULL,
  `fecha_publicacion` date NOT NULL,
  `fecha_primera_edicion` date DEFAULT NULL,
  `paginas` smallint NOT NULL,
  `altura` decimal(5,2) NOT NULL,
  `ancho` decimal(5,2) NOT NULL,
  `peso_g` decimal(6,2) NOT NULL,
  `sinopsis` text,
  `foto_principal` varchar(250) DEFAULT NULL,
  `fk_segmentos_id` tinyint NOT NULL,
  `fecha_modificacion_margen` date DEFAULT NULL,
  `factor_ajuste_precio` smallint DEFAULT NULL,
  `precio_competencia` decimal(9,2) DEFAULT NULL,
  `stock_inmediato_competencia` tinyint(1) DEFAULT NULL,
  `fecha_analisis_competencia` date DEFAULT NULL,
  `mejorado_en_catalogo` tinyint(1) DEFAULT NULL,
  `recomendado_tbs` tinyint(1) DEFAULT NULL,
  `reseña_TBS` text,
  `disponible_formato_economico` tinyint(1) DEFAULT NULL,
  `a_pedido` tinyint(1) DEFAULT '0',
  `inactivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = no pedir a editorial; si hay stock puede ir a Full',
  `fecha_agregacion` date DEFAULT NULL,
  `ventas_estimadas_manual` decimal(5,2) DEFAULT NULL,
  `comentario` varchar(2500) DEFAULT NULL,
  `puntaje_goodreads` decimal(3,2) DEFAULT NULL,
  `goodreads_calificaciones` int unsigned DEFAULT NULL,
  `fecha_actualizacion_goodreads` date DEFAULT NULL,
  PRIMARY KEY (`SKU`),
  KEY `fk_autores_id` (`fk_autores_id`),
  KEY `fk_sellos_editoriales_id` (`fk_sellos_editoriales_id`),
  KEY `fk_subcategorias_id` (`fk_subcategorias_id`),
  KEY `fk_margenes_id` (`fk_margenes_id`),
  KEY `fk_segmentos_id_catalogo` (`fk_segmentos_id`),
  CONSTRAINT `fk_autores_id` FOREIGN KEY (`fk_autores_id`) REFERENCES `autores` (`id`),
  CONSTRAINT `fk_margenes_id` FOREIGN KEY (`fk_margenes_id`) REFERENCES `margenes` (`id`),
  CONSTRAINT `fk_segmentos_id_catalogo` FOREIGN KEY (`fk_segmentos_id`) REFERENCES `segmentos` (`id`),
  CONSTRAINT `fk_sellos_editoriales_id` FOREIGN KEY (`fk_sellos_editoriales_id`) REFERENCES `sellos_editoriales` (`id`),
  CONSTRAINT `fk_subcategorias_id` FOREIGN KEY (`fk_subcategorias_id`) REFERENCES `subcategorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1819 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_catalogo_margen_alta_inactivo` BEFORE INSERT ON `catalogo` FOR EACH ROW BEGIN
    DECLARE v_decision VARCHAR(50);

    IF NEW.fk_margenes_id IS NOT NULL THEN
        SELECT decision INTO v_decision FROM margenes WHERE id = NEW.fk_margenes_id LIMIT 1;

        IF v_decision = 'seguir pidiendo' THEN
            SET NEW.inactivo = 0;
        ELSEIF v_decision IS NOT NULL THEN
            SET NEW.inactivo = 1;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_catalogo_margen_baja_inactivo` BEFORE UPDATE ON `catalogo` FOR EACH ROW BEGIN
    DECLARE v_decision VARCHAR(50);

    IF NEW.fk_margenes_id IS NOT NULL THEN
        SELECT decision INTO v_decision FROM margenes WHERE id = NEW.fk_margenes_id LIMIT 1;

        IF v_decision = 'seguir pidiendo' THEN
            IF COALESCE(NEW.inactivo, 0) = 1 THEN
                SET NEW.inactivo = 0;
                IF NEW.comentario LIKE 'INACTIVO |%' THEN
                    SET NEW.comentario = NULL;
                END IF;
            END IF;
        ELSEIF v_decision IS NOT NULL THEN
            SET NEW.inactivo = 1;

            IF OLD.fk_margenes_id IS NULL OR OLD.fk_margenes_id <> NEW.fk_margenes_id THEN
                SET NEW.a_pedido = 0;
                SET NEW.recomendado_tbs = 0;
                SET NEW.comentario = CASE
                    WHEN NEW.comentario IS NULL OR TRIM(NEW.comentario) = '' THEN
                        CONCAT(
                            'INACTIVO | margen ', NEW.fk_margenes_id,
                            ' | no pedir a editorial; liquidar via Full | ', CURDATE()
                        )
                    WHEN UPPER(NEW.comentario) LIKE '%INACTIVO%'
                      OR UPPER(NEW.comentario) LIKE '%FUERA DE CATALOGO%' THEN
                        NEW.comentario
                    ELSE
                        CONCAT(
                            NEW.comentario, ' | INACTIVO | margen ', NEW.fk_margenes_id,
                            ' | no pedir a editorial; liquidar via Full | ', CURDATE()
                        )
                END;
            END IF;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP TABLE IF EXISTS `catalogo_motivos_retiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogo_motivos_retiro` (
  `fk_catalogo_SKU` smallint NOT NULL,
  `fk_motivos_retiro_id` tinyint unsigned NOT NULL,
  `fecha_asignacion` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`fk_catalogo_SKU`,`fk_motivos_retiro_id`),
  KEY `fk_motivos_retiro_id` (`fk_motivos_retiro_id`),
  CONSTRAINT `fk_catalogo_SKU_motivos_retiro` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_motivos_retiro_id` FOREIGN KEY (`fk_motivos_retiro_id`) REFERENCES `motivos_retiro` (`id_motivo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `categorias_costos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_costos` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `grupo` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_cliente` varchar(100) NOT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `condicion_fiscal` enum('Consumidor Final','Empresa') NOT NULL DEFAULT 'Consumidor Final',
  `ciudad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `intereses` varchar(1000) DEFAULT NULL,
  `id_comprador_ml` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_clientes_id_comprador_ml` (`id_comprador_ml`)
) ENGINE=InnoDB AUTO_INCREMENT=3407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `comisiones_impuestos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comisiones_impuestos` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `plataforma` varchar(30) NOT NULL DEFAULT 'MELI',
  `es_impuesto` tinyint(1) NOT NULL DEFAULT '0',
  `tipo_calculo` enum('monto_fijo','porcentaje') NOT NULL,
  `valor` decimal(10,4) NOT NULL,
  `precio_min` decimal(10,2) DEFAULT NULL,
  `precio_max` decimal(10,2) DEFAULT NULL,
  `aplica_siempre` tinyint(1) NOT NULL DEFAULT '0',
  `vigencia_desde` date NOT NULL,
  `vigencia_hasta` date DEFAULT NULL,
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_comisiones_nombre_vigencia` (`nombre`,`vigencia_desde`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `costos_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costos_variables` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `valor` decimal(10,4) NOT NULL,
  `vigente_desde` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL,
  `aplica_siempre` tinyint(1) NOT NULL DEFAULT '0',
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_costos_variables_vigente_hasta` (`vigente_hasta`),
  KEY `idx_costos_variables_aplica_siempre` (`aplica_siempre`),
  KEY `idx_costos_variables_nombre_vigente` (`nombre`,`vigente_desde`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `demanda_forecast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `demanda_forecast` (
  `fk_catalogo_SKU` smallint NOT NULL,
  `est_t4` decimal(6,2) NOT NULL DEFAULT '0.00',
  `est_t3` decimal(6,2) NOT NULL DEFAULT '0.00',
  `est_t2` decimal(6,2) NOT NULL DEFAULT '0.00',
  `est_t1` decimal(6,2) NOT NULL DEFAULT '0.00',
  `est_t0` decimal(6,2) NOT NULL DEFAULT '0.00',
  `ventas_estimadas_core` decimal(5,2) DEFAULT NULL,
  `boost_activo` decimal(4,2) NOT NULL DEFAULT '1.00',
  `ajuste_evento` decimal(6,2) NOT NULL DEFAULT '0.00',
  `demanda_final` decimal(6,2) NOT NULL DEFAULT '0.00',
  `confianza` enum('alta','media','baja') NOT NULL DEFAULT 'baja',
  `metodo_calculo` varchar(60) NOT NULL DEFAULT 'shrinkage_peers',
  `ventas_totales` smallint NOT NULL DEFAULT '0',
  `meses_validos` tinyint NOT NULL DEFAULT '0',
  `fecha_calculo` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_forecast` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `demanda_forecast_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `demanda_forecast_historico` (
  `fk_catalogo_SKU` smallint NOT NULL,
  `fecha_vigencia` date NOT NULL,
  `dias_disponibles` tinyint NOT NULL DEFAULT '0',
  `ventas_mensualizadas_core` decimal(6,2) NOT NULL DEFAULT '0.00',
  `demanda_final_est` decimal(5,2) DEFAULT NULL,
  `mes_valido` tinyint NOT NULL DEFAULT '0',
  `es_pico` tinyint NOT NULL DEFAULT '0',
  `fecha_calculo` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fk_catalogo_SKU`,`fecha_vigencia`),
  KEY `fk_sku_temporal` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_baseline` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `detalle_envios_full`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_envios_full` (
  `fk_envios_full_id` int NOT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `cantidad_enviada` smallint NOT NULL,
  `cantidad_procesada` smallint NOT NULL DEFAULT '0',
  `diferencia` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`fk_envios_full_id`,`fk_catalogo_SKU`),
  KEY `fk_catalogo_SKU_envios` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_envios` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_envios_full_id` FOREIGN KEY (`fk_envios_full_id`) REFERENCES `envios_full` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `detalle_pedidos_editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedidos_editorial` (
  `fk_pedidos_editorial_id` int NOT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `cantidad_pedida` smallint NOT NULL,
  `cantidad_recibida_ok` smallint NOT NULL DEFAULT '0',
  `cantidad_mal_estado` smallint NOT NULL DEFAULT '0',
  `cantidad_no_recibida` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`fk_pedidos_editorial_id`,`fk_catalogo_SKU`),
  KEY `fk_catalogo_SKU_compras` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_compras` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_compras_id` FOREIGN KEY (`fk_pedidos_editorial_id`) REFERENCES `pedidos_editorial` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_det_pedidos_ai` AFTER INSERT ON `detalle_pedidos_editorial` FOR EACH ROW UPDATE pedidos_editorial p SET
  p.unidades_pedidas=(SELECT SUM(cantidad_pedida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id),
  p.unidades_mal_estado=(SELECT SUM(cantidad_mal_estado) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id),
  p.unidades_no_recibidas=(SELECT SUM(cantidad_no_recibida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id)
  WHERE p.id=NEW.fk_pedidos_editorial_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_det_pedidos_au` AFTER UPDATE ON `detalle_pedidos_editorial` FOR EACH ROW BEGIN UPDATE pedidos_editorial p SET
  p.unidades_pedidas=(SELECT SUM(cantidad_pedida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id),
  p.unidades_mal_estado=(SELECT SUM(cantidad_mal_estado) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id),
  p.unidades_no_recibidas=(SELECT SUM(cantidad_no_recibida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=NEW.fk_pedidos_editorial_id)
  WHERE p.id=NEW.fk_pedidos_editorial_id; IF OLD.fk_pedidos_editorial_id<>NEW.fk_pedidos_editorial_id THEN UPDATE pedidos_editorial p SET
  p.unidades_pedidas=(SELECT SUM(cantidad_pedida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id),
  p.unidades_mal_estado=(SELECT SUM(cantidad_mal_estado) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id),
  p.unidades_no_recibidas=(SELECT SUM(cantidad_no_recibida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id)
  WHERE p.id=OLD.fk_pedidos_editorial_id; END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_det_pedidos_ad` AFTER DELETE ON `detalle_pedidos_editorial` FOR EACH ROW UPDATE pedidos_editorial p SET
  p.unidades_pedidas=(SELECT SUM(cantidad_pedida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id),
  p.unidades_mal_estado=(SELECT SUM(cantidad_mal_estado) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id),
  p.unidades_no_recibidas=(SELECT SUM(cantidad_no_recibida) FROM detalle_pedidos_editorial WHERE fk_pedidos_editorial_id=OLD.fk_pedidos_editorial_id)
  WHERE p.id=OLD.fk_pedidos_editorial_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP TABLE IF EXISTS `detalle_retiros_full`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_retiros_full` (
  `fk_retiros_full_id` int NOT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `cantidad_retirada` smallint NOT NULL,
  `cantidad_reactivada` smallint DEFAULT NULL,
  `diferencias_stock` smallint DEFAULT NULL,
  PRIMARY KEY (`fk_retiros_full_id`,`fk_catalogo_SKU`),
  KEY `fk_catalogo_SKU_detalle_retiros_full` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_detalle_retiros_full` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_retiros_full_id` FOREIGN KEY (`fk_retiros_full_id`) REFERENCES `retiros_full` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `devoluciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devoluciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_ventas_id` int NOT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `unidades` smallint NOT NULL DEFAULT '1',
  `fecha_devolucion` date DEFAULT NULL,
  `fecha_reingreso_full` date DEFAULT NULL,
  `motivo` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ventas_id_devoluciones` (`fk_ventas_id`),
  KEY `fk_catalogo_SKU_devoluciones` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_devoluciones` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_ventas_id_devoluciones` FOREIGN KEY (`fk_ventas_id`) REFERENCES `ventas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `editoriales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `editoriales` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre_editorial` varchar(100) NOT NULL,
  `fk_metodos_envio_id` smallint DEFAULT NULL,
  `descuento_general` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `metodo_envio_id` (`fk_metodos_envio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `envios_full`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `envios_full` (
  `id` int NOT NULL,
  `fecha_envio` date NOT NULL,
  `fecha_procesamiento_full` date DEFAULT NULL,
  `estado` enum('en_camino','procesado') NOT NULL DEFAULT 'en_camino',
  `costo_envio` decimal(7,2) DEFAULT NULL,
  `flete_interno` int DEFAULT NULL,
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `eventos_demanda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos_demanda` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_catalogo_SKU` smallint NOT NULL,
  `tipo` enum('adaptacion_pelicula','premio','viral','otro') NOT NULL DEFAULT 'otro',
  `fecha_inicio` date NOT NULL,
  `fecha_fin_estimada` date DEFAULT NULL,
  `factor_boost` decimal(4,2) NOT NULL DEFAULT '1.50',
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_catalogo_SKU_eventos` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_eventos` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `libros más vendidos ult. 60d`;
/*!50001 DROP VIEW IF EXISTS `libros más vendidos ult. 60d`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `libros más vendidos ult. 60d` AS SELECT 
 1 AS `sku`,
 1 AS `titulo`,
 1 AS `Subcategoría`,
 1 AS `Unidades Vendidas`,
 1 AS `Ventas Netas Totales`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `libros_sin_stock_mas_vendidos`;
/*!50001 DROP VIEW IF EXISTS `libros_sin_stock_mas_vendidos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `libros_sin_stock_mas_vendidos` AS SELECT 
 1 AS `SKU`,
 1 AS `ISBN`,
 1 AS `titulo`,
 1 AS `formato`,
 1 AS `Unidades Vendidas Ult. 60d`,
 1 AS `Facturacion Total`,
 1 AS `Esperando Arribo`,
 1 AS `En Deposito`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `margenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `margenes` (
  `id` varchar(3) NOT NULL,
  `valor_margen` decimal(4,2) NOT NULL,
  `descripcion_margen` varchar(250) DEFAULT NULL,
  `decision` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `metodos_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_envio` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre_metodo` varchar(50) NOT NULL,
  `tiempo_envio` smallint NOT NULL,
  `costo_envio_g` decimal(5,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `motivos_retiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motivos_retiro` (
  `id_motivo` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `nombre_motivo` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_motivo`),
  UNIQUE KEY `uq_motivos_retiro_nombre` (`nombre_motivo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `obsolesencia`;
/*!50001 DROP VIEW IF EXISTS `obsolesencia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `obsolesencia` AS SELECT 
 1 AS `fk_catalogo_sku`,
 1 AS `total_unidades`,
 1 AS `costo_pesos`,
 1 AS `dias_sin_ventas`,
 1 AS `costo_obsolescencia_sku`,
 1 AS `fecha_obsolescencia`,
 1 AS `ult_fecha_venta`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `parametros_reposicion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parametros_reposicion` (
  `id` tinyint NOT NULL DEFAULT '1',
  `lead_time_total_d` smallint GENERATED ALWAYS AS ((((`demora_envio_internacional_d` + `demora_procesamiento_d`) + `demora_envio_full_d`) + `demora_procesamiento_full_d`)) STORED,
  `demora_envio_internacional_d` smallint NOT NULL DEFAULT '10',
  `demora_procesamiento_d` smallint NOT NULL DEFAULT '4',
  `demora_envio_full_d` smallint NOT NULL DEFAULT '3',
  `demora_procesamiento_full_d` smallint NOT NULL DEFAULT '1',
  `lead_time_full_d` smallint GENERATED ALWAYS AS ((`demora_envio_full_d` + `demora_procesamiento_full_d`)) STORED,
  `ciclo_pedido_dias` smallint NOT NULL DEFAULT '30',
  `tope_unidades_pedido` smallint NOT NULL DEFAULT '135',
  `tope_unidades_pedido_min` smallint NOT NULL DEFAULT '120',
  `dias_stock_confiable` smallint NOT NULL DEFAULT '15',
  `dias_stock_parcial` smallint NOT NULL DEFAULT '5',
  `ratio_pico_umbral` decimal(4,2) NOT NULL DEFAULT '2.50',
  `decaimiento_pico` decimal(4,2) NOT NULL DEFAULT '0.50',
  `shrinkage_objetivo` smallint NOT NULL DEFAULT '10',
  `ventas_confianza_alta` smallint NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_parametros_singleton` CHECK ((`id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pedidos_editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_editorial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha_pedido` date NOT NULL,
  `fecha_arribo_estimada` date DEFAULT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `estado` enum('en_camino','recibido','procesado') NOT NULL DEFAULT 'en_camino',
  `fk_editoriales_id` smallint NOT NULL,
  `costo_mercaderias` decimal(7,2) NOT NULL DEFAULT '0.00',
  `fk_metodos_envio_id` smallint NOT NULL DEFAULT '1',
  `costo_envio` decimal(7,2) DEFAULT NULL,
  `peso_estimado` decimal(7,2) DEFAULT NULL,
  `unidades_pedidas` smallint DEFAULT NULL,
  `unidades_mal_estado` smallint DEFAULT NULL,
  `unidades_no_recibidas` smallint DEFAULT NULL,
  `reembolsos` decimal(5,2) DEFAULT NULL,
  `notas` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_editoriales_id_compras` (`fk_editoriales_id`),
  KEY `fk_metodos_envio_id_pedidos_editorial` (`fk_metodos_envio_id`),
  CONSTRAINT `fk_editoriales_id_compras` FOREIGN KEY (`fk_editoriales_id`) REFERENCES `editoriales` (`id`),
  CONSTRAINT `fk_metodos_envio_id_pedidos_editorial` FOREIGN KEY (`fk_metodos_envio_id`) REFERENCES `metodos_envio` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `precio_ml_sugerido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precio_ml_sugerido` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_catalogo_SKU` smallint NOT NULL,
  `fecha_calculo` date NOT NULL,
  `tipo_cambio` decimal(12,4) NOT NULL,
  `costo_libro_usd` decimal(12,4) NOT NULL,
  `costo_envio_editorial_usd` decimal(12,4) NOT NULL,
  `costo_adquisicion` decimal(12,2) NOT NULL,
  `costo_preparacion` decimal(12,2) NOT NULL,
  `precio_core` decimal(12,2) NOT NULL,
  `comision_fija` decimal(12,2) NOT NULL,
  `envio_meli` decimal(12,2) NOT NULL,
  `pct_comisiones_impuestos` decimal(8,6) NOT NULL,
  `precio_base` decimal(12,2) NOT NULL,
  `factor_ajuste` int NOT NULL DEFAULT '0',
  `precio_publicado` decimal(12,2) NOT NULL,
  `ganancia_neta` decimal(12,2) NOT NULL,
  `calculado_en` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_precio_sku_fecha` (`fk_catalogo_SKU`,`fecha_calculo`),
  KEY `idx_precio_fecha` (`fecha_calculo`),
  CONSTRAINT `fk_precio_catalogo` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=2732 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `registro_cambios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_cambios` (
  `id_evento` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `accion` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `resultado` text COLLATE utf8mb4_unicode_ci,
  `fecha_evaluacion` date DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `idx_eventos_registrados_fecha` (`fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `registro_operaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_operaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `fk_categorias_costos_id` smallint NOT NULL,
  `detalle` varchar(150) NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `notas` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_registro_operaciones_fecha` (`fecha`),
  KEY `fk_categorias_costos_registro` (`fk_categorias_costos_id`),
  CONSTRAINT `fk_categorias_costos_registro` FOREIGN KEY (`fk_categorias_costos_id`) REFERENCES `categorias_costos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `retiros_full`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retiros_full` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_retiro_ml` int DEFAULT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `fecha_retiro` date NOT NULL,
  `fecha_recepcion_deposito` date DEFAULT NULL,
  `cantidad` smallint NOT NULL,
  `motivo` enum('sin_ventas','descatalogado','otro') NOT NULL DEFAULT 'sin_ventas',
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_catalogo_SKU_retiros` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_retiros` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `segmentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `segmentos` (
  `id` tinyint NOT NULL AUTO_INCREMENT,
  `nombre_segmento` varchar(50) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `participacion_objetivo` decimal(4,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sellos_editoriales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sellos_editoriales` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `nombre_sello` varchar(100) NOT NULL,
  `fk_editoriales_id` smallint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_editoriales_id_sellos_editoriales` (`fk_editoriales_id`),
  CONSTRAINT `fk_editoriales_id_sellos_editoriales` FOREIGN KEY (`fk_editoriales_id`) REFERENCES `editoriales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sobrestocks`;
/*!50001 DROP VIEW IF EXISTS `sobrestocks`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sobrestocks` AS SELECT 
 1 AS `fk_catalogo_sku`,
 1 AS `fecha`,
 1 AS `unidades_full`,
 1 AS `unidades_deposito`,
 1 AS `unidades_camino_hacia_full`,
 1 AS `stock_hoy`,
 1 AS `demanda_final_est`,
 1 AS `segmento_ventas`,
 1 AS `unidades_sobrestock`,
 1 AS `costo_libro`,
 1 AS `costo_diario_sobrestock`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `fk_catalogo_SKU` smallint NOT NULL,
  `unidades_en_camino_desde_proveedor` smallint NOT NULL DEFAULT '0',
  `unidades_en_deposito` smallint NOT NULL DEFAULT '0',
  `unidades_en_camino_hacia_full` smallint NOT NULL DEFAULT '0',
  `unidades_en_full` smallint NOT NULL DEFAULT '0',
  `unidades_en_devolucion` smallint NOT NULL DEFAULT '0',
  `fecha_ultima_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_stock` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `stock_cortes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_cortes` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `fecha_corte` datetime NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `stock_cortes_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_cortes_detalle` (
  `fk_stock_cortes_id` smallint NOT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `unidades_full` smallint NOT NULL DEFAULT '0',
  `unidades_deposito` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`fk_stock_cortes_id`,`fk_catalogo_SKU`),
  KEY `fk_catalogo_SKU_cortes` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_cortes` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_stock_cortes_id` FOREIGN KEY (`fk_stock_cortes_id`) REFERENCES `stock_cortes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `stock_diario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_diario` (
  `fk_catalogo_SKU` smallint NOT NULL,
  `fecha` date NOT NULL,
  `unidades_full` smallint NOT NULL DEFAULT '0',
  `unidades_deposito` smallint NOT NULL DEFAULT '0',
  `unidades_camino_hacia_full` smallint NOT NULL DEFAULT '0',
  `unidades_vendibles` smallint NOT NULL DEFAULT '0',
  `dias_disponible_full` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`fk_catalogo_SKU`,`fecha`),
  CONSTRAINT `fk_catalogo_SKU_diario` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `stockouts`;
/*!50001 DROP VIEW IF EXISTS `stockouts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `stockouts` AS SELECT 
 1 AS `fecha`,
 1 AS `fk_catalogo_sku`,
 1 AS `Stockout`,
 1 AS `Unidades en Full`,
 1 AS `Demanda diaria est.`,
 1 AS `Unidades Perdidas`,
 1 AS `Costo Neto por Stockout`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `subcategorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategorias` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `fk_categorias_id` smallint NOT NULL,
  `nombre_subcategoria` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_categorias_id` (`fk_categorias_id`),
  CONSTRAINT `fk_categorias_id` FOREIGN KEY (`fk_categorias_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25004 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tarifas_envio_meli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifas_envio_meli` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `peso_min_kg` decimal(6,3) NOT NULL,
  `peso_max_kg` decimal(6,3) NOT NULL,
  `precio_min` decimal(10,2) DEFAULT NULL,
  `precio_max` decimal(10,2) DEFAULT NULL,
  `costo_envio` decimal(10,2) NOT NULL,
  `vigente_desde` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL,
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tarifas_envio_lookup` (`peso_max_kg`,`precio_max`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipo_cambio_oficial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_cambio_oficial` (
  `fecha` date NOT NULL,
  `moneda` char(3) NOT NULL DEFAULT 'USD',
  `cotizacion` decimal(12,4) NOT NULL,
  `fuente` varchar(30) NOT NULL DEFAULT 'bcra',
  `actualizado_en` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fecha`,`moneda`),
  KEY `idx_tc_oficial_fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `v_clientes_compras`;
/*!50001 DROP VIEW IF EXISTS `v_clientes_compras`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_clientes_compras` AS SELECT 
 1 AS `fk_clientes_id`,
 1 AS `nombre_cliente`,
 1 AS `id_comprador_ml`,
 1 AS `compras_distintas`,
 1 AS `lineas_venta`,
 1 AS `unidades_totales`,
 1 AS `neto_total`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `v_estimacion_demanda`;
/*!50001 DROP VIEW IF EXISTS `v_estimacion_demanda`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_estimacion_demanda` AS SELECT 
 1 AS `SKU`,
 1 AS `titulo`,
 1 AS `formato`,
 1 AS `demanda_final`,
 1 AS `confianza`,
 1 AS `inactivo`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `v_eventos_demanda_vigentes`;
/*!50001 DROP VIEW IF EXISTS `v_eventos_demanda_vigentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_eventos_demanda_vigentes` AS SELECT 
 1 AS `id`,
 1 AS `sku`,
 1 AS `titulo`,
 1 AS `tipo`,
 1 AS `fecha_inicio`,
 1 AS `fecha_fin_estimada`,
 1 AS `factor_boost`,
 1 AS `notas`,
 1 AS `estado`,
 1 AS `dias_restantes`,
 1 AS `dias_desde_vencimiento`*/;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_venta_ml` varchar(50) DEFAULT NULL,
  `id_pedido_ml` varchar(50) DEFAULT NULL,
  `fk_catalogo_SKU` smallint NOT NULL,
  `fk_clientes_id` int DEFAULT NULL,
  `canal` enum('Full','Deposito_ML','Deposito_RRSS','Presencial') NOT NULL,
  `estado` enum('en_camino','concretada','cancelada','devuelta','esperando_disponibilidad') NOT NULL DEFAULT 'concretada',
  `unidades` smallint NOT NULL DEFAULT '1',
  `precio_unitario` decimal(8,2) NOT NULL,
  `comision_variable` decimal(8,2) NOT NULL DEFAULT '0.00',
  `comision_fija` decimal(8,2) NOT NULL DEFAULT '0.00',
  `costo_cuotas` decimal(8,2) NOT NULL DEFAULT '0.00',
  `costo_envio` decimal(8,2) NOT NULL DEFAULT '0.00',
  `impuestos` decimal(8,2) NOT NULL DEFAULT '0.00',
  `precio_neto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fecha_venta` datetime NOT NULL,
  `fecha_concrecion` date DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `notas` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ventas_id_venta_ml` (`id_venta_ml`),
  KEY `fk_clientes_id_ventas` (`fk_clientes_id`),
  KEY `fk_catalogo_SKU_ventas` (`fk_catalogo_SKU`),
  CONSTRAINT `fk_catalogo_SKU_ventas` FOREIGN KEY (`fk_catalogo_SKU`) REFERENCES `catalogo` (`SKU`),
  CONSTRAINT `fk_clientes_id_ventas` FOREIGN KEY (`fk_clientes_id`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3740 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


-- =====================================================================
-- DATOS DE EJEMPLO (ficticios) -- catalogo poblado con libros reales,
-- el resto de los valores (precios, ventas, clientes, stock, costos)
-- es sintetico y no corresponde a la operacion real de The Book Store.
-- =====================================================================

-- categorias (10 filas)
INSERT INTO `categorias` (`id`, `nombre_categoria`) VALUES
(1, 'Ficcion'),
(2, 'No Ficcion'),
(3, 'Infantil y Juvenil'),
(4, 'Autoayuda y Desarrollo Personal'),
(5, 'Negocios y Economia'),
(6, 'Ciencia y Tecnologia'),
(7, 'Historia'),
(8, 'Arte y Diseno'),
(9, 'Cocina'),
(10, 'Salud y Bienestar');

-- categorias_costos (9 filas)
INSERT INTO `categorias_costos` (`id`, `nombre`, `descripcion`, `grupo`) VALUES
(1, 'Compra de mercaderia', 'Costo de adquisicion de libros a editoriales', 'compra'),
(2, 'Envio internacional', 'Flete desde editorial/proveedor al deposito', 'logistica'),
(3, 'Envio nacional', 'Flete interno y envios a Full', 'logistica'),
(4, 'Comisiones plataforma', 'Comisiones de venta en marketplace', 'venta'),
(5, 'Impuestos', 'IIBB, IVA y otras cargas impositivas', 'impuestos'),
(6, 'Marketing', 'Publicidad y promociones', 'marketing'),
(7, 'Alquiler deposito', 'Alquiler del espacio de almacenamiento', 'operativo'),
(8, 'Sueldos', 'Remuneraciones del equipo', 'operativo'),
(9, 'Otros gastos operativos', 'Gastos varios no clasificados', 'operativo');

-- segmentos (5 filas)
INSERT INTO `segmentos` (`id`, `nombre_segmento`, `descripcion`, `participacion_objetivo`) VALUES
(1, 'A - Alta rotacion', 'Los titulos de venta mas rapida', 0.30),
(2, 'B - Rotacion media', 'Venta constante pero moderada', 0.35),
(3, 'C - Rotacion baja', 'Venta esporadica', 0.20),
(4, 'D - Cola larga', 'Muy baja rotacion, catalogo amplio', 0.10),
(5, 'Sin demanda', 'Sin ventas registradas en el periodo', 0.05);

-- margenes (7 filas)
INSERT INTO `margenes` (`id`, `valor_margen`, `descripcion_margen`, `decision`) VALUES
('A', 0.45, 'Margen alto - prioridad de pedido', 'seguir pidiendo'),
('B', 0.35, 'Margen bueno - pedido regular', 'seguir pidiendo'),
('B.1', 0.30, 'Margen aceptable - pedido regular', 'seguir pidiendo'),
('C', 0.22, 'Margen ajustado - evaluar antes de pedir', 'evaluar'),
('D', 0.15, 'Margen bajo - no pedir a editorial', 'no pedir'),
('E', 0.08, 'Margen muy bajo - liquidar stock existente', 'liquidar'),
('N/A', 0.00, 'Margen no calculado aun', 'sin calcular');

-- metodos_envio (5 filas)
INSERT INTO `metodos_envio` (`id`, `nombre_metodo`, `tiempo_envio`, `costo_envio_g`) VALUES
(1, 'Correo internacional estandar', 25, 0.0090),
(2, 'courier_penguin', 10, 0.0180),
(3, 'Maritimo consolidado', 45, 0.0035),
(4, 'Retiro en deposito del proveedor', 5, 0.0000),
(5, 'Envio directo editorial local', 7, 0.0060);

-- motivos_retiro (3 filas)
INSERT INTO `motivos_retiro` (`id_motivo`, `nombre_motivo`, `descripcion`) VALUES
(1, 'Sin ventas 90 dias', 'El titulo no registra ventas en los ultimos 90 dias'),
(2, 'Descatalogado por editorial', 'La editorial discontinuo el titulo'),
(3, 'Danado en deposito Full', 'Unidades danadas detectadas en el centro de fulfillment');

-- comisiones_impuestos (10 filas)
INSERT INTO `comisiones_impuestos` (`id`, `nombre`, `plataforma`, `es_impuesto`, `tipo_calculo`, `valor`, `precio_min`, `precio_max`, `aplica_siempre`, `vigencia_desde`, `vigencia_hasta`, `notas`) VALUES
(1, 'Comision variable MELI', 'MELI', 0, 'porcentaje', 0.1300, NULL, NULL, 1, '2026-01-01', NULL, 'Comision estandar categoria libros'),
(2, 'Comision fija MELI < $3000', 'MELI', 0, 'monto_fijo', 180.0000, 0.00, 3000.00, 0, '2026-01-01', NULL, 'Cargo fijo por venta de bajo monto'),
(3, 'IIBB CABA', 'MELI', 1, 'porcentaje', 0.0300, NULL, NULL, 1, '2026-01-01', NULL, NULL),
(4, 'Percepcion IVA', 'MELI', 1, 'porcentaje', 0.0150, NULL, NULL, 1, '2026-01-01', NULL, NULL),
(5, 'Comision cuotas sin interes 3', 'MELI', 0, 'porcentaje', 0.0450, NULL, NULL, 0, '2026-01-01', NULL, 'Costo financiero por cuotas'),
(6, 'Comision cuotas sin interes 6', 'MELI', 0, 'porcentaje', 0.0850, NULL, NULL, 0, '2026-01-01', NULL, 'Costo financiero por cuotas'),
(7, 'Comision variable ML Full', 'MELI', 0, 'porcentaje', 0.1450, NULL, NULL, 1, '2026-03-01', NULL, 'Incluye manipuleo Full'),
(8, 'IIBB Buenos Aires', 'MELI', 1, 'porcentaje', 0.0350, NULL, NULL, 1, '2026-01-01', NULL, NULL),
(9, 'Comision fija venta presencial', 'Presencial', 0, 'monto_fijo', 0.0000, NULL, NULL, 1, '2026-01-01', NULL, 'Sin comision, venta directa'),
(10, 'Comision variable RRSS', 'RRSS', 0, 'porcentaje', 0.0000, NULL, NULL, 1, '2026-01-01', NULL, 'Venta directa por redes');

-- costos_variables (5 filas)
INSERT INTO `costos_variables` (`id`, `nombre`, `valor`, `vigente_desde`, `vigente_hasta`, `aplica_siempre`, `notas`) VALUES
(1, 'Costo de preparacion por envio', 350.0000, '2026-01-01', NULL, 1, 'Embalaje y etiquetado por unidad enviada'),
(2, 'Costo de embalaje protegido', 120.0000, '2026-01-01', NULL, 0, 'Plastico burbuja / caja rigida para libros fragiles'),
(3, 'Costo administrativo por pedido', 500.0000, '2026-01-01', NULL, 1, 'Gestion de pedido a editorial'),
(4, 'Costo de capital inmovilizado', 0.0150, '2026-01-01', NULL, 1, 'Tasa mensual sobre stock inmovilizado'),
(5, 'Costo de handling Full', 90.0000, '2026-03-01', NULL, 1, 'Manipuleo por unidad en centro de fulfillment');

-- tarifas_envio_meli (10 filas)
INSERT INTO `tarifas_envio_meli` (`id`, `peso_min_kg`, `peso_max_kg`, `precio_min`, `precio_max`, `costo_envio`, `vigente_desde`, `vigente_hasta`, `notas`) VALUES
(1, 0.000, 0.200, NULL, 8000.00, 950.00, '2026-01-01', NULL, NULL),
(2, 0.201, 0.500, NULL, 8000.00, 1250.00, '2026-01-01', NULL, NULL),
(3, 0.501, 1.000, NULL, 8000.00, 1650.00, '2026-01-01', NULL, NULL),
(4, 1.001, 2.000, NULL, 8000.00, 2200.00, '2026-01-01', NULL, NULL),
(5, 2.001, 3.000, NULL, 8000.00, 2850.00, '2026-01-01', NULL, NULL),
(6, 0.000, 0.500, 8000.01, 20000.00, 0.00, '2026-01-01', NULL, NULL),
(7, 0.501, 1.500, 8000.01, 20000.00, 0.00, '2026-01-01', NULL, NULL),
(8, 1.501, 3.000, 8000.01, 20000.00, 0.00, '2026-01-01', NULL, NULL),
(9, 0.000, 1.000, 20000.01, NULL, 0.00, '2026-01-01', NULL, NULL),
(10, 1.001, 3.000, 20000.01, NULL, 0.00, '2026-01-01', NULL, NULL);

-- tipo_cambio_oficial (121 filas)
INSERT INTO `tipo_cambio_oficial` (`fecha`, `moneda`, `cotizacion`, `fuente`, `actualizado_en`) VALUES
('2026-06-01', 'USD', 1182.3943, 'bluelytics', '2026-06-01 18:00:00'),
('2026-06-02', 'USD', 1178.6444, 'bluelytics', '2026-06-02 18:00:00'),
('2026-06-03', 'USD', 1177.3947, 'bluelytics', '2026-06-03 18:00:00'),
('2026-06-04', 'USD', 1175.6268, 'bluelytics', '2026-06-04 18:00:00'),
('2026-06-05', 'USD', 1178.9915, 'bluelytics', '2026-06-05 18:00:00'),
('2026-06-06', 'USD', 1181.7585, 'bluelytics', '2026-06-06 18:00:00'),
('2026-06-07', 'USD', 1186.6803, 'bluelytics', '2026-06-07 18:00:00'),
('2026-06-08', 'USD', 1183.5497, 'bluelytics', '2026-06-08 18:00:00'),
('2026-06-09', 'USD', 1183.7689, 'bluelytics', '2026-06-09 18:00:00'),
('2026-06-10', 'USD', 1180.0669, 'bluelytics', '2026-06-10 18:00:00'),
('2026-06-11', 'USD', 1178.2532, 'bluelytics', '2026-06-11 18:00:00'),
('2026-06-12', 'USD', 1179.3068, 'bluelytics', '2026-06-12 18:00:00'),
('2026-06-13', 'USD', 1175.5721, 'bluelytics', '2026-06-13 18:00:00'),
('2026-06-14', 'USD', 1173.5605, 'bluelytics', '2026-06-14 18:00:00'),
('2026-06-15', 'USD', 1176.0594, 'bluelytics', '2026-06-15 18:00:00'),
('2026-06-16', 'USD', 1177.5088, 'bluelytics', '2026-06-16 18:00:00'),
('2026-06-17', 'USD', 1175.7132, 'bluelytics', '2026-06-17 18:00:00'),
('2026-06-18', 'USD', 1177.6058, 'bluelytics', '2026-06-18 18:00:00'),
('2026-06-19', 'USD', 1181.7002, 'bluelytics', '2026-06-19 18:00:00'),
('2026-06-20', 'USD', 1177.7651, 'bluelytics', '2026-06-20 18:00:00'),
('2026-06-21', 'USD', 1181.8233, 'bluelytics', '2026-06-21 18:00:00'),
('2026-06-22', 'USD', 1184.8047, 'bluelytics', '2026-06-22 18:00:00'),
('2026-06-23', 'USD', 1184.2072, 'bluelytics', '2026-06-23 18:00:00'),
('2026-06-24', 'USD', 1181.7620, 'bluelytics', '2026-06-24 18:00:00'),
('2026-06-25', 'USD', 1187.3342, 'bluelytics', '2026-06-25 18:00:00'),
('2026-06-26', 'USD', 1186.7001, 'bluelytics', '2026-06-26 18:00:00'),
('2026-06-27', 'USD', 1183.6276, 'bluelytics', '2026-06-27 18:00:00'),
('2026-06-28', 'USD', 1180.5947, 'bluelytics', '2026-06-28 18:00:00'),
('2026-06-29', 'USD', 1185.0697, 'bluelytics', '2026-06-29 18:00:00'),
('2026-06-30', 'USD', 1187.1069, 'bluelytics', '2026-06-30 18:00:00'),
('2026-07-01', 'USD', 1191.1782, 'bluelytics', '2026-07-01 18:00:00'),
('2026-07-02', 'USD', 1194.4755, 'bluelytics', '2026-07-02 18:00:00'),
('2026-07-03', 'USD', 1195.8378, 'bluelytics', '2026-07-03 18:00:00'),
('2026-07-04', 'USD', 1201.5690, 'bluelytics', '2026-07-04 18:00:00'),
('2026-07-05', 'USD', 1201.3543, 'bluelytics', '2026-07-05 18:00:00'),
('2026-07-06', 'USD', 1202.8747, 'bluelytics', '2026-07-06 18:00:00'),
('2026-07-07', 'USD', 1207.1688, 'bluelytics', '2026-07-07 18:00:00'),
('2026-07-08', 'USD', 1209.3540, 'bluelytics', '2026-07-08 18:00:00'),
('2026-07-09', 'USD', 1213.9710, 'bluelytics', '2026-07-09 18:00:00'),
('2026-07-10', 'USD', 1215.7446, 'bluelytics', '2026-07-10 18:00:00'),
('2026-07-11', 'USD', 1218.7903, 'bluelytics', '2026-07-11 18:00:00'),
('2026-07-12', 'USD', 1215.2485, 'bluelytics', '2026-07-12 18:00:00'),
('2026-07-13', 'USD', 1213.5275, 'bluelytics', '2026-07-13 18:00:00'),
('2026-07-14', 'USD', 1212.4214, 'bluelytics', '2026-07-14 18:00:00'),
('2026-07-15', 'USD', 1209.2193, 'bluelytics', '2026-07-15 18:00:00'),
('2026-07-16', 'USD', 1207.5472, 'bluelytics', '2026-07-16 18:00:00'),
('2026-07-17', 'USD', 1204.5572, 'bluelytics', '2026-07-17 18:00:00'),
('2026-07-18', 'USD', 1203.3370, 'bluelytics', '2026-07-18 18:00:00'),
('2026-07-19', 'USD', 1205.6938, 'bluelytics', '2026-07-19 18:00:00'),
('2026-07-20', 'USD', 1205.3421, 'bluelytics', '2026-07-20 18:00:00'),
('2026-07-21', 'USD', 1205.0439, 'bluelytics', '2026-07-21 18:00:00'),
('2026-07-22', 'USD', 1203.1390, 'bluelytics', '2026-07-22 18:00:00'),
('2026-07-23', 'USD', 1201.8088, 'bluelytics', '2026-07-23 18:00:00'),
('2026-07-24', 'USD', 1207.1753, 'bluelytics', '2026-07-24 18:00:00'),
('2026-07-25', 'USD', 1209.6557, 'bluelytics', '2026-07-25 18:00:00'),
('2026-07-26', 'USD', 1211.7470, 'bluelytics', '2026-07-26 18:00:00'),
('2026-07-27', 'USD', 1209.4584, 'bluelytics', '2026-07-27 18:00:00'),
('2026-07-28', 'USD', 1212.7496, 'bluelytics', '2026-07-28 18:00:00'),
('2026-07-29', 'USD', 1210.3837, 'bluelytics', '2026-07-29 18:00:00'),
('2026-07-30', 'USD', 1210.1782, 'bluelytics', '2026-07-30 18:00:00'),
('2026-07-31', 'USD', 1216.0735, 'bluelytics', '2026-07-31 18:00:00'),
('2026-08-01', 'USD', 1218.4735, 'bluelytics', '2026-08-01 18:00:00'),
('2026-08-02', 'USD', 1220.0430, 'bluelytics', '2026-08-02 18:00:00'),
('2026-08-03', 'USD', 1222.8891, 'bluelytics', '2026-08-03 18:00:00'),
('2026-08-04', 'USD', 1227.3176, 'bluelytics', '2026-08-04 18:00:00'),
('2026-08-05', 'USD', 1231.0776, 'bluelytics', '2026-08-05 18:00:00'),
('2026-08-06', 'USD', 1229.3681, 'bluelytics', '2026-08-06 18:00:00'),
('2026-08-07', 'USD', 1225.6891, 'bluelytics', '2026-08-07 18:00:00'),
('2026-08-08', 'USD', 1224.8436, 'bluelytics', '2026-08-08 18:00:00'),
('2026-08-09', 'USD', 1223.5210, 'bluelytics', '2026-08-09 18:00:00'),
('2026-08-10', 'USD', 1221.6309, 'bluelytics', '2026-08-10 18:00:00'),
('2026-08-11', 'USD', 1227.0600, 'bluelytics', '2026-08-11 18:00:00'),
('2026-08-12', 'USD', 1231.8236, 'bluelytics', '2026-08-12 18:00:00'),
('2026-08-13', 'USD', 1230.9704, 'bluelytics', '2026-08-13 18:00:00'),
('2026-08-14', 'USD', 1233.5248, 'bluelytics', '2026-08-14 18:00:00'),
('2026-08-15', 'USD', 1233.4811, 'bluelytics', '2026-08-15 18:00:00'),
('2026-08-16', 'USD', 1238.6266, 'bluelytics', '2026-08-16 18:00:00'),
('2026-08-17', 'USD', 1239.2151, 'bluelytics', '2026-08-17 18:00:00'),
('2026-08-18', 'USD', 1237.8639, 'bluelytics', '2026-08-18 18:00:00'),
('2026-08-19', 'USD', 1236.3302, 'bluelytics', '2026-08-19 18:00:00'),
('2026-08-20', 'USD', 1237.9439, 'bluelytics', '2026-08-20 18:00:00'),
('2026-08-21', 'USD', 1236.5713, 'bluelytics', '2026-08-21 18:00:00'),
('2026-08-22', 'USD', 1238.4172, 'bluelytics', '2026-08-22 18:00:00'),
('2026-08-23', 'USD', 1243.3954, 'bluelytics', '2026-08-23 18:00:00'),
('2026-08-24', 'USD', 1243.3894, 'bluelytics', '2026-08-24 18:00:00'),
('2026-08-25', 'USD', 1241.5826, 'bluelytics', '2026-08-25 18:00:00'),
('2026-08-26', 'USD', 1247.5580, 'bluelytics', '2026-08-26 18:00:00'),
('2026-08-27', 'USD', 1248.6532, 'bluelytics', '2026-08-27 18:00:00'),
('2026-08-28', 'USD', 1245.5623, 'bluelytics', '2026-08-28 18:00:00'),
('2026-08-29', 'USD', 1242.0335, 'bluelytics', '2026-08-29 18:00:00'),
('2026-08-30', 'USD', 1239.1300, 'bluelytics', '2026-08-30 18:00:00'),
('2026-08-31', 'USD', 1241.4044, 'bluelytics', '2026-08-31 18:00:00'),
('2026-09-01', 'USD', 1245.3252, 'bluelytics', '2026-09-01 18:00:00'),
('2026-09-02', 'USD', 1245.5468, 'bluelytics', '2026-09-02 18:00:00'),
('2026-09-03', 'USD', 1242.1821, 'bluelytics', '2026-09-03 18:00:00'),
('2026-09-04', 'USD', 1241.9983, 'bluelytics', '2026-09-04 18:00:00'),
('2026-09-05', 'USD', 1247.9595, 'bluelytics', '2026-09-05 18:00:00'),
('2026-09-06', 'USD', 1249.2507, 'bluelytics', '2026-09-06 18:00:00'),
('2026-09-07', 'USD', 1254.9614, 'bluelytics', '2026-09-07 18:00:00'),
('2026-09-08', 'USD', 1259.5692, 'bluelytics', '2026-09-08 18:00:00'),
('2026-09-09', 'USD', 1255.6841, 'bluelytics', '2026-09-09 18:00:00'),
('2026-09-10', 'USD', 1258.8913, 'bluelytics', '2026-09-10 18:00:00'),
('2026-09-11', 'USD', 1261.7084, 'bluelytics', '2026-09-11 18:00:00'),
('2026-09-12', 'USD', 1263.0781, 'bluelytics', '2026-09-12 18:00:00'),
('2026-09-13', 'USD', 1261.7463, 'bluelytics', '2026-09-13 18:00:00'),
('2026-09-14', 'USD', 1264.1559, 'bluelytics', '2026-09-14 18:00:00'),
('2026-09-15', 'USD', 1261.2715, 'bluelytics', '2026-09-15 18:00:00'),
('2026-09-16', 'USD', 1261.6191, 'bluelytics', '2026-09-16 18:00:00'),
('2026-09-17', 'USD', 1262.1564, 'bluelytics', '2026-09-17 18:00:00'),
('2026-09-18', 'USD', 1267.6945, 'bluelytics', '2026-09-18 18:00:00'),
('2026-09-19', 'USD', 1272.4530, 'bluelytics', '2026-09-19 18:00:00'),
('2026-09-20', 'USD', 1271.0869, 'bluelytics', '2026-09-20 18:00:00'),
('2026-09-21', 'USD', 1272.0928, 'bluelytics', '2026-09-21 18:00:00'),
('2026-09-22', 'USD', 1269.8793, 'bluelytics', '2026-09-22 18:00:00'),
('2026-09-23', 'USD', 1275.0056, 'bluelytics', '2026-09-23 18:00:00'),
('2026-09-24', 'USD', 1279.7108, 'bluelytics', '2026-09-24 18:00:00'),
('2026-09-25', 'USD', 1278.6952, 'bluelytics', '2026-09-25 18:00:00'),
('2026-09-26', 'USD', 1281.0847, 'bluelytics', '2026-09-26 18:00:00'),
('2026-09-27', 'USD', 1283.1744, 'bluelytics', '2026-09-27 18:00:00'),
('2026-09-28', 'USD', 1280.7028, 'bluelytics', '2026-09-28 18:00:00'),
('2026-09-29', 'USD', 1284.3279, 'bluelytics', '2026-09-29 18:00:00');

-- parametros_reposicion (1 filas)
INSERT INTO `parametros_reposicion` (`id`, `demora_envio_internacional_d`, `demora_procesamiento_d`, `demora_envio_full_d`, `demora_procesamiento_full_d`, `ciclo_pedido_dias`, `tope_unidades_pedido`, `tope_unidades_pedido_min`, `dias_stock_confiable`, `dias_stock_parcial`, `ratio_pico_umbral`, `decaimiento_pico`, `shrinkage_objetivo`, `ventas_confianza_alta`) VALUES
(1, 10, 4, 3, 1, 30, 135, 120, 15, 5, 2.50, 0.50, 10, 10);

-- autores (53 filas)
INSERT INTO `autores` (`id`, `nombre_autor`, `seguidores_goodreads`, `comentarios`) VALUES
(1, 'Gabriel Garcia Marquez', 207112, NULL),
(2, 'George Orwell', 2953, NULL),
(3, 'Jorge Luis Borges', 958, 'Autor de alta rotacion, presente en varios formatos.'),
(4, 'Julio Cortazar', NULL, 'Autor de nicho dentro de su categoria.'),
(5, 'Frank Herbert', 25453, 'Titulo de catalogo permanente (fondo editorial).'),
(6, 'Ray Bradbury', 202387, NULL),
(7, 'Patrick Rothfuss', 1025, 'Autor de nicho dentro de su categoria.'),
(8, 'Fiodor Dostoievski', 72483, 'Autor de nicho dentro de su categoria.'),
(9, 'Carlos Ruiz Zafon', 58521, NULL),
(10, 'Haruki Murakami', 107593, 'Autor de alta rotacion, presente en varios formatos.'),
(11, 'Neil Gaiman', 238828, 'Titulo de catalogo permanente (fondo editorial).'),
(12, 'Roberto Bolano', NULL, NULL),
(13, 'Juan Rulfo', 8514, 'Autor de nicho dentro de su categoria.'),
(14, 'Yuval Noah Harari', NULL, NULL),
(15, 'Walter Isaacson', 188556, NULL),
(16, 'Tara Westover', NULL, 'Autor de alta rotacion, presente en varios formatos.'),
(17, 'Charles Duhigg', NULL, 'Autor de alta rotacion, presente en varios formatos.'),
(18, 'Stephen Hawking', 59160, NULL),
(19, 'J.K. Rowling', 2838, NULL),
(20, 'Antoine de Saint-Exupery', 2437, NULL),
(21, 'Roald Dahl', 28409, 'Titulo de catalogo permanente (fondo editorial).'),
(22, 'Rick Riordan', 1951, 'Titulo de catalogo permanente (fondo editorial).'),
(23, 'John Green', 179518, NULL),
(24, 'Stephen R. Covey', 108544, 'Autor de alta rotacion, presente en varios formatos.'),
(25, 'Eckhart Tolle', NULL, NULL),
(26, 'James Clear', NULL, 'Titulo de catalogo permanente (fondo editorial).'),
(27, 'Carol S. Dweck', 1251, NULL),
(28, 'Robert Kiyosaki', 119164, NULL),
(29, 'Benjamin Graham', 173955, NULL),
(30, 'Simon Sinek', NULL, NULL),
(31, 'Steven Levitt', 2164, NULL),
(32, 'Stephen Dubner', NULL, NULL),
(33, 'Eric Ries', 2052, 'Autor de alta rotacion, presente en varios formatos.'),
(34, 'Carl Sagan', 2363, 'Autor de nicho dentro de su categoria.'),
(35, 'Richard Dawkins', NULL, 'Autor de alta rotacion, presente en varios formatos.'),
(36, 'Robert C. Martin', 18331, 'Autor de nicho dentro de su categoria.'),
(37, 'Jared Diamond', 749, NULL),
(38, 'Ken Follett', 705, 'Autor de nicho dentro de su categoria.'),
(39, 'Bill Bryson', NULL, 'Autor de nicho dentro de su categoria.'),
(40, 'Mario Vargas Llosa', NULL, NULL),
(41, 'John Berger', 20815, NULL),
(42, 'E.H. Gombrich', 34427, NULL),
(43, 'Francis Mallmann', NULL, 'Autor de nicho dentro de su categoria.'),
(44, 'James Nestor', 112897, 'Autor de nicho dentro de su categoria.'),
(45, 'Elizabeth Gilbert', 2815, 'Autor de alta rotacion, presente en varios formatos.'),
(46, 'Isabel Allende', 178564, 'Autor de alta rotacion, presente en varios formatos.'),
(47, 'Agatha Christie', 1477, NULL),
(48, 'Felipe Pigna', 1728, NULL),
(49, 'Ana Frank', 123136, 'Autor de nicho dentro de su categoria.'),
(50, 'John Hersey', 22204, NULL),
(51, 'Victor Papanek', NULL, 'Autor de alta rotacion, presente en varios formatos.'),
(52, 'Narda Lepes', NULL, 'Autor de alta rotacion, presente en varios formatos.'),
(53, 'Iban Yarza', 1667, 'Autor de nicho dentro de su categoria.');

-- editoriales (10 filas)
INSERT INTO `editoriales` (`id`, `nombre_editorial`, `fk_metodos_envio_id`, `descuento_general`) VALUES
(1, 'Penguin Random House Grupo Editorial', 3, 0.47),
(2, 'Grupo Planeta', 5, 0.35),
(3, 'Anagrama', 5, 0.41),
(4, 'Tusquets Editores', 1, 0.54),
(5, 'Grupo Santillana', 2, 0.40),
(6, 'Roca Editorial / Ediciones B', 1, 0.50),
(7, 'Grupo Oceano', 2, 0.40),
(8, 'Debate / Grijalbo', 5, 0.39),
(9, 'Deusto / Empresa Activa', 3, 0.39),
(10, 'Gaia Ediciones / Urano', 3, 0.45);

-- sellos_editoriales (28 filas)
INSERT INTO `sellos_editoriales` (`id`, `nombre_sello`, `fk_editoriales_id`) VALUES
(1, 'Sudamericana', 1),
(2, 'Debolsillo', 1),
(3, 'Alfaguara', 1),
(4, 'Lumen', 1),
(5, 'Plaza & Janes', 1),
(6, 'Reservoir Books', 1),
(7, 'Planeta', 2),
(8, 'Destino', 2),
(9, 'Minotauro', 2),
(10, 'Booket', 2),
(11, 'Anagrama Panorama de Narrativas', 3),
(12, 'Anagrama Compactos', 3),
(13, 'Tusquets Andanzas', 4),
(14, 'Tusquets Maxi', 4),
(15, 'Alfaguara Infantil', 5),
(16, 'Santillana', 5),
(17, 'Roca Editorial', 6),
(18, 'Nube de Tinta', 6),
(19, 'Vergara', 6),
(20, 'Oceano', 7),
(21, 'Paidos', 7),
(22, 'Debate', 8),
(23, 'Grijalbo', 8),
(24, 'Deusto', 9),
(25, 'Empresa Activa', 9),
(26, 'Gaia', 10),
(27, 'Sirio', 10),
(28, 'Urano', 10);

-- subcategorias (30 filas)
INSERT INTO `subcategorias` (`id`, `fk_categorias_id`, `nombre_subcategoria`) VALUES
(1, 1, 'Novela contemporanea'),
(2, 1, 'Novela historica'),
(3, 1, 'Cuentos'),
(4, 1, 'Ciencia ficcion'),
(5, 2, 'Biografias'),
(6, 2, 'Ensayo'),
(7, 2, 'Periodismo narrativo'),
(8, 3, 'Primeros lectores'),
(9, 3, 'Middle grade'),
(10, 3, 'Young adult'),
(11, 4, 'Productividad'),
(12, 4, 'Habitos'),
(13, 4, 'Mindfulness'),
(14, 5, 'Emprendimiento'),
(15, 5, 'Finanzas personales'),
(16, 5, 'Management'),
(17, 6, 'Divulgacion cientifica'),
(18, 6, 'Programacion'),
(19, 6, 'Innovacion'),
(20, 7, 'Historia argentina'),
(21, 7, 'Historia universal'),
(22, 7, 'Historia militar'),
(23, 8, 'Diseno grafico'),
(24, 8, 'Historia del arte'),
(25, 9, 'Cocina internacional'),
(26, 9, 'Reposteria'),
(27, 9, 'Cocina saludable'),
(28, 10, 'Nutricion'),
(29, 10, 'Ejercicio fisico'),
(30, 10, 'Salud mental');

-- clientes (50 filas)
INSERT INTO `clientes` (`id`, `nombre_cliente`, `direccion`, `condicion_fiscal`, `ciudad`, `provincia`, `codigo_postal`, `telefono`, `email`, `intereses`, `id_comprador_ml`) VALUES
(1, 'Cliente Ficticio 001', 'Calle Ejemplo 516', 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', '11-5133-1722', NULL, 'Literatura infantil', 'ML-FICT-100001'),
(2, 'Cliente Ficticio 002', NULL, 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', '11-6297-1158', NULL, 'Literatura infantil', 'ML-FICT-100002'),
(3, 'Cliente Ficticio 003', NULL, 'Consumidor Final', 'Neuquen', 'Neuquen', '8300', '11-5760-3088', NULL, 'Cocina y reposteria', 'ML-FICT-100003'),
(4, 'Cliente Ficticio 004', 'Calle Ejemplo 1820', 'Consumidor Final', 'Ciudad Autonoma de Buenos Aires', 'CABA', '1414', '11-5448-7658', 'cliente004@ejemplo-mail.com', 'Literatura infantil', 'ML-FICT-100004'),
(5, 'Cliente Ficticio 005', 'Calle Ejemplo 1550', 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', NULL, 'cliente005@ejemplo-mail.com', 'Cocina y reposteria', 'ML-FICT-100005'),
(6, 'Cliente Ficticio 006', 'Calle Ejemplo 2132', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-4442-7267', 'cliente006@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100006'),
(7, 'Cliente Ficticio 007', NULL, 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', '11-7360-4728', 'cliente007@ejemplo-mail.com', NULL, 'ML-FICT-100007'),
(8, 'Cliente Ficticio 008', 'Calle Ejemplo 2382', 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', '11-5143-6753', 'cliente008@ejemplo-mail.com', 'Arte y diseno', 'ML-FICT-100008'),
(9, 'Cliente Ficticio 009', 'Calle Ejemplo 326', 'Consumidor Final', 'Neuquen', 'Neuquen', '8300', '11-4731-5349', NULL, NULL, 'ML-FICT-100009'),
(10, 'Cliente Ficticio 010', 'Calle Ejemplo 2669', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-4473-7311', 'cliente010@ejemplo-mail.com', 'Historia argentina', 'ML-FICT-100010'),
(11, 'Cliente Ficticio 011', NULL, 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', '11-7303-9821', 'cliente011@ejemplo-mail.com', NULL, 'ML-FICT-100011'),
(12, 'Cliente Ficticio 012', 'Calle Ejemplo 673', 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', '11-6552-6143', 'cliente012@ejemplo-mail.com', 'Negocios, finanzas personales', 'ML-FICT-100012'),
(13, 'Cliente Ficticio 013', 'Calle Ejemplo 3445', 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', '11-6270-3085', 'cliente013@ejemplo-mail.com', NULL, 'ML-FICT-100013'),
(14, 'Cliente Ficticio 014', 'Calle Ejemplo 1525', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-6244-1006', 'cliente014@ejemplo-mail.com', 'Historia argentina', 'ML-FICT-100014'),
(15, 'Cliente Ficticio 015', 'Calle Ejemplo 2739', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-4875-9375', 'cliente015@ejemplo-mail.com', 'Literatura infantil', 'ML-FICT-100015'),
(16, 'Cliente Ficticio 016', 'Calle Ejemplo 2845', 'Consumidor Final', 'La Plata', 'Buenos Aires', '1900', '11-4962-6085', 'cliente016@ejemplo-mail.com', 'Historia argentina', 'ML-FICT-100016'),
(17, 'Cliente Ficticio 017', NULL, 'Consumidor Final', 'Rosario', 'Santa Fe', '2000', '11-7480-2193', 'cliente017@ejemplo-mail.com', NULL, 'ML-FICT-100017'),
(18, 'Cliente Ficticio 018', NULL, 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-4999-3417', 'cliente018@ejemplo-mail.com', 'Ciencia ficcion, fantasia', 'ML-FICT-100018'),
(19, 'Cliente Ficticio 019', 'Calle Ejemplo 1892', 'Consumidor Final', 'La Plata', 'Buenos Aires', '1900', '11-6121-8611', NULL, 'Historia argentina', 'ML-FICT-100019'),
(20, 'Cliente Ficticio 020', 'Calle Ejemplo 3906', 'Consumidor Final', 'La Plata', 'Buenos Aires', '1900', '11-6438-6198', 'cliente020@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100020'),
(21, 'Cliente Ficticio 021', 'Calle Ejemplo 4235', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-5826-3607', 'cliente021@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100021'),
(22, 'Cliente Ficticio 022', 'Calle Ejemplo 2125', 'Consumidor Final', 'San Miguel de Tucuman', 'Tucuman', '4000', NULL, 'cliente022@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100022'),
(23, 'Cliente Ficticio 023', 'Calle Ejemplo 734', 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', NULL, 'cliente023@ejemplo-mail.com', 'Novela historica', 'ML-FICT-100023'),
(24, 'Cliente Ficticio 024', NULL, 'Consumidor Final', 'La Plata', 'Buenos Aires', '1900', '11-6893-4505', NULL, 'Arte y diseno', 'ML-FICT-100024'),
(25, 'Cliente Ficticio 025', 'Calle Ejemplo 3506', 'Empresa', 'Mar del Plata', 'Buenos Aires', '7600', '11-5595-1320', 'cliente025@ejemplo-mail.com', NULL, 'ML-FICT-100025'),
(26, 'Cliente Ficticio 026', 'Calle Ejemplo 2981', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-7652-7865', 'cliente026@ejemplo-mail.com', 'Novela historica', 'ML-FICT-100026'),
(27, 'Cliente Ficticio 027', 'Calle Ejemplo 4099', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-4118-7371', 'cliente027@ejemplo-mail.com', NULL, 'ML-FICT-100027'),
(28, 'Cliente Ficticio 028', 'Calle Ejemplo 3928', 'Consumidor Final', 'Salta', 'Salta', '4400', '11-6187-1441', 'cliente028@ejemplo-mail.com', NULL, 'ML-FICT-100028'),
(29, 'Cliente Ficticio 029', 'Calle Ejemplo 787', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', NULL, 'cliente029@ejemplo-mail.com', 'Ciencia ficcion, fantasia', 'ML-FICT-100029'),
(30, 'Cliente Ficticio 030', 'Calle Ejemplo 1833', 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', '11-7603-7211', 'cliente030@ejemplo-mail.com', 'Arte y diseno', 'ML-FICT-100030'),
(31, 'Cliente Ficticio 031', 'Calle Ejemplo 3952', 'Empresa', 'Mendoza', 'Mendoza', '5500', '11-7899-6733', 'cliente031@ejemplo-mail.com', 'Negocios, finanzas personales', 'ML-FICT-100031'),
(32, 'Cliente Ficticio 032', 'Calle Ejemplo 2125', 'Consumidor Final', 'Ciudad Autonoma de Buenos Aires', 'CABA', '1414', NULL, 'cliente032@ejemplo-mail.com', 'Literatura infantil', 'ML-FICT-100032'),
(33, 'Cliente Ficticio 033', 'Calle Ejemplo 4720', 'Consumidor Final', 'San Miguel de Tucuman', 'Tucuman', '4000', '11-5049-7043', 'cliente033@ejemplo-mail.com', NULL, 'ML-FICT-100033'),
(34, 'Cliente Ficticio 034', 'Calle Ejemplo 1441', 'Consumidor Final', 'La Plata', 'Buenos Aires', '1900', NULL, NULL, 'Autoayuda', 'ML-FICT-100034'),
(35, 'Cliente Ficticio 035', 'Calle Ejemplo 3174', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-4311-4978', NULL, 'Autoayuda', 'ML-FICT-100035'),
(36, 'Cliente Ficticio 036', 'Calle Ejemplo 4736', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-5754-7071', NULL, NULL, 'ML-FICT-100036'),
(37, 'Cliente Ficticio 037', NULL, 'Consumidor Final', 'Mar del Plata', 'Buenos Aires', '7600', '11-5775-6934', 'cliente037@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100037'),
(38, 'Cliente Ficticio 038', 'Calle Ejemplo 4374', 'Consumidor Final', 'Rosario', 'Santa Fe', '2000', NULL, 'cliente038@ejemplo-mail.com', 'Novela historica', 'ML-FICT-100038'),
(39, 'Cliente Ficticio 039', 'Calle Ejemplo 4953', 'Consumidor Final', 'San Miguel de Tucuman', 'Tucuman', '4000', '11-7402-2419', 'cliente039@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100039'),
(40, 'Cliente Ficticio 040', 'Calle Ejemplo 4768', 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', '11-4117-9098', 'cliente040@ejemplo-mail.com', 'Literatura infantil', 'ML-FICT-100040'),
(41, 'Cliente Ficticio 041', 'Calle Ejemplo 2216', 'Consumidor Final', 'San Miguel de Tucuman', 'Tucuman', '4000', '11-6872-5526', 'cliente041@ejemplo-mail.com', 'Novela historica', 'ML-FICT-100041'),
(42, 'Cliente Ficticio 042', NULL, 'Consumidor Final', 'Cordoba', 'Cordoba', '5000', '11-7105-4937', 'cliente042@ejemplo-mail.com', NULL, 'ML-FICT-100042'),
(43, 'Cliente Ficticio 043', 'Calle Ejemplo 241', 'Consumidor Final', 'San Miguel de Tucuman', 'Tucuman', '4000', NULL, 'cliente043@ejemplo-mail.com', 'Autoayuda', 'ML-FICT-100043'),
(44, 'Cliente Ficticio 044', 'Calle Ejemplo 4634', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', '11-7055-6419', 'cliente044@ejemplo-mail.com', 'Divulgacion cientifica', 'ML-FICT-100044'),
(45, 'Cliente Ficticio 045', 'Calle Ejemplo 1988', 'Consumidor Final', 'Mendoza', 'Mendoza', '5500', NULL, NULL, 'Novela historica', 'ML-FICT-100045'),
(46, 'Cliente Ficticio 046', NULL, 'Consumidor Final', 'Rosario', 'Santa Fe', '2000', NULL, 'cliente046@ejemplo-mail.com', 'Novela historica', 'ML-FICT-100046'),
(47, 'Cliente Ficticio 047', 'Calle Ejemplo 923', 'Consumidor Final', 'Bahia Blanca', 'Buenos Aires', '8000', NULL, 'cliente047@ejemplo-mail.com', 'Autoayuda', 'ML-FICT-100047'),
(48, 'Cliente Ficticio 048', 'Calle Ejemplo 1136', 'Consumidor Final', 'Ciudad Autonoma de Buenos Aires', 'CABA', '1414', '11-6266-5786', 'cliente048@ejemplo-mail.com', 'Literatura infantil', 'ML-FICT-100048'),
(49, 'Cliente Ficticio 049', NULL, 'Empresa', 'San Miguel de Tucuman', 'Tucuman', '4000', NULL, 'cliente049@ejemplo-mail.com', 'Cocina y reposteria', 'ML-FICT-100049'),
(50, 'Cliente Ficticio 050', 'Calle Ejemplo 2168', 'Consumidor Final', 'Rosario', 'Santa Fe', '2000', '11-7367-2070', 'cliente050@ejemplo-mail.com', 'Negocios, finanzas personales', 'ML-FICT-100050');

-- catalogo (58 filas)
INSERT INTO `catalogo` (`SKU`, `ISBN`, `titulo`, `subtitulo`, `fk_margenes_id`, `fk_autores_id`, `formato`, `idioma`, `es_un_kit`, `con_proteccion`, `fk_sellos_editoriales_id`, `fk_subcategorias_id`, `precio_lista`, `descuento_proveedor`, `fecha_publicacion`, `fecha_primera_edicion`, `paginas`, `altura`, `ancho`, `peso_g`, `sinopsis`, `foto_principal`, `fk_segmentos_id`, `fecha_modificacion_margen`, `factor_ajuste_precio`, `precio_competencia`, `stock_inmediato_competencia`, `fecha_analisis_competencia`, `mejorado_en_catalogo`, `recomendado_tbs`, `reseña_TBS`, `disponible_formato_economico`, `a_pedido`, `inactivo`, `fecha_agregacion`, `ventas_estimadas_manual`, `comentario`, `puntaje_goodreads`, `goodreads_calificaciones`, `fecha_actualizacion_goodreads`) VALUES
(1, '0000000000000', 'SIN CATALOGAR (placeholder)', NULL, 'N/A', NULL, 'N/A', 'N/A', 0, 0, NULL, NULL, 0.00, 0.00, '2020-01-01', NULL, 0, 0.00, 0.00, 0.00, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, '2026-01-01', NULL, NULL, NULL, NULL, NULL),
(2, '9780010000023', 'Cien anios de soledad', NULL, 'D', 1, 'Blanda', 'Español', 0, 0, 1, 1, 22.92, 0.36, '1967-04-04', '1967-04-04', 496, 19.67, 14.75, 586.68, 'Edicion de \'Cien anios de soledad\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-25', NULL, NULL, 4.32, 324729, '2026-09-25'),
(3, '9780010000030', 'El amor en los tiempos del colera', NULL, 'B', 1, 'Blanda', 'Español', 0, 0, 1, 1, 26.50, 0.43, '1985-07-10', '1985-07-10', 464, 23.09, 13.69, 606.83, 'Edicion de \'El amor en los tiempos del colera\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-01-20', NULL, NULL, 3.72, 109440, '2026-01-20'),
(4, '9780010000047', '1984', NULL, 'B', 2, 'Pocket', 'Español', 0, 0, 2, 4, 13.98, 0.37, '1949-07-15', '1949-07-15', 328, 20.08, 14.71, 395.74, 'Edicion de \'1984\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-10', 2.66, NULL, 3.94, 238543, '2026-08-10'),
(5, '9780010000054', 'Ficciones', NULL, 'A', 3, 'Pocket', 'Español', 0, 0, 2, 3, 24.34, 0.53, '1944-04-14', '1944-04-14', 224, 22.55, 15.00, 340.84, 'Edicion de \'Ficciones\' en el catalogo de demostracion (dato de portfolio).', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-04-21', 2.49, NULL, 3.77, 31767, '2026-04-21'),
(6, '9780010000061', 'El Aleph', NULL, 'B', 3, 'Pocket', 'Español', 0, 0, 2, 3, 26.92, 0.47, '1949-08-23', '1949-08-23', 240, 22.71, 16.18, 338.16, 'Edicion de \'El Aleph\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-07-09', NULL, NULL, 4.19, 42674, '2026-07-09'),
(7, '9780010000078', 'Rayuela', NULL, 'E', 4, 'Dura', 'Español', 0, 0, 3, 1, 8.48, 0.44, '1963-11-27', '1963-11-27', 736, 20.45, 13.50, 769.29, 'Edicion de \'Rayuela\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-01-25', NULL, NULL, 3.92, 21592, '2026-01-25'),
(8, '9780010000085', 'Dune', NULL, 'B', 5, 'Blanda', 'Español', 0, 0, 2, 4, 19.03, 0.48, '1965-11-27', '1965-11-27', 688, 23.12, 13.23, 860.28, 'Edicion de \'Dune\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-02-16', NULL, NULL, 4.00, 351842, '2026-02-16'),
(9, '9780010000092', 'Fahrenheit 451', NULL, 'B', 6, 'Pocket', 'Español', 0, 0, 9, 4, 28.51, 0.42, '1953-09-02', '1953-09-02', 208, 22.12, 13.65, 345.84, 'Edicion de \'Fahrenheit 451\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-06-09', NULL, NULL, 4.76, 212404, '2026-06-09'),
(10, '9780010000108', 'El nombre del viento', NULL, 'C', 7, 'Dura', 'Español', 0, 0, 5, 4, 27.71, 0.35, '2007-09-12', '2007-09-12', 880, 22.91, 14.35, 891.08, 'Edicion de \'El nombre del viento\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-21', NULL, NULL, 3.66, 140514, '2026-08-21'),
(11, '9780010000115', 'Crimen y castigo', NULL, 'B.1', 8, 'Dura', 'Español', 0, 0, 2, 1, 18.23, 0.49, '1866-04-23', '1866-04-23', 688, 19.55, 16.39, 866.76, 'Edicion de \'Crimen y castigo\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-09-01', NULL, NULL, 3.71, 59986, '2026-09-01'),
(12, '9780010000122', 'La sombra del viento', NULL, 'B', 9, 'Blanda', 'Español', 0, 0, 7, 2, 23.37, 0.38, '2001-07-27', '2001-07-27', 576, 23.20, 13.67, 760.93, 'Edicion de \'La sombra del viento\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-08-08', NULL, NULL, 3.77, 100434, '2026-08-08'),
(13, '9780010000139', 'Tokio Blues (Norwegian Wood)', NULL, 'E', 10, 'Blanda', 'Español', 0, 0, 13, 1, 19.95, 0.53, '1987-07-11', '1987-07-11', 400, 22.89, 13.60, 566.40, 'Edicion de \'Tokio Blues (Norwegian Wood)\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-09', NULL, NULL, 3.94, 157029, '2026-09-09'),
(14, '9780010000146', 'Kafka en la orilla', NULL, 'D', 10, 'Dura', 'Español', 0, 0, 13, 4, 21.71, 0.48, '2002-06-18', '2002-06-18', 640, 22.89, 14.29, 779.99, 'Edicion de \'Kafka en la orilla\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-13', NULL, NULL, 3.99, 99408, '2026-09-13'),
(15, '9780010000153', 'American Gods', NULL, 'B', 11, 'Blanda', 'Español', 0, 0, 17, 4, 21.51, 0.40, '2001-12-26', '2001-12-26', 592, 22.49, 12.67, 789.15, 'Edicion de \'American Gods\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-03-16', NULL, NULL, 3.75, 309924, '2026-03-16'),
(16, '9780010000160', 'Los detectives salvajes', NULL, 'B.1', 12, 'Blanda', 'Español', 0, 0, 11, 1, 28.81, 0.52, '1998-12-05', '1998-12-05', 608, 20.98, 14.60, 738.32, 'Edicion de \'Los detectives salvajes\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-03-03', NULL, NULL, 4.76, 178003, '2026-03-03'),
(17, '9780010000177', 'Pedro Paramo', NULL, 'E', 13, 'Pocket', 'Español', 0, 0, 2, 2, 24.47, 0.48, '1955-07-11', '1955-07-11', 208, 22.83, 15.91, 338.70, 'Edicion de \'Pedro Paramo\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-28', NULL, NULL, 4.34, 123587, '2026-08-28'),
(18, '9780010000184', 'La guerra del fin del mundo', NULL, 'B.1', 40, 'Dura', 'Español', 0, 0, 3, 2, 31.94, 0.50, '1981-02-15', '1981-02-15', 664, 20.95, 12.89, 845.92, 'Edicion de \'La guerra del fin del mundo\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-05-01', 6.47, NULL, 3.95, 197024, '2026-05-01'),
(19, '9780010000191', 'Los pilares de la tierra', NULL, 'B', 38, 'Dura', 'Español', 0, 0, 2, 2, 20.51, 0.46, '1989-07-20', '1989-07-20', 1076, 22.57, 13.18, 1082.39, 'Edicion de \'Los pilares de la tierra\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-19', 3.96, NULL, 3.90, 134364, '2026-08-19'),
(20, '9780010000207', 'Sapiens: De animales a dioses', NULL, 'C', 14, 'Blanda', 'Español', 0, 0, 22, 6, 29.58, 0.49, '2011-10-10', '2011-10-10', 496, 19.71, 14.27, 594.96, 'Edicion de \'Sapiens: De animales a dioses\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-23', 6.84, NULL, 3.84, 202190, '2026-07-23'),
(21, '9780010000214', 'Homo Deus', NULL, 'C', 14, 'Blanda', 'Español', 0, 0, 22, 6, 10.11, 0.43, '2015-01-27', '2015-01-27', 496, 20.62, 13.68, 665.14, 'Edicion de \'Homo Deus\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-09', 6.99, NULL, 4.53, 26213, '2026-07-09'),
(22, '9780010000221', 'Steve Jobs', NULL, 'E', 15, 'Dura', 'Español', 0, 0, 22, 5, 25.76, 0.52, '2011-06-08', '2011-06-08', 784, 23.06, 15.60, 857.77, 'Edicion de \'Steve Jobs\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-04-20', 6.17, NULL, 4.52, 357464, '2026-04-20'),
(23, '9780010000238', 'Una educacion (Educated)', NULL, 'B', 16, 'Blanda', 'Español', 0, 0, 4, 5, 29.63, 0.48, '2018-12-05', '2018-12-05', 432, 20.39, 14.26, 568.95, 'Edicion de \'Una educacion (Educated)\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-05-11', NULL, NULL, 3.81, 69789, '2026-05-11'),
(24, '9780010000245', 'Harry Potter y la piedra filosofal', NULL, 'D', 19, 'Dura', 'Español', 0, 0, 15, 9, 28.97, 0.42, '1997-08-26', '1997-08-26', 254, 21.26, 13.59, 325.32, 'Edicion de \'Harry Potter y la piedra filosofal\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-05-24', NULL, NULL, 4.57, 246040, '2026-05-24'),
(25, '9780010000252', 'El Principito', NULL, 'B', 20, 'Dura', 'Español', 0, 1, 15, 8, 25.98, 0.40, '1943-09-12', '1943-09-12', 96, 22.04, 15.20, 181.66, 'Edicion de \'El Principito\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-07-01', 1.43, NULL, 4.04, 353000, '2026-07-01'),
(26, '9780010000269', 'Matilda', NULL, 'B.1', 21, 'Blanda', 'Español', 0, 0, 15, 8, 27.65, 0.54, '1988-09-11', '1988-09-11', 240, 19.49, 13.44, 298.40, 'Edicion de \'Matilda\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-04-21', 6.68, NULL, 4.69, 158934, '2026-04-21'),
(27, '9780010000276', 'Percy Jackson y el ladron del rayo', NULL, 'C', 22, 'Blanda', 'Español', 0, 0, 18, 9, 10.36, 0.36, '2005-04-18', '2005-04-18', 384, 19.17, 16.48, 443.44, 'Edicion de \'Percy Jackson y el ladron del rayo\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-03-13', NULL, NULL, 4.40, 365658, '2026-03-13'),
(28, '9780010000283', 'Bajo la misma estrella', NULL, 'D', 23, 'Blanda', 'Español', 0, 0, 18, 10, 17.77, 0.50, '2012-08-20', '2012-08-20', 313, 19.70, 14.16, 374.10, 'Edicion de \'Bajo la misma estrella\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-09', 3.28, NULL, 4.13, 124291, '2026-07-09'),
(29, '9780010000290', 'Los 7 habitos de la gente altamente efectiva', NULL, 'B.1', 24, 'Blanda', 'Español', 0, 0, 21, 11, 9.93, 0.49, '1989-07-09', '1989-07-09', 464, 21.45, 16.41, 564.17, 'Edicion de \'Los 7 habitos de la gente altamente efectiva\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-02-28', NULL, NULL, 3.71, 111704, '2026-02-28'),
(30, '9780010000306', 'El poder del ahora', NULL, 'E', 25, 'Blanda', 'Español', 0, 0, 26, 13, 31.29, 0.36, '1997-04-03', '1997-04-03', 224, 20.50, 16.46, 352.11, 'Edicion de \'El poder del ahora\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-07', NULL, NULL, 4.58, 122658, '2026-09-07'),
(31, '9780010000313', 'Habitos atomicos', NULL, 'B.1', 26, 'Blanda', 'Español', 0, 0, 21, 12, 26.47, 0.51, '2018-03-18', '2018-03-18', 320, 21.68, 13.61, 493.96, 'Edicion de \'Habitos atomicos\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-03-04', NULL, NULL, 3.63, 8291, '2026-03-04'),
(32, '9780010000320', 'Mindset: La actitud del exito', NULL, 'B.1', 27, 'Blanda', 'Español', 0, 0, 27, 11, 26.85, 0.40, '2006-12-14', '2006-12-14', 320, 20.46, 13.20, 374.71, 'Edicion de \'Mindset: La actitud del exito\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-02-16', NULL, NULL, 4.03, 311751, '2026-02-16'),
(33, '9780010000337', 'El poder de los habitos', NULL, 'B', 17, 'Blanda', 'Español', 0, 0, 28, 12, 18.57, 0.39, '2012-11-17', '2012-11-17', 400, 21.77, 15.41, 585.40, 'Edicion de \'El poder de los habitos\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-01-02', NULL, NULL, 4.62, 223990, '2026-01-02'),
(34, '9780010000344', 'Padre Rico, Padre Pobre', NULL, 'B', 28, 'Blanda', 'Español', 0, 0, 22, 15, 19.51, 0.53, '1997-02-05', '1997-02-05', 336, 19.33, 12.82, 464.16, 'Edicion de \'Padre Rico, Padre Pobre\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-09-23', NULL, NULL, 4.79, 278664, '2026-09-23'),
(35, '9780010000351', 'El inversor inteligente', NULL, 'B.1', 29, 'Dura', 'Español', 0, 0, 24, 15, 18.62, 0.47, '1949-11-25', '1949-11-25', 640, 19.45, 15.31, 874.31, 'Edicion de \'El inversor inteligente\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-04-14', NULL, NULL, 3.87, 178197, '2026-04-14'),
(36, '9780010000368', 'Empieza con el porque', NULL, 'B.1', 30, 'Blanda', 'Español', 0, 0, 25, 16, 17.69, 0.37, '2009-03-22', '2009-03-22', 256, 20.92, 15.16, 348.73, 'Edicion de \'Empieza con el porque\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-02-03', NULL, NULL, 3.71, 51127, '2026-02-03'),
(37, '9780010000375', 'Freakonomics', NULL, 'B.1', 31, 'Blanda', 'Español', 0, 0, 22, 14, 27.39, 0.46, '2005-02-14', '2005-02-14', 320, 21.64, 14.75, 410.19, 'Edicion de \'Freakonomics\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-07-28', NULL, NULL, 3.66, 151300, '2026-07-28'),
(38, '9780010000382', 'La startup Lean', NULL, 'E', 33, 'Blanda', 'Español', 0, 0, 24, 14, 15.15, 0.37, '2011-02-12', '2011-02-12', 320, 21.28, 13.12, 429.72, 'Edicion de \'La startup Lean\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-12', 2.59, NULL, 3.87, 225478, '2026-09-12'),
(39, '9780010000399', 'Una breve historia del tiempo', NULL, 'D', 18, 'Blanda', 'Español', 0, 0, 23, 17, 31.38, 0.51, '1988-11-27', '1988-11-27', 256, 21.76, 15.07, 313.09, 'Edicion de \'Una breve historia del tiempo\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-05-01', 5.77, NULL, 3.97, 178665, '2026-05-01'),
(40, '9780010000405', 'Cosmos', NULL, 'B.1', 34, 'Blanda', 'Español', 0, 0, 22, 17, 7.65, 0.52, '1980-11-01', '1980-11-01', 432, 21.55, 14.10, 493.32, 'Edicion de \'Cosmos\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-09-07', NULL, NULL, 4.14, 83027, '2026-09-07'),
(41, '9780010000412', 'El gen egoista', NULL, 'B.1', 35, 'Blanda', 'Español', 0, 0, 22, 17, 15.14, 0.41, '1976-03-06', '1976-03-06', 360, 23.24, 14.88, 531.20, 'Edicion de \'El gen egoista\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-01-22', 3.82, NULL, 4.11, 318782, '2026-01-22'),
(42, '9780010000429', 'Clean Code', NULL, 'C', 36, 'Blanda', 'Inglés', 0, 0, 20, 18, 17.65, 0.39, '2008-11-22', '2008-11-22', 464, 21.31, 13.88, 518.18, 'Edicion de \'Clean Code\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-17', NULL, NULL, 3.65, 207731, '2026-08-17'),
(43, '9780010000436', 'Armas, germenes y acero', NULL, 'E', 37, 'Blanda', 'Español', 0, 0, 22, 21, 8.84, 0.39, '1997-05-11', '1997-05-11', 624, 23.25, 15.57, 832.33, 'Edicion de \'Armas, germenes y acero\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-02-01', NULL, NULL, 4.12, 68230, '2026-02-01'),
(44, '9780010000443', 'Breve historia de casi todo', NULL, 'B.1', 39, 'Blanda', 'Español', 0, 0, 2, 21, 20.55, 0.40, '2003-07-28', '2003-07-28', 624, 21.51, 15.17, 730.00, 'Edicion de \'Breve historia de casi todo\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-01', NULL, NULL, 3.69, 164633, '2026-07-01'),
(45, '9780010000450', 'El diario de Ana Frank', NULL, 'D', 49, 'Blanda', 'Español', 0, 0, 2, 22, 18.02, 0.43, '1947-06-06', '1947-06-06', 352, 21.88, 13.66, 453.83, 'Edicion de \'El diario de Ana Frank\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-27', NULL, NULL, 4.03, 229462, '2026-08-27'),
(46, '9780010000467', 'Hiroshima', NULL, 'B', 50, 'Blanda', 'Español', 0, 0, 22, 22, 13.46, 0.47, '1946-06-08', '1946-06-08', 160, 21.36, 14.08, 243.86, 'Edicion de \'Hiroshima\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-03-03', NULL, NULL, 3.74, 267861, '2026-03-03'),
(47, '9780010000474', 'Los mitos de la historia argentina', NULL, 'B', 48, 'Blanda', 'Español', 0, 0, 7, 20, 29.70, 0.42, '2004-04-04', '2004-04-04', 400, 22.27, 15.78, 570.41, 'Edicion de \'Los mitos de la historia argentina\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-04-06', NULL, NULL, 4.51, 344175, '2026-04-06'),
(48, '9780010000481', 'Modos de ver', NULL, 'A', 41, 'Blanda', 'Español', 0, 0, 21, 24, 11.84, 0.50, '1972-08-22', '1972-08-22', 176, 21.22, 15.52, 291.90, 'Edicion de \'Modos de ver\' en el catalogo de demostracion (dato de portfolio).', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-06-28', NULL, NULL, 3.98, 231062, '2026-06-28'),
(49, '9780010000498', 'La historia del arte', NULL, 'A', 42, 'Dura', 'Español', 0, 0, 2, 24, 18.99, 0.48, '1950-02-10', '1950-02-10', 688, 22.58, 14.87, 796.05, 'Edicion de \'La historia del arte\' en el catalogo de demostracion (dato de portfolio).', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-01-02', NULL, NULL, 3.94, 338490, '2026-01-02'),
(50, '9780010000504', 'Disenar para el mundo real', NULL, 'A', 51, 'Blanda', 'Español', 0, 0, 26, 23, 22.57, 0.45, '1971-01-15', '1971-01-15', 400, 21.08, 14.72, 566.69, 'Edicion de \'Disenar para el mundo real\' en el catalogo de demostracion (dato de portfolio).', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-04-11', NULL, NULL, 4.20, 32939, '2026-04-11'),
(51, '9780010000511', 'Siete fuegos', NULL, 'C', 43, 'Dura', 'Español', 0, 0, 1, 25, 10.04, 0.53, '2009-03-02', '2009-03-02', 288, 20.55, 15.36, 397.32, 'Edicion de \'Siete fuegos\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-04-23', NULL, NULL, 4.13, 274570, '2026-04-23'),
(52, '9780010000528', 'Comer y pasarla bien', NULL, 'B.1', 52, 'Blanda', 'Español', 0, 0, 7, 27, 16.63, 0.41, '2010-11-21', '2010-11-21', 240, 20.84, 13.85, 353.40, 'Edicion de \'Comer y pasarla bien\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-06-04', NULL, NULL, 4.06, 132618, '2026-06-04'),
(53, '9780010000535', 'Pan casero', NULL, 'E', 53, 'Blanda', 'Español', 0, 0, 7, 26, 28.90, 0.42, '2016-11-23', '2016-11-23', 400, 21.62, 13.07, 495.97, 'Edicion de \'Pan casero\' en el catalogo de demostracion (dato de portfolio).', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-05', NULL, NULL, 4.73, 162810, '2026-07-05'),
(54, '9780010000542', 'Come, reza, ama', NULL, 'D', 45, 'Blanda', 'Español', 0, 0, 23, 30, 16.73, 0.51, '2006-12-22', '2006-12-22', 400, 22.66, 15.18, 572.63, 'Edicion de \'Come, reza, ama\' en el catalogo de demostracion (dato de portfolio).', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-09-03', NULL, NULL, 4.11, 190202, '2026-09-03'),
(55, '9780010000559', 'Respira (Breath)', NULL, 'A', 44, 'Blanda', 'Español', 0, 0, 28, 29, 16.38, 0.39, '2020-04-05', NULL, 304, 19.96, 16.29, 412.73, 'Edicion de \'Respira (Breath)\' en el catalogo de demostracion (dato de portfolio).', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2026-05-28', NULL, NULL, 4.21, 283495, '2026-05-28'),
(56, '9780010000566', 'Cronica de una muerte anunciada', NULL, 'C', 1, 'Pocket', 'Español', 0, 0, 1, 1, 8.42, 0.42, '1981-03-06', '1981-03-06', 144, 22.45, 13.02, 231.30, 'Edicion de \'Cronica de una muerte anunciada\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-03-24', NULL, NULL, 4.09, 355108, '2026-03-24'),
(57, '9780010000573', 'El Alquimista', NULL, 'B', 46, 'Blanda', 'Español', 0, 0, 1, 1, 31.25, 0.47, '1988-04-10', '1988-04-10', 288, 22.39, 15.64, 366.16, 'Edicion de \'El Alquimista\' en el catalogo de demostracion (dato de portfolio).', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-08-27', 5.59, NULL, 4.28, 231499, '2026-08-27'),
(58, '9780010000580', 'Asesinato en el Orient Express', NULL, 'C', 47, 'Pocket', 'Español', 0, 0, 7, 1, 26.35, 0.51, '1934-04-26', '1934-04-26', 256, 21.26, 14.17, 326.99, 'Edicion de \'Asesinato en el Orient Express\' en el catalogo de demostracion (dato de portfolio).', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-03-28', 5.31, NULL, 4.65, 291239, '2026-03-28');

-- stock (58 filas)
INSERT INTO `stock` (`fk_catalogo_SKU`, `unidades_en_camino_desde_proveedor`, `unidades_en_deposito`, `unidades_en_camino_hacia_full`, `unidades_en_full`, `unidades_en_devolucion`, `fecha_ultima_actualizacion`) VALUES
(1, 0, 0, 0, 0, 0, '2026-09-29 00:00:00'),
(2, 0, 29, 0, 3, 0, '2026-09-29 00:00:00'),
(3, 0, 8, 0, 14, 0, '2026-09-29 00:00:00'),
(4, 0, 30, 0, 7, 0, '2026-09-29 00:00:00'),
(5, 0, 12, 0, 16, 0, '2026-09-29 00:00:00'),
(6, 0, 7, 15, 0, 0, '2026-09-29 00:00:00'),
(7, 0, 25, 0, 4, 0, '2026-09-29 00:00:00'),
(8, 35, 24, 0, 22, 0, '2026-09-29 00:00:00'),
(9, 0, 0, 10, 8, 2, '2026-09-29 00:00:00'),
(10, 0, 16, 0, 13, 0, '2026-09-29 00:00:00'),
(11, 31, 1, 0, 7, 1, '2026-09-29 00:00:00'),
(12, 0, 19, 0, 17, 0, '2026-09-29 00:00:00'),
(13, 0, 13, 0, 0, 0, '2026-09-29 00:00:00'),
(14, 0, 21, 3, 21, 2, '2026-09-29 00:00:00'),
(15, 0, 16, 0, 25, 0, '2026-09-29 00:00:00'),
(16, 0, 20, 0, 12, 0, '2026-09-29 00:00:00'),
(17, 0, 25, 13, 2, 0, '2026-09-29 00:00:00'),
(18, 0, 24, 0, 18, 2, '2026-09-29 00:00:00'),
(19, 16, 10, 0, 20, 0, '2026-09-29 00:00:00'),
(20, 9, 25, 0, 4, 0, '2026-09-29 00:00:00'),
(21, 0, 1, 0, 25, 2, '2026-09-29 00:00:00'),
(22, 0, 12, 2, 17, 0, '2026-09-29 00:00:00'),
(23, 0, 9, 0, 11, 0, '2026-09-29 00:00:00'),
(24, 33, 13, 0, 12, 1, '2026-09-29 00:00:00'),
(25, 0, 22, 0, 15, 1, '2026-09-29 00:00:00'),
(26, 0, 2, 0, 13, 0, '2026-09-29 00:00:00'),
(27, 0, 10, 9, 21, 1, '2026-09-29 00:00:00'),
(28, 0, 5, 0, 22, 0, '2026-09-29 00:00:00'),
(29, 0, 19, 3, 13, 1, '2026-09-29 00:00:00'),
(30, 0, 11, 4, 16, 1, '2026-09-29 00:00:00'),
(31, 0, 1, 14, 4, 0, '2026-09-29 00:00:00'),
(32, 0, 11, 0, 12, 0, '2026-09-29 00:00:00'),
(33, 0, 11, 0, 14, 1, '2026-09-29 00:00:00'),
(34, 0, 10, 0, 20, 0, '2026-09-29 00:00:00'),
(35, 0, 15, 0, 16, 1, '2026-09-29 00:00:00'),
(36, 23, 6, 0, 19, 0, '2026-09-29 00:00:00'),
(37, 0, 27, 0, 2, 0, '2026-09-29 00:00:00'),
(38, 0, 25, 0, 21, 2, '2026-09-29 00:00:00'),
(39, 0, 17, 13, 9, 0, '2026-09-29 00:00:00'),
(40, 0, 25, 0, 11, 0, '2026-09-29 00:00:00'),
(41, 0, 7, 7, 25, 2, '2026-09-29 00:00:00'),
(42, 0, 11, 0, 14, 0, '2026-09-29 00:00:00'),
(43, 35, 9, 0, 12, 2, '2026-09-29 00:00:00'),
(44, 0, 2, 0, 4, 2, '2026-09-29 00:00:00'),
(45, 0, 11, 0, 4, 1, '2026-09-29 00:00:00'),
(46, 0, 16, 0, 1, 0, '2026-09-29 00:00:00'),
(47, 0, 10, 0, 22, 0, '2026-09-29 00:00:00'),
(48, 0, 8, 4, 6, 0, '2026-09-29 00:00:00'),
(49, 0, 19, 11, 17, 0, '2026-09-29 00:00:00'),
(50, 0, 5, 0, 21, 0, '2026-09-29 00:00:00'),
(51, 0, 1, 14, 20, 1, '2026-09-29 00:00:00'),
(52, 6, 19, 12, 20, 0, '2026-09-29 00:00:00'),
(53, 0, 20, 14, 9, 1, '2026-09-29 00:00:00'),
(54, 0, 9, 0, 14, 1, '2026-09-29 00:00:00'),
(55, 0, 15, 0, 14, 0, '2026-09-29 00:00:00'),
(56, 0, 27, 0, 22, 0, '2026-09-29 00:00:00'),
(57, 0, 16, 0, 17, 0, '2026-09-29 00:00:00'),
(58, 0, 8, 0, 14, 0, '2026-09-29 00:00:00');

-- stock_diario (300 filas)
INSERT INTO `stock_diario` (`fk_catalogo_SKU`, `fecha`, `unidades_full`, `unidades_deposito`, `unidades_camino_hacia_full`, `unidades_vendibles`, `dias_disponible_full`) VALUES
(26, '2026-09-15', 13, 4, 0, 13, 1),
(26, '2026-09-16', 11, 4, 0, 11, 1),
(26, '2026-09-17', 10, 2, 8, 10, 1),
(26, '2026-09-18', 16, 3, 5, 16, 1),
(26, '2026-09-19', 10, 0, 0, 10, 1),
(26, '2026-09-20', 12, 2, 0, 12, 1),
(26, '2026-09-21', 10, 3, 1, 10, 1),
(26, '2026-09-22', 14, 1, 6, 14, 1),
(26, '2026-09-23', 12, 0, 7, 12, 1),
(26, '2026-09-24', 13, 4, 5, 13, 1),
(26, '2026-09-25', 15, 4, 0, 15, 1),
(26, '2026-09-26', 10, 3, 0, 10, 1),
(26, '2026-09-27', 14, 2, 0, 14, 1),
(26, '2026-09-28', 14, 4, 7, 14, 1),
(26, '2026-09-29', 10, 0, 0, 10, 1),
(57, '2026-09-15', 19, 16, 8, 19, 1),
(57, '2026-09-16', 17, 15, 0, 17, 1),
(57, '2026-09-17', 18, 16, 0, 18, 1),
(57, '2026-09-18', 18, 16, 6, 18, 1),
(57, '2026-09-19', 20, 18, 8, 20, 1),
(57, '2026-09-20', 18, 16, 0, 18, 1),
(57, '2026-09-21', 16, 16, 0, 16, 1),
(57, '2026-09-22', 18, 16, 1, 18, 1),
(57, '2026-09-23', 17, 16, 4, 17, 1),
(57, '2026-09-24', 14, 18, 0, 14, 1),
(57, '2026-09-25', 18, 18, 0, 18, 1),
(57, '2026-09-26', 20, 15, 1, 20, 1),
(57, '2026-09-27', 19, 14, 0, 19, 1),
(57, '2026-09-28', 17, 16, 0, 17, 1),
(57, '2026-09-29', 17, 15, 7, 17, 1),
(41, '2026-09-15', 28, 9, 8, 28, 1),
(41, '2026-09-16', 27, 5, 3, 27, 1),
(41, '2026-09-17', 23, 9, 6, 23, 1),
(41, '2026-09-18', 25, 9, 0, 25, 1),
(41, '2026-09-19', 23, 8, 6, 23, 1),
(41, '2026-09-20', 24, 7, 0, 24, 1),
(41, '2026-09-21', 23, 7, 0, 23, 1),
(41, '2026-09-22', 24, 7, 4, 24, 1),
(41, '2026-09-23', 27, 8, 0, 27, 1),
(41, '2026-09-24', 24, 9, 0, 24, 1),
(41, '2026-09-25', 22, 9, 0, 22, 1),
(41, '2026-09-26', 28, 7, 0, 28, 1),
(41, '2026-09-27', 22, 7, 0, 22, 1),
(41, '2026-09-28', 25, 7, 0, 25, 1),
(41, '2026-09-29', 23, 9, 5, 23, 1),
(28, '2026-09-15', 24, 5, 0, 24, 1),
(28, '2026-09-16', 23, 7, 0, 23, 1),
(28, '2026-09-17', 19, 7, 4, 19, 1),
(28, '2026-09-18', 20, 3, 0, 20, 1),
(28, '2026-09-19', 21, 6, 2, 21, 1),
(28, '2026-09-20', 25, 4, 1, 25, 1),
(28, '2026-09-21', 20, 6, 0, 20, 1),
(28, '2026-09-22', 24, 4, 0, 24, 1),
(28, '2026-09-23', 21, 3, 2, 21, 1),
(28, '2026-09-24', 23, 4, 0, 23, 1),
(28, '2026-09-25', 22, 4, 0, 22, 1),
(28, '2026-09-26', 25, 6, 3, 25, 1),
(28, '2026-09-27', 25, 5, 0, 25, 1),
(28, '2026-09-28', 21, 7, 0, 21, 1),
(28, '2026-09-29', 21, 6, 0, 21, 1),
(17, '2026-09-15', 5, 27, 0, 5, 1),
(17, '2026-09-16', 0, 23, 0, 0, 0),
(17, '2026-09-17', 4, 26, 5, 4, 1),
(17, '2026-09-18', 0, 23, 0, 0, 0),
(17, '2026-09-19', 3, 24, 3, 3, 1),
(17, '2026-09-20', 5, 26, 7, 5, 1),
(17, '2026-09-21', 1, 23, 7, 1, 1),
(17, '2026-09-22', 0, 24, 0, 0, 0),
(17, '2026-09-23', 1, 24, 0, 1, 1),
(17, '2026-09-24', 2, 24, 0, 2, 1),
(17, '2026-09-25', 1, 25, 0, 1, 1),
(17, '2026-09-26', 4, 25, 0, 4, 1),
(17, '2026-09-27', 4, 23, 0, 4, 1),
(17, '2026-09-28', 0, 26, 5, 0, 0),
(17, '2026-09-29', 0, 25, 6, 0, 0),
(12, '2026-09-15', 15, 18, 0, 15, 1),
(12, '2026-09-16', 15, 20, 0, 15, 1),
(12, '2026-09-17', 19, 21, 8, 19, 1),
(12, '2026-09-18', 20, 18, 4, 20, 1),
(12, '2026-09-19', 20, 21, 2, 20, 1),
(12, '2026-09-20', 17, 21, 0, 17, 1),
(12, '2026-09-21', 18, 17, 1, 18, 1),
(12, '2026-09-22', 18, 18, 0, 18, 1),
(12, '2026-09-23', 16, 21, 0, 16, 1),
(12, '2026-09-24', 19, 18, 0, 19, 1),
(12, '2026-09-25', 18, 20, 0, 18, 1),
(12, '2026-09-26', 15, 21, 0, 15, 1),
(12, '2026-09-27', 18, 17, 8, 18, 1),
(12, '2026-09-28', 20, 19, 0, 20, 1),
(12, '2026-09-29', 16, 17, 4, 16, 1),
(22, '2026-09-15', 14, 10, 0, 14, 1),
(22, '2026-09-16', 19, 10, 0, 19, 1),
(22, '2026-09-17', 17, 10, 0, 17, 1),
(22, '2026-09-18', 15, 11, 0, 15, 1),
(22, '2026-09-19', 17, 13, 0, 17, 1),
(22, '2026-09-20', 14, 14, 3, 14, 1),
(22, '2026-09-21', 20, 12, 0, 20, 1),
(22, '2026-09-22', 18, 13, 3, 18, 1),
(22, '2026-09-23', 15, 10, 0, 15, 1),
(22, '2026-09-24', 17, 14, 7, 17, 1),
(22, '2026-09-25', 17, 11, 0, 17, 1),
(22, '2026-09-26', 16, 11, 0, 16, 1),
(22, '2026-09-27', 19, 10, 1, 19, 1),
(22, '2026-09-28', 17, 14, 0, 17, 1),
(22, '2026-09-29', 15, 10, 2, 15, 1),
(38, '2026-09-15', 18, 26, 0, 18, 1),
(38, '2026-09-16', 23, 23, 0, 23, 1),
(38, '2026-09-17', 19, 27, 0, 19, 1),
(38, '2026-09-18', 19, 27, 0, 19, 1),
(38, '2026-09-19', 24, 27, 6, 24, 1),
(38, '2026-09-20', 22, 25, 0, 22, 1),
(38, '2026-09-21', 19, 27, 0, 19, 1),
(38, '2026-09-22', 20, 25, 1, 20, 1),
(38, '2026-09-23', 22, 24, 7, 22, 1),
(38, '2026-09-24', 21, 23, 6, 21, 1),
(38, '2026-09-25', 23, 26, 6, 23, 1),
(38, '2026-09-26', 21, 26, 0, 21, 1),
(38, '2026-09-27', 21, 24, 0, 21, 1),
(38, '2026-09-28', 24, 24, 5, 24, 1),
(38, '2026-09-29', 19, 26, 1, 19, 1),
(48, '2026-09-15', 6, 9, 0, 6, 1),
(48, '2026-09-16', 4, 8, 0, 4, 1),
(48, '2026-09-17', 8, 6, 0, 8, 1),
(48, '2026-09-18', 3, 10, 0, 3, 1),
(48, '2026-09-19', 5, 9, 0, 5, 1),
(48, '2026-09-20', 4, 10, 0, 4, 1),
(48, '2026-09-21', 4, 8, 0, 4, 1),
(48, '2026-09-22', 4, 7, 2, 4, 1),
(48, '2026-09-23', 9, 9, 4, 9, 1),
(48, '2026-09-24', 7, 7, 0, 7, 1),
(48, '2026-09-25', 7, 8, 0, 7, 1),
(48, '2026-09-26', 6, 10, 0, 6, 1),
(48, '2026-09-27', 5, 8, 0, 5, 1),
(48, '2026-09-28', 3, 9, 0, 3, 1),
(48, '2026-09-29', 5, 8, 0, 5, 1),
(52, '2026-09-15', 21, 18, 0, 21, 1),
(52, '2026-09-16', 19, 21, 0, 19, 1),
(52, '2026-09-17', 18, 18, 0, 18, 1),
(52, '2026-09-18', 20, 21, 0, 20, 1),
(52, '2026-09-19', 21, 19, 0, 21, 1),
(52, '2026-09-20', 22, 20, 0, 22, 1),
(52, '2026-09-21', 22, 19, 0, 22, 1),
(52, '2026-09-22', 22, 21, 0, 22, 1),
(52, '2026-09-23', 21, 17, 0, 21, 1),
(52, '2026-09-24', 23, 17, 0, 23, 1),
(52, '2026-09-25', 18, 18, 2, 18, 1),
(52, '2026-09-26', 18, 17, 4, 18, 1),
(52, '2026-09-27', 20, 19, 1, 20, 1),
(52, '2026-09-28', 22, 21, 8, 22, 1),
(52, '2026-09-29', 20, 17, 1, 20, 1),
(14, '2026-09-15', 22, 22, 0, 22, 1),
(14, '2026-09-16', 22, 21, 0, 22, 1),
(14, '2026-09-17', 22, 22, 0, 22, 1),
(14, '2026-09-18', 18, 23, 0, 18, 1),
(14, '2026-09-19', 19, 23, 0, 19, 1),
(14, '2026-09-20', 20, 22, 0, 20, 1),
(14, '2026-09-21', 21, 22, 4, 21, 1),
(14, '2026-09-22', 19, 21, 2, 19, 1),
(14, '2026-09-23', 24, 19, 0, 24, 1),
(14, '2026-09-24', 21, 22, 0, 21, 1),
(14, '2026-09-25', 23, 19, 0, 23, 1),
(14, '2026-09-26', 21, 22, 6, 21, 1),
(14, '2026-09-27', 24, 19, 0, 24, 1),
(14, '2026-09-28', 19, 23, 0, 19, 1),
(14, '2026-09-29', 18, 19, 5, 18, 1),
(53, '2026-09-15', 10, 18, 0, 10, 1),
(53, '2026-09-16', 6, 19, 3, 6, 1),
(53, '2026-09-17', 12, 21, 0, 12, 1),
(53, '2026-09-18', 7, 22, 4, 7, 1),
(53, '2026-09-19', 12, 21, 0, 12, 1),
(53, '2026-09-20', 12, 19, 2, 12, 1),
(53, '2026-09-21', 11, 20, 0, 11, 1),
(53, '2026-09-22', 9, 19, 0, 9, 1),
(53, '2026-09-23', 10, 22, 0, 10, 1),
(53, '2026-09-24', 6, 20, 0, 6, 1),
(53, '2026-09-25', 7, 20, 0, 7, 1),
(53, '2026-09-26', 7, 22, 0, 7, 1),
(53, '2026-09-27', 12, 22, 0, 12, 1),
(53, '2026-09-28', 11, 18, 0, 11, 1),
(53, '2026-09-29', 7, 21, 3, 7, 1),
(33, '2026-09-15', 14, 11, 0, 14, 1),
(33, '2026-09-16', 11, 9, 0, 11, 1),
(33, '2026-09-17', 13, 11, 0, 13, 1),
(33, '2026-09-18', 11, 10, 0, 11, 1),
(33, '2026-09-19', 15, 13, 0, 15, 1),
(33, '2026-09-20', 11, 9, 6, 11, 1),
(33, '2026-09-21', 11, 13, 0, 11, 1),
(33, '2026-09-22', 11, 11, 0, 11, 1),
(33, '2026-09-23', 17, 9, 4, 17, 1),
(33, '2026-09-24', 15, 10, 0, 15, 1),
(33, '2026-09-25', 12, 11, 0, 12, 1),
(33, '2026-09-26', 14, 10, 0, 14, 1),
(33, '2026-09-27', 14, 11, 0, 14, 1),
(33, '2026-09-28', 14, 9, 0, 14, 1),
(33, '2026-09-29', 12, 12, 0, 12, 1),
(34, '2026-09-15', 17, 9, 0, 17, 1),
(34, '2026-09-16', 20, 10, 0, 20, 1),
(34, '2026-09-17', 20, 10, 7, 20, 1),
(34, '2026-09-18', 21, 9, 0, 21, 1),
(34, '2026-09-19', 21, 9, 0, 21, 1);
INSERT INTO `stock_diario` (`fk_catalogo_SKU`, `fecha`, `unidades_full`, `unidades_deposito`, `unidades_camino_hacia_full`, `unidades_vendibles`, `dias_disponible_full`) VALUES
(34, '2026-09-20', 18, 11, 0, 18, 1),
(34, '2026-09-21', 22, 11, 0, 22, 1),
(34, '2026-09-22', 20, 10, 0, 20, 1),
(34, '2026-09-23', 17, 12, 4, 17, 1),
(34, '2026-09-24', 21, 9, 1, 21, 1),
(34, '2026-09-25', 20, 9, 0, 20, 1),
(34, '2026-09-26', 23, 8, 7, 23, 1),
(34, '2026-09-27', 20, 9, 0, 20, 1),
(34, '2026-09-28', 19, 9, 0, 19, 1),
(34, '2026-09-29', 17, 11, 8, 17, 1),
(31, '2026-09-15', 4, 3, 7, 4, 1),
(31, '2026-09-16', 1, 1, 0, 1, 1),
(31, '2026-09-17', 7, 0, 0, 7, 1),
(31, '2026-09-18', 6, 3, 1, 6, 1),
(31, '2026-09-19', 6, 2, 0, 6, 1),
(31, '2026-09-20', 1, 0, 0, 1, 1),
(31, '2026-09-21', 2, 3, 0, 2, 1),
(31, '2026-09-22', 3, 2, 8, 3, 1),
(31, '2026-09-23', 5, 3, 0, 5, 1),
(31, '2026-09-24', 1, 2, 0, 1, 1),
(31, '2026-09-25', 4, 0, 2, 4, 1),
(31, '2026-09-26', 2, 1, 0, 2, 1),
(31, '2026-09-27', 4, 0, 0, 4, 1),
(31, '2026-09-28', 4, 0, 8, 4, 1),
(31, '2026-09-29', 6, 2, 0, 6, 1),
(46, '2026-09-15', 0, 14, 0, 0, 0),
(46, '2026-09-16', 4, 16, 2, 4, 1),
(46, '2026-09-17', 4, 15, 4, 4, 1),
(46, '2026-09-18', 0, 18, 0, 0, 0),
(46, '2026-09-19', 2, 17, 0, 2, 1),
(46, '2026-09-20', 4, 17, 0, 4, 1),
(46, '2026-09-21', 3, 17, 0, 3, 1),
(46, '2026-09-22', 3, 18, 0, 3, 1),
(46, '2026-09-23', 2, 17, 0, 2, 1),
(46, '2026-09-24', 3, 15, 0, 3, 1),
(46, '2026-09-25', 4, 14, 2, 4, 1),
(46, '2026-09-26', 0, 16, 0, 0, 0),
(46, '2026-09-27', 1, 14, 5, 1, 1),
(46, '2026-09-28', 4, 17, 6, 4, 1),
(46, '2026-09-29', 1, 18, 7, 1, 1),
(21, '2026-09-15', 22, 1, 0, 22, 1),
(21, '2026-09-16', 26, 0, 5, 26, 1),
(21, '2026-09-17', 26, 0, 0, 26, 1),
(21, '2026-09-18', 22, 0, 0, 22, 1),
(21, '2026-09-19', 23, 1, 3, 23, 1),
(21, '2026-09-20', 25, 2, 3, 25, 1),
(21, '2026-09-21', 25, 2, 0, 25, 1),
(21, '2026-09-22', 27, 3, 3, 27, 1),
(21, '2026-09-23', 23, 2, 0, 23, 1),
(21, '2026-09-24', 23, 1, 8, 23, 1),
(21, '2026-09-25', 22, 1, 0, 22, 1),
(21, '2026-09-26', 23, 0, 7, 23, 1),
(21, '2026-09-27', 26, 2, 7, 26, 1),
(21, '2026-09-28', 25, 2, 0, 25, 1),
(21, '2026-09-29', 23, 0, 0, 23, 1),
(43, '2026-09-15', 11, 7, 0, 11, 1),
(43, '2026-09-16', 13, 9, 0, 13, 1),
(43, '2026-09-17', 13, 10, 2, 13, 1),
(43, '2026-09-18', 9, 9, 6, 9, 1),
(43, '2026-09-19', 15, 7, 8, 15, 1),
(43, '2026-09-20', 10, 10, 2, 10, 1),
(43, '2026-09-21', 15, 8, 0, 15, 1),
(43, '2026-09-22', 12, 9, 0, 12, 1),
(43, '2026-09-23', 12, 7, 0, 12, 1),
(43, '2026-09-24', 15, 11, 6, 15, 1),
(43, '2026-09-25', 13, 10, 3, 13, 1),
(43, '2026-09-26', 10, 8, 0, 10, 1),
(43, '2026-09-27', 13, 9, 5, 13, 1),
(43, '2026-09-28', 13, 8, 6, 13, 1),
(43, '2026-09-29', 11, 9, 5, 11, 1),
(3, '2026-09-15', 16, 6, 0, 16, 1),
(3, '2026-09-16', 11, 8, 3, 11, 1),
(3, '2026-09-17', 17, 7, 0, 17, 1),
(3, '2026-09-18', 16, 8, 4, 16, 1),
(3, '2026-09-19', 14, 9, 3, 14, 1),
(3, '2026-09-20', 16, 8, 0, 16, 1),
(3, '2026-09-21', 14, 6, 0, 14, 1),
(3, '2026-09-22', 15, 8, 0, 15, 1),
(3, '2026-09-23', 14, 8, 1, 14, 1),
(3, '2026-09-24', 11, 9, 0, 11, 1),
(3, '2026-09-25', 17, 10, 0, 17, 1),
(3, '2026-09-26', 14, 7, 0, 14, 1),
(3, '2026-09-27', 13, 8, 6, 13, 1),
(3, '2026-09-28', 15, 7, 0, 15, 1),
(3, '2026-09-29', 16, 6, 0, 16, 1),
(7, '2026-09-15', 6, 26, 0, 6, 1),
(7, '2026-09-16', 7, 24, 0, 7, 1),
(7, '2026-09-17', 1, 26, 4, 1, 1),
(7, '2026-09-18', 2, 25, 0, 2, 1),
(7, '2026-09-19', 1, 25, 0, 1, 1),
(7, '2026-09-20', 3, 24, 0, 3, 1),
(7, '2026-09-21', 6, 25, 0, 6, 1),
(7, '2026-09-22', 6, 23, 0, 6, 1),
(7, '2026-09-23', 2, 26, 0, 2, 1),
(7, '2026-09-24', 5, 24, 0, 5, 1),
(7, '2026-09-25', 1, 25, 0, 1, 1),
(7, '2026-09-26', 6, 24, 0, 6, 1),
(7, '2026-09-27', 2, 26, 2, 2, 1),
(7, '2026-09-28', 7, 23, 0, 7, 1),
(7, '2026-09-29', 3, 25, 0, 3, 1);

-- stock_cortes (3 filas)
INSERT INTO `stock_cortes` (`id`, `fecha_corte`, `descripcion`) VALUES
(1, '2026-07-01 09:00:00', 'Corte mensual julio'),
(2, '2026-08-01 09:00:00', 'Corte mensual agosto'),
(3, '2026-09-01 09:00:00', 'Corte mensual septiembre');

-- stock_cortes_detalle (60 filas)
INSERT INTO `stock_cortes_detalle` (`fk_stock_cortes_id`, `fk_catalogo_SKU`, `unidades_full`, `unidades_deposito`) VALUES
(1, 26, 10, 7),
(1, 57, 22, 13),
(1, 41, 21, 10),
(1, 28, 26, 0),
(1, 17, 6, 30),
(1, 12, 14, 21),
(1, 22, 17, 10),
(1, 38, 26, 22),
(1, 48, 7, 12),
(1, 52, 25, 21),
(1, 14, 19, 17),
(1, 53, 5, 17),
(1, 33, 10, 15),
(1, 34, 21, 10),
(1, 31, 5, 1),
(1, 46, 0, 14),
(1, 21, 24, 6),
(1, 43, 8, 7),
(1, 3, 17, 12),
(1, 7, 8, 29),
(2, 26, 12, 0),
(2, 57, 22, 15),
(2, 41, 23, 10),
(2, 28, 26, 8),
(2, 17, 0, 26),
(2, 12, 16, 24),
(2, 22, 12, 10),
(2, 38, 23, 26),
(2, 48, 2, 6),
(2, 52, 22, 24),
(2, 14, 25, 17),
(2, 53, 12, 15),
(2, 33, 14, 11),
(2, 34, 17, 11),
(2, 31, 8, 2),
(2, 46, 1, 19),
(2, 21, 30, 0),
(2, 43, 14, 5),
(2, 3, 9, 12),
(2, 7, 0, 20),
(3, 26, 12, 0),
(3, 57, 12, 11),
(3, 41, 26, 10),
(3, 28, 21, 10),
(3, 17, 5, 26),
(3, 12, 18, 20),
(3, 22, 13, 17),
(3, 38, 24, 28),
(3, 48, 10, 5),
(3, 52, 19, 15),
(3, 14, 20, 17),
(3, 53, 12, 18),
(3, 33, 11, 14),
(3, 34, 20, 11),
(3, 31, 8, 6),
(3, 46, 6, 21),
(3, 21, 30, 0),
(3, 43, 11, 10),
(3, 3, 12, 3),
(3, 7, 2, 21);

-- pedidos_editorial (10 filas)
INSERT INTO `pedidos_editorial` (`id`, `fecha_pedido`, `fecha_arribo_estimada`, `fecha_recepcion`, `estado`, `fk_editoriales_id`, `costo_mercaderias`, `fk_metodos_envio_id`, `costo_envio`, `peso_estimado`, `unidades_pedidas`, `unidades_mal_estado`, `unidades_no_recibidas`, `reembolsos`, `notas`) VALUES
(1, '2026-05-11', '2026-05-26', '2026-05-24', 'procesado', 5, 615.00, 2, 341.92, 67.61, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(2, '2026-07-20', '2026-08-10', NULL, 'en_camino', 9, 1809.38, 5, 346.68, 27.52, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(3, '2026-07-29', '2026-08-23', '2026-08-25', 'recibido', 2, 1003.02, 1, 238.85, 54.29, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(4, '2026-06-24', '2026-07-19', NULL, 'en_camino', 2, 1219.36, 4, 213.25, 52.47, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(5, '2026-04-07', '2026-04-23', '2026-04-25', 'procesado', 2, 1613.42, 5, 122.67, 70.56, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(6, '2026-08-30', '2026-09-13', NULL, 'en_camino', 1, 482.77, 2, 214.67, 84.02, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(7, '2026-07-16', '2026-07-30', '2026-08-03', 'procesado', 4, 846.87, 3, 418.87, 39.00, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(8, '2026-08-11', '2026-09-03', '2026-09-01', 'procesado', 3, 1847.81, 2, 443.12, 86.56, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(9, '2026-08-13', '2026-09-03', NULL, 'en_camino', 5, 555.49, 3, 249.00, 42.67, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular'),
(10, '2026-06-17', '2026-07-10', '2026-07-11', 'recibido', 8, 1465.04, 3, 262.54, 72.95, NULL, NULL, NULL, NULL, 'Pedido de reposicion regular');

-- detalle_pedidos_editorial (42 filas)
INSERT INTO `detalle_pedidos_editorial` (`fk_pedidos_editorial_id`, `fk_catalogo_SKU`, `cantidad_pedida`, `cantidad_recibida_ok`, `cantidad_mal_estado`, `cantidad_no_recibida`) VALUES
(1, 48, 12, 12, 0, 0),
(1, 36, 18, 18, 0, 0),
(1, 50, 22, 22, 0, 0),
(1, 52, 15, 14, 0, 1),
(2, 8, 20, 0, 0, 0),
(2, 15, 6, 0, 0, 0),
(2, 35, 9, 0, 0, 0),
(2, 17, 27, 0, 0, 0),
(2, 28, 13, 0, 0, 0),
(3, 4, 21, 20, 1, 0),
(3, 16, 19, 19, 0, 0),
(3, 56, 21, 20, 0, 1),
(4, 39, 18, 0, 0, 0),
(4, 38, 26, 0, 0, 0),
(4, 5, 9, 0, 0, 0),
(5, 20, 30, 29, 1, 0),
(5, 18, 15, 14, 1, 0),
(5, 56, 12, 12, 0, 0),
(5, 22, 9, 7, 2, 0),
(6, 8, 15, 0, 0, 0),
(6, 12, 18, 0, 0, 0),
(6, 30, 8, 0, 0, 0),
(6, 31, 22, 0, 0, 0),
(7, 51, 13, 13, 0, 0),
(7, 15, 10, 10, 0, 0),
(7, 30, 11, 11, 0, 0),
(7, 21, 7, 7, 0, 0),
(7, 31, 17, 15, 2, 0),
(8, 18, 19, 17, 2, 0),
(8, 54, 8, 7, 1, 0),
(8, 13, 30, 30, 0, 0),
(8, 3, 5, 5, 0, 0),
(8, 27, 9, 8, 0, 1),
(9, 45, 23, 0, 0, 0),
(9, 42, 13, 0, 0, 0),
(9, 43, 7, 0, 0, 0),
(9, 7, 5, 0, 0, 0),
(9, 39, 7, 0, 0, 0),
(10, 43, 7, 7, 0, 0),
(10, 30, 6, 5, 1, 0),
(10, 53, 10, 7, 2, 1),
(10, 10, 28, 26, 1, 1);

-- ajustes_stock (12 filas)
INSERT INTO `ajustes_stock` (`id`, `fk_catalogo_SKU`, `fecha`, `ubicacion`, `cantidad`, `tipo`, `fk_compras_id`, `notas`) VALUES
(1, 3, '2026-06-23', 'full', 2, 'correccion_inventario', NULL, 'Ajuste detectado en control de inventario'),
(2, 19, '2026-06-06', 'deposito', 1, 'otro', 10, NULL),
(3, 43, '2026-07-15', 'full', 4, 'otro', NULL, NULL),
(4, 19, '2026-06-22', 'deposito', 4, 'retiro_personal', NULL, 'Retiro para uso propio / obsequio'),
(5, 53, '2026-05-12', 'deposito', 4, 'otro', NULL, 'Retiro para uso propio / obsequio'),
(6, 52, '2026-05-27', 'full', 5, 'otro', NULL, 'Ajuste detectado en control de inventario'),
(7, 13, '2026-09-22', 'full', 5, 'retiro_personal', NULL, NULL),
(8, 53, '2026-05-31', 'full', 5, 'retiro_personal', NULL, NULL),
(9, 44, '2026-07-29', 'full', 5, 'otro', NULL, 'Retiro para uso propio / obsequio'),
(10, 56, '2026-06-21', 'full', 2, 'retiro_personal', 4, 'Ajuste detectado en control de inventario'),
(11, 53, '2026-03-24', 'full', 5, 'retiro_personal', 6, 'Retiro para uso propio / obsequio'),
(12, 11, '2026-05-07', 'deposito', 4, 'otro', NULL, 'Ajuste detectado en control de inventario');

-- envios_full (8 filas)
INSERT INTO `envios_full` (`id`, `fecha_envio`, `fecha_procesamiento_full`, `estado`, `costo_envio`, `flete_interno`, `notas`) VALUES
(1, '2026-09-10', '2026-09-13', 'procesado', 841.50, 581, 'Envio periodico a centro de fulfillment'),
(2, '2026-05-08', '2026-05-12', 'procesado', 1126.11, 1325, 'Envio periodico a centro de fulfillment'),
(3, '2026-08-17', '2026-08-20', 'procesado', 1126.90, 1825, 'Envio periodico a centro de fulfillment'),
(4, '2026-09-04', '2026-09-07', 'procesado', 996.93, 2655, 'Envio periodico a centro de fulfillment'),
(5, '2026-06-18', NULL, 'en_camino', 636.23, 2120, 'Envio periodico a centro de fulfillment'),
(6, '2026-04-22', '2026-04-26', 'procesado', 590.34, 1145, 'Envio periodico a centro de fulfillment'),
(7, '2026-03-16', NULL, 'en_camino', 1012.66, 2495, 'Envio periodico a centro de fulfillment'),
(8, '2026-04-06', '2026-04-10', 'procesado', 500.91, 2912, 'Envio periodico a centro de fulfillment');

-- detalle_envios_full (39 filas)
INSERT INTO `detalle_envios_full` (`fk_envios_full_id`, `fk_catalogo_SKU`, `cantidad_enviada`, `cantidad_procesada`, `diferencia`) VALUES
(1, 26, 12, 12, 0),
(1, 21, 7, 7, 0),
(1, 48, 8, 8, 0),
(1, 46, 3, 3, 0),
(2, 56, 13, 13, 0),
(2, 51, 10, 10, 0),
(2, 38, 6, 6, 0),
(2, 4, 18, 18, 0),
(2, 13, 7, 7, 0),
(2, 40, 13, 13, 0),
(3, 17, 8, 8, 0),
(3, 24, 5, 5, 0),
(3, 22, 13, 13, 0),
(4, 2, 14, 14, 0),
(4, 18, 11, 11, 0),
(4, 15, 6, 6, 0),
(4, 17, 3, 3, 0),
(4, 46, 4, 4, 0),
(4, 6, 15, 15, 0),
(5, 48, 14, 0, 0),
(5, 28, 20, 0, 0),
(5, 12, 15, 0, 0),
(5, 57, 6, 0, 0),
(5, 33, 18, 0, 0),
(5, 26, 10, 0, 0),
(6, 30, 4, 4, 0),
(6, 6, 12, 12, 0),
(6, 53, 3, 3, 0),
(6, 56, 13, 13, 0),
(7, 8, 15, 0, 0),
(7, 6, 8, 0, 0),
(7, 23, 5, 0, 0),
(7, 12, 20, 0, 0),
(7, 58, 5, 0, 0),
(8, 40, 16, 16, 0),
(8, 41, 8, 8, 0),
(8, 32, 16, 16, 0),
(8, 47, 8, 8, 0),
(8, 3, 4, 4, 0);

-- retiros_full (10 filas)
INSERT INTO `retiros_full` (`id`, `id_retiro_ml`, `fk_catalogo_SKU`, `fecha_retiro`, `fecha_recepcion_deposito`, `cantidad`, `motivo`, `notas`) VALUES
(1, NULL, 8, '2026-07-02', '2026-07-08', 4, 'descatalogado', NULL),
(2, NULL, 46, '2026-05-06', '2026-05-13', 5, 'descatalogado', NULL),
(3, NULL, 17, '2026-08-31', '2026-09-03', 7, 'otro', NULL),
(4, NULL, 37, '2026-05-22', '2026-05-27', 1, 'descatalogado', NULL),
(5, NULL, 2, '2026-06-07', '2026-06-11', 5, 'otro', NULL),
(6, NULL, 42, '2026-04-24', '2026-05-04', 4, 'sin_ventas', NULL),
(7, NULL, 3, '2026-08-03', '2026-08-08', 5, 'sin_ventas', NULL),
(8, NULL, 32, '2026-08-26', '2026-09-02', 7, 'descatalogado', NULL),
(9, NULL, 33, '2026-04-08', '2026-04-15', 2, 'otro', NULL),
(10, NULL, 36, '2026-06-17', '2026-06-22', 6, 'descatalogado', NULL);

-- detalle_retiros_full (10 filas)
INSERT INTO `detalle_retiros_full` (`fk_retiros_full_id`, `fk_catalogo_SKU`, `cantidad_retirada`, `cantidad_reactivada`, `diferencias_stock`) VALUES
(1, 8, 4, 0, 0),
(2, 46, 5, NULL, 0),
(3, 17, 7, 0, 0),
(4, 37, 1, NULL, 0),
(5, 2, 5, 0, 0),
(6, 42, 4, 0, 0),
(7, 3, 5, 0, 0),
(8, 32, 7, 0, 0),
(9, 33, 2, NULL, 0),
(10, 36, 6, 0, 0);

-- catalogo_motivos_retiro (10 filas)
INSERT INTO `catalogo_motivos_retiro` (`fk_catalogo_SKU`, `fk_motivos_retiro_id`, `fecha_asignacion`) VALUES
(2, 3, '2026-09-21'),
(7, 1, '2026-06-24'),
(13, 3, '2026-07-05'),
(14, 1, '2026-09-18'),
(17, 3, '2026-08-15'),
(22, 3, '2026-08-07'),
(24, 3, '2026-08-30'),
(28, 3, '2026-09-21'),
(30, 2, '2026-06-16'),
(38, 3, '2026-08-06');

-- ventas (226 filas)
INSERT INTO `ventas` (`id`, `id_venta_ml`, `id_pedido_ml`, `fk_catalogo_SKU`, `fk_clientes_id`, `canal`, `estado`, `unidades`, `precio_unitario`, `comision_variable`, `comision_fija`, `costo_cuotas`, `costo_envio`, `impuestos`, `precio_neto`, `fecha_venta`, `fecha_concrecion`, `fecha_envio`, `notas`) VALUES
(1, NULL, NULL, 27, 29, 'Presencial', 'concretada', 1, 31201.60, 4056.21, 0.00, 0.00, 0.00, 1404.07, 25741.32, '2026-07-02 17:36:00', '2026-07-02', NULL, NULL),
(2, 'MLA-FICT-200002', 'MLA-FICT-200002', 12, 5, 'Full', 'concretada', 3, 64272.75, 25066.37, 0.00, 0.00, 1835.04, 8676.82, 157240.02, '2026-06-16 11:02:00', '2026-06-18', '2026-06-17 11:02:00', NULL),
(3, 'MLA-FICT-200003', 'MLA-FICT-200003', 37, 38, 'Deposito_ML', 'concretada', 2, 62814.94, 16331.88, 0.00, 10678.54, 247.54, 5653.34, 92718.58, '2026-07-25 22:17:00', '2026-07-26', '2026-07-25 22:17:00', NULL),
(4, 'MLA-FICT-200004', 'MLA-FICT-200004', 8, 3, 'Full', 'concretada', 1, 50455.74, 6559.25, 0.00, 4288.74, 581.10, 2270.51, 36756.14, '2026-07-24 10:50:00', '2026-07-27', '2026-07-26 10:50:00', NULL),
(5, 'MLA-FICT-200005', 'MLA-FICT-200005', 27, 2, 'Full', 'concretada', 1, 33455.28, 4349.19, 0.00, 0.00, 108.44, 1505.49, 27492.16, '2026-07-16 19:44:00', '2026-07-19', '2026-07-17 19:44:00', NULL),
(6, 'MLA-FICT-200006', 'MLA-FICT-200006', 52, 27, 'Full', 'concretada', 1, 55382.83, 7199.77, 0.00, 0.00, 295.65, 2492.23, 45395.18, '2026-08-21 22:31:00', '2026-08-24', '2026-08-22 22:31:00', NULL),
(7, 'MLA-FICT-200007', 'MLA-FICT-200007', 7, 33, 'Full', 'concretada', 1, 27276.46, 3545.94, 0.00, 0.00, 1133.59, 1227.44, 21369.49, '2026-08-07 22:26:00', '2026-08-08', '2026-08-07 22:26:00', NULL),
(8, NULL, NULL, 51, NULL, 'Presencial', 'concretada', 1, 25067.72, 3258.80, 0.00, 0.00, 0.00, 1128.05, 20680.87, '2026-07-29 18:01:00', '2026-07-30', NULL, NULL),
(9, NULL, NULL, 25, 39, 'Deposito_RRSS', 'concretada', 1, 85134.37, 11067.47, 0.00, 0.00, 0.00, 3831.05, 70235.85, '2026-09-01 14:52:00', '2026-09-02', NULL, NULL),
(10, 'MLA-FICT-200010', 'MLA-FICT-200010', 57, 37, 'Deposito_ML', 'concretada', 2, 96527.44, 25097.13, 0.00, 0.00, 627.15, 8687.47, 158643.13, '2026-07-21 14:22:00', '2026-07-24', '2026-07-21 14:22:00', NULL),
(11, NULL, NULL, 15, 42, 'Presencial', 'concretada', 1, 60966.73, 7925.67, 0.00, 0.00, 0.00, 2743.50, 50297.56, '2026-08-30 12:43:00', '2026-09-02', NULL, NULL),
(12, 'MLA-FICT-200012', 'MLA-FICT-200012', 53, 30, 'Full', 'en_camino', 1, 88032.80, 11444.26, 0.00, 3961.48, 932.37, 3961.48, 67733.21, '2026-08-30 18:51:00', NULL, '2026-08-31 18:51:00', NULL),
(13, 'MLA-FICT-200013', 'MLA-FICT-200013', 31, 31, 'Full', 'concretada', 1, 74974.55, 9746.69, 0.00, 3373.85, 1235.21, 3373.85, 57244.95, '2026-07-08 22:39:00', '2026-07-10', '2026-07-09 22:39:00', NULL),
(14, NULL, NULL, 19, 16, 'Deposito_RRSS', 'concretada', 2, 61193.30, 15910.26, 0.00, 0.00, 0.00, 5507.40, 100968.94, '2026-08-20 13:16:00', '2026-08-21', NULL, NULL),
(15, NULL, NULL, 53, 27, 'Presencial', 'concretada', 1, 88404.69, 11492.61, 0.00, 7514.40, 0.00, 3978.21, 65419.47, '2026-06-17 18:25:00', '2026-06-19', NULL, NULL),
(16, 'MLA-FICT-200016', 'MLA-FICT-200016', 49, 11, 'Full', 'concretada', 1, 47857.69, 6221.50, 0.00, 4067.90, 1994.36, 2153.60, 33420.33, '2026-07-21 18:52:00', '2026-07-23', '2026-07-23 18:52:00', NULL),
(17, 'MLA-FICT-200017', 'MLA-FICT-200017', 58, 23, 'Deposito_ML', 'concretada', 1, 83081.85, 10800.64, 0.00, 0.00, 2083.23, 3738.68, 66459.30, '2026-09-03 10:30:00', '2026-09-05', '2026-09-05 10:30:00', NULL),
(18, 'MLA-FICT-200018', 'MLA-FICT-200018', 57, 33, 'Full', 'concretada', 1, 99978.47, 12997.20, 0.00, 8498.17, 118.09, 4499.03, 73865.98, '2026-08-10 14:23:00', '2026-08-10', '2026-08-11 14:23:00', NULL),
(19, 'MLA-FICT-200019', 'MLA-FICT-200019', 45, 46, 'Deposito_ML', 'concretada', 1, 43758.95, 5688.66, 0.00, 0.00, 753.87, 1969.15, 35347.27, '2026-04-19 13:26:00', '2026-04-22', '2026-04-19 13:26:00', NULL),
(20, 'MLA-FICT-200020', 'MLA-FICT-200020', 7, 50, 'Deposito_ML', 'concretada', 1, 21839.48, 2839.13, 0.00, 0.00, 1267.81, 982.78, 16749.76, '2026-08-19 11:20:00', '2026-08-20', '2026-08-20 11:20:00', NULL),
(21, 'MLA-FICT-200021', 'MLA-FICT-200021', 41, 49, 'Deposito_ML', 'cancelada', 1, 35136.05, 4567.69, 0.00, 0.00, 1607.45, 1581.12, 27379.79, '2026-07-14 15:27:00', NULL, '2026-07-14 15:27:00', NULL),
(22, 'MLA-FICT-200022', 'MLA-FICT-200022', 14, 11, 'Full', 'concretada', 1, 70061.30, 9107.97, 0.00, 3152.76, 283.65, 3152.76, 54364.16, '2026-04-09 09:40:00', '2026-04-12', '2026-04-11 09:40:00', NULL),
(23, 'MLA-FICT-200023', 'MLA-FICT-200023', 4, 11, 'Full', 'concretada', 1, 38422.05, 4994.87, 0.00, 0.00, 754.01, 1728.99, 30944.18, '2026-05-11 16:46:00', '2026-05-14', '2026-05-12 16:46:00', NULL),
(24, 'MLA-FICT-200024', 'MLA-FICT-200024', 53, 3, 'Deposito_ML', 'devuelta', 1, 66575.96, 8654.87, 0.00, 0.00, 270.96, 2995.92, 54654.21, '2026-09-21 12:46:00', NULL, '2026-09-23 12:46:00', NULL),
(25, 'MLA-FICT-200025', 'MLA-FICT-200025', 42, 8, 'Full', 'concretada', 1, 42302.86, 5499.37, 0.00, 0.00, 106.12, 1903.63, 34793.74, '2026-06-23 18:03:00', '2026-06-23', '2026-06-24 18:03:00', NULL),
(26, NULL, NULL, 32, 7, 'Deposito_RRSS', 'concretada', 1, 80404.95, 10452.64, 0.00, 3618.22, 0.00, 3618.22, 62715.87, '2026-09-06 20:43:00', '2026-09-07', NULL, NULL),
(27, 'MLA-FICT-200027', 'MLA-FICT-200027', 41, 36, 'Full', 'concretada', 1, 47239.76, 6141.17, 0.00, 0.00, 787.43, 2125.79, 38185.37, '2026-08-24 21:06:00', '2026-08-27', '2026-08-25 21:06:00', NULL),
(28, NULL, NULL, 15, 50, 'Deposito_RRSS', 'concretada', 1, 70110.35, 9114.35, 0.00, 5959.38, 0.00, 3154.97, 51881.65, '2026-05-16 14:15:00', '2026-05-17', NULL, NULL),
(29, NULL, NULL, 48, 12, 'Deposito_RRSS', 'concretada', 3, 30780.49, 12004.39, 0.00, 7849.02, 0.00, 4155.37, 68332.69, '2026-09-10 13:41:00', '2026-09-10', NULL, NULL),
(30, 'MLA-FICT-200030', 'MLA-FICT-200030', 56, 22, 'Full', 'concretada', 1, 26938.49, 3502.00, 0.00, 0.00, 21.28, 1212.23, 22202.98, '2026-08-16 19:20:00', '2026-08-17', '2026-08-18 19:20:00', NULL),
(31, 'MLA-FICT-200031', 'MLA-FICT-200031', 30, 31, 'Deposito_ML', 'concretada', 1, 75187.95, 9774.43, 0.00, 6390.98, 2117.08, 3383.46, 53522.00, '2026-05-05 20:05:00', '2026-05-07', '2026-05-06 20:05:00', NULL),
(32, NULL, NULL, 43, 31, 'Presencial', 'concretada', 3, 28216.38, 11004.39, 0.00, 0.00, 0.00, 3809.21, 69835.54, '2026-09-04 11:44:00', '2026-09-07', NULL, NULL),
(33, 'MLA-FICT-200033', 'MLA-FICT-200033', 45, 29, 'Deposito_ML', 'concretada', 1, 57872.70, 7523.45, 0.00, 0.00, 1062.78, 2604.27, 46682.20, '2026-05-11 18:24:00', '2026-05-14', '2026-05-11 18:24:00', NULL),
(34, NULL, NULL, 18, 45, 'Deposito_RRSS', 'concretada', 1, 92714.82, 12052.93, 0.00, 0.00, 0.00, 4172.17, 76489.72, '2026-08-21 20:55:00', '2026-08-23', NULL, NULL),
(35, 'MLA-FICT-200035', 'MLA-FICT-200035', 8, 32, 'Deposito_ML', 'concretada', 1, 51298.54, 6668.81, 0.00, 0.00, 25.62, 2308.43, 42295.68, '2026-07-10 12:30:00', '2026-07-11', '2026-07-12 12:30:00', NULL),
(36, NULL, NULL, 6, 16, 'Presencial', 'cancelada', 1, 67852.48, 8820.82, 0.00, 5767.46, 0.00, 3053.36, 50210.84, '2026-08-01 12:21:00', NULL, NULL, NULL),
(37, NULL, NULL, 30, 27, 'Presencial', 'concretada', 1, 75352.68, 9795.85, 0.00, 6404.98, 0.00, 3390.87, 55760.98, '2026-04-16 16:05:00', '2026-04-16', NULL, NULL),
(38, 'MLA-FICT-200038', 'MLA-FICT-200038', 37, 24, 'Full', 'cancelada', 1, 88779.75, 11541.37, 0.00, 0.00, 1440.11, 3995.09, 71803.18, '2026-06-12 21:38:00', NULL, '2026-06-13 21:38:00', NULL),
(39, 'MLA-FICT-200039', 'MLA-FICT-200039', 54, 15, 'Full', 'concretada', 1, 51093.26, 6642.12, 0.00, 2299.20, 1575.01, 2299.20, 38277.73, '2026-06-08 14:35:00', '2026-06-08', '2026-06-08 14:35:00', NULL),
(40, 'MLA-FICT-200040', 'MLA-FICT-200040', 1, 13, 'Full', 'concretada', 1, 35922.42, 4669.91, 0.00, 0.00, 1083.33, 1616.51, 28552.67, '2026-06-11 21:18:00', '2026-06-14', '2026-06-11 21:18:00', NULL),
(41, 'MLA-FICT-200041', 'MLA-FICT-200041', 56, 38, 'Deposito_ML', 'concretada', 1, 26082.81, 3390.77, 0.00, 0.00, 2038.58, 1173.73, 19479.73, '2026-08-31 22:50:00', '2026-08-31', '2026-09-01 22:50:00', NULL),
(42, 'MLA-FICT-200042', 'MLA-FICT-200042', 10, 7, 'Deposito_ML', 'concretada', 1, 80689.59, 10489.65, 0.00, 0.00, 1522.00, 3631.03, 65046.91, '2026-09-26 20:03:00', '2026-09-27', '2026-09-28 20:03:00', NULL),
(43, 'MLA-FICT-200043', 'MLA-FICT-200043', 40, 9, 'Deposito_ML', 'concretada', 3, 25009.25, 9753.61, 0.00, 0.00, 601.91, 3376.25, 61295.98, '2026-05-31 17:56:00', '2026-06-02', '2026-06-01 17:56:00', NULL),
(44, NULL, NULL, 40, 46, 'Deposito_RRSS', 'concretada', 1, 20035.53, 2604.62, 0.00, 0.00, 0.00, 901.60, 16529.31, '2026-05-30 17:19:00', '2026-05-31', NULL, NULL),
(45, NULL, NULL, 24, 49, 'Deposito_RRSS', 'cancelada', 1, 83024.86, 10793.23, 0.00, 3736.12, 0.00, 3736.12, 64759.39, '2026-09-08 20:41:00', NULL, NULL, NULL),
(46, 'MLA-FICT-200046', 'MLA-FICT-200046', 32, 2, 'Deposito_ML', 'concretada', 1, 85616.61, 11130.16, 0.00, 3852.75, 1930.45, 3852.75, 64850.50, '2026-07-23 19:45:00', '2026-07-26', '2026-07-23 19:45:00', NULL),
(47, NULL, NULL, 5, 19, 'Deposito_RRSS', 'concretada', 3, 73459.62, 28649.25, 0.00, 0.00, 0.00, 9917.05, 181812.56, '2026-09-15 13:48:00', '2026-09-15', NULL, NULL),
(48, 'MLA-FICT-200048', 'MLA-FICT-200048', 36, 45, 'Full', 'concretada', 1, 51068.12, 6638.86, 0.00, 0.00, 1633.31, 2298.07, 40497.88, '2026-08-16 16:06:00', '2026-08-19', '2026-08-16 16:06:00', NULL),
(49, 'MLA-FICT-200049', 'MLA-FICT-200049', 44, 50, 'Full', 'cancelada', 3, 53793.04, 20979.29, 0.00, 0.00, 28.52, 7262.06, 133109.25, '2026-05-19 15:26:00', NULL, '2026-05-20 15:26:00', NULL),
(50, NULL, NULL, 30, 12, 'Presencial', 'concretada', 1, 91224.62, 11859.20, 0.00, 0.00, 0.00, 4105.11, 75260.31, '2026-05-08 19:45:00', '2026-05-09', NULL, NULL),
(51, 'MLA-FICT-200051', 'MLA-FICT-200051', 6, 46, 'Full', 'concretada', 1, 69492.40, 9034.01, 0.00, 3127.16, 286.15, 3127.16, 53917.92, '2026-05-05 20:32:00', '2026-05-07', '2026-05-05 20:32:00', NULL),
(52, 'MLA-FICT-200052', 'MLA-FICT-200052', 4, 21, 'Full', 'concretada', 1, 44604.46, 5798.58, 0.00, 2007.20, 1079.21, 2007.20, 33712.27, '2026-05-18 18:03:00', '2026-05-20', '2026-05-18 18:03:00', NULL),
(53, 'MLA-FICT-200053', 'MLA-FICT-200053', 13, 14, 'Deposito_ML', 'concretada', 1, 47467.06, 6170.72, 0.00, 0.00, 1943.47, 2136.02, 37216.85, '2026-09-14 17:10:00', '2026-09-16', '2026-09-15 17:10:00', NULL),
(54, 'MLA-FICT-200054', 'MLA-FICT-200054', 41, 21, 'Deposito_ML', 'concretada', 1, 36395.04, 4731.36, 0.00, 1637.78, 980.47, 1637.78, 27407.65, '2026-08-03 17:52:00', '2026-08-04', '2026-08-03 17:52:00', NULL),
(55, 'MLA-FICT-200055', 'MLA-FICT-200055', 52, NULL, 'Full', 'concretada', 2, 52681.81, 13697.27, 0.00, 4741.36, 1131.48, 4741.36, 81052.15, '2026-08-13 17:46:00', '2026-08-16', '2026-08-14 17:46:00', NULL),
(56, 'MLA-FICT-200056', 'MLA-FICT-200056', 14, 14, 'Full', 'concretada', 2, 62112.59, 16149.27, 0.00, 0.00, 1379.25, 5590.13, 101106.53, '2026-04-20 10:06:00', '2026-04-21', '2026-04-22 10:06:00', NULL),
(57, NULL, NULL, 29, NULL, 'Presencial', 'concretada', 3, 30954.03, 12072.07, 0.00, 0.00, 0.00, 4178.79, 76611.23, '2026-09-10 17:53:00', '2026-09-11', NULL, NULL),
(58, 'MLA-FICT-200058', 'MLA-FICT-200058', 4, 21, 'Full', 'concretada', 1, 44279.54, 5756.34, 0.00, 1992.58, 896.79, 1992.58, 33641.25, '2026-09-13 11:50:00', '2026-09-16', '2026-09-15 11:50:00', NULL),
(59, NULL, NULL, 1, 33, 'Deposito_RRSS', 'concretada', 1, 46284.41, 6016.97, 0.00, 0.00, 0.00, 2082.80, 38184.64, '2026-09-09 09:41:00', '2026-09-09', NULL, NULL),
(60, NULL, NULL, 52, 15, 'Deposito_RRSS', 'concretada', 1, 45012.79, 5851.66, 0.00, 0.00, 0.00, 2025.58, 37135.55, '2026-08-22 10:18:00', '2026-08-25', NULL, NULL),
(61, NULL, NULL, 27, 1, 'Presencial', 'cancelada', 1, 31198.85, 4055.85, 0.00, 1403.95, 0.00, 1403.95, 24335.10, '2026-06-18 17:18:00', NULL, NULL, NULL),
(62, 'MLA-FICT-200062', 'MLA-FICT-200062', 37, 42, 'Full', 'concretada', 1, 90461.99, 11760.06, 0.00, 4070.79, 462.12, 4070.79, 70098.23, '2026-09-08 09:36:00', '2026-09-10', '2026-09-08 09:36:00', NULL),
(63, 'MLA-FICT-200063', 'MLA-FICT-200063', 11, 19, 'Full', 'concretada', 1, 54774.88, 7120.73, 0.00, 0.00, 1873.05, 2464.87, 43316.23, '2026-09-03 18:53:00', '2026-09-06', '2026-09-05 18:53:00', NULL),
(64, 'MLA-FICT-200064', 'MLA-FICT-200064', 18, 13, 'Full', 'en_camino', 1, 95979.67, 12477.36, 0.00, 0.00, 220.10, 4319.09, 78963.12, '2026-09-02 18:31:00', NULL, '2026-09-04 18:31:00', NULL),
(65, 'MLA-FICT-200065', 'MLA-FICT-200065', 30, 15, 'Full', 'concretada', 1, 90497.28, 11764.65, 0.00, 4072.38, 2109.05, 4072.38, 68478.82, '2026-04-13 19:19:00', '2026-04-14', '2026-04-13 19:19:00', NULL),
(66, 'MLA-FICT-200066', 'MLA-FICT-200066', 43, 12, 'Deposito_ML', 'concretada', 1, 24737.42, 3215.86, 0.00, 2102.68, 789.23, 1113.18, 17516.47, '2026-08-25 14:08:00', '2026-08-27', '2026-08-26 14:08:00', NULL),
(67, NULL, NULL, 7, 33, 'Presencial', 'concretada', 1, 26052.50, 3386.83, 0.00, 0.00, 0.00, 1172.36, 21493.31, '2026-08-24 22:08:00', '2026-08-24', NULL, NULL),
(68, 'MLA-FICT-200068', 'MLA-FICT-200068', 54, 50, 'Deposito_ML', 'concretada', 1, 42853.32, 5570.93, 0.00, 3642.53, 1438.60, 1928.40, 30272.86, '2026-07-22 21:37:00', '2026-07-23', '2026-07-23 21:37:00', NULL),
(69, 'MLA-FICT-200069', 'MLA-FICT-200069', 56, 11, 'Full', 'concretada', 1, 19293.92, 2508.21, 0.00, 0.00, 1865.56, 868.23, 14051.92, '2026-09-07 17:32:00', '2026-09-08', '2026-09-09 17:32:00', NULL),
(70, NULL, NULL, 38, 24, 'Deposito_RRSS', 'concretada', 2, 35203.35, 9152.87, 0.00, 5984.57, 0.00, 3168.30, 52100.96, '2026-03-28 11:47:00', '2026-03-29', NULL, NULL),
(71, 'MLA-FICT-200071', 'MLA-FICT-200071', 44, 34, 'Full', 'concretada', 2, 66419.16, 17268.98, 0.00, 0.00, 2157.30, 5977.72, 107434.32, '2026-07-29 21:23:00', '2026-07-31', '2026-07-29 21:23:00', NULL),
(72, NULL, NULL, 19, 15, 'Presencial', 'concretada', 1, 55147.29, 7169.15, 0.00, 0.00, 0.00, 2481.63, 45496.51, '2026-06-28 18:34:00', '2026-06-30', NULL, NULL),
(73, NULL, NULL, 24, 5, 'Presencial', 'concretada', 1, 81752.87, 10627.87, 0.00, 0.00, 0.00, 3678.88, 67446.12, '2026-06-03 16:50:00', '2026-06-06', NULL, NULL),
(74, 'MLA-FICT-200074', 'MLA-FICT-200074', 19, 31, 'Full', 'concretada', 1, 61406.91, 7982.90, 0.00, 5219.59, 1784.58, 2763.31, 43656.53, '2026-09-06 11:23:00', '2026-09-06', '2026-09-07 11:23:00', NULL),
(75, NULL, NULL, 12, 17, 'Deposito_RRSS', 'concretada', 1, 57350.44, 7455.56, 0.00, 0.00, 0.00, 2580.77, 47314.11, '2026-06-11 09:15:00', '2026-06-12', NULL, NULL),
(76, 'MLA-FICT-200076', 'MLA-FICT-200076', 35, 31, 'Deposito_ML', 'concretada', 1, 55761.03, 7248.93, 0.00, 2509.25, 2083.96, 2509.25, 41409.64, '2026-07-19 18:40:00', '2026-07-20', '2026-07-20 18:40:00', NULL),
(77, 'MLA-FICT-200077', 'MLA-FICT-200077', 12, 5, 'Full', 'concretada', 1, 57874.28, 7523.66, 0.00, 2604.34, 368.99, 2604.34, 44772.95, '2026-06-11 18:09:00', '2026-06-13', '2026-06-12 18:09:00', NULL),
(78, 'MLA-FICT-200078', 'MLA-FICT-200078', 26, 39, 'Full', 'concretada', 1, 75577.92, 9825.13, 0.00, 0.00, 1332.12, 3401.01, 61019.66, '2026-09-10 12:33:00', '2026-09-11', '2026-09-11 12:33:00', NULL),
(79, 'MLA-FICT-200079', 'MLA-FICT-200079', 52, 3, 'Deposito_ML', 'concretada', 1, 48755.05, 6338.16, 0.00, 0.00, 1973.33, 2193.98, 38249.58, '2026-07-31 10:05:00', '2026-08-03', '2026-08-02 10:05:00', NULL),
(80, 'MLA-FICT-200080', 'MLA-FICT-200080', 29, 6, 'Full', 'concretada', 1, 31269.48, 4065.03, 0.00, 0.00, 936.08, 1407.13, 24861.24, '2026-05-15 16:50:00', '2026-05-17', '2026-05-16 16:50:00', NULL),
(81, 'MLA-FICT-200081', 'MLA-FICT-200081', 58, 21, 'Deposito_ML', 'concretada', 1, 76526.36, 9948.43, 0.00, 0.00, 1143.48, 3443.69, 61990.76, '2026-08-11 12:00:00', '2026-08-14', '2026-08-13 12:00:00', NULL),
(82, 'MLA-FICT-200082', 'MLA-FICT-200082', 8, 36, 'Full', 'concretada', 1, 54993.73, 7149.18, 0.00, 2474.72, 2181.96, 2474.72, 40713.15, '2026-08-09 18:16:00', '2026-08-12', '2026-08-09 18:16:00', NULL),
(83, 'MLA-FICT-200083', 'MLA-FICT-200083', 25, 45, 'Deposito_ML', 'concretada', 1, 70405.28, 9152.69, 0.00, 0.00, 1881.00, 3168.24, 56203.35, '2026-07-25 13:19:00', '2026-07-25', '2026-07-27 13:19:00', NULL),
(84, 'MLA-FICT-200084', 'MLA-FICT-200084', 8, 31, 'Full', 'concretada', 1, 57457.84, 7469.52, 0.00, 0.00, 353.62, 2585.60, 47049.10, '2026-07-30 21:21:00', '2026-07-30', '2026-07-30 21:21:00', NULL),
(85, 'MLA-FICT-200085', 'MLA-FICT-200085', 29, 4, 'Full', 'concretada', 1, 26762.07, 3479.07, 0.00, 2274.78, 1350.72, 1204.29, 18453.21, '2026-09-14 12:23:00', '2026-09-16', '2026-09-16 12:23:00', NULL),
(86, 'MLA-FICT-200086', 'MLA-FICT-200086', 54, 3, 'Full', 'concretada', 1, 52669.77, 6847.07, 0.00, 2370.14, 428.44, 2370.14, 40653.98, '2026-07-13 16:00:00', '2026-07-14', '2026-07-15 16:00:00', NULL),
(87, 'MLA-FICT-200087', 'MLA-FICT-200087', 43, 47, 'Full', 'concretada', 1, 23927.71, 3110.60, 0.00, 0.00, 1139.03, 1076.75, 18601.33, '2026-04-29 10:17:00', '2026-04-29', '2026-04-29 10:17:00', NULL),
(88, 'MLA-FICT-200088', 'MLA-FICT-200088', 39, 7, 'Full', 'concretada', 2, 86958.36, 22609.17, 0.00, 14782.92, 1264.79, 7826.25, 127433.59, '2026-04-30 22:17:00', '2026-05-02', '2026-04-30 22:17:00', NULL),
(89, 'MLA-FICT-200089', 'MLA-FICT-200089', 34, 16, 'Full', 'concretada', 1, 55816.85, 7256.19, 0.00, 2511.76, 1527.22, 2511.76, 42009.92, '2026-08-18 10:51:00', '2026-08-21', '2026-08-20 10:51:00', NULL),
(90, 'MLA-FICT-200090', 'MLA-FICT-200090', 51, 23, 'Deposito_ML', 'concretada', 1, 23623.70, 3071.08, 0.00, 0.00, 1489.21, 1063.07, 18000.34, '2026-07-07 18:55:00', '2026-07-08', '2026-07-08 18:55:00', NULL),
(91, NULL, NULL, 2, 23, 'Deposito_RRSS', 'concretada', 1, 72582.15, 9435.68, 0.00, 0.00, 0.00, 3266.20, 59880.27, '2026-06-11 12:18:00', '2026-06-12', NULL, NULL),
(92, 'MLA-FICT-200092', 'MLA-FICT-200092', 38, 13, 'Full', 'en_camino', 1, 46602.63, 6058.34, 0.00, 0.00, 1617.94, 2097.12, 36829.23, '2026-05-11 20:43:00', NULL, '2026-05-12 20:43:00', NULL),
(93, 'MLA-FICT-200093', 'MLA-FICT-200093', 55, 21, 'Deposito_ML', 'concretada', 1, 54254.52, 7053.09, 0.00, 4611.63, 1350.42, 2441.45, 38797.93, '2026-08-17 21:06:00', '2026-08-17', '2026-08-18 21:06:00', NULL),
(94, 'MLA-FICT-200094', 'MLA-FICT-200094', 58, 28, 'Deposito_ML', 'devuelta', 2, 68053.83, 17694.00, 0.00, 0.00, 1650.37, 6124.84, 110638.45, '2026-06-03 16:11:00', NULL, '2026-06-03 16:11:00', NULL),
(95, 'MLA-FICT-200095', 'MLA-FICT-200095', 36, 25, 'Full', 'concretada', 1, 58989.57, 7668.64, 0.00, 5014.11, 694.43, 2654.53, 42957.86, '2026-07-31 15:55:00', '2026-07-31', '2026-07-31 15:55:00', NULL),
(96, 'MLA-FICT-200096', 'MLA-FICT-200096', 22, 45, 'Full', 'concretada', 1, 71846.01, 9339.98, 0.00, 3233.07, 805.03, 3233.07, 55234.86, '2026-07-17 13:11:00', '2026-07-20', '2026-07-18 13:11:00', NULL),
(97, NULL, NULL, 25, 36, 'Presencial', 'concretada', 3, 78482.80, 30608.29, 0.00, 0.00, 0.00, 10595.18, 194244.93, '2026-08-12 16:11:00', '2026-08-14', NULL, NULL),
(98, 'MLA-FICT-200098', 'MLA-FICT-200098', 26, 36, 'Full', 'concretada', 1, 75629.45, 9831.83, 0.00, 0.00, 2190.24, 3403.33, 60204.05, '2026-09-06 20:09:00', '2026-09-08', '2026-09-07 20:09:00', NULL),
(99, 'MLA-FICT-200099', 'MLA-FICT-200099', 5, 36, 'Deposito_ML', 'concretada', 1, 77549.42, 10081.42, 0.00, 0.00, 989.68, 3489.72, 62988.60, '2026-09-11 11:03:00', '2026-09-13', '2026-09-12 11:03:00', NULL),
(100, 'MLA-FICT-200100', 'MLA-FICT-200100', 53, 33, 'Full', 'concretada', 1, 84793.24, 11023.12, 0.00, 0.00, 2154.62, 3815.70, 67799.80, '2026-08-18 15:07:00', '2026-08-20', '2026-08-19 15:07:00', NULL),
(101, 'MLA-FICT-200101', 'MLA-FICT-200101', 49, 37, 'Deposito_ML', 'concretada', 1, 46267.92, 6014.83, 0.00, 0.00, 1409.28, 2082.06, 36761.75, '2026-05-29 15:39:00', '2026-05-31', '2026-05-30 15:39:00', NULL),
(102, 'MLA-FICT-200102', 'MLA-FICT-200102', 6, 34, 'Full', 'concretada', 1, 69153.99, 8990.02, 0.00, 5878.09, 596.75, 3111.93, 50577.20, '2026-09-05 12:20:00', '2026-09-08', '2026-09-06 12:20:00', NULL),
(103, 'MLA-FICT-200103', 'MLA-FICT-200103', 28, 31, 'Full', 'concretada', 1, 45345.11, 5894.86, 0.00, 0.00, 463.26, 2040.53, 36946.46, '2026-05-11 22:01:00', '2026-05-14', '2026-05-11 22:01:00', NULL),
(104, NULL, NULL, 3, 48, 'Presencial', 'concretada', 1, 62832.99, 8168.29, 0.00, 5340.80, 0.00, 2827.48, 46496.42, '2026-08-12 21:05:00', '2026-08-14', NULL, NULL),
(105, 'MLA-FICT-200105', 'MLA-FICT-200105', 42, 36, 'Full', 'concretada', 1, 56642.35, 7363.51, 0.00, 2548.91, 1901.33, 2548.91, 42279.69, '2026-09-08 22:10:00', '2026-09-11', '2026-09-10 22:10:00', NULL),
(106, 'MLA-FICT-200106', 'MLA-FICT-200106', 46, 6, 'Deposito_ML', 'concretada', 1, 38887.33, 5055.35, 0.00, 1749.93, 1999.63, 1749.93, 28332.49, '2026-09-03 18:29:00', '2026-09-06', '2026-09-05 18:29:00', NULL),
(107, 'MLA-FICT-200107', 'MLA-FICT-200107', 25, 49, 'Deposito_ML', 'concretada', 1, 83026.42, 10793.43, 0.00, 3736.19, 630.88, 3736.19, 64129.73, '2026-08-27 13:00:00', '2026-08-27', '2026-08-29 13:00:00', NULL),
(108, NULL, NULL, 2, 11, 'Presencial', 'concretada', 1, 61506.63, 7995.86, 0.00, 5228.06, 0.00, 2767.80, 45514.91, '2026-08-09 13:38:00', '2026-08-12', NULL, NULL),
(109, 'MLA-FICT-200109', 'MLA-FICT-200109', 43, 5, 'Deposito_ML', 'concretada', 1, 25087.38, 3261.36, 0.00, 1128.93, 626.29, 1128.93, 18941.87, '2026-06-12 12:16:00', '2026-06-14', '2026-06-13 12:16:00', NULL),
(110, 'MLA-FICT-200110', 'MLA-FICT-200110', 20, 19, 'Full', 'concretada', 1, 73441.60, 9547.41, 0.00, 0.00, 334.73, 3304.87, 60254.59, '2026-07-14 18:28:00', '2026-07-14', '2026-07-14 18:28:00', NULL),
(111, 'MLA-FICT-200111', 'MLA-FICT-200111', 47, 3, 'Deposito_ML', 'concretada', 1, 78683.20, 10228.82, 0.00, 3540.74, 1728.60, 3540.74, 59644.30, '2026-06-30 12:05:00', '2026-07-03', '2026-07-01 12:05:00', NULL),
(112, NULL, NULL, 55, 1, 'Presencial', 'concretada', 1, 45663.48, 5936.25, 0.00, 0.00, 0.00, 2054.86, 37672.37, '2026-05-10 09:17:00', '2026-05-12', NULL, NULL),
(113, NULL, NULL, 51, 44, 'Deposito_RRSS', 'concretada', 3, 25050.95, 9769.87, 0.00, 0.00, 0.00, 3381.88, 62001.10, '2026-08-28 21:28:00', '2026-08-29', NULL, NULL),
(114, 'MLA-FICT-200114', 'MLA-FICT-200114', 22, 14, 'Full', 'en_camino', 1, 65780.16, 8551.42, 0.00, 2960.11, 437.19, 2960.11, 50871.33, '2026-07-15 09:47:00', NULL, '2026-07-15 09:47:00', NULL),
(115, NULL, NULL, 17, 38, 'Deposito_RRSS', 'concretada', 1, 66251.86, 8612.74, 0.00, 0.00, 0.00, 2981.33, 54657.79, '2026-08-08 09:10:00', '2026-08-08', NULL, NULL),
(116, NULL, NULL, 32, 42, 'Deposito_RRSS', 'concretada', 1, 63868.46, 8302.90, 0.00, 2874.08, 0.00, 2874.08, 49817.40, '2026-07-19 14:49:00', '2026-07-19', NULL, NULL),
(117, NULL, NULL, 36, 2, 'Presencial', 'concretada', 1, 52649.29, 6844.41, 0.00, 2369.22, 0.00, 2369.22, 41066.44, '2026-09-10 16:14:00', '2026-09-13', NULL, NULL),
(118, NULL, NULL, 24, 35, 'Deposito_RRSS', 'concretada', 1, 83032.45, 10794.22, 0.00, 7057.76, 0.00, 3736.46, 61444.01, '2026-09-07 09:31:00', '2026-09-08', NULL, NULL),
(119, 'MLA-FICT-200119', 'MLA-FICT-200119', 48, 30, 'Deposito_ML', 'en_camino', 1, 27875.94, 3623.87, 0.00, 0.00, 988.65, 1254.42, 22009.00, '2026-08-25 22:38:00', NULL, '2026-08-26 22:38:00', NULL),
(120, NULL, NULL, 1, 43, 'Deposito_RRSS', 'concretada', 1, 40098.02, 5212.74, 0.00, 0.00, 0.00, 1804.41, 33080.87, '2026-07-31 20:11:00', '2026-08-02', NULL, NULL),
(121, 'MLA-FICT-200121', 'MLA-FICT-200121', 54, 5, 'Deposito_ML', 'concretada', 1, 43260.09, 5623.81, 0.00, 3677.11, 1409.99, 1946.70, 30602.48, '2026-09-02 19:31:00', '2026-09-02', '2026-09-02 19:31:00', NULL),
(122, 'MLA-FICT-200122', 'MLA-FICT-200122', 10, 39, 'Full', 'concretada', 1, 80267.37, 10434.76, 0.00, 6822.73, 1447.43, 3612.03, 57950.42, '2026-06-02 12:06:00', '2026-06-04', '2026-06-02 12:06:00', NULL),
(123, 'MLA-FICT-200123', 'MLA-FICT-200123', 2, 3, 'Full', 'concretada', 1, 61191.82, 7954.94, 0.00, 5201.30, 1808.46, 2753.63, 43473.49, '2026-07-11 22:05:00', '2026-07-11', '2026-07-13 22:05:00', NULL),
(124, 'MLA-FICT-200124', 'MLA-FICT-200124', 55, 12, 'Full', 'concretada', 1, 46751.70, 6077.72, 0.00, 0.00, 424.86, 2103.83, 38145.29, '2026-09-13 12:33:00', '2026-09-14', '2026-09-15 12:33:00', NULL),
(125, 'MLA-FICT-200125', 'MLA-FICT-200125', 37, 33, 'Deposito_ML', 'concretada', 1, 83231.48, 10820.09, 0.00, 7074.68, 1942.21, 3745.42, 59649.08, '2026-06-27 21:40:00', '2026-06-28', '2026-06-27 21:40:00', NULL),
(126, 'MLA-FICT-200126', 'MLA-FICT-200126', 12, 47, 'Deposito_ML', 'concretada', 1, 78307.73, 10180.00, 0.00, 3523.85, 1858.68, 3523.85, 59221.35, '2026-04-09 16:59:00', '2026-04-12', '2026-04-11 16:59:00', NULL),
(127, 'MLA-FICT-200127', 'MLA-FICT-200127', 17, 19, 'Deposito_ML', 'concretada', 1, 65305.76, 8489.75, 0.00, 5550.99, 984.50, 2938.76, 47341.76, '2026-07-26 15:49:00', '2026-07-29', '2026-07-26 15:49:00', NULL),
(128, 'MLA-FICT-200128', 'MLA-FICT-200128', 35, 37, 'Full', 'concretada', 1, 59661.80, 7756.03, 0.00, 0.00, 1697.35, 2684.78, 47523.64, '2026-04-16 13:00:00', '2026-04-18', '2026-04-18 13:00:00', NULL),
(129, 'MLA-FICT-200129', 'MLA-FICT-200129', 11, 37, 'Full', 'concretada', 1, 53026.11, 6893.39, 0.00, 0.00, 563.74, 2386.17, 43182.81, '2026-09-18 14:09:00', '2026-09-20', '2026-09-18 14:09:00', NULL),
(130, 'MLA-FICT-200130', 'MLA-FICT-200130', 48, 37, 'Full', 'concretada', 1, 35813.19, 4655.71, 0.00, 0.00, 1309.51, 1611.59, 28236.38, '2026-07-01 21:30:00', '2026-07-03', '2026-07-01 21:30:00', NULL),
(131, 'MLA-FICT-200131', 'MLA-FICT-200131', 51, 39, 'Full', 'concretada', 1, 32978.04, 4287.15, 0.00, 0.00, 1913.53, 1484.01, 25293.35, '2026-05-20 14:22:00', '2026-05-21', '2026-05-22 14:22:00', NULL),
(132, NULL, NULL, 42, 44, 'Presencial', 'concretada', 1, 51010.37, 6631.35, 0.00, 2295.47, 0.00, 2295.47, 39788.08, '2026-07-14 09:19:00', '2026-07-15', NULL, NULL),
(133, 'MLA-FICT-200133', 'MLA-FICT-200133', 27, 4, 'Deposito_ML', 'concretada', 1, 32419.32, 4214.51, 0.00, 0.00, 290.82, 1458.87, 26455.12, '2026-06-26 18:32:00', '2026-06-26', '2026-06-27 18:32:00', NULL),
(134, 'MLA-FICT-200134', 'MLA-FICT-200134', 18, 48, 'Full', 'concretada', 1, 89412.72, 11623.65, 0.00, 0.00, 1073.29, 4023.57, 72692.21, '2026-08-12 15:49:00', '2026-08-13', '2026-08-14 15:49:00', NULL),
(135, 'MLA-FICT-200135', 'MLA-FICT-200135', 17, 39, 'Full', 'concretada', 1, 58765.49, 7639.51, 0.00, 4995.07, 931.79, 2644.45, 42554.67, '2026-08-26 15:20:00', '2026-08-28', '2026-08-26 15:20:00', NULL),
(136, 'MLA-FICT-200136', 'MLA-FICT-200136', 51, 10, 'Full', 'concretada', 1, 29648.49, 3854.30, 0.00, 2520.12, 98.73, 1334.18, 21841.16, '2026-09-04 14:39:00', '2026-09-05', '2026-09-04 14:39:00', NULL),
(137, 'MLA-FICT-200137', 'MLA-FICT-200137', 56, 20, 'Full', 'en_camino', 2, 27097.69, 7045.40, 0.00, 2438.79, 30.21, 2438.79, 42242.19, '2026-09-09 09:15:00', NULL, '2026-09-11 09:15:00', NULL),
(138, 'MLA-FICT-200138', 'MLA-FICT-200138', 3, 2, 'Full', 'concretada', 1, 67822.79, 8816.96, 0.00, 5764.94, 1370.69, 3052.03, 48818.17, '2026-08-31 17:13:00', '2026-09-01', '2026-09-02 17:13:00', NULL),
(139, 'MLA-FICT-200139', 'MLA-FICT-200139', 44, 18, 'Deposito_ML', 'concretada', 1, 60569.11, 7873.98, 0.00, 0.00, 1022.91, 2725.61, 48946.61, '2026-09-17 11:03:00', '2026-09-17', '2026-09-17 11:03:00', NULL),
(140, 'MLA-FICT-200140', 'MLA-FICT-200140', 44, 39, 'Full', 'concretada', 1, 51984.56, 6757.99, 0.00, 4418.69, 1118.79, 2339.31, 37349.78, '2026-06-04 09:18:00', '2026-06-04', '2026-06-05 09:18:00', NULL),
(141, 'MLA-FICT-200141', 'MLA-FICT-200141', 13, 2, 'Full', 'en_camino', 1, 50816.31, 6606.12, 0.00, 2286.73, 733.85, 2286.73, 38902.88, '2026-07-31 16:35:00', NULL, '2026-08-01 16:35:00', NULL),
(142, 'MLA-FICT-200142', 'MLA-FICT-200142', 24, 15, 'Full', 'concretada', 1, 74113.77, 9634.79, 0.00, 6299.67, 1958.88, 3335.12, 52885.31, '2026-07-15 12:32:00', '2026-07-15', '2026-07-17 12:32:00', NULL),
(143, NULL, NULL, 27, 10, 'Deposito_RRSS', 'concretada', 1, 33385.28, 4340.09, 0.00, 0.00, 0.00, 1502.34, 27542.85, '2026-09-07 20:24:00', '2026-09-10', NULL, NULL),
(144, 'MLA-FICT-200144', 'MLA-FICT-200144', 21, 34, 'Deposito_ML', 'concretada', 1, 28961.73, 3765.02, 0.00, 0.00, 1897.69, 1303.28, 21995.74, '2026-08-19 17:08:00', '2026-08-21', '2026-08-21 17:08:00', NULL),
(145, NULL, NULL, 29, 10, 'Presencial', 'concretada', 1, 28356.09, 3686.29, 0.00, 0.00, 0.00, 1276.02, 23393.78, '2026-09-06 18:58:00', '2026-09-07', NULL, NULL),
(146, 'MLA-FICT-200146', 'MLA-FICT-200146', 50, 2, 'Full', 'concretada', 1, 71488.99, 9293.57, 0.00, 3217.00, 334.31, 3217.00, 55427.11, '2026-05-31 15:26:00', '2026-06-01', '2026-05-31 15:26:00', NULL),
(147, 'MLA-FICT-200147', 'MLA-FICT-200147', 41, 39, 'Deposito_ML', 'concretada', 1, 45758.65, 5948.62, 0.00, 2059.14, 174.85, 2059.14, 35516.90, '2026-08-26 18:39:00', '2026-08-29', '2026-08-26 18:39:00', NULL),
(148, 'MLA-FICT-200148', 'MLA-FICT-200148', 43, 15, 'Full', 'concretada', 1, 22315.47, 2901.01, 0.00, 1896.81, 1681.99, 1004.20, 14831.46, '2026-09-03 15:31:00', '2026-09-03', '2026-09-04 15:31:00', NULL),
(149, NULL, NULL, 14, 30, 'Presencial', 'en_camino', 3, 69830.20, 27233.78, 0.00, 17806.70, 0.00, 9427.08, 155023.04, '2026-05-09 10:11:00', NULL, NULL, NULL),
(150, 'MLA-FICT-200150', 'MLA-FICT-200150', 29, 3, 'Deposito_ML', 'concretada', 1, 26867.43, 3492.77, 0.00, 0.00, 1145.43, 1209.03, 21020.20, '2026-06-22 18:47:00', '2026-06-25', '2026-06-23 18:47:00', NULL),
(151, 'MLA-FICT-200151', 'MLA-FICT-200151', 17, 50, 'Deposito_ML', 'concretada', 1, 72458.13, 9419.56, 0.00, 0.00, 417.67, 3260.62, 59360.28, '2026-07-27 20:02:00', '2026-07-30', '2026-07-28 20:02:00', NULL),
(152, 'MLA-FICT-200152', 'MLA-FICT-200152', 31, 45, 'Full', 'concretada', 1, 64417.89, 8374.33, 0.00, 5475.52, 198.97, 2898.81, 47470.26, '2026-08-09 18:58:00', '2026-08-09', '2026-08-09 18:58:00', NULL),
(153, 'MLA-FICT-200153', 'MLA-FICT-200153', 27, 46, 'Deposito_ML', 'concretada', 2, 33643.67, 8747.35, 0.00, 5719.42, 198.40, 3027.93, 49594.24, '2026-08-20 09:11:00', '2026-08-22', '2026-08-22 09:11:00', NULL),
(154, NULL, NULL, 47, 25, 'Deposito_RRSS', 'concretada', 1, 84517.96, 10987.33, 0.00, 7184.03, 0.00, 3803.31, 62543.29, '2026-09-08 10:45:00', '2026-09-09', NULL, NULL),
(155, 'MLA-FICT-200155', 'MLA-FICT-200155', 12, 29, 'Full', 'concretada', 1, 57798.13, 7513.76, 0.00, 0.00, 923.08, 2600.92, 46760.37, '2026-07-23 19:55:00', '2026-07-25', '2026-07-25 19:55:00', NULL),
(156, 'MLA-FICT-200156', 'MLA-FICT-200156', 13, 16, 'Full', 'concretada', 1, 55367.91, 7197.83, 0.00, 4706.27, 1195.70, 2491.56, 39776.55, '2026-05-27 12:00:00', '2026-05-27', '2026-05-29 12:00:00', NULL),
(157, 'MLA-FICT-200157', 'MLA-FICT-200157', 44, 4, 'Deposito_ML', 'concretada', 1, 66432.83, 8636.27, 0.00, 2989.48, 1363.49, 2989.48, 50454.11, '2026-08-06 16:05:00', '2026-08-07', '2026-08-06 16:05:00', NULL),
(158, 'MLA-FICT-200158', 'MLA-FICT-200158', 4, 40, 'Full', 'concretada', 1, 45770.74, 5950.20, 0.00, 0.00, 239.55, 2059.68, 37521.31, '2026-06-06 19:36:00', '2026-06-07', '2026-06-06 19:36:00', NULL),
(159, 'MLA-FICT-200159', 'MLA-FICT-200159', 46, 25, 'Deposito_ML', 'cancelada', 1, 35924.79, 4670.22, 0.00, 0.00, 204.88, 1616.62, 29433.07, '2026-07-22 17:11:00', NULL, '2026-07-23 17:11:00', NULL),
(160, 'MLA-FICT-200160', 'MLA-FICT-200160', 50, 4, 'Deposito_ML', 'concretada', 1, 72408.18, 9413.06, 0.00, 3258.37, 1159.52, 3258.37, 55318.86, '2026-06-09 10:18:00', '2026-06-10', '2026-06-11 10:18:00', NULL),
(161, NULL, NULL, 48, 21, 'Deposito_RRSS', 'concretada', 1, 37073.88, 4819.60, 0.00, 1668.32, 0.00, 1668.32, 28917.64, '2026-07-28 10:30:00', '2026-07-31', NULL, NULL),
(162, 'MLA-FICT-200162', 'MLA-FICT-200162', 38, 13, 'Deposito_ML', 'concretada', 1, 44880.45, 5834.46, 0.00, 3814.84, 1777.56, 2019.62, 31433.97, '2026-04-30 11:39:00', '2026-05-01', '2026-05-02 11:39:00', NULL),
(163, 'MLA-FICT-200163', 'MLA-FICT-200163', 1, 41, 'Full', 'concretada', 1, 44167.99, 5741.84, 0.00, 3754.28, 910.89, 1987.56, 31773.42, '2026-08-05 21:07:00', '2026-08-07', '2026-08-06 21:07:00', NULL),
(164, 'MLA-FICT-200164', 'MLA-FICT-200164', 42, 37, 'Full', 'concretada', 1, 50725.98, 6594.38, 0.00, 0.00, 250.44, 2282.67, 41598.49, '2026-07-06 13:50:00', '2026-07-08', '2026-07-07 13:50:00', NULL),
(165, NULL, NULL, 3, 41, 'Presencial', 'concretada', 1, 86640.59, 11263.28, 0.00, 0.00, 0.00, 3898.83, 71478.48, '2026-09-04 14:53:00', '2026-09-05', NULL, NULL),
(166, 'MLA-FICT-200166', 'MLA-FICT-200166', 57, 14, 'Deposito_ML', 'concretada', 2, 73140.75, 19016.60, 0.00, 6582.67, 1242.87, 6582.67, 112856.69, '2026-05-27 16:50:00', '2026-05-29', '2026-05-29 16:50:00', NULL),
(167, NULL, NULL, 23, 11, 'Presencial', 'concretada', 1, 94460.39, 12279.85, 0.00, 4250.72, 0.00, 4250.72, 73679.10, '2026-05-22 21:22:00', '2026-05-25', NULL, NULL),
(168, 'MLA-FICT-200168', 'MLA-FICT-200168', 26, 24, 'Full', 'concretada', 1, 72433.58, 9416.37, 0.00, 0.00, 597.29, 3259.51, 59160.41, '2026-07-19 22:50:00', '2026-07-19', '2026-07-20 22:50:00', NULL),
(169, 'MLA-FICT-200169', 'MLA-FICT-200169', 21, 10, 'Full', 'concretada', 1, 25257.47, 3283.47, 0.00, 0.00, 976.30, 1136.59, 19861.11, '2026-07-28 11:07:00', '2026-07-28', '2026-07-29 11:07:00', NULL),
(170, NULL, NULL, 32, 30, 'Deposito_RRSS', 'concretada', 1, 64067.10, 8328.72, 0.00, 0.00, 0.00, 2883.02, 52855.36, '2026-06-02 13:49:00', '2026-06-03', NULL, NULL),
(171, 'MLA-FICT-200171', 'MLA-FICT-200171', 57, 43, 'Deposito_ML', 'concretada', 1, 100675.78, 13087.85, 0.00, 4530.41, 1027.13, 4530.41, 77499.98, '2026-09-09 13:59:00', '2026-09-09', '2026-09-09 13:59:00', NULL),
(172, 'MLA-FICT-200172', 'MLA-FICT-200172', 3, 18, 'Deposito_ML', 'concretada', 1, 68621.56, 8920.80, 0.00, 3087.97, 1700.13, 3087.97, 51824.69, '2026-06-25 19:57:00', '2026-06-25', '2026-06-26 19:57:00', NULL),
(173, 'MLA-FICT-200173', 'MLA-FICT-200173', 41, 22, 'Deposito_ML', 'concretada', 1, 36833.82, 4788.40, 0.00, 1657.52, 1262.98, 1657.52, 27467.40, '2026-07-30 12:34:00', '2026-07-31', '2026-07-30 12:34:00', NULL),
(174, 'MLA-FICT-200174', 'MLA-FICT-200174', 5, 22, 'Full', 'concretada', 1, 66705.79, 8671.75, 0.00, 0.00, 1550.29, 3001.76, 53481.99, '2026-09-19 19:03:00', '2026-09-22', '2026-09-21 19:03:00', NULL),
(175, NULL, NULL, 47, 45, 'Presencial', 'cancelada', 1, 82653.64, 10744.97, 0.00, 0.00, 0.00, 3719.41, 68189.26, '2026-07-09 17:05:00', NULL, NULL, NULL),
(176, 'MLA-FICT-200176', 'MLA-FICT-200176', 31, 43, 'Full', 'concretada', 1, 66749.35, 8677.42, 0.00, 3003.72, 2008.30, 3003.72, 50056.19, '2026-07-07 20:49:00', '2026-07-10', '2026-07-07 20:49:00', NULL),
(177, 'MLA-FICT-200177', 'MLA-FICT-200177', 57, 33, 'Full', 'concretada', 1, 86816.91, 11286.20, 0.00, 0.00, 620.97, 3906.76, 71002.98, '2026-08-06 09:04:00', '2026-08-08', '2026-08-08 09:04:00', NULL),
(178, NULL, NULL, 54, 16, 'Deposito_RRSS', 'concretada', 1, 47770.26, 6210.13, 0.00, 4060.47, 0.00, 2149.66, 35350.00, '2026-06-18 14:35:00', '2026-06-21', NULL, NULL),
(179, 'MLA-FICT-200179', 'MLA-FICT-200179', 32, 5, 'Deposito_ML', 'concretada', 1, 89641.99, 11653.46, 0.00, 4033.89, 1197.96, 4033.89, 68722.79, '2026-09-14 12:52:00', '2026-09-15', '2026-09-14 12:52:00', NULL),
(180, 'MLA-FICT-200180', 'MLA-FICT-200180', 47, 44, 'Deposito_ML', 'concretada', 1, 70848.35, 9210.29, 0.00, 6022.11, 387.58, 3188.18, 52040.19, '2026-06-10 10:37:00', '2026-06-13', '2026-06-10 10:37:00', NULL),
(181, NULL, NULL, 51, 29, 'Presencial', 'concretada', 1, 31750.46, 4127.56, 0.00, 0.00, 0.00, 1428.77, 26194.13, '2026-08-14 16:41:00', '2026-08-15', NULL, NULL),
(182, 'MLA-FICT-200182', 'MLA-FICT-200182', 26, 23, 'Deposito_ML', 'concretada', 1, 80071.59, 10409.31, 0.00, 3603.22, 2020.70, 3603.22, 60435.14, '2026-07-22 12:13:00', '2026-07-25', '2026-07-24 12:13:00', NULL),
(183, 'MLA-FICT-200183', 'MLA-FICT-200183', 39, 2, 'Full', 'concretada', 1, 73661.52, 9576.00, 0.00, 0.00, 1.86, 3314.77, 60768.89, '2026-04-13 17:25:00', '2026-04-15', '2026-04-13 17:25:00', NULL),
(184, 'MLA-FICT-200184', 'MLA-FICT-200184', 46, 24, 'Deposito_ML', 'concretada', 1, 38613.08, 5019.70, 0.00, 0.00, 1044.72, 1737.59, 30811.07, '2026-08-13 14:45:00', '2026-08-14', '2026-08-15 14:45:00', NULL),
(185, 'MLA-FICT-200185', 'MLA-FICT-200185', 11, 27, 'Full', 'concretada', 1, 41873.66, 5443.58, 0.00, 3559.26, 1447.44, 1884.31, 29539.07, '2026-04-11 19:08:00', '2026-04-12', '2026-04-11 19:08:00', NULL),
(186, NULL, NULL, 52, 12, 'Deposito_RRSS', 'concretada', 1, 47831.44, 6218.09, 0.00, 4065.67, 0.00, 2152.41, 35395.27, '2026-07-18 15:39:00', '2026-07-21', NULL, NULL),
(187, 'MLA-FICT-200187', 'MLA-FICT-200187', 2, 24, 'Deposito_ML', 'concretada', 1, 75193.41, 9775.14, 0.00, 3383.70, 73.62, 3383.70, 58577.25, '2026-08-01 20:15:00', '2026-08-01', '2026-08-03 20:15:00', NULL),
(188, NULL, NULL, 32, 34, 'Deposito_RRSS', 'concretada', 1, 82983.38, 10787.84, 0.00, 3734.25, 0.00, 3734.25, 64727.04, '2026-09-13 20:46:00', '2026-09-16', NULL, NULL),
(189, 'MLA-FICT-200189', 'MLA-FICT-200189', 7, 1, 'Full', 'cancelada', 1, 25137.97, 3267.94, 0.00, 1131.21, 1348.69, 1131.21, 18258.92, '2026-08-04 20:42:00', NULL, '2026-08-05 20:42:00', NULL),
(190, 'MLA-FICT-200190', 'MLA-FICT-200190', 34, 17, 'Deposito_ML', 'concretada', 3, 50690.64, 19769.35, 0.00, 0.00, 77.72, 6843.24, 125381.61, '2026-07-22 14:26:00', '2026-07-24', '2026-07-24 14:26:00', NULL),
(191, 'MLA-FICT-200191', 'MLA-FICT-200191', 32, 18, 'Deposito_ML', 'devuelta', 1, 79321.94, 10311.85, 0.00, 3569.49, 1066.47, 3569.49, 60804.64, '2026-09-04 09:42:00', NULL, '2026-09-04 09:42:00', NULL),
(192, 'MLA-FICT-200192', 'MLA-FICT-200192', 41, 45, 'Full', 'concretada', 1, 49400.94, 6422.12, 0.00, 0.00, 1450.14, 2223.04, 39305.64, '2026-08-25 13:00:00', '2026-08-27', '2026-08-25 13:00:00', NULL),
(193, NULL, NULL, 13, 49, 'Presencial', 'devuelta', 2, 58317.59, 15162.57, 0.00, 0.00, 0.00, 5248.58, 96224.03, '2026-07-28 09:21:00', NULL, NULL, NULL),
(194, 'MLA-FICT-200194', 'MLA-FICT-200194', 51, 30, 'Deposito_ML', 'concretada', 1, 30854.02, 4011.02, 0.00, 1388.43, 119.52, 1388.43, 23946.62, '2026-08-29 16:46:00', '2026-08-31', '2026-08-29 16:46:00', NULL),
(195, 'MLA-FICT-200195', 'MLA-FICT-200195', 21, 29, 'Deposito_ML', 'concretada', 1, 30755.19, 3998.17, 0.00, 2614.19, 577.78, 1383.98, 22181.07, '2026-06-27 21:59:00', '2026-06-30', '2026-06-27 21:59:00', NULL),
(196, 'MLA-FICT-200196', 'MLA-FICT-200196', 22, 22, 'Deposito_ML', 'en_camino', 1, 85334.59, 11093.50, 0.00, 7253.44, 1343.07, 3840.06, 61804.52, '2026-07-07 09:06:00', NULL, '2026-07-09 09:06:00', NULL),
(197, 'MLA-FICT-200197', 'MLA-FICT-200197', 53, 44, 'Full', 'concretada', 1, 73438.97, 9547.07, 0.00, 0.00, 1143.90, 3304.75, 59443.25, '2026-08-27 18:25:00', '2026-08-28', '2026-08-28 18:25:00', NULL),
(198, 'MLA-FICT-200198', 'MLA-FICT-200198', 1, 4, 'Full', 'concretada', 1, 37754.54, 4908.09, 0.00, 1698.95, 554.17, 1698.95, 28894.38, '2026-09-23 10:33:00', '2026-09-23', '2026-09-23 10:33:00', NULL),
(199, NULL, NULL, 44, 42, 'Presencial', 'concretada', 2, 48771.26, 12680.53, 0.00, 0.00, 0.00, 4389.41, 80472.58, '2026-08-31 18:40:00', '2026-09-03', NULL, NULL),
(200, 'MLA-FICT-200200', 'MLA-FICT-200200', 13, 5, 'Full', 'concretada', 2, 59249.16, 15404.78, 0.00, 5332.42, 1692.59, 5332.42, 90736.11, '2026-07-05 13:18:00', '2026-07-07', '2026-07-06 13:18:00', NULL);
INSERT INTO `ventas` (`id`, `id_venta_ml`, `id_pedido_ml`, `fk_catalogo_SKU`, `fk_clientes_id`, `canal`, `estado`, `unidades`, `precio_unitario`, `comision_variable`, `comision_fija`, `costo_cuotas`, `costo_envio`, `impuestos`, `precio_neto`, `fecha_venta`, `fecha_concrecion`, `fecha_envio`, `notas`) VALUES
(201, 'MLA-FICT-200201', 'MLA-FICT-200201', 5, 12, 'Deposito_ML', 'cancelada', 1, 67076.68, 8719.97, 0.00, 5701.52, 2154.73, 3018.45, 47482.01, '2026-08-13 09:16:00', NULL, '2026-08-13 09:16:00', NULL),
(202, 'MLA-FICT-200202', 'MLA-FICT-200202', 8, 17, 'Full', 'concretada', 1, 52463.96, 6820.31, 0.00, 2360.88, 227.23, 2360.88, 40694.66, '2026-07-27 15:13:00', '2026-07-27', '2026-07-27 15:13:00', NULL),
(203, 'MLA-FICT-200203', 'MLA-FICT-200203', 3, NULL, 'Deposito_ML', 'en_camino', 1, 68045.41, 8845.90, 0.00, 3062.04, 1990.16, 3062.04, 51085.27, '2026-09-06 19:00:00', NULL, '2026-09-08 19:00:00', NULL),
(204, 'MLA-FICT-200204', 'MLA-FICT-200204', 51, 23, 'Deposito_ML', 'concretada', 1, 23651.30, 3074.67, 0.00, 0.00, 7.28, 1064.31, 19505.04, '2026-08-03 15:54:00', '2026-08-06', '2026-08-03 15:54:00', NULL),
(205, 'MLA-FICT-200205', 'MLA-FICT-200205', 21, 36, 'Deposito_ML', 'concretada', 1, 26763.88, 3479.30, 0.00, 2274.93, 1673.00, 1204.37, 18132.28, '2026-09-15 19:05:00', '2026-09-17', '2026-09-17 19:05:00', NULL),
(206, NULL, NULL, 26, 9, 'Deposito_RRSS', 'concretada', 1, 73770.26, 9590.13, 0.00, 0.00, 0.00, 3319.66, 60860.47, '2026-09-02 20:24:00', '2026-09-05', NULL, NULL),
(207, NULL, NULL, 3, 2, 'Deposito_RRSS', 'concretada', 1, 78834.33, 10248.46, 0.00, 6700.92, 0.00, 3547.54, 58337.41, '2026-04-13 12:31:00', '2026-04-16', NULL, NULL),
(208, 'MLA-FICT-200208', 'MLA-FICT-200208', 5, 5, 'Full', 'concretada', 1, 73037.08, 9494.82, 0.00, 6208.15, 2068.20, 3286.67, 51979.24, '2026-06-20 09:25:00', '2026-06-21', '2026-06-22 09:25:00', NULL),
(209, 'MLA-FICT-200209', 'MLA-FICT-200209', 11, NULL, 'Deposito_ML', 'en_camino', 1, 55371.81, 7198.34, 0.00, 0.00, 31.60, 2491.73, 45650.14, '2026-07-11 16:58:00', NULL, '2026-07-13 16:58:00', NULL),
(210, 'MLA-FICT-200210', 'MLA-FICT-200210', 52, 28, 'Full', 'concretada', 1, 39826.15, 5177.40, 0.00, 3385.22, 1308.95, 1792.18, 28162.40, '2026-08-06 11:53:00', '2026-08-07', '2026-08-06 11:53:00', NULL),
(211, NULL, NULL, 55, 38, 'Deposito_RRSS', 'cancelada', 1, 39775.81, 5170.86, 0.00, 0.00, 0.00, 1789.91, 32815.04, '2026-07-08 14:07:00', NULL, NULL, NULL),
(212, 'MLA-FICT-200212', 'MLA-FICT-200212', 6, 41, 'Full', 'concretada', 1, 66174.92, 8602.74, 0.00, 0.00, 2036.49, 2977.87, 52557.82, '2026-08-25 21:26:00', '2026-08-25', '2026-08-25 21:26:00', NULL),
(213, 'MLA-FICT-200213', 'MLA-FICT-200213', 51, 10, 'Full', 'concretada', 1, 23857.78, 3101.51, 0.00, 1073.60, 915.69, 1073.60, 17693.38, '2026-09-22 16:05:00', '2026-09-25', '2026-09-24 16:05:00', NULL),
(214, 'MLA-FICT-200214', 'MLA-FICT-200214', 35, 36, 'Deposito_ML', 'concretada', 1, 56876.18, 7393.90, 0.00, 0.00, 1379.82, 2559.43, 45543.03, '2026-08-11 11:39:00', '2026-08-13', '2026-08-12 11:39:00', NULL),
(215, 'MLA-FICT-200215', 'MLA-FICT-200215', 9, 8, 'Deposito_ML', 'concretada', 3, 80630.39, 31445.85, 0.00, 20560.75, 1694.73, 10885.10, 177304.74, '2026-04-28 18:23:00', '2026-04-29', '2026-04-29 18:23:00', NULL),
(216, NULL, NULL, 45, 17, 'Presencial', 'concretada', 1, 41924.70, 5450.21, 0.00, 1886.61, 0.00, 1886.61, 32701.27, '2026-03-25 16:31:00', '2026-03-27', NULL, NULL),
(217, NULL, NULL, 53, 5, 'Presencial', 'concretada', 1, 70824.92, 9207.24, 0.00, 0.00, 0.00, 3187.12, 58430.56, '2026-08-06 10:47:00', '2026-08-09', NULL, NULL),
(218, 'MLA-FICT-200218', 'MLA-FICT-200218', 48, 13, 'Deposito_ML', 'concretada', 1, 31159.80, 4050.77, 0.00, 0.00, 717.49, 1402.19, 24989.35, '2026-07-20 14:26:00', '2026-07-20', '2026-07-20 14:26:00', NULL),
(219, 'MLA-FICT-200219', 'MLA-FICT-200219', 16, 13, 'Full', 'concretada', 1, 94557.82, 12292.52, 0.00, 8037.41, 391.73, 4255.10, 69581.06, '2026-08-04 16:03:00', '2026-08-06', '2026-08-04 16:03:00', NULL),
(220, 'MLA-FICT-200220', 'MLA-FICT-200220', 19, 19, 'Full', 'concretada', 1, 49223.96, 6399.11, 0.00, 4184.04, 1008.87, 2215.08, 35416.86, '2026-08-19 09:44:00', '2026-08-20', '2026-08-20 09:44:00', NULL),
(221, 'MLA-FICT-200221', 'MLA-FICT-200221', 38, 41, 'Deposito_ML', 'concretada', 1, 37107.37, 4823.96, 0.00, 0.00, 1452.76, 1669.83, 30613.58, '2026-04-04 14:00:00', '2026-04-04', '2026-04-05 14:00:00', NULL),
(222, 'MLA-FICT-200222', 'MLA-FICT-200222', 39, 36, 'Deposito_ML', 'concretada', 1, 91139.17, 11848.09, 0.00, 0.00, 1355.00, 4101.26, 75189.82, '2026-05-02 14:00:00', '2026-05-02', '2026-05-03 14:00:00', NULL),
(223, 'MLA-FICT-200223', 'MLA-FICT-200223', 45, 34, 'Deposito_ML', 'concretada', 1, 49097.87, 6382.72, 0.00, 0.00, 989.21, 2209.40, 40505.75, '2026-05-07 14:00:00', '2026-05-07', '2026-05-08 14:00:00', NULL),
(224, 'MLA-FICT-200224', 'MLA-FICT-200224', 14, 30, 'Deposito_ML', 'concretada', 1, 63369.48, 8238.03, 0.00, 0.00, 779.17, 2851.63, 52279.82, '2026-04-29 14:00:00', '2026-04-29', '2026-04-30 14:00:00', NULL),
(225, 'MLA-FICT-200225', 'MLA-FICT-200225', 28, 16, 'Deposito_ML', 'concretada', 1, 48731.72, 6335.12, 0.00, 0.00, 747.83, 2192.93, 40203.67, '2026-03-27 14:00:00', '2026-03-27', '2026-03-28 14:00:00', NULL),
(226, 'MLA-FICT-200226', 'MLA-FICT-200226', 30, 38, 'Deposito_ML', 'concretada', 1, 90923.25, 11820.02, 0.00, 0.00, 1446.25, 4091.55, 75011.68, '2026-04-15 14:00:00', '2026-04-15', '2026-04-16 14:00:00', NULL);

-- devoluciones (4 filas)
INSERT INTO `devoluciones` (`id`, `fk_ventas_id`, `fk_catalogo_SKU`, `unidades`, `fecha_devolucion`, `fecha_reingreso_full`, `motivo`) VALUES
(1, 24, 53, 1, '2026-10-01', '2026-10-05', 'Cliente arrepentido - derecho a retracto'),
(2, 94, 58, 2, '2026-06-04', '2026-06-09', 'Cliente arrepentido - derecho a retracto'),
(3, 191, 32, 1, '2026-09-11', '2026-09-15', 'Cliente arrepentido - derecho a retracto'),
(4, 193, 13, 2, '2026-08-05', '2026-08-06', 'Cliente arrepentido - derecho a retracto');

-- eventos_demanda (8 filas)
INSERT INTO `eventos_demanda` (`id`, `fk_catalogo_SKU`, `tipo`, `fecha_inicio`, `fecha_fin_estimada`, `factor_boost`, `notas`) VALUES
(1, 46, 'adaptacion_pelicula', '2026-09-20', '2026-11-19', 2.10, 'Boost por estreno de adaptacion audiovisual'),
(2, 48, 'premio', '2026-05-30', '2026-08-22', 1.98, 'Boost por premio literario reciente'),
(3, 28, 'adaptacion_pelicula', '2026-05-31', '2026-07-29', 2.23, 'Boost por estreno de adaptacion audiovisual'),
(4, 15, 'otro', '2026-08-08', '2026-10-27', 2.35, 'Evento de demanda puntual'),
(5, 10, 'otro', '2026-09-24', '2026-12-18', 2.05, 'Evento de demanda puntual'),
(6, 24, 'otro', '2026-07-01', '2026-09-02', 1.34, 'Evento de demanda puntual'),
(7, 20, 'otro', '2026-07-17', '2026-09-29', 2.44, 'Evento de demanda puntual'),
(8, 17, 'premio', '2026-09-04', '2026-11-12', 2.36, 'Boost por premio literario reciente');

-- demanda_forecast (57 filas)
INSERT INTO `demanda_forecast` (`fk_catalogo_SKU`, `est_t4`, `est_t3`, `est_t2`, `est_t1`, `est_t0`, `ventas_estimadas_core`, `boost_activo`, `ajuste_evento`, `demanda_final`, `confianza`, `metodo_calculo`, `ventas_totales`, `meses_validos`, `fecha_calculo`) VALUES
(2, 1.64, 1.47, 1.69, 0.97, 1.52, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(3, 1.31, 1.58, 1.23, 0.96, 1.05, 1.25, 1.00, 0.00, 1.25, 'media', 'shrinkage_peers', 5, 4, '2026-09-29 00:00:00'),
(4, 1.47, 1.50, 1.03, 1.35, 1.32, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(5, 2.60, 2.30, 3.82, 2.62, 3.72, 3.00, 1.00, 0.00, 3.00, 'media', 'shrinkage_peers', 6, 2, '2026-09-29 00:00:00'),
(6, 1.18, 0.71, 0.81, 0.71, 1.14, 1.00, 1.00, 0.00, 1.00, 'media', 'shrinkage_peers', 3, 3, '2026-09-29 00:00:00'),
(7, 2.57, 2.41, 3.52, 2.34, 2.65, 3.00, 1.00, 0.00, 3.00, 'media', 'shrinkage_peers', 3, 1, '2026-09-29 00:00:00'),
(8, 1.99, 2.94, 3.11, 2.81, 2.01, 2.50, 1.00, 0.00, 2.50, 'media', 'shrinkage_peers', 5, 2, '2026-09-29 00:00:00'),
(9, 2.83, 3.76, 2.64, 2.39, 3.07, 3.00, 1.00, 0.00, 3.00, 'media', 'shrinkage_peers', 3, 1, '2026-09-29 00:00:00'),
(10, 1.18, 1.10, 1.30, 1.15, 1.28, 1.00, 2.17, 0.00, 2.17, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(11, 1.25, 1.58, 1.63, 1.10, 1.13, 1.50, 1.00, 0.00, 1.50, 'media', 'shrinkage_peers', 3, 2, '2026-09-29 00:00:00'),
(12, 2.82, 1.84, 2.14, 2.90, 2.95, 2.33, 1.00, 0.00, 2.33, 'media', 'shrinkage_peers', 7, 3, '2026-09-29 00:00:00'),
(13, 1.65, 1.27, 1.71, 1.57, 1.16, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(14, 4.50, 4.13, 3.79, 4.99, 3.78, 4.00, 1.00, 0.00, 4.00, 'media', 'shrinkage_peers', 4, 1, '2026-09-29 00:00:00'),
(15, 1.08, 0.88, 0.79, 1.17, 0.83, 1.00, 2.06, 0.00, 2.06, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(16, 1.11, 0.85, 0.96, 0.99, 0.92, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 1, 1, '2026-09-29 00:00:00'),
(17, 1.46, 2.55, 2.16, 1.83, 1.46, 2.00, 1.65, 0.00, 3.30, 'media', 'shrinkage_peers', 4, 2, '2026-09-29 00:00:00'),
(18, 1.82, 2.04, 1.84, 2.24, 1.73, 2.00, 1.00, 0.00, 2.00, 'baja', 'shrinkage_peers', 2, 1, '2026-09-29 00:00:00'),
(19, 2.02, 2.12, 1.86, 1.73, 1.97, 1.67, 1.00, 0.00, 1.67, 'media', 'shrinkage_peers', 5, 3, '2026-09-29 00:00:00'),
(20, 1.13, 0.91, 1.16, 1.06, 1.23, 1.00, 1.33, 0.00, 1.33, 'baja', 'shrinkage_peers', 1, 1, '2026-09-29 00:00:00'),
(21, 1.18, 0.76, 0.73, 1.15, 1.16, 1.00, 1.00, 0.00, 1.00, 'media', 'shrinkage_peers', 4, 4, '2026-09-29 00:00:00'),
(22, 1.15, 0.79, 0.72, 1.10, 0.82, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 1, 1, '2026-09-29 00:00:00'),
(23, 1.15, 0.80, 1.28, 1.13, 1.02, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 1, 1, '2026-09-29 00:00:00'),
(24, 0.89, 1.16, 0.94, 1.01, 0.95, 1.00, 1.86, 0.00, 1.86, 'media', 'shrinkage_peers', 3, 3, '2026-09-29 00:00:00'),
(25, 2.58, 1.89, 1.67, 2.41, 2.22, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 6, 3, '2026-09-29 00:00:00'),
(26, 3.22, 2.79, 2.34, 1.93, 2.76, 2.50, 1.00, 0.00, 2.50, 'media', 'shrinkage_peers', 5, 2, '2026-09-29 00:00:00'),
(27, 1.63, 1.76, 1.30, 1.57, 1.69, 1.50, 1.00, 0.00, 1.50, 'media', 'shrinkage_peers', 6, 4, '2026-09-29 00:00:00'),
(28, 1.00, 1.20, 1.14, 0.72, 1.27, 1.00, 1.33, 0.00, 1.33, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(29, 2.83, 2.11, 2.00, 2.32, 2.56, 2.33, 1.00, 0.00, 2.33, 'media', 'shrinkage_peers', 7, 3, '2026-09-29 00:00:00'),
(30, 1.95, 2.49, 2.81, 2.20, 3.04, 2.50, 1.00, 0.00, 2.50, 'media', 'shrinkage_peers', 5, 2, '2026-09-29 00:00:00'),
(31, 1.37, 1.61, 1.92, 1.50, 1.40, 1.50, 1.00, 0.00, 1.50, 'media', 'shrinkage_peers', 3, 2, '2026-09-29 00:00:00'),
(32, 1.69, 1.47, 1.89, 2.59, 1.91, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 6, 3, '2026-09-29 00:00:00'),
(33, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, 0.00, 'baja', 'shrinkage_peers', 0, 1, '2026-09-29 00:00:00'),
(34, 2.42, 2.00, 1.92, 1.84, 2.14, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 4, 2, '2026-09-29 00:00:00'),
(35, 0.83, 0.99, 1.18, 0.74, 0.90, 1.00, 1.00, 0.00, 1.00, 'media', 'shrinkage_peers', 3, 3, '2026-09-29 00:00:00'),
(36, 1.22, 1.12, 0.71, 0.81, 1.16, 1.00, 1.00, 0.00, 1.00, 'media', 'shrinkage_peers', 3, 3, '2026-09-29 00:00:00'),
(37, 1.53, 1.12, 1.30, 1.09, 0.98, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(38, 2.36, 1.43, 1.58, 1.69, 1.68, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 4, 2, '2026-09-29 00:00:00'),
(39, 1.42, 1.98, 2.56, 2.42, 1.61, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 4, 2, '2026-09-29 00:00:00'),
(40, 5.04, 4.56, 3.07, 3.14, 4.54, 4.00, 1.00, 0.00, 4.00, 'media', 'shrinkage_peers', 4, 1, '2026-09-29 00:00:00'),
(41, 2.08, 3.15, 2.87, 2.96, 2.86, 2.50, 1.00, 0.00, 2.50, 'media', 'shrinkage_peers', 5, 2, '2026-09-29 00:00:00'),
(42, 1.05, 1.56, 1.15, 1.13, 1.31, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(43, 1.94, 2.17, 1.96, 1.90, 1.63, 1.75, 1.00, 0.00, 1.75, 'media', 'shrinkage_peers', 7, 4, '2026-09-29 00:00:00'),
(44, 2.08, 1.56, 1.69, 1.39, 2.13, 1.75, 1.00, 0.00, 1.75, 'media', 'shrinkage_peers', 7, 4, '2026-09-29 00:00:00'),
(45, 1.58, 1.41, 1.21, 1.34, 1.49, 1.33, 1.00, 0.00, 1.33, 'media', 'shrinkage_peers', 4, 3, '2026-09-29 00:00:00'),
(46, 1.16, 1.13, 0.85, 0.77, 1.05, 1.00, 2.08, 0.00, 2.08, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(47, 1.90, 1.84, 1.21, 1.42, 1.23, 1.50, 1.00, 0.00, 1.50, 'media', 'shrinkage_peers', 3, 2, '2026-09-29 00:00:00'),
(48, 2.41, 3.82, 2.37, 3.18, 3.21, 3.00, 1.98, 0.00, 5.94, 'media', 'shrinkage_peers', 6, 2, '2026-09-29 00:00:00'),
(49, 1.30, 1.06, 1.21, 0.78, 1.00, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(50, 1.28, 1.22, 0.98, 0.75, 1.09, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00'),
(51, 3.16, 2.91, 3.52, 3.47, 3.57, 2.75, 1.00, 0.00, 2.75, 'alta', 'shrinkage_peers', 11, 4, '2026-09-29 00:00:00'),
(52, 3.56, 3.12, 2.73, 4.29, 4.40, 3.50, 1.00, 0.00, 3.50, 'media', 'shrinkage_peers', 7, 2, '2026-09-29 00:00:00'),
(53, 1.78, 2.47, 1.78, 1.72, 2.31, 2.00, 1.00, 0.00, 2.00, 'media', 'shrinkage_peers', 4, 2, '2026-09-29 00:00:00'),
(54, 1.21, 2.10, 2.17, 1.61, 1.88, 1.67, 1.00, 0.00, 1.67, 'media', 'shrinkage_peers', 5, 3, '2026-09-29 00:00:00'),
(55, 0.70, 1.30, 0.83, 1.10, 1.04, 1.00, 1.00, 0.00, 1.00, 'media', 'shrinkage_peers', 3, 3, '2026-09-29 00:00:00'),
(56, 1.12, 1.19, 1.80, 1.91, 1.58, 1.50, 1.00, 0.00, 1.50, 'media', 'shrinkage_peers', 3, 2, '2026-09-29 00:00:00'),
(57, 2.13, 1.36, 2.06, 2.18, 2.27, 1.75, 1.00, 0.00, 1.75, 'media', 'shrinkage_peers', 7, 4, '2026-09-29 00:00:00'),
(58, 1.15, 0.87, 1.17, 0.80, 1.21, 1.00, 1.00, 0.00, 1.00, 'baja', 'shrinkage_peers', 2, 2, '2026-09-29 00:00:00');

-- demanda_forecast_historico (228 filas)
INSERT INTO `demanda_forecast_historico` (`fk_catalogo_SKU`, `fecha_vigencia`, `dias_disponibles`, `ventas_mensualizadas_core`, `demanda_final_est`, `mes_valido`, `es_pico`, `fecha_calculo`) VALUES
(2, '2026-06-01', 25, 0.92, 0.91, 1, 0, '2026-06-01 00:00:00'),
(2, '2026-07-01', 25, 0.84, 0.79, 1, 0, '2026-07-01 00:00:00'),
(2, '2026-08-01', 21, 1.39, 1.41, 1, 0, '2026-08-01 00:00:00'),
(2, '2026-09-01', 22, 1.62, 1.78, 1, 0, '2026-09-01 00:00:00'),
(3, '2026-06-01', 23, 1.71, 1.80, 1, 0, '2026-06-01 00:00:00'),
(3, '2026-07-01', 25, 1.51, 1.47, 1, 0, '2026-07-01 00:00:00'),
(3, '2026-08-01', 30, 1.02, 1.00, 1, 0, '2026-08-01 00:00:00'),
(3, '2026-09-01', 25, 0.80, 0.78, 1, 0, '2026-09-01 00:00:00'),
(4, '2026-06-01', 24, 1.36, 1.35, 1, 0, '2026-06-01 00:00:00'),
(4, '2026-07-01', 30, 1.19, 1.30, 1, 0, '2026-07-01 00:00:00'),
(4, '2026-08-01', 21, 1.66, 1.56, 1, 0, '2026-08-01 00:00:00'),
(4, '2026-09-01', 21, 1.74, 1.59, 1, 0, '2026-09-01 00:00:00'),
(5, '2026-06-01', 27, 3.47, 3.23, 1, 0, '2026-06-01 00:00:00'),
(5, '2026-07-01', 30, 2.29, 2.07, 1, 0, '2026-07-01 00:00:00'),
(5, '2026-08-01', 30, 2.80, 2.82, 1, 0, '2026-08-01 00:00:00'),
(5, '2026-09-01', 25, 2.12, 2.09, 1, 0, '2026-09-01 00:00:00'),
(6, '2026-06-01', 28, 1.27, 1.31, 1, 0, '2026-06-01 00:00:00'),
(6, '2026-07-01', 25, 0.93, 0.96, 1, 0, '2026-07-01 00:00:00'),
(6, '2026-08-01', 27, 1.23, 1.25, 1, 0, '2026-08-01 00:00:00'),
(6, '2026-09-01', 28, 1.16, 1.15, 1, 0, '2026-09-01 00:00:00'),
(7, '2026-06-01', 24, 2.96, 3.12, 1, 0, '2026-06-01 00:00:00'),
(7, '2026-07-01', 25, 1.91, 1.83, 1, 0, '2026-07-01 00:00:00'),
(7, '2026-08-01', 29, 4.09, 4.44, 1, 0, '2026-08-01 00:00:00'),
(7, '2026-09-01', 24, 3.51, 3.29, 1, 0, '2026-09-01 00:00:00'),
(8, '2026-06-01', 25, 1.73, 1.76, 1, 0, '2026-06-01 00:00:00'),
(8, '2026-07-01', 25, 2.38, 2.23, 1, 0, '2026-07-01 00:00:00'),
(8, '2026-08-01', 20, 2.62, 2.71, 1, 0, '2026-08-01 00:00:00'),
(8, '2026-09-01', 22, 3.46, 3.37, 1, 0, '2026-09-01 00:00:00'),
(9, '2026-06-01', 22, 3.00, 3.27, 1, 0, '2026-06-01 00:00:00'),
(9, '2026-07-01', 22, 4.03, 3.63, 1, 0, '2026-07-01 00:00:00'),
(9, '2026-08-01', 28, 3.57, 3.45, 1, 0, '2026-08-01 00:00:00'),
(9, '2026-09-01', 27, 3.49, 3.77, 1, 0, '2026-09-01 00:00:00'),
(10, '2026-06-01', 25, 1.34, 1.39, 1, 0, '2026-06-01 00:00:00'),
(10, '2026-07-01', 20, 1.19, 1.10, 1, 0, '2026-07-01 00:00:00'),
(10, '2026-08-01', 24, 1.04, 0.94, 1, 0, '2026-08-01 00:00:00'),
(10, '2026-09-01', 23, 1.09, 1.08, 1, 0, '2026-09-01 00:00:00'),
(11, '2026-06-01', 24, 2.02, 1.90, 1, 0, '2026-06-01 00:00:00'),
(11, '2026-07-01', 27, 1.00, 1.04, 1, 0, '2026-07-01 00:00:00'),
(11, '2026-08-01', 28, 2.05, 2.01, 1, 0, '2026-08-01 00:00:00'),
(11, '2026-09-01', 29, 1.49, 1.52, 1, 0, '2026-09-01 00:00:00'),
(12, '2026-06-01', 25, 2.09, 1.89, 1, 0, '2026-06-01 00:00:00'),
(12, '2026-07-01', 24, 2.04, 2.23, 1, 0, '2026-07-01 00:00:00'),
(12, '2026-08-01', 21, 3.03, 2.86, 1, 0, '2026-08-01 00:00:00'),
(12, '2026-09-01', 26, 3.05, 3.24, 1, 0, '2026-09-01 00:00:00'),
(13, '2026-06-01', 29, 0.95, 0.97, 1, 0, '2026-06-01 00:00:00'),
(13, '2026-07-01', 24, 0.95, 0.95, 1, 0, '2026-07-01 00:00:00'),
(13, '2026-08-01', 25, 1.72, 1.57, 1, 0, '2026-08-01 00:00:00'),
(13, '2026-09-01', 26, 1.82, 1.67, 1, 0, '2026-09-01 00:00:00'),
(14, '2026-06-01', 22, 4.82, 4.53, 1, 0, '2026-06-01 00:00:00'),
(14, '2026-07-01', 24, 5.06, 5.11, 1, 0, '2026-07-01 00:00:00'),
(14, '2026-08-01', 24, 2.54, 2.71, 1, 0, '2026-08-01 00:00:00'),
(14, '2026-09-01', 28, 3.37, 3.53, 1, 0, '2026-09-01 00:00:00'),
(15, '2026-06-01', 30, 0.70, 0.75, 1, 0, '2026-06-01 00:00:00'),
(15, '2026-07-01', 27, 0.93, 1.01, 1, 0, '2026-07-01 00:00:00'),
(15, '2026-08-01', 20, 1.12, 1.03, 1, 0, '2026-08-01 00:00:00'),
(15, '2026-09-01', 21, 0.82, 0.84, 1, 0, '2026-09-01 00:00:00'),
(16, '2026-06-01', 21, 1.38, 1.35, 1, 0, '2026-06-01 00:00:00'),
(16, '2026-07-01', 20, 1.19, 1.27, 1, 0, '2026-07-01 00:00:00'),
(16, '2026-08-01', 20, 0.73, 0.68, 1, 0, '2026-08-01 00:00:00'),
(16, '2026-09-01', 22, 0.97, 0.94, 1, 0, '2026-09-01 00:00:00'),
(17, '2026-06-01', 21, 2.22, 2.23, 1, 0, '2026-06-01 00:00:00'),
(17, '2026-07-01', 22, 2.43, 2.56, 1, 0, '2026-07-01 00:00:00'),
(17, '2026-08-01', 22, 2.16, 2.18, 1, 0, '2026-08-01 00:00:00'),
(17, '2026-09-01', 30, 2.60, 2.76, 1, 0, '2026-09-01 00:00:00'),
(18, '2026-06-01', 22, 1.43, 1.44, 1, 0, '2026-06-01 00:00:00'),
(18, '2026-07-01', 27, 1.80, 1.77, 1, 0, '2026-07-01 00:00:00'),
(18, '2026-08-01', 22, 2.67, 2.46, 1, 0, '2026-08-01 00:00:00'),
(18, '2026-09-01', 23, 1.45, 1.55, 1, 0, '2026-09-01 00:00:00'),
(19, '2026-06-01', 21, 1.95, 1.92, 1, 0, '2026-06-01 00:00:00'),
(19, '2026-07-01', 21, 2.23, 2.37, 1, 0, '2026-07-01 00:00:00'),
(19, '2026-08-01', 27, 2.24, 2.17, 1, 0, '2026-08-01 00:00:00'),
(19, '2026-09-01', 22, 1.93, 2.05, 1, 0, '2026-09-01 00:00:00'),
(20, '2026-06-01', 23, 1.25, 1.16, 1, 0, '2026-06-01 00:00:00'),
(20, '2026-07-01', 23, 1.16, 1.12, 1, 0, '2026-07-01 00:00:00'),
(20, '2026-08-01', 21, 0.77, 0.76, 1, 0, '2026-08-01 00:00:00'),
(20, '2026-09-01', 21, 1.21, 1.11, 1, 0, '2026-09-01 00:00:00'),
(21, '2026-06-01', 20, 1.01, 1.00, 1, 0, '2026-06-01 00:00:00'),
(21, '2026-07-01', 20, 1.33, 1.21, 1, 0, '2026-07-01 00:00:00'),
(21, '2026-08-01', 21, 1.13, 1.19, 1, 0, '2026-08-01 00:00:00'),
(21, '2026-09-01', 23, 1.34, 1.36, 1, 0, '2026-09-01 00:00:00'),
(22, '2026-06-01', 29, 0.82, 0.80, 1, 0, '2026-06-01 00:00:00'),
(22, '2026-07-01', 28, 0.73, 0.77, 1, 0, '2026-07-01 00:00:00'),
(22, '2026-08-01', 28, 1.09, 1.11, 1, 0, '2026-08-01 00:00:00'),
(22, '2026-09-01', 29, 0.68, 0.72, 1, 0, '2026-09-01 00:00:00'),
(23, '2026-06-01', 21, 0.60, 0.65, 1, 0, '2026-06-01 00:00:00'),
(23, '2026-07-01', 27, 1.34, 1.30, 1, 0, '2026-07-01 00:00:00'),
(23, '2026-08-01', 27, 1.07, 1.11, 1, 0, '2026-08-01 00:00:00'),
(23, '2026-09-01', 25, 0.69, 0.76, 1, 0, '2026-09-01 00:00:00'),
(24, '2026-06-01', 27, 1.02, 1.07, 1, 0, '2026-06-01 00:00:00'),
(24, '2026-07-01', 28, 1.16, 1.21, 1, 0, '2026-07-01 00:00:00'),
(24, '2026-08-01', 27, 0.67, 0.62, 1, 0, '2026-08-01 00:00:00'),
(24, '2026-09-01', 29, 0.83, 0.87, 1, 0, '2026-09-01 00:00:00'),
(25, '2026-06-01', 21, 1.88, 2.03, 1, 0, '2026-06-01 00:00:00'),
(25, '2026-07-01', 30, 2.48, 2.41, 1, 0, '2026-07-01 00:00:00'),
(25, '2026-08-01', 30, 1.22, 1.22, 1, 0, '2026-08-01 00:00:00'),
(25, '2026-09-01', 27, 1.37, 1.38, 1, 0, '2026-09-01 00:00:00'),
(26, '2026-06-01', 22, 2.98, 2.72, 1, 0, '2026-06-01 00:00:00'),
(26, '2026-07-01', 25, 3.45, 3.24, 1, 0, '2026-07-01 00:00:00'),
(26, '2026-08-01', 26, 3.19, 2.95, 1, 0, '2026-08-01 00:00:00'),
(26, '2026-09-01', 27, 3.18, 3.04, 1, 0, '2026-09-01 00:00:00'),
(27, '2026-06-01', 27, 1.38, 1.43, 1, 0, '2026-06-01 00:00:00'),
(27, '2026-07-01', 27, 2.04, 2.04, 1, 0, '2026-07-01 00:00:00'),
(27, '2026-08-01', 27, 1.08, 1.00, 1, 0, '2026-08-01 00:00:00'),
(27, '2026-09-01', 27, 1.20, 1.14, 1, 0, '2026-09-01 00:00:00'),
(28, '2026-06-01', 29, 0.74, 0.77, 1, 0, '2026-06-01 00:00:00'),
(28, '2026-07-01', 29, 0.72, 0.74, 1, 0, '2026-07-01 00:00:00'),
(28, '2026-08-01', 30, 1.21, 1.27, 1, 0, '2026-08-01 00:00:00'),
(28, '2026-09-01', 27, 1.21, 1.14, 1, 0, '2026-09-01 00:00:00'),
(29, '2026-06-01', 20, 2.42, 2.66, 1, 0, '2026-06-01 00:00:00'),
(29, '2026-07-01', 21, 3.04, 2.97, 1, 0, '2026-07-01 00:00:00'),
(29, '2026-08-01', 26, 1.98, 1.96, 1, 0, '2026-08-01 00:00:00'),
(29, '2026-09-01', 22, 1.47, 1.49, 1, 0, '2026-09-01 00:00:00'),
(30, '2026-06-01', 27, 2.93, 3.08, 1, 0, '2026-06-01 00:00:00'),
(30, '2026-07-01', 27, 2.64, 2.72, 1, 0, '2026-07-01 00:00:00'),
(30, '2026-08-01', 29, 2.87, 2.85, 1, 0, '2026-08-01 00:00:00'),
(30, '2026-09-01', 22, 2.62, 2.62, 1, 0, '2026-09-01 00:00:00'),
(31, '2026-06-01', 25, 2.07, 1.89, 1, 0, '2026-06-01 00:00:00'),
(31, '2026-07-01', 22, 1.61, 1.72, 1, 0, '2026-07-01 00:00:00'),
(31, '2026-08-01', 29, 1.32, 1.20, 1, 0, '2026-08-01 00:00:00'),
(31, '2026-09-01', 25, 1.97, 1.92, 1, 0, '2026-09-01 00:00:00'),
(32, '2026-06-01', 24, 1.58, 1.61, 1, 0, '2026-06-01 00:00:00'),
(32, '2026-07-01', 21, 2.66, 2.86, 1, 0, '2026-07-01 00:00:00'),
(32, '2026-08-01', 22, 1.38, 1.25, 1, 0, '2026-08-01 00:00:00'),
(32, '2026-09-01', 27, 1.72, 1.77, 1, 0, '2026-09-01 00:00:00'),
(33, '2026-06-01', 25, 0.00, 0.00, 1, 0, '2026-06-01 00:00:00'),
(33, '2026-07-01', 29, 0.00, 0.00, 1, 0, '2026-07-01 00:00:00'),
(33, '2026-08-01', 30, 0.00, 0.00, 1, 0, '2026-08-01 00:00:00'),
(33, '2026-09-01', 30, 0.00, 0.00, 1, 0, '2026-09-01 00:00:00'),
(34, '2026-06-01', 28, 2.46, 2.32, 1, 0, '2026-06-01 00:00:00'),
(34, '2026-07-01', 24, 1.62, 1.78, 1, 0, '2026-07-01 00:00:00'),
(34, '2026-08-01', 23, 1.84, 1.89, 1, 0, '2026-08-01 00:00:00'),
(34, '2026-09-01', 29, 2.73, 2.51, 1, 0, '2026-09-01 00:00:00'),
(35, '2026-06-01', 30, 1.24, 1.32, 1, 0, '2026-06-01 00:00:00'),
(35, '2026-07-01', 24, 1.00, 0.99, 1, 0, '2026-07-01 00:00:00'),
(35, '2026-08-01', 23, 1.03, 1.01, 1, 0, '2026-08-01 00:00:00'),
(35, '2026-09-01', 28, 0.80, 0.79, 1, 0, '2026-09-01 00:00:00'),
(36, '2026-06-01', 23, 1.06, 1.09, 1, 0, '2026-06-01 00:00:00'),
(36, '2026-07-01', 27, 1.26, 1.20, 1, 0, '2026-07-01 00:00:00'),
(36, '2026-08-01', 29, 1.11, 1.19, 1, 0, '2026-08-01 00:00:00'),
(36, '2026-09-01', 29, 1.33, 1.39, 1, 0, '2026-09-01 00:00:00'),
(37, '2026-06-01', 26, 1.61, 1.58, 1, 0, '2026-06-01 00:00:00'),
(37, '2026-07-01', 21, 1.71, 1.76, 1, 0, '2026-07-01 00:00:00'),
(37, '2026-08-01', 24, 1.70, 1.81, 1, 0, '2026-08-01 00:00:00'),
(37, '2026-09-01', 24, 1.49, 1.55, 1, 0, '2026-09-01 00:00:00'),
(38, '2026-06-01', 27, 1.70, 1.72, 1, 0, '2026-06-01 00:00:00'),
(38, '2026-07-01', 30, 1.90, 2.05, 1, 0, '2026-07-01 00:00:00'),
(38, '2026-08-01', 24, 1.52, 1.41, 1, 0, '2026-08-01 00:00:00'),
(38, '2026-09-01', 24, 1.61, 1.66, 1, 0, '2026-09-01 00:00:00'),
(39, '2026-06-01', 21, 2.58, 2.48, 1, 0, '2026-06-01 00:00:00'),
(39, '2026-07-01', 21, 1.68, 1.81, 1, 0, '2026-07-01 00:00:00'),
(39, '2026-08-01', 25, 1.85, 1.91, 1, 0, '2026-08-01 00:00:00'),
(39, '2026-09-01', 26, 2.62, 2.85, 1, 0, '2026-09-01 00:00:00'),
(40, '2026-06-01', 29, 4.07, 4.44, 1, 0, '2026-06-01 00:00:00'),
(40, '2026-07-01', 24, 5.38, 5.38, 1, 0, '2026-07-01 00:00:00'),
(40, '2026-08-01', 29, 2.69, 2.49, 1, 0, '2026-08-01 00:00:00'),
(40, '2026-09-01', 25, 4.98, 5.31, 1, 0, '2026-09-01 00:00:00'),
(41, '2026-06-01', 23, 1.71, 1.87, 1, 0, '2026-06-01 00:00:00'),
(41, '2026-07-01', 24, 2.38, 2.55, 1, 0, '2026-07-01 00:00:00'),
(41, '2026-08-01', 28, 1.61, 1.57, 1, 0, '2026-08-01 00:00:00'),
(41, '2026-09-01', 25, 3.40, 3.43, 1, 0, '2026-09-01 00:00:00'),
(42, '2026-06-01', 25, 1.30, 1.38, 1, 0, '2026-06-01 00:00:00'),
(42, '2026-07-01', 29, 0.82, 0.74, 1, 0, '2026-07-01 00:00:00'),
(42, '2026-08-01', 20, 1.58, 1.64, 1, 0, '2026-08-01 00:00:00'),
(42, '2026-09-01', 23, 1.64, 1.56, 1, 0, '2026-09-01 00:00:00'),
(43, '2026-06-01', 23, 1.80, 1.93, 1, 0, '2026-06-01 00:00:00'),
(43, '2026-07-01', 26, 1.59, 1.73, 1, 0, '2026-07-01 00:00:00'),
(43, '2026-08-01', 24, 2.34, 2.15, 1, 0, '2026-08-01 00:00:00'),
(43, '2026-09-01', 23, 2.20, 2.11, 1, 0, '2026-09-01 00:00:00'),
(44, '2026-06-01', 20, 1.95, 1.86, 1, 0, '2026-06-01 00:00:00'),
(44, '2026-07-01', 27, 1.16, 1.15, 1, 0, '2026-07-01 00:00:00'),
(44, '2026-08-01', 25, 1.63, 1.70, 1, 0, '2026-08-01 00:00:00'),
(44, '2026-09-01', 21, 2.28, 2.43, 1, 0, '2026-09-01 00:00:00'),
(45, '2026-06-01', 27, 1.58, 1.64, 1, 0, '2026-06-01 00:00:00'),
(45, '2026-07-01', 30, 1.61, 1.66, 1, 0, '2026-07-01 00:00:00'),
(45, '2026-08-01', 30, 1.47, 1.36, 1, 0, '2026-08-01 00:00:00'),
(45, '2026-09-01', 30, 1.22, 1.17, 1, 0, '2026-09-01 00:00:00'),
(46, '2026-06-01', 29, 0.70, 0.73, 1, 0, '2026-06-01 00:00:00'),
(46, '2026-07-01', 25, 1.23, 1.22, 1, 0, '2026-07-01 00:00:00'),
(46, '2026-08-01', 22, 1.30, 1.24, 1, 0, '2026-08-01 00:00:00'),
(46, '2026-09-01', 25, 1.15, 1.22, 1, 0, '2026-09-01 00:00:00'),
(47, '2026-06-01', 23, 1.96, 1.77, 1, 0, '2026-06-01 00:00:00'),
(47, '2026-07-01', 28, 0.93, 0.96, 1, 0, '2026-07-01 00:00:00'),
(47, '2026-08-01', 21, 1.65, 1.81, 1, 0, '2026-08-01 00:00:00'),
(47, '2026-09-01', 22, 1.14, 1.04, 1, 0, '2026-09-01 00:00:00'),
(48, '2026-06-01', 28, 1.83, 1.81, 1, 0, '2026-06-01 00:00:00'),
(48, '2026-07-01', 27, 4.01, 4.27, 1, 0, '2026-07-01 00:00:00'),
(48, '2026-08-01', 23, 2.99, 3.12, 1, 0, '2026-08-01 00:00:00'),
(48, '2026-09-01', 24, 2.26, 2.16, 1, 0, '2026-09-01 00:00:00'),
(49, '2026-06-01', 30, 0.83, 0.78, 1, 0, '2026-06-01 00:00:00'),
(49, '2026-07-01', 22, 0.74, 0.67, 1, 0, '2026-07-01 00:00:00'),
(49, '2026-08-01', 23, 1.38, 1.41, 1, 0, '2026-08-01 00:00:00'),
(49, '2026-09-01', 25, 1.33, 1.35, 1, 0, '2026-09-01 00:00:00'),
(50, '2026-06-01', 23, 0.92, 0.96, 1, 0, '2026-06-01 00:00:00'),
(50, '2026-07-01', 29, 1.17, 1.11, 1, 0, '2026-07-01 00:00:00'),
(50, '2026-08-01', 20, 0.68, 0.62, 1, 0, '2026-08-01 00:00:00'),
(50, '2026-09-01', 27, 1.34, 1.45, 1, 0, '2026-09-01 00:00:00'),
(51, '2026-06-01', 24, 1.75, 1.75, 1, 0, '2026-06-01 00:00:00'),
(51, '2026-07-01', 26, 2.49, 2.58, 1, 0, '2026-07-01 00:00:00'),
(51, '2026-08-01', 28, 1.94, 1.76, 1, 0, '2026-08-01 00:00:00'),
(51, '2026-09-01', 22, 2.04, 2.04, 1, 0, '2026-09-01 00:00:00');
INSERT INTO `demanda_forecast_historico` (`fk_catalogo_SKU`, `fecha_vigencia`, `dias_disponibles`, `ventas_mensualizadas_core`, `demanda_final_est`, `mes_valido`, `es_pico`, `fecha_calculo`) VALUES
(52, '2026-06-01', 21, 2.50, 2.41, 1, 0, '2026-06-01 00:00:00'),
(52, '2026-07-01', 27, 4.84, 5.20, 1, 0, '2026-07-01 00:00:00'),
(52, '2026-08-01', 25, 4.44, 4.82, 1, 0, '2026-08-01 00:00:00'),
(52, '2026-09-01', 24, 2.89, 2.96, 1, 0, '2026-09-01 00:00:00'),
(53, '2026-06-01', 22, 2.79, 2.82, 1, 0, '2026-06-01 00:00:00'),
(53, '2026-07-01', 30, 2.68, 2.84, 1, 0, '2026-07-01 00:00:00'),
(53, '2026-08-01', 22, 1.29, 1.18, 1, 0, '2026-08-01 00:00:00'),
(53, '2026-09-01', 27, 1.49, 1.42, 1, 0, '2026-09-01 00:00:00'),
(54, '2026-06-01', 28, 1.48, 1.48, 1, 0, '2026-06-01 00:00:00'),
(54, '2026-07-01', 22, 1.66, 1.54, 1, 0, '2026-07-01 00:00:00'),
(54, '2026-08-01', 24, 1.13, 1.06, 1, 0, '2026-08-01 00:00:00'),
(54, '2026-09-01', 28, 1.23, 1.31, 1, 0, '2026-09-01 00:00:00'),
(55, '2026-06-01', 22, 1.21, 1.19, 1, 0, '2026-06-01 00:00:00'),
(55, '2026-07-01', 27, 0.66, 0.68, 1, 0, '2026-07-01 00:00:00'),
(55, '2026-08-01', 20, 1.31, 1.25, 1, 0, '2026-08-01 00:00:00'),
(55, '2026-09-01', 21, 1.39, 1.36, 1, 0, '2026-09-01 00:00:00'),
(56, '2026-06-01', 30, 1.90, 1.89, 1, 0, '2026-06-01 00:00:00'),
(56, '2026-07-01', 24, 1.65, 1.68, 1, 0, '2026-07-01 00:00:00'),
(56, '2026-08-01', 20, 0.91, 0.94, 1, 0, '2026-08-01 00:00:00'),
(56, '2026-09-01', 25, 2.04, 2.22, 1, 0, '2026-09-01 00:00:00'),
(57, '2026-06-01', 24, 2.17, 2.09, 1, 0, '2026-06-01 00:00:00'),
(57, '2026-07-01', 21, 1.13, 1.14, 1, 0, '2026-07-01 00:00:00'),
(57, '2026-08-01', 21, 1.89, 1.85, 1, 0, '2026-08-01 00:00:00'),
(57, '2026-09-01', 26, 1.30, 1.19, 1, 0, '2026-09-01 00:00:00'),
(58, '2026-06-01', 21, 1.12, 1.07, 1, 0, '2026-06-01 00:00:00'),
(58, '2026-07-01', 24, 1.24, 1.34, 1, 0, '2026-07-01 00:00:00'),
(58, '2026-08-01', 25, 1.08, 1.12, 1, 0, '2026-08-01 00:00:00'),
(58, '2026-09-01', 28, 1.27, 1.19, 1, 0, '2026-09-01 00:00:00');

-- precio_ml_sugerido (57 filas)
INSERT INTO `precio_ml_sugerido` (`id`, `fk_catalogo_SKU`, `fecha_calculo`, `tipo_cambio`, `costo_libro_usd`, `costo_envio_editorial_usd`, `costo_adquisicion`, `costo_preparacion`, `precio_core`, `comision_fija`, `envio_meli`, `pct_comisiones_impuestos`, `precio_base`, `factor_ajuste`, `precio_publicado`, `ganancia_neta`, `calculado_en`) VALUES
(1, 2, '2026-09-29', 1284.3279, 14.6688, 2.0027, 21411.67, 350.00, 25601.96, 0.00, 1404.52, 0.175000, 32735.13, 100, 32835.13, 3922.79, '2026-09-29 00:00:00'),
(2, 3, '2026-09-29', 1284.3279, 15.1050, 2.3203, 22379.80, 350.00, 34968.92, 0.00, 1449.99, 0.175000, 44144.13, -100, 44144.13, 12239.12, '2026-09-29 00:00:00'),
(3, 4, '2026-09-29', 1284.3279, 8.8074, 2.9897, 15151.35, 350.00, 23848.23, 0.00, 1698.03, 0.175000, 30965.16, -100, 30965.16, 8346.88, '2026-09-29 00:00:00'),
(4, 5, '2026-09-29', 1284.3279, 11.4398, 2.5029, 17907.00, 350.00, 33194.55, 0.00, 1020.83, 0.175000, 41473.19, 200, 41673.19, 15102.55, '2026-09-29 00:00:00'),
(5, 6, '2026-09-29', 1284.3279, 14.2676, 1.7227, 20536.79, 350.00, 32133.52, 0.00, 1502.58, 0.175000, 40771.03, 0, 40771.03, 11246.73, '2026-09-29 00:00:00'),
(6, 7, '2026-09-29', 1284.3279, 4.7488, 2.5485, 9372.13, 350.00, 10567.53, 180.00, 1827.73, 0.175000, 15242.74, -100, 15242.74, 845.40, '2026-09-29 00:00:00'),
(7, 8, '2026-09-29', 1284.3279, 9.8956, 2.2237, 15565.16, 350.00, 24484.86, 0.00, 1741.39, 0.175000, 31789.39, 0, 31789.39, 8569.70, '2026-09-29 00:00:00'),
(8, 9, '2026-09-29', 1284.3279, 16.5358, 1.5849, 23272.92, 350.00, 36342.95, 0.00, 1468.56, 0.175000, 45832.13, -100, 45832.13, 12720.03, '2026-09-29 00:00:00'),
(9, 10, '2026-09-29', 1284.3279, 18.0115, 1.6111, 25201.85, 350.00, 32758.78, 0.00, 2179.44, 0.175000, 42349.36, 100, 42449.36, 7289.43, '2026-09-29 00:00:00'),
(10, 11, '2026-09-29', 1284.3279, 9.2973, 3.0722, 15886.49, 350.00, 23194.99, 0.00, 1580.02, 0.175000, 30030.32, 100, 30130.32, 7041.00, '2026-09-29 00:00:00'),
(11, 12, '2026-09-29', 1284.3279, 14.4894, 2.3350, 21608.05, 350.00, 33781.62, 0.00, 1616.29, 0.175000, 42906.56, 0, 42906.56, 11823.57, '2026-09-29 00:00:00'),
(12, 13, '2026-09-29', 1284.3279, 9.3765, 2.1862, 14850.30, 350.00, 16522.07, 0.00, 1563.85, 0.175000, 21922.33, -100, 21922.33, 1321.77, '2026-09-29 00:00:00'),
(13, 14, '2026-09-29', 1284.3279, 11.2892, 1.0551, 15854.13, 350.00, 19063.68, 0.00, 1759.11, 0.175000, 25239.75, 200, 25439.75, 3024.55, '2026-09-29 00:00:00'),
(14, 15, '2026-09-29', 1284.3279, 12.9060, 2.9946, 20421.58, 350.00, 31956.28, 0.00, 1362.09, 0.175000, 40385.90, 200, 40585.90, 11349.70, '2026-09-29 00:00:00'),
(15, 16, '2026-09-29', 1284.3279, 13.8288, 1.0208, 19071.76, 350.00, 27745.37, 0.00, 1554.48, 0.175000, 35514.97, 0, 35514.97, 8323.61, '2026-09-29 00:00:00'),
(16, 17, '2026-09-29', 1284.3279, 12.7244, 2.7994, 19937.65, 350.00, 22051.79, 0.00, 1501.74, 0.175000, 28549.73, 0, 28549.73, 1764.14, '2026-09-29 00:00:00'),
(17, 18, '2026-09-29', 1284.3279, 15.9700, 3.0759, 24461.18, 350.00, 35444.54, 0.00, 958.84, 0.175000, 44125.31, -100, 44125.31, 10633.36, '2026-09-29 00:00:00'),
(18, 19, '2026-09-29', 1284.3279, 11.0754, 3.1672, 18292.17, 350.00, 28680.26, 0.00, 1286.94, 0.175000, 36323.88, 200, 36523.88, 10203.09, '2026-09-29 00:00:00'),
(19, 20, '2026-09-29', 1284.3279, 15.0858, 2.7551, 22913.57, 350.00, 29825.09, 0.00, 1884.56, 0.175000, 38435.94, -100, 38435.94, 6561.52, '2026-09-29 00:00:00'),
(20, 21, '2026-09-29', 1284.3279, 5.7627, 2.4843, 10591.85, 350.00, 14028.01, 180.00, 1244.60, 0.175000, 18730.44, 0, 18730.44, 3086.16, '2026-09-29 00:00:00'),
(21, 22, '2026-09-29', 1284.3279, 12.3648, 1.3699, 17639.86, 350.00, 19554.20, 0.00, 1001.69, 0.175000, 24916.23, 200, 25116.23, 1729.34, '2026-09-29 00:00:00'),
(22, 23, '2026-09-29', 1284.3279, 15.4076, 1.5002, 21715.16, 350.00, 33946.40, 0.00, 1775.43, 0.175000, 43299.19, -100, 43299.19, 11881.24, '2026-09-29 00:00:00'),
(23, 24, '2026-09-29', 1284.3279, 16.8026, 2.2428, 24460.54, 350.00, 29188.87, 0.00, 907.60, 0.175000, 36480.57, 0, 36480.57, 4378.33, '2026-09-29 00:00:00'),
(24, 25, '2026-09-29', 1284.3279, 15.5880, 0.8359, 21093.67, 350.00, 32990.26, 0.00, 1752.54, 0.175000, 42112.48, -100, 42112.48, 11546.59, '2026-09-29 00:00:00'),
(25, 26, '2026-09-29', 1284.3279, 12.7190, 2.6679, 19761.83, 350.00, 28731.19, 0.00, 2029.41, 0.175000, 37285.58, 200, 37485.58, 8784.36, '2026-09-29 00:00:00'),
(26, 27, '2026-09-29', 1284.3279, 6.6304, 2.7600, 12060.35, 350.00, 15910.71, 0.00, 1293.64, 0.175000, 20853.76, 200, 21053.76, 3665.36, '2026-09-29 00:00:00'),
(27, 28, '2026-09-29', 1284.3279, 8.8850, 1.7740, 13689.65, 350.00, 16517.24, 0.00, 1775.94, 0.175000, 22173.55, -100, 22173.55, 2477.59, '2026-09-29 00:00:00'),
(28, 29, '2026-09-29', 1284.3279, 5.0643, 2.9725, 10321.89, 350.00, 15245.56, 0.00, 1013.93, 0.175000, 19708.47, 0, 19708.47, 4573.67, '2026-09-29 00:00:00'),
(29, 30, '2026-09-29', 1284.3279, 20.0256, 0.8375, 26795.06, 350.00, 29505.50, 0.00, 1045.49, 0.175000, 37031.50, 0, 37031.50, 2360.44, '2026-09-29 00:00:00'),
(30, 31, '2026-09-29', 1284.3279, 12.9703, 2.6793, 20099.22, 350.00, 29213.17, 0.00, 1144.69, 0.175000, 36797.41, 0, 36797.41, 8763.95, '2026-09-29 00:00:00'),
(31, 32, '2026-09-29', 1284.3279, 16.1100, 1.3649, 22443.50, 350.00, 32562.14, 0.00, 1743.21, 0.175000, 41582.24, 0, 41582.24, 9768.64, '2026-09-29 00:00:00'),
(32, 33, '2026-09-29', 1284.3279, 11.3277, 1.9766, 17087.08, 350.00, 26826.28, 0.00, 1713.88, 0.175000, 34594.13, 200, 34794.13, 9554.20, '2026-09-29 00:00:00'),
(33, 34, '2026-09-29', 1284.3279, 9.1697, 1.3155, 13466.44, 350.00, 21256.06, 0.00, 1291.19, 0.175000, 27330.00, -100, 27330.00, 7439.62, '2026-09-29 00:00:00'),
(34, 35, '2026-09-29', 1284.3279, 9.8686, 1.2000, 14215.71, 350.00, 20808.16, 0.00, 1448.44, 0.175000, 26977.70, 0, 26977.70, 6242.45, '2026-09-29 00:00:00'),
(35, 36, '2026-09-29', 1284.3279, 11.1447, 1.2485, 15916.93, 350.00, 23238.47, 0.00, 1098.15, 0.175000, 29498.93, -100, 29498.93, 6971.54, '2026-09-29 00:00:00'),
(36, 37, '2026-09-29', 1284.3279, 14.7906, 3.4024, 23365.78, 350.00, 33879.69, 0.00, 1512.94, 0.175000, 42900.16, -100, 42900.16, 10163.91, '2026-09-29 00:00:00'),
(37, 38, '2026-09-29', 1284.3279, 9.5445, 2.3801, 15315.10, 350.00, 17027.28, 0.00, 1161.74, 0.175000, 22047.30, 200, 22247.30, 1527.18, '2026-09-29 00:00:00'),
(38, 39, '2026-09-29', 1284.3279, 15.3762, 3.0395, 23651.80, 350.00, 28237.41, 0.00, 1409.25, 0.175000, 35935.35, 100, 36035.35, 4318.11, '2026-09-29 00:00:00'),
(39, 40, '2026-09-29', 1284.3279, 3.6720, 0.8213, 5770.87, 350.00, 8744.10, 180.00, 1719.53, 0.175000, 12901.37, -100, 12901.37, 2623.23, '2026-09-29 00:00:00'),
(40, 41, '2026-09-29', 1284.3279, 8.9326, 3.4446, 15896.38, 350.00, 23209.11, 0.00, 2003.20, 0.175000, 30560.38, 200, 30760.38, 7127.73, '2026-09-29 00:00:00'),
(41, 42, '2026-09-29', 1284.3279, 10.7665, 2.4088, 16921.41, 350.00, 22142.83, 0.00, 1620.60, 0.175000, 28804.16, 100, 28904.16, 4953.92, '2026-09-29 00:00:00'),
(42, 43, '2026-09-29', 1284.3279, 5.3924, 0.8999, 8081.38, 350.00, 9164.54, 180.00, 1419.58, 0.175000, 13047.42, 200, 13247.42, 898.16, '2026-09-29 00:00:00'),
(43, 44, '2026-09-29', 1284.3279, 12.3300, 2.3958, 18912.76, 350.00, 27518.23, 0.00, 1694.94, 0.175000, 35409.90, -100, 35409.90, 8255.47, '2026-09-29 00:00:00'),
(44, 45, '2026-09-29', 1284.3279, 10.2714, 1.4261, 15023.43, 350.00, 18086.39, 0.00, 978.92, 0.175000, 23109.47, 0, 23109.47, 2712.96, '2026-09-29 00:00:00'),
(45, 46, '2026-09-29', 1284.3279, 7.1338, 1.9394, 11652.96, 350.00, 18466.09, 0.00, 1310.61, 0.175000, 23971.76, 0, 23971.76, 6463.13, '2026-09-29 00:00:00'),
(46, 47, '2026-09-29', 1284.3279, 17.2260, 1.5232, 24080.12, 350.00, 37584.80, 0.00, 1742.79, 0.175000, 47669.81, -100, 47669.81, 13154.68, '2026-09-29 00:00:00'),
(47, 48, '2026-09-29', 1284.3279, 5.9200, 1.1157, 9036.15, 350.00, 17065.73, 0.00, 1709.51, 0.175000, 22757.87, 100, 22857.87, 7762.08, '2026-09-29 00:00:00'),
(48, 49, '2026-09-29', 1284.3279, 9.8748, 2.0105, 15264.62, 350.00, 28390.22, 0.00, 1467.10, 0.175000, 36190.69, 0, 36190.69, 12775.60, '2026-09-29 00:00:00'),
(49, 50, '2026-09-29', 1284.3279, 12.4135, 1.5776, 17969.16, 350.00, 33307.56, 0.00, 1149.86, 0.175000, 41766.57, 100, 41866.57, 15070.90, '2026-09-29 00:00:00'),
(50, 51, '2026-09-29', 1284.3279, 4.7188, 1.9829, 8607.18, 350.00, 11483.56, 180.00, 1559.93, 0.175000, 16028.47, 200, 16228.47, 2691.38, '2026-09-29 00:00:00'),
(51, 52, '2026-09-29', 1284.3279, 9.8117, 3.2545, 16781.29, 350.00, 24473.27, 0.00, 1340.90, 0.175000, 31289.90, 200, 31489.90, 7506.98, '2026-09-29 00:00:00'),
(52, 53, '2026-09-29', 1284.3279, 16.7620, 3.1043, 25514.84, 350.00, 28113.96, 0.00, 1829.76, 0.175000, 36295.42, -100, 36295.42, 2249.12, '2026-09-29 00:00:00'),
(53, 54, '2026-09-29', 1284.3279, 8.1977, 1.1541, 12010.78, 350.00, 14542.09, 180.00, 1281.41, 0.175000, 19398.18, -100, 19398.18, 2181.31, '2026-09-29 00:00:00'),
(54, 55, '2026-09-29', 1284.3279, 9.9918, 3.3915, 17188.55, 350.00, 31888.27, 0.00, 1983.00, 0.175000, 41056.08, 100, 41156.08, 14432.22, '2026-09-29 00:00:00'),
(55, 56, '2026-09-29', 1284.3279, 4.8836, 2.9491, 10059.76, 350.00, 13345.85, 180.00, 1939.68, 0.175000, 18746.10, 0, 18746.10, 2936.09, '2026-09-29 00:00:00'),
(56, 57, '2026-09-29', 1284.3279, 16.5625, 2.4790, 24455.53, 350.00, 38162.35, 0.00, 1267.19, 0.175000, 47793.38, 0, 47793.38, 13356.82, '2026-09-29 00:00:00'),
(57, 58, '2026-09-29', 1284.3279, 12.9115, 2.6011, 19923.27, 350.00, 25991.37, 0.00, 1067.83, 0.175000, 32799.03, 0, 32799.03, 5718.10, '2026-09-29 00:00:00');

-- registro_operaciones (45 filas)
INSERT INTO `registro_operaciones` (`id`, `fecha`, `fk_categorias_costos_id`, `detalle`, `valor`, `notas`) VALUES
(1, '2026-09-03', 3, 'Flete a deposito propio', -19940.32, NULL),
(2, '2026-07-30', 8, 'Honorarios contables', -5631.11, NULL),
(3, '2026-06-29', 1, 'Pago mercaderia pedido editorial', -9247.57, NULL),
(4, '2026-03-01', 3, 'Envio interno a centro Full', -21556.81, NULL),
(5, '2026-03-06', 9, 'Gastos varios de oficina', -2059.81, NULL),
(6, '2026-04-23', 7, 'Alquiler deposito mensual', -6053.91, NULL),
(7, '2026-05-27', 9, 'Gastos varios de oficina', -6816.64, NULL),
(8, '2026-03-16', 6, 'Promocion redes sociales', -1643.57, NULL),
(9, '2026-02-11', 9, 'Insumos de embalaje', -4203.87, NULL),
(10, '2026-04-01', 9, 'Gastos varios de oficina', -1735.34, NULL),
(11, '2026-01-25', 8, 'Honorarios contables', -21119.13, NULL),
(12, '2026-03-12', 2, 'Flete internacional pedido editorial', -15459.03, NULL),
(13, '2026-05-22', 2, 'Flete internacional pedido editorial', -3082.57, NULL),
(14, '2026-02-07', 2, 'Flete internacional pedido editorial', -9360.14, NULL),
(15, '2026-03-17', 5, 'Percepciones IVA', -12894.47, NULL),
(16, '2026-04-16', 2, 'Flete internacional pedido editorial', -9411.55, NULL),
(17, '2026-02-23', 3, 'Envio interno a centro Full', -5446.31, NULL),
(18, '2026-07-28', 7, 'Alquiler deposito mensual', -20952.93, NULL),
(19, '2026-07-17', 8, 'Honorarios contables', -12873.06, NULL),
(20, '2026-06-25', 2, 'Ajuste de flete por sobrepeso', -18022.39, NULL),
(21, '2026-04-20', 7, 'Expensas deposito', -16792.38, NULL),
(22, '2026-03-11', 3, 'Flete a deposito propio', -6090.46, NULL),
(23, '2026-02-05', 7, 'Expensas deposito', -10528.08, NULL),
(24, '2026-01-30', 8, 'Honorarios contables', -1229.19, NULL),
(25, '2026-03-29', 3, 'Envio interno a centro Full', -20253.05, NULL),
(26, '2026-07-04', 2, 'Flete internacional pedido editorial', -8212.71, NULL),
(27, '2026-09-13', 3, 'Flete a deposito propio', -10135.02, NULL),
(28, '2026-02-09', 1, 'Pago mercaderia pedido editorial', -24454.46, NULL),
(29, '2026-06-13', 9, 'Insumos de embalaje', -10349.07, NULL),
(30, '2026-03-28', 9, 'Insumos de embalaje', -18696.09, NULL),
(31, '2026-03-01', 6, 'Campana de publicidad en MELI', -7354.63, NULL),
(32, '2026-04-02', 9, 'Gastos varios de oficina', -10396.48, NULL),
(33, '2026-04-03', 4, 'Ajuste de comisiones', -8958.64, NULL),
(34, '2026-02-15', 7, 'Alquiler deposito mensual', -7887.52, NULL),
(35, '2026-06-21', 1, 'Reembolso parcial pedido', -18631.28, NULL),
(36, '2026-08-05', 3, 'Flete a deposito propio', -2774.08, NULL),
(37, '2026-05-18', 9, 'Insumos de embalaje', -8847.37, NULL),
(38, '2026-09-21', 3, 'Envio interno a centro Full', -22312.82, NULL),
(39, '2026-07-29', 9, 'Insumos de embalaje', -20889.61, NULL),
(40, '2026-05-22', 5, 'Percepciones IVA', -3205.83, NULL),
(41, '2026-07-24', 1, 'Reembolso parcial pedido', -9184.60, NULL),
(42, '2026-06-06', 1, 'Pago mercaderia pedido editorial', -18553.04, NULL),
(43, '2026-07-30', 8, 'Honorarios contables', -20232.00, NULL),
(44, '2026-07-01', 9, 'Gastos varios de oficina', -7830.44, NULL),
(45, '2026-05-18', 3, 'Flete a deposito propio', -18569.05, NULL);

-- registro_cambios (6 filas)
INSERT INTO `registro_cambios` (`id_evento`, `fecha`, `accion`, `comentario`, `resultado`, `fecha_evaluacion`) VALUES
(1, '2026-06-01', 'Actualizacion de politica de margenes', 'Se redefinieron los rangos de margen A-E y su relacion con inactivo.', 'Aplicado en catalogo activo', '2026-06-09'),
(2, '2026-06-26', 'Cambio de metodo de envio principal', 'Se evaluo pasar de maritimo a aereo para reducir lead time.', 'Se mantuvo mixto segun editorial', '2026-07-11'),
(3, '2026-07-31', 'Revision de tarifas de envio MELI', 'Actualizacion de tramos de peso y costo por cambios de la plataforma.', 'Tarifas actualizadas', '2026-08-11'),
(4, '2026-08-15', 'Incorporacion de forecast de demanda', 'Se implemento el modelo de shrinkage hacia pares para estimar demanda.', 'En produccion', '2026-08-31'),
(5, '2026-09-09', 'Ajuste de stock de seguridad', 'Se recalcularon los dias de stock confiable y parcial.', 'Parametros actualizados', '2026-09-28'),
(6, '2026-09-24', 'Automatizacion de asientos de pedidos', 'Registro automatico de costos de mercaderia y envio al cargar un pedido.', 'Implementado', '2026-10-02');

/*!50003 DROP FUNCTION IF EXISTS `fn_redondear_precio_ml` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_redondear_precio_ml`(precio DECIMAL(12, 2)) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
    IF precio IS NULL OR precio <= 0 THEN
        RETURN 0;
    END IF;

    IF precio < 10000 THEN
        RETURN CEIL(precio / 100) * 100 - 10;
    ELSEIF precio < 50000 THEN
        RETURN CEIL(precio / 500) * 500 - 100;
    ELSE
        RETURN CEIL(precio / 1000) * 1000 - 100;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_actualizar_margen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_margen`(
    IN  p_titulo_busqueda VARCHAR(50),   -- obligatorio si no hay SKU
    IN  p_sku             SMALLINT,      -- opcional
    IN  p_margen_nuevo    VARCHAR(3),    -- ej. 'A', 'B', 'C', 'D'
    IN  p_formato         VARCHAR(20),   -- opcional: 'Blanda', 'Dura', etc.
    OUT p_filas_afectadas INT
)
BEGIN
    DECLARE v_margen_existe INT DEFAULT 0;
    IF p_sku IS NULL
       AND (p_titulo_busqueda IS NULL OR TRIM(p_titulo_busqueda) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar p_sku o p_titulo_busqueda';
    END IF;
    SET p_margen_nuevo = UPPER(TRIM(p_margen_nuevo));
    SELECT COUNT(*) INTO v_margen_existe
    FROM margenes
    WHERE id = p_margen_nuevo;
    IF v_margen_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Margen no valido: no existe en la tabla margenes';
    END IF;
    UPDATE catalogo
    SET
        fk_margenes_id = p_margen_nuevo,
        fecha_modificacion_margen = CURDATE()
    WHERE
        (p_sku IS NOT NULL AND SKU = p_sku)
        OR (
            p_sku IS NULL
            AND titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
            AND (
                p_formato IS NULL
                OR TRIM(p_formato) = ''
                OR formato = TRIM(p_formato)
            )
        );
    SET p_filas_afectadas = ROW_COUNT();
    -- Vista de precio estimado con el margen nuevo
    CALL sp_vista_precio_sugerido(p_sku, p_titulo_busqueda);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_consultar_stock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consultar_stock`(
    IN p_sku SMALLINT,
    IN p_titulo_busqueda VARCHAR(50)
)
BEGIN
    IF p_sku IS NULL AND (p_titulo_busqueda IS NULL OR TRIM(p_titulo_busqueda) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar p_sku o p_titulo_busqueda';
    END IF;

    SELECT
        c.SKU,
        c.titulo,
        c.ISBN,
        COALESCE(s.unidades_en_camino_desde_proveedor, 0) AS en_camino_proveedor,
        COALESCE(s.unidades_en_deposito, 0)               AS en_deposito,
        COALESCE(s.unidades_en_camino_hacia_full, 0)       AS en_camino_hacia_full,
        COALESCE(s.unidades_en_full, 0)                    AS en_full,
        COALESCE(s.unidades_en_devolucion, 0)              AS en_devolucion,
        COALESCE(s.unidades_en_full, 0)
            + COALESCE(s.unidades_en_deposito, 0)          AS vendible_inmediato,
        COALESCE(s.unidades_en_full, 0)
            + COALESCE(s.unidades_en_deposito, 0)
            + COALESCE(s.unidades_en_camino_hacia_full, 0) AS stock_vendible,
        COALESCE(s.unidades_en_full, 0)
            + COALESCE(s.unidades_en_deposito, 0)
            + COALESCE(s.unidades_en_camino_hacia_full, 0)
            + COALESCE(s.unidades_en_camino_desde_proveedor, 0) AS stock_posicion,
        COALESCE(s.unidades_en_camino_desde_proveedor, 0)
            + COALESCE(s.unidades_en_deposito, 0)
            + COALESCE(s.unidades_en_camino_hacia_full, 0)
            + COALESCE(s.unidades_en_full, 0)
            + COALESCE(s.unidades_en_devolucion, 0)        AS stock_total,
        s.fecha_ultima_actualizacion
    FROM catalogo c
    LEFT JOIN stock s ON s.fk_catalogo_SKU = c.SKU
    WHERE
        (p_sku IS NOT NULL AND c.SKU = p_sku)
        OR (
            p_sku IS NULL
            AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
        )
    ORDER BY c.titulo, c.SKU;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_libros_comprados_junto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_libros_comprados_junto`(
    IN p_sku SMALLINT,
    IN p_titulo_busqueda VARCHAR(50),
    IN p_limite INT
)
BEGIN
    DECLARE v_limite INT DEFAULT 25;
    DECLARE v_compradores_ancla INT DEFAULT 0;
    DECLARE v_unidades_ancla INT DEFAULT 0;

    IF p_sku IS NULL AND (p_titulo_busqueda IS NULL OR TRIM(p_titulo_busqueda) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar p_sku o p_titulo_busqueda';
    END IF;

    IF p_limite IS NOT NULL AND p_limite > 0 THEN
        SET v_limite = p_limite;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM catalogo c
        WHERE
            (p_sku IS NOT NULL AND c.SKU = p_sku)
            OR (
                p_sku IS NULL
                AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
            )
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se encontro ningun libro con ese criterio';
    END IF;

    SELECT COUNT(DISTINCT v.fk_clientes_id) INTO v_compradores_ancla
    FROM ventas v
    JOIN catalogo c ON c.SKU = v.fk_catalogo_SKU
    WHERE v.estado = 'concretada'
      AND v.fk_clientes_id IS NOT NULL
      AND v.fk_clientes_id <> 1
      AND (
          (p_sku IS NOT NULL AND c.SKU = p_sku)
          OR (
              p_sku IS NULL
              AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
          )
      );

    SELECT COALESCE(SUM(v.unidades), 0) INTO v_unidades_ancla
    FROM ventas v
    JOIN catalogo c ON c.SKU = v.fk_catalogo_SKU
    WHERE v.estado = 'concretada'
      AND (
          (p_sku IS NOT NULL AND c.SKU = p_sku)
          OR (
              p_sku IS NULL
              AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
          )
      );

    SELECT
        COUNT(DISTINCT c.SKU) AS ediciones_ancla,
        GROUP_CONCAT(DISTINCT c.titulo ORDER BY c.titulo SEPARATOR ' | ') AS titulos_ancla,
        v_unidades_ancla AS unidades_vendidas_total,
        COUNT(v.id) AS lineas_venta_total,
        v_compradores_ancla AS compradores_identificados,
        MIN(v.fecha_venta) AS primera_venta,
        MAX(v.fecha_venta) AS ultima_venta
    FROM ventas v
    JOIN catalogo c ON c.SKU = v.fk_catalogo_SKU
    WHERE v.estado = 'concretada'
      AND (
          (p_sku IS NOT NULL AND c.SKU = p_sku)
          OR (
              p_sku IS NULL
              AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
          )
      );

    SELECT
        c.SKU,
        c.titulo,
        c.ISBN,
        sub.nombre_subcategoria,
        COUNT(DISTINCT CASE
            WHEN v.fk_clientes_id IS NOT NULL AND v.fk_clientes_id <> 1
            THEN v.fk_clientes_id
        END) AS compradores_identificados,
        COUNT(v.id) AS lineas_venta,
        SUM(v.unidades) AS unidades_vendidas,
        MIN(v.fecha_venta) AS primera_venta,
        MAX(v.fecha_venta) AS ultima_venta
    FROM ventas v
    JOIN catalogo c ON c.SKU = v.fk_catalogo_SKU
    JOIN subcategorias sub ON sub.id = c.fk_subcategorias_id
    WHERE v.estado = 'concretada'
      AND (
          (p_sku IS NOT NULL AND c.SKU = p_sku)
          OR (
              p_sku IS NULL
              AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
          )
      )
    GROUP BY c.SKU, c.titulo, c.ISBN, sub.nombre_subcategoria
    ORDER BY c.titulo, c.SKU;

    SELECT
        c.SKU,
        c.titulo,
        c.ISBN,
        sub.nombre_subcategoria,
        seg.nombre_segmento,
        COUNT(DISTINCT v.fk_clientes_id) AS compradores_en_comun,
        SUM(v.unidades) AS unidades_vendidas_ancla,
        tot.unidades_vendidas_totales,
        ROUND(
            100.0 * SUM(v.unidades) / NULLIF(tot.unidades_vendidas_totales, 0),
            1
        ) AS pct_VENTAS_ancla,
        COALESCE(ped.veces_mismo_pedido_ml, 0) AS veces_mismo_pedido_ml,
        CASE
            WHEN c.fk_subcategorias_id IN (
                SELECT la.fk_subcategorias_id
                FROM catalogo la
                WHERE
                    (p_sku IS NOT NULL AND la.SKU = p_sku)
                    OR (
                        p_sku IS NULL
                        AND la.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
                    )
            ) THEN 'Si'
            ELSE 'No'
        END AS misma_subcategoria_que_ancla
    FROM ventas v
    JOIN catalogo c ON c.SKU = v.fk_catalogo_SKU
    JOIN subcategorias sub ON sub.id = c.fk_subcategorias_id
    JOIN segmentos seg ON seg.id = c.fk_segmentos_id
    JOIN (
        SELECT
            fk_catalogo_SKU AS SKU,
            SUM(unidades) AS unidades_vendidas_totales
        FROM ventas
        WHERE estado = 'concretada'
        GROUP BY fk_catalogo_SKU
    ) tot ON tot.SKU = c.SKU
    LEFT JOIN (
        SELECT
            v_otro.fk_catalogo_SKU AS SKU,
            COUNT(DISTINCT v_otro.id_pedido_ml) AS veces_mismo_pedido_ml
        FROM ventas v_ancla
        JOIN ventas v_otro
            ON v_otro.id_pedido_ml = v_ancla.id_pedido_ml
           AND v_otro.id_pedido_ml IS NOT NULL
           AND TRIM(v_otro.id_pedido_ml) <> ''
        JOIN catalogo c_ancla ON c_ancla.SKU = v_ancla.fk_catalogo_SKU
        WHERE v_ancla.estado = 'concretada'
          AND v_otro.estado = 'concretada'
          AND v_otro.fk_catalogo_SKU <> v_ancla.fk_catalogo_SKU
          AND (
              (p_sku IS NOT NULL AND c_ancla.SKU = p_sku)
              OR (
                  p_sku IS NULL
                  AND c_ancla.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
              )
          )
        GROUP BY v_otro.fk_catalogo_SKU
    ) ped ON ped.SKU = c.SKU
    WHERE v.estado = 'concretada'
      AND v.fk_clientes_id IS NOT NULL
      AND v.fk_clientes_id <> 1
      AND v.fk_clientes_id IN (
          SELECT DISTINCT v2.fk_clientes_id
          FROM ventas v2
          JOIN catalogo c2 ON c2.SKU = v2.fk_catalogo_SKU
          WHERE v2.estado = 'concretada'
            AND v2.fk_clientes_id IS NOT NULL
            AND v2.fk_clientes_id <> 1
            AND (
                (p_sku IS NOT NULL AND c2.SKU = p_sku)
                OR (
                    p_sku IS NULL
                    AND c2.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
                )
            )
      )
      AND c.SKU NOT IN (
          SELECT la.SKU
          FROM catalogo la
          WHERE
              (p_sku IS NOT NULL AND la.SKU = p_sku)
              OR (
                  p_sku IS NULL
                  AND la.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
              )
      )
    GROUP BY
        c.SKU,
        c.titulo,
        c.ISBN,
        c.fk_subcategorias_id,
        sub.nombre_subcategoria,
        seg.nombre_segmento,
        tot.unidades_vendidas_totales,
        ped.veces_mismo_pedido_ml
    ORDER BY
        compradores_en_comun DESC,
        unidades_vendidas_ancla DESC,
        c.titulo
    LIMIT v_limite;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_top_vendidos_por_categoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_top_vendidos_por_categoria`(
    IN p_nombre_categoria VARCHAR(100),  -- NULL/'' = todas
    IN p_solo_con_stock TINYINT          -- 1 = solo vendibles > 0 (default); 0 = todos
)
BEGIN
    DECLARE v_solo_con_stock TINYINT DEFAULT 1;

    IF p_solo_con_stock IS NOT NULL THEN
        SET v_solo_con_stock = p_solo_con_stock;
    END IF;

    SELECT
        cat.nombre_categoria,
        sc.nombre_subcategoria,
        c.SKU,
        c.ISBN,
        c.titulo,
        c.formato,
        COALESCE(v60.ventas_netas_60d, 0) AS ventas_netas_60d,
        COALESCE(v60.unidades_60d, 0) AS u_vendidas_60d,
        COALESCE(s.unidades_en_full, 0) AS stock_full
    FROM catalogo c
    JOIN subcategorias sc ON sc.id = c.fk_subcategorias_id
    JOIN categorias cat ON cat.id = sc.fk_categorias_id
    LEFT JOIN stock s ON s.fk_catalogo_SKU = c.SKU
    LEFT JOIN (
        SELECT
            v.fk_catalogo_SKU,
            SUM(v.unidades) AS unidades_60d,
            ROUND(SUM(v.precio_neto), 2) AS ventas_netas_60d
        FROM ventas v
        WHERE v.estado = 'concretada'
          AND COALESCE(v.fecha_concrecion, DATE(v.fecha_venta))
              >= (CURDATE() - INTERVAL 60 DAY)
        GROUP BY v.fk_catalogo_SKU
    ) v60 ON v60.fk_catalogo_SKU = c.SKU
    WHERE
        (
            p_nombre_categoria IS NULL
            OR TRIM(p_nombre_categoria) = ''
            OR cat.nombre_categoria LIKE CONCAT('%', TRIM(p_nombre_categoria), '%')
        )
        AND (
            v_solo_con_stock = 0
            OR (
                COALESCE(s.unidades_en_full, 0)
                + COALESCE(s.unidades_en_deposito, 0)
            ) > 0
        )
    ORDER BY
        u_vendidas_60d DESC,
        ventas_netas_60d DESC,
        cat.nombre_categoria,
        sc.nombre_subcategoria,
        c.titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_top_vendidos_por_subcategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_top_vendidos_por_subcategoria`(
    IN p_nombre_categoria VARCHAR(100),     -- NULL/'' = todas
    IN p_nombre_subcategoria VARCHAR(100),  -- NULL/'' = todas
    IN p_solo_con_stock TINYINT             -- 1 = solo vendibles > 0 (default); 0 = todos
)
BEGIN
    DECLARE v_solo_con_stock TINYINT DEFAULT 1;

    IF p_solo_con_stock IS NOT NULL THEN
        SET v_solo_con_stock = p_solo_con_stock;
    END IF;

    SELECT
        cat.nombre_categoria,
        sc.nombre_subcategoria,
        c.SKU,
        c.ISBN,
        c.titulo,
        c.formato,
        COALESCE(v60.ventas_netas_60d, 0) AS ventas_netas_60d,
        COALESCE(v60.unidades_60d, 0) AS u_vendidas_60d,
        COALESCE(s.unidades_en_full, 0) AS stock_full

    FROM catalogo c
    JOIN subcategorias sc ON sc.id = c.fk_subcategorias_id
    JOIN categorias cat ON cat.id = sc.fk_categorias_id
    LEFT JOIN stock s ON s.fk_catalogo_SKU = c.SKU
    LEFT JOIN (
        SELECT
            v.fk_catalogo_SKU,
            SUM(v.unidades) AS unidades_60d,
            ROUND(SUM(v.precio_neto), 2) AS ventas_netas_60d
        FROM ventas v
        WHERE v.estado = 'concretada'
          AND COALESCE(v.fecha_concrecion, DATE(v.fecha_venta))
              >= (CURDATE() - INTERVAL 60 DAY)
        GROUP BY v.fk_catalogo_SKU
    ) v60 ON v60.fk_catalogo_SKU = c.SKU
    WHERE
        (
            p_nombre_categoria IS NULL
            OR TRIM(p_nombre_categoria) = ''
            OR cat.nombre_categoria LIKE CONCAT('%', TRIM(p_nombre_categoria), '%')
        )
        AND (
            p_nombre_subcategoria IS NULL
            OR TRIM(p_nombre_subcategoria) = ''
            OR sc.nombre_subcategoria LIKE CONCAT('%', TRIM(p_nombre_subcategoria), '%')
        )
        AND (
            v_solo_con_stock = 0
            OR (
                COALESCE(s.unidades_en_full, 0)
                + COALESCE(s.unidades_en_deposito, 0)
            ) > 0
        )
    ORDER BY
        unidades_60d DESC,
        ventas_netas_60d DESC,
        cat.nombre_categoria,
        sc.nombre_subcategoria,
        c.titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_vista_precio_sugerido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_vista_precio_sugerido`(
    IN p_sku SMALLINT,
    IN p_titulo_busqueda VARCHAR(50)
)
BEGIN
    IF p_sku IS NULL AND (p_titulo_busqueda IS NULL OR TRIM(p_titulo_busqueda) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar p_sku o p_titulo_busqueda';
    END IF;

    SELECT
        c.SKU,
        c.titulo,
        m.id AS margen_id,
        m.valor_margen,
        p.precio_publicado AS precio_publicado_anterior,
        p.fecha_calculo AS fecha_calculo_anterior,
        CASE
            WHEN p.id IS NULL THEN NULL
            ELSE
                fn_redondear_precio_ml(
                    (p.costo_adquisicion + p.costo_preparacion) * (1 + m.valor_margen)
                        / (1 - p.pct_comisiones_impuestos)
                    + p.comision_fija + p.envio_meli
                ) + COALESCE(c.factor_ajuste_precio, 0)
        END AS precio_sugerido_estimado,
        CASE
            WHEN p.id IS NULL THEN NULL
            ELSE
                fn_redondear_precio_ml(
                    (p.costo_adquisicion + p.costo_preparacion) * (1 + m.valor_margen)
                        / (1 - p.pct_comisiones_impuestos)
                    + p.comision_fija + p.envio_meli
                ) + COALESCE(c.factor_ajuste_precio, 0) - p.precio_publicado
        END AS diferencia_vs_anterior,
        CASE
            WHEN p.id IS NULL THEN 'Sin calculo previo: ejecutar calc_precio_ml.py'
            ELSE 'Estimado con comision/envio del ultimo calculo'
        END AS nota
    FROM catalogo c
    JOIN margenes m ON m.id = c.fk_margenes_id
    LEFT JOIN (
        SELECT p2.fk_catalogo_SKU, MAX(p2.id) AS ultimo_id
        FROM precio_ml_sugerido p2
        JOIN (SELECT fk_catalogo_SKU, MAX(fecha_calculo) AS ultima_fecha FROM precio_ml_sugerido GROUP BY fk_catalogo_SKU) mf
          ON mf.fk_catalogo_SKU = p2.fk_catalogo_SKU AND mf.ultima_fecha = p2.fecha_calculo
        GROUP BY p2.fk_catalogo_SKU
    ) ult ON ult.fk_catalogo_SKU = c.SKU
    LEFT JOIN precio_ml_sugerido p ON p.id = ult.ultimo_id
    WHERE
        (p_sku IS NOT NULL AND c.SKU = p_sku)
        OR (
            p_sku IS NULL
            AND c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
        )
    ORDER BY c.titulo, c.SKU;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_vista_previa_margen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_vista_previa_margen`(
    IN p_sku SMALLINT,
    IN p_titulo_busqueda VARCHAR(50)
)
BEGIN
    IF p_sku IS NULL AND (p_titulo_busqueda IS NULL OR TRIM(p_titulo_busqueda) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar p_sku o p_titulo_busqueda';
    END IF;

    IF p_sku IS NOT NULL THEN
        SELECT
            c.SKU,
            c.titulo,
            c.fk_margenes_id AS margen_actual,
            m.valor_margen,
            m.descripcion_margen,
            c.fecha_modificacion_margen
        FROM catalogo c
        JOIN margenes m ON m.id = c.fk_margenes_id
        WHERE c.SKU = p_sku;
    ELSE
        SELECT
            c.SKU,
            c.titulo,
            c.fk_margenes_id AS margen_actual,
            m.valor_margen,
            m.descripcion_margen,
            c.fecha_modificacion_margen
        FROM catalogo c
        JOIN margenes m ON m.id = c.fk_margenes_id
        WHERE c.titulo LIKE CONCAT('%', TRIM(p_titulo_busqueda), '%')
        ORDER BY c.titulo, c.SKU;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

USE `thebookstore`;
/*!50001 DROP VIEW IF EXISTS `libros más vendidos ult. 60d`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `libros más vendidos ult. 60d` AS select `c`.`SKU` AS `sku`,`c`.`titulo` AS `titulo`,`s`.`nombre_subcategoria` AS `Subcategoría`,sum(`v`.`unidades`) AS `Unidades Vendidas`,sum(`v`.`precio_neto`) AS `Ventas Netas Totales` from ((`ventas` `v` join `catalogo` `c` on((`v`.`fk_catalogo_SKU` = `c`.`SKU`))) join `subcategorias` `s` on((`c`.`fk_subcategorias_id` = `s`.`id`))) where (((`v`.`estado` = 'concretada') or (`v`.`estado` = 'en_camino')) and ((to_days(curdate()) - to_days(`v`.`fecha_venta`)) <= 60) and (`c`.`inactivo` = 0)) group by `c`.`SKU` order by sum(`v`.`precio_neto`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `libros_sin_stock_mas_vendidos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `libros_sin_stock_mas_vendidos` AS select `c`.`SKU` AS `SKU`,`c`.`ISBN` AS `ISBN`,`c`.`titulo` AS `titulo`,`c`.`formato` AS `formato`,sum(`v`.`unidades`) AS `Unidades Vendidas Ult. 60d`,sum((`v`.`precio_unitario` * `v`.`unidades`)) AS `Facturacion Total`,`s`.`unidades_en_camino_desde_proveedor` AS `Esperando Arribo`,`s`.`unidades_en_deposito` AS `En Deposito` from ((`catalogo` `c` join `ventas` `v` on((`c`.`SKU` = `v`.`fk_catalogo_SKU`))) join `stock` `s` on((`c`.`SKU` = `s`.`fk_catalogo_SKU`))) where ((`v`.`fecha_concrecion` >= (curdate() - interval 2 month)) and (`v`.`estado` = 'concretada') and (`c`.`inactivo` <> 1) and (`s`.`unidades_en_full` = 0) and (`s`.`unidades_en_camino_hacia_full` = 0) and (`s`.`unidades_en_devolucion` = 0)) group by `c`.`SKU`,`c`.`titulo`,`c`.`formato` order by sum((`v`.`precio_unitario` * `v`.`unidades`)) desc limit 15 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `obsolesencia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `obsolesencia` AS with `fecha_ultima_venta_por_sku` as (select `ventas`.`fk_catalogo_SKU` AS `fk_catalogo_SKU`,max(`ventas`.`fecha_venta`) AS `ult_fecha_venta` from `ventas` where (`ventas`.`estado` = 'concretada') group by `ventas`.`fk_catalogo_SKU`) select `v`.`fk_catalogo_SKU` AS `fk_catalogo_sku`,(((`s`.`unidades_en_deposito` + `s`.`unidades_en_camino_hacia_full`) + `s`.`unidades_en_full`) + `s`.`unidades_en_devolucion`) AS `total_unidades`,(((`c`.`precio_lista` * (1 - `c`.`descuento_proveedor`)) + (`c`.`peso_g` * `m`.`costo_envio_g`)) * `t`.`cotizacion`) AS `costo_pesos`,(to_days(curdate()) - to_days(`v`.`ult_fecha_venta`)) AS `dias_sin_ventas`,((((`c`.`precio_lista` * (1 - `c`.`descuento_proveedor`)) + (`c`.`peso_g` * `m`.`costo_envio_g`)) * `t`.`cotizacion`) * (((`s`.`unidades_en_deposito` + `s`.`unidades_en_camino_hacia_full`) + `s`.`unidades_en_full`) + `s`.`unidades_en_devolucion`)) AS `costo_obsolescencia_sku`,(`v`.`ult_fecha_venta` + interval 120 day) AS `fecha_obsolescencia`,`v`.`ult_fecha_venta` AS `ult_fecha_venta` from ((((`fecha_ultima_venta_por_sku` `v` join `stock` `s` on((`s`.`fk_catalogo_SKU` = `v`.`fk_catalogo_SKU`))) join `catalogo` `c` on((`v`.`fk_catalogo_SKU` = `c`.`SKU`))) join `tipo_cambio_oficial` `t` on((`t`.`fecha` = (select max(`tipo_cambio_oficial`.`fecha`) from `tipo_cambio_oficial`)))) join `metodos_envio` `m` on((`m`.`nombre_metodo` = 'courier_penguin'))) where ((to_days(curdate()) - to_days(`v`.`ult_fecha_venta`)) > 120) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `sobrestocks`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sobrestocks` AS select `s`.`fk_catalogo_SKU` AS `fk_catalogo_sku`,`s`.`fecha` AS `fecha`,`s`.`unidades_full` AS `unidades_full`,`s`.`unidades_deposito` AS `unidades_deposito`,`s`.`unidades_camino_hacia_full` AS `unidades_camino_hacia_full`,((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) AS `stock_hoy`,`d`.`demanda_final_est` AS `demanda_final_est`,(case when (`d`.`demanda_final_est` >= 3) then 'Best Seller' when (`d`.`demanda_final_est` >= 1.5) then 'Medio' when (`d`.`demanda_final_est` >= 0.5) then 'Bajo' else 'Lento' end) AS `segmento_ventas`,if(((((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) - `d`.`demanda_final_est`) < 0),0,(((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) - `d`.`demanda_final_est`)) AS `unidades_sobrestock`,(((`c`.`precio_lista` * (1 - `c`.`descuento_proveedor`)) + (`c`.`peso_g` * `m`.`costo_envio_g`)) * `t`.`cotizacion`) AS `costo_libro`,(case when ((((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) - `d`.`demanda_final_est`) <= 0) then 0 when ((((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) - `d`.`demanda_final_est`) > 0) then (((((((`s`.`unidades_full` + `s`.`unidades_deposito`) + `s`.`unidades_camino_hacia_full`) - `d`.`demanda_final_est`) * ((`c`.`precio_lista` * (1 - `c`.`descuento_proveedor`)) + (`c`.`peso_g` * `m`.`costo_envio_g`))) * `t`.`cotizacion`) * (0.4 / 365)) + (`s`.`unidades_full` * 0.75)) end) AS `costo_diario_sobrestock` from ((((`stock_diario` `s` join `demanda_forecast_historico` `d` on(((`s`.`fk_catalogo_SKU` = `d`.`fk_catalogo_SKU`) and (`d`.`fecha_vigencia` = date_format(`s`.`fecha`,'%Y-%m-01'))))) join `catalogo` `c` on((`s`.`fk_catalogo_SKU` = `c`.`SKU`))) join `tipo_cambio_oficial` `t` on((`t`.`fecha` = `s`.`fecha`))) join `metodos_envio` `m` on((`m`.`nombre_metodo` = 'courier_penguin'))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `stockouts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `stockouts` AS select `s`.`fecha` AS `fecha`,`s`.`fk_catalogo_SKU` AS `fk_catalogo_sku`,if((`s`.`unidades_full` = 0),1,0) AS `Stockout`,`s`.`unidades_full` AS `Unidades en Full`,(`d`.`demanda_final_est` / 30) AS `Demanda diaria est.`,(if((`s`.`unidades_full` = 0),1,0) * (`d`.`demanda_final_est` / 30)) AS `Unidades Perdidas`,if((`s`.`unidades_full` = 0),(`p`.`ganancia_neta` * (`d`.`demanda_final_est` / 30)),0) AS `Costo Neto por Stockout` from ((`stock_diario` `s` left join `demanda_forecast_historico` `d` on(((`s`.`fk_catalogo_SKU` = `d`.`fk_catalogo_SKU`) and (`d`.`fecha_vigencia` = date_format(`s`.`fecha`,'%Y-%m-01'))))) left join (select `precio_ml_sugerido`.`fk_catalogo_SKU` AS `fk_catalogo_sku`,date_format(`precio_ml_sugerido`.`fecha_calculo`,'%Y-%m-01') AS `mes_precio`,avg(`precio_ml_sugerido`.`ganancia_neta`) AS `ganancia_neta` from `precio_ml_sugerido` group by `precio_ml_sugerido`.`fk_catalogo_SKU`,date_format(`precio_ml_sugerido`.`fecha_calculo`,'%Y-%m-01')) `p` on(((`s`.`fk_catalogo_SKU` = `p`.`fk_catalogo_sku`) and (date_format(`s`.`fecha`,'%Y-%m-01') = `p`.`mes_precio`)))) where (`s`.`fk_catalogo_SKU` <> 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_clientes_compras`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_clientes_compras` AS select `c`.`id` AS `fk_clientes_id`,`c`.`nombre_cliente` AS `nombre_cliente`,`c`.`id_comprador_ml` AS `id_comprador_ml`,count(distinct coalesce(`v`.`id_pedido_ml`,`v`.`id_venta_ml`)) AS `compras_distintas`,count(`v`.`id`) AS `lineas_venta`,sum(`v`.`unidades`) AS `unidades_totales`,sum(`v`.`precio_neto`) AS `neto_total` from (`clientes` `c` join `ventas` `v` on((`v`.`fk_clientes_id` = `c`.`id`))) where (`v`.`estado` = 'concretada') group by `c`.`id`,`c`.`nombre_cliente`,`c`.`id_comprador_ml` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_estimacion_demanda`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estimacion_demanda` AS select `c`.`SKU` AS `SKU`,`c`.`titulo` AS `titulo`,`c`.`formato` AS `formato`,`d`.`demanda_final` AS `demanda_final`,`d`.`confianza` AS `confianza`,`c`.`inactivo` AS `inactivo` from (`demanda_forecast` `d` join `catalogo` `c` on((`c`.`SKU` = `d`.`fk_catalogo_SKU`))) where (coalesce(`c`.`inactivo`,0) = 0) order by `d`.`demanda_final` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_eventos_demanda_vigentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_eventos_demanda_vigentes` AS select `e`.`id` AS `id`,`e`.`fk_catalogo_SKU` AS `sku`,`c`.`titulo` AS `titulo`,`e`.`tipo` AS `tipo`,`e`.`fecha_inicio` AS `fecha_inicio`,`e`.`fecha_fin_estimada` AS `fecha_fin_estimada`,`e`.`factor_boost` AS `factor_boost`,`e`.`notas` AS `notas`,(case when ((`e`.`fecha_inicio` <= curdate()) and ((`e`.`fecha_fin_estimada` is null) or (`e`.`fecha_fin_estimada` >= curdate()))) then 'activo' else 'vencido_reciente' end) AS `estado`,(case when (`e`.`fecha_fin_estimada` is null) then NULL when (`e`.`fecha_fin_estimada` >= curdate()) then (to_days(`e`.`fecha_fin_estimada`) - to_days(curdate())) else NULL end) AS `dias_restantes`,(case when ((`e`.`fecha_fin_estimada` is not null) and (`e`.`fecha_fin_estimada` < curdate())) then (to_days(curdate()) - to_days(`e`.`fecha_fin_estimada`)) else NULL end) AS `dias_desde_vencimiento` from (`eventos_demanda` `e` join `catalogo` `c` on((`c`.`SKU` = `e`.`fk_catalogo_SKU`))) where (((`e`.`fecha_inicio` <= curdate()) and ((`e`.`fecha_fin_estimada` is null) or (`e`.`fecha_fin_estimada` >= curdate()))) or ((`e`.`fecha_fin_estimada` is not null) and (`e`.`fecha_fin_estimada` < curdate()) and (`e`.`fecha_fin_estimada` >= (curdate() - interval 2 month)))) order by (case when ((`e`.`fecha_inicio` <= curdate()) and ((`e`.`fecha_fin_estimada` is null) or (`e`.`fecha_fin_estimada` >= curdate()))) then 0 else 1 end),`e`.`fecha_fin_estimada` desc,`e`.`fk_catalogo_SKU`,`e`.`fecha_inicio` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

