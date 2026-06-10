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

--loome funktsioon
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
return (select Name from EmployeesWithDates where Id = @id)
end

--kasutame funktsiooni, leides Id 1 all oleva inimene
select dbo.fn_GetNameById(1)

select * from EmployeesWithDates

--saab näha funktsiooni sisu
sp_helptext fn_GetNameById

--muudate funktsiooni nimega fn_GetNameById
--ja panete sinna encryption, et keegi peale teie ei saaks sisu näha

alter function fn_GetNameById(@Id int)
returns nvarchar(30)
with Encryption 
as begin
return (select Name from EmployeesWithDates where Id = @id)
end

--kasutame schemabindingut et näha mis on funktsiooni sisu
alter function dbo.fn_GetNameById(@Id int)
returns nvarchar(30)
with schemabinding 
as begin
return (select Name from dbo.EmployeesWithDates where Id = @id)
end
--schemabinding tähendab, et kui keegi üritab muuta EmplyeesWithDates 
--tabelit siis ei lase seda teha kuna see on seotud 
--fn_GetNameById funktsiooniga

--ei saa kustuda ega muuta tabeli EmployeesWithDates
--kuna see on seotud funktsiooniga fn_GetNameById
drop table dbo.EmployeesWithDates

--temporary tables
--see on olemas ainult selle sessiooni jooksul
--kasutatakse # sümbolit, et saada aru, et tegemist on temporary tabeliga
create table #PersonDetails (Id int, Name Nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select Name from sysobjects
where name like '#PersonDetails%'

--kustutame temporary tabeli
drop table #PersonDetails

--loome sp, mis loob temporary tabeli ja paneb sinna andmed
create proc spCreateLocalTempTable
as begin
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--globaalñe temp tabel on olemas kogu
--serveris ja kõigile kasutajatale, kes on ühendatud
create table ##GlobalPersonDetails (Id int, Name nvarchar(20))

--index 
create table EmployeeWithSalary
(
Id int primary key,
Name nvarchar(20),
Salary int,
Gender nvarchar(10)
) 

insert into EmployeeWithSalary(Id, Name, salary, Gender) values
(1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

--otsime inimesi kelle palgavahemik on 5000 kuni 7000
select * from EmployeeWithSalary where Salary between 5000 and 7000

--loome indeksi Salary veerule, et kiirendada otsingut
--mis asetab andmed Salary veeru järgi järjestatult
create index IX_EmployeeSalary 
on EmployeeWithSalary(salary asc)

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--tahaks IX_EMployeeSalary indeksi kasutada, et otsing oleks kiirem
select * from EmployeeWithSalary
where Salary between 5000 and 7000

--näitab, et kasutatakse indeksi IX_EmployeeSalary,
--kuna see on järjestatud Salary veeru järgi
select * from EmployeeWithSalary with (index(IX_EmployeeSalary))

drop index IX_EmployeeSalary on EmployeeWithSalary --1 variant
drop index EmployeeWithSalary.IX_EmployeeSalary --2 variant

--indeksi tüübid:
--1. Klastrites olevad
--2. Mitte klastrites olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid 
--10. Välja arvatud veergudega indeksid

--klastrits olev indeks määrab ära tabelis oleva füüsilise jäerjestuse
--ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

create table EmployeeCity
(
ID int primary key,
Name nvarchar(20),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Female', 'Syndney')

exec sp_helpindex EmployeeCity
--andmete õige jõrjestuse loovad klastris olevad indeksid 
--ja kasutab selleks id nr-t
--põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest

--klastris olevad indeksid dikteerivad säilitanud andmete järjestus tabelis 
--ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity
create clustered index IX_EmployeeCityName
on EmployeeCity(Name)
--põhjus miks ei saa luua klastris olevat
--indeks Name veerule on se et tabelis on juba kastris 
--olev indeks Id veerul, kuna see on primaarvõti

--loome composite indeksi mis tähendab et see on mitme veeru indeks
--enne tuleb kustutad aklastris olev indeks, kuna composite indeks
--on
create clustered index IX_EmployeeGenderSalary
on EmployeeCity(Gender desc, Salary desc)
--kui teed select päringu sellele tabelile siis peaksid nägema andmeid,
--mis on järjestatud selliselt: Esimeseks võetakse aluseks Gender veerg
--kahanevas jäerjestuses ja siis Salary veerg tõusvas järjestuses

select * from EmployeeCity

--mitte klastris oolev indeks on eraldi struktuur,
--mis hoiab indeksi veru väärtusi
create nonclustered index IX_EmployeeCityName
on EmployeeCity(Name)
--kui nüüud teed select päringu, siis näed, et andmed on
--järjestatud Id veeru järgi

--erinevused kahe indeksi vahel 
--1. ainult üks klastris olev indeks saab olla tabeli peale,
--mitte-klastris olevaid indekseid saab olla mitu
--2. Klastris olevaid indeksid on kiiremad kuna indeks peab tagasi
--viitama tabelile juhul kui selekteeritud veerg ei ole  olemas indeksis
--3.Klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
--ja ei nõua kettal lisa rumi. Samas mitte klastris olevaid indeksid on
----salvestatud tabelist eraldi ja nüuab lisa ruumi

create table EmployeeFirstName
(
ID int primary key,
FirstName nvarchar(20),
LastName nvarchar(20),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)
exec sp_helpindex EmployeeFirstNAme 
insert into EmployeeFirstName values(1, 'John', 'Smith', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC27F6B586E8
--kui küivitada ülevalpool oleva koodi, siis tuleb veateade
--et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste 
--unkiaalsust ja primaarvütit koodiga UNikaalseid Indekseid
--ei saa kustuda aga käsitsi saab

create unique nonclustered index UTX_Employee_FirstName_LastName
on EMployeeFirstName(FirstName, LastName)

--lisame uue piirangu peale 
alter table EmployeeFirstNAme
add constraint UQ_EmployeeFirstNameCity
unique nonclustered (City)

--sisetsage kolmas rida andmeid, mis on id-s 3, FIrstNAme-s John,
--LastName-s Menco ja linn on London
insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'London')

--saab vaadata indeksite infot
exec sp_helpconstraint EmployeeFirstName

--1. Vaikimisi primaarvüti loob unikaalses klastris oleva indeksi
--samas unikaalse mitte-klastris oleva indeksi
--2.Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabelis
--kui tabel juba sisaldab väärtusi võtmeveerus
--3. Vaikimisi korduvaid väärtuseid  ei ole veerus lubatud,
--kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada
----10 rida andmeid, millest 5 sisaldavad korduvaid andmeid
----siis kõik 1 lükatakse tagais. Kui soovin ainult 5
--rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks
----kasutatakse IGNORE_DUP_KEY

create unique index IX_EMployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key
insert into EmployeeFirstName values(4, 'John', 'Menco', 3512, 'Male', 'London1')
insert into EmployeeFirstName values(5, 'John', 'Menco', 3123, 'Male', 'London2')
insert into EmployeeFirstName values(5, 'John', 'Menco', 3220, 'Male', 'London2')
--enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne
select * from EmployeeFirstName

--view on virtuaalne tabel, mis on loodud ühe või mitme tabeli põhjal
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.id = Employees.Department

create view vw_EmployeesByDetails
as 
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.id = Employees.Department

--kuidas view-d kasutada: vw_EmployeesByDetails
select * from vw_EmployeesByDetails
--view ei salvesta andmeid vaikimisi
--seda tasub võtta, kui salvestatud virtuaalne tabelina

--milleks on vaja:
--saab kasutada andebaasi skeemi keerukuse lihtsustamiseks
--mitte IT-inimesele
--piiratud ligipääas andmetele, ei näe kõiki veerge

--teeme view, kus näeb ainult IT-Töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.id = Employees.Department
where Department.DepartmentName = 'IT'
--ülevalpool olevat päringut saav liigutada reataseme turvalisuse
--alla Tahan ainult näidata IT osakonna töötajaid

--veeru taseme turvalisus
--peale selecti määratled veergude näitamise ära
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
JOIN Department
on Employees.Department = Department.id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as 
select DepartmentName, COUNT(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.Department = Department.id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu?
sp_helptext vEmployeesCountByDepartment
--kui soovid muuta, siis kasutad alter view

--lkui soovid kustutada, siis kasutad drop view
drop view vEmployeesCountByDepartment

--andmete uuendamine läbi view
create view vEmploeesDataExceptSalary
as 
select Id, FirstName, Gender, Department
from Employees

select * from Employees

update vEmploeesDataExceptSalary
set [FirstName] = 'Pam' where id = 2

--kustutage Id 2 rida ära
delete from vEmploeesDataExceptSalary where id = 2
--andemete sisestamine l'bi view
--id2, female, osakond 2, nimi on Pam

insert into vEmploeesDataExceptSalary values
(2, 'Pam', 'Female', 2)

--indekseeritud view
--MS SQL on indekseeritud view nime all ja 
--Oracle materialiseeritu view nimega

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

select * from Product

insert into Product values 
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

select * from ProductSales
Insert into ProductSales values
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

--loome view, mis annab meile veerud TotalSales ja TtalTransaction

create view vTotalSalesByProduct
with schemabinding
as 
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
count_big(*) as TotalTransaction
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

select * from vTotalSalesByProduct

--kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
--1. view tuleb luua koos schemabinding-ga
--2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks
--võib oll NULL, siis aasendusväärtus peaks olema täpsustatud.
--Antud juhul kasutamine ISNULL funktsiooni asendamaks NULL väärtust
--3. kui GroupBY on täpsustatud, siis view select list peab
--sisaldama COUNT_BIG(*)väljebdit
--4. baastabelist peaksid view-d olema viidatud kaheosalise nimega
--e antud juhul dbo.Product ja dbo.Productsales

create unique clustered index UIX_vTotalSalesBYProduct_Name
on vTotalSalesByProduct(Name)

select * from vTotalSalesByProduct

--view piirangud 
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, Department
from Employees
where Gender = @Gender

--mis on selles view valesti??
--vaatesse e view-sse ei saa kaasa panna parameetrid e antud juhul Gender

--teha funktsioon kus parameetriks on Gender
--soovin näha veerge: ID, FirstName, Gender, DepartmentID
--tabeli nimi on employees
--funktsiooni nimi on fnEmployeedetails
create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, Department
from Employees where Gender = @Gender)

--kasutame funktsiooni koos parameetriga
select * from fnEmployeeDetails('Female')

--order by kasutamine
create view vEmployeeDetailsStored
as 
select Id, FirstName, Gender, Department
from Employees
order by Id
--order by-d ei saa kasutada

--temp tabeli tegemine
create table ##TestTempTable
(Id int, FirstName nvarchar(20), Gender nvarchar(20))

insert into ##TestTempTable values(101, 'Mart', 'Male')
insert into ##TestTempTable values(102, 'Joe', 'Female')
insert into ##TestTempTable values(103, 'Pam', 'Female')
insert into ##TestTempTable values(104, 'James', 'Male')

--view nimi on VonTempTable
--kasutame ##TestTempTable
--
create view VOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--view-d ja funktsioone ei saa teha ajutistele tabelitele

--Triggerid

--DML trigger
--kokku on kolme tüüpi: DML, DDL, ja LOGON

--trigger on stored procedure eriliik, mis automaatselt käivitab,
--kui mingi tegevus
----peaks andmebaasis aset leidma

----DML - dta manipulation language
--DML-i põhilised käsklused: insert, update, JA delete

----DML triggereid saab klassifitseerida kahte tüüpi:
--1.After TRIGGER(kutsutakse ka FOR triggeriks)
--2.Instead of trigger (selmet trigger e selle asemel trigger

--after trigger käivitub peale sündmust, kui kuskil on tehtud

--loome  uue tabeli
create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

--PEALE IGA Tõõtaja sisestamist tahame teada tõõtaja ID-d
--p'eva ning aega(millal sisestati)
--kõik andmed tulevad employeeAudit tabeliss
--anmdeid sisestame Employees tabelisse

create trigger trEmployerForInsert on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values('New employee with Id = ' + CAST(@Id as nvarchar(5)) + ' is added at '
+ CAST(getdate() as nvarchar(20)))
end

select * from Employees

insert into Employees values (11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3, 'bob@bob.com')
go 
select * from EmployeeAudit

--delete trigger
create trigger trEmployeeForDelete
on Employees
for delete
as begin
declare @Id int
select @Id = Id from deleted

insert into EmployeeAudit
values('An existing employee with Id = '+ CAST(@Id as nvarchar(5)) + 
' is deleted at ' + CAST(getdate() as nvarchar(20)))
end

delete from Employees where id = 11
select * from EmployeeAudit

--update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)

	---muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	-- laeb kõik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	-- käib läbi kõik andmed temp tabelist
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		-- selekteerib esimese rea andmed temp tabel-st
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = Department,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		--võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = Department,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id

		---rida 1677
		---tund 14
		---30.04.26
		--hakkab võrdlema igat muutujat, et kas toimus andmete muutus
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) + ' to ' +
			cast(@NewSalary as nvarchar(20))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20)) + ' to ' +
			cast(@NewDepartmentId as nvarchar(20))

		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20)) + ' to ' +
			cast(@NewManagerId as nvarchar(20))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
			@NewFirstName

		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' Middlename from ' + @OldMiddleName + ' to ' +
			@NewMiddleName

		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' Lastname from ' + @OldLastName + ' to ' +
			@NewLastName

		if(@OldEmail <> @NewEmail)
			set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' +
			@NewEmail

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp tabelist rea
		delete from #TempTable where Id = @Id
	end
end
--triggeri lõpp

update Employees set FirstName = 'test123', Salary = 4000, MiddleName = 'test456'
where Id = 10

select * from Employees
select * from EmployeeAudit
--

--instead of trigger
create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentID int
)
--kelel ei ole seda tabelit, siis nemad sisestavad selle koodi
create table Department
(
Id int primary key,
DepartmentName nvarchar(20)
)

select * from Employee
insert into Employee values
(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2),
(3, 'Pam', 'Female', 1),
(4, 'Todd', 'Male', 4),
(5, 'Sara', 'Female', 1),
(6, 'Ben', 'Male', 3)

create view vEmployeeDetails
as 
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentID = Department.id

select * from vEmployeeDetails
--tuleb veatteade
insert into vEmployeeDetails values (7, 'Valarie', 'Female', 'IT')

--nüüd proovime lahendada probleemi, kui kasutame instead of trigger-t
create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
declare @DeptId int

select @DeptId = dbo.Department.id
from Department
join inserted
on inserted.DepartmentName = Department.DepartmentName

if(@DeptId is null)
begin
raiserror('Invalid department name. Statment terminated', 16, 1)
return
end

insert into dbo.Employee(Id, Name, Gender, DepartmentId)
select Id, Name, Gender, @DeptId
from inserted
end
--raiserror funktsiooon
--selle eesmärk on tuua välja veateade, kui departmentName veerus ei ole väärtust
--ja ei klappi uue sisestatud väärtusega 
--esimene on parameeter ja veateade sisu, teinne on veataseme nr (nr 16 tähendab
--üldised vigu) ja kolmas on olek

--nüüd saab läbi view sisestada andmed
insert into vEmployeeDetails values (7, 'Valarie', 'Female', 'IT')

--uuendad andmeid 
update vEmployeeDetails
set Name = 'Johny', DepartmentName = 'IT'
where Id = 1
--ei saa uuendada andmeid kuna mitu tabelit on sellest mõjutatud

update vEmployeeDetails
set DepartmentName = 'IT'
where Id = 1

select * from vEmployeeDetails

create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin

if(update(Id))
begin
raiserror('Id cannot be changed', 16, 1)
return
end

if(UPDATE(DepartmentName))
begin
declare @DeptId int
select @DeptId = Department.id
from Department
join inserted
on inserted.DepartmentName= Department.DepartmentName

if(@DeptId is null)
begin
raiserror('Invalid Department name', 16, 1)
return
end

update Employee set DepartmentID = @DeptId
from inserted
join Employee
on Employee.Id = inserted.id 
end

if(UPDATE(Gender))
begin
update Employee set Gender = inserted.Gender
from inserted
join Employee
on Employee.Id = inserted.id
end

if(UPDATE(Name))
begin
update Employee set Name = inserted.Name
from inserted
join Employee
on Employee.Id = inserted.id
end
end

--uuendame anmdeid, kasuta vEmployeeDetails
--uuendada seal, kus Id on 1
update vEmployeeDetails
set Name = 'john123', Gender = 'Male', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails

--delete trigger
create view vEmployeeCount
as 
select DepartmentID, DepartmentName, COUNT(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentID = Department.id
group by DepartmentName, DepartmentID

select * from vEmployeeCount

--vaja teha päring, kus on töötajaid 2tk või rohkem 
--kasutada vEmployeeCount

select * from vEmployeeCount where TotalEmployees > 2
select DepartmentName, TotalEmployees from vEmployeeCount where TotalEmployees >= 2

---
select DepartmentName, DepartmentId, COUNT(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentID

select * from #TempEmployeeCount

--läbi ajutise tabeli saab samu andmeid vaadata, kui seal on info olemas
select DepartmentName, TotalEmployees from #TempEmployeeCount
where TotalEmployees >= 2

--tuleb teha trigger nimega trEmployeeDetails_InsteadOfDelete
--ja kasutada vEmployeeDetails
--triggeri tüüp on instead of delete

create trigger trEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
delete Employee
from Employee
join deleted 
on Employee.Id = deleted.Id
end

delete from vEmployeeDetails where Id = 7

-- CTE e common table expression

--CTN näide 
with EmployeeCount(DepartmentName, DepartmentId, TotaEmployees)
as 
(
select DepartmentName, DepartmentID, COUNT(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentID = Department.id
group by DepartmentName, TotalEmployees
)
select DepartmentName, TotalEmployees 
from EmployeeCount
where TotalEmployees >= 2

--CTE-d võivad sarnaneda temp tabeliga 
--sarnane päritud tabelile ja ei ole salvestatud objektina
--ning kestab  päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from
(
select DepartmentName, DepartmentID, COUNT(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentID = Department.id
group by DepartmentName, TotalEmployees
)
as EmployeeCount
where TotalEmployees >= 2

--tehke päring, kus on kaks CTE päringut sees

with EmployeeCountBy_PayRoll_It_Dept(DepartmentName, Total)
as
(
select DepartmentName, COUNT(Employee.Id) as TotalEmployees
from Employee
join Department
on Employee.DepartmentID = Department.Id
where DepartmentName in ('Payroll', 'IT')
group by DepartmentName
),
EmployeeCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
select DepartmentName, COUNT(Employee.Id) as TotalEmployees
from Employee
join Department
on Employee.DepartmentID = Department.Id
group by DepartmentName
)
--kui on kaks CTE-d olemas, siis unioni abil ühendab päringu
select * from EmployeeCountBy_PayRoll_It_Dept
union
select * EmployeeCountBy_HR_Admin_Dept

--teha CTE päring nimega EmployeeCount
--järjestaks DepartmentName järgi ära
with EmployeeCount(DepartmentName, Total)
as
(
select DepartmentName, COUNT(Employee.Id) as TotalEmployees
from Employee
group by DepartmentName
)
--peale CTE-d peab kohe tulema käsklus SELECT, INSERT, UPDATE või DELETE
--kui proovid midagi muud, siis tuleb veateade
select DepartmentName
from Department
join Employee 
on Department.id = Employee.DepartmentId
order by DepartmentName

--tund 15

--uuendame CTE-d

with Employee_Name_Gender
as
(
select Id, Name, Gender from Employee
)
select * from Employee_Name_Gender

--kasutame JOIN-i CTE tegemiseks
with EmployeesByDepartment
as 
(
select Employee.Id, Employee.Name, Gender, DepartmentName
from Employee
join Department
on Department.id = Employee.DepartmentID
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

--kasutage eemlistCTe andmete muutmiseks
--aga seekord muutke ID1 töötaja Gender Female peale ja 
--departmentName payroll peale
with EmployeesByDepartment
as 
(
select Employee.Id, Employee.Name, Gender, DepartmentName
from Employee
join Department
on Department.id = Employee.DepartmentID
)
update EmployeesByDepartment set Gender = 'Female', DepartmentName = 'Payroll' where Id = 1
--ei luba mitmes taelis anmdeid muuta, kui on tegemist CTE-ga

--kokkuvüte CTE-st
-- 1.Kui CTE baseerub ühel tabelil, siis uuendus töötab
-- 2.Kui CTE baseerub mitmel tabelil, siis tuleb veateade
-- 3.Kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit,
--siis uuendus saab tehtud

--korduv CTE
--CTE, mis iseendale viitab, kustutakse korduvaks CTE-ks
--kui tahad andmeid näidata hierarhiliselt
Create table Employee
(
EmployeeId int primary key,
Name nvarchar(20),
ManagerId int
)

select * from Employee

insert into Employee values
(1, 'Tom', 2),
(2, 'Josh', null),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

--kasutame left join-i, et näha kõiki töötajaid ja nende juhte
select Emp.Name as [Employee Name],
ISNULL(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.ManagerId = Manager.EmployeeId

--peab samasuguse tulemuse saavutama, aga kasutate CTE-D
--seal sees kasutab joini koos union all
with EmployeeCTE(Id, Name, ManagerId, [Level])
as 
(
select Employee.EmployeeId, Employee.Name, ManagerId, 1
from Employee
where ManagerId is null

union all

select Employee.EmployeeId, Employee.Name, Employee.ManagerId,
EmployeeCTE.[Level] + 1
from Employee
join EmployeeCTE on Employee.ManagerId = EmployeeCTE.Id
)
select EmpCTE.Name as Employee,
ISNULL(MgrCTE.Name, 'Super Boss') as [Manager Name],
EmpCTE.Level as [Boss Level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.Id

--PIVOT
--mis on pivot?
--PIVOT on SQL-i operatsioon, mis võimaldab teisendada ridu veergudeks
create table Sales
(
	SalesAgent nvarchar(20),
	SalesCountry nvarchar(20),
	salesAmount int
)
select * from Sales
insert into Sales values
('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('John', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'UK', 360),
('David', 'UK', 140)

----
select SalesCountry, SalesAgent, sum(SalesAmount) as TotalSales
from Sales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--kasuta pivotit, et saada sama tulemus nagu ülemises päringus

select SalesAgent, India, US, UK from Sales
pivot (sum(SalesAmount) for SalesCountry in (UK, US, India))
as TotalSales

--p'ring muudab unikaalsete veergude väärtust salesCountry veerus
--omaette veergudeks koos veergude SalesAmount liitmisega

Create table SalesWithId
(Id int primary key,
SalesAgent nvarchar(20),
SalesCountry nvarchar(20),
SalesAmount int
)
insert into SalesWithId values
(1, 'Tom', 'UK', 200),
(2, 'John', 'US', 180),
(3, 'John', 'UK', 260),
(4, 'David', 'India', 450),
(5, 'Tom', 'India', 350),
(6, 'David', 'US', 200),
(7, 'Tom', 'US', 130),
(8, 'John', 'India', 540),
(9, 'John', 'UK', 120),
(10, 'John', 'UK', 220),
(11, 'John', 'UK', 420),
(12, 'David', 'US', 320),
(13, 'Tom', 'US', 340),
(14, 'Tom', 'UK', 660),
(15, 'John', 'India', 430),
(16, 'David', 'India', 230),
(17, 'David', 'India', 280),
(18, 'Tom', 'UK', 480),
(19, 'John', 'UK', 360),
(20,'David', 'UK', 140)

select SalesAgent, India, US, UK from SalesWithId
pivot (sum(SalesAmount) for SalesCountry in (UK, US, India))
as TotalSales
--põhjuseks on Id veeru olemasolu SaleswithId, mida võetakse arvesse
--pööramise ja grupeerimise järgi

select SalesAgent, India, US, UK
from
(
Select SalesAgent, SalesCountry, SalesAmont from SalesWithId
)
as SourceTable
pivot
(sum(SalesAmount) for SalesCountry in (India, US, UK))
as PivotTable

--transaction
--transaction jälgib järgmisi samme:
--1. selle algus
--2. käivitatakse Db käske
--3. kontrollib vigu. KUi on viga, siis taastab algse oleku

create table MailingAddress
(
Id int  not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(10),
StreetAddress nvarchar(50),
City nvarchar(50),
PostalCode nvarchar(20)
)

insert into MailingAddress values
(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create table PhysicalAddress
(
Id int  not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(10),
StreetAddress nvarchar(50),
City nvarchar(50),
PostalCode nvarchar(20)
)

insert into PhysicalAddress values
(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create proc spUpdateAddress
as begin
begin try
begin transaction
update MailingAddress set City = 'LONDON'
where MailingAddress.Id = 1 and EmployeeNumber = 101

update PhysicalAddress set City = 'LONDON'
where PhysicalAddress.Id = 1 and EmployeeNumber = 101
commit transaction
end try
begin catch
rollback tran
end catch
end

--käivitame spUpdateAddress stored procedure-i
spUpdateAddress
select * from MailingAddress
select * from PhysicalAddress

--kui tene uuendus ei lähe läbi, siis esimene ei lähe ka läbi
--kõik uuendused peavad läbi minema
--transaction ACID test
--A - atomic e aatomlius
--C - consistent e järjepidevus
--I - isolated e isoleeritus
--D - durable e vastupidav

----Atomic - kõik tehingud transactionis on kas edukalt tehtud või need
----lükatakse tagasi. Nt, Mõlemad käsud peaksid alati õnnestuma. Andmebaas
--teeb sellisel juhul: võtab esimene update tagasi ja veeretab selle algasendiss
--e taastab algsed andmed

--Consistent - kõik transactionid puudutavad andmed jäetakse loogiliselt
--järjepidevasse olekusse. Nt, kui laos saadaval olevaid esemete hulka 
--vähendatakse siis tabelis peab olema vastav kanne. Inventuur ei saa
--lihtsalt kaduda

--Isolated - transaction peab andmeid mõjutama, sekkumata tesitesse
--samaaegselt transactionitesse. See takistab andmete muutmist, mis 
--põhinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi
--muudetakse. Enamik DB-d kasutab thingute isoleeriise säilitamiseks lukustamist

--Durable - kui muudatus on tehtudd, siis see on püsiv. Kui süsteemiviga või
--voolukatkestus ilmnev enne käskud ekomplekti valmimist, siis tühistatakse need
--käsud ja andmed taastakse algsesse olekusse

--subqueries e alamkäsud
--alamkäsud on SQL.i käsud, mis on peastatud teise SQL-i käsu sisse

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
Quantity int
)

truncate table Product

--rida 2387
--tund 16
--21.05.26

insert into ProductSales values(3, 450, 5)
insert into ProductSales values(2, 250, 7)
insert into ProductSales values(3, 450, 4)
insert into ProductSales values(3, 450, 9)

select * from Product
select * from ProductSales

--kirjutame päringu mis annab infot müümata toodetest
select Id, Name, Description from Product
where Id not in (select ProductId from ProductSales)
--sulguude sees on subquery, mis tagastab kõik ProductId-d ProductSales tabelist

--enamus juhtudel saab subquery-t asendada JOIN-iga
--teha päring join-iga, et saada müümata toodete infot
select Product.Id, Product.Name, Description from Product
left join ProductSales 
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

--teeme subquery, kus kasutatakse selecti
Select name,
(select SUM(Quantity) from ProductSales where ProductId = Product.Id) as
[Total Quantity]
from Product
order by Name

--sama tulemus aga join-iga
select Product.Id,
SUM(Quantity) as [Total Quantity]
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

--subquery-t saab subquery sisse panna
--subquery on alati sulgudes ja neid nimetatakse sisemisteks päringuteks

--rohkete andmetega testimise tabel

truncate table Product
truncate table ProductSales

--sisestame näidisandmed product Tabelisse
declare @Id int
set @Id = 1
while(@Id <= 3000000)
begin
	insert into Product values('Product - ' + cast(@Id as nvarchar(20)),
	'Product - ' + cast(@Id as nvarchar(20)) + ' Description')

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- ProductId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000

--UnitPrice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100

--QuantitySold
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10

declare @Counter int
set @Counter = 1

while(@Counter <= 4500000)
begin
	select @RandomProductId = round(((@UpperLimitForProductId -
	@LowerLimitForProductId) * RAND() + @LowerLimitForProductId), 0)

	select @RandomUnitPrice = round(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * RAND() + @LowerLimitForUnitPrice), 0)

	select @RandomQuantitySold = round(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * RAND() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales
	values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end

create table Product
(
Id int identity primary key,
Name nvarchar(50),
Description nvarchar(250)
)
create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)
select * from Product
select * from ProductSales

--tund 17
--rida 2370
--27.05.26

--võrdleme subquerit ja JOIN-i
select Id, Name, description 
from Product
where Id in
(
select Product.Id from ProductSales
)
--teeme cache puhtaks, et uut päringut ei oleks kuskile vahemällu salvestatud

checkpoint;
go
dbcc DROPCLEANBUFFERS;  --puhastab päringu cache-i
go
dbcc FREEPROCCACHE; --puhastab täitva planeeritudcache-i
go

-- teeme sama tabelite peale inner join päringu
--product ja productsales

select Product.Id, Name, Description 
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId


select Id, Name, Description
from Product
where not exists
(
select * from ProductSales where ProductId = Product.Id
)
--2,1 miljonit rida 11 sekundiga
--vahemälu puhtaks teha
--kasutage leftjoini Productid is null

select Product.Id, Name, Description 
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

--Cursor-d

--relatsiooniliste DB-de haldusüsteemid saavad väga hästi hakkama 
--SETS.ga SETS lubab mitut päringut
--kombineerida üuheks tulemuseks.
--Sinna alla käivad UNION; INTersect ja EXCEpt

update ProductSales set UnitPrice = 50 
where ProductSales.ProductId = 101

--kui on vaja rea kaupa andmeid töödelda siis kõige parem oleks kasutada
--Cursoreid. Samas on need jõudluse halvad ja võimaldusel vältida.
----soovitatav ileks kasutada JOIN-i

--Cursorid jagunevad omakorda neljaks:
--1. forward-only e edasi-ainult
--2. static e staatilised
--3. keyset võtmele seadisatud
--4. Dynamic e düunaamiline

--cursori näide
if the ProductName = 'Product 55', set UnitPrice to 55

--nüüd algab õige cursor
-----------------------
declare @ProductId int
--deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
--open avaldusega täidab select avaldust
--ja sisestab tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
--kui tulemuses on veel rid, siis @@FETCH_STATUS on 0
while(@@FETCH_STATUS = 0)
begin
declare @ProductName nvarchar(50)
select @ProductName = Name from Product where Id = @ProductId

if(@ProductName = 'Product - 55')
begin
update ProductSales set UnitPrice = 55 where ProductId = @ProductId
end

else if(@ProductName = 'Product - 56')
begin
update ProductSales set UnitPrice = 65 where ProductId = @ProductId
end

else if(@ProductName = 'Product - 1000')
begin
update ProductSales set UnitPrice = 1000 where ProductId = @ProductId
end

fetch next from ProductIdCursor into @ProductId
end

select * from Product

--rida 2478
--tund 18
--28. 05. 26
--vabatab rea e suleb cursori

--vaatame kas read on uuuendatud
select name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product 55' or Name = 'Product - 65' or Name = 'Product - 1000')

-- asendame cursorid JOIN-ga
update ProductSales
set UnitPrice = 
case
when Name = 'Product - 55' then 155
when Name = 'Product - 65' then 165
--võib kasutadalike või =
when Name like 'Product - 1000' then 10001
end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where Name = 'Product - 55' or Name = 'Product - 65' or
Name like 'Product - 1000'

--vaatame tulemust
selECT Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')

--tabelite info
--nimekiri süsteemi objektidest
select * from sysobjects where xtype = 'S'

--tabelite nimekiri
select * from sys.tables
--nimekiri tabelist ja view-st
select * from INFORMATION_SCHEMA.TABLES

--kui soovid erinevaid objekttüüpe vaadata, siis kasuta XTYPE süntaksit
select distinct xtype from sysobjects

--IT - internal table
--P - stored procedure
--PK - primary key contsraint
--S - system table
--SQ - service queue
--U - user table 
--V - view

--annab teada kas sellise nimega tabel on olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Employee')
begin 
create table Employee123
(
Id int Primary key,
Name nvarchar (30),
ManagerId int
)
print 'Table has been created'
end
else
begin
print 'Table already exists'
end

--saab kasutada ka sissehitatud funktsiooni: OBJECT_ID()
if OBJECT_ID('Employee') is null
begin
print 'Table created'
end
else
begin
print 'Table already exists'
end

--tahame sama nimega tabeli ära kustudada ja siis uuesti luua
if OBJECT_ID('Employee') is not null
begin
drop table Employee
end
create table Employee
(
Id int priamry key,
Name nvarchar(30),
ManagerId intn
)

--rida 2711
--tund
--03.06.26

alter table Employee
add Email nvarchar(50)

if not exists(select * from INFORMATION_SCHEMA.COLUMNS where
COLUMN_NAME = 'Email' and TABLE_NAME = 'Employee' and TABLE_SCHEMA = 'dbo')
begin 
alter table Employee
add Email nvarchar(40)
end
else
begin 
print 'Column already exists'
end

--kontrollime kas mingi nimega veerg on olemas
if COL_LENGTH('Employee', 'Email') is not null
begin 
print 'Column already exists'
end
else
begin
print 'Column does not exist'
end

--Merge
--tutvustati aastal 2008, mis lubab teha sisestamist, uuendamist ja kustutamist
--ei peakasutama mitut käsku

--merge puhul peab alati olema vähemalt kaks tabelit:
--1, algallika tabel e source table
--2. sihtmärk tabel e target table

--ühendab sihttabeli lähtetabeliga ja kasutab mõlemas tabelis ühist veergu
--koodinäide:
merge [TARGET] as T
using [SOURCE] as S
on [JOIN_]
when matched then
[DELETE STATEMENT]
when matched by target then
[DELETE STATEMENT]
when not matched by source then
[DELETE STATEMENT]

create table StudentSource
(
Id int primary key,
Name nvarchar(30)
)
go
insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'sara')
go
create table StudentTarget
(
Id int primary key,
Name nvarchar(30)
)
insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')
)
go
--1. kui leitakse klappiv rida, siis StdentTarget tabel on uuendatud
--2. kui read on SourceStudent tabelis olemas, aga neid ei ole StdentTarget-s
--siis puuduolevad read sisestatakse
--3.lui read on olemas StdentTarget-s aga mitte StudentSource-s, siis StdentTarget
--tabelis read kustutakse ära
merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then 
update set T.Name = S.Name
when not matched by target then
insert(Id, Name) values(S.Id, S.Name)
when not matched by source then
delete;
--------------------------
insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'sara')
insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')

merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then 
update set T.Name = S.Name
when not matched by target then
insert(Id, Name) values(S.Id, S.Name);

select * from StudentTarget
select * from StudentSource

--transaction-d

--mis see on?
--on rühm käske, mis muudavad DB-s salvestatud andmeid. Tehingut käsitletakse
--ühe tööüksusena. KAs kõik käsud õnnestuvad või mitte. Kui üks tehing sellest ebaõnnestub
--siis kõik juba muudetud andmed muudetakse tagasi

create table Account
(
Id int primary key,
AccountName nvarchar(25),
Balance int
)
 insert into Account values(1, 'Mark', 1000)
  insert into Account values(2, 'Mary', 1000)

  begin try 
  begin transaction
  update Account set Balance = Balance - 100 where Id = 1
    update Account set Balance = Balance - 100 where Id = 2

commit transaction
end try
begin catch
rollback transaction
print 'Transaction failed. All changes have been rolled back'
end catch
go

select * from Account

--mõned levinumad probleemid:
--1. Dirty rea e must lugemine
--2. Lost update Employee kadunud uuendused
--3. Nonreapeateable reads e kordumatud lugemised
--4. Phantom read e fantoom lugemine

--kõik eelnecad probleemid lahendaks ära, kui lubatakse igal ajal
--korraga ühel kasutajal ühe tehingu teha. Selle tulemusel kõik tehingud
--satuvad järjekorda ja neil võib tejjida vajadus kaua oodata, enne
--kui võimalus tehingut teha saabub

--kui ubada samaaegselt kõik tehingud ära teha, siis see omakorda

--1. read uncommited e lugemine ei ole teostatud
--2. read commited e lugemine tehtud
--3. reapeatable read e korduv lugemine
--4. snapshot e kuvatõmmis
--5. serializable e serailseerimine

----iagle juhumile tuleb läheneda jutumipõhiselt ja 
--mid vähem valet lugemist tuleb seda aeglasem

--dirty read näide

create table Inventory
(
Id int identity primary key,
Product nvarchar(50),
ItemsInStock int
)
go
insert into Inventory values('Phone', 10)
select * from Inventory

--1.käsklus
--1. transaction
begin tran
update Inventory set ItemsInStock = 9 where Id = 1
--kliendile tuleb arve
waitfor delay '00:00:15'
--ebapiisav saldojääk, teeb rollback-i
rollback tran

--2 käsklus
--samal ajal TEGIN UUE päringuga kna
--kus kohe peale esimest käsklust käsklust käivitan
--teise käskluse
--2 transction
set tran isolation level read uncommited
select * from Inventory where Id = 1
--3 käsklus
--nüüd panen selle käskluse tööle
--käivita kui käsklus 1 on moodas
select * from Inventory (nolock) where Id = 1
--muutsin esimese käsuga 9 iphine peale, aga--ikka on 10 tk

--Lost update e kadunud uuendused
select * from Inventory

set tran isolation level repeatable read
---1 tran
begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:15'
set @ItemsInStock = @ItemsInStock - 1

update Inventory
set ItemsInStock = @ItemsInStock where Id = 1

print @ItemsInStock
commit transaction


-- samal ajal panen teise transactioni tööle
set tran isolation level repeatable
read
begin tran
declare @ItemsInStock int
select @ItemsInStock = ItemsInStock
from dbo.Inventory where Id = 1

waitfor delay '00:00:01'
set @ItemsInStock = @ItemsInStock - 2

update Inventory
set ItemsInStock = @ItemsInStock
where Id = 1

print @ItemsInStock
commit tran