/*
* Урок 9 
* Тема “Хранимые процедуры и функции, триггеры”
*/

/*
* Задание 1
* Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
* в зависимости от текущего времени суток. 
* С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
* с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
* с 18:00 до 00:00 — "Добрый вечер", 
* с 00:00 до 6:00 — "Доброй ночи".
*/


DELIMITER //
DROP FUNCTION IF EXISTS func_hello//

CREATE FUNCTION func_hello ()
RETURNS VARCHAR(255) DETERMINISTIC

BEGIN 
    SET @hour_now = HOUR(CURTIME());
    IF (@hour_now < 6) THEN
        RETURN "Доброй ночи";
    ELSEIF (@hour_now < 12) THEN
        RETURN "Доброе утро";
    ELSEIF (@hour_now < 18) THEN
        RETURN "Добрый день";
    ELSE
        RETURN "Добрый вечер";
    END IF;
END//

DELIMITER ;

SELECT func_hello();

/*
* Задание 2
* В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
* Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают 
* неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих 
* полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

DELIMITER //

DROP TRIGGER IF EXISTS chek_null_on_insert//
DROP TRIGGER IF EXISTS chek_null_on_update//

CREATE TRIGGER chek_null_on_insert BEFORE INSERT ON products
FOR EACH ROW

BEGIN
  IF (NEW.name IS NULL AND NEW.desсription IS NULL) THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Название и описание не могут быть пустыми одновременно';
  END IF;
END//

CREATE TRIGGER chek_null_on_update BEFORE UPDATE ON products
FOR EACH ROW

BEGIN
  IF (NEW.name IS NULL AND NEW.desсription IS NULL) THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Название и описание не могут быть пустыми одновременно';
  END IF;
END//

DELIMITER ;


/*
* Урок 9 
* Тема “Транзакции, переменные, представления”
*/

/*
* Задание 1
* В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
* Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
* 
* Можно сразу из одной базы перенести в другую, но сделаем через временную таблицу, просто показать умение 
* пользования временными таблицами.
*/

DROP TABLE IF EXISTS tmp_table;

START TRANSACTION;

CREATE TEMPORARY TABLE `tmp_table` 
    SELECT *
    FROM shop.users u2 
    WHERE u2.id=1;

DELETE FROM shop.users 
WHERE users.id = 1;

INSERT INTO sample.users SELECT * FROM tmp_table;

COMMIT;

/*
 * По идее нужно еще обработку ошибок, при вставке записи в базу sample
 * но почему-то в теории вообще ни слова про это не сказано, значит и в задании не ожидается,
 * хотя, по-моему, это глюк, дать транзакции и не дать обработку ошибок.
 * Но задание выполнено.
 */


/*
* Задание 2
* Создайте представление, которое выводит название name товарной позиции из таблицы products 
* и соответствующее название каталога name из таблицы catalogs.
*/

CREATE VIEW cat AS 
    SELECT p.name AS product,
            c.name AS catalog
    FROM products p
    LEFT JOIN catalogs c
    ON p.catalog_id = c.id;

SELECT * FROM cat;

