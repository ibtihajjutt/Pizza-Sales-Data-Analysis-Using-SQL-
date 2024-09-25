--QUESTION
--Retrieve the total number of orders placed.


SELECT COUNT(order_id) AS TOTAL_SALES FROM order_details ;


--Calculate the total revenue generated from pizza sales.

SELECT ROUND(sum(order_details.quantity * pizzas.price),2) AS TOTAL_REVENU
FROM order_details
JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id;



--Identify the highest-priced pizza.

SELECT TOP 1 pizza_types.name, ROUND(pizzas.price,3) AS PRICE
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price desc;



--Identify the most common pizza size ordered.
SELECT pizzas.size, COUNT(order_details.order_details_id) AS num_orders
FROM pizzas
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;


--List the top 5 most ordered pizza types along with their quantities.

SELECT TOP 5 pizzas.pizza_type_id , COUNT(order_details.order_details_id)
From pizzas
JOIN order_details
on pizzas.pizza_id = order_details.pizza_id
Group by pizzas.pizza_type_id;


--Intermediate:
--join the necessary tables to find the total quantity of each pizza category ordered.


SELECT TOP 5 pizza_types.name, SUM(CAST(order_details.quantity AS INT)) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC;


--Determine the distribution of orders by hour of the day.


SELECT  DATEPART(hour, time) AS order_hour,  COUNT(order_id) AS num_orders
from orders
GROUP BY DATEPART(hour, time)


--Join relevant tables to find the category-wise distribution of pizzas.

SELECT name AS category_name, COUNT(pizza_id) AS num_pizzas
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY name
ORDER BY num_pizzas DESC;



--Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT AVG(total_quantity) AS average_quantity
FROM (
    SELECT 
        orders.date AS order_date, 
        SUM(CAST(order_details.quantity AS INT)) AS total_quantity
    FROM 
        orders
    JOIN 
        order_details ON orders.order_id = order_details.order_id
    GROUP BY 
        orders.date
) AS QUANT;


--Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name AS NAME, 
    SUM(pizzas.price * order_details.quantity) AS total_revenue
FROM 
    pizza_types
JOIN 
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN 
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    NAME;

--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.
WITH TotalRevenue AS (
    SELECT 
        SUM(p.price * od.quantity) AS total_revenue
    FROM 
        pizzas p
    JOIN 
        order_details od ON p.pizza_id = od.pizza_id
)
SELECT 
    pt.name AS pizza_type,
    SUM(p.price * od.quantity) AS type_revenue,
    (SUM(p.price * od.quantity) / tr.total_revenue) * 100 AS percentage_contribution
FROM 
    pizza_types pt
JOIN 
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
    order_details od ON p.pizza_id = od.pizza_id
JOIN 
    TotalRevenue tr
GROUP BY 
    pt.name, tr.total_revenue
ORDER BY 
    percentage_contribution DESC;



--Analyze the cumulative revenue generated over time.

SELECT order.date,  SUM(order_details.quantity*pizzas.price) AS revenu,
SUM(SUM((order_details.quantity*pizzas.price))OVER(ORDER BY order.date) AS cummulitive_revenu
from
(SELECT orders.date, SUM(order_details.quantity*pizzas.price) AS revenu
FROM order_details
JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.date)

SELECT 
    o.date,
    SUM(od.quantity * p.price) AS revenue,
    SUM(SUM(od.quantity * p.price)) OVER(ORDER BY o.date) AS cumulative_revenue
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    o.date
ORDER BY 
    o.date;

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.