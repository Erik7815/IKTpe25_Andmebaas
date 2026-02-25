--teeme andmebaasi e db
create database IKT25tar


use IKT25tar

--andmebaasi kustutamine
drop database IKT25tar

create database IKT25tar
--teeme tabeli
create table Gender
(
--Meil on muutuja Id, mis on täisarv andmetüüp,
--kui sisestad andmed, siis see peab veerg olema täidetud
--tegemist on primaarvõtmega
Id int not null primary key,
--veeru nimi on Gender, 10 tähemärki on max pikkus
--andmed peavad olema sisestatud e ei tohi olla tühi
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
--* tähendab näita kõike seal sees olevat infot
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

--näen tabelis olevat infot 
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sistenaud Genderid alla
--väärtust, siis automaatslet sisestab sellele reale väärtuse 3
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

--soovin kustutada ühe rea
delete from Person
where Id = 8

--lisame uue veeru city nvarchar(50)
alter table Person 
add City nvarchar(50)
select * from Person where City = 'Gotham City'
--kõik kes ei ela gothamis
select * from Person where City != 'Gotham City'
--Vrjänt nr.2 kõik kes ei ela gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi 
--valime 151,35,25
select * from Person where Age in (151, 25, 35);
select * from Person where Age = 150 or Age = 35 or Age = 26

--soovin näha inimesi vahemikkus 22 kuni 41
select * from person where Age > 22 and Age < 41

--wildcard e näitab kõik g tähega linnad
select * from Person where City like 'g%';
--otsib emailid @ märgiga
select * from Person where Email like '%@%'

--tahan näha kellel on emailis ees ja peale @ märki üks täht
select * from Person where Email like '%@_._com%'

--kõik kelle nimes ei ole esimene täht W, A, S
select * from Person where Name like '[^WAS]%'

--kõik kes elavad gothamis ja new yorkis
select * from Person where (City = 'Gotham city' or City = 'New York')

--kõik kes elavad gothamis ja new yorkis ning peavad olema vanemad kui 29
select * from Person where (City = 'Gotham city' or City = 'New York') and Age > 29

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks name veeru 
select * from Person order by Name

--võtab kolm esimest rida person tabelis
select top 3 * from Person

--kolm esimest aga tabeli järjestus on age ja siis Name
select top 3 Age, Name from Person
--näita esimesed 50% tabelist

select top 50 PERCENT * from Person

--järjestab vanuse järgi isikud
select * from Person order by cast(Age as int) desc
--muudab age muutuja int-ks ja näitab vanuselises järjestuses

--kõikide isikut koondvanus e liidab kõik kokku
select SUM(cast(age as int)) from Person

--kõige noorem isik tuleb leida üles
select min(cast(age as int)) from Person

--kõige vanem isisk
select max(cast(age as int)) from Person

--muudame age muutuja int peale
--näeme konkreetsete linnades olevates isikute koondavust
select city, SUM(age) as totalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table person
alter column name nvarchar(25)

--kuvab esimeses reas välja toodud järjestusesja kuvab Age-i
--TotalAge-ka
--järjestab city-s olevate nimede järgi ja siis GenderID järgi
--kasutada group by-d ja order by-d
select city, GenderId, SUM(age) as TotalAge from Person group by City, GenderId
order by City

--näitab et mitu rida andmeid on selles tabelis
SELECT COUNT(*)FROM Person 
-- näitab tuemust mitu inimest on GenderId väärtusega 2
--arvutab vanuse kokku selles linnas
select GenderId, city, SUM(age) as totalage, COUNT(id) as [total person(s)]
from Person where GenderId = '2'
group by GenderId, City

--näitab ära inimeste koondvanuse mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
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

--arvutab kõikide palgad kokku employees tabelis
select SUM(cast(salary as int)) from Employees

--kõige väiksema palga saaja
select min(cast(salary as int)) from Employees

--näitab veerge location ja palka. Palga veerg kuvatakse totalsalary-ks
--teha left join department tabeliga
--grupitab locationiga
select Location, SUM(cast(salary as int)) as totalsalary from Employees
left join Department
on Employees.Department = Department
group by Location