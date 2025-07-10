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

-- Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor -- no.
SELECT a.actor_id, a.first_name
FROM actor AS a
LEFT JOIN film_actor AS fa -- left join so it can get all actors even if they didn't participate in any movie.
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL; -- checking for null ids

-- Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010; 

-- Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id
WHERE c.name ="Family";

-- Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
GROUP BY a.first_name, a.last_name -- group by must be before the having. if not it gives an error.
HAVING COUNT(f.film_id) > 10;

--  Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film
 SELECT title
 FROM film
 WHERE rating ="R" AND length> 120;
 
 -- Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración
SELECT rating, AVG(length)
FROM film
WHERE length> 120
GROUP BY rating;
 
 -- Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name, COUNT(f.film_id) as "cantidad de peliculas"
FROM actor AS a
INNER JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
GROUP BY a.first_name 
HAVING COUNT(f.film_id) >= 5; -- 5 should be included in this case

 -- Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
 
 -- subquery
 SELECT rental_id, rental_date, return_date
 FROM rental
 WHERE datediff(return_date,rental_date) > 5; 

-- merging all together
 SELECT f.title
 FROM film AS f
 INNER JOIN inventory AS i
 ON f.film_id = i.film_id
 INNER JOIN rental AS r
 ON i.inventory_id = r.rental_id
 WHERE r.rental_id IN (SELECT rental_id -- we removed the extra fields to avoid errors . Apart from that, we use IN to check the rental id using the conditions. if we use = it fails)
 FROM rental
 WHERE datediff(return_date,rental_date) > 5);
 
 -- Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT a.first_name, a.last_name
FROM actor AS a
where a.actor_id NOT IN (SELECT a.actor_id 
 FROM actor AS a
 LEFT JOIN film_actor AS fa
 ON a.actor_id = fa.actor_id
 LEFT JOIN film AS f
 ON fa.film_id = f.film_id
 LEFT JOIN film_category AS fc
 ON f.film_id=fc.film_id
 LEFT JOIN category AS c
 ON fc.category_id=c.category_id
 WHERE c.name = "Horror")
 
 
 
 
 
 
 