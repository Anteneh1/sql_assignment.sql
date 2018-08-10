
/* Assignment on sakila
1. Displaying the Actor Name and Last Name*/
use sakila;
SELECT 
    first_name, last_name
FROM
    actor;
    
    
   /* Display the actor name in full , capitalized
   1.b*/
SELECT 
    UPPER(CONCAT(first_name, ' --', last_name)) AS 'Actor Name'
FROM
    actor;
    
    

/*----2a
 finding the ID number, first name, and last name of an actor, of whom  only the first name, "Joe." is given*/

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';
    
    
 /* 2.b
 finding all actors whose last name contain the letters `GEN`: */
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
    
    
 /* 2c
 last names contain the letters `LI`-- then  with last name written first*/
SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%';
    

/*2.d
displaying  the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:*/
 SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China'); 
    
    
 /*3.a
 Adding  a `middle_name` column to the table `actor` and positioning  it after `first_name`....*/
 ALTER TABLE
     actor
add 
  middle_name varchar(45) 
 AFTER 
  first_name;
  
  
/*3.b
Changing  the data type of the `middle_name` column to `blobs`....*/
alter table actor
modify column  middle_name blob; 



/*3.c
delete the `middle_name` column.......*/
alter table actor
drop middle_name;


/*4.a
 Listing the ast names of actors, as well as well as the count of aliases with the same last name.....*/
 SELECT 
    last_name, COUNT(last_name) AS ' Number of Aliases'
FROM
    actor
GROUP BY last_name;


/* 4.b
The number of actors who have that last name,shared by at least two actors or more........*/
SELECT 
    COUNT(last_name), last_name
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;


/* 4.c
a query to fix only one of the  record's name ....*/
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';


/*4.d
chainging the name back using actor_id....*/
SELECT 
    actor_id
FROM
    actor
WHERE
    (first_name = 'HARPO')
        AND (last_name = 'WILLIAMS');
        
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE 
actor_id=172;



/*5...*/
show tables; /* ...this shows all the tables present in the database 
in order to create another table called address table . we use..

create table ......Statement..*/




/* 6.a
displaying the first and last names,  the address, of each staff member....*/
SELECT 
    S.first_name, S.last_name, A.address
FROM
    staff AS S
        LEFT JOIN
    address AS A ON A.address_id = S.address_id;
    
    

/* 6.b
display ing the total amount rung up by each staff member in August of 2005.....*/
SELECT 
    S.first_name, S.last_name, P.amount, P.payment_date
FROM
    payment AS P
        INNER JOIN
    staff AS S ON S.staff_id = P.staff_id
WHERE
    payment_date IN (SELECT 
            payment_date
        FROM
            payment
        WHERE
            `payment_date` BETWEEN '2005-08-01 00:00:01' AND '2005-08-31 23:59:59');
            


/* 6.c
each film and the number of actors involved.....*/
  SELECT 
    f.title, COUNT(fa.actor_id) AS 'Actors involved'
FROM
    film AS f
        INNER JOIN
    film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.title;



-- 6.d
-- number of copies of the film `Hunchback Impossible....
SELECT 
    COUNT(film_id) AS 'no of copies'
FROM
    inventory
GROUP BY film_id
HAVING film_id = (SELECT 
        film_id
    FROM
        film
    WHERE
        title = 'HUNCHBACK IMPOSSIBLE');
        
        
	
 -- 6.e
 -- total paid by each customer....
 SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS 'Total amount Paid'
FROM
    customer AS c
        INNER JOIN
    payment AS p ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;



-- 7.a
-- movies starting with the letters `K` and `Q` and whose language is enlish...
SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND (language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English'));
            
            
 
 -- 7.b
 -- Actors in ALONE TRIP.....
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    EXISTS( SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'ALONE TRIP'));
                    
                    
                    
-- 7.c
-- names and email addresses of all Canadian customers ...
SELECT 
    a.first_name, a.last_name, a.email, d.country
FROM
    customer AS a
        INNER JOIN
    address AS b ON b.address_id = a.address_id
        INNER JOIN
    city AS c ON c.city_id = b.city_id
        INNER JOIN
    country AS d ON d.country_id = c.country_id
WHERE
    country = 'Canada';   
    
    
    
 -- 7.d
 -- all family movies 
SELECT 
    title AS 'Family movies'
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));
                    
                    
                    
-- 7.e
-- Displaying  the most frequently rented movies in descending order by thier  title and the total times rented .....
SELECT 
    COUNT(film.title) AS ' Total times rented', film.title
FROM
    film
        RIGHT JOIN
    inventory ON inventory.film_id = film.film_id
        RIGHT JOIN
    rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY COUNT(film.title) DESC;



-- 7.f
-- Amount each store brought in.....
SELECT 
    staff_id AS ' Store No', SUM(amount) AS ' Total business'
FROM
    payment
GROUP BY staff_id;



-- 7.g
-- store ID, city, and country......
SELECT 
    d.store_id, b.city, a.country
FROM
    country AS a
        INNER JOIN
    city AS b ON b.country_id = a.country_id
        INNER JOIN
    address AS c ON c.city_id = b.city_id
        INNER JOIN
    store AS d ON d.address_id = c.address_id;
    
    
    
-- 7.h
-- the top five genres in gross revenue ......
SELECT 
    a.name, SUM(amount)
FROM
    category AS a
        INNER JOIN
    film_category AS b ON b.category_id = a.category_id
        INNER JOIN
    inventory AS c ON c.film_id = b.film_id
        INNER JOIN
    rental AS d ON d.inventory_id = c.inventory_id
        INNER JOIN
    payment AS e ON e.rental_id = d.rental_id
GROUP BY a.name
ORDER BY SUM(amount) DESC
LIMIT 5;

 

-- 8.a
-- to create a view....
CREATE VIEW top_genres AS
    SELECT 
        a.name, SUM(amount)
    FROM
        category AS a
            INNER JOIN
        film_category AS b ON b.category_id = a.category_id
            INNER JOIN
        inventory AS c ON c.film_id = b.film_id
            INNER JOIN
        rental AS d ON d.inventory_id = c.inventory_id
            INNER JOIN
        payment AS e ON e.rental_id = d.rental_id
    GROUP BY a.name
    ORDER BY SUM(amount) DESC;
    
    
    
-- 8.b
--  to display the view that is  created .....
SELECT 
    *
FROM
    top_genres;

-- 8.c
-- a query to delete the view.....

drop view top_genres;




                    
   

 
  