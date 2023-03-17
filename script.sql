-- Database: movies

DROP DATABASE IF EXISTS movies;

CREATE DATABASE movies
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE movies
    IS 'Contains info about movies for web users';

\c movies
\encoding UTF8

-- Table: public.job_functions

-- DROP TABLE IF EXISTS public.job_functions;

CREATE TABLE IF NOT EXISTS public.job_functions
(
    id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 32767 CACHE 1 ),
    name character varying(100) NOT NULL,
    CONSTRAINT jobs_pk PRIMARY KEY (id),
    CONSTRAINT job_name_unique UNIQUE (name)
);

COMMENT ON TABLE public.job_functions
    IS 'The table contains types of position at film:
id - non-null auto incrementing identificator of the job;
name - the name of position - director, producer, etc.';

-- Table: public.person

-- DROP TABLE IF EXISTS public.person;

CREATE TABLE IF NOT EXISTS public.person
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying(100) NOT NULL,
    job_functions_id smallint NOT NULL,
    CONSTRAINT person_pk PRIMARY KEY (id),
    CONSTRAINT person_job_id_fk FOREIGN KEY (job_functions_id)
        REFERENCES public.job_functions (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID
);

COMMENT ON TABLE public.person
    IS 'The table contains people that participate in movies:
id - the unique auto incrementing primary key an id of the participant;
name - the name of the participant;
job_functions_id - the reference (foreign key) to id of the function in film.';


-- Table: public.countries

-- DROP TABLE IF EXISTS public.countries;

CREATE TABLE IF NOT EXISTS public.countries
(
    id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 32767 CACHE 1 ),
    name character varying(250) NOT NULL,
    CONSTRAINT countries_pk PRIMARY KEY (id),
    CONSTRAINT countries_name_unique UNIQUE (name)
);

COMMENT ON TABLE public.countries
    IS 'The table contains countries directory:
id - identificator of the country;
name - the name of the country.';

-- Table: public.genres

-- DROP TABLE IF EXISTS public.genres;

CREATE TABLE IF NOT EXISTS public.genres
(
    id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 32767 CACHE 1 ),
    genre character varying(50) NOT NULL,
    CONSTRAINT genres_pk PRIMARY KEY (id),
    CONSTRAINT genres_name_unique UNIQUE (genre)
);

COMMENT ON TABLE public.genres
    IS 'The table contains genres:
id - non-null auto incrementing identificator of genre;
name - the name of the genre.';

-- Table: public.film

-- DROP TABLE IF EXISTS public.film;

CREATE TABLE IF NOT EXISTS public.film
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying(200) NOT NULL,
    name_translation character varying(200),
    description text,
    year smallint NOT NULL,
    country_id smallint NOT NULL,
    slogan character varying(250),
    budget numeric,
    marketing numeric,
    own_country_fees numeric,
    other_fees numeric,
    age character varying(4) NOT NULL,
    "Mpaa_rating" character varying(5),
    film_time character varying(20),
    audiotracks character varying(200),
    subtitles character varying(50),
    video_quality character varying(50),
    words_url text,
    director_id bigint,
    scenario_id bigint,
    producer_id bigint,
    operator_id bigint,
    composer_id bigint,
    designer_id bigint,
    editor_id bigint,
    "premiere_Russia" date,
    premiere_other date,
    "DVD_release" date,
    CONSTRAINT film_pk PRIMARY KEY (id),
    CONSTRAINT composer_person_fk FOREIGN KEY (composer_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT country_countries_fk FOREIGN KEY (country_id)
        REFERENCES public.countries (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT designer_person_fk FOREIGN KEY (designer_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT director_person_fk FOREIGN KEY (director_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT editor_person_fk FOREIGN KEY (editor_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT operator_person_fk FOREIGN KEY (operator_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT producer_person_fk FOREIGN KEY (producer_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID,
    CONSTRAINT scenario_person_fk FOREIGN KEY (scenario_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID
);

COMMENT ON TABLE public.film
    IS 'The table contains info about the film, the some columns:
id - the unique auto incrementing primary key - an id of film;
name - the name of the film;
name_translation - translation of the name;
description - the annotation;
year - release year;
country_id - the foreign key to the table countries on country''s id;
premiere_Russia, premiere_other, DVD_release - only dates, simplified;
audiotracks - one track is expected - to simplify, etc.';

-- Table: public.film_genres

-- DROP TABLE IF EXISTS public.film_genres;

CREATE TABLE IF NOT EXISTS public.film_genres
(
    film_id bigint NOT NULL,
    genres_id smallint NOT NULL,
    CONSTRAINT film_genres_pk PRIMARY KEY (film_id, genres_id),
    CONSTRAINT film_id_fk FOREIGN KEY (film_id)
        REFERENCES public.film (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CONSTRAINT genre_id_fk FOREIGN KEY (genres_id)
        REFERENCES public.genres (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
);

COMMENT ON TABLE public.film_genres
    IS 'The table implements a many-to-many relationship between tables film and genres on the corresponding primary keys.';


-- Table: public.film_person

-- DROP TABLE IF EXISTS public.film_person;

CREATE TABLE IF NOT EXISTS public.film_person
(
    film_id bigint NOT NULL,
    person_id bigint NOT NULL,
    CONSTRAINT film_person_pk PRIMARY KEY (film_id, person_id),
    CONSTRAINT film_id_fk FOREIGN KEY (film_id)
        REFERENCES public.film (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CONSTRAINT person_id_fk FOREIGN KEY (person_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

COMMENT ON TABLE public.film_person
    IS 'The table implements a many-to-many relationship between tables film and persons on the corresponding primary keys for main roles and role doubles.';

-- Table: public.other_info

-- DROP TABLE IF EXISTS public.other_info;

CREATE TABLE IF NOT EXISTS public.other_info
(
    rating bigint,
    reviews integer,
    is_viewed boolean,
    will_watch boolean,
    place integer,
    film_id bigint NOT NULL,
    CONSTRAINT other_info_pkey PRIMARY KEY (film_id),
    CONSTRAINT film_id_fk FOREIGN KEY (film_id)
        REFERENCES public.film (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
        NOT VALID
);

COMMENT ON TABLE public.other_info
    IS 'Table contains other info about the film:
rating - the amount of estimations, place - the place in the rating (all estimations are not stored, such table can be very heavy);
reviews - the amount of reviews;
is_viewed, will_watch - boolean flags for watchers;
film_id - the reference to the certain film.';

-- Table: public.viewers

-- DROP TABLE IF EXISTS public.viewers;

CREATE TABLE IF NOT EXISTS public.viewers
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    amount integer NOT NULL,
    country_id smallint NOT NULL,
    film_id bigint NOT NULL,
    CONSTRAINT viewers_pk PRIMARY KEY (id),
    CONSTRAINT country_id_fk FOREIGN KEY (country_id)
        REFERENCES public.countries (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CONSTRAINT film_id_fk FOREIGN KEY (film_id)
        REFERENCES public.film (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE 
);

COMMENT ON TABLE public.viewers
    IS 'The table contains info about the viewers by country:
id - the primary key;
amount - the amount of viewers in the certain country;
country_id - the reference to country (foreign key);
film_id - the reference to film (foreign key).';

-- Table: public.watch_urls

-- DROP TABLE IF EXISTS public.watch_urls;

CREATE TABLE IF NOT EXISTS public.watch_urls
(
    id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 32767 CACHE 1 ),
    url text NOT NULL,
    film_id bigint,
    CONSTRAINT watch_urls_pkey PRIMARY KEY (id),
    CONSTRAINT film_id_fk FOREIGN KEY (film_id)
        REFERENCES public.film (id) MATCH SIMPLE
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

COMMENT ON TABLE public.watch_urls
    IS 'The table contains another urls to watch the film, film_id is a reference to the certain film.';

INSERT INTO public.countries (
name) VALUES (
'Австралия'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Бразилия'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Греция'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Ирландия'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Россия'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Великобритания'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'США'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Германия'::character varying)
 returning id;

INSERT INTO public.countries (
name) VALUES (
'Беларусь'::character varying)
 returning id;

----------------------------------------------

INSERT INTO public.genres (
genre) VALUES (
'драма'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'фэнтези'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'комедия'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'криминал'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'мелодрама'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'боевик'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'триллер'::character varying)
 returning id;

INSERT INTO public.genres (
genre) VALUES (
'вестерн'::character varying)
 returning id;

-------------------------------------------

INSERT INTO public.job_functions (
name) VALUES (
'Режиссер'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Автор сценария'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Продюсер'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Оператор'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Композитор'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Художник'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Монтаж'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'В главных ролях'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Роли дублировали'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Актер'::character varying)
 returning id;

INSERT INTO public.job_functions (
name) VALUES (
'Помощник оператора'::character varying)
 returning id;

----------------------------------------------------------------
INSERT INTO public.person (
name, job_functions_id) VALUES (
'Том Хэнкс'::character varying, '8'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Том Хэнкс'::character varying, '3'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Том Хэнкс'::character varying, '1'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид Морс'::character varying, '8'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид Морс'::character varying, '3'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид Морс'::character varying, '2'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид Морс'::character varying, '1'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Фрэнк Дарабонт'::character varying, '1'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид Валдес'::character varying, '3'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Владимир Антоник'::character varying, '9'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Дэвид ТеттерСол'::character varying, '4'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Томас Ньюман'::character varying, '5'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Теренс Марш'::character varying, '6'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ричард Фрэнсис-Брюс'::character varying, '7'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ума Турман'::character varying, '3'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ума Турман'::character varying, '8'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Квентин Тарантино'::character varying, '1'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ума Турман'::character varying, '2'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Лоуренс Бендер'::character varying, '3'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Роберт Ричардсон'::character varying, '4'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'RZA'::character varying, '5'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ёхэй Танеда'::character varying, '6'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Салли Менке'::character varying, '7'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Майкл Мэдсен'::character varying, '10'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Ольга Плетнева'::character varying, '9'::smallint)
 returning id;

INSERT INTO public.person (
name, job_functions_id) VALUES (
'Джули Дрейфус'::character varying, '10'::smallint)
 returning id;

----------------------------------------------------------------
INSERT INTO public.film (
name, name_translation, description, year, country_id, slogan, budget, marketing, own_country_fees, other_fees, age, "Mpaa_rating", film_time, audiotracks, subtitles, video_quality, words_url, director_id, scenario_id, producer_id, operator_id, composer_id, designer_id, editor_id, "premiere_Russia", premiere_other, "DVD_release") VALUES (
'Зеленая миля'::character varying, 'The Green Mile'::character varying, 'В тюрьме для смертников появляется заключенный с божественным даром. Мистическая драма по роману Стивена Кинга'::text, '1999'::smallint, '7'::smallint, '«Пол Эджкомб не верил в чудеса. Пока не столкнулся с одним из них»'::character varying, '60000000'::numeric, '30000000'::numeric, '136801374'::numeric, '150000000'::numeric, '16+'::character varying, 'R'::character varying, '189'::character varying, 'Русский'::character varying, 'Русские'::character varying, 'Full HD'::character varying, 'https://www.kinopoisk.ru/film/435/keywords/'::text, '8'::bigint, '6'::bigint, '9'::bigint, '11'::bigint, '12'::bigint, '13'::bigint, '14'::bigint, '2000-04-18'::date, '1999-12-06'::date, '2001-02-13'::date)
 returning id;

INSERT INTO public.film (
name, name_translation, year, country_id, slogan, budget, marketing, own_country_fees, other_fees, age, "Mpaa_rating", film_time, words_url, director_id, scenario_id, producer_id, operator_id, composer_id, designer_id, editor_id, "premiere_Russia", premiere_other, "DVD_release") VALUES (
'Убить Билла'::character varying, 'Kill Bill'::character varying, '2003'::smallint, '7'::smallint, '«И пришла невеста»'::character varying, '30000000'::numeric, '25000000'::numeric, '70099045'::numeric, '110800000'::numeric, '18+'::character varying, 'R'::character varying, '111'::character varying, 'https://www.kinopoisk.ru/film/2717/keywords/'::text, '17'::bigint, '18'::bigint, '19'::bigint, '20'::bigint, '21'::bigint, '22'::bigint, '23'::bigint, '04.12.2003'::date, '29.09.2003'::date, '30.03.2004'::date)
 returning id;
---------------------------------------------------------------------

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'1'::bigint, '1'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'1'::bigint, '2'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'1'::bigint, '4'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'2'::bigint, '1'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'2'::bigint, '4'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'2'::bigint, '6'::smallint)
 returning film_id,genres_id;

INSERT INTO public.film_genres (
film_id, genres_id) VALUES (
'2'::bigint, '7'::smallint)
 returning film_id,genres_id;

-------------------------------------------

INSERT INTO public.film_person (
film_id, person_id) VALUES (
'1'::bigint, '1'::bigint)
 returning film_id,person_id;

INSERT INTO public.film_person (
film_id, person_id) VALUES (
'1'::bigint, '4'::bigint)
returning film_id,person_id;

INSERT INTO public.film_person (
film_id, person_id) VALUES (
'2'::bigint, '16'::bigint)
 returning film_id,person_id;

INSERT INTO public.film_person (
film_id, person_id) VALUES (
'2'::bigint, '24'::bigint)
 returning film_id,person_id;

INSERT INTO public.film_person (
film_id, person_id) VALUES (
'2'::bigint, '25'::bigint)
 returning film_id,person_id;
------------------------------------------------------------------------

INSERT INTO public.other_info (
rating, reviews, will_watch, place, film_id) VALUES (
'868119'::bigint, '475'::integer, false::boolean, '1'::integer, '1'::bigint)
 returning film_id;

INSERT INTO public.other_info (
rating, reviews, will_watch, film_id) VALUES (
'276051'::bigint, '165'::integer, false::boolean, '2'::bigint)
 returning film_id;

----------------------------------------------------------------------------

INSERT INTO public.viewers (
amount, country_id, film_id) VALUES (
'26000000'::integer, '7'::smallint, '1'::bigint)
 returning id;

INSERT INTO public.viewers (
amount, country_id, film_id) VALUES (
'2107877'::integer, '8'::smallint, '1'::bigint)
 returning id;

INSERT INTO public.viewers (
amount, country_id, film_id) VALUES (
'11600000'::integer, '7'::smallint, '2'::bigint)
 returning id;

INSERT INTO public.viewers (
amount, country_id, film_id) VALUES (
'2400000'::integer, '6'::smallint, '2'::bigint)
 returning id;
----------------------------------------------------------------------------------

INSERT INTO public.watch_urls (
url, film_id) VALUES (
'https://okko.tv/movie/the-green-mile?utm_medium=referral&utm_source=yandex_search&utm_campaign=new_search_feed'::text, '1'::bigint)
 returning id;

INSERT INTO public.watch_urls (
url, film_id) VALUES (
'https://premier.one/show/zelenaja-milja-1999?utm_source=yandex&utm_medium=yandex_feed_search&utm_campaign=yandex_feed'::text, '1'::bigint)
 returning id;

INSERT INTO public.watch_urls (
url, film_id) VALUES (
'https://viju.ru/filmy/zelenaya-milya/?utm_campaign=yandex_content_integration&utm_medium=affiliate&utm_source=yandex'::text, '1'::bigint)
 returning id;
