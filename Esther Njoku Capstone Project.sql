--Esther Njoku|C3/083 CAPSTONE Project--


-- 1. Display the customer names that share the same address (e.g. husband and wife)--
SELECT customer.first_name, customer.last_name, address.address, 
count(address.address_id)
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
group by customer.first_name, customer.last_name, address.address
having count(address.address_id)>1;
					

-- 2.  What is the name of the customer who made the highest total payments.
SELECT first_name, last_name, SUM(amount)AS total_payments
FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_payments DESC LIMIT 1;


-- 3. What is the movie(s) that was rented the most.
SELECT title AS movie_name, film_id, count(film_id)
FROM FILM 
INNER JOIN INVENTORY USING (FILM_ID)
INNER JOIN RENTAL USING (INVENTORY_ID)
GROUP BY film_id
ORDER BY count(film_id) DESC LIMIT 1;


-- 4. Which movies have been rented so far.
SELECT DISTINCT title AS movie_name
FROM film 
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id;


-- 5.  Which movies have not been rented so far.
SELECT DISTINCT title AS movie_name
FROM film 
LEFT JOIN inventory 
ON film.film_id = inventory.film_id
LEFT JOIN rental 
ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;


-- 6. Which customers have not rented any movies so far.
SELECT customer.first_name, customer.last_name
FROM customer 
LEFT JOIN rental  ON customer.customer_id = rental.customer_id
WHERE rental.rental_id IS NULL;


-- 7. Display each movie and the number of times it got rented
SELECT f.title AS Movies, COUNT(r.rental_id) AS rental_Count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_Count ASC;


-- 8. Show the first name and last name and the number of films each actor acted in
SELECT first_name, last_name, COUNT(film_actor.film_id) AS num_films
FROM film_actor 
INNER JOIN actor
ON film_actor.actor_id = actor.actor_id
GROUP BY (first_name, last_name)
ORDER BY num_films ASC;

--9. Display the names of the actors that acted in more than 20 movies
SELECT first_name, last_name, COUNT(film_actor.film_id)
FROM film_actor 
INNER JOIN actor
ON film_actor.actor_id = actor.actor_id
GROUP BY (first_name, last_name)
Having COUNT(film_actor.film_id) >20;

--10. For all the movies rated “PG” show me the movie and the number of times it got rented.
SELECT title AS Movies, COUNT(rental.rental_id) AS Rental_Count
FROM film 
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental  ON inventory.inventory_id = rental.inventory_id
WHERE film.rating = 'PG'
GROUP BY title
ORDER BY rental_Count ASC;


-- 11. Display the movies offered for rent in store_id 1 and not offered in store_id 2.
SELECT DISTINCT f.title AS Movies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
AND f.film_id NOT IN 
(SELECT DISTINCT f2.film_id
 FROM film f2
 JOIN inventory i2 ON f2.film_id = i2.film_id
 WHERE i2.store_id = 2);

-- 12. Display the movies offered for rent in any of the two stores 1 and 2.
SELECT DISTINCT title AS Movies
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE i.store_id IN (1, 2);
 
 
-- 13. Display the movie titles of those movies offered in both stores at the same time.
SELECT title AS movie_titles
FROM inventory i1
JOIN inventory i2 ON i1.film_id = i2.film_id
JOIN film f ON i1.film_id = f.film_id
WHERE i1.store_id = 1 AND i2.store_id = 2
GROUP BY f.film_id, f.title;


-- 14. Display the movie title for the most rented movie in the store with store_id 1.
SELECT 
    f.title AS movie_titles, 
    COUNT(r.rental_id) AS Rental_Count
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    i.store_id = 1
GROUP BY 
    f.film_id, f.title
ORDER BY 
    Rental_Count DESC
LIMIT 1;


-- 15. How many movies are not offered for rent in the stores yet. There are two stores only 1 and 2.
SELECT COUNT(*) AS "Movies Not Offered"
FROM film 
LEFT JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IS NULL;


--16. Show the number of rented movies under each rating.
SELECT 
film.rating, COUNT(rental.rental_id) AS "rented number"
FROM 
film 
JOIN 
inventory ON film.film_id = inventory.film_id
JOIN 
rental ON inventory.inventory_id = rental.inventory_id
GROUP BY 
film.rating
ORDER BY "rented number" DESC;


-- 17. Show the profit of each of the stores 1 and 2
SELECT 
    i.store_id, 
    SUM(p.amount) AS Total_Profit
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
GROUP BY 
    i.store_id
ORDER BY 
    i.store_id;
