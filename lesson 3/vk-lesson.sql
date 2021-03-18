/*
* Урок 3. Вебинар. Введение в проектирование БД
*/

/*
* Задание 1
* Проанализировать структуру БД vk с помощью скрипта, который мы создали на занятии (vk-lesson.sql),
* и внести предложения по усовершенствованию (если такие идеи есть). Создайте у себя БД vk с помощью
* скрипта из материалов урока. Напишите пожалуйста, всё ли понятно по структуре.
*  Примечание: vk-lesson.sql - скрипт, который мы писали на уроке, vk.sql - дамп таблицы vk.
*
* Все понятно.
* не пользуюсь и не знаю что там и как в Вк, исхожу из того, что вижу в созданной Базе данных
* Вроде все понятно.
*/


DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;


/*
 * По усовершенствованию не совсем понятно, нужно понять задачу и предложить свое видение базы данных или 
 * в том ,что мы сделали где-то не совсем корректно созданы индексы или связи? 
 * Видимо просто у меня нет идей, надеюсь к концу курса я пересмотрю это задание и найду их :)
 * Убрал лишнее создание таблицы Профиля
 * Создал таблицу со странами
 * К ней 1:n привязал таблицу с городами
 * город в профиле пользователя выбирается из нее
 */

CREATE TABLE countries (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(56) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE cities (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(25) NOT NULL,
  country_id BIGINT UNSIGNED NOT NULL,
  INDEX fk_cities_to_contries_idx (country_id),
  CONSTRAINT fk_cities_to_contries FOREIGN KEY (country_id) REFERENCES countries (id)  
) ENGINE=InnoDB;


CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, -- COMMENT "Имя",
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone INT UNSIGNED NOT NULL,
  password_hash CHAR(65) DEFAULT NULL,
  passport VARCHAR(20),
  gender ENUM('f', 'm', 'x') NOT NULL, -- CHAR(1)
  birthday DATE NOT NULL,
  photo_id INT UNSIGNED,
  user_status VARCHAR(30),
  city_id BIGINT UNSIGNED,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
  UNIQUE INDEX email_unique (email),
  UNIQUE INDEX phone_unique (phone),
  INDEX fk_users_to_cities_idx (city_id),
  CONSTRAINT fk_users_cities FOREIGN KEY (city_id) REFERENCES cities (id)  
) ENGINE=InnoDB;



-- n:m

CREATE TABLE messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
  from_user_id BIGINT UNSIGNED NOT NULL, -- id = 1, Вася
  to_user_id BIGINT UNSIGNED NOT NULL, -- id = 2, Петя
  txt TEXT NOT NULL, -- txt = ПРИВЕТ
  is_delivered BOOLEAN DEFAULT False,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  INDEX fk_messages_from_user_idx (from_user_id),
  INDEX fk_messages_to_user_idx (to_user_id),
  CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);



-- n:m

CREATE TABLE friend_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
  from_user_id BIGINT UNSIGNED NOT NULL, -- id = 1, Вася
  to_user_id BIGINT UNSIGNED NOT NULL, -- id = 2, Петя
  accepted BOOLEAN DEFAULT False,
  INDEX fk_friend_requests_from_user_idx (from_user_id),
  INDEX fk_friend_requests_to_user_idx (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);



CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL,
  admin_id BIGINT UNSIGNED NOT NULL,
  INDEX fk_communities_users_admin_idx (admin_id),
  CONSTRAINT fk_communities_users FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;


-- n:m

-- Таблица связи пользователей и сообществ
CREATE TABLE communities_users (
  community_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (community_id, user_id),
  INDEX fk_communities_users_comm_idx (community_id),
  INDEX fk_communities_users_users_idx (user_id),
  CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;


CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL -- фото, музыка, документы
) ENGINE=InnoDB;


-- 1:n

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Картинка 1
  user_id BIGINT UNSIGNED NOT NULL,
  media_types_id INT UNSIGNED NOT NULL, -- фото
  file_name VARCHAR(245) DEFAULT NULL COMMENT '/files/folder/img.png',
  file_size BIGINT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX fk_media_media_types_idx (media_types_id),
  INDEX fk_media_users_idx (user_id),
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id),
  CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

/*
* Задание 2
*
* Придумать 2-3 таблицы для БД vk, которую мы создали на занятии (с перечнем полей, указанием индексов и внешних ключей). Прислать результат в виде скрипта *.sql.
*
* Возможные таблицы:
* a. Посты пользователя
* b. Лайки на посты пользователей, лайки на медиафайлы
* c. Черный список
* d. Школы, университеты для профиля пользователя
* e. Чаты (на несколько пользователей)
* f. Посты в сообществе
*
*/

/*
 * Таблица с видами образования - Высшее, среднее и т.п.
 */

CREATE TABLE type_of_education (
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_of_type VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

/*
 * Теперь сама таблица с образованием пользователя
 * связь 1-n
 * Дата окончания может быть не заполнена, если обучение не завершено
 * Сами учебные заведения тоже можно отдельной таблицей, если их можно унифицировать, 
 * в нашем случае пользователь будет писать название как хочет. 
 * Если нужно, добавлю еще одну таблицу и тогда Тип образования привяжу к списку учебных заведений
 */
CREATE TABLE education (
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
organization VARCHAR(245) NOT NULL,
finish DATE,
type_of_education BIGINT UNSIGNED NOT NULL,
INDEX fk_education_users_idx (user_id),
INDEX fk_education_type_of_aducation_idx (type_of_education),
CONSTRAINT fk_education_users FOREIGN KEY (user_id) REFERENCES users (id),
CONSTRAINT fk_education_type_of_aducation FOREIGN KEY (type_of_education) REFERENCES type_of_education (id)
) ENGINE=InnoDB;

/*
 * Посты пользователя, это текстовые сообщения с датой публикации
 * Принадлежат пользователю
*/

CREATE TABLE users_posts (
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
posts_text MEDIUMTEXT NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
INDEX fk_users_posts_users_idx (user_id),
CONSTRAINT fk_users_posts_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

/*
* Лайки постам могут ставить любые пользователи, у каждого поста может быть столько лайков, сколько есть пользователей
*/

CREATE TABLE likes_for_posts (
post_id BIGINT UNSIGNED NOT NULL,
user_id BIGINT UNSIGNED NOT NULL,
liked BOOL NOT NULL DEFAULT True,
updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (post_id, user_id),
INDEX fk_likes_for_posts_users_idx (user_id),
INDEX fk_likes_for_posts_posts_idx (post_id),
CONSTRAINT fk_likes_for_posts_users FOREIGN KEY (user_id) REFERENCES users (id),
CONSTRAINT fk_likes_for_posts_posts FOREIGN KEY (post_id) REFERENCES users_posts (id)
) ENGINE=InnoDB;

/*
* Лайки для медиа, то-же самое, что и для постов, только привязка к таблице с медиа
*/
CREATE TABLE likes_for_media (
media_id BIGINT UNSIGNED NOT NULL,
user_id BIGINT UNSIGNED NOT NULL,
liked BOOL NOT NULL DEFAULT True,
updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (media_id, user_id),
INDEX fk_likes_for_media_users_idx (user_id),
INDEX fk_likes_for_media_media_idx (media_id),
CONSTRAINT fk_likes_for_media_users FOREIGN KEY (user_id) REFERENCES users (id),
CONSTRAINT fk_likes_for_media_media FOREIGN KEY (media_id) REFERENCES media (id)
) ENGINE=InnoDB;


