-- INGREDIENT OPTIMISATION

-- 1. What are the standard ingredients for each pizza?
SELECT
	t1.pizza_id,
	t1.pizza_name,
	pt.topping_id,
	pt.topping_name
FROM(SELECT
	 pn.pizza_id AS pizza_id,
	 pn.pizza_name AS pizza_name,
	unnest(string_to_array(toppings, ','))::integer AS toppings_id
FROM pizza_runner.pizza_recipes AS pr
JOIN pizza_runner.pizza_names AS pn
ON pn.pizza_id = pr.pizza_id) AS t1
JOIN pizza_runner.pizza_toppings AS pt
ON pt.topping_id = t1.toppings_id
ORDER BY 1,3;

-- 2. What was the most commonly added extra?
SELECT 
	pt.topping_name AS topping,
	COUNT(*) AS no_of_times
FROM(SELECT unnest(string_to_array(extras, ','))::integer AS extras
FROM pizza_runner.customer_orders
WHERE extras != 'None') AS t1
JOIN pizza_runner.pizza_toppings AS pt
ON t1.extras = pt.topping_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 3. What was the most common exclusion?
SELECT 
	pt.topping_name AS topping,
	COUNT(*) AS no_of_times
FROM(SELECT unnest(string_to_array(exclusions, ','))::integer AS exclusions
FROM pizza_runner.customer_orders
WHERE exclusions != 'None') AS t1
JOIN pizza_runner.pizza_toppings AS pt
ON pt.topping_id = t1.exclusions
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;