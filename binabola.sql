-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 19, 2024 at 02:55 PM
-- Server version: 8.0.30
-- PHP Version: 8.0.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `binabola`
--

-- --------------------------------------------------------

--
-- Table structure for table `calories`
--

CREATE TABLE `calories` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  `foods` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `calorie` int NOT NULL,
  `amount` int NOT NULL,
  `category` varchar(20) NOT NULL,
  `total` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `calories`
--

INSERT INTO `calories` (`id`, `user_id`, `date`, `foods`, `calorie`, `amount`, `category`, `total`) VALUES
(3, 26, '2024-06-05', 'apel', 300, 3, 'morning', 900),
(4, 26, '2024-06-05', 'apel', 300, 3, 'night', 900),
(5, 26, '2024-06-05', 'apel', 300, 3, 'morning', 900),
(6, 26, '2024-06-12', 'apel', 300, 3, 'morning', 900);

-- --------------------------------------------------------

--
-- Table structure for table `daily_missions`
--

CREATE TABLE `daily_missions` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `exercise_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `daily_missions`
--

INSERT INTO `daily_missions` (`id`, `user_id`, `exercise_id`, `date`, `status`) VALUES
(31, 26, 1, '2024-06-19', 2),
(32, 26, 6, '2024-06-19', 2),
(33, 27, 6, '2024-06-19', 2);

-- --------------------------------------------------------

--
-- Table structure for table `exercises`
--

CREATE TABLE `exercises` (
  `id` int NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `detail` text,
  `duration` time NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `step` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `calorie_out` int DEFAULT NULL,
  `foto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `video` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `body_part_needed` varchar(50) DEFAULT NULL,
  `is_support_interactive` int DEFAULT NULL,
  `interactive_setting_id` int DEFAULT NULL,
  `interactive_body_part_segment_value_id` int DEFAULT NULL,
  `submission` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `exercises`
--

INSERT INTO `exercises` (`id`, `name`, `detail`, `duration`, `category`, `step`, `calorie_out`, `foto`, `video`, `body_part_needed`, `is_support_interactive`, `interactive_setting_id`, `interactive_body_part_segment_value_id`, `submission`) VALUES
(1, 'Dumbbel Curl', 'Latihan lengan', '00:00:00', 'strength', 'menyiapkan lengan', 500, 'foto', 'video', 'right_hand,left_hand', 1, 1, 1, 0),
(2, 'Push Up', 'Latihan Dada', '00:00:00', 'Strength', 'Tengkurap', 400, 'foto', 'video', 'right_hand,left_hand', 1, 2, 2, 0),
(3, 'Dumbbell Sumo Squat', 'Sumo', '00:00:00', 'Strength', 'Kuda-Kuda Sumo', 150, 'foto', 'video', 'right_leg,left_leg', 1, 3, 3, 0),
(4, 'Biceps Curl With Bosu Ball', 'biceps', '00:00:00', 'Strength', 'siapkan lengan', 180, 'foto', 'video', 'right_hand,left_hand', 1, 1, 1, 0),
(5, 'Lari', 'Lari ', '00:30:00', 'endurance', 'lari', 300, 'foto', 'video', NULL, NULL, NULL, NULL, 0),
(6, 'Zigzag', 'melatih kelincahan', '00:30:00', 'Speed', 'lincah', 400, NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `expires` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `submission`
--

CREATE TABLE `submission` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `exercise_id` int NOT NULL,
  `video_url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `submission`
--

INSERT INTO `submission` (`id`, `user_id`, `exercise_id`, `video_url`, `date`) VALUES
(7, 26, 6, 'https://www.youtube.com/watch?v=your_video_id', '2024-06-19'),
(8, 27, 6, 'https://www.youtube.com/watch?v=your_video_id', '2024-06-19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `role` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('L','P') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `calorie` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`, `role`, `name`, `height`, `weight`, `birth_date`, `gender`, `calorie`) VALUES
(26, 'farhan17764', 'farhan17764@gmail.com', '$2b$10$uAdbTddRMt9Ze52aMfZCKOFEdv4XqDo701/sZgp9MzTOzsARmgNuS', '2024-06-12 15:31:32', 'user', 'Farhan Al Farisi', '179.00', '68.00', '2002-11-12', 'L', '1739.06'),
(27, 'ahan', 'ahan@gmail.com', '$2b$10$1YVBhpa7d/TOUDLB7/11f.J/MntwyHn/G4VibC/ajsf4/1KwWXty6', '2024-06-19 21:43:27', 'user', 'Farhan Al Farisi', '179.00', '68.00', '2002-11-12', 'L', '1739.06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calories`
--
ALTER TABLE `calories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `daily_missions`
--
ALTER TABLE `daily_missions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `FK_daily_missions_exercises` (`exercise_id`);

--
-- Indexes for table `exercises`
--
ALTER TABLE `exercises`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `submission`
--
ALTER TABLE `submission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_submission_users` (`user_id`),
  ADD KEY `FK_submission_exercises` (`exercise_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calories`
--
ALTER TABLE `calories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `daily_missions`
--
ALTER TABLE `daily_missions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `exercises`
--
ALTER TABLE `exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `submission`
--
ALTER TABLE `submission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calories`
--
ALTER TABLE `calories`
  ADD CONSTRAINT `calories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `daily_missions`
--
ALTER TABLE `daily_missions`
  ADD CONSTRAINT `daily_missions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK_daily_missions_exercises` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`);

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `submission`
--
ALTER TABLE `submission`
  ADD CONSTRAINT `FK_submission_exercises` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`),
  ADD CONSTRAINT `FK_submission_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
