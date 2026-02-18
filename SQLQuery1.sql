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