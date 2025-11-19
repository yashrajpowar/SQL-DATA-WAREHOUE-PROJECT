/* static / fixed value which are not present on the file */


SELECT 123 AS static_number

SELECT 'HELLO' AS static_string

SELECT
id,
first_name,
'new customer' AS customer_type
FROM customers

/* create a new table acled persons with column : id, person_name, birth_date and phone*/

CREATE TABLE first_table (
    id INT NOT NULL,
    person_name VARCHAR(20) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
)

