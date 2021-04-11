/*
* Урок 11 
* Тема “Оптимизация запросов”
*/

/*
* Задание 1
* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах 
* users, catalogs и products в таблицу logs помещается время и дата создания записи, 
* название таблицы, идентификатор первичного ключа и содержимое поля name.
*/
USE shop;
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  id SERIAL,
  table_name VARCHAR(30) NOT NULL,
  created_at DATETIME DEFAULT now() NOT NULL,
  table_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL
) ENGINE=Archive;

/* Дальше не совсем понятно, что тут сделать от Оптимизации, может я не так теорию понял, но ...
*  если "при каждом создании" то это наверное триггеры.
*/

DELIMITER //

DROP TRIGGER IF EXISTS chek_users_on_insert//
DROP TRIGGER IF EXISTS chek_catalogs_on_insert//
DROP TRIGGER IF EXISTS chek_products_on_insert//

CREATE TRIGGER chek_users_on_insert AFTER INSERT ON users
FOR EACH ROW

BEGIN
    INSERT INTO logs (table_name, table_id, name) VALUES ('users', NEW.id, NEW.name);
END//

CREATE TRIGGER chek_catalogs_on_insert AFTER INSERT ON catalogs
FOR EACH ROW

BEGIN
    INSERT INTO logs (table_name, table_id, name) VALUES ('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER chek_products_on_insert AFTER INSERT ON products
FOR EACH ROW

BEGIN
    INSERT INTO logs (table_name, table_id, name) VALUES ('products', NEW.id, NEW.name);
END//
DELIMITER ;


/*
* Урок 11 
* Тема “NoSQL”
*/

/*
* Задание 1
* В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
*/


/* 
 * простите, но я вообще отказываюсь что-то понимать. 
 * Что значит "подберите"? В какой базе? Ее где-то нужно взять? Где?
 * Где взять про это информацию? Два раза внимательно прочитал теорию.
 * Кроме фразы "Для доступа к redis-серверу используется клиент redis-cli" больше вообще ничего
 * И что нужно сделать с этой информацией? Найти самому и установить себе клиента? И тогда волшебство и появиться база данных
 * в которой нужно "подобрать коллекцию"????
 * 
 * Поставьте 2 за эту домашку и все.
 * 
 */

/*
* Задание 2
* При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
* поиск электронного адреса пользователя по его имени.
* 
* 
* Поиска где???? В Чем???? 
* source10.zip не содержит ничего кроме текста с 5 командами Редиса из той-же теории. 
* Показали как добавить ключ значение и множество. Все.
* где нужно раздобыть информацию для решения задач?
* 
*/

/*
* Задание 2
* Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/


/*
* Для работы с MongoDB необходим запущенный сервер MongoDB. Убедиться, что он запущен, можно, 
* поискав среди процессов операционной системы mongod.
* 
* 
* Неужели реально можно что-то найти, если не устанавливал? А ведь это все. 
* Просто поищите и вот потом команды для работы с Монго ДБ
*/

SELECT * FROM products p 

db.products.insert({
name: 'Intel Core i3-8100',
description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
price: 7890,
created_at: '20-05-1985',
updated_at: '28-03-2021',
catalog_id: ''
})

/*
 * Как в командной строке и без js создать связь с другой таблицей я не знаю. 
 * Хотя только что сдал проект на node.js на MongoDB
 * Могу на ноде описать схемы и заполнить таблицы, но что хотят в задании к этому уроку я не понимаю.
 */

