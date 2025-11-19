-- copy data from customers to table persons

INSERT INTO first_table(id, person_name, birth_date, phone)
SELECT
id,
first_name,
null,
'unknown'
FROM customers

SELECT * 
FROM first_table 

SELECT *
FROM customers

UPDATE customers
SET score = 0
WHERE id = 6 

-- Change the score. of customer with ID 10 to O and update the country to 'UK'
UPDATE customers
SET country = 'UK',
    score = 0
WHERE id = 7

SELECT *
FROM customers

UPDATE customers
SET score = 10
WHERE score = 0 

-- delete all customers with id greater than 5

DELETE FROM customers
WHERE id > 5

SELECT *
FROM customers 

TRUNCATE TABLE first_table  -- clear the whole table at once without cheacking or logging



