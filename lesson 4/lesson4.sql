/* Практическое задание #4. */

/* Задание # 3.
 * Написать запрос для переименования названий типов медиа (колонка name в media_types) в осмысленные для полученного дампа с данными (например, в "фото", "видео", ...).
*/
-- открытие базы данных vk для использования
USE vk;


-- изменим значения поля name в таблице media_types воспользуемся для выборки нужной строки ее id

UPDATE media_types 
SET name = 'Видео'
WHERE id=1;

-- аналогично для других трех типов

UPDATE media_types 
SET name = 'Музыка'
WHERE id=2;

UPDATE media_types 
SET name = 'Фото'
WHERE id=3;

UPDATE media_types 
SET name = 'Анимация'
WHERE id=4;
