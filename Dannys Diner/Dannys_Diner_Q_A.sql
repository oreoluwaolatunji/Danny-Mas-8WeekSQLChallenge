-- 1). What is the total amount each customer spent at the restaurant?
SELECT 
	s.customer_id AS customer,
	CONCAT('$', SUM(price)) AS total_amount
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
GROUP BY 1
ORDER BY 1;

-- 2). How many days has each customer visited the restaurant?
SELECT 
	customer_id AS customer,
	COUNT(DISTINCT order_date) AS no_of_visits
FROM dannys_diner.sales AS m
GROUP BY 1
ORDER BY 1;

-- 3). What was the first item from the menu purchased by each customer?
SELECT
	customer,
	date,
	product
FROM(SELECT
	s.customer_id AS customer,
	s.order_date AS date,
	m.product_name AS product,
	ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER by s.order_date) AS row_number
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id) AS t1
WHERE row_number = 1;

-- 4). What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	m.product_name,
	COUNT(s.order_date) AS no_of_purchases
FROM dannys_diner.menu AS m
JOIN dannys_diner.sales AS s
ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- 5). Which item was the most popular for each customer?
SELECT
	customer,
	product,
	no_of_purchases
FROM(SELECT
	s.customer_id AS customer,
	product_name AS product,
	COUNT(order_date) AS no_of_purchases,
	RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(order_date) DESC) AS rank
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON m.product_id = s.product_id
GROUP BY 1,2) AS t1
WHERE rank = 1;

-- 6). Which item was purchased first by the customer after they became a member?
SELECT
	customer,
	product
FROM(SELECT
	s.customer_id AS customer,
	join_date,
	product_name AS product,
	order_date,
	ROW_NUMBER() OVER(PARTITION by s.customer_id ORDER BY order_date) AS row_number
FROM dannys_diner.members AS m
JOIN dannys_diner.sales AS s
ON m.customer_id = s.customer_id
JOIN dannys_diner.menu AS menu
ON menu.product_id = s.product_id
WHERE m.join_date <= s.order_date) AS t1
WHERE row_number = 1;

-- 7). Which item was purchased just before the customer became a member?
SELECT
	customer,
	product
FROM(SELECT
	s.customer_id AS customer,
	join_date,
	product_name AS product,
	order_date,
	ROW_NUMBER() OVER(PARTITION by s.customer_id ORDER BY order_date DESC) AS row_number
FROM dannys_diner.members AS m
JOIN dannys_diner.sales AS s
ON m.customer_id = s.customer_id
JOIN dannys_diner.menu AS menu
ON menu.product_id = s.product_id
WHERE m.join_date > s.order_date) AS t1
WHERE row_number = 1;

-- 8). What is the total items and amount spent for each member before they became a member?
SELECT 
	m.customer_id AS customer,
	COUNT(s.product_id) AS no_of_purchases,
	CONCAT('$', SUM(menu.price)) AS total_amount
FROM dannys_diner.menu AS menu
JOIN dannys_diner.sales AS s
ON menu.product_id = s.product_id
LEFT JOIN dannys_diner.members AS m
ON m.customer_id = s.customer_id
WHERE s.order_date < m.join_date
GROUP BY 1;

-- 9). If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
	customer,
	SUM(points) AS points
FROM(SELECT 
	s.customer_id AS customer,
	m.product_name AS product,
	m.price AS price,
	CASE WHEN m.product_name = 'sushi' THEN m.price * 20 ELSE m.price * 10 END AS points
FROM dannys_diner.menu AS m
JOIN dannys_diner.sales AS s
ON m.product_id = s.product_id
ORDER BY 1) AS t1
GROUP BY 1;

-- 10). In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT
	customer,
	SUM(tally) AS points
FROM(SELECT
	s.customer_id AS customer,
	m.join_date AS join_date,
	s.order_date AS order_date,
	m.join_date + 7 AS one_week,
	menu.product_name AS product,
	menu.price AS price,
	CASE WHEN s.order_date < (m.join_date + 7) THEN menu.price * 20 ELSE menu.price * 10 END AS tally
FROM dannys_diner.menu AS menu
JOIN dannys_diner.sales AS s
ON s.product_id = menu.product_id
JOIN dannys_diner.members AS m
ON m.customer_id = s.customer_id
WHERE s.order_date >= m.join_date AND DATE_PART('month', order_date) = 1
ORDER BY 1) AS t1
GROUP BY 1
ORDER BY 1;