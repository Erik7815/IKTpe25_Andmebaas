--teeme andmebaasi e db
create database IKT25tar


use IKT25tar

--andmebaasi kustutamine
drop database IKT25tar

create database IKT25tar
--teeme tabeli
create table Gender
(
--Meil on muutuja Id, mis on t‰isarv andmet¸¸p,
--kui sisestad andmed, siis see peab veerg olema t‰idetud
--tegemist on primaarvıtmega
Id int not null primary key,
--veeru nimi on Gender, 10 t‰hem‰rki on max pikkus
--andmed peavad olema sisestatud e ei tohi olla t¸hi
Gender nvarchar(10) not null
)

--andmete sisestamine 
--proovige ise teha
--id 1, Gender Male
--Id 2, Gender Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu 
--* t‰hendab n‰ita kıike seal sees olevat infot
select * from Gender

--teeme tabeli nimega person
--veeru nimed: Id int not null primary key, 
--Name nvarchar (30)
--Email nvarchar (30)
--gender int 
create table Person 
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
Age nvarchar(10),
GenderId int
)
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'aquaman', 'a@a.com', 2),
(5, 'catwoman', 'c@c.com', 1),
(6, 'antman', 'ant"ant.com', 2),
(8, null, null, 2)

--n‰en tabelis olevat infot 
select * from Person

--vıırvıtme ¸henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sistenaud Genderid alla
--v‰‰rtust, siis automaatslet sisestab sellele reale v‰‰rtuse 3
--e unknown
alter table Person 
add constraint DF_Person_GenderId
default 3 for GenderId

Insert into Gender (Id, Gender)
values (3, 'unknown')

insert into Person (Id, Name, Email, GenderId)
VALUES (7, 'Black panther', 'b@b.com', null)

insert into Person (Id, Name, Email)
VALUES (9, 'Spiderman', 'spider@man.com')

select * from Person
--piirangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId
--kuida lisada veergu tabelile Person
--veeru nimi on Age nvarchar(10)
alter table Person 
add Age nvarchar(10) 

alter table person
add constraint CK_Person_Age check (Age > 0 and Age <155)

--kuidas uuendada andmeid 
update Person
Set Age = 25
where Id = 2

--soovin kustutada ¸he rea
delete from Person
where Id = 8

--lisame uue veeru city nvarchar(50)
alter table Person 
add City nvarchar(50)
select * from Person where City = 'Gotham City'
--kıik kes ei ela gothamis
select * from Person where City != 'Gotham City'
--Vrj‰nt nr.2 kıik kes ei ela gothamis
select * from Person where City <> 'Gotham'

--n‰itab teatud vanusega inimesi 
--valime 151,35,25
select * from Person where Age in (151, 25, 35);
select * from Person where Age = 150 or Age = 35 or Age = 26

--soovin n‰ha inimesi vahemikkus 22 kuni 41
select * from person where Age > 22 and Age < 41

--wildcard e n‰itab kıik g t‰hega linnad
select * from Person where City like 'g%';
--otsib emailid @ m‰rgiga
select * from Person where Email like '%@%'

--tahan n‰ha kellel on emailis ees ja peale @ m‰rki ¸ks t‰ht
select * from Person where Email like '%@_._com%'

--kıik kelle nimes ei ole esimene t‰ht W, A, S
select * from Person where Name like '[^WAS]%'

--kıik kes elavad gothamis ja new yorkis
select * from Person where (City = 'Gotham city' or City = 'New York')

--kıik kes elavad gothamis ja new yorkis ning peavad olema vanemad kui 29
select * from Person where (City = 'Gotham city' or City = 'New York') and Age > 29

--kuvab t‰hestikulises j‰rjekorras inimesi ja vıtab aluseks name veeru 
select * from Person order by Name

--vıtab kolm esimest rida person tabelis
select top 3 * from Person

--kolm esimest aga tabeli j‰rjestus on age ja siis Name
select top 3 Age, Name from Person
--n‰ita esimesed 50% tabelist

select top 50 PERCENT * from Person

--j‰rjestab vanuse j‰rgi isikud
select * from Person order by cast(Age as int) desc
--muudab age muutuja int-ks ja n‰itab vanuselises j‰rjestuses

--kıikide isikut koondvanus e liidab kıik kokku
select SUM(cast(age as int)) from Person

--kıige noorem isik tuleb leida ¸les
select min(cast(age as int)) from Person

--kıige vanem isisk
select max(cast(age as int)) from Person

--muudame age muutuja int peale
--n‰eme konkreetsete linnades olevates isikute koondavust
select city, SUM(age) as totalAge from Person group by City

--kuidas saab koodiga muuta andmet¸¸pi ja selle pikkust
alter table person
alter column name nvarchar(25)

--kuvab esimeses reas v‰lja toodud j‰rjestusesja kuvab Age-i
--TotalAge-ka
--j‰rjestab city-s olevate nimede j‰rgi ja siis GenderID j‰rgi
--kasutada group by-d ja order by-d
select city, GenderId, SUM(age) as TotalAge from Person group by City, GenderId
order by City

--n‰itab et mitu rida andmeid on selles tabelis
SELECT COUNT(*)FROM Person 
-- n‰itab tuemust mitu inimest on GenderId v‰‰rtusega 2
--arvutab vanuse kokku selles linnas
select GenderId, city, SUM(age) as totalage, COUNT(id) as [total person(s)]
from Person where GenderId = '2'
group by GenderId, City

--n‰itab ‰ra inimeste koondvanuse mis on ¸le 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ‰ra
select GenderId, city, SUM(age) as totalage, COUNT(id) as [total person(s)]
from Person where GenderId = '2'
group by GenderId, City having SUM(age) > 41

--loome tabelid Employees ja Depatment
create table Department 
(
id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees 
(
id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
Department int
)
insert into Employees (id, Name, Gender, Salary, Department)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, Null),
(10, 'Russel', 'Male', 8800, null)

insert into Department (id, DepartmentName,  Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christine'),
(4, 'Other department', 'Sydney', 'Cindrella')
select * from Department
select * from Employees

select Name, Gender, Salary, Department
from Employees
left join Department
on Employees.Department = Department

--arvutab kıikide palgad kokku employees tabelis
select SUM(cast(salary as int)) from Employees

--kıige v‰iksema palga saaja
select min(cast(salary as int)) from Employees

--n‰itab veerge location ja palka. Palga veerg kuvatakse totalsalary-ks
--teha left join department tabeliga
--grupitab locationiga
select Location, SUM(cast(salary as int)) as totalsalary from Employees
left join Department
on Employees.Department = Department
group by Location

select SUM(cast(salary as int)) from employees --arvutab kıigi palga kokku

--lisame veeru City ja pikkus on 30
alter table employees 
add City nvarchar(30) 

select City, Gender, SUM(cast(Salary as int )) as TotalSalary from Employees
group by City, Gender

--peaagu sama p‰ring aga linnad on t‰hestikulises j‰rjestuses
select City, Gender, SUM(cast(Salary as int )) as TotalSalary from Employees
group by City, Gender
order by City asc

--on vaja teada, et mitu inimest on nimekirjas
select COUNT(*) from Employees

--mitu tˆˆtajat on soo ja linna kaupa tˆˆtamas
select City, Gender, SUM(cast(salary as int)) as totalsalary,
COUNT (id) as [Total employees]
from Employees
group by Gender,City

--kuvab kas naised vıi mehed linnade kaupa
--kasutage where
select City, Gender, SUM(cast(salary as int)) as totalsalary,
COUNT (id) as [Total employees]
from Employees
where Gender = 'Male'
group by Gender,City

--sama tulemus nagu eelmine kord aga kasutage having
select City, Gender, SUM(cast(salary as int)) as totalsalary,
COUNT (id) as [Total employees]
from Employees
where Gender = 'Male'
group by Gender,City
having city = 'London';

--kıik kes teenivad rohkem kui 4000 
select City, Gender, SUM(cast(salary as int)) as totalsalary,
COUNT (id) as [Total employees]
from Employees
where Gender = 'Male'
group by Gender,City
having sum(cast(salary as int)) > 4000;

--loome tabeli milles hakatakse automaatslet numerdama Id-d
create table test1
(
id int identity(1,1),
value nvarchar(20)
)
insert into test1 values('X')
select * from test1

--kustutame veeru nimega city employee tabelist 
alter table employees drop column city

--inner join
--kuvab neid kellel on Department all olemas v‰‰rtus
--mitte katuvad read eemaldatakse ja sellep‰rast ei n‰idata
--Jamesi ja Russelit tabelis kuna 
--neil on departmentId null
select name, Gender, Salary, DepartmentName 
from Employees
inner join Department
on Employees.Department = Department.Id

--left join
select name, Gender, Salary, DepartmentName 
from Employees
left join Department
on Employees.Department = Department.Id
--uurige mis on left join
--n‰itab andmeid kus vasakpoolses tabelis isegi siis kui seal puudub 
--mınes reas v‰‰rtus

--right join
select name, Gender, Salary, DepartmentName 
from Employees
right join Department
on Employees.Department = Department.Id
--right join n‰itab paremas (department) tabelis olevaid v‰‰rtuseid 
--mis ei ¸hti (employees vasaku tabeliga 
--outer join
select name, Gender, Salary, DepartmentName 
from Employees
full outer join Department
on Employees.Department = Department.Id
--mılema tabeli read kuvab

--teha cross join 
--teha left join kus Employee tabelist DepartmentId on null
select name, Gender, Salary, DepartmentName 
from Employees
cross join Department
where Employees.Department = Department.Id
--korrutab kıik omavahel l‰bi

select name, Gender, Salary, DepartmentName 
from Employees
left join Department
on Employees.Department = Department.id
where Department.Id is null
--n‰itab ainult neid kellel on vasakus tabelis(employee)
--departmentId mull

select name, Gender, Salary, DepartmentName 
from Employees
right join Department
on Employees.Department = Department.id
where Department.Id is null
--n‰itab ainult paremas tabelis olevatrida
--mis ei kattu Employees-ga

--full join 
--mılema tabeli mitte-kattuvate v‰‰rtustega read kuvab v‰lja
select name, Gender, Salary, DepartmentName 
from Employees
full join Department
on Employees.Department = Department.id
where employees.Department is null
--teete AdventureworksLT2019 andmebaasile join p‰ringud
--inner join, left join, right join, cross join ja full join
--tabeleid sellesse andmebaasi ei tohi teha
select p.Name as Productname, pc.Name as CategoryName
from SalesLT.Product p 
cross join SalesLT.ProductCategory pc
select * from SalesLT.Product 

select p.Name as Productname, pc.Name as CategoryName
from SalesLT.Product p 
right join SalesLT.ProductCategory pc
on P.productCategoryID = pc.productcategoryID 

select p.Name as Productname, pc.Name as CategoryName
from SalesLT.Product p 
left join SalesLT.ProductCategory pc
on P.productCategoryID = pc.productcategoryID 

select p.Name as Productname, pc.Name as CategoryName
from SalesLT.Product p 
cross join SalesLT.ProductCategory pc
