-- Создание базы данных
CREATE DATABASE IF NOT EXISTS Observatory;
USE Observatory;

-- Создание таблицы Сектор
CREATE TABLE IF NOT EXISTS Sector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(255),
    light_intensity FLOAT,
    foreign_objects INT,
    star_objects_count INT,
    unknown_objects_count INT,
    defined_objects_count INT,
    notes TEXT
);

-- Создание таблицы Объекты
CREATE TABLE IF NOT EXISTS Objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    accuracy FLOAT,
    quantity INT,
    time TIME,
    date DATE,
    notes TEXT
);

-- Создание таблицы ЕстественныеОбъекты
CREATE TABLE IF NOT EXISTS NaturalObjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    galaxy VARCHAR(255),
    accuracy FLOAT,
    light_flow FLOAT,
    associated_objects VARCHAR(255),
    notes TEXT
);

-- Создание таблицы Положение
CREATE TABLE IF NOT EXISTS `Position` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_position VARCHAR(255),
    sun_position VARCHAR(255),
    moon_position VARCHAR(255)
);

-- Создание таблицы Наблюдение
CREATE TABLE IF NOT EXISTS Observation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    position_id INT,
    FOREIGN KEY (sector_id) REFERENCES Sector(id),
    FOREIGN KEY (object_id) REFERENCES Objects(id),
    FOREIGN KEY (natural_object_id) REFERENCES NaturalObjects(id),
    FOREIGN KEY (position_id) REFERENCES `Position`(id)
);

DELIMITER //

CREATE TRIGGER UpdateObjects
AFTER UPDATE ON Objects
FOR EACH ROW
BEGIN
    DECLARE column_exists INT DEFAULT 0;
    
    -- Проверка наличия столбца date_update
    SELECT COUNT(*) INTO column_exists
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Objects' AND COLUMN_NAME = 'date_update';

    -- Добавление столбца, если он отсутствует
    IF column_exists = 0 THEN
        SET @alter_sql = 'ALTER TABLE Objects ADD COLUMN date_update TIMESTAMP';
        PREPARE stmt FROM @alter_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    -- Обновление значения date_update текущей датой и временем
    SET NEW.date_update = NOW();
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE JoinTables(IN table1 VARCHAR(255), IN table2 VARCHAR(255))
BEGIN
    SET @sql = CONCAT('SELECT * FROM ', table1, ' t1 JOIN ', table2, ' t2 ON t1.id = t2.id');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;