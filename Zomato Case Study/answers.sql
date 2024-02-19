-- Q1. Select a database
USE zomato;

-- Q2. Count total number of orders
SELECT COUNT(*) FROM orders;
-- Q3. Return n random records froms orders table i.e. finding 5 random samples.

SELECT * FROM orders
ORDER BY RAND() LIMIT 5;

-- Q4. Find NULL values from the orders table.
SELECT * FROM orders
WHERE restaurant_rating =''; 
/*Here we could have used 'IS NULL' but the empty fields are not treated as 'NULL' in this column. 
Hence, compared '' which is actually NULL value*/

-- Q5. Replace empty fields with NULL values.
UPDATE orders SET restaurant_rating = NULL
WHERE restaurant_rating =0; 

-- Q6. Find the number of orders placed by each customer.
SELECT name,COUNT(*) AS num_orders 
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY name;

-- Q7. Find the restaurants with the highest number of menu items.
SELECT r_name, COUNT(*) AS menu_items 
FROM menu m
JOIN restaurants r
ON m.r_id = r.r_id
GROUP BY r_name
ORDER BY menu_items DESC;

-- Q8. Find the number of votes and avg rating for all restaurants.
SELECT r_name, COUNT(restaurant_rating) AS total_ratings, ROUND(AVG(restaurant_rating),2) AS ratings 
FROM orders o
JOIN restaurants r
ON o.r_id = r.r_id
GROUP BY r_name;

-- Q9. Which food item is sold by most of the restaurants?
SELECT f_name, COUNT(*) AS num_occurance 
FROM menu t1
JOIN food t2
ON t1.f_id = t2.f_id
GROUP BY t2.f_name
ORDER BY num_occurance DESC 
LIMIT 1;

-- Q10. Which restaurant had the maximum revenue in the month of May
SELECT t1.r_name, SUM(amount) AS revenue 
FROM restaurants t1
JOIN orders t2
ON t1.r_id = t2.r_id
WHERE MONTH(DATE(t2.date))=5
GROUP BY t1.r_name
ORDER BY revenue DESC 
LIMIT 1;

-- Q11. Month wise revenues of restaurants
SELECT t2.r_name, MONTH(DATE(t1.date)) AS months, SUM(amount) as revenue
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t2.r_name, months
ORDER BY months,revenue;

-- Q12. Find restaurants with revenue more than 1500.
SELECT t2.r_name, SUM(t1.amount) AS revenue 
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t2.r_name
HAVING revenue >= 1500;

-- Q13. Find customers who never ordered.
SELECT t2.name FROM orders t1
RIGHT JOIN users t2
ON t1.user_id = t2.user_id
WHERE t1.order_id IS NULL;

-- Q14. Show order details of particular customer in given date range. 
-- (For example, Order details of Neha from 5th june to 15th july 2022.)
SELECT t1.order_id,t1.amount,  t3.f_name ,  t1.date
FROM orders t1
JOIN order_details t2 
ON t2.order_id = t1.order_id
JOIN food t3 
ON t2.f_id = t3.f_id
WHERE (t1.date BETWEEN '2022-06-05' AND '2022-07-15') AND (t1.user_id = 1);

-- Q15. Find the costliest restaurants.
SELECT r.r_name,AVG(m.price) AS avg_price 
FROM menu m
JOIN restaurants r
ON m.r_id = r.r_id
GROUP BY r.r_name
ORDER BY avg_price DESC 
LIMIT 1;

-- Q16. Find delivery partner compensation using the formula (# deliveries * 100 + 1000 * avg_rating)
SELECT partner_name, ( (COUNT(*)*100) + (AVG(o.delivery_rating)*1000) ) as compensation 
FROM orders o
JOIN delivery_partner d
ON o.partner_id = d.partner_id
GROUP BY partner_name
ORDER BY compensation DESC;

-- Q17. Find all Veg restaurants.
SELECT DISTINCT(r_name) 
FROM food f
JOIN menu m
ON f.f_id = m.f_id
JOIN restaurants r
ON m.r_id = r.r_id
EXCEPT
SELECT DISTINCT(r_name) 
FROM food f
JOIN menu m
ON f.f_id = m.f_id
JOIN restaurants r
ON m.r_id = r.r_id
WHERE type = 'Non-veg';

-- Q18. Find min and max order value for all customers.
SELECT name,MIN(amount) as min_order_value, MAX(amount) as max_order_value 
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY name;