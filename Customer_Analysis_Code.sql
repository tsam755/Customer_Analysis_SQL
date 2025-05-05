
-------------------------------TASK 2 Part (a) and (b)-----------------------------------------------

------------------------------------------Question 1--------------------------------------------------

---What is the average order value for each customer who made purchases in 2016?
---Include the customer's ID, full name, and average order value (rounded to two decimal places) in the results.
---Order the results appropriately to quickly identify the customers with the highest average spending per order.

----------------------------------Final Answer to Question 1 Part A-------------------------------

SELECT
    c.CustomerID, c.CustomerName, ROUND(AVG(OrderTotal.TotalOrderValue), 2) AS [Average Order Value]
FROM Sales.Orders o
JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
JOIN (SELECT
		o.OrderID, SUM(ol.Quantity * ol.UnitPrice) AS [TotalOrderValue]
		FROM Sales.Orders o
		JOIN Sales.Orderlines ol ON o.OrderID = ol.OrderID
		WHERE YEAR(o.OrderDate) = 2016
		GROUP BY o.OrderID) as OrderTotal 
	ON o.OrderID = OrderTotal.OrderID
GROUP BY
c.CustomerID, c.CustomerName
ORDER BY
[Average Order Value] DESC

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 1 Part B--------------------------------------------------
/*
To answer the question, I first list the requirements:

•	Customer's ID, Full Name, Average Order Value rounded to two decimal places,
•	For each customer who made a purchase in 2016,
•	Order by highest average spending per order.

To understand the flow of information and visualize the columns required to solve the question, I ran exploratory queries. 
These helped me in understanding the relationships between the tables which were required to join the tables together.
The challenge for this question was to visualize the tables and decide which join is required.
Another challenge was to figure out how to aggregate the Order Value by Order ID and then join it with the Customer table to get the average order value by customer.

I solved this problem by breaking down the question into parts.
Running exploratory queries helped in visualizing the data. The queries I ran to understand the tables and the flow of information are listed below:

1.	SELECT* FROM Sales.Customers
•	Running this showed me that all unique customer IDs are listed in this table.

2.	SELECT* FROM Sales.Orders ORDER BY OrderID
•	The query lists all information from the Orders table.
•	Arranging it by OrderID showed me that one customer can have multiple Order IDs whereas an Order ID is unique to each customer.

3.	SELECT* FROM Sales.OrderLines ORDER BY OrderID
•	OrderLines table joins the Orders table using the OrderID. 
•	Running this query showed me that an order is further broken down by ProductLineID. This means that 1 order can have different types of products in it.

Then I list the tables I need to solve the question, this helps me while I am writing my JOINS.

•	Sales.Customers – This table will provide me with Customer ID, Full Name. 
•	Sales.Orders – Used to get the Order ID of each order placed.
•	Sales.Orderlines – Used to get the average order value.

------------------------------------------------Try 1--------------------------------------------------------------

Since all of the customer ID's were required, I decided to use LEFT JOIN to match the customer table with the orders table.

SElECT c.CustomerID , c.CustomerName , COUNT(o.OrderID) AS [ORDER COUNT (CHECK)] , ROUND(AVG(ol.Quantity * ol.UnitPrice), 2) AS [Average Order Value]
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
WHERE o.OrderDate = '2016'
GROUP BY c.CustomerID , c.CustomerName
ORDER BY [Average Order Value] DESC

------------------------------------------------Try 2--------------------------------------------------------------

After running the above query, I realized that the results are not averaging based on the order value rather it is based on the orderlines. My next challenge was to aggregate the total order value based on the order ID and then link it to the customer ID and customer name.
SELECT o.OrderID, SUM(ol.Quantity * ol.UnitPrice) AS [TotalOrderValue]
FROM Sales.Orders o
JOIN Sales.Orderlines ol ON o.OrderID = ol.OrderID
WHERE YEAR (o.OrderDate) = 2016
GROUP BY o.OrderID

This sums order value based on Order ID from the Orders table and the Orderlines table.

------------------------------------------------Try 3--------------------------------------------------------------

Next challenge was to get Customer ID and Customer Name and join it with the table above to get the accurate average order value. 
I used the query from Try 2 in the JOIN clause to join it with Customers Table. This allowed me to pull the Customer Name and Customer ID.
Ordered it descending by the average order value gave me the customer with the highest average order in 2016.

SELECT c.CustomerID, c.CustomerName, 
ROUND(AVG(OrderTotal.TotalOrderValue), 2) AS [Average Order Value]
FROM Sales.Orders o
JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
JOIN (SELECT	o.OrderID, SUM(ol.Quantity * ol.UnitPrice) AS [Total Order Value]
FROM Sales.Orders o
JOIN Sales.Orderlines ol ON o.OrderID = ol.OrderID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY o.OrderID) AS OrderTotal 
ON o.OrderID = OrderTotal.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Average Order Value] DESC

*/

-----------------------------------------Question 2-----------------------------------------------

---Which stock groups have generated the highest total sales between January 1, 2014, and December 31, 2016?
---Include the stock group ID, stock group name, and total sales amount in your results.
---Order the results suitably to identify the top-performing stock groups.

----------------------------------Final Answer to Question 2 Part A-------------------------------

SELECT
sg.StockGroupID , sg.StockGroupName , ROUND(SUM(il.Quantity *il.UnitPrice),2) AS [Total Sales]
FROM Warehouse.StockGroups sg
JOIN
Warehouse.StockItemStockGroups sist ON sist.StockGroupID= sg.StockGroupID 
JOIN
Warehouse.StockItems si ON si.StockItemID = sist.StockItemID
JOIN
Sales.InvoiceLines il ON il.StockItemID = si.StockItemID
JOIN
Sales.Invoices i ON i.InvoiceID = il.InvoiceID
WHERE
i.InvoiceDate BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY
sg.StockGroupID , sg.StockGroupName
ORDER BY
[Total Sales] DESC

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 2 Part B--------------------------------------------------

/*

To answer the question, I first list the requirements:

•	Stock groups with highest sales,
•	Between January 1, 2014, and December 31, 2016,
•	Stock group ID, stock group name, and total sales amount,
•	Order by top-performing groups.

I wrote SELECT statements to pull all information in that table to understand the relationship it has with other tables. 
This helps in identifying the foreign key and the primary key. This also helps in identifying key columns required to answer the question.
The challenge for this question was to find out the tables needed to answer this question. 
I used the help of Dataedo link provided by the professor to move between different tables to understand. The queries I ran to understand the tables and the flow of information are below.

1.	SELECT* FROM Warehouse.StockGroups
•	Key information after running this query was the total stock groups in the dataset.

2.	SELECT* FROM Warehouse.StockItemStockGroups
•	Wanted to see the key that links stock group table and stock item stock groups table.

3.	SELECT* FROM Warehouse.StockItems
•	This table links the Warehouse tables with the sales tables thus it was important to join it.

4.	SELECT* FROM Sales.Invoices
•	This table links with StockItems table directly and has the sales columns required to calculate total sales. 
•	This table also has the stock item ID that is required to reach back to the stock group name.

5.	SELECT* FROM Sales.InvoiceLines
•	This table is require because the question asks us to filter sales between a date.
•	The invoice date is not available in the InvoiceLines table thus it was important to join the Invoices table.

6.	SELECT sg.StockGroupID , sg.StockGroupName FROM Warehouse.StockGroups sg ORDER BY 1
•	I wanted to check what are the total number of Stock groups so that when I get the results I could verify my answer.
 
Then I start with listing the tables I need to solve the question, this allows me to keep track of them when I write my JOINS.

1.	Warehouse.StockGroups
•	This table has the list of Stock Group ID and their Names.

2.	Warehouse.StockItemStockGroups
•	This table links Stock Items with Stock Groups thus was necessary since there is no direct relationship between Stock Groups and Sales tables.

3.	Warehouse.StockItems
•	This table links Warehouse tables with Sales tables.

4.	Sales.Invoices
•	This table has the Invoice Date and is also the common table to join the Sales Lines table.

5.	Sales.InvoiceLines
•	This table has the sales lines which I need to calculate total sales.

------------------------------------------------Try 1--------------------------------------------------------------

I joined the required tables needed but I did a mistake of using the wrong keys to join the StockGroup table with the StockItemStockGroups. 
The right key to join these tables should be StockGroupID.

SELECT sg.StockGroupID , sg.StockGroupName , ROUND(SUM(il.Quantity *il.UnitPrice),2) AS [Total Sales]
FROM Warehouse.StockGroups sg
JOIN Warehouse.StockItemStockGroups sist ON sist.StockItemStockGroupID= sg.StockGroupID 
JOIN Warehouse.StockItems si ON si.StockItemID = sist.StockItemID
JOIN Sales.InvoiceLines il ON il.StockItemID = si.StockItemID
JOIN Sales.Invoices i ON i.InvoiceID = il.InvoiceID
WHERE i.InvoiceDate BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY sg.StockGroupID , sg.StockGroupName
ORDER BY [Total Sales] DESC

------------------------------------------------Try 2--------------------------------------------------------------

This is the final code that I wrote to solve the answer.

SELECT sg.StockGroupID , sg.StockGroupName , ROUND(SUM(il.Quantity *il.UnitPrice),2) AS [Total Sales]
FROM Warehouse.StockGroups sg
JOIN Warehouse.StockItemStockGroups sist ON sist.StockGroupID= sg.StockGroupID 
JOIN Warehouse.StockItems si ON si.StockItemID = sist.StockItemID
JOIN Sales.InvoiceLines il ON il.StockItemID = si.StockItemID
JOIN Sales.Invoices i ON i.InvoiceID = il.InvoiceID
WHERE i.InvoiceDate BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY sg.StockGroupID , sg.StockGroupName
ORDER BY [Total Sales] DESC

*/

-----------------------------------------Question 3-----------------------------------------------

---List all suppliers, displaying the total sales amount for their items (if any),
---order the suppliers by the total sales amount in descending order, 
---ensuring that suppliers with no sales are shown with a total sales amount of zero.

----------------------------------Final Answer to Question 2 Part A-------------------------------

SELECT
s.SupplierID , s.SupplierName , ROUND(COALESCE(SUM(il.Quantity * il.UnitPrice),0),2) AS [Total Sales]
FROM
Purchasing.Suppliers s
LEFT JOIN
Warehouse.StockItems st ON s.SupplierID = st.SupplierID
LEFT JOIN
Sales.InvoiceLines il ON st.StockItemID = il.StockItemID
GROUP BY
s.SupplierID , s.SupplierName
ORDER BY
[Total Sales] DESC

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 3 Part B--------------------------------------------------

/*

To answer the question, I first list the requirements:

•	List of all suppliers,
•	Total Sales Amount (if any),
•	Order by Total Sales Amount (DESC),
•	Suppliers with no sales have a ZERO.

I wrote SELECT statements to pull all information in that table to understand the relationship it has with other tables.
This helps in identifying the foreign key and the primary key. This also helps in identifying key columns required to answer the question.
The challenge for this question was to know which join to use and the tables required to join to get the desired information.
I referred to my lecture notes to find out that to get the list of all the suppliers I need to use LEFT JOIN.
To find out the tables needed to answer this question. I used the help of Dataedo link provided by the professor to move between different tables to understand which tables were needed.
The queries I ran to understand the tables and the flow of information are listed below.

1.	SELECT* FROM Purchasing.Suppliers
•	Running this query gave me two key information. 
•	The total number of suppliers, which I came to know by looking at the total number of SupplierID and the key needed to join this table with the next one.

2.	SELECT* FROM Warehouse.StockItems
•	This table necessary to link sales data with suppliers. StockItems table is the common table to link Purchasing schemas with Sales schemas.

3.	SELECT* FROM Sales.InvoiceLines
•	This table has the required information to calculate total sales. 

Then I start with making a list of all the tables I need to solve the question.

1.	Purchasing.Suppliers
2.	Warehouse.StockItems
3.	Sales.InvoiceLines

------------------------------------------------Try 1--------------------------------------------------------------

This was the first attempt to get the required information. 
LEFT JOIN was used because we needed the list of all suppliers.
This query did not work since this did not give me those suppliers which had no sales. 
Since I knew that the total number of suppliers are 13, discarding the results from this code was easy.
This also made me aware that I used an INNER JOIN to connect StockItems with InvoiceLines, this will not work since I need information of all suppliers, not just of those that have sales.

SELECT s.SupplierID , s.SupplierName , ROUND(SUM(il.Quantity * il.UnitPrice),2) AS [Total Sales]
FROM Purchasing.Suppliers s
LEFT JOIN Warehouse.StockItems st ON s.SupplierID = st.SupplierID
JOIN Sales.InvoiceLines il ON st.StockItemID = il.StockItemID
GROUP BY s.SupplierID , s.SupplierName
 
------------------------------------------------Try 2--------------------------------------------------------------

I changed my INNER JOIN to LEFT JOIN and fixed my aggregate function to give me ZERO where the supplier has no sale value. 

SELECT s.SupplierID , s.SupplierName , ROUND(COALESCE(SUM(il.Quantity * il.UnitPrice),0),2) AS [Total Sales]
FROM Purchasing.Suppliers s
LEFT JOIN Warehouse.StockItems st ON s.SupplierID = st.SupplierID
LEFT JOIN Sales.InvoiceLines il ON st.StockItemID = il.StockItemID
GROUP BY s.SupplierID , s.SupplierName
ORDER BY [Total Sales] DESC

*/

-----------------------------------------Question 4-----------------------------------------------

-----List all delivery methods and usage counts in sales invoices and purchase orders.
-----Return the delivery method ID, delivery method name, and the counts of their usage in both sales and purchasing.

----------------------------------Final Answer to Question 2 Part A-------------------------------

SELECT
dm.DeliveryMethodID , dm.DeliveryMethodName , COUNT(i.DeliveryMethodID) AS [Delivery Method Count - Sales], COUNT(po.DeliveryMethodID) AS [Delivery Method Count - Purchases]
FROM
Application.DeliveryMethods dm
LEFT JOIN
Sales.Invoices i ON dm.DeliveryMethodID = i.DeliveryMethodID
LEFT JOIN
Purchasing.PurchaseOrders po ON dm.DeliveryMethodID = po.DeliveryMethodID
GROUP BY
dm.DeliveryMethodID , dm.DeliveryMethodName

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 4 Part B--------------------------------------------------

/*

To answer this question, I first list the requirements:

•	List all delivery methods,
•	Usage counts in sales invoices and purchase orders,
•	Return the delivery method ID, delivery method name.

I wrote SELECT statements to pull all information in that table to understand the relationship it has with other tables. 
This helps in identifying the foreign key and the primary key. This also helps in identifying key columns required to answer the question. 
The challenge for this question was to know which join to use. 
Reading the list of requirements helped me in figuring out that I will need LEFT JOIN to solve it. 
To find out the tables needed to answer this question. I used the help of Dataedo provided by the professor.
The queries I ran to understand the tables and the flow of the information are below:

1.	SELECT* FROM Application.DeliveryMethods
•	I wanted to know what the total number of delivery methods are.

2.	SELECT* FROM Purchasing.PurchaseOrders
•	This table contains information for the preferred delivery method for purchasing.

3.	SELECT* FROM Sales.Invoices
•	This contains delivery methods for sales.

Then I start solving the question by listing the tables I need.

1.	Application.Deliverymethods
2.	Sales.Invoices
3.	Purchasing.PurchaseOrders

------------------------------------------------Try 1--------------------------------------------------------------

This query counts the number of times a particular delivery method is used in the Sales table. It took out all NULL values. The query only gave 1 result.

SELECT dm.DeliveryMethodID , dm.DeliveryMethodName , COUNT(i.DeliveryMethodID) AS [Delivery Method Count - Sales]
FROM Application.DeliveryMethods dm
LEFT JOIN Sales.Invoices i ON dm.DeliveryMethodID = i.DeliveryMethodID
WHERE i.DeliveryMethodID IS NOT NULL 
GROUP BY dm.DeliveryMethodID , dm.DeliveryMethodName

I wanted to check whether results from the above query was correct or not thus I wrote the following query. It lists the unique delivery methods used for Sales.Invoices. 

SELECT DISTINCT DeliveryMethodID
FROM Sales.Invoices
 
The query below lists the number of unique delivery methods used for the purchase order table. This helped me in combining the two insights and counter checking my answer.

SELECT DISTINCT DeliveryMethodID
FROM Purchasing.PurchaseOrders

------------------------------------------------Try 2--------------------------------------------------------------

This provided me with 2 separate columns where one was counting the unique delivery method ID in sales table and the other was counting from the Purchases table. 
LEFT JOIN was used because I wanted the complete list of delivery method ID's. 
LEFT JOIN was also used because I wanted to see which delivery method is not being used in each of the table. 

SELECT dm.DeliveryMethodID , dm.DeliveryMethodName , COUNT(i.DeliveryMethodID) AS [Delivery Method Count - Sales], COUNT(po.DeliveryMethodID) AS [Delivery Method Count - Purchases]
FROM Application.DeliveryMethods dm
LEFT JOIN Sales.Invoices i ON dm.DeliveryMethodID = i.DeliveryMethodID
LEFT JOIN Purchasing.PurchaseOrders po ON dm.DeliveryMethodID = po.DeliveryMethodID
GROUP BY dm.DeliveryMethodID , dm.DeliveryMethodName

*/

-----------------------------------------Question 5-----------------------------------------------

----Identify which customers purchased the most diverse range of products in 2016, and the total amount they spent.
----Include the number of unique products each customer has bought, 
----and the total amount spent in the results to demonstrate the diversity of products. 
----Order and filter the result set in a suitable manner to find the top 10 high-value customers.

----------------------------------Final Answer to Question 5 Part A-------------------------------

SELECT TOP 10
i.CustomerID , COUNT(DISTINCT(il.StockItemID)) AS [Product Count] , SUM(il.Quantity * il.UnitPrice) AS [Total Sales]
FROM
Sales.InvoiceLines il
JOIN
Sales.Invoices i ON il.InvoiceID = i.InvoiceID
WHERE
YEAR(i.invoiceDate) = 2016
GROUP BY
i.CustomerID
ORDER BY
2 DESC

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 5 Part B--------------------------------------------------
/*

To answer this question, I first list the requirements:

•	Identify which customers,
•	Purchased the most diverse range of products in 2016,
•	Total amount they spent.

I wrote SELECT statements to pull all information in that table to understand the relationship it has with other tables.
This helps in identifying the foreign key and the primary key. This also helps in identifying key columns required to answer the question. 
The challenge for this question was to figure out how to count the number of unique products. Defining 'diverse products' was a challenge. 
To resolve this challenge, I tried to understand the relationship between the sales tables. Looked at customer buying pattern from the Invoices table.
Running different queries to get an idea of the flow of information and to find out the tables needed to answer this question.
I used the help of Dataedo link provided by the professor to move between different tables to understand which tables were needed.
The queries I ran to understand the tables and the flow of the information are below:

1.	SELECT* FROM Sales.invoiceLines
•	This table had the StockItemID, which is a unique identifier for the type of product ordered. 
•	This gave me an idea to count the unique IDs by customer to see what is the count of diverse product range ordered by each customer.
•	This table also has the quantity ordered and the unit price which would give me the total sales value.

2.	SELECT* FROM Sales.invoices
•	This table had the customer information that was required to join with the InvoiceLines table to arrange the diverse product range by CustomerID.

Then I start solving the question by listing the tables I need.

1.	Sales.InvoiceLines
2.	Sales.Invoices

------------------------------------------------Try 1--------------------------------------------------------------

The following query was run to find out the number of orders placed by each customer in 2016.

SELECT i.CustomerID , COUNT(DISTINCT(il.StockItemID)) AS [Number of Orders]
FROM Sales.InvoiceLines il
JOIN Sales.Invoices i ON il.InvoiceID = i.InvoiceID
WHERE YEAR(i.invoiceDate) = 2016
GROUP BY i.CustomerID
ORDER BY [Number of Orders] DESC

------------------------------------------------Try 2--------------------------------------------------------------

The following query is like the above one with the addition of Total Sales column. This does not provide with the top 10 customers.

SELECT i.CustomerID , COUNT(DISTINCT(StockItemID)) AS [Product Count] , SUM(il.Quantity * il.UnitPrice) AS [Total Sales]
FROM Sales.InvoiceLines il
JOIN Sales.Invoices i ON il.InvoiceID = i.InvoiceID
WHERE YEAR(i.invoiceDate) = 2016
GROUP BY i.CustomerID
ORDER BY 2 DESC
 
------------------------------------------------Try 3--------------------------------------------------------------

This is the final query. Top 10 customers who have ordered unique products and their total sales in 2016.

SELECT TOP 10 i.CustomerID , COUNT(DISTINCT(il.StockItemID)) AS [Product Count] , SUM(il.Quantity * il.UnitPrice) AS [Total Sales]
FROM Sales.InvoiceLines il
JOIN Sales.Invoices i ON il.InvoiceID = i.InvoiceID
WHERE YEAR(i.invoiceDate) = 2016
GROUP BY i.CustomerID
ORDER BY 2 DESC

*/

-----------------------------------------Question 6-----------------------------------------------

-----Modify your query from question 5) above to display the details of these purchases for the top 5 high-value customers.
-----Include in your results the customer's ID and full name, the product IDs and names, the number of orders for each product,
-----the total quantity ordered, and the total amount spent on each product.

----------------------------------Final Answer to Question 6 Part A-------------------------------

SELECT 
tc.CustomerID, tc.CustomerName,si.StockItemID,si.StockItemName,COUNT(il.InvoiceID) AS NumberOfOrders,SUM(il.Quantity) AS TotalQuantityOrdered,ROUND(SUM(il.Quantity * il.UnitPrice), 2) AS TotalAmountSpent
FROM 
(SELECT TOP 5
c.CustomerID,
c.CustomerName,
COUNT(DISTINCT il.StockItemID) AS UniqueProductsBought,
ROUND(SUM(il.Quantity * il.UnitPrice), 2) AS TotalAmountSpent
FROM 
Sales.Invoices i
JOIN 
Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
JOIN 
Sales.Customers c ON i.CustomerID = c.CustomerID
JOIN 
Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE 
YEAR(i.InvoiceDate) = 2016
GROUP BY 
c.CustomerID, 
c.CustomerName
ORDER BY 
TotalAmountSpent DESC) AS tc
JOIN 
Sales.Invoices i ON tc.CustomerID = i.CustomerID
JOIN 
Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
JOIN 
Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE 
YEAR(i.InvoiceDate) = 2016
GROUP BY 
tc.CustomerID, 
tc.CustomerName,
si.StockItemID,
si.StockItemName
ORDER BY 
tc.CustomerName ASC, 
TotalAmountSpent DESC;

-------------------------------------------END------------------------------------------------------

---------------------------------------COMMENTS-----------------------------------------------------

---------------------------------Question 6 Part B--------------------------------------------------

/*

To answer this question, I first list the requirements:

•	Display the details of these purchases for the top 5 high-value customers,
•	Customer's ID and full name, the product IDs and names, number of orders for each product,
•	Total quantity ordered, and the total amount spent on each product.
 
Running different queries to get an idea of the flow of information and to find out the tables needed to answer this question. 
I used the help of Dataedo link provided by the professor to move between different tables to understand which tables were needed. 
The queries I ran to understand the tables and the flow of the information are below:

1.	Sales.Invoices
2.	Sales.InvoiceLines
3.	Sales.Customers
4.	Warehouse.StockItems

Next, I brought my query from question 5 and tried to understand what more is required from this question and how can I modify it for the results required.

------------------------------------------------Try 3--------------------------------------------------------------

This is just bringing the above query below and listing the new requirements for the question.
This query will work as a virtual table for the top 5 customers who spent the most in 2016. This is based on their unique purchasing pattern.

SELECT TOP 5 c.CustomerID, c.CustomerName, COUNT(DISTINCT il.StockItemID) AS UniqueProductsBought, ROUND(SUM(il.Quantity * il.UnitPrice), 2) AS TotalAmountSpent
FROM Sales.Invoices i
JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
JOIN Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE YEAR(i.InvoiceDate) = 2016
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalAmountSpent DESC
 
------------------------------------------------Try 3--------------------------------------------------------------

Next, I had to JOIN my virtual table with Invoices table to pull in their invoices and join the Invoices table with InvoiceLines to pull in individual product information
and lastly joining the StockItems table to pull in each product details like name of the product. 

SELECT 
tc.CustomerID, tc.CustomerName, si.StockItemID, si.StockItemName, COUNT(il.InvoiceID) AS NumberOfOrders,SUM(il.Quantity) AS TotalQuantityOrdered, ROUND(SUM(il.Quantity * il.UnitPrice), 2) AS TotalAmountSpent
FROM (SELECT TOP 5
c.CustomerID, c.CustomerName,
COUNT(DISTINCT il.StockItemID) AS UniqueProductsBought,
ROUND(SUM(il.Quantity * il.UnitPrice), 2) AS TotalAmountSpent
FROM Sales.Invoices i
JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
JOIN Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE YEAR(i.InvoiceDate) = 2016
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalAmountSpent DESC) AS tc
JOIN Sales.Invoices i ON tc.CustomerID = i.CustomerID
JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
JOIN Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE YEAR(i.InvoiceDate) = 2016
GROUP BY tc.CustomerID, tc.CustomerName, si.StockItemID, si.StockItemName
ORDER BY tc.CustomerName ASC, TotalAmountSpent DESC

*/

-------------------------------TASK 2 Part (c)-----------------------------------------------

--------------------------------EDA QUESTION 1----------------------------------------
/*
What orders take more than 2 days from the date when the order was received to the date when it was invoiced to the customer.
Include Order ID, Description of the product, Quantity Ordered, Invoice Date, Order Date and the difference between the two dates.
*/

----------------------------------Final Answer to Question 1-------------------------------

SELECT
i.OrderID,
ol.Description,
ol.Quantity,
i.InvoiceDate , o.OrderDate ,
DATEDIFF (DAY , O.OrderDate, i.InvoiceDate) AS [Days From receiving an Order to Invoicing]
FROM
Sales.InvoiceLines il
JOIN
Sales.Invoices i ON il.InvoiceID = i.InvoiceID
JOIN
Sales.Orders o ON i.OrderID = o.OrderID
JOIN
Sales.OrderLines ol ON o.OrderID = ol.OrderID
JOIN
Warehouse.StockItems si ON il.StockItemID = si.StockItemID
WHERE
DATEDIFF (DAY , O.OrderDate, i.InvoiceDate) > 2
AND
YEAR(o.OrderDate) = 2015
GROUP BY
i.InvoiceDate , o.OrderDate ,i.OrderID , ol.Description ,ol.Quantity
ORDER BY
[Days From receiving an Order to Invoicing] DESC

-------------------------------------------END------------------------------------------------------

----------------------------------------EDA QUESTION 2----------------------------------------
/*
List products that have not been ordered in the past 2 years. Include Product ID and Description of each product.
*/

--------------------------------------Final Answer to Question 2 ------------------------------

SELECT
q.StockItemID , q.StockItemName , [QuantityOrderedin2014] ,[QuantityOrderedin2015]
FROM
(SELECT
pol.StockItemID, si.StockItemName, 
SUM(CASE WHEN po.OrderDate BETWEEN '2013-01-01' AND '2013-12-31' THEN pol.OrderedOuters ELSE 0 END) AS [QuantityOrderedin2013],
SUM(CASE WHEN po.OrderDate BETWEEN '2014-01-01' AND '2014-12-31' THEN pol.OrderedOuters ELSE 0 END) AS [QuantityOrderedin2014],
SUM(CASE WHEN po.OrderDate BETWEEN '2015-01-01' AND '2015-12-31' THEN pol.OrderedOuters ELSE 0 END) AS [QuantityOrderedin2015]
FROM
Purchasing.PurchaseOrderLines pol
JOIN
Purchasing.PurchaseOrders po ON pol.PurchaseOrderID = po.PurchaseOrderID
JOIN
Warehouse.StockItems si ON pol.StockItemID = si.StockItemID
GROUP BY
pol.StockItemID , si.StockItemName ) AS [q]
WHERE
q.QuantityOrderedin2014 = 0 OR
q.QuantityOrderedin2015 = 0
ORDER BY
q.StockItemID

--------------------------------------------END--------------------------------------------------

----------------------------------------EDA QUESTION 3----------------------------------------
/*
How have sales and quantity sold changed between 2013 and 2015 by continent.
*/

--------------------------------------Final Answer to Question 3 ------------------------------

SELECT
c.Continent ,

(SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2014-01-01' AND '2014-12-31'
	THEN il.Quantity
	ELSE 0
	END) 
	-
SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2013-01-01' AND '2013-12-31'
	THEN il.Quantity
	ELSE 0
	END)) AS [Change in Quantity Sold 2013/2014] ,

(SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2015-01-01' AND '2015-12-31'
	THEN il.Quantity
	ELSE 0
	END)
	-
SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2014-01-01' AND '2014-12-31'
	THEN il.Quantity
	ELSE 0
	END)) AS [Change in Quantity Sold 2014/2015],

(SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2014-01-01' AND '2014-12-31' 
	THEN (il.Quantity * il.UnitPrice) 
	ELSE 0
	END)
	-
	SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2013-01-01' AND '2013-12-31' 
	THEN (il.Quantity * il.UnitPrice) 
	ELSE 0
	END)) AS [Change in Sales 2013/2014],

(SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2015-01-01' AND '2015-12-31' 
	THEN (il.Quantity * il.UnitPrice) 
	ELSE 0
	END)
	-
SUM(CASE 
	WHEN i.InvoiceDate BETWEEN '2014-01-01' AND '2014-12-31' 
	THEN (il.Quantity * il.UnitPrice) 
	ELSE 0
	END)) AS [Change in Sales 2014/2015]
FROM
Application.Countries c
LEFT JOIN
Application.People p ON c.LastEditedBy = p.PersonID
JOIN
Application.DeliveryMethods dm ON p.PersonID = dm.LastEditedBy
JOIN
Sales.Customers sc On dm.DeliveryMethodID = sc.DeliveryMethodID
JOIN
Sales.Invoices i ON sc.CustomerID = i.CustomerID
JOIN
Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY
c.Continent

--------------------------------------------END--------------------------------------------------

----------------------------------------EDA QUESTION 4----------------------------------------
/*
Which product category had the highest increase in profit earned in between 2014 and 2015?
*/

--------------------------------------Final Answer to Question 4 ------------------------------

SELECT
sg.StockGroupName ,
---AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN sih.LastCostPrice ELSE 0 END) AS [Average Cost Price - 2014] ,
---AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.UnitPrice ELSE 0 END) AS [Average Sales Price - 2014] ,

(AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN sih.LastCostPrice ELSE 0 END))) AS [Profit Margin 2014],

---AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN sih.LastCostPrice ELSE 0 END) AS [Average Cost Price - 2015] ,
---AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.UnitPrice ELSE 0 END) AS [Average Sales Price - 2015],

(AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN sih.LastCostPrice ELSE 0 END))) AS [Profit Margin 2015],

SUM (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.Quantity ELSE 0 END) AS [Total Quantity Sold - 2014] ,
SUM (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.Quantity ELSE 0 END) AS [Total Quantity Sold - 2015] , 

((AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN sih.LastCostPrice ELSE 0 END))) 
* (SUM (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.Quantity ELSE 0 END))) AS [Profit Earned 2014] ,

((AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN sih.LastCostPrice ELSE 0 END))) 
* (SUM (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.Quantity ELSE 0 END))) AS [Profit Earned 2015],

((((AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN sih.LastCostPrice ELSE 0 END))) 
* (SUM (CASE WHEN YEAR(i.InvoiceDate) = 2015 THEN il.Quantity ELSE 0 END))) - ((AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN sih.LastCostPrice ELSE 0 END))) 
* (SUM (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.Quantity ELSE 0 END)))) / ((AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.UnitPrice ELSE 0 END) - (AVG (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN sih.LastCostPrice ELSE 0 END))) 
* (SUM (CASE WHEN YEAR(i.InvoiceDate) = 2014 THEN il.Quantity ELSE 0 END)))) * 100 AS [Percentage Growth]
FROM
Warehouse.StockItemHoldings sih
JOIN
Warehouse.StockItems si ON sih.StockItemID = si.StockItemID
JOIN
Warehouse.StockItemStockGroups sisg ON si.StockItemID = sisg.StockItemID
JOIN
Warehouse.StockGroups  sg ON sisg.StockGroupID = sg.StockGroupID
JOIN
Sales.InvoiceLines il ON si.StockItemID = il.StockItemID
JOIN
Sales.Invoices i ON il.InvoiceID = i.InvoiceID
GROUP BY
StockGroupName
ORDER BY
[Percentage Growth] DESC

-------------------------------------------END-----------------------------------------------------