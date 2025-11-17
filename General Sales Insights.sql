-- 1.General Sales Insights
-- 1.1.What is the total revenue generated over the entire period?
-- REVENUE = (QUANTITY * PRICE)
SELECT @REVENUE:=SUM(od.quantity*price) AS TOTAL_REVENUE
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID;

-- 1.2.Revenue Excluding Returned Orders

SELECT @WITH_RETURN:= SUM(OD.Quantity*Price) AS REVENUE_EXCLUDING_RETURNS
FROM orderdetails OD
JOIN products P ON OD.ProductID = P.ProductID
JOIN orders o ON OD.OrderID =O.OrderID
WHERE IsReturned = 0;
-- TO FIND LOSS
SELECT ROUND((@REVENUE -@WITH_RETURN)) AS LOSS_VALUE;
-- LOSS = 708287

-- 1.3.Total Revenue per Year / Month

SELECT YEAR(orderdate) AS years,
       MONTH(orderdate) AS months,
       SUM(od.quantity*price) AS PERIODIC_REVENUE
FROM orders o
JOIN orderdetails od ON OD.OrderID =O.OrderID
JOIN products p ON od.ProductID = p.ProductID
GROUP BY years,months
ORDER BY  years,months;
-- 1.4.Revenue by Product / Category
SELECT ProductName,Category,SUM(OD.Quantity*Price) AS REVENUE_EXCLUDING_RETURNS
FROM orderdetails OD
JOIN products P ON OD.ProductID = P.ProductID
JOIN orders o ON OD.OrderID =O.OrderID
GROUP BY ProductName,Category;

-- 1.5.What is the average order value (AOV) across all orders? TOTAL REVENUE / ORDERS 

  WITH T AS(SELECT o.orderid ,SUM(p.price*quantity) AS AVG_ORDERS
FROM orders O
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON OD.ProductID = P.ProductID
GROUP BY o.OrderID)
SELECT AVG(AVG_ORDERS)/ COUNT(DISTINCT OrderID) AS AVG_ORDERVALUE
FROM T;

-- 1.6.AOV per Year / Month
 SELECT YEAR(OrderDate) AS YEARS,
 MONTH(OrderDate) AS MONTHS,
 AVG(AVG_ORDERS)
 FROM (SELECT o.orderid ,o.OrderDate,SUM(p.price*quantity) AS AVG_ORDERS
FROM orders O
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON OD.ProductID = P.ProductID
GROUP BY o.OrderID) T
GROUP BY YEARS,MONTHS
ORDER BY YEARS,MONTHS;

-- 1.7 What is the average order size by region = SUM OF TOTAL QUANITY
SELECT RegionName,AVG(TOTAL_ORDERS) AS AVG_TOTAL_ORDERS
FROM (SELECT RegionID,SUM(QUANTITY) AS TOTAL_ORDERS
FROM orderdetails OD
JOIN orders O ON OD.OrderID = O.OrderID
JOIN customers C ON O.CustomerID = C.CustomerID
GROUP BY RegionID) AS TD
JOIN regions r ON r.RegionID = TD.RegionID
GROUP BY RegionName
ORDER BY  AVG_TOTAL_ORDERS DESC;





       
     
