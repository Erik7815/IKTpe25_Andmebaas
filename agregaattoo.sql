
select count(CustomerID) as TotalCustomers from SalesLT.Customer 

select COUNT_BIG(*) from SalesLT.SalesOrderHeader

select MAX(CAST(TotalDue as int)) from SalesLT.SalesOrderHeader

select min(CAST(TotalDue as int)) from SalesLT.SalesOrderHeader

select sum(CAST(TotalDue as int)) from SalesLT.SalesOrderHeader

select count(ListPrice) from SalesLT.Product where ListPrice > 100

select max(ListPrice) from SalesLT.Product where ListPrice < 1000

select min(ListPrice) from SalesLT.Product where ListPrice  > 0

select sum(ListPrice) from SalesLT.Product where Color is not null

select count(*) from SalesLT.Customer where YEAR(cast(ModifiedDate as int)) > 2010

select MIN(ModifiedDate) from SalesLT.SalesOrderDetail where YEAR(cast(ModifiedDate as int)) < 2009

select sum(CAST(TotalDue as int)) from SalesLT.SalesOrderHeader group by CustomerID

select COUNT(*) from SalesLT.Customer
join SalesLT.SalesOrderHeader on SalesOrderHeader.SalesOrderID = SalesOrderHeader.SalesOrderID
group by Customer.CustomerID, SalesOrderHeader.SalesOrderID

select COUNT(*) from SalesLT.ProductCategory
join SalesLT.Product on Product.ProductID = Product.ProductID
group by Product.ProductCategoryID

SELECT SUM(TotalDue) FROM SalesLT.SalesOrderHeader 
join SalesLT.Customer on Customer.CustomerID = Customer.CustomerID	
group by SalesOrderHeader.TotalDue
having TotalDue > 10000