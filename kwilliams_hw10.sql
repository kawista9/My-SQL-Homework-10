USE sakila;

SELECT * FROM actor;
-------------------------------------------------------------------------------
#1a. Display the first and last names of all the actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor;
-------------------------------------------------------------------------------
#1b.Display the first and last name of each actor in a single column in upper case letters. 
#Name the column actorname.

ALTER TABLE actor
ADD COLUMN actorname VARCHAR(200);
UPDATE actor 
SET 
    actorname = CONCAT(last_name, ',  ', first_name);
SELECT 
    *
FROM
    actor;
--------------------------------------------------------------------------------
#2a.You need to find the ID number, first name, and last name of an actor, of whom you
#know only the first name, "Joe."  What is one query would you use to obtain this information?

SELECT 
    actor_id, actorname
FROM
    actor
WHERE
    first_name IN ('JOE');
---------------------------------------------------------------------------------
#2b.Find all actors who last name contain the letters GEN

SELECT 
    actorname
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
-----------------------------------------------------------------------------------
#2c.Find all actors whose last names contain the letters LI.  This time, order the rows by 
#last name and first name, in that order

SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%';
   
------------------------------------------------------------------------------------
#2d.Using IN, display the country_id and country columns of the following countries:
#Afghanistan, Bangladesh, and China.

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
  --------------------------------------------------------------------------------
#3a.You want to keep a description of each actor.  You don't think you will be performing
#queries on a description, so create a column in the table "actor" named "description" 
#and use the data type BLOB

ALTER TABLE actor
ADD COLUMN description BLOB(200);

SELECT 
    *
FROM
    actor;
-------------------------------------------------------------------------------------
#3b.Very quickly you realize that entering descriptions for each actor is too much effort.
#Delete the "description" column.

ALTER TABLE actor
DROP COLUMN description;

SELECT 
    *
FROM
    actor;
--------------------------------------------------------------------------------------
#4a.List the last names of actors, as well as how many actors have that last name

SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;
----------------------------------------------------------------------------------------
#4b.List last names of actors and the numbers of actors hwho have that last name, but only
#for names that are shared by at least two actors.

SELECT 
    last_name, COUNT(last_name) AS 'count_me'
FROM
    actor
GROUP BY last_name
HAVING count_me > 1;
-------------------------------------------------------------------------------------------
#4c.The actor HARPO WILLIAMS was accidentally entered in the "actor" table as GROUCHO WILLIAMS
#Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
SELECT 
    actorname
FROM
    actor
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'HARPO';


--------------------------------------------------------------------------------------------
#4d.Perhaps we were too hasty in changing GROUCHO to HARPO.  It turns out that GROUCHO was
#the correct name after all!  In a single query, if the first name of the actor is currently
#HARPO, change it to GROUCHO

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';

SELECT 
    actorname
FROM
    actor
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'GROUCHO';

--------------------------------------------------------------------------------------------
#5a.You cannot locate the schema of the "address" table.  Which query would you use to 
#recreate it?

SHOW CREATE TABLE address;
----------------------------------------------------------------------------------------------
#6a.Use "join" to display the first and last names, as well as the address, of each staff
#member in August of 2005.  Use tables "staff" and "address."

SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        INNER JOIN
    address ON staff.address_id = address.address_id;
----------------------------------------------------------------------------------------------

#6b.Use "join" to display the total amount rung up by each staff member in August of 2005.  
#Use tables staff and payment.

SELECT 
    staff.first_name, staff.last_name, SUM(payment.amount)
FROM
    staff
        INNER JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

----------------------------------------------------------------------------------------------
#6c.List each film and the number of actors who are listed for that film.  Use tables "film_actor"
#"film".  Use inner join.

SELECT 
    film.title, COUNT(film_actor.actor_id)
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

----------------------------------------------------------------------------------------------
#6d.How many copies of the film "Hunchback Impossible" exist in the inventory system?
SELECT 
    COUNT(inventory.film_id)
FROM
    inventory
        INNER JOIN
    film ON inventory.film_id = film.film_id
WHERE
    film.title = 'Hunchback Impossible';

-----------------------------------------------------------------------------------------------
#6e.Using the tables payment and customer and the "join" command, list the total paid by each
#customer.  List the customers alphabetically by last name:

SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS 'Total Amount Paid'
FROM
    customer
        INNER JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;
-----------------------------------------------------------------------------------------------
#7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence.  As an 
#unintended consequence, films starting with the letters k and q have also soared in 
#popularity.  Use subqueries to display the title of movies starting with the letters of k and q A
#whose language is English.

SELECT film.title, film.language_id=1
FROM film
WHERE film.title LIKE "k%" OR film.title LIKE "q%";
-----------------------------------------------------------------------------------------------
#7b.Use subqueries to display all actors who appear in the film "Alone Trip"

SELECT 
    actor.first_name, actor.last_name
FROM
    actor
WHERE
    actor.actor_id IN (SELECT 
            film_actor.actor_id
        FROM
            film_actor
        WHERE
            film_actor.film_id IN (SELECT 
                    film.film_id
                FROM
                    film
                WHERE
                    film.title = 'Alone Trip'));
                    
-------------------------------------------------------------------------------------------------
#7c. You want to run an email marketing campaign in Canada, for which you will need the names 
#and email addresses of all Canadian customers.  Use joins to retrieve this information.
#use customer and country

SELECT 
    customer.first_name, customer.last_name, customer.email
FROM
    customer
        INNER JOIN
    address ON customer.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id
WHERE
    country.country = 'Canada';
------------------------------------------------------------------------------------------------
#7d.Sales have been lagging amoung young families, and you with to target all family movies
#for a promotion. Identify all movies categorized as family films.

SELECT 
    film.title
FROM
    film
WHERE
    film.film_id IN (SELECT 
            film_category.film_id
        FROM
            film_category
        WHERE
            category_id = 8);
 -----------------------------------------------------------------------------------------------           
#7e.Display the most frequently rented movies in descending order.

SELECT film.title, count(film.film_id)
FROM film
WHERE film.film_id IN
(
SELECT inventory.film_id
FROM inventory
WHERE inventory.inventory_id IN
(
SELECT rental.inventory_id 
FROM rental
GROUP BY rental.inventory_id
)
);
------------------------------------------------------------------------------------------------
#7f.Write a query to display HOW MUCH BUSINESS, IN DOLLARS, EACH STORE BROUGHT IN

SELECT 
    SUM(payment.amount)
FROM
    payment
        INNER JOIN
    staff ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;
-----------------------------------------------------------------------------------------------
#7g. Write a query to display for each store its store ID, city and, country.

SELECT 
    store.store_id, city.city, country.country
FROM
    country
        INNER JOIN
    city ON country.country_id = city.country_id
        INNER JOIN
    address ON address.city_id = city.city_id
        INNER JOIN
    store ON address.address_id = store.address_id;
-----------------------------------------------------------------------------------------------
#7h. List the top five genres in gross revenue in descending order.

SELECT category.name, sum(payment.amount)
FROM category
inner join film_category
on category.category_id=film_category.category_id

inner join inventory on
inventory.film_id=film_category.film_id

WHERE inventory.inventory_id IN
(
select rental.inventory_id
FROM rental
WHERE rental.rental_id in
(
select payment.rental_id
from payment

)
)
GROUP BY category.category_id;
------------------------------------------------------------------------------------------------
#8a.

create view this as
SELECT 
    actor.first_name, actor.last_name
FROM
    actor
WHERE
    actor.actor_id IN (SELECT 
            film_actor.actor_id
        FROM
            film_actor
        WHERE
            film_actor.film_id IN (SELECT 
                    film.film_id
                FROM
                    film
                WHERE
                    film.title = 'Alone Trip'));
#8b. how to view the created view
select * from this;

#8c. deleting the created view

drop view this;


