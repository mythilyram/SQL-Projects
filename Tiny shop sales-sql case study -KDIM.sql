# Schema (PostgreSQL v15)
#CREATE DATABASE `https://d-i-motion.com/lessons/customer-orders-analysis/` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

    CREATE TABLE customers (
        customer_id int,
        first_name varchar(100),
        last_name varchar(100),
        email varchar(100),
        PRIMARY KEY (customer_id)
    );
    
    CREATE TABLE products (
        -- product_id integer PRIMARY KEY,
        product_id int,
        product_name varchar(100),
        -- price decimal,
		price decimal(5,2),
        PRIMARY KEY (product_id)
    );
    
    CREATE TABLE orders (
        order_id integer PRIMARY KEY,
        customer_id integer,
        order_date date
    );
    
    CREATE TABLE order_items (
        order_id integer,
        product_id integer,
        quantity integer
    );
  
    INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
    (1, 'John', 'Doe', 'johndoe@email.com'),
    (2, 'Jane', 'Smith', 'janesmith@email.com'),
    (3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
    (4, 'Alice', 'Brown', 'alicebrown@email.com'),
    (5, 'Charlie', 'Davis', 'charliedavis@email.com'),
    (6, 'Eva', 'Fisher', 'evafisher@email.com'),
    (7, 'George', 'Harris', 'georgeharris@email.com'),
    (8, 'Ivy', 'Jones', 'ivyjones@email.com'),
    (9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
    (10, 'Lily', 'Nelson', 'lilynelson@email.com'),
    (11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
    (12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
    (13, 'Sophia', 'Thomas', 'sophiathomas@email.com');
    
    INSERT INTO products (product_id, product_name, price) VALUES
    (1, 'Product A', 10.00),
    (2, 'Product B', 15.00),
    (3, 'Product C', 20.00),
    (4, 'Product D', 25.00),
    (5, 'Product E', 30.00),
    (6, 'Product F', 35.00),
    (7, 'Product G', 40.00),
    (8, 'Product H', 45.00),
    (9, 'Product I', 50.00),
    (10, 'Product J', 55.00),
    (11, 'Product K', 60.00),
    (12, 'Product L', 65.00),
    (13, 'Product M', 70.00);
    
    INSERT INTO orders (order_id, customer_id, order_date) VALUES
    (1, 1, '2023-05-01'),
    (2, 2, '2023-05-02'),
    (3, 3, '2023-05-03'),
    (4, 1, '2023-05-04'),
    (5, 2, '2023-05-05'),
    (6, 3, '2023-05-06'),
    (7, 4, '2023-05-07'),
    (8, 5, '2023-05-08'),
    (9, 6, '2023-05-09'),
    (10, 7, '2023-05-10'),
    (11, 8, '2023-05-11'),
    (12, 9, '2023-05-12'),
    (13, 10, '2023-05-13'),
    (14, 11, '2023-05-14'),
    (15, 12, '2023-05-15'),
    (16, 13, '2023-05-16');
    
    INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 2, 1),
    (2, 3, 3),
    (3, 1, 1),
    (3, 3, 2),
    (4, 2, 4),
    (4, 3, 1),
    (5, 1, 1),
    (5, 3, 2),
    (6, 2, 3),
    (6, 1, 1),
    (7, 4, 1),
    (7, 5, 2),
    (8, 6, 3),
    (8, 7, 1),
    (9, 8, 2),
    (9, 9, 1),
    (10, 10, 3),
    (10, 11, 2),
    (11, 12, 1),
    (11, 13, 3),
    (12, 4, 2),
    (12, 5, 1),
    (13, 6, 3),
    (13, 7, 2),
    (14, 8, 1),
    (14, 9, 2),
    (15, 10, 3),
    (15, 11, 1),
    (16, 12, 2),
    (16, 13, 3);
    

---

**Query #1**
Questions

-- 1. Which product has the highest price? Only return a single row.

    SELECT * FROM products
    ORDER BY price DESC, product_name ASC
    LIMIT 1;

| product_id | product_name | price |
| ---------- | ------------ | ----- |
| 13         | Product M    | 70.00 |

---
**Query #2**
-- 2. Which customer has made the most orders?

    SELECT 
    	CONCAT(first_name,' ',last_name) as name,
    	COUNT(order_id) as order_count 
    FROM orders O
    JOIN customers C
    USING (customer_id)
    GROUP BY customer_id,first_name,last_name
    HAVING COUNT(order_id)>1
    ORDER BY order_count DESC;

| name        | order_count |
| ----------- | ----------- |
| John Doe    | 2           |
| Jane Smith  | 2           |
| Bob Johnson | 2           |

**Alternate Query #2**

    SELECT 
    *
    FROM (
    SELECT 
      C.customer_id,
      C.first_name,
      C.last_name,
      COUNT(O.order_id) as order_count,
      DENSE_RANK() OVER(ORDER BY COUNT(O.order_id) DESC) order_rank
    FROM orders O
    JOIN customers C
    USING (customer_id)
    GROUP BY C.customer_id,C.first_name,C.last_name) ranked_orders
    WHERE order_rank=1;

| customer_id | first_name | last_name | order_count | order_rank |
| ----------- | ---------- | --------- | ----------- | ---------- |
| 2           | Jane       | Smith     | 2           | 1          |
| 3           | Bob        | Johnson   | 2           | 1          |
| 1           | John       | Doe       | 2           | 1          |

---
-- 3. How many orders were placed in May, 2023? # REFER - EXTRACT MONTH
**Query #3**

    SELECT 
    	COUNT(*) May_orders
    FROM orders
    WHERE 
    		EXTRACT(MONTH FROM order_date) =5
    	AND EXTRACT(YEAR FROM order_date) =2023;

| may_orders |
| ---------- |
| 16         |

---
-- 4. What’s the total revenue per product?
**Query #4**

    SELECT 
    	P.product_id,
        P.product_name,
    	SUM(price*quantity) as total_revenue
    FROM products P
    JOIN order_items OI
    USING (product_id)
    GROUP BY P.product_id,P.product_name
    ORDER BY total_revenue DESC ;

| product_id | product_name | total_revenue |
| ---------- | ------------ | ------------- |
| 13         | Product M    | 420.00        |
| 10         | Product J    | 330.00        |
| 6          | Product F    | 210.00        |
| 12         | Product L    | 195.00        |
| 11         | Product K    | 180.00        |
| 3          | Product C    | 160.00        |
| 9          | Product I    | 150.00        |
| 8          | Product H    | 135.00        |
| 2          | Product B    | 135.00        |
| 7          | Product G    | 120.00        |
| 5          | Product E    | 90.00         |
| 4          | Product D    | 75.00         |
| 1          | Product A    | 50.00         |

-- --5. Find the date with the highest revenue.
**Query #5**

    SELECT 
    	order_date,
    	SUM(price*quantity) as order_revenue
    FROM orders O
    	JOIN order_items OI
    		USING (order_id)
    	JOIN products P
    		USING (product_id)
    GROUP BY order_date
    ORDER BY order_revenue DESC
    LIMIT 1;

| order_date               | order_revenue |
| ------------------------ | ------------- |
| 2023-05-16T00:00:00.000Z | 340.00        |

-- ---6. Find the month in 2023 with the highest total sales.
**Query #6**

    SELECT 
    	EXTRACT(MONTH FROM O.order_date) month_for_revenue,
    	SUM(price*quantity) as monthly_revenue
    FROM orders O
    	JOIN order_items OI
    		USING (order_id)
    	JOIN products P
    		USING (product_id)
    GROUP BY EXTRACT(MONTH FROM O.order_date)
    LIMIT 1;

| month_for_revenue | monthly_revenue |
| ----------------- | --------------- |
| 5                 | 2250.00         |

-- ---7. Find the top 3 customers who have ordered the most distinct products
**Query #7**

    WITH CTE AS (
     SELECT 
    	customer_id,
        COUNT(DISTINCT(product_id)) distinct_prod_count,
      	DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT(product_id))) distinct_prod_rank
    FROM orders O
    JOIN  order_items OI
    USING(order_id)   
    GROUP BY  customer_id ) 
    SELECT 
    	customer_id,
        distinct_prod_count
    FROM CTE 
    
    WHERE distinct_prod_rank =1
    LIMIT 3;

| customer_id | distinct_prod_count |
| ----------- | ------------------- |
| 13          | 2                   |
| 10          | 2                   |
| 11          | 2                   |

