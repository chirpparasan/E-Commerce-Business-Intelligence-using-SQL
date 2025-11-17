-- 3.1 What are the top 10 most sold products (by quantity)?
WITH T AS (SELECT ProductName, SUM(Quantity) AS TOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY ProductName
ORDER BY TOTAL_SALES DESC),
  RNKED AS (SELECT *,
DENSE_RANK() OVER(ORDER BY TOTAL_SALES DESC) AS RNKS
FROM T)
SELECT *
FROM RNKED
WHERE RNKS BETWEEN 1 AND 10;

-- 3.2 What are the top 10 most sold products (by revenue)?
WITH T AS (SELECT ProductName, SUM(OD.Quantity*Price) AS TOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY ProductName
ORDER BY TOTAL_SALES DESC),
  RNKED AS (SELECT *,
DENSE_RANK() OVER(ORDER BY TOTAL_SALES DESC) AS RNKS
FROM T)
SELECT *
FROM RNKED
WHERE RNKS BETWEEN 1 AND 10;

-- 3.3 Which products have the highest return rate?
WITH T AS (SELECT p.ProductID, SUM(Quantity) AS TOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID
ORDER BY TOTAL_SALES DESC),
tn AS(
SELECT p.ProductID, SUM(Quantity) AS RETURNTOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
JOIN ORDERS O ON od.OrderID = o.OrderID
WHERE IsReturned = 1
GROUP BY p.ProductID)
SELECT p.productname,ROUND((TOTAL_SALES/RETURNTOTAL_SALES),2) AS return_rate
FROM products p
JOIN t on  p.ProductID = t.ProductID
JOIN tn ON  p.ProductID = tn.ProductID;

-- 3.4.Return Rate by Category
WITH T AS (SELECT p.Category, SUM(Quantity) AS TOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TOTAL_SALES DESC),
tn AS(
SELECT p.Category, SUM(Quantity) AS RETURNTOTAL_SALES
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
JOIN ORDERS O ON od.OrderID = o.OrderID
WHERE IsReturned = 1
GROUP BY p.Category)
SELECT t.Category,ROUND((TOTAL_SALES/RETURNTOTAL_SALES),2) AS return_rate
FROM t
JOIN tn ON t.Category = tn.Category;

-- 3.5 	What is the average price of products per region AVG= TOTAL REVENUE / TOTAL QUANTITY
SELECT DISTINCT ProductName,RegionName,SUM(OD.Quantity*P.Price) / SUM(OD.Quantity) AS AVG_PRICE
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID
GROUP BY ProductName,RegionName
ORDER BY AVG_PRICE DESC;

-- 3.6 What is the sales trend for each product category
SELECT date_format(OrderDate,"%Y-%m") AS PERIODIC,Category,SUM(OD.Quantity*Price) AS REVENUE
FROM orders O 
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON OD.ProductID = P.ProductID
GROUP BY PERIODIC,Category
ORDER BY PERIODIC,Category,REVENUE;