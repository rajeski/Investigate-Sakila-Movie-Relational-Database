/* Q.1) – Here are the top six categories (with animation, family and children being the top three) based on each movie, film category and total number of rentals. */

SELECT f.title, c.name, count(rental_id) as rental_count from rental r
    LEFT JOIN inventory i on r.inventory_id = i.inventory_id
    INNER JOIN film_category fc ON i.film_id = fc.film_id
    INNER JOIN film f on f.film_id = fc.film_id
    INNER JOIN category c on fc.category_id = c.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY f.title, c.name
ORDER by name, rental_count DESC

/* Q.1, 2) – Here are the same top six categories box and whisker-plotted based on quartiles and duration. */

SELECT f.title film_title,
       c.name category_name,
       f.rental_duration duration,
       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
  FROM film f
  INNER JOIN film_category fc
    ON f.film_id = fc.film_id
  INNER JOIN category c
    ON fc.category_id = c.category_id
 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

/* Q.1, 3) – Here are the same top six categories based on the rental length in quartiles and count of movies. */

 WITH t1 AS (
 	SELECT f.title film_title,
 	       c.name category_name,
 	       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
 	  FROM film f
 	  INNER JOIN film_category fc
 	    ON f.film_id = fc.film_id
 	  INNER JOIN category c
 	    ON fc.category_id = c.category_id
 	 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

 	 )

 	 SELECT category_name,
 	        standard_quartile,
 	        COUNT(film_title)
 	   FROM t1
 	  GROUP BY 1, 2
 	  ORDER BY 1, 2

/* Q.2, 1) - Here is a store-to-store comparison for select months (in a 10-month period). */

    SELECT DATE_PART('month', rental.rental_date) AS rental_month,
           DATE_PART('year', rental.rental_date) AS rental_year,
           store.store_id,
           COUNT(store.store_id)
      FROM store
      JOIN staff
        ON store.store_id = staff.store_id
      JOIN rental
        ON staff.staff_id = rental.staff_id
     GROUP BY 1, 2, 3
     ORDER BY 2, 1, 4 DESC
