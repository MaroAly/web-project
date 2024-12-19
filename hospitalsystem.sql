-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 14, 2024 at 05:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospitalsystem1`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `email`, `password`) VALUES
(1, 'admin@gmail.com', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `gov_id` varchar(20) DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `status` enum('Scheduled','Cancelled','Completed') DEFAULT 'Scheduled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `patient_id`, `doctor_id`, `email`, `phone`, `gov_id`, `date`, `time`, `status`) VALUES
(19, 5, 2, NULL, NULL, NULL, '2024-12-17', '00:00:00', 'Scheduled'),
(20, 5, 3, NULL, NULL, NULL, '2024-12-26', '00:00:00', 'Scheduled'),
(21, 5, 1, NULL, NULL, NULL, '2025-01-09', '00:00:00', 'Scheduled'),
(22, 5, 6, NULL, NULL, NULL, '2024-12-27', '00:00:00', 'Scheduled'),
(23, 5, 2, NULL, NULL, NULL, '2024-12-27', '00:00:00', 'Scheduled'),
(24, 5, 4, NULL, NULL, NULL, '2024-12-23', '00:00:00', 'Scheduled'),
(25, 5, 7, NULL, NULL, NULL, '2025-01-09', '00:00:00', 'Scheduled');

-- --------------------------------------------------------

--
-- Table structure for table `appointment_logs`
--

CREATE TABLE `appointment_logs` (
  `id` int(11) NOT NULL,
  `appointment_id` int(11) NOT NULL,
  `action` enum('Cancelled','Rescheduled') NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact`
--

INSERT INTO `contact` (`id`, `full_name`, `email`, `subject`, `message`, `created_at`) VALUES
(2, 'rfgd', 'admin@gmail.com', 'f', 'يبسيب', '2024-12-14 12:29:47'),
(3, 'rfgd', 'admin@gmail.com', 'f', 'sgfsgf', '2024-12-14 12:30:39'),
(4, 'rfgd', 'Ranimmoustafa63@gmail.com', 'f', 'بيليبل', '2024-12-14 12:34:07'),
(5, 'rfgd', 'admin@gmail.com', 'f', 'يري', '2024-12-14 12:35:45'),
(6, 'rfgd', 'admin@gmail.com', 'f', 'يري', '2024-12-14 12:36:07'),
(8, 'rfgd', 'admin@gmail.com', 'fيبلابي', 'fdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhg', '2024-12-14 12:50:52'),
(9, '', '', '', 'fdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhgfdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhgfdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhgfdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhgfdfhgjkhdfgjbfdjkgbdjfk fgjbfkjdbjf v fjbdkjgfgdfgfhgdhg', '2024-12-14 12:51:24'),
(10, 'rfgd', 'admin@gmail.com', 'f', 'لبلبيل', '2024-12-14 12:54:13');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Dentistry'),
(4, 'Pediatrics'),
(5, 'Carlogy');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `profession` varchar(50) NOT NULL,
  `gov_id` varchar(20) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `fee` int(11) NOT NULL,
  `department` varchar(100) NOT NULL,
  `brief` text DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `first_name`, `last_name`, `profession`, `gov_id`, `phone_number`, `address`, `email`, `fee`, `department`, `brief`, `start_time`, `end_time`) VALUES
(1, 'John', 'Doe', 'Cardiologist', '12345', '555-5555', '123 Main St', 'johndoe@example.com', 200, 'Cardiology', 'Specialized in heart diseases.', '09:00:00', '17:00:00'),
(2, 'Jane', 'Smith', 'Neurologist', '12346', '555-5556', '456 Elm St', 'janesmith@example.com', 250, 'Neurology', 'Expert in brain disorders.', '08:30:00', '14:30:00'),
(3, 'Emma', 'Taylor', 'Dentist', '12347', '555-5557', '789 Oak St', 'emmataylor@example.com', 150, 'Dentistry', 'Focused on dental health.', '10:00:00', '15:00:00'),
(4, 'Liam', 'Brown', 'Pediatrician', '12348', '555-5558', '321 Pine St', 'liambrown@example.com', 180, 'Pediatrics', 'Child health specialist.', '08:00:00', '14:00:00'),
(6, 'ranim', 'moustafa', 'gegeg', '5577777444444', '01125252662', 'sffs@djkjc.com', 'Ranimmoustafa63@gmail.com', 55, 'Cardiology', NULL, '00:00:00', '00:00:00'),
(7, 'hamza', 'ahmed', 'dentast', '5577777444449', '01212887883', 'alex', 'hamza@gmail.com', 300, 'Dental', NULL, '00:00:00', '00:00:00'),
(8, 'ranim', 'moustafa', 'gegeg', '1233385885555', '01125252525', 'sffs@djkjc.com', 'ranim@gmail.com', 123, 'Cardiology', 'hjjfjfghfgjhj fjgkld ', '00:00:00', '00:00:00'),
(9, 'ranim', 'moustafa', 'gegeg', '1233385785555', '01127252525', 'sffs@djkjc.com', 'rafnim@gmail.com', 123, 'Carlogy', 'hjjfjfghfgjhj fjgkld ', '00:00:00', '00:00:00'),
(10, 'dd', 'moustafa', 'gdd', '5577777444445', '01125252663', 'hjhj', 'randim@gmail.com', 56, 'Cardiology', 'CardiologyCardiology', '00:00:00', '00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `time_slots`
--

CREATE TABLE `time_slots` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `is_booked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gov_id` varchar(20) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `messages` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `gov_id`, `phone_number`, `address`, `email`, `password`, `messages`) VALUES
(2, 'esraa', 'mostafa', '123456', '11552552', 'alex', 'esraa@gmail.com', '123', NULL),
(3, 'iraa', 'iraa', '12345678952', '1235955c', 'cairo', 'iraa@gmial.com', '12', NULL),
(4, 'es', 'es', '123456888', '123582222', 'cairo', 'es@gmail.com', '55', NULL),
(5, 'ranim', 'moustafa', '353', '0112525252', 'alx', 'ranim@gmail.com', '333', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_patient` (`patient_id`),
  ADD KEY `fk_doctor` (`doctor_id`);

--
-- Indexes for table `appointment_logs`
--
ALTER TABLE `appointment_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_id` (`appointment_id`);

--
-- Indexes for table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `time_slots`
--
ALTER TABLE `time_slots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slot` (`doctor_id`,`date`,`time`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `appointment_logs`
--
ALTER TABLE `appointment_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `time_slots`
--
ALTER TABLE `time_slots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`),
  ADD CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `appointment_logs`
--
ALTER TABLE `appointment_logs`
  ADD CONSTRAINT `appointment_logs_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `time_slots`
--
ALTER TABLE `time_slots`
  ADD CONSTRAINT `time_slots_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
