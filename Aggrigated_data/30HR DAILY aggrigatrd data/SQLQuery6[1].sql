
SELECT*
FROM customers

/* RETRIVE EACH COSTOMR NAME COUNTRY AND SCORE */

SELECT
	first_name,
	country,
	score
FROM customers

/* retrive customers with score highter then 500 */
SELECT*
FROM customers
WHERE score > 500

SELECT*
FROM customers
WHERE score != 0

-- retrive customers from germany

SELECT *
FROM customers
WHERE country = 'Germany' 

-- short the data
SELECT*
FROM customers
ORDER BY score ASC

/* IT MAKES COUNTRY LOWEST TO HEIGST and score highest to lowest*/
SELECT*
FROM customers
ORDER BY 
	country ASC,
	score DESC

/* group by */

SELECT
    country,
	SUM(score) as total_score
FROM customers
GROUP BY COUNTRY

/* find total score and total number of custoers for each country */

 SELECT 
     country,
	 SUM(score) AS total_score,
	 COUNT(first_name) AS total_customer
FROM customers
GROUP BY COUNTRY

-- HAVING
SELECT 
     country,
	 SUM(score) AS total_score
	 FROM customers
GROUP BY COUNTRY
HAVING SUM(score) > 800

/* find average score for each coutry considering only with customer
score not eqal to zero */
-- and return those countries with an average score grater than 430

SELECT
     country,
	 AVG(score) AS average_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430





