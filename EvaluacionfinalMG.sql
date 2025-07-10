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
WHERE last_name LIKE "Gibson";

-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name
FROM actor
WHERE actor_id BETWEEN 10 and 20; -- ids 10 and 20 included

-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
FROM film
WHERE rating NOT LIKE "R" and rating NOT LIKE "PG-13"; 

-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(title) AS "cantidad total de películas", f.rating -- this could be done with a distinct COUNT(DISTINCT(title)) and it would be more accurate since it would not include duplicated titles, but I'm leaving them there since it's asking for the total in each rating and duplicates count in this case.
FROM film AS f
GROUP BY rating;

-- Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id, c.first_name, c.last_name , COUNT(i.film_id) AS "Total peliculas alquiladas" -- alias to enhance legibility
FROM customer AS c
INNER JOIN rental AS r -- inner join because we want matches between customers and rentals
ON c.customer_id = r.customer_id
INNER JOIN inventory AS i -- inner join again because we just want matches. not interested in customers who did not rent
ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id;

-- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT cat.name, COUNT(r.rental_date) AS "Recuento alquileres"
FROM category AS cat
INNER JOIN film_category AS fc -- inners joins to retrieve coincidences
ON cat.category_id = fc.category_id
INNER JOIN film AS f
ON fc.film_id = f.film_id
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY cat.name;

-- Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
SELECT AVG(length), rating
FROM film
GROUP BY rating;

-- Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
WHERE f.title ="Indian Love";

-- Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción
SELECT title
FROM film
WHERE `description` LIKE "%dog%" or "%cat%";



