select ProductID, Name, ListPrice, Weight from SalesLT.Product where ListPrice > 500 and Weight > 500


select ProductID, Name from SalesLT.Product where Name ='Mountain Bikes' or Name ='Road Bikes' or Name not like 'Women%'



Select Name, ListPrice * 0.85  as DiscountPrice from SalesLT.Product


Select Name, ListPrice * 1.22  as PricewithVAT from SalesLT.Product


Create procedure spTooteOtsimineID
@ProductID int
as begin
select * from SalesLT.Product where @ProductId = ProductID
end

spTooteOtsimineID @ProductId = 706



create Procedure spTootedKategooriast
@ProductCategory int
as begin
select * from SalesLT.Product where @ProductCategory = ProductCategoryID
end
spTootedKategooriast 18




Create table LogiTabel
( 
LogId int,
ProductId int,
ProductName nvarchar(30),
InsertDate nvarchar(50)
)
create trigger trLogiOnInsert on LogiTabel
for insert
as begin
declare @LogId int
select @LogId = LogId from inserted
Print ('New Product with Id = ' + CAST(@LogId as nvarchar(5)) + ' is added at '
+ CAST(getdate() as nvarchar(20)))
end
insert into LogiTabel values (12, 32, 'Bike', '03-06')
drop trigger trCustomerOnInsert

create table KliendiLogi
(
LogId int,
CustomerId int,
LogDate nvarchar(1000)
)
create trigger trCustomerOnInsert on KliendiLogi
for insert
as begin
declare @LogId int
select @LogId = LogId from inserted
insert into KliendiLogi
values ('New Customer with Id = ' + CAST(@LogId as nvarchar(5)) + ' is added at '
+ CAST(getdate() as nvarchar(20)))
end

insert into KliendiLogi values (11, 485, '111')
drop table KliendiLogi