-- Cleaning customer orders table

-- change null and empty rows in the exclusions column to None
UPDATE pizza_runner.customer_orders SET exclusions = 'None'
WHERE exclusions IS NULL OR exclusions = 'null' OR exclusions = '';

-- change null and empty rows in the extras column to None
UPDATE pizza_runner.customer_orders SET extras = 'None'
WHERE extras IS NULL OR extras = 'null' OR extras = '';

-- remove extra spaces in extras and exclusions columns
UPDATE pizza_runner.customer_orders SET extras = REPLACE(extras, ' ', '');
UPDATE pizza_runner.customer_orders SET exclusions = REPLACE(exclusions, ' ', '');

-- Cleaning runner orders table

-- change null and empty rows in the cancellations column to None
UPDATE pizza_runner.runner_orders SET cancellation = 'None'
WHERE cancellation IS NULL or cancellation = 'null' OR cancellation = '';

-- remove white spaces and km from distance column
UPDATE pizza_runner.runner_orders SET distance = TRIM(BOTH ' ' FROM TRIM(BOTH 'km' FROM distance));

-- remove white spaces and any variation of minutes from duration column
UPDATE pizza_runner.runner_orders SET duration = LEFT(duration, 2);

-- change null and empty rows in the distance column to 0 
UPDATE pizza_runner.runner_orders SET distance = '0'
WHERE distance IS NULL OR distance = 'null' OR distance = '';

-- change null and empty rows in the duration column to 0
UPDATE pizza_runner.runner_orders SET duration = '0'
WHERE duration IS NULL OR duration = 'nu' OR duration = '';

-- change null rows in the pickup time column to None
UPDATE pizza_runner.runner_orders SET pickup_time = 'None'
WHERE pickup_time = 'null';

-- Cleaning pizza recipes table

-- remove extra spaces in toppings column
UPDATE pizza_runner.pizza_recipes SET toppings = REPLACE(toppings, ' ', '');