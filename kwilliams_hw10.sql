USE sakila;

SELECT * FROM actor;
-------------------------------------------------------------------------------
#1a. Display the first and last names of all the actors from the table actor.
SELECT first_name,last_name FROM actor;
-------------------------------------------------------------------------------
#1b.Display the first and last name of each actor in a single column in upper case letters. 
#Name the column actorname.

ALTER TABLE actor
ADD COLUMN actorname VARCHAR(200);
UPDATE actor SET actorname=CONCAT(last_name,",  ",first_name);
SELECT * FROM actor;
--------------------------------------------------------------------------------
#2a.You need to find the ID number, first name, and last name of an actor, of whom you
#know only the first name, "Joe."  What is one query would you use to obtain this information?

SELECT actor_id, actorname
FROM actor 
WHERE first_name IN ("JOE");
---------------------------------------------------------------------------------
#2b.Find all actors who last name contain the letters GEN

SELECT actorname
FROM actor
WHERE last_name LIKE "%GEN%";
-----------------------------------------------------------------------------------
#2c.Find all actors whose last names contain the letters LI.  This time, order the rows by 
#last name and first name, in that order

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%";
   
------------------------------------------------------------------------------------
#2d.Using IN, display the country_id and country columns of the following countries:
#Afghanistan, Bangladesh, and China.

SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");
  --------------------------------------------------------------------------------
