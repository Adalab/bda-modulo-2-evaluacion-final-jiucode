USE sakila; 

-- Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT(title) -- using distinct to remove dupes
FROM film;

--  Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
from film
WHERE rating = "PG-13";

--  Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, `description`
FROM film
WHERE `description` LIKE "%amazing%" OR `description` LIKE "%amazing" OR `description` LIKE "amazing%";  -- done like that because I tried to include the word in any position of the description

-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
SELECT title 
FROM film
WHERE length > 120;  -- 120 not included

-- Recupera los nombres de todos los actores.
SELECT first_name
FROM actor; -- not doing additional filtering on this because there might be different actors under the same name, it doesn't make sense to remove duplicates. 
-- At the same time, I feel like it would make sense to add the last_name too to the query, however, I'm going to add only the first_name since it was the only thing requested.

-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "Gibson"



