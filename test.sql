--1.
create table Raamatud(
Id int not null primary key,
pealkiri varchar(100),
autor varchar(100),
aasta int,
hind decimal
)
select * from Raamatud

insert into Raamatud (Id, pealkiri, autor, aasta, hind) values 
(1, 'raamat1', 'Juss', 2000, 20),
(2, 'raamat', 'Joonas', 1999, 35),
(3, 'Ajakiri', 'Mari', 2026, 3),
(4, 'Romaan', 'Tom', 2020, 24),
(5, 'Ajalugu', 'Mati', 1990, 44),
(6, 'Teadus', 'Juss', 2011, 15)

update Raamatud
set hind = 5
where Id = 3
update Raamatud
set autor = 'E.Vesper'
where Id = 6

alter table Raamatud
add LaosKogus int 
update Raamatud 
set LaosKogus = 23
where Id = 1
update Raamatud 
set LaosKogus = 18
where Id = 3
update Raamatud 
set LaosKogus = 35
where Id = 5


alter table Raamatud
drop column hind

delete from Raamatud where Id = 2
