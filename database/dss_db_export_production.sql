-- MySQL dump 10.13  Distrib 8.4.7, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: dss_db
-- ------------------------------------------------------
-- Server version	8.4.7

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

--
-- Current Database: `dss_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dss_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `dss_db`;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` bigint unsigned NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit_entity` (`entity_type`,`entity_id`),
  KEY `ix_audit_user_created` (`user_id`,`created_at`),
  CONSTRAINT `fk_audit_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,5,'inventory.adjust','StockAdjustment',1,NULL,'{\"after\": 36, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:02.000000'),(2,5,'inventory.adjust','StockAdjustment',2,NULL,'{\"after\": 22, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:02.000000'),(3,5,'inventory.adjust','StockAdjustment',3,NULL,'{\"after\": 14, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:02.000000'),(4,5,'inventory.adjust','StockAdjustment',4,NULL,'{\"after\": 40, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:02.000000'),(5,5,'inventory.adjust','StockAdjustment',5,NULL,'{\"after\": 18, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:02.000000'),(6,5,'inventory.adjust','StockAdjustment',6,NULL,'{\"after\": 76, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:03.000000'),(7,5,'inventory.adjust','StockAdjustment',7,NULL,'{\"after\": 44, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:03.000000'),(8,5,'inventory.adjust','StockAdjustment',8,NULL,'{\"after\": 39, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:03.000000'),(9,5,'inventory.adjust','StockAdjustment',9,NULL,'{\"after\": 26, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:03.000000'),(10,5,'inventory.adjust','StockAdjustment',10,NULL,'{\"after\": 12, \"before\": 0, \"reason\": \"Tồn đầu minh họa\"}','127.0.0.1','2026-10-25 08:23:03.000000'),(11,3,'sale.create','SalesOrder',1,NULL,NULL,'127.0.0.1','2026-10-25 08:23:08.000000'),(12,3,'sale.confirm','SalesOrder',1,NULL,NULL,'127.0.0.1','2026-10-25 08:23:08.000000'),(13,5,'sale.fulfill','SalesOrder',1,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(14,3,'sale.create','SalesOrder',2,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(15,3,'sale.confirm','SalesOrder',2,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(16,5,'sale.fulfill','SalesOrder',2,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(17,3,'sale.create','SalesOrder',3,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(18,3,'sale.confirm','SalesOrder',3,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(19,5,'sale.fulfill','SalesOrder',3,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(20,3,'sale.create','SalesOrder',4,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(21,3,'sale.confirm','SalesOrder',4,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(22,5,'sale.fulfill','SalesOrder',4,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(23,3,'sale.create','SalesOrder',5,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(24,3,'sale.confirm','SalesOrder',5,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(25,5,'sale.fulfill','SalesOrder',5,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(26,3,'sale.create','SalesOrder',6,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(27,3,'sale.confirm','SalesOrder',6,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(28,5,'sale.fulfill','SalesOrder',6,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(29,3,'sale.create','SalesOrder',7,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(30,3,'sale.confirm','SalesOrder',7,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(31,5,'sale.fulfill','SalesOrder',7,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(32,3,'sale.create','SalesOrder',8,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(33,3,'sale.confirm','SalesOrder',8,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(34,5,'sale.fulfill','SalesOrder',8,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(35,3,'sale.create','SalesOrder',9,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(36,3,'sale.confirm','SalesOrder',9,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(37,5,'sale.fulfill','SalesOrder',9,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(38,3,'sale.create','SalesOrder',10,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(39,3,'sale.confirm','SalesOrder',10,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(40,5,'sale.fulfill','SalesOrder',10,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(41,3,'sale.create','SalesOrder',11,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(42,3,'sale.confirm','SalesOrder',11,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(43,5,'sale.fulfill','SalesOrder',11,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(44,3,'sale.create','SalesOrder',12,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(45,3,'sale.confirm','SalesOrder',12,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(46,5,'sale.fulfill','SalesOrder',12,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(47,3,'sale.create','SalesOrder',13,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(48,3,'sale.confirm','SalesOrder',13,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(49,5,'sale.fulfill','SalesOrder',13,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(50,3,'sale.create','SalesOrder',14,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(51,3,'sale.confirm','SalesOrder',14,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(52,5,'sale.fulfill','SalesOrder',14,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(53,3,'sale.create','SalesOrder',15,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(54,3,'sale.confirm','SalesOrder',15,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(55,5,'sale.fulfill','SalesOrder',15,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(56,3,'sale.create','SalesOrder',16,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(57,3,'sale.confirm','SalesOrder',16,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(58,5,'sale.fulfill','SalesOrder',16,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(59,3,'sale.create','SalesOrder',17,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(60,3,'sale.confirm','SalesOrder',17,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(61,5,'sale.fulfill','SalesOrder',17,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(62,3,'sale.create','SalesOrder',18,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(63,3,'sale.confirm','SalesOrder',18,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(64,5,'sale.fulfill','SalesOrder',18,NULL,NULL,'127.0.0.1','2026-10-25 08:23:09.000000'),(65,4,'purchase.create','PurchaseOrder',1,NULL,NULL,'::1','2026-10-31 14:43:47.000000'),(66,4,'purchase.submit','PurchaseOrder',1,NULL,NULL,'::1','2026-10-31 14:43:58.000000');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel-cache-0ad66b34dc1e86ab0a829666980ee6a1','i:1;',1793457949),('laravel-cache-0ad66b34dc1e86ab0a829666980ee6a1:timer','i:1793457949;',1793457949),('laravel-cache-1cfd03b9c1f08d3ecf9b927ae0081969','i:1;',1793457185),('laravel-cache-1cfd03b9c1f08d3ecf9b927ae0081969:timer','i:1793457185;',1793457185),('laravel-cache-db7b0206b8167f6a0403fe30ff256881','i:1;',1793457803),('laravel-cache-db7b0206b8167f6a0403fe30ff256881:timer','i:1793457803;',1793457803),('laravel-cache-de9d35f5bca3d12900571bce41c6e882','i:1;',1793290620),('laravel-cache-de9d35f5bca3d12900571bce41c6e882:timer','i:1793290620;',1793290620),('laravel-cache-e7c5cedb8803835f4a0c39788a2e9f19','i:1;',1793457148),('laravel-cache-e7c5cedb8803835f4a0c39788a2e9f19:timer','i:1793457148;',1793457148),('smartstock-dss-cache-db7b0206b8167f6a0403fe30ff256881','i:1;',1793460028),('smartstock-dss-cache-db7b0206b8167f6a0403fe30ff256881:timer','i:1793460028;',1793460028),('smartstock-dss-cache-de9d35f5bca3d12900571bce41c6e882','i:1;',1794390614),('smartstock-dss-cache-de9d35f5bca3d12900571bce41c6e882:timer','i:1794390614;',1794390614);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_categories_code` (`code`),
  CONSTRAINT `ck_categories_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Laptop','LAPTOP','active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,'Điện thoại','PHONE','active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,'Phụ kiện','ACC','active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,'Màn hình','MONITOR','active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_customers_name` (`name`),
  CONSTRAINT `ck_customers_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Nguyễn Văn An',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(2,'Trần Thị Bình',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(3,'Lê Văn Cường',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(4,'Phạm Minh Đức',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(5,'Khách lẻ tại quầy',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demand_forecasts`
--

DROP TABLE IF EXISTS `demand_forecasts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `demand_forecasts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `forecast_run_id` bigint unsigned NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `predicted_qty` decimal(14,3) NOT NULL,
  `actual_qty` int unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_forecast_run_period` (`forecast_run_id`,`period_start`),
  CONSTRAINT `fk_demand_forecasts_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast_runs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_forecast_period` CHECK (((`period_start` <= `period_end`) and (`predicted_qty` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demand_forecasts`
--

LOCK TABLES `demand_forecasts` WRITE;
/*!40000 ALTER TABLE `demand_forecasts` DISABLE KEYS */;
INSERT INTO `demand_forecasts` VALUES (1,1,'2026-10-26','2026-11-01',0.333,NULL,'2026-10-28 06:47:42.000000'),(2,1,'2026-11-02','2026-11-08',0.444,NULL,'2026-10-28 06:47:42.000000'),(3,1,'2026-11-09','2026-11-15',0.259,NULL,'2026-10-28 06:47:42.000000'),(4,1,'2026-11-16','2026-11-22',0.345,NULL,'2026-10-28 06:47:42.000000');
/*!40000 ALTER TABLE `demand_forecasts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forecast_runs`
--

DROP TABLE IF EXISTS `forecast_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forecast_runs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `method` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `granularity` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'weekly',
  `train_from` date NOT NULL,
  `train_to` date NOT NULL,
  `mae` decimal(18,4) DEFAULT NULL,
  `mape` decimal(9,4) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_by` bigint unsigned NOT NULL,
  `generated_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_forecast_product_created` (`product_id`,`created_at`),
  KEY `fk_forecast_runs_created_by` (`created_by`),
  CONSTRAINT `fk_forecast_runs_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_forecast_runs_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_fr_granularity` CHECK ((`granularity` = _utf8mb4'weekly')),
  CONSTRAINT `ck_fr_method` CHECK ((`method` in (_utf8mb4'moving_average',_utf8mb4'exponential_smoothing'))),
  CONSTRAINT `ck_fr_range` CHECK ((`train_from` <= `train_to`)),
  CONSTRAINT `ck_fr_status` CHECK ((`status` in (_utf8mb4'pending',_utf8mb4'completed',_utf8mb4'failed')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forecast_runs`
--

LOCK TABLES `forecast_runs` WRITE;
/*!40000 ALTER TABLE `forecast_runs` DISABLE KEYS */;
INSERT INTO `forecast_runs` VALUES (1,1,'moving_average','weekly','2026-06-15','2026-10-25',0.4375,NULL,'completed',1,'2026-10-28 06:47:42.000000','2026-10-28 06:47:42.000000');
/*!40000 ALTER TABLE `forecast_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `qty_on_hand` int unsigned NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inventory_product_wh` (`product_id`,`warehouse_id`),
  KEY `fk_inventories_warehouse_id` (`warehouse_id`),
  CONSTRAINT `fk_inventories_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventories_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_inventory_nonnegative` CHECK ((`qty_on_hand` >= 0)),
  CONSTRAINT `ck_ss_nonnegative` CHECK ((`qty_on_hand` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
INSERT INTO `inventories` VALUES (1,1,1,31,'2026-10-25 08:23:02.000000','2026-10-25 08:23:09.000000'),(2,2,1,16,'2026-10-25 08:23:02.000000','2026-10-25 08:23:09.000000'),(3,3,1,9,'2026-10-25 08:23:02.000000','2026-10-25 08:23:09.000000'),(4,4,1,35,'2026-10-25 08:23:02.000000','2026-10-25 08:23:09.000000'),(5,5,1,11,'2026-10-25 08:23:02.000000','2026-10-25 08:23:09.000000'),(6,6,1,70,'2026-10-25 08:23:03.000000','2026-10-25 08:23:09.000000'),(7,7,1,39,'2026-10-25 08:23:03.000000','2026-10-25 08:23:09.000000'),(8,8,1,32,'2026-10-25 08:23:03.000000','2026-10-25 08:23:09.000000'),(9,9,1,21,'2026-10-25 08:23:03.000000','2026-10-25 08:23:09.000000'),(10,10,1,9,'2026-10-25 08:23:03.000000','2026-10-25 08:23:09.000000');
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_alerts`
--

DROP TABLE IF EXISTS `inventory_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_alerts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inventory_id` bigint unsigned NOT NULL,
  `alert_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `qty_at_detection` int unsigned NOT NULL,
  `threshold_qty` int unsigned NOT NULL,
  `first_detected_at` datetime(6) NOT NULL,
  `last_detected_at` datetime(6) NOT NULL,
  `resolved_at` datetime(6) DEFAULT NULL,
  `open_inventory_id` bigint unsigned GENERATED ALWAYS AS ((case when (`status` = _utf8mb4'open') then `inventory_id` else NULL end)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_alert_active` (`open_inventory_id`,`alert_type`),
  KEY `ix_alert_inventory_created` (`inventory_id`,`first_detected_at`),
  CONSTRAINT `fk_inventory_alerts_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_alert_status` CHECK ((`status` in (_utf8mb4'open',_utf8mb4'resolved'))),
  CONSTRAINT `ck_alert_type` CHECK ((`alert_type` in (_utf8mb4'low_stock',_utf8mb4'out_of_stock')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_alerts`
--

LOCK TABLES `inventory_alerts` WRITE;
/*!40000 ALTER TABLE `inventory_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_policies`
--

DROP TABLE IF EXISTS `inventory_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_policies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inventory_id` bigint unsigned NOT NULL,
  `lead_time_days` int unsigned NOT NULL,
  `safety_stock_qty` int unsigned NOT NULL DEFAULT '0',
  `demand_window_days` int unsigned NOT NULL DEFAULT '30',
  `target_cover_days` int unsigned NOT NULL DEFAULT '14',
  `updated_by` bigint unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inventory_policy_inventory` (`inventory_id`),
  KEY `fk_inventory_policies_updated_by` (`updated_by`),
  CONSTRAINT `fk_inventory_policies_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_policies_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_policy_days` CHECK (((`lead_time_days` >= 1) and (`demand_window_days` >= 1) and (`target_cover_days` >= 1)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_policies`
--

LOCK TABLES `inventory_policies` WRITE;
/*!40000 ALTER TABLE `inventory_policies` DISABLE KEYS */;
INSERT INTO `inventory_policies` VALUES (1,1,5,10,30,14,2,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,2,5,10,30,14,2,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,3,5,10,30,14,2,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,4,5,10,30,14,2,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(5,5,5,10,30,14,2,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(6,6,5,10,30,14,2,'2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(7,7,5,10,30,14,2,'2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(8,8,5,10,30,14,2,'2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(9,9,5,10,30,14,2,'2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(10,10,5,10,30,14,2,'2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000');
/*!40000 ALTER TABLE `inventory_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_transactions`
--

DROP TABLE IF EXISTS `inventory_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inventory_id` bigint unsigned NOT NULL,
  `movement_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_delta` int NOT NULL,
  `qty_before` int unsigned NOT NULL,
  `qty_after` int unsigned NOT NULL,
  `purchase_order_item_id` bigint unsigned DEFAULT NULL,
  `sales_order_item_id` bigint unsigned DEFAULT NULL,
  `stock_adjustment_id` bigint unsigned DEFAULT NULL,
  `performed_by` bigint unsigned NOT NULL,
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tx_purchase_item` (`purchase_order_item_id`),
  UNIQUE KEY `uq_tx_sales_item` (`sales_order_item_id`),
  UNIQUE KEY `uq_tx_adjustment` (`stock_adjustment_id`),
  KEY `ix_tx_inventory_created` (`inventory_id`,`created_at`),
  KEY `fk_inventory_transactions_performed_by` (`performed_by`),
  CONSTRAINT `fk_inventory_transactions_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_transactions_performed_by` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_transactions_purchase_order_item_id` FOREIGN KEY (`purchase_order_item_id`) REFERENCES `purchase_order_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_transactions_sales_order_item_id` FOREIGN KEY (`sales_order_item_id`) REFERENCES `sales_order_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_transactions_stock_adjustment_id` FOREIGN KEY (`stock_adjustment_id`) REFERENCES `stock_adjustments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_ss_ledger_balance` CHECK (((`quantity_delta` <> 0) and ((cast(`qty_before` as signed) + `quantity_delta`) = cast(`qty_after` as signed)))),
  CONSTRAINT `ck_ss_ledger_source` CHECK (((((`purchase_order_item_id` is not null) + (`sales_order_item_id` is not null)) + (`stock_adjustment_id` is not null)) = 1)),
  CONSTRAINT `ck_tx_balance` CHECK (((cast(`qty_before` as signed) + `quantity_delta`) = cast(`qty_after` as signed))),
  CONSTRAINT `ck_tx_nonzero` CHECK ((`quantity_delta` <> 0)),
  CONSTRAINT `ck_tx_source_type` CHECK ((((`movement_type` = _utf8mb4'purchase_receipt') and (`purchase_order_item_id` is not null) and (`quantity_delta` > 0)) or ((`movement_type` = _utf8mb4'sales_issue') and (`sales_order_item_id` is not null) and (`quantity_delta` < 0)) or ((`movement_type` in (_utf8mb4'adjustment_in',_utf8mb4'adjustment_out',_utf8mb4'opening_balance')) and (`stock_adjustment_id` is not null) and (((`movement_type` in (_utf8mb4'adjustment_in',_utf8mb4'opening_balance')) and (`quantity_delta` > 0)) or ((`movement_type` = _utf8mb4'adjustment_out') and (`quantity_delta` < 0)))))),
  CONSTRAINT `ck_tx_sources` CHECK (((((`purchase_order_item_id` is not null) + (`sales_order_item_id` is not null)) + (`stock_adjustment_id` is not null)) = 1)),
  CONSTRAINT `ck_tx_type` CHECK ((`movement_type` in (_utf8mb4'purchase_receipt',_utf8mb4'sales_issue',_utf8mb4'adjustment_in',_utf8mb4'adjustment_out',_utf8mb4'opening_balance')))
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_transactions`
--

LOCK TABLES `inventory_transactions` WRITE;
/*!40000 ALTER TABLE `inventory_transactions` DISABLE KEYS */;
INSERT INTO `inventory_transactions` VALUES (1,1,'opening_balance',36,0,36,NULL,NULL,1,5,'Tồn đầu minh họa','2026-10-25 08:23:02.000000'),(2,2,'opening_balance',22,0,22,NULL,NULL,2,5,'Tồn đầu minh họa','2026-10-25 08:23:02.000000'),(3,3,'opening_balance',14,0,14,NULL,NULL,3,5,'Tồn đầu minh họa','2026-10-25 08:23:02.000000'),(4,4,'opening_balance',40,0,40,NULL,NULL,4,5,'Tồn đầu minh họa','2026-10-25 08:23:02.000000'),(5,5,'opening_balance',18,0,18,NULL,NULL,5,5,'Tồn đầu minh họa','2026-10-25 08:23:02.000000'),(6,6,'opening_balance',76,0,76,NULL,NULL,6,5,'Tồn đầu minh họa','2026-10-25 08:23:03.000000'),(7,7,'opening_balance',44,0,44,NULL,NULL,7,5,'Tồn đầu minh họa','2026-10-25 08:23:03.000000'),(8,8,'opening_balance',39,0,39,NULL,NULL,8,5,'Tồn đầu minh họa','2026-10-25 08:23:03.000000'),(9,9,'opening_balance',26,0,26,NULL,NULL,9,5,'Tồn đầu minh họa','2026-10-25 08:23:03.000000'),(10,10,'opening_balance',12,0,12,NULL,NULL,10,5,'Tồn đầu minh họa','2026-10-25 08:23:03.000000'),(11,1,'sales_issue',-1,36,35,NULL,1,NULL,5,NULL,'2026-10-25 08:23:08.000000'),(12,4,'sales_issue',-1,40,39,NULL,2,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(13,2,'sales_issue',-2,22,20,NULL,3,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(14,5,'sales_issue',-1,18,17,NULL,4,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(15,3,'sales_issue',-3,14,11,NULL,5,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(16,6,'sales_issue',-1,76,75,NULL,6,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(17,4,'sales_issue',-1,39,38,NULL,7,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(18,7,'sales_issue',-1,44,43,NULL,8,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(19,5,'sales_issue',-2,17,15,NULL,9,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(20,8,'sales_issue',-1,39,38,NULL,10,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(21,6,'sales_issue',-3,75,72,NULL,11,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(22,9,'sales_issue',-1,26,25,NULL,12,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(23,7,'sales_issue',-1,43,42,NULL,13,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(24,10,'sales_issue',-1,12,11,NULL,14,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(25,1,'sales_issue',-1,35,34,NULL,16,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(26,8,'sales_issue',-2,38,36,NULL,15,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(27,2,'sales_issue',-1,20,19,NULL,18,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(28,9,'sales_issue',-3,25,22,NULL,17,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(29,3,'sales_issue',-1,11,10,NULL,20,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(30,10,'sales_issue',-1,11,10,NULL,19,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(31,1,'sales_issue',-2,34,32,NULL,21,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(32,4,'sales_issue',-1,38,37,NULL,22,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(33,2,'sales_issue',-3,19,16,NULL,23,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(34,5,'sales_issue',-1,15,14,NULL,24,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(35,3,'sales_issue',-1,10,9,NULL,25,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(36,6,'sales_issue',-1,72,71,NULL,26,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(37,4,'sales_issue',-2,37,35,NULL,27,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(38,7,'sales_issue',-1,42,41,NULL,28,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(39,5,'sales_issue',-3,14,11,NULL,29,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(40,8,'sales_issue',-1,36,35,NULL,30,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(41,6,'sales_issue',-1,71,70,NULL,31,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(42,9,'sales_issue',-1,22,21,NULL,32,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(43,7,'sales_issue',-2,41,39,NULL,33,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(44,10,'sales_issue',-1,10,9,NULL,34,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(45,1,'sales_issue',-1,32,31,NULL,36,NULL,5,NULL,'2026-10-25 08:23:09.000000'),(46,8,'sales_issue',-3,35,32,NULL,35,NULL,5,NULL,'2026-10-25 08:23:09.000000');
/*!40000 ALTER TABLE `inventory_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2024_01_01_000000_create_passkeys_table',1),(5,'2025_08_14_170933_add_two_factor_columns_to_users_table',1),(6,'2026_10_25_000001_smartstock_identity',1),(7,'2026_10_25_000002_smartstock_business',1),(8,'2026_10_25_000003_notifications',1),(9,'2026_10_25_000004_smartstock_integrity',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint unsigned NOT NULL,
  `data` json NOT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_notifications_notifiable` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passkeys`
--

DROP TABLE IF EXISTS `passkeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passkeys` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential` json NOT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `passkeys_credential_id_unique` (`credential_id`),
  KEY `passkeys_user_id_index` (`user_id`),
  CONSTRAINT `passkeys_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passkeys`
--

LOCK TABLES `passkeys` WRITE;
/*!40000 ALTER TABLE `passkeys` DISABLE KEYS */;
/*!40000 ALTER TABLE `passkeys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_permissions_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'catalog.manage','catalog.manage','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,'purchase.create','purchase.create','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,'purchase.approve','purchase.approve','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,'purchase.receive','purchase.receive','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(5,'sale.create','sale.create','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(6,'sale.fulfill','sale.fulfill','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(7,'inventory.adjust','inventory.adjust','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(8,'dss.view','dss.view','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(9,'staff.manage','staff.manage','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `unit_id` bigint unsigned NOT NULL,
  `cost_price` decimal(18,2) NOT NULL,
  `selling_price` decimal(18,2) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_products_sku` (`sku`),
  KEY `ix_products_category_status` (`category_id`,`status`),
  KEY `fk_products_unit_id` (`unit_id`),
  CONSTRAINT `fk_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_products_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_products_price` CHECK (((`cost_price` >= 0) and (`selling_price` >= 0))),
  CONSTRAINT `ck_products_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'LAP-001','Laptop Dell Inspiron 15',1,1,12500000.00,15900000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,'LAP-002','Laptop ASUS Vivobook',1,1,14500000.00,17900000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,'LAP-003','MacBook Air M2',1,1,19000000.00,24490000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,'PHO-001','Samsung Galaxy A55',2,1,6900000.00,8990000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(5,'PHO-002','iPhone 15',2,1,14900000.00,18990000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(6,'ACC-001','Chuột Logitech M650',3,1,310000.00,450000.00,'active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(7,'ACC-002','Bàn phím Akko 5075',3,1,980000.00,1290000.00,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(8,'ACC-003','Tai nghe Sony WH-CH520',3,1,990000.00,1490000.00,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(9,'MON-001','Màn hình LG 24 inch',4,1,2300000.00,3190000.00,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(10,'MON-002','Màn hình Dell 27 inch',4,1,4100000.00,5390000.00,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order_items`
--

DROP TABLE IF EXISTS `purchase_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `purchase_order_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_cost` decimal(18,2) NOT NULL,
  `line_total` decimal(18,2) GENERATED ALWAYS AS ((`quantity` * `unit_cost`)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_poi_order_product` (`purchase_order_id`,`product_id`),
  KEY `fk_purchase_order_items_product_id` (`product_id`),
  CONSTRAINT `fk_purchase_order_items_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_order_items_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_poi_cost` CHECK ((`unit_cost` >= 0)),
  CONSTRAINT `ck_poi_qty` CHECK ((`quantity` > 0)),
  CONSTRAINT `ck_ss_po_quantity` CHECK (((`quantity` > 0) and (`unit_cost` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_items`
--

LOCK TABLES `purchase_order_items` WRITE;
/*!40000 ALTER TABLE `purchase_order_items` DISABLE KEYS */;
INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `product_id`, `quantity`, `unit_cost`) VALUES (1,1,8,3,990000.00),(2,1,10,2,4100000.00);
/*!40000 ALTER TABLE `purchase_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_orders`
--

DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_id` bigint unsigned NOT NULL,
  `status` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `total_amount` decimal(18,2) NOT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `created_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `received_by` bigint unsigned DEFAULT NULL,
  `rejected_by` bigint unsigned DEFAULT NULL,
  `rejected_at` datetime(6) DEFAULT NULL,
  `rejection_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancelled_by` bigint unsigned DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_purchase_orders_code` (`code`),
  KEY `ix_po_status_created` (`status`,`created_at`),
  KEY `fk_purchase_orders_supplier_id` (`supplier_id`),
  KEY `fk_purchase_orders_created_by` (`created_by`),
  KEY `fk_purchase_orders_approved_by` (`approved_by`),
  KEY `fk_purchase_orders_received_by` (`received_by`),
  KEY `fk_purchase_orders_rejected_by` (`rejected_by`),
  KEY `fk_purchase_orders_cancelled_by` (`cancelled_by`),
  CONSTRAINT `fk_purchase_orders_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_orders_cancelled_by` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_orders_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_orders_received_by` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_orders_rejected_by` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_orders_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_po_no_self_approve` CHECK (((`approved_by` is null) or (`approved_by` <> `created_by`))),
  CONSTRAINT `ck_po_status` CHECK ((`status` in (_utf8mb4'draft',_utf8mb4'pending_approval',_utf8mb4'approved',_utf8mb4'rejected',_utf8mb4'received',_utf8mb4'completed',_utf8mb4'cancelled'))),
  CONSTRAINT `ck_po_total` CHECK ((`total_amount` >= 0)),
  CONSTRAINT `ck_ss_no_self_approve` CHECK (((`approved_by` is null) or (`approved_by` <> `created_by`)))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_orders`
--

LOCK TABLES `purchase_orders` WRITE;
/*!40000 ALTER TABLE `purchase_orders` DISABLE KEYS */;
INSERT INTO `purchase_orders` VALUES (1,'PO-01M696NBC429QD8A23WRBZC8BB',2,'pending_approval',11170000.00,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Yêu cầu nhập hàng 1','2026-10-31 14:43:47.000000','2026-10-31 14:43:58.000000');
/*!40000 ALTER TABLE `purchase_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_recommendations`
--

DROP TABLE IF EXISTS `purchase_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_recommendations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inventory_id` bigint unsigned NOT NULL,
  `forecast_run_id` bigint unsigned DEFAULT NULL,
  `purchase_order_id` bigint unsigned DEFAULT NULL,
  `qty_on_hand_snapshot` int unsigned NOT NULL,
  `incoming_qty_snapshot` int unsigned NOT NULL,
  `reorder_point_snapshot` int unsigned NOT NULL,
  `suggested_qty` int unsigned NOT NULL,
  `basis` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'proposed',
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_rec_inventory_created` (`inventory_id`,`created_at`),
  KEY `fk_purchase_recommendations_forecast_run_id` (`forecast_run_id`),
  KEY `fk_purchase_recommendations_purchase_order_id` (`purchase_order_id`),
  KEY `fk_purchase_recommendations_created_by` (`created_by`),
  CONSTRAINT `fk_purchase_recommendations_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_recommendations_forecast_run_id` FOREIGN KEY (`forecast_run_id`) REFERENCES `forecast_runs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_recommendations_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase_recommendations_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_rec_basis` CHECK ((`basis` in (_utf8mb4'historical_average',_utf8mb4'forecast'))),
  CONSTRAINT `ck_rec_qty` CHECK ((`suggested_qty` > 0)),
  CONSTRAINT `ck_rec_status` CHECK ((`status` in (_utf8mb4'proposed',_utf8mb4'converted',_utf8mb4'dismissed')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_recommendations`
--

LOCK TABLES `purchase_recommendations` WRITE;
/*!40000 ALTER TABLE `purchase_recommendations` DISABLE KEYS */;
INSERT INTO `purchase_recommendations` VALUES (1,3,NULL,NULL,9,0,10,1,'historical_average','proposed',1,'2026-10-28 06:47:14.000000');
/*!40000 ALTER TABLE `purchase_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_role_permissions_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(2,1),(1,2),(4,2),(1,3),(2,3),(1,4),(5,4),(1,5),(3,5),(1,6),(5,6),(1,7),(5,7),(1,8),(2,8),(1,9);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_roles_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Quản trị viên','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,'manager','Quản lý','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,'sales','Nhân viên bán hàng','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,'purchasing','Nhân viên mua hàng','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(5,'warehouse','Nhân viên kho','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_items`
--

DROP TABLE IF EXISTS `sales_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sales_order_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(18,2) NOT NULL,
  `line_total` decimal(18,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_soi_order_product` (`sales_order_id`,`product_id`),
  KEY `fk_sales_order_items_product_id` (`product_id`),
  CONSTRAINT `fk_sales_order_items_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_sales_order_items_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `sales_orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_soi_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `ck_soi_qty` CHECK ((`quantity` > 0)),
  CONSTRAINT `ck_ss_so_quantity` CHECK (((`quantity` > 0) and (`unit_price` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_items`
--

LOCK TABLES `sales_order_items` WRITE;
/*!40000 ALTER TABLE `sales_order_items` DISABLE KEYS */;
INSERT INTO `sales_order_items` (`id`, `sales_order_id`, `product_id`, `quantity`, `unit_price`) VALUES (1,1,1,1,15900000.00),(2,1,4,1,8990000.00),(3,2,2,2,17900000.00),(4,2,5,1,18990000.00),(5,3,3,3,24490000.00),(6,3,6,1,450000.00),(7,4,4,1,8990000.00),(8,4,7,1,1290000.00),(9,5,5,2,18990000.00),(10,5,8,1,1490000.00),(11,6,6,3,450000.00),(12,6,9,1,3190000.00),(13,7,7,1,1290000.00),(14,7,10,1,5390000.00),(15,8,8,2,1490000.00),(16,8,1,1,15900000.00),(17,9,9,3,3190000.00),(18,9,2,1,17900000.00),(19,10,10,1,5390000.00),(20,10,3,1,24490000.00),(21,11,1,2,15900000.00),(22,11,4,1,8990000.00),(23,12,2,3,17900000.00),(24,12,5,1,18990000.00),(25,13,3,1,24490000.00),(26,13,6,1,450000.00),(27,14,4,2,8990000.00),(28,14,7,1,1290000.00),(29,15,5,3,18990000.00),(30,15,8,1,1490000.00),(31,16,6,1,450000.00),(32,16,9,1,3190000.00),(33,17,7,2,1290000.00),(34,17,10,1,5390000.00),(35,18,8,3,1490000.00),(36,18,1,1,15900000.00);
/*!40000 ALTER TABLE `sales_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_orders`
--

DROP TABLE IF EXISTS `sales_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `total_amount` decimal(18,2) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `confirmed_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `cancelled_by` bigint unsigned DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sales_orders_code` (`code`),
  KEY `ix_so_status_created` (`status`,`created_at`),
  KEY `fk_sales_orders_customer_id` (`customer_id`),
  KEY `fk_sales_orders_created_by` (`created_by`),
  KEY `fk_sales_orders_cancelled_by` (`cancelled_by`),
  CONSTRAINT `fk_sales_orders_cancelled_by` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_sales_orders_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_sales_orders_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_so_status` CHECK ((`status` in (_utf8mb4'draft',_utf8mb4'confirmed',_utf8mb4'completed',_utf8mb4'cancelled'))),
  CONSTRAINT `ck_so_total` CHECK ((`total_amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_orders`
--

LOCK TABLES `sales_orders` WRITE;
/*!40000 ALTER TABLE `sales_orders` DISABLE KEYS */;
INSERT INTO `sales_orders` VALUES (1,'DEMO-SO-001',1,'completed',24890000.00,3,'2026-06-17 10:00:00.000000','2026-06-17 10:00:00.000000',NULL,NULL,NULL,'2026-06-17 10:00:00.000000','2026-10-25 08:23:09.000000'),(2,'DEMO-SO-002',1,'completed',54790000.00,3,'2026-06-24 10:00:00.000000','2026-06-24 10:00:00.000000',NULL,NULL,NULL,'2026-06-24 10:00:00.000000','2026-10-25 08:23:09.000000'),(3,'DEMO-SO-003',1,'completed',73920000.00,3,'2026-07-01 10:00:00.000000','2026-07-01 10:00:00.000000',NULL,NULL,NULL,'2026-07-01 10:00:00.000000','2026-10-25 08:23:09.000000'),(4,'DEMO-SO-004',1,'completed',10280000.00,3,'2026-07-08 10:00:00.000000','2026-07-08 10:00:00.000000',NULL,NULL,NULL,'2026-07-08 10:00:00.000000','2026-10-25 08:23:09.000000'),(5,'DEMO-SO-005',1,'completed',39470000.00,3,'2026-07-15 10:00:00.000000','2026-07-15 10:00:00.000000',NULL,NULL,NULL,'2026-07-15 10:00:00.000000','2026-10-25 08:23:09.000000'),(6,'DEMO-SO-006',1,'completed',4540000.00,3,'2026-07-22 10:00:00.000000','2026-07-22 10:00:00.000000',NULL,NULL,NULL,'2026-07-22 10:00:00.000000','2026-10-25 08:23:09.000000'),(7,'DEMO-SO-007',1,'completed',6680000.00,3,'2026-07-29 10:00:00.000000','2026-07-29 10:00:00.000000',NULL,NULL,NULL,'2026-07-29 10:00:00.000000','2026-10-25 08:23:09.000000'),(8,'DEMO-SO-008',1,'completed',18880000.00,3,'2026-08-05 10:00:00.000000','2026-08-05 10:00:00.000000',NULL,NULL,NULL,'2026-08-05 10:00:00.000000','2026-10-25 08:23:09.000000'),(9,'DEMO-SO-009',1,'completed',27470000.00,3,'2026-08-12 10:00:00.000000','2026-08-12 10:00:00.000000',NULL,NULL,NULL,'2026-08-12 10:00:00.000000','2026-10-25 08:23:09.000000'),(10,'DEMO-SO-010',1,'completed',29880000.00,3,'2026-08-19 10:00:00.000000','2026-08-19 10:00:00.000000',NULL,NULL,NULL,'2026-08-19 10:00:00.000000','2026-10-25 08:23:09.000000'),(11,'DEMO-SO-011',1,'completed',40790000.00,3,'2026-08-26 10:00:00.000000','2026-08-26 10:00:00.000000',NULL,NULL,NULL,'2026-08-26 10:00:00.000000','2026-10-25 08:23:09.000000'),(12,'DEMO-SO-012',1,'completed',72690000.00,3,'2026-09-02 10:00:00.000000','2026-09-02 10:00:00.000000',NULL,NULL,NULL,'2026-09-02 10:00:00.000000','2026-10-25 08:23:09.000000'),(13,'DEMO-SO-013',1,'completed',24940000.00,3,'2026-09-09 10:00:00.000000','2026-09-09 10:00:00.000000',NULL,NULL,NULL,'2026-09-09 10:00:00.000000','2026-10-25 08:23:09.000000'),(14,'DEMO-SO-014',1,'completed',19270000.00,3,'2026-09-16 10:00:00.000000','2026-09-16 10:00:00.000000',NULL,NULL,NULL,'2026-09-16 10:00:00.000000','2026-10-25 08:23:09.000000'),(15,'DEMO-SO-015',1,'completed',58460000.00,3,'2026-09-23 10:00:00.000000','2026-09-23 10:00:00.000000',NULL,NULL,NULL,'2026-09-23 10:00:00.000000','2026-10-25 08:23:09.000000'),(16,'DEMO-SO-016',1,'completed',3640000.00,3,'2026-09-30 10:00:00.000000','2026-09-30 10:00:00.000000',NULL,NULL,NULL,'2026-09-30 10:00:00.000000','2026-10-25 08:23:09.000000'),(17,'DEMO-SO-017',1,'completed',7970000.00,3,'2026-10-07 10:00:00.000000','2026-10-07 10:00:00.000000',NULL,NULL,NULL,'2026-10-07 10:00:00.000000','2026-10-25 08:23:09.000000'),(18,'DEMO-SO-018',1,'completed',20370000.00,3,'2026-10-14 10:00:00.000000','2026-10-14 10:00:00.000000',NULL,NULL,NULL,'2026-10-14 10:00:00.000000','2026-10-25 08:23:09.000000');
/*!40000 ALTER TABLE `sales_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('0YHM9fyyCZRHFfcfA435VadcotRn6lkquMeWn0Qv',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJOeUlLOHlmcnFvcXRjZzM5R0NmY1VZQkZ5a0RzNlBkYU9QdXlKWWpPIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL3NtYXJ0c3RvY2sudGVzdFwvbG9naW4iLCJyb3V0ZSI6ImxvZ2luIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwidXJsIjpbXSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjEsInBhc3N3b3JkX2hhc2hfd2ViIjoiMzA0ZWUwNDA0MzczZWM3NWJmYTVkOTEzMDRiOTM5NWQ2NGM5MGNhNzE2MGYwZWI3YjZlNmZlMGRkNTkyYjAzNCJ9',1794390559),('fLcs3vWYzBQCyapfyCEb6frfSN5sm8CLPwsuruOw',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJJNWlmbTdLemZjTWRhSzNkZVN0RWZjRHNhS25EWThpbFFicHRxTVFJIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJ1cmwiOltdLCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MSwicGFzc3dvcmRfaGFzaF93ZWIiOiIzMDRlZTA0MDQzNzNlYzc1YmZhNWQ5MTMwNGI5Mzk1ZDY0YzkwY2E3MTYwZjBlYjdiNmU2ZmUwZGQ1OTJiMDM0In0=',1793290576),('M9cwLSwy6Te9R2TKQzoNFB3Qi7Xjnbl7txgygsMV',NULL,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36 Edg/157.0.0.0','eyJfdG9rZW4iOiJTVDJMQjlYSlJBT0QzQ0hsVnduOFZTSUVvUXgwVVpGQlphbzdrRDJCIiwidXJsIjp7ImludGVuZGVkIjoiaHR0cDpcL1wvc21hcnRzdG9jay50ZXN0XC9kYXNoYm9hcmQifSwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL3NtYXJ0c3RvY2sudGVzdFwvbG9naW4iLCJyb3V0ZSI6ImxvZ2luIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=',1794448592),('MyA9SrccZzdA7CZJRHW9nB9zjTBegNZYCASn6viN',4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJOMGw5bFU3QW5taXN4bVNYZHNOcEdlTTZTQ2d0VXpOODZlcmNuelZwIiwidXJsIjpbXSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJfcHJldmlvdXMiOnsidXJsIjoiaHR0cDpcL1wvc21hcnRzdG9jay50ZXN0XC9kYXNoYm9hcmQiLCJyb3V0ZSI6ImRhc2hib2FyZCJ9LCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6NCwicGFzc3dvcmRfaGFzaF93ZWIiOiI0ZjMzYzA4M2IwZmJiYmFlYjM2N2MzYWNiNTdiN2RhNmE2N2M2N2M5Y2UyNGFhNGUxYmIxMzU2Y2JkYzQyMzQ4In0=',1793460579),('oXE32CgQUcRIIzwQE6KWBdDC6Hn2Lp9FEy4moPap',2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJhMk4wVHRXVWJjSkZVeEw5VXFJczk3TU1VbWp2Vjhqb0hHM3ZkdFQ1IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJ1cmwiOltdLCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MiwicGFzc3dvcmRfaGFzaF93ZWIiOiIzNjlmMTQwNjNkYmYyYTIyODg0Yjc3NTE5ODVjMjFlZTU4MmIxN2UyYzIwNWJlNThkMGM4YmU4Mjg1YjRlMzgyIn0=',1793459087),('pImjbvPLDewbP50aADLiHxDaIci4dFyBCsRJzxC3',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJhV2dMcEhlem1HQ0Y5dXozbW1SN2F6VW9zVnhiUk5CbDN5WUdabUg2IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL3NtYXJ0c3RvY2sudGVzdFwvbG9naW4iLCJyb3V0ZSI6ImxvZ2luIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwidXJsIjpbXSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjEsInBhc3N3b3JkX2hhc2hfd2ViIjoiMzA0ZWUwNDA0MzczZWM3NWJmYTVkOTEzMDRiOTM5NWQ2NGM5MGNhNzE2MGYwZWI3YjZlNmZlMGRkNTkyYjAzNCIsImF1dGgiOnsicGFzc3dvcmRfY29uZmlybWVkX2F0IjoxNzkzMTcwMTg0fSwidHdvX2ZhY3Rvcl9lbXB0eV9hdCI6MTc5MzE3MDE4NH0=',1793170753),('S2YTElpnEUkaK3rjYQXVP3X5znmqhaTIYTqWoS5g',NULL,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJIWTRkUTBISm9NYThHV3dWY0xRaHFWT014QXVxN1lOdE1BOHNzUG9CIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL3NtYXJ0c3RvY2sudGVzdFwvbG9naW4iLCJyb3V0ZSI6ImxvZ2luIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwidXJsIjp7ImludGVuZGVkIjoiaHR0cDpcL1wvc21hcnRzdG9jay50ZXN0XC9kYXNoYm9hcmQifX0=',1793986098);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_adjustments`
--

DROP TABLE IF EXISTS `stock_adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_adjustments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inventory_id` bigint unsigned NOT NULL,
  `adjustment_type` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty_before` int unsigned NOT NULL,
  `qty_after` int unsigned NOT NULL,
  `quantity_delta` int NOT NULL,
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stock_adjustment_code` (`code`),
  KEY `fk_stock_adjustments_inventory_id` (`inventory_id`),
  KEY `fk_stock_adjustments_created_by` (`created_by`),
  CONSTRAINT `fk_stock_adjustments_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_stock_adjustments_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_ss_adjust_balance` CHECK ((((cast(`qty_before` as signed) + `quantity_delta`) = cast(`qty_after` as signed)) and (`quantity_delta` <> 0))),
  CONSTRAINT `ck_stock_adjust_delta` CHECK (((`quantity_delta` <> 0) and ((cast(`qty_before` as signed) + `quantity_delta`) = cast(`qty_after` as signed)))),
  CONSTRAINT `ck_stock_adjust_type` CHECK ((`adjustment_type` in (_utf8mb4'opening_balance',_utf8mb4'manual')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_adjustments`
--

LOCK TABLES `stock_adjustments` WRITE;
/*!40000 ALTER TABLE `stock_adjustments` DISABLE KEYS */;
INSERT INTO `stock_adjustments` VALUES (1,'ADJ-01M5S2FWGE0N077NZMMRYP33GN',1,'opening_balance',0,36,36,'Tồn đầu minh họa',5,'2026-10-25 08:23:02.000000'),(2,'ADJ-01M5S2FWH4EJXAN06863J4THGQ',2,'opening_balance',0,22,22,'Tồn đầu minh họa',5,'2026-10-25 08:23:02.000000'),(3,'ADJ-01M5S2FWHJ9K2NG4EBP6BHYEKV',3,'opening_balance',0,14,14,'Tồn đầu minh họa',5,'2026-10-25 08:23:02.000000'),(4,'ADJ-01M5S2FWJ1ZQQ1C1BKMQR0SBS7',4,'opening_balance',0,40,40,'Tồn đầu minh họa',5,'2026-10-25 08:23:02.000000'),(5,'ADJ-01M5S2FWJGGJEMQX9HCSSW91WA',5,'opening_balance',0,18,18,'Tồn đầu minh họa',5,'2026-10-25 08:23:02.000000'),(6,'ADJ-01M5S2FWJYCWKG9K6Z3ZDT1APS',6,'opening_balance',0,76,76,'Tồn đầu minh họa',5,'2026-10-25 08:23:03.000000'),(7,'ADJ-01M5S2FWKCQ4BSF2ZWW09V3XS6',7,'opening_balance',0,44,44,'Tồn đầu minh họa',5,'2026-10-25 08:23:03.000000'),(8,'ADJ-01M5S2FWKS9F6C6Z0QYSHN840S',8,'opening_balance',0,39,39,'Tồn đầu minh họa',5,'2026-10-25 08:23:03.000000'),(9,'ADJ-01M5S2FWM6RZ72GAFZT19AEJ5Y',9,'opening_balance',0,26,26,'Tồn đầu minh họa',5,'2026-10-25 08:23:03.000000'),(10,'ADJ-01M5S2FWMJ6CZXKCJKYTGXAWCG',10,'opening_balance',0,12,12,'Tồn đầu minh họa',5,'2026-10-25 08:23:03.000000');
/*!40000 ALTER TABLE `stock_adjustments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_suppliers_name` (`name`),
  CONSTRAINT `ck_suppliers_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Công ty Thiết bị A',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(2,'Nhà phân phối Công nghệ B',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000'),(3,'Kho hàng Điện tử C',NULL,NULL,NULL,'active','2026-10-25 08:23:03.000000','2026-10-25 08:23:03.000000');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_units_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'Cái','PCS','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_roles_role_id` (`role_id`),
  CONSTRAINT `fk_user_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1),(2,2),(3,3),(4,4),(5,5);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `email_verified_at` datetime(6) DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  CONSTRAINT `ck_users_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Quản trị viên','admin@smartstock.test','$2y$12$m1lPy3tr6Q78byR6OQegquZhy9yqf4Ca/ZlMHPrKkiV3.n94pNBjW',NULL,NULL,NULL,'active','2026-10-25 08:23:02.000000','03QWUtl9P89kYmeWKyYJObOkZ0MwsYa6UCA6gtxW4Ie0B5xp0c7f0oWCKQJf','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(2,'Quản lý','manager@smartstock.test','$2y$12$a8u7MaYIOno0ujzsy1eulOP8.su6fVG9Fre9sGCF5fhlo7nuCu9ju',NULL,NULL,NULL,'active','2026-10-25 08:23:02.000000',NULL,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(3,'Nhân viên bán hàng','sales@smartstock.test','$2y$12$pJsjo/mz0/CDyqIngC.q8O5mlQfuuASUoF5i4sEqnoflvD2WOgitK',NULL,NULL,NULL,'active','2026-10-25 08:23:02.000000',NULL,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(4,'Nhân viên mua hàng','purchasing@smartstock.test','$2y$12$daQl2pSOSfjNmpf/MX84COaJjufRs/SJlGnQACAAfHsQkVWIY0ZIe',NULL,NULL,NULL,'active','2026-10-25 08:23:02.000000',NULL,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000'),(5,'Nhân viên kho','warehouse@smartstock.test','$2y$12$ujMzdLNs5ZIc4B2X/uinHeiBOCuO9YuW0UNpAdIjgYMwt.GOcXDza',NULL,NULL,NULL,'active','2026-10-25 08:23:02.000000',NULL,'2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_warehouses_code` (`code`),
  CONSTRAINT `ck_warehouses_status` CHECK ((`status` in (_utf8mb4'active',_utf8mb4'inactive')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
INSERT INTO `warehouses` VALUES (1,'MAIN','Kho chính','active','2026-10-25 08:23:02.000000','2026-10-25 08:23:02.000000');
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-13 13:36:23
