-- Runner & Customer Experience

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
	EXTRACT(WEEK FROM registration_date + INTERVAL '7 DAYS') AS week_number,
	COUNT(*) AS no_of_runners
FROM pizza_runner.runners
GROUP BY 1
ORDER BY 1;

-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT 
	ro.runner_id AS runner,
	COUNT(DISTINCT ro.order_id) AS no_of_orders, 
	AVG(ro.pickup_time::timestamp - co.order_time) AS average_pickup_time
FROM pizza_runner.runner_orders AS ro
JOIN pizza_runner.customer_orders AS co
ON co.order_id = ro.order_id
WHERE pickup_time != 'None'
GROUP BY 1
ORDER BY 1;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT
	c.order_id,
	COUNT(C.order_id) AS no_of_pizzas,
	c.order_time,
	r.pickup_time::timestamp,
	r.pickup_time::timestamp - c.order_time AS preparation_time
FROM pizza_runner.customer_orders AS c
JOIN pizza_runner.runner_orders AS r
ON r.order_id = c.order_id
WHERE r.pickup_time != 'None'
GROUP BY 1,3,4,5
ORDER BY 2;

-- 4. What was the average distance travelled for each customer?
SELECT 
	c.customer_id AS customer,
	ROUND(AVG(r.distance::numeric), 2) AS average_distance
FROM pizza_runner.runner_orders AS r
JOIN pizza_runner.customer_orders AS c
ON c.order_id = r.order_id
WHERE r.pickup_time != 'None'
GROUP BY 1
ORDER BY 1;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration::integer) - MIN(duration::integer) AS delivery_time_difference
FROM pizza_runner.runner_orders AS r
JOIN pizza_runner.customer_orders AS c
ON c.order_id = r.order_id
WHERE r.pickup_time != 'None';

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT 
	r.runner_id,
	c.order_id,
	r.distance::numeric,
	r.duration::numeric,
	ROUND(AVG(r.distance::numeric/(r.duration::numeric/60)), 2) AS speed
FROM pizza_runner.runner_orders AS r
JOIN pizza_runner.customer_orders AS c
ON c.order_id = r.order_id
WHERE r.pickup_time != 'None'
GROUP BY 1,2,3,4
ORDER BY 1;

-- 7. What is the successful delivery percentage for each runner?
SELECT
	runner,
	no_of_orders,
	ROUND(delivered::numeric/ordered::numeric * 100, 0) AS percentage_delivery
FROM(SELECT 
	runner_id AS runner,
	COUNT(order_id) AS no_of_orders,
	COUNT(CASE WHEN order_id IS NOT NULL THEN 'ordered' END) AS ordered,
	COUNT(CASE WHEN cancellation = 'None' THEN 'delivered' END) AS delivered
FROM pizza_runner.runner_orders
GROUP BY 1
ORDER BY 1) AS t1;
