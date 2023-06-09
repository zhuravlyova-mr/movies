# База данных для хранения фильмов

![База данных](images/db1.png) 
![Проектор](images/proj.jpg)


База данных называется movies. Она содержит информацию о фильмах, необходимую для размещения на сайтах, реализующих функции обработки и просмотра видеоконтента.


База имеет следующую структуру:


### Таблица видов работ/должностей - job_functions


1. id: первичный ключ (автоматически инкрементируется)
2. name: название вида работы (с ограничением уникальности). Примеры: режиссер, продюсер, автор сценария.


### Таблица "персоны" - person


1. id: первичный ключ (автоматически инкрементируется)
2. name: ФИО персоны
3. job_functions_id: внешний ключ, ссылка на вид работы, которую выполняла данная персона во время съемок фильма


### Таблица-справочник стран - countries


1. id: первичный ключ (автоматически инкрементируется)
2. name: название страны (с ограничением уникальности).


### Таблица  жанров - genres


1. id: первичный ключ (автоматически инкрементируется)
2. genre: название жанра (с ограничением уникальности).


### Таблица  фильмов - film

![](images/land.jpg)

Таблица содержит необходимую информацию о фильме, в том числе:

1. id: первичный ключ (автоматически инкрементируется)
2. name: название фильма
3. name_translation: перевод названия фильма на английский язык
4. description: аннотация к фильму
5. year: год выпуска фильма
6. country_id: внешний ключ для связи со страной, выпустившей фильма
7. director_id, scenario_id, producer_id, operator_id, composer_id, designer_id, editor_id: внешние ключи для связи с создателями и участниками фильма
8. premiere_Russia, premiere_other, DVD_release: только даты (для упрощения) соответственно премьеры в России, в других странах, выпуска на DVD
9. audiotracks: одна дорожка (для упрощения) и другие поля, описывающие фильм. 


### Таблица-связка фильмов с жанрами - film_genres


1. film_id: id фильма, внешний ключ, ссылка на id в film
2. genres_id: id жанра, внешний ключ, ссылка на id в genres

Совокупность обоих полей составляет первичный ключ.


### Таблица-связка фильмов с персонами (актерами и дублерами) - film_person


1. film_id: id фильма, внешний ключ, ссылка на id в film
2. person_id: id жанра, внешний ключ, ссылка на id в person

Совокупность обоих полей составляет первичный ключ.


### Таблица, содержащая другую информацию (больше подходящую для сайта) - other_info


1. rating: количество оценок, place - место в рейтинге (упрощенно - все оценки не сохраняются, такая таблица была бы слишком "тяжелой")
2. reviews: количество рецензентов
3. is_viewed, will_watch - флаги на странице для просматривающих фильм/информацию о фильме
4. film_id - внешний ключ, ссылка на конкретный фильм


### Таблица зрителей по странам - viewers


1. id: первичный ключ (автоинкрементируется)
2. amount: количество зрителей в определенной стране;
3. country_id: внешний ключ, ссылка на страну
4. film_id:  внешний ключ, ссылка на фильм


### Таблица дополнительных урлов (где еще посмотреть фильм) - watch_urls


1. id: первичный ключ (автоинкрементируется)
2. url: URL в текстовом виде
4. film_id:  внешний ключ, ссылка на фильм




## Порядок развертывания базы данных

Для создания базы данных и заполнения некоторыми начальными данными ее таблиц, рекомендуется выполнить следующие действия:

1. Закрыть все подключения к movies. Переключиться на какую-либо другую базу данных, например, postgres, т.е. в в psql выполнить:

\c postgres


Далее в psql нужно выполнить скрипт script.sql, находящийся в корне репозитория (скрипт удаляет текущую базу данных movies, поэтому при необходимости следует сделать ее бэкап):

\i /путь_к_скрипту/script.sql


Для проверки в базу с помощью скрипта добавляется информация о видах работ, странах, жанрах, двух фильмах и другие необходимые сведения для сохранения целостности данных.







