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
GenderId int
)
