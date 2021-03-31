/*
* Урок 7 Тема “Сложные запросы”
*/

/*
* Задание 1
* Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/

USE shop;

SELECT user_id,
	name
	FROM orders, users
	WHERE orders.user_id=users.id
	GROUP BY user_id, name
	ORDER BY name;

/*
* Задание 2
* Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

SELECT
  products.id,
  products.name  AS "Товар",
  (SELECT
 	catalogs.name
   FROM
 	catalogs
   WHERE
 	catalogs.id = products.catalog_id) AS 'Каталог'
FROM
  products;
  
 /*
* Задание 3
* (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и 
* таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, 
* поле name — русское. Выведите список рейсов flights с русскими названиями городов.
*/

SELECT flights.id,
(SELECT
 	cities.name
   FROM
 	cities
   WHERE
 	cities.label = flights.from) AS 'From',
 	(SELECT
 	cities.name
   FROM
 	cities
   WHERE
 	cities.label = flights.to) AS 'To'
 	FROM flights
 	
 	-- подзапросы с условиями очень сильно тормозят, поэтому другой варинт:
 	
 	SELECT flights.id,
	 	c1.name  AS 'From',
 		c2.name AS 'To'
 	FROM flights
 	JOIN cities c1 
 		on flights.from=c1.label
  	JOIN cities c2
 		on flights.to=c2.label;

 