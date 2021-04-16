/*
*   Курсовой проект.
*  Создание базы данных для сервиса по хранению рецептов различных блюд.
*
*
* База данных предназначена для хранения рецептов, которые пользователи могут добавлять на сайт. 
* Пользователи могут просматривать чужие рецепты, оставлять свои комментарии к ним. 
* Любой понравившийся чужой рецепт пользователь может пометить как "Любимый"
* Каждый рецепт содержит перечень и количество ингредиентов, которые выбираются из специального справочника. 
* Кроме этого есть возможность добавить текстовое описание технологии приготовления блюда.
* Пользователь при желании может добавлять фотографии готовых блюд или этапов приготовления в свой рецепт.
*
*/

DROP DATABASE IF EXISTS recipe_book;
CREATE DATABASE recipe_book;
USE recipe_book;



-- Пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL,
    email varchar(100) NOT NULL UNIQUE,
    password varchar(100) NOT NULL,
    birthday DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

INSERT INTO recipe_book.users (name,email,password,birthday)
    VALUES ('Anna','ann@abc@mail.ru','qwerty','1983-11-02');
INSERT INTO recipe_book.users (name,email,password,birthday)
    VALUES ('Petr','petr@asdw.com','123456','1979-03-17');
INSERT INTO recipe_book.users (name,email,password,birthday)
    VALUES ('Andrew','anpetrov@asdw.com','password','1981-04-12');
INSERT INTO recipe_book.users (name,email,password,birthday)
    VALUES ('Helen','lena@mymail.com','god','1973-08-24');

-- Группы рецептов (Первые блюда, вторые, десерты)

DROP TABLE IF EXISTS recipes_group;
CREATE TABLE recipes_group (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)
ENGINE=InnoDB;

INSERT INTO recipe_book.recipes_group (name)
    VALUES ('Первые блюда'),('Вторые блюда'),('Выпечка');


-- Разделы рецептов (Повседневные, На пасху, Постные...) 

DROP TABLE IF EXISTS recipes_chapter;
CREATE TABLE recipes_chapter (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)
ENGINE=InnoDB;

INSERT INTO recipe_book.recipes_chapter (name)
    VALUES ('Повседневные блюда'),('Масленица'), ('Гриль, барбекю');

-- Рецепты

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    title varchar(100) NOT NULL,
    prescription text NOT NULL,
    owner BIGINT UNSIGNED NOT NULL,
    group_id BIGINT UNSIGNED NOT NULL,
    chapter_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX fk_recipes_to_users_idx (owner),
    INDEX fk_recipes_to_group_idx (group_id),
    INDEX fk_recipes_to_chapter_idx (chapter_id),
    CONSTRAINT fk_recipes_to_users FOREIGN KEY (owner) REFERENCES users (id),
    CONSTRAINT fk_recipes_to_group FOREIGN KEY (group_id) REFERENCES recipes_group (id),
    CONSTRAINT fk_recipes_to_chapter FOREIGN KEY (chapter_id) REFERENCES recipes_chapter (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.recipes (title,prescription,owner,group_id,chapter_id)
    VALUES ('Блины на кефире','В большой миске взбиваем венчиком яйца с солью и затем вливаем кипяток, постоянно мешая венчиком содержимое миски. Работайте интенсивно венчиком, чтобы получилась однородная смесь.
Теперь вливаем кефир.
Добавим соду и сахар. Перемешаем тесто. На поверхности теста появятся пузырьки - это кефир вступает в реакцию с содой.
Вольем любое растительное масло, у меня - оливковое рафинированное, лучше, если масло будет без запаха.
Постепенно всыпаем муку и тщательно перемешиваем тесто венчиком, чтобы не образовывались комочки.
В конечном итоге у нас должно получиться блинное тесто. Дадим ему постоять минут десять-двадцать.
Сковороду ставим на сильный огонь, смазываем поверхность сковороды растительным маслом, вливаем небольшую порцию теста на сковороду, круговым движением поворачиваем сковороду, чтобы тесто равномерно распределилось по поверхности сковороды.
Как только на поверхности блина появятся пузырьки, а по краям блина увидим коричневую кайму, переворачиваем блин на другую сторону.
Выпекаем блины с двух сторон до румяного цвета. Следующий блин выпекаем, уже не смазывая сковороду маслом. 
Готовые блины подаем горячими с любимыми джемами, медом, сливочным маслом, сметаной. Я подаю тонкие блины с дырочками (на кефире) с апельсиновым киселем.',2,3,2);

INSERT INTO recipe_book.recipes (title,prescription,owner,group_id,chapter_id)
    VALUES ('Шашлык из свинины в кефире','Подготовьте свинину (лучше всего подходит шея или вырезка), кефир, базилик и перец.
Порубите и пожмите базилик, перцы раздавите.
Перемешайте базилик и перцы с кефиром. Не солите!
Свинину нарежьте кусочками.
Поместите куски свинины в маринад примерно на три часа.
Затем нужно посолить и нанизать куски мяса на шампура.
Жарьте шашлык из свинины над раскаленными углями, переворачивая его разными сторонами, до полной готовности.
Подавайте шашлык с соусами по вкусу.',4,2,3);


-- Справочник групп ингредиентов (Мясо, овощи, крупы, специи ...)

DROP TABLE IF EXISTS ingredients_group;
CREATE TABLE ingredients_group (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NULL
)
ENGINE=InnoDB;

INSERT INTO recipe_book.ingredients_group (name)
    VALUES ('Мясо, птица, яйцо'),('Крупы'),('Овощи, зелень'),('Специи'),('Морепродукты'),('Молочные продукты'),('Прочее'),('Бакалея');

-- Справочник ингредиентов

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL UNIQUE,
    group_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    INDEX fk_ingredients_to_group_idx (group_id),
    CONSTRAINT fk_ingredients_to_group FOREIGN KEY (group_id) REFERENCES ingredients_group (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.ingredients (name,group_id)
    VALUES ('Мука',8), ('Кипяток',7), ('Кефир',6), ('Яйцо куриное',1), ('Соль',4),
    ('Сахар',4), ('Сода',4), ('Растительное масло',8), ('Свинина (шея)',1), ('Базилик',3),
    ('Смесь перцев',4);

-- Ингредиенты в рецептах

DROP TABLE IF EXISTS recipe_ingredients;
CREATE TABLE recipe_ingredients (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    ingredient BIGINT UNSIGNED NOT NULL,
    quantity VARCHAR(20) NOT NULL,
    recipe BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    INDEX fk_recipe_ingredients_to_recipe_idx (recipe),
    INDEX fk_recipe_ingredients_to_ingredients_idx (ingredient),
    CONSTRAINT fk_recipe_ingredients_to_recipe FOREIGN KEY (recipe) REFERENCES recipes (id),
    CONSTRAINT fk_recipe_ingredients_to_ingredients FOREIGN KEY (ingredient) REFERENCES ingredients (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (1,'1 стакан',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (3,'1 стакан',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (2,'1 стакан',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (4,'2 штуки',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (5,'1 щепотка',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (6,'2 ст. л.',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (8,'3 ст. л.',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (7,'1 ч. л.',1);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (9,'2,5 кг.',2);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (3,'0,5 л.',2);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (10,'1 пучек',2);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (11,'По вкусу',2);
INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe)
    VALUES (5,'По вкусу',2);

-- Лайки рецептов

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
    owner BIGINT UNSIGNED NOT NULL,
    recipe BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NULL,
    PRIMARY KEY (`recipe`,`owner`),
    INDEX fk_likes_to_users_idx (owner),
    CONSTRAINT fk_likes_to_users FOREIGN KEY (owner) REFERENCES users (id),
    INDEX fk_likes_to_recipe_idx (recipe),
    CONSTRAINT fk_likes_to_recipe FOREIGN KEY (recipe) REFERENCES recipes (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.likes (owner,recipe)
    VALUES (3,2);
INSERT INTO recipe_book.likes (owner,recipe)
    VALUES (2,2);

-- Фотографии (блюд и этапов приготовления)

DROP TABLE IF EXISTS media;
CREATE TABLE media (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    title varchar(100) NOT NULL,
    file text NOT NULL,
    owner BIGINT UNSIGNED NOT NULL,
    recipe BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NULL,
    INDEX fk_media_to_users_idx (owner),
    CONSTRAINT fk_media_to_users FOREIGN KEY (owner) REFERENCES users (id),
    INDEX fk_media_to_recipe_idx (recipe),
    CONSTRAINT fk_media_to_recipe FOREIGN KEY (recipe) REFERENCES recipes (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.media (title,file,owner,recipe)
    VALUES ('Вариант сервировки','https://i.pinimg.com/originals/43/c4/bb/43c4bbee47a467704ad3afc92220e2c0.jpg',1,1);
INSERT INTO recipe_book.media (title,file,owner,recipe)
    VALUES ('Готовый шашлык','https://im.kommersant.ru/Issues.photo/OGONIOK/2018/021/KMO_088734_02640_1_t218_223611.jpg',4,2);


-- Любимые рецепты пользователя

DROP TABLE IF EXISTS favorit;
CREATE TABLE favorit (
    owner BIGINT UNSIGNED NOT NULL,
    recipe BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NULL,
    PRIMARY KEY (`recipe`,`owner`),
    INDEX fk_favorit_to_users_idx (owner),
    CONSTRAINT fk_favorit_to_users FOREIGN KEY (owner) REFERENCES users (id), 
    INDEX fk_favorit_to_recipe_idx (recipe),
    CONSTRAINT fk_favorit_to_recipe FOREIGN KEY (recipe) REFERENCES recipes (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.favorit (owner,recipe)
    VALUES (1,1);
INSERT INTO recipe_book.favorit (owner,recipe)
    VALUES (2,2);
INSERT INTO recipe_book.favorit (owner,recipe)
    VALUES (3,1);
INSERT INTO recipe_book.favorit (owner,recipe)
    VALUES (3,2);

-- Комментарии пользователей к рецептам

DROP TABLE IF EXISTS comments;

CREATE TABLE comments (
    id BIGINT UNSIGNED auto_increment NOT NULL PRIMARY KEY,
    title varchar(100) NOT NULL,
    comment text NOT NULL,
    owner BIGINT UNSIGNED NOT NULL,
    recipe BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NULL,
    edited_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX fk_comments_to_users_idx (owner),
    CONSTRAINT fk_comments_to_users FOREIGN KEY (owner) REFERENCES users (id),
    INDEX fk_comments_to_recipe_idx (recipe),
    CONSTRAINT fk_comments_to_recipe FOREIGN KEY (recipe) REFERENCES recipes (id)  
)
ENGINE=InnoDB;

INSERT INTO recipe_book.comments (title,comment,owner,recipe)
    VALUES ('Великолепно','Неоднократно готовил по вашему реуепту, семья в восторге.',2,1);
INSERT INTO recipe_book.comments (title,comment,owner,recipe)
    VALUES ('Отлично','Теперь у нас это самый любимый рецепт шашлыка',3,2);
INSERT INTO recipe_book.comments (title,comment,owner,recipe)
    VALUES ('Не фонтан','Нам не понравилось. Мясо получилось сухое и не вкусное.',1,2);


/*
 *  Основные выборки из базы данных.
 *  
 */

-- Вывести запрошенный рецепт

SET @need_recipe = 1;
-- Название, сам рецепт и требуемые ингредиенты для выбранного пользователем рецепта. Выбранный внесем в переменную.

SELECT r.title, 
    r.prescription,
    i.name,
    ri.quantity
    FROM recipes r
    JOIN recipe_ingredients ri ON r.id = ri.recipe
    JOIN ingredients i ON ri.ingredient = i.id
    WHERE r.id = @need_recipe;
    
-- Найти все рецепты по указанному слову. Ищем в названии. Выводим вместе с именем Автора, сортируем по количеству лайков

SET @search_word = 'блин';

SELECT r.title, u.name, (SELECT count(*) FROM likes l WHERE l.recipe = r.id)  AS count_likes
FROM recipes r
JOIN users u ON r.owner = u.id
WHERE LOCATE(LOWER(@search_word), LOWER(r.title))
ORDER BY count_likes DESC ;

-- Вывести 10 рецептов с максимальным количеством лайков.

SELECT r.title,
    u.name,
    count(l.recipe) AS count_likes
FROM recipes r
JOIN users u ON r.owner = u.id
LEFT JOIN likes l ON l.recipe = r.id
GROUP BY r.title, u.name
ORDER BY count_likes DESC 
LIMIT 10;

-- Вывести любимые рецепты пользователя с ингредиентами и рецептурой.

SET @cur_user = 2;

SELECT r.title, 
    r.prescription,
    i.name,
    ri.quantity
    FROM favorit f
    JOIN recipes r ON r.id = f.recipe
    JOIN recipe_ingredients ri ON r.id = ri.recipe
    JOIN ingredients i ON ri.ingredient = i.id
    WHERE  f.owner = @cur_user;
    
-- Выбрать самые любимые рецепты (по частоте добавления в Любимые)

SELECT r.title, 
    r.prescription,
    i.name,
    ri.quantity,
    COUNT(f.recipe) AS fav_count
    FROM favorit f
    JOIN recipes r ON r.id = f.recipe
    JOIN recipe_ingredients ri ON r.id = ri.recipe
    JOIN ingredients i ON ri.ingredient = i.id
    GROUP BY r.title, r.prescription, i.name, ri.quantity
    ORDER BY fav_count
    LIMIT 10;
 

/*
*  Примем следующие условия. При изменении удалении или добавлении ингредиента в рецепт, считаем, что рецепт был изменен.
* 
*  Если есть комментарии, привязаные к рецепту, то после обновления рецепта в коментариях должны появиться пометки, что 
*  комментарий написан к предыдущей версии рецепта, до его изменения.
*
*  Для реализации данного функционала используем триггеры для отслеживания изменений и процедуру, которая будет вносить изменения 
*  в Таблицу комментариев.
* 
*/


DELIMITER //
-- Отработаем добавление или изменения ингредиентов

 DROP TRIGGER IF EXISTS ingredients_on_insert//

 CREATE TRIGGER ingredients_on_insert BEFORE INSERT ON recipe_ingredients
 FOR EACH ROW

 BEGIN
    SET @success = TRUE;
    SET @rec = NEW.recipe;

    CALL change_ingredient(@rec, @success);

    IF (NOT @success) THEN 
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Не удалось обновить данные в базе. Попробуйте позже';
      
   END IF;
 END//
 
 DROP TRIGGER IF EXISTS ingredients_on_update//

 CREATE TRIGGER ingredients_on_insert BEFORE UPDATE ON recipe_ingredients
 FOR EACH ROW

 BEGIN
    SET @success = TRUE;
    SET @rec = OLD.recipe;

    CALL change_ingredient(@rec, @success);

    IF (NOT @success) THEN 
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Не удалось обновить данные в базе. Попробуйте позже';
      
   END IF;
 END//

 DROP TRIGGER IF EXISTS ingredients_on_delete//

 CREATE TRIGGER ingredients_on_insert BEFORE DELETE ON recipe_ingredients
 FOR EACH ROW

 BEGIN
    SET @success = TRUE;
    SET @rec = OLD.recipe;

    CALL change_ingredient(@rec, @success);

    IF (NOT @success) THEN 
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Не удалось обновить данные в базе. Попробуйте позже';
      
   END IF;
 END//

 -- Отработаем изменения в рецепте
DROP TRIGGER IF EXISTS recipe_on_change//

 CREATE TRIGGER recipe_on_change BEFORE UPDATE ON recipes
 FOR EACH ROW

 BEGIN
    SET @success = TRUE;
    SET @rec = OLD.id;
    SET @old_date = OLD.edited_at;

    CALL change_recipe(@rec, @old_date, @success);

    IF (NOT @success) THEN 
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Не удалось обновить данные в базе. Попробуйте позже';
   END IF;
 END//


 
DELIMITER ;
 
 
 /*
  * Процедура для обновления комментариев
  * Принимает на вход id рецепта, который изменяется.
  * 
  */
 
DELIMITER //
 
CREATE PROCEDURE change_recipe (record BIGINT unsigned, old_date DATETIME, INOUT success BOOL)
 
BEGIN
     
    UPDATE comments 
    SET comment = CONCAT('Комментарий к версии рецепта от ', DATE_FORMAT(old_date,'%e %M %Y'), '|', comment)
    WHERE recipe = record;
    
END//
     
 
DELIMITER ;
 
/*
  * Процедура для обновления даты изменения рецепта при изменении ингредиентов
  * Принимает на вход id рецепта, в котором изменились ингредиенты.
  * 
  */
 
DELIMITER //
 
CREATE PROCEDURE change_ingredient (IN record BIGINT UNSIGNED, INOUT success BOOL)
 
BEGIN
     
    UPDATE recipes 
    SET edited_at = NOW()
    WHERE id = record;
    
END//
     
 
DELIMITER ;
 

SELECT * FROM comments c ;
SELECT * FROM recipes r ;

-- Запросы для проверки работы триггеров
-- UPDATE recipe_book.recipes SET title='Шашлыки из свинины в кефире' WHERE id=2;
-- UPDATE recipe_book.recipe_ingredients SET quantity='0,5 ч.л.' WHERE id=12;
-- INSERT INTO recipe_book.recipe_ingredients (ingredient,quantity,recipe) VALUES (2,'1 ложка',2);

/*
 * Создадим представление для отображения выбранного рецепта с ингредиентами, именем владельца и количеством лайков
 */

SET @need_recipe = 1;


CREATE or replace VIEW view_recipes
AS 
SELECT r.id,
    r.title, 
    r.prescription,
    i.name ingredient,
    ri.quantity,
    COUNT(l.owner) count_likes
    FROM recipes r
    JOIN recipe_ingredients ri ON r.id = ri.recipe
    JOIN ingredients i ON ri.ingredient = i.id
    LEFT JOIN likes l ON r.id = l.recipe 
    GROUP BY r.id, r.title, r.prescription, i.name, ri.quantity;
    
    
 -- Используем представление с условием по id нужного рецепта   
    SELECT * FROM view_recipes
    WHERE id = @need_recipe; 



