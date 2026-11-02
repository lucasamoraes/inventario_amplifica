
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `action` varchar(40) NOT NULL,
  `entity_type` varchar(60) NOT NULL,
  `entity_id` bigint(20) unsigned DEFAULT NULL,
  `details_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details_json`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_audit_company` (`company_id`,`created_at`),
  KEY `fk_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,1,'save','computer',34,'[]','127.0.0.1','2026-11-01 12:24:13'),(2,1,1,'save','computer',11,'[]','127.0.0.1','2026-11-01 12:48:13'),(3,1,1,'save','computer',20,'[]','::1','2026-11-02 14:36:31'),(4,1,1,'save','computer',21,'[]','::1','2026-11-02 14:38:23');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `catalog_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `catalog_type` enum('sector','location','asset_status') NOT NULL,
  `name` varchar(140) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_catalog_item` (`company_id`,`catalog_type`,`name`),
  CONSTRAINT `fk_catalog_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `catalog_items` WRITE;
/*!40000 ALTER TABLE `catalog_items` DISABLE KEYS */;
INSERT INTO `catalog_items` VALUES (1,1,'sector','Áudio e Vídeo',1,'2026-11-01 12:31:26'),(2,1,'sector','Coordenação Ensino Médio',1,'2026-11-01 12:31:26'),(3,1,'sector','Coordenação Fundamental',1,'2026-11-01 12:31:26'),(4,1,'sector','Coordenação Pedagógica',1,'2026-11-01 12:31:26'),(5,1,'sector','Financeiro',1,'2026-11-01 12:31:26'),(6,1,'sector','Gerencia Adm',1,'2026-11-01 12:31:26'),(7,1,'sector','Gráfica',1,'2026-11-01 12:31:26'),(8,1,'sector','Marketing',1,'2026-11-01 12:31:26'),(9,1,'sector','Notebook Reserva',1,'2026-11-01 12:31:26'),(10,1,'sector','Portaria',1,'2026-11-01 12:31:26'),(11,1,'sector','Sala Criativa',1,'2026-11-01 12:31:26'),(12,1,'sector','Sala de Estudo',1,'2026-11-01 12:31:26'),(13,1,'sector','Secretaria',1,'2026-11-01 12:31:26'),(16,1,'asset_status','Em uso',1,'2026-11-01 12:31:26'),(17,1,'asset_status','Reserva',1,'2026-11-01 12:31:26'),(18,1,'asset_status','Em manutenþÒo',1,'2026-11-01 12:31:26'),(19,1,'asset_status','Baixado',1,'2026-11-01 12:31:26'),(23,1,'asset_status','Em manutenção',1,'2026-11-01 12:32:13');
/*!40000 ALTER TABLE `catalog_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(160) NOT NULL,
  `slug` varchar(80) NOT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `primary_color` char(7) NOT NULL DEFAULT '#173F73',
  `accent_color` char(7) NOT NULL DEFAULT '#F3B61F',
  `critical_year_before` smallint(6) NOT NULL DEFAULT 2019,
  `critical_ram_below` smallint(6) NOT NULL DEFAULT 8,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `attention_score_threshold` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `critical_score_threshold` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `ssd_mitigation_points` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Colégio CAVE','cave','/media/company-1-cb6c7a4b.png','#941a2a','#f3b61f',2019,8,1,'2026-10-31 12:50:50',1,3,1);
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `computers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `computers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `collected_at` datetime DEFAULT NULL,
  `computer_name` varchar(120) NOT NULL,
  `sector` varchar(140) DEFAULT NULL,
  `assigned_user` varchar(160) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `model` varchar(160) DEFAULT NULL,
  `manufacture_year` smallint(6) DEFAULT NULL,
  `service_tag` varchar(120) DEFAULT NULL,
  `processor` varchar(255) DEFAULT NULL,
  `ram_gb` smallint(6) DEFAULT NULL,
  `ram_slots_detail` varchar(255) DEFAULT NULL,
  `windows_version` varchar(160) DEFAULT NULL,
  `local_ip` varchar(45) DEFAULT NULL,
  `mac_address` varchar(30) DEFAULT NULL,
  `location` varchar(140) DEFAULT NULL,
  `asset_status` varchar(80) NOT NULL DEFAULT 'Em uso',
  `notes` text DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_company_computer` (`company_id`,`computer_name`),
  KEY `ix_company_sector` (`company_id`,`sector`),
  KEY `ix_company_user` (`company_id`,`assigned_user`),
  KEY `fk_computers_created` (`created_by`),
  KEY `fk_computers_updated` (`updated_by`),
  CONSTRAINT `fk_computers_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_computers_created` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_computers_updated` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `computers` WRITE;
/*!40000 ALTER TABLE `computers` DISABLE KEYS */;
INSERT INTO `computers` VALUES (1,1,'2026-10-31 07:34:00','DESKTOP-9KGL3II',NULL,'Vanessa Lage','Dell Inc.','Inspiron 3647',2015,'B8ZKVG2','Intel(R) Core(TM) i5-4460S CPU @ 2.90GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','192.168.4.218','84-7B-EB-E4-9E-57',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(2,1,'2026-10-31 07:41:00','DESKTOP-H3DB2F1',NULL,'Lenilson','Dell Inc.','Vostro 3681',2025,'9KMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Home Single Language','192.168.4.143','B0-7B-25-0E-76-14',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(3,1,'2026-10-31 07:45:00','DESKTOP-BFELGCU',NULL,'Vanessa','Dell Inc.','Dell Pro Micro QCM1250',2026,'6VK2JG4','Intel(R) Core(TM) Ultra 5 235T',16,'1 pente(s) (16GB 5600MHz)','Microsoft Windows 11 Pro','192.168.4.157','D0-C1-B5-80-14-38',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(4,1,'2026-10-31 07:52:00','DESKTOP-RMPPLVF',NULL,'Virginia','Dell Inc.','Dell Pro Micro QCM1250',2025,'3SK2JG4','Intel(R) Core(TM) Ultra 5 235T',16,'1 pente(s) (16GB 5600MHz)','Microsoft Windows 11 Pro','192.168.4.48','D0-C1-B5-80-13-C7',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(5,1,'2026-10-31 08:02:00','DESKTOP-BOCQDKO','Marketing','Fernanda Henrique','Dell Inc.','Inspiron 3647',2015,'D0SVVC2','Intel(R) Core(TM) i5-4460S CPU @ 2.90GHz',8,'1 pente(s) (8GB 1600MHz)','Microsoft Windows 11 Pro','192.168.4.229','F4-8E-38-E1-AC-41',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(6,1,'2026-10-31 08:07:00','DESKTOP-VA7HBQ8','Marketing','Gesane','Dell Inc.','Dell Pro Micro QCM1250',2026,'HRK2JG4','Intel(R) Core(TM) Ultra 5 235T',16,'1 pente(s) (16GB 5600MHz)','Microsoft Windows 11 Pro','192.168.4.153','D0-C1-B5-80-0C-37',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(7,1,'2026-10-31 08:19:00','DESKTOP-JUNPKMS','Coordenação Fundamental','Lorena Oliveira','Dell Inc.','Vostro 3681',2021,'8KMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Home Single Language','192.168.4.146','B0-7B-25-0E-76-8C',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(8,1,'2026-10-31 08:24:00','FUNDAMENTAL','Coordenação Fundamental','Simone Arcuri','Dell Inc.','Vostro 3681',2021,'DKMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Home Single Language','192.168.4.148','B0-7B-25-0E-76-75',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(9,1,'2026-10-31 08:43:00','DESKTOP-P79C823','Coordenação Ensino Médio','Roberta Bretas','HP','HP ProDesk 400 G5 SFF',2023,'BRJ0037BH6','Intel(R) Core(TM) i5-8500 CPU @ 3.00GHz',8,'1 pente(s) (8GB 2667MHz)','Microsoft Windows 11 Pro','192.168.4.39','04-0E-3C-FC-B1-7D',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(10,1,'2026-10-31 08:46:00','DESKTOP-7P7OELB','Coordenação Ensino Médio','Mesa lado roberta','Dell Inc.','OptiPlex 7020',2015,'BMSMF82','Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','192.168.4.140','34-E6-D7-FB-CD-31',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(11,1,'2026-10-31 08:59:00','CAVEON1','Coordenação Pedagógica','Andreza','Dell Inc.','Inspiron 3647',2013,'HCYFKZ1','Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','192.168.4.201','A4-1F-72-FA-4B-DA',NULL,'Em uso','teste',NULL,1,'2026-10-31 12:50:50','2026-11-01 12:48:13'),(12,1,'2026-10-31 09:01:00','PC-CLAUDIA','Coordenação Pedagógica','Claudia merces','Dell Inc.','Dell Pro Micro QCM1250',2026,'FRK2JG4','Intel(R) Core(TM) Ultra 5 235T',16,'1 pente(s) (16GB 5600MHz)','Microsoft Windows 11 Pro','192.168.4.16','D0-C1-B5-80-0C-5A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(13,1,'2026-10-31 09:10:00','DESKTOP-GHPU1PI','Secretaria','Vivian','Dell Inc.','Inspiron 3647',2013,'1CYFKZ1','Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','192.168.4.46','A4-1F-72-FA-73-D1',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(14,1,'2026-10-31 09:12:00','DESKTOP-ATDTPJ6','Secretaria','Nayara','Dell Inc.','Dell Pro Micro QCM1250',2026,'CSK2JG4','Intel(R) Core(TM) Ultra 5 235T',16,'1 pente(s) (16GB 5600MHz)','Microsoft Windows 11 Pro','192.168.4.68','D0-C1-B5-80-16-6D',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(15,1,'2026-10-31 09:15:00','DESKTOP-0LTNRGS','Secretaria','Secretaria reserva 4','HP','HP ProDesk 400 G5 SFF',2020,'BRJ0037BTW','Intel(R) Core(TM) i5-8500 CPU @ 3.00GHz',8,'1 pente(s) (8GB 2667MHz)','Microsoft Windows 11 Pro','192.168.4.141','04-0E-3C-FC-B1-9A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(16,1,'2026-10-31 09:15:00','CAVE03','Secretaria','Gabriela Sec','Dell Inc.','Vostro 3681',2022,'87401D3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Home Single Language','192.168.4.52','B0-7B-25-17-7F-A7',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(17,1,'2026-10-31 09:20:00','DESKTOP-A67S0M9','Notebook Reserva','Notebook Sec','SAMSUNG ELECTRONICS CO., LTD.','300E5K/300E5Q',2016,'08639QAJA01486','Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Home Single Language','10.0.1.49','98-83-89-8E-38-BF',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(18,1,'2026-10-31 09:27:00','EST-ALE','Gerencia Adm','Alessandra','Dell Inc.','OptiPlex 390',2013,'CXVX8S1','Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1333MHz)','Microsoft Windows 10 Pro','192.168.4.123','78-2B-CB-C3-F6-21',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(19,1,'2026-10-31 09:30:00','DESKTOP-6394T4J','Gerencia Adm','Vivian','Dell Inc.','Inspiron 3647',2015,'GX5CF82','Intel(R) Core(TM) i5-4460S CPU @ 2.90GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1600MHz)','Microsoft Windows 10 Home Single Language','172100101183','44-1C-A8-C0-1F-25',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(20,1,'2026-10-31 09:36:00','DESKTOP-LM5LS2I','Financeiro','Gabriela Alex','Dell Inc.','Vostro 3681',2021,'BKMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Pro','Sem rede','B0-7B-25-0E-76-5D',NULL,'Em uso',NULL,NULL,1,'2026-10-31 12:50:50','2026-11-02 14:36:31'),(21,1,'2026-10-31 09:41:00','AudioVideo03-PC','Áudio e Vídeo','AudioVideo03-PC','Dell Inc.','OptiPlex 7020',2015,NULL,'Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 7 Pro',NULL,NULL,NULL,'Em uso',NULL,NULL,1,'2026-10-31 12:50:50','2026-11-02 14:38:23'),(22,1,'2026-10-31 09:48:00','DESKTOP-GPQQSDF','Áudio e Vídeo','Audioevideo2','Dell Inc.','OptiPlex 390',2018,'78CX2V1','Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1333MHz)','Microsoft Windows 10 Pro','192.168.4.102','5C-F9-DD-EC-37-6B',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(23,1,'2026-10-31 09:48:00','DESKTOP-GPQQSDF','Áudio e Vídeo','Audioevideo1','Dell Inc.','OptiPlex 390',2018,'78CX2V1','Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1333MHz)','Microsoft Windows 7 Pro','Sem Rede','N/A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(24,1,'2026-10-31 09:49:00','DESKTOP-RHRDL16','Áudio e Vídeo','Parada Audio e Video 1','Dell Inc.','Inspiron 3647',2013,'6BYFKZ1','Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','Sem Rede','N/A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(25,1,'2026-10-31 09:49:00','DESKTOP-RHRDL16','Áudio e Vídeo','Parada Audio e Video 2','Dell Inc.','OptiPlex 390',2018,'78CX2V1','Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1333MHz)','Microsoft Windows 7 Ultimate','Sem Rede','N/A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(26,1,'2026-10-31 09:49:00','Sem nome','Áudio e Vídeo','Audioevido4 PC professor','Dell Inc.','Vostro 3710',2022,'5YSD5S3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(27,1,'2026-10-31 09:54:00','BETINHA','Áudio e Vídeo','audio video 5 monitor ruim','Dell Inc.','Vostro 3681',2021,'7KMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Pro','10.0.1.63','5C-CD-5B-C3-52-99',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(28,1,'2026-10-31 10:21:00','LAPTOP-M5HU1IG1','Notebook Reserva','Notebook Botão arrumado','SAMSUNG ELECTRONICS CO., LTD.','300E5K/300E5Q',2016,'08639QAJA01686','Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Home Single Language','10.0.1.25','98-83-89-8D-AE-5F',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(29,1,'2026-10-31 10:21:00','SAMSUNG-AULAS','Notebook Reserva','Notebook Botão teclado e botão fundo','SAMSUNG ELECTRONICS CO., LTD.','300E5K/300E5Q',2016,'08639QAJA01676','Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Home Single Language','172.100.101.75','98-83-89-8D-B1-DD',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(30,1,'2026-10-31 10:24:00','DESKTOP-AI7B0M3','Notebook Reserva','Notebook Botão fundo','SAMSUNG ELECTRONICS CO., LTD.','300E5K/300E5Q',2016,'08639QAJA01451','Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 11 Pro','10.0.0.44','98-83-89-8D-B1-2F',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(31,1,'2026-10-31 10:25:00','DESKTOP-23QV58D','Sala Criativa','Sala Criativa','Dell Inc.','OptiPlex 390',2013,'CXVL8S1','Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz',8,'2 pente(s) (4GB 1333MHz + 4GB 1333MHz)','Microsoft Windows 10 Pro','192.168.4.175','78-2B-CB-C3-F5-5D',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50'),(32,1,'2026-10-31 10:31:00','DELLGRAFICA','Gráfica','Grafica Professor','Dell Inc.','OptiPlex Micro Plus 7010',2026,'JCLJG04','13th Gen Intel(R) Core(TM) i7-13700T',32,'2 pente(s) (16GB 4800MHz + 16GB 4800MHz)','Microsoft Windows 11 Pro','192.168.4.126','D0-94-66-E2-8A-2A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(33,1,'2026-10-31 10:35:00','DESKTOP-1BKEITM','Gráfica','Grafica PC catraca','Dell Inc.','Inspiron 3647',2019,'HBYFKZ1','Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz',8,'2 pente(s) (4GB 1600MHz + 4GB 1600MHz)','Microsoft Windows 10 Pro','192.168.4.216','A4-1F-72-FA-61-7C',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:56:28'),(34,1,'2026-10-31 11:10:00','DESKTOP-6DBLREB','Sala de Estudo','Sala de Estudo','Dell Inc.','OptiPlex 3040',2016,'4PGBMD2','Intel(R) Core(TM) i3-6100T CPU @ 3.20GHz',8,'1 pente(s) (8GB 1600MHz)','Microsoft Windows 10 Pro','Sem Rede','N/A',NULL,'Em uso',NULL,NULL,1,'2026-10-31 12:50:50','2026-11-01 12:24:13'),(35,1,'2026-10-31 11:17:00','DESKTOP-EL8MM4P','Portaria','Entrada Portaria','Dell Inc.','Vostro 3681',2021,'CKMYRB3','Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz',8,'1 pente(s) (8GB 3200MHz)','Microsoft Windows 11 Home Single Language','Sem Rede','N/A',NULL,'Em uso',NULL,NULL,NULL,'2026-10-31 12:50:50','2026-10-31 12:50:50');
/*!40000 ALTER TABLE `computers` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `custom_field_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_field_values` (
  `computer_id` bigint(20) unsigned NOT NULL,
  `custom_field_id` bigint(20) unsigned NOT NULL,
  `value_text` text DEFAULT NULL,
  PRIMARY KEY (`computer_id`,`custom_field_id`),
  KEY `fk_value_field` (`custom_field_id`),
  CONSTRAINT `fk_value_computer` FOREIGN KEY (`computer_id`) REFERENCES `computers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_value_field` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `custom_field_values` WRITE;
/*!40000 ALTER TABLE `custom_field_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_field_values` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_fields` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `field_key` varchar(120) NOT NULL,
  `field_type` enum('text','number','date','select','textarea') NOT NULL DEFAULT 'text',
  `options_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options_json`)),
  `required` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_company_field` (`company_id`,`field_key`),
  CONSTRAINT `fk_custom_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `disks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `computer_id` bigint(20) unsigned NOT NULL,
  `disk_type` enum('SSD','HDD','NVMe','Outro') NOT NULL,
  `brand_model` varchar(190) DEFAULT NULL,
  `size_gb` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_disks_computer` (`computer_id`),
  CONSTRAINT `fk_disks_computer` FOREIGN KEY (`computer_id`) REFERENCES `computers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `disks` WRITE;
/*!40000 ALTER TABLE `disks` DISABLE KEYS */;
INSERT INTO `disks` VALUES (1,1,'SSD','ADATA SU650',224),(2,1,'HDD','TOSHIBA DT01ACA100',932),(3,2,'SSD','KINGSTON SA400S37240G',224),(4,3,'NVMe','NVMe BM9C1 Samsung 512GB',477),(5,4,'NVMe','NVMe BM9C1 Samsung 512GB',477),(6,5,'HDD','Generic- Multi-Card USB Device',0),(7,5,'SSD','WALRAM 512GB',477),(8,6,'NVMe','NVMe BM9C1 Samsung 512GB',477),(9,6,'SSD','SanDisk Portable SSD SCSI Disk Device',932),(10,7,'SSD','ADATA SU650',224),(11,8,'SSD','KINGSTON SA400S37480G',447),(12,9,'HDD','WDC WD10EZEX-60WN4A1',932),(13,9,'NVMe','KNUP NVME 256GB',238),(14,9,'SSD','VendorCo ProductCode USB Device',15),(15,10,'SSD','KINGSTON SA400S37240G',224),(17,12,'NVMe','NVMe BM9C1 Samsung 512GB',477),(18,13,'SSD','KINGSTON SA400S37480G',447),(19,13,'HDD','ST1000DM003-1CH162',932),(20,14,'NVMe','NVMe BM9C1 Samsung 512GB',477),(21,15,'HDD','WDC WD10EZEX-60WN4A1',932),(22,15,'NVMe','KNUP NVME 256GB',238),(23,16,'SSD','KINGSTON SA400S37240G',224),(24,17,'HDD','TOSHIBA MQ01ABD100',932),(25,18,'SSD','WDC WD3200AAKX-753CA1 ATA Device',298),(26,18,'SSD','ADATA SU650 ATA Device',224),(27,19,'SSD','KINGSTON SA400S37240G',224),(30,22,'SSD','KINGSTON SA400S37240G ATA Device',224),(31,23,'SSD','KINGSTON SA400S37240G ATA Device',224),(32,24,'HDD','ST1000DM010-2EP102',932),(33,25,'HDD','WD',320),(34,27,'NVMe','NVMe KNUP NVME 256GB',238),(35,27,'HDD','ST1000DM010-2EP102',932),(36,28,'HDD','SAMSUNG MZMTD128HAFV-000',932),(37,29,'HDD','TOSHIBA MQ01ABD100',932),(38,30,'SSD','WALRAM 480GB',447),(39,31,'SSD','CT240BX500SSD1 ATA Device',224),(40,32,'NVMe','NVMe KXG80ZNV512G NVMe KIOXIA 512GB',477),(41,33,'HDD','Generic- Multi-Card USB Device',0),(42,33,'HDD','ST1000DM003-1CH162',932),(44,35,'HDD','ST1000DM010-2EP102',932),(45,34,'HDD','WDC WD5000LPLX-75ZNTT0',466),(46,11,'SSD','SATA SSD',238),(47,20,'SSD','SanDisk SSD PLUS 480GB',447),(48,21,'SSD','KINGSTON SA400S37240G',224);
/*!40000 ALTER TABLE `disks` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(190) DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `succeeded` tinyint(1) NOT NULL DEFAULT 0,
  `attempted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_login_ip` (`ip_address`,`attempted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES (1,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 12:51:19'),(2,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 12:51:32'),(3,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 12:54:37'),(4,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 12:55:06'),(5,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 12:56:53'),(6,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 13:02:51'),(7,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 13:06:16'),(8,'admin@amplificati.test','127.0.0.1',1,'2026-10-31 13:08:47'),(9,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:05:37'),(10,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:05:56'),(11,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:06:18'),(12,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:12:48'),(13,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:13:10'),(14,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:32:13'),(15,'admin@amplificati.test','127.0.0.1',1,'2026-11-01 12:32:24'),(16,'admin@amplificati.test','::1',1,'2026-11-02 14:32:38'),(17,'admin@amplificati.test','::1',1,'2026-11-02 14:33:41');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `platform_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platform_admins` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(160) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `platform_admins` WRITE;
/*!40000 ALTER TABLE `platform_admins` DISABLE KEYS */;
INSERT INTO `platform_admins` VALUES (1,'Lucas Moraes','lucas.moraes@amplificati.com.br','$2y$10$Ip.rGIXcmCgM5u9WJFpr6eTnOUl3g0TKRZBdXJo.Jhrld/uM4mBRG',1,1,'2026-11-02 16:08:33','2026-11-02 16:08:20');
/*!40000 ALTER TABLE `platform_admins` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `name` varchar(160) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('employee','it','manager') NOT NULL DEFAULT 'employee',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `failed_attempts` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_company_email` (`company_id`,`email`),
  CONSTRAINT `fk_users_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Administrador','admin@amplificati.test','$2y$10$WydJOQL3NvsA4qShFzbdQe/zrF.OcUHlYo9AW5Gi36eutvloftQ.G','manager',1,0,NULL,'2026-11-02 14:33:41','2026-10-31 12:50:50','2026-11-02 14:33:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

