-- 4.1 What are the monthly sales trends over the past year
SELECT YEAR(OrderDate) AS YEARS,
	   MONTH(OrderDate) AS MONTHS, 
		SUM(OD.Quantity*Price) AS REVENUE
FROM orders O 
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON OD.ProductID = P.ProductID
WHERE OrderDate>=current_date() - interval 12 month
GROUP BY YEARS,MONTHS
ORDER BY YEARS,MONTHS;

-- 4.2 How does the average order value (AOV) change by month or week?
SELECT date_format(OrderDate,"%Y-%m") AS DAYS ,SUM(p.price*quantity) / COUNT(DISTINCT OD.OrderID) AS AVG_ORDERVALUE 
FROM orders O
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON OD.ProductID = P.ProductID
GROUP BY DAYS;

-- 5 Regional Insights
-- 5.1 Which regions have the highest order volume and which have the lowest
-- HIGHEST = 
WITH T AS (SELECT RegionName,COUNT(O.OrderID) AS TOTAL_ORDERS_RECIVED
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID
GROUP BY RegionName
ORDER BY TOTAL_ORDERS_RECIVED)
SELECT *, CASE
WHEN TOTAL_ORDERS_RECIVED < 150 THEN "LOW"
WHEN TOTAL_ORDERS_RECIVED BETWEEN 151 AND 200 THEN "MEDIUM"
ELSE "HIGH"
END ORDER_SEGEMENT
FROM T;

-- 5.2 What is the revenue per region and how does it compare across different regions
WITH T AS(SELECT SUM(od.quantity*price) AS REVENUE, RegionName
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID
GROUP BY RegionName
ORDER BY REVENUE),
T2 AS(SELECT RegionName,COUNT(O.OrderID) AS TOTAL_ORDERS_RECIVED
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID
GROUP BY RegionName
ORDER BY TOTAL_ORDERS_RECIVED)
SELECT T.RegionName,T2.TOTAL_ORDERS_RECIVED,T.REVENUE
FROM T2
JOIN T ON T2.RegionName = T.RegionName
ORDER BY TOTAL_ORDERS_RECIVED DESC;

-- 6 Return & Refund Insights
-- 6.1 What is the overall return rate by product category
SELECT Category,
		ROUND(SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END) / COUNT(O.OrderID),2)AS RETURN_RATE 
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID    
GROUP BY Category
ORDER BY RETURN_RATE;

-- 6.2 What is the overall return rate by region
SELECT RegionName,
		ROUND(SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END) / COUNT(O.OrderID),2)AS RETURN_RATE 
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID    
GROUP BY RegionName
ORDER BY RETURN_RATE DESC;

-- 6.3 Which customers are making frequent returns
SELECT CustomerName,COUNT(O.OrderID) AS ORDERS_RETURNED
FROM products P
JOIN orderdetails OD ON OD.ProductID = P.ProductID
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON C.CustomerID= O.CustomerID
JOIN regions R ON C.RegionID = R.RegionID
WHERE IsReturned = 1    
GROUP BY CustomerName
ORDER BY ORDERS_RETURNED DESC;
