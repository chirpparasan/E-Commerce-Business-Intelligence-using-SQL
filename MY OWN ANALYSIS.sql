-- TO FIND LOWEST REVEUNE MONTH
WITH T AS(SELECT YEAR(orderdate) AS years,
       MONTH(orderdate) AS months,
       SUM(od.quantity*price) AS PERIODIC_REVENUE
FROM orders o
JOIN orderdetails od ON OD.OrderID =O.OrderID
JOIN products p ON od.ProductID = p.ProductID
GROUP BY years,months
ORDER BY  years,months
)
SELECT *
FROM T
WHERE PERIODIC_REVENUE =(SELECT MAX(PERIODIC_REVENUE))
LIMIT 1,1;
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