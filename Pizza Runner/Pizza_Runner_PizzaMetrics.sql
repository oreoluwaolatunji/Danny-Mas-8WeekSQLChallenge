-- PIZZA METRICS

-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS no_of_orders
FROM pizza_runner.customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS no_of_unique_orders
FROM pizza_runner.customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT 
	runner_id AS runner,
	COUNT(cancellation) AS no_of_succesful_deliveries
FROM pizza_runner.runner_orders
WHERE cancellation = 'None'
GROUP BY 1
ORDER BY 1;

-- 4. How many of each type of pizza was delivered?
SELECT 
	pn.pizza_name AS pizza_type,
	COUNT(cancellation) AS no_of_deliveres
FROM pizza_runner.customer_orders AS co
JOIN pizza_runner.pizza_names AS pn
ON pn.pizza_id = co.pizza_id
JOIN pizza_runner.runner_orders AS ro
ON ro.order_id = co.order_id
WHERE ro.cancellation = 'None'
GROUP BY 1
ORDER BY 1;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
	co.customer_id AS customer,
	pn.pizza_name AS pizza_type,
	COUNT(cancellation) AS no_of_orders
FROM pizza_runner.customer_orders AS co
JOIN pizza_runner.pizza_names AS pn
ON pn.pizza_id = co.pizza_id
JOIN pizza_runner.runner_orders AS ro
ON ro.order_id = co.order_id
GROUP BY 1,2
ORDER BY 1,2;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT 
	co.order_id AS order, 
	COUNT(*) AS no_of_pizza
FROM pizza_runner.runner_orders AS ro
JOIN pizza_runner.customer_orders AS co
ON co.order_id = ro.order_id
WHERE cancellation = 'None'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
	co.customer_id AS customer,
	COUNT(CASE WHEN exclusions = 'None' AND extras = 'None'  THEN 'no change' END) AS no_change,
	COUNT(CASE WHEN exclusions != 'None' OR extras != 'None'  THEN 'at least one change' END) AS atleast_one_change
FROM pizza_runner.runner_orders AS ro
JOIN pizza_runner.customer_orders AS co
ON co.order_id = ro.order_id
WHERE cancellation = 'None'
GROUP BY 1
ORDER BY 1;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS no_of_orders_with_exclusions_extras
FROM pizza_runner.runner_orders AS ro
JOIN pizza_runner.customer_orders AS co
ON co.order_id = ro.order_id
WHERE cancellation = 'None' AND extras != 'None' AND exclusions != 'None';

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	CONCAT(DATE_PART('hour', order_time),':','00') AS hour_of_day,
	COUNT(*) AS no_of_orders
FROM pizza_runner.customer_orders
GROUP BY 1
ORDER BY 2 DESC;

-- 10. What was the volume of orders for each day of the week?
SELECT 
	to_char(order_time, 'Day') AS day_of_week,
	COUNT(*) AS no_of_orders
FROM pizza_runner.customer_orders
GROUP BY 1
ORDER BY 2 DESC;