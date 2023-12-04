-- PRICING

 -- 1. If a meatlover costs $12 and vegetarian costs $10 and there was no charge for changes - how much money has pizza runner made so far if there are no delivery fees?
SELECT SUM(revenue) AS total_revenue
FROM(SELECT
	n.pizza_name AS pizza,
	CASE WHEN n.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END AS unit_price,
	COUNT(*) AS no_of_orders,
	SUM(CASE WHEN n.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS revenue
FROM pizza_runner.customer_orders AS c
JOIN pizza_runner.runner_orders AS r
ON c.order_id = r.order_id
JOIN pizza_runner.pizza_names AS n
ON n.pizza_id = c.pizza_id
WHERE r.cancellation = 'None'
GROUP BY 1,2) AS t1;

-- 2. What if there was an additional $1 charge of any pizza extras?
SELECT SUM(revenue + extras_charge) AS total_revenue
FROM(SELECT
	n.pizza_name AS pizza,
	SUM(CASE WHEN n.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS revenue,
	SUM(CASE WHEN c.extras = 'None' THEN 0 ELSE 1 END) AS extras_charge
FROM pizza_runner.customer_orders AS c
JOIN pizza_runner.runner_orders AS r
ON c.order_id = r.order_id
JOIN pizza_runner.pizza_names AS n
ON n.pizza_id = c.pizza_id
WHERE r.cancellation = 'None'
GROUP BY 1) AS T1;

-- 3. If a meatlover is $12 and vegetarian $10 with no charge for extras and each runner is paid $0.30 per kilometer travelled, how much money does pizza runner have after all deliveries?
SELECT SUM(pizza_price) - SUM(pay_per_km) AS revenue_left
FROM(SELECT 
	r.runner_id AS runner,
	r.distance,
	r.distance::numeric * 0.30 AS pay_per_km,
	CASE WHEN c.pizza_id = 1 THEN 12 ELSE 10 END AS pizza_price
FROM pizza_runner.customer_orders AS c
JOIN pizza_runner.runner_orders AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'None') AS t1