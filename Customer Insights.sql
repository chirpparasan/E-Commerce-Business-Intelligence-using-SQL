-- 2.1 Who are the top 10 customers by total revenue spent
SELECT CustomerName,SUM(od.quantity*price) AS TOTAL_REVENUE
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN orders o ON od.OrderID = o.OrderID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY CustomerName 
ORDER BY TOTAL_REVENUE DESC
LIMIT 10;

-- 2.2 What is the repeat customer rate >1 ORDERS

SELECT ROUND(COUNT(DISTINCT CASE WHEN ORDERS_C > 1 THEN CustomerID END) / COUNT( DISTINCT CustomerID),2) AS REPEATED_ORDERS
		FROM (SELECT CustomerID,COUNT(OrderID) AS ORDERS_C
FROM orders
GROUP BY CustomerID) AS T;

-- 2.4 Customer Segment (based on total spend)
-- •Platinum: Total Spend > 1500
-- •Gold: 1000–1500
-- •Silver: 500–999
-- •Bronze: < 500
 WITH T AS (SELECT CustomerName,SUM(od.quantity*price) AS TOTAL_REVENUE
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN orders o ON od.OrderID = o.OrderID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY CustomerName 
ORDER BY TOTAL_REVENUE DESC)
SELECT *, CASE
WHEN TOTAL_REVENUE < 500 THEN "BRONZE"
WHEN TOTAL_REVENUE BETWEEN 500 AND 999 THEN "SILVER"
WHEN TOTAL_REVENUE BETWEEN 1000 AND 1500 THEN "BRONZE"
ELSE "PLATINUM"
END CUSTOMER_SEGEMENT
FROM T;

-- 2.5.What is the customer lifetime value (CLV)? = TOTAL REVENUE BY PER CUSTOMER
SELECT CustomerName,SUM(od.quantity*price) AS CUSTOMER_LIFETIME_SPEND
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN orders o ON od.OrderID = o.OrderID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY CustomerName 
ORDER BY CUSTOMER_LIFETIME_SPEND DESC