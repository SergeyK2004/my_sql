USE vk;

/* Практическое задание #6. */

/* Задание # 1.
 * Пусть задан некоторый пользователь.
 * Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. (можете взять пользователя с любым id).
*/

-- Возьмем пользователя с id=6

-- делаем выборку из таблицы messages с отбором по получателю id=6 
SELECT * FROM messages  WHERE to_user_id=6;

-- принимаем, что больше общался = писал чаще других
-- чтобы подсчитать количество сообщений группируем по from_id и считаем количество

SELECT from_user_id, count(*) AS count FROM messages  WHERE to_user_id=6 GROUP BY from_user_id;

-- используем эту свертку для вывода пользователя с максимальным количеством сообщений.
-- необходимо учесть, что таких пользователей может быть больше 1

SELECT from_user_id, count FROM 
        (SELECT from_user_id, count(*) AS count FROM messages  WHERE to_user_id=6 GROUP BY from_user_id) AS tab1 
    WHERE count IN 
    (SELECT max(count) FROM 
        (SELECT from_user_id, count(*) AS count FROM messages  WHERE to_user_id=6 GROUP BY from_user_id) AS tab2);
        
    /* Задание # 2.
    *  Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.
    */
    
    -- сперва сделаем выборку пользователей младше 18 лет
   
    
    SELECT profiles.user_id,
        timestampdiff(YEAR,profiles.birthday, NOW()) AS age
    FROM profiles
    WHERE timestampdiff(YEAR,profiles.birthday, NOW())<18;

    -- теперь выберем нужное из постов

SELECT posts.id post,
    posts.user_id 
    FROM posts;
    
-- объеденим запрос, чтобы получить нужное из постов только выбранных пользователей

    SELECT posts.id post
    FROM profiles, posts
    WHERE timestampdiff(YEAR,profiles.birthday, NOW())<18 AND profiles.user_id = posts.user_id;

-- получили список id постов пользователей которым меньше 18 лет
-- теперь запрос по лайкам сгруппированный по id постов

SELECT post_id,
count(user_id)
FROM posts_likes
WHERE like_type=1
GROUP BY post_id;

-- добавим к выборке постов условие выборки только постов из запроса выше

SELECT post_id,
count(user_id) count
FROM posts_likes
WHERE like_type=1 AND post_id IN 
(SELECT posts.id post
    FROM profiles, posts
    WHERE timestampdiff(YEAR,profiles.birthday, NOW())<18 AND profiles.user_id = posts.user_id)
GROUP BY post_id;

-- ну и теперь считаем сумму
SELECT sum(tab1.count)
FROM 
(SELECT post_id,
count(user_id) count
FROM posts_likes
WHERE like_type=1 AND post_id IN 
(SELECT posts.id post
    FROM profiles, posts
    WHERE timestampdiff(YEAR,profiles.birthday, NOW())<18 AND profiles.user_id = posts.user_id)
GROUP BY post_id) AS tab1;

    /* Задание # 3.
    *  Определить, кто больше поставил лайков (всего) - мужчины или женщины?
    */

-- берем таблицу лайков
SELECT * FROM posts_likes

-- объеденяем с профайлами пользователей и группируем по полу

SELECT count(posts_likes.post_id) count,
        profiles.gender
FROM profiles, posts_likes
WHERE profiles.user_id = posts_likes.user_id
GROUP BY  profiles.gender;

-- выбираем строку с максимумом количества строк

SELECT max(count) 
FROM (SELECT count(posts_likes.post_id) count,
        profiles.gender
FROM profiles, posts_likes
WHERE profiles.user_id = posts_likes.user_id
GROUP BY  profiles.gender) AS tab2;

-- теперь выберем строку с полом с максимумом лайков

SELECT tab1.count, tab1.gender
FROM (SELECT count(posts_likes.post_id) count,
        profiles.gender
FROM profiles, posts_likes
WHERE profiles.user_id = posts_likes.user_id
GROUP BY  profiles.gender) AS tab1
WHERE tab1.count IN (
SELECT max(count) 
FROM (SELECT count(posts_likes.post_id) count,
        profiles.gender
FROM profiles, posts_likes
WHERE profiles.user_id = posts_likes.user_id
GROUP BY  profiles.gender) AS tab2
);

-- очень хотел сделать доп, но ....
-- уже 24:50 а в 9 в аэропорт, лететь 9 часов до Москвы
-- следующая домашка из отпуска