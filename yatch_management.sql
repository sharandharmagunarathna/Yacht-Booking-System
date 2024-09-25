-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 25, 2024 at 05:05 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `yatch_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `charter`
--

CREATE TABLE `charter` (
  `charter_id` varchar(50) NOT NULL,
  `customer_id` varchar(50) NOT NULL,
  `start_date` datetime NOT NULL,
  `duration` int(11) NOT NULL,
  `yacht_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `charter`
--
DELIMITER $$
CREATE TRIGGER `update_charter_id` BEFORE INSERT ON `charter` FOR EACH ROW BEGIN
        IF NEW.charter_id = '' THEN
		SET NEW.charter_id = next_charter_id();
        END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nationality` varchar(100) NOT NULL,
  `phoneno` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `verify_customer_id` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
        IF NEW.customer_id = '' THEN
		SET NEW.customer_id = next_customer_id();
        END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `port`
--

CREATE TABLE `port` (
  `port` varchar(50) NOT NULL,
  `port_phone_no` varchar(150) DEFAULT NULL,
  `port_email` varchar(200) DEFAULT NULL,
  `docking_places` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `visit`
--

CREATE TABLE `visit` (
  `visit_id` varchar(50) NOT NULL,
  `port` varchar(50) NOT NULL,
  `customer_id` varchar(50) NOT NULL,
  `charter_id` varchar(50) NOT NULL,
  `date_of_arrival` date NOT NULL,
  `length_of_stay` int(11) NOT NULL,
  `yacht_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `visit`
--
DELIMITER $$
CREATE TRIGGER `update_visit_id` BEFORE INSERT ON `visit` FOR EACH ROW BEGIN
        IF NEW.visit_id = '' THEN
		SET NEW.visit_id = next_visit_id();
        END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `yacht`
--

CREATE TABLE `yacht` (
  `yacht_name` varchar(50) NOT NULL,
  `type` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  `berths` int(11) NOT NULL,
  `cost` double NOT NULL,
  `homeport` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL DEFAULT 'Running'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `charter`
--
ALTER TABLE `charter`
  ADD PRIMARY KEY (`charter_id`,`customer_id`),
  ADD KEY `FKcharter_customer` (`customer_id`),
  ADD KEY `FKcharter_yacht` (`yacht_name`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phoneno` (`phoneno`);

--
-- Indexes for table `port`
--
ALTER TABLE `port`
  ADD PRIMARY KEY (`port`);

--
-- Indexes for table `visit`
--
ALTER TABLE `visit`
  ADD PRIMARY KEY (`visit_id`,`port`,`customer_id`,`charter_id`,`yacht_name`),
  ADD KEY `FKvisit_yacht` (`yacht_name`),
  ADD KEY `FKvisit_port` (`port`),
  ADD KEY `FKvisit_charter` (`charter_id`,`customer_id`),
  ADD KEY `VISIT_INDEX_I` (`date_of_arrival`,`visit_id`);

--
-- Indexes for table `yacht`
--
ALTER TABLE `yacht`
  ADD PRIMARY KEY (`yacht_name`),
  ADD KEY `FKyacht_port` (`homeport`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `charter`
--
ALTER TABLE `charter`
  ADD CONSTRAINT `FKcharter_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKcharter_yacht` FOREIGN KEY (`yacht_name`) REFERENCES `yacht` (`yacht_name`);

--
-- Constraints for table `visit`
--
ALTER TABLE `visit`
  ADD CONSTRAINT `FKvisit_charter` FOREIGN KEY (`charter_id`,`customer_id`) REFERENCES `charter` (`charter_id`, `customer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKvisit_port` FOREIGN KEY (`port`) REFERENCES `port` (`port`),
  ADD CONSTRAINT `FKvisit_yacht` FOREIGN KEY (`yacht_name`) REFERENCES `yacht` (`yacht_name`);

--
-- Constraints for table `yacht`
--
ALTER TABLE `yacht`
  ADD CONSTRAINT `FKyacht_port` FOREIGN KEY (`homeport`) REFERENCES `port` (`port`);
COMMIT;
