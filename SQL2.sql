create database HarjutusDB

create table Tootajad
(
Id int,
Name nvarchar(30),
Amet nvarchar(30),
Palk int
)

create user ArendajaUser for login ArendajaLogin
create user RaamatupidajaUser for login RaamatupidajaLogin
create user AdminUser for login AdminLogin

create login ArendajaLogin
with password = 'Password.1234'

create login RaamatupidajaLogin
with password = 'Password.1234'

create login AdminLogin
with password = 'Password.1234'

grant select on Tootajad to ArendajaUser

grant select, update on Tootajad to RaamatupidajaUser

alter role db_owner
add member AdminUser

create role Vaatajad
grant select on Tootajad to Vaatajad

alter role Vaatajad
add member ArendajaUser

deny delete on Tootajad to RaamatupidajaUser

alter database HarjutusDB
set containment = partial

create user TestUser
with password = 'Password.1234'
grant select on Tootajad to TestUser

execute as user = 'ArendajaUser'
select * from Tootajad
update Tootajad set Palk = 5000 where Id = 1
revert

execute as user = 'AdminUser'
select * from Tootajad
update Tootajad set Palk = 5676 where Id = 1
delete from Tootajad where Id = 2
revert

