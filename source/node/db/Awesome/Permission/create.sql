CREATE TABLE `permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `enabledAt` timestamp NULL DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_permission` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

INSERT INTO `jet`.`permission` (`id`, `name`, `enabledAt`) VALUES

('1', 'insert', NOW()),
('2', 'select', NOW()),
('3', 'update', NOW()),
('4', 'delete', NOW())

;
