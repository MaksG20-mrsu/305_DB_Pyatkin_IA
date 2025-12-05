PRAGMA foreign_keys = ON;
-- 1. Добавление пяти новых пользователей

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Пяткин Игорь', 'pyatkin.igor@student.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Полковников Дмитрий', 'polkovnikov.dmitry@student.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Пшеницына Полина', 'pshenitsyna.polina@student.ru', 'female', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Рыбаков Евгений', 'rybakov.evgeny@student.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Рыжкин Владислав', 'ryzhkin.vlad@student.ru', 'male', datetime('now', 'localtime'), 'student');

-- 1. Добавление трех новых фильмов

INSERT INTO movies (title, year)
VALUES ('Reincarnation (2018)', 2018);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Reincarnation (2018)' AND year = 2018),
    (SELECT id FROM genres WHERE name = 'Horror')
);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Reincarnation (2018)' AND year = 2018),
    (SELECT id FROM genres WHERE name = 'Thriller')
);

INSERT INTO movies (title, year)
VALUES ('Major Payne (1995)', 1995);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Major Payne (1995)' AND year = 1995),
    (SELECT id FROM genres WHERE name = 'Comedy')
);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Major Payne (1995)' AND year = 1995),
    (SELECT id FROM genres WHERE name = 'Children')
);

INSERT INTO movies (title, year)
VALUES ('Vivarium (2019)', 2019);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Vivarium (2019)' AND year = 2019),
    (SELECT id FROM genres WHERE name = 'Thriller')
);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Vivarium (2019)' AND year = 2019),
    (SELECT id FROM genres WHERE name = 'Sci-Fi')
);

-- 3. Добавление трех отзывов

-- Отзыв на Реинкарнацию (рейтинг 5/5)
INSERT INTO reviews (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'pyatkin.igor@student.ru'),
    (SELECT id FROM movies WHERE title = 'Reincarnation (2018)' AND year = 2018),
    5.0,
    strftime('%s', 'now')
);

-- Отзыв на Майор Пейн (рейтинг 5/5)
INSERT INTO reviews (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'pyatkin.igor@student.ru'),
    (SELECT id FROM movies WHERE title = 'Major Payne (1995)' AND year = 1995),
    5.0,
    strftime('%s', 'now')
);

-- Отзыв на Вивариум (рейтинг 4.5/5)
INSERT INTO reviews (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'pyatkin.igor@student.ru'),
    (SELECT id FROM movies WHERE title = 'Vivarium (2019)' AND year = 2019),
    4.5,
    strftime('%s', 'now')
);