-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: binabola
-- ------------------------------------------------------
-- Server version	8.0.31-google

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
-- Current Database: `binabola`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `binabola` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `binabola`;

--
-- Table structure for table `calories`
--

DROP TABLE IF EXISTS `calories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  `foods` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `calorie` int NOT NULL,
  `amount` int NOT NULL,
  `category` varchar(20) NOT NULL,
  `total` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `calories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calories`
--

LOCK TABLES `calories` WRITE;
/*!40000 ALTER TABLE `calories` DISABLE KEYS */;
INSERT INTO `calories` VALUES (3,26,'2024-06-05','apel',300,3,'morning',900),(4,26,'2024-06-05','apel',300,3,'night',900),(5,26,'2024-06-05','apel',300,3,'morning',900),(6,26,'2024-06-12','apel',300,3,'morning',900),(7,28,'2024-06-20','telur',153,2,'morning',306),(8,29,'2024-06-20','daging',288,2,'morning',576),(9,30,'2024-06-20','daging',288,2,'morning',576),(10,30,'2024-06-20','daging',288,3,'morning',864),(11,30,'2024-06-20','Ayam goreng',295,1,'morning',295);
/*!40000 ALTER TABLE `calories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_missions`
--

DROP TABLE IF EXISTS `daily_missions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_missions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exercise_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `FK_daily_missions_exercises` (`exercise_id`),
  CONSTRAINT `daily_missions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_daily_missions_exercises` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_missions`
--

LOCK TABLES `daily_missions` WRITE;
/*!40000 ALTER TABLE `daily_missions` DISABLE KEYS */;
INSERT INTO `daily_missions` VALUES (31,26,1,'2024-06-19',2),(32,26,6,'2024-06-19',2),(33,27,6,'2024-06-19',2),(34,27,1,'2024-06-19',1),(35,28,5,'2024-06-19',1),(36,28,5,'2024-06-20',1),(37,28,5,'2024-06-20',1),(38,28,3,'2024-06-20',2),(39,29,1,'2024-06-20',1),(40,29,5,'2024-06-20',1),(41,27,1,'2024-06-20',1),(42,27,5,'2024-06-20',1),(43,30,2,'2024-06-20',1),(44,30,5,'2024-06-20',1),(45,28,6,'2024-06-20',2),(46,28,6,'2024-06-20',2),(47,28,6,'2024-06-20',2),(48,28,6,'2024-06-20',2),(49,30,1,'2024-06-20',1),(50,28,1,'2024-06-20',1),(51,30,4,'2024-06-20',1),(52,30,6,'2024-06-20',1);
/*!40000 ALTER TABLE `daily_missions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercises` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `detail` text,
  `duration` time NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `step` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `calorie_out` int DEFAULT NULL,
  `foto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `video` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `body_part_needed` varchar(50) DEFAULT NULL,
  `is_support_interactive` int DEFAULT NULL,
  `interactive_setting_id` int DEFAULT NULL,
  `interactive_body_part_segment_value_id` int DEFAULT NULL,
  `submission` tinyint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
INSERT INTO `exercises` VALUES (1,'Dumbbell Curl','Dumbbell curl adalah latihan bisep yang menargetkan otot-otot di lengan Anda. Tujuan : Pada latihan strength, endurance, dan speed, latihan strength menjadi latihan urutan pertama yang harus dilakukan. Latihan ini akan membantu menguatkan otot dari para pemain sepakbola.\n','00:10:00','Strength','Berdirilah dengan kaki terbuka selebar bahu. Pegang dumbel di masing-masing tangan dengan lengan terentang penuh dan telapak tangan menghadap ke depan. Jaga agar lengan atas Anda tetap diam dan hembuskan napas saat Anda menggulung beban sambil mengencangkan otot bisep. Tarik napas dan perlahan-lahan mulai turunkan dumbel kembali ke posisi awal.',50,'https://storage.googleapis.com/binabola/asset/dumbbel.png','https://storage.googleapis.com/binabola/asset/biceps_curl_ball_model.gif','right_hand,left_hand',1,1,1,0),(2,'Push Up','Latihan beban tubuh yang menargetkan dada, bahu, dan trisep. Tujuan : Pada latihan strength, endurance, dan speed, latihan strength menjadi latihan urutan pertama yang harus dilakukan. Latihan ini akan membantu menguatkan otot dari para pemain sepakbola.\n','00:10:00','Strength','Mulailah dengan posisi papan. Turunkan tubuh Anda hingga dada hampir menyentuh lantai. Dorong kembali ke posisi awal.',80,'https://storage.googleapis.com/binabola/asset/push%20up.png','https://storage.googleapis.com/binabola/asset/push_up_model.gif','right_hand,left_hand',1,2,2,0),(3,'Dumbbell Sumo Squat','Variasi dari squat tradisional yang menargetkan paha bagian dalam dan bokong. Tujuan : Pada latihan strength, endurance, dan speed, latihan strength menjadi latihan urutan pertama yang harus dilakukan. Latihan ini akan membantu menguatkan otot dari para pemain sepakbola.\n','00:10:00','Strength','Berdirilah dengan kaki lebih lebar dari lebar bahu, dengan jari-jari kaki mengarah keluar. Pegang dumbbell dengan kedua tangan di depan Anda. Jongkok, jaga punggung tetap lurus. Kembali ke posisi awal.',60,'https://storage.googleapis.com/binabola/asset/dumbbel.png','https://storage.googleapis.com/binabola/asset/sumo_squat_model.gif','right_leg,left_leg',1,3,3,0),(4,'Biceps Curl With Bosu Ball','Latihan yang menggabungkan stabilisasi inti dengan penguatan bisep. Tujuan : Pada latihan strength, endurance, dan speed, latihan strength menjadi latihan urutan pertama yang harus dilakukan. Latihan ini akan membantu menguatkan otot dari para pemain sepakbola.\n','00:10:00','Strength','Duduklah di atas bola Bosu dalam posisi duduk V. Lakukan bicep curl sambil menjaga keseimbangan. Ulangi step tersebut.',80,'https://storage.googleapis.com/binabola/asset/biceps.png','https://storage.googleapis.com/binabola/asset/biceps_curl_ball_model.gif','right_hand,left_hand',1,1,1,0),(5,'Running','Latihan lari adalah bentuk olahraga kardio yang melibatkan aktivitas berlari dengan tujuan meningkatkan kebugaran fisik, stamina, dan kesehatan jantung.','00:30:00','Endurance','Ingat, latihan jogging untuk endurance mengutamakan aspek durasi yang lama dan jarak yang jauh\n. ⁠Persiapkan tempat untuk jogging dan alat untuk menghitung waktu\n. ⁠Lakukan jogging dengan kecepatan yang konstan selama 10 menit\n. ⁠Setelah 2 minggu melakukan jogging dengan durasi yang sama, tingkatkan waktu tempuh sebanyak 2 menit dari durasi sebelumnya\n. ⁠Lakukan latihan jogging dengan durasi yang baru untuk 2 minggu selanjutnya, dan seterusnya',300,'https://storage.googleapis.com/binabola/asset/run.png','video',NULL,NULL,NULL,NULL,0),(6,'Zig zag','Lari Zig Zag adalah bentuk latihan lari yang melibatkan berlari dalam pola zig zag, yaitu dengan berlari secara cepat dari satu titik ke titik lainnya secara bergantian ke kiri dan ke kanan. Latihan ini sangat efektif untuk meningkatkan kelincahan, kecepatan perubahan arah, koordinasi, dan keseimbangan, yang sangat penting dalam olahraga sepak bola','00:30:00','Speed','Persiapkan alat untuk penanda, seperti cones (kerucut)\n. ⁠Persiapkan tempat kosong untuk melakukan latihan sekitar 12 meter, letakkan cones di kedua ujung area lari\n. Jarak 2 meter pertama akan dipakai untuk melakukan latihan koordinasi dan jarak 10 meter sisanya untuk dipakai melakukan sprint\n. ⁠Pada 2 meter pertama, letakkan 3 cones tambahan dengan jarak masing-masing sekitar 50 cm. ⁠Lakukan latihan koordinasi dengan melakukan gerakan zigzag pada 2 meter pertama secara cepat\n. ⁠Lalu, lari dengan kecepatan maksimal hingga cones terakhir.',400,'https://storage.googleapis.com/binabola/asset/zigzag.png',NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expires` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exercise_id` int NOT NULL,
  `video_url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_submission_users` (`user_id`),
  KEY `FK_submission_exercises` (`exercise_id`),
  CONSTRAINT `FK_submission_exercises` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`),
  CONSTRAINT `FK_submission_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission`
--

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
INSERT INTO `submission` VALUES (7,26,6,'https://www.youtube.com/watch?v=your_video_id','2024-06-19'),(8,27,6,'https://www.youtube.com/watch?v=your_video_id','2024-06-19'),(9,26,6,'https://www.youtube.com/watch?v=your_video_id','2024-06-20'),(10,28,6,'https://www.youtube.com/watch?v=12345','2024-06-20'),(11,30,6,'http://pornhub.com','2024-06-20');
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('L','P') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `calorie` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (26,'farhan17764','farhan17764@gmail.com','$2b$10$uAdbTddRMt9Ze52aMfZCKOFEdv4XqDo701/sZgp9MzTOzsARmgNuS','2024-06-12 15:31:32','user','Farhan Al Farisi',179.00,68.00,'2002-11-12','L',1739.06),(27,'ahan','ahan@gmail.com','$2b$10$1YVBhpa7d/TOUDLB7/11f.J/MntwyHn/G4VibC/ajsf4/1KwWXty6','2024-06-19 21:43:27','user','Farhan Al Farisi',179.00,68.00,'2002-11-12','L',1739.06),(28,'hafidzfadillah23','hafidzfadillah23@gmail.com','$2b$10$8r22KlFl3hG.jCPpe3Iq2.HlHPxm04LOCGQIC6gFbsqQy4BsV/1s6','2024-06-19 20:25:49','user','Hafidz Fadillah',170.00,70.00,'2003-07-31','L',1728.36),(29,'rifqilukmansyah2001','rifqilukmansyah2001@gmail.com','$2b$10$9E3GFw5qG5/gNR2gjSy9EOSO2GCvlycr.e3mFf6IgCHgz8Fd4R15y','2024-06-20 05:11:51','user','Rifqi Lukmansyah',165.00,80.00,'2001-08-03','L',1826.96),(30,'rifqilukmansyah381','rifqilukmansyah381@gmail.com','$2b$10$S/cLXad4/aPXfyqywAuHXu8gtgikpdS3eFCLCCvkDxOytXbFpKuI6','2024-06-20 08:56:35','user','Rifqi Lukmansyah',165.00,80.00,'2024-06-19','L',1952.36),(31,'ahann','ahann@gmail.com','$2b$10$nAH6Th9Tmr1LR3R/duBo/e913I5n7Tw2YE9YegTioasOhqxsrSnPi','2024-06-20 17:45:19','user','Farhan Al Farisi',179.00,68.00,'2002-11-12','L',1739.06);
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

-- Dump completed on 2024-06-20 18:04:15
