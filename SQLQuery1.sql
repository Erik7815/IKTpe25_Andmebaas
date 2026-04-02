--17.02.2026
--tund nr 1

-- teeme andmebaasi e db
create database IKT25tar

--andmebaasi valimine
use IKT25tar

--andmebaasi kustutamine koodiga
--otsida kood ülesse
drop database IKT25tar

--teeme uuesti andmebaasi IKT25tar
create database IKT25tar

--teeme tabeli
create table Gender
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad andmed, 
--siis see veerg peab olema täidetud,
--tegemist on primaarvõtmega
Id int not null primary key,
--veeru nimi on Gender,
--10 tähemärki on max pikkus,
--andmed peavad olema sisestatud e 
--ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
--proovige ise teha
-- Id = 1, Gender = Male
-- Id = 2, Gender = Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--veeru nimed: Id int not null primary key,
-- Name nvarchar (30)
-- Email nvarchar (30)
--GenderId int
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--18.02.2026
--tund nr 2

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--näen tabelis olevat infot
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

-- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla 
-- väärtust, siis automaatselt sisestab sellele reale väärtuse 3
-- e unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email, GenderId)
values (7, 'Black Panther', 'b@b.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@man.com')

select * from Person

--piirnagu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--kuidas lisada veergu tabelile Person
--veeru nimi on Age nvarchar(10)
alter table Person
add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

-- kuidas uuendada andemeid
update Person
set Age = 159
where Id = 7

select * from Person

--soovin kustutada ühe rea
-- kuidas seda teha????
delete from Person where Id = 8

select * from Person

--lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
-- variant nr 2. K]ik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi
-- valime 151, 35, 26
select * from Person where Age in (151, 35, 26)
select * from Person where Age = 151 or Age = 35 or Age = 26

-- soovin näha inimesi vahemikus 22 kuni 41
select * from Person where Age between 22 and 41

--wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
--otsib emailid @-märgiga
select * from Person where Email like '%@%'

--tahan näha, kellel on emailis ees ja peale @-märki üks täht
select * from Person where Email like '_@_.com'

--kõik, kelle nimes ei ole esimene täht W, A, S
select * from Person where Name like '[^WAS]%'

--k]ik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning peavad olema 
-- vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks 
-- Name veeru
select * from Person
select * from Person order by Name

--võtab kolm esimest rida Person tabelist
select top 3 * from Person

--tund 3
--25.02.2026
--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--näita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja näitab vanuselises järjestuses
-- cast abil saab andmetüüpi muuta
select * from Person order by cast(Age as int) desc

-- kõikide isikute koondvanus e liidab kõik kokku
select sum(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i 
-- TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis Genderid järgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--näitab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--näitab tulemust, et mitu inimest on Genderid väärtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, Department)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

---
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab k]ikide palgad kokku Employees tabelist
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku
-- kõige väiksema palga saaja
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location


-- 4 tund
-- 03.03.26

select * from Employees
select sum(cast(Salary as int)) from Employees  --arvutab kõikide palgad kokku

-- lisame veeru City ja pikkus on 30
-- Employees tabelisse lisada
alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender

--peaaegu sama päring, aga linnad on tähestikulises järjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees 
group by City, Gender 
order by City

select * from Employees
--on vaja teada, et mitu inimest on nimekirjas selles tabelis
select count (*) from Employees

--mitu töötajat on soo ja linna kaupa töötamas
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 

--kuvab kas naised või mehed linnade kaupa
--kasutage where
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
where Gender = 'Female'
group by Gender, City 

--sama tulemuse nagu eelmine kord, aga kasutage: having
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 
having Gender = 'Female'

--kõik, kes teenivad rohkem, kui 4000
select * from Employees where sum(cast(Salary as int)) > 4000

--teeme variandi, kus saame tulemuse
select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1


--5 tund
--04.03.26

--kustutame veeru nimega City Employee tabelist
alter table Employees
drop column City


--inner join 
--kuvab neid, kellel on DepartmentName all olemas väärtus
--mitte kattuvad read eemaldatakse tulemusest
-- ja sellepärast ei näidata Jamesi ja Russelit tabelis
--kuna neil on DepartmentId NULL
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

-- left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department  --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--näitab andmeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub
--võõrvõtme reas väärtus

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department  --võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid,
--mis ei ühti vasaku (Employees) tabeliga

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mõlema tabeli read kuvab

--teha cross join
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department
--korrutab kõik omavahel läbi

--teha left join, kus Employees tabelist DepartmentId on null
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--teine variant ja sama tulemus
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null
-- näitab ainult neid, kellel on vasakus tabelis (Employees)
-- DepartmentId null

select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
--näitab ainult paremas tabelis olevat rida, 
--mis ei kattu Employees-ga.

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--teete AdventureWorksLT2019 andmebaasile join p'ringuid:
--inner join, left join, right join, cross join ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

--Mõnikord peab muutuja ette kirjutama tabeli nimetuse nagu on Product.Name,
--et editor saaks aru, et kummma tabeli muutujat soovitakse kasutada ja ei tekiks
--segadust
select Product.Name as [Product Name], ProductNumber, ListPrice, 
ProductModel.Name as [Product Model Name], 
Product.ProductModelId, ProductModel.ProductModelId
--mõnikord peab ka tabeli ette kirjutama täpsustama info
--nagu on SalesLt.Product
from SalesLt.Product
inner join SalesLt.ProductModel
--antud juhul Producti tabelis ProductModelId võõrvõti,
--mis ProductModeli tabelis on primaarvõti
on Product.ProductModelId = ProductModel.ProductModelId

--rida 412
--6 tund
--12.03.26

--isnull funktsiooni kasutamine
select isnull('Ingvar', 'No Manager') as Manager

-- NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

alter table Employees
add ManagerId int

--neile, kellel ei ole ülemust, siis paneb neile No Manager teksti
--kasutage left joini
select  E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--kasutame inner joini
--kuvab ainult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

--lisame Employees tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)

alter table Employees
add LastName nvarchar(30)

--muudame olemasoleva veeru nimetust
sp_rename 'Employees.Name', 'FirstName'

update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
--coalesce
select * from Employees
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all, mis näitab kõiki ridu
--union all ühendab tabelid ja näitab sisu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kasutad union all, aga sorteerid nime järgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saab kasutada selle nimelist sp-d
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--@ tähendab muutujat
@Gender nvarchar(20),
@Department int
as begin
	select FirstName, Gender, Department from Employees where Gender = @Gender
	and Department = @Department
end

--kui nüüd allolevat käsklust käima panna, siis nõuab gender parameetrit
spGetEmployeesByGenderAndDepartment

--õige variant
spGetEmployeesByGenderAndDepartment 'Female', 1

--niimoodi saab sp kirja pandud j'rjekorrast mööda minna, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

---saab vaadata sp sisu result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja panna sinna v]ti peale, et keegi teine peale teie ei saaks muuta
--kuskile tuleb lisada with encryption
alter proc spGetEmployeesByGenderAndDepartment   
@Gender nvarchar(20),  
@Department int 
with encryption
as begin  
 select FirstName, Gender, Department from Employees where Gender = @Gender  
 and Department = @Department  
end

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
--tuleb teha declare muutuja @TotlaCount, mis on int
declare @TotalCount int
--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
execute spGetEmployeeCountByGender 'Male', @TotalCount out
--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is null
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount
--l]pus kasuta print @TotalCounti puhul

declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info vaatamine
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame millest sõltub meie valitud sp
sp_depends
--näitab, et sp sõltub Employees tabelist kuna seal on Count(Id)
--ja ID on Employee tabelis

--vaatame tabelit
sp_depends Employees

--teeme sp, mis annab andmeid ID ja Name veergude kohta Employee tabelis
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin 
select @Id = Id, @Name = FirstName from Employees
end
--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
select @TotalCount = count(Id) from Employees
end

--on vaja teha uus päring kus kasutame sptotalcount2 sp-d
--et saada tabelite ridade arv
--tuleb delrareerida muutuja @TotalCount mis on int andmetüüp
--tuleb execute spTotalCount2 kus parameeter @totalcount out
declare @TotalEmployees int
execute spTotalCount2 @TotalCount out
print @TotalEmployees

--Mis Id all on keegi nime järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
select @FirstName = FirstName from Employees where Id = @Id 
end

--annab tulemuse kus Id 1 (sead numbrit saab muuta) real on keegi koos nimega
--print tuleb kasyrada et näidata tulemust
declare @FirstName nvarchar(20) 
exec spGetNameById1 3, @FirstName output
print 'Name of the Employee = ' + @FirstName

--tehke sama mis eelmine aga kasutage spgetbynameid sp-d
--firstname lõpus on out
declare @FirstName nvarchar(20) 
exec spGetNameById1 3, @FirstName out
print 'Name of the Employee = ' + @FirstName 
--output tagastab muudetud read kohe pärinu tulemusena
--see on salvestatud protseduuuris ja ühe väärtuse tagastamine
--out ei anna mitte midagi kui seda ei määra execute käsus

sp_help spGetNameById

create proc spGetNamebyId2
@Id int
as begin
--kui on begin siis on ka end kuskil olemas
return (select FirstName from Employees where id = @Id)
end

--tuleb veateade kuna kutsusime välja int-i aga Tom on nvarchar
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNamebyId2 1
print 'Name of the employee = ' + @EmployeeName


--sisseehitatud string funktsioonid 
--see konverteerib ASCII tähe väärtuse numbriks
select ASCII('A')
select CHAR(65)
--prindime kogu tähestiku välja

declare @Start int
set @Start = 97
while (@Start <= 122)
begin
select char (@Start)
set @Start = @Start + 1
end

--eemaldame tühjad kohad sulgudes
select ('                Hello')
select LTRIM('                Hello')

--tühiute eemaldamine veerust, mis on tabelist
select FirstName, MiddleName, LastName from Employees
--eemaldage tühikud FirstName veerust ära
select LTRIM(FirstName) as FirstName, MiddleName, LastName from Employees

--paremalt poolt tühjad stringid lõikab ära
select RTRIM('       hello      ')
--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt lower-ga ja upper-ga saan muuta märkide suurust
--reverse funktsioon pöörab kõik ümber 
select REVERSE(upper(ltrim(FirstName))) as FirstName, MiddleName, LOWER(LastName), RTRIM(ltrim(FirstName)) + 
' ' + MiddleName + ' ' LastName as FullName
from Employees
--left, right, substring
--vasakult poolt neli esimest tähte
select LEFT('ABCDEF', 4)
--paremalt poolt kol tähte
select RIGHT ('ABCDEF', 3)

--kuvab @-tähemärki asetust e mitmes on @ märrk 
select charindex('@', 'Sara@aaa.com')

--esimene nr peale komakohta näitab, et mitmedast alustab ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5 2)

--@ märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, +3)

select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 5
len('pam@bbb.com') - charindex('@', 'pam@bbb.com')
--peale @ märki hakkab kuvama tulemus, nr saab kaugust seadistada

alter table Employees 
add Email nvarchar(20)

update Employees set Email = 'Tom@ttt.com' where id = 1
update Employees set Email = 'Pam@bbb.com' where id = 2
update Employees set Email = 'John@jjj.com' where id = 3
update Employees set Email = 'Sam@sss.com' where id = 4
update Employees set Email = 'Todd@ttt.com' where id = 5
update Employees set Email = 'Ben@bbb.com' where id = 6
update Employees set Email = 'Sara@sss.com' where id = 7
update Employees set Email = 'Valarie@vvv.com' where id = 8
update Employees set Email = 'James@jjj.com' where id = 9
update Employees set Email = 'Russel@rrr.com' where id = 10

select * from Employees
select SUBSTRING (Email, charindex('@', Email) + 1,
len (email) - charindex('@', Email)) as EmailDomain
from Employees

--alates teisest tähest emailisis kuni @ märgini on tärnid
select FirstName, LastName, 
SUBSTRING (Email, 1, 2) + replicate('*', 5) + 
substring(Email, Charindex('@', Email), len (Email) - charindex('@', Email)+1) as Email
from Employees

--kolm korda näitab stringis olevat väärtust
select REPLICATE ('asd', 3)

--tühiku sisestamine
select SPACE(5)

--tühiku sisestaine FirstName ja LastName vahele
select FirstName + SPACE(25) + LastName as FullName
from Employees

--PatIndex
--sama mis charindex aga dünaamilisem ja saab kasutada wildcardi 
select Email, PATINDEX('%@aaa.com', Email) as Firstoccurence
from Employees where PATINDEX('%@jjj.com', Email) > 0
--leian kõik selle domeeni esindajad ja alates mitmendast märgist algab @

--kõik .com emailid  asendav .net-ga
select Email, REPLACE (Email, '.com', '.net') from Employees

--soovin asendada peale esimest märki kolm tähte viis tärniga
select FirstName, LastName, Email,
stuff(Email, 2, 3, '*****') as stuffedEmail
from Employees 

create table DateTime 
(
c_time time,
c_date date,
c_smalldatetime smalldatetime, 
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (getdate(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

update DateTime 
set c_datetimeoffset = '2026-03-19 55:27:15.0500000 +10:00'
where c_datetimeoffset = '2026-03-19 14:27:15.0500000 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' ---aja päring
select SYSDATETIME(), 'SYSDATETIME' ---veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aeg koos ajalise nihkega
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg
--saab kontrollida kas on õige andmetüüp
select ISDATE('asd') --tagastab 0 kuna string ei ole date
--kuidas saada vastuseks 1 isdate puhul
select ISDATE(GETDATE())
select ISDATE('2026-03-19 55:27:15.0500000') --tagastab 0 kuna max kolm komakohta võib olla 
select DAY(getdate()) --annab tänase päeva nr
select DAY('01/24/2026') --annab stringis oleva kuupäeva ja järjestus peab olema õige
select Month(Getdate()) --annab tänase kuu nr
select month('01/24/2026') --annab stringis oleva kuu ja järjestus peab olema õige
select YEAR(getdate()) --annab jooksva aasta nr
select year('01/24/2026') --annab stringis oleva aasta ja järjestus peab olema õige

select DATENAME(day, '2026-03-19 14:27:15.0500000') --annab stringis oleva päeva nr
select DATENAME(WEEKDAY, '2026-03-19 14:27:15.0500000') --annab stringis oleva päeva sõnana 
select DATENAME(month, '2026-03-19 14:27:15.0500000') --annab stringis oleva kuu sõnana

create table EmployeesWithDates
(
Id nvarchar(2), 
Name nvarchar(20),
DateOfBirth datetime
)
insert into EmployeesWithDates (Id, Name, DateOfBirth) values
('1','Sam', '1980-12-30 00:00:00.000'),
('2', 'Pam', '1982-12-30 12:02:36.260'),
('3' , 'John', '1985-08-22 12:03:30:370'),
('4', 'Sara', '1979-11-29 12:59:30.670')
select * from EmployeesWithDates

--tund 9

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud

--vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
select Name, DateOfBirth, DATENAME(weekday, DateOfBirth) as [Day], 
--vaatab Vob veerust kuupõevasid ja kuvab kuu nr
MONTH(DateOfBirth) as MonthNumber,
--vaatab DoB veerust kuud ja kuvab sõnana
DateName(Month, DateOfBirth) as [MonthName],
--võtab DoB veerust aasta
YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

---kuvab 1 kuna USA nädal algab pühapäeval
select DATEPART(weekday, '2026-3-24 12:59:30.670')
--tehke sama kasutage kuud
select DATEPART(month, '2026-3-24 12:59:30.670')
--liidab stringis oleva kp 20 päeva juurde
select DATEadd(day, 20, '2026-3-24 12:59:30.670')
select DATEadd(day, -20, '2026-3-24 12:59:30.670')
--kuvab kahe stringis oleva kuudevahelist aega numbrina
select DATEDIFF(month,  '11/20/2026', '01/20/2026')
--sama aga kasutage aastat
select DATEDIFF(year,  '11/20/2026', '01/20/2026')
--alguses uurite mis on funktsioon MS SQL
--miks seda on vaja 
--mis on selle eelised ja puudused

--mis on: eelkirjutatud toimingud, salvestatud tegevus
--miks on vaja:pakkuda DB-s korduvkasutatud funktionaalsust
--eelised: saab kiiresti kasutada toiminguid ja ei pea kood uuesti kirjutama
--puudused: funktsioon ei tohi muuta DB olekut
create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
declare @tempdate datetime, @years int, @months int, @days int
select @tempdate = @DOB
select @years = DATEDIFF(year, @tempdate, getdate()) - case when (MONTH(@DOB) >
MONTH(getdate())) or (MONTH(@dob) = MONTH(getdate()) and DAY(@DOB) > DAY(getdate()))
then 1 else 0 end
select @tempdate = DATEADD(year, @years, @tempdate)

select @months = DATEDIFF(month, @tempdate, getdate()) - case when DAY(@DOB) > DAY(getdate()) then 1 else 0 end
select @tempdate  = DATEADD(day, @months, @tempdate)

select @days = DATEDIFF(day, @tempdate, getdate())

declare @Age nvarchar(50)
set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(2))
+ ' Months ' + CAST(@days as nvarchar(2)) + ' Days old '
return @Age
end

select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

--kui kasutame seda funktsiooni siis saame teada tänase päeva vahet stringis oleva välja tooduga
select dbo.fnComputeAge('02/24/2010') as age

-- n peale DOB muutujat näitab et mismoodikuvada DOB-i
select Id, Name, DateOfBirth,
CONVERT(nvarchar, DateOfBirth, 109) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + '-' + CAST(Id as nvarchar) as [Name-ID] from EmployeesWithDates

select CAST(getdate() as date) --tänane kp
--tänanae kuupäev aga kasutate converti et kuvada stringina

select CONVERT(nvarchar, GETDATE(), 109) as ConvertedDOB

--matemaatilised funktsioonid 
select ABS(-5) --abs on absoluutväärtusega number ja tulemuseks saame ilma miinus märgita 5
select CEILING(4.2) --ceiling on funktsioon, mis ümardab ülespoole ja tulemuseks saame 5
select CEILING(-4.2) --ceiling ümardab ka miinus numbrid ülespoole, mis täheendab, et saame -4
select FLOOR(15.2) --floor on funktsioon, mis ümardab ülespoole ja tulemuseks saame 15
select FLOOR (-15.2) --floor ümardab ka miinus numbrid ülespoole, mis täheendab, et saame -16
select POWER(2, 4) --kaks astmes neli  
select SQUARE(9) -- antud juhul 9 ruudus
select SQRT(16) --antud juhul 16 ruutjuur

select RAND() --RAND on funtksioon mis genereerib 
--juhusliku numbri vahemikus 0 kuni 1
--kuidas aada täis number iga kord 
select FLOOR(rand() * 100) --korrutab sajaga iga suvalise numbri

--iga kord näitab 10 suvalist numbrit 
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
select FLOOR(rand() * 100)
set @counter = @counter + 1
end

select ROUND(850.556, 2)
--round on funktsioon, mis ümardab kaks komakohta
--ja tulemuseks saame 850.56
select ROUND(850.556, 2, 1)
--round on funktsioon, mis ümardab kaks komakohta ja 
--kui kolmas parameeter on 1, siis ümardab alla
select ROUND(850.556, 1)
--round on funktsioon, mis ümardab ühe komakoha ja 
--tulemuseks saame 850.6
select ROUND(850.556, 1, 1) --ümardab alla ühe komakoha pealt ja tulemsueks saame 850.5
select ROUND(850.556, -2) --ümardab täisnr ülespoole ja tulemuseks saame 90
select ROUND(850.556, -1)-- ümardab täisnr alla ja tulemus on 850

create function dbo.CalcuteAge(@DOB date)
returns int 
as begin
declare @Age int 
set @Age = DATEDIFF(year, @DOB, GEtdate()) - 
case
when (MONTH(@DOB) > MONTH(getdate())) OR 
(MONTH(@DOB) = MONTH(getdate()) and DAY(@DOB) > DAY(getdate()))
then 1 else 0 end
return @age
end
exec dbo.CalcuteAge '1980-12-30'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad 
--antud juhul näitab kõike kes on üle 36 a vanad 
select Id, dbo.CalcuteAge(DateOfBirth) as age from EmployeesWithDates
where dbo.CalcuteAge(DateOfBirth) > 36

--inline table functsions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

select * from EmployeesWithDates

insert into EmployeesWithDates(Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', 1978-11-29, 1, 'Male')

update EmployeesWithDates 
set DepartmentId = 1 
where Id = 1

update EmployeesWithDates 
set DepartmentId = 2 
where Id = 2

update EmployeesWithDates 
set DepartmentId = 1
where Id = 3

update EmployeesWithDates 
set DepartmentId = 3
where Id = 4

update EmployeesWithDates
set Gender = 'Male'
where Id = 1

update EmployeesWithDates
set Gender = 'Female'
where Id = 2
update EmployeesWithDates
set Gender = 'Male'
where Id = 3
update EmployeesWithDates
set Gender = 'Female'
where Id = 4

--scalar function annab mingis vahemikus olevaid andmeid
--inline table values ei kasutabegin ja end funktsioone 
--scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table 
as
return (select Id, Name, DateOfBirth, Gender
from EmployeesWithDates
where Gender = @Gender)

--kuidas leida kõik naised tabelis EmployeesByGender
select * from fn_EmployeesByGender('female')
--tahaks ainult Pami nime näha 

select * from fn_EmployeesByGender('female') where Id = 2

select * from Department
--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--esimene on funktsioon ja teine tabel

select Name, Gender; DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--multi tabel statement 
--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth AS date)
AS dob
FROM EmployeesWithDates)

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
--funktsioon nimi on fn_MS_GetEmpolyees()
--peab edastama meile Id, NAme, DOB tabelist EMployeeswithDates

create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DateOfBirth date)
as begin 
insert into @Table
select Id, Name, CAST(DateOfBirth as date) from EmployeesWithDates
return
end

select * from fn_MS_GetEmployees()

--muudane andmeid ja vaatame, kas inline funktsioonis on muutused kajastatud
update fn_GetEmployees() set Name = 'Sam1' where Id = 1
select * from fn_GetEmployees()

update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1
--ei saa muuta andmeid multi state funktsioonis, 
--kuna see on nagu stored pocedure

--deterministic vs non-determenistic functions
--deterministic funktsioonid annavad alati sama tulemuse kui sisend on sama
select COUNT(*) from EmployeesWithDates
select SQUARE(4)
--non-deterministic funktsioonid annavd erineva tulemuse, kui sisend on sama
select GETDATE()
select CURRENT_TIMESTAMP
select RAND()