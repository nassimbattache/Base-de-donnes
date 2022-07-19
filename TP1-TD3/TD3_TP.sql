USE Companie_aerienne;
create database Companie_aerienne;

CREATE TABLE PILOTE(

PLNUM integer not null,
PLNOM varchar(30),
PLPRENOM varchar(30),
VILLE varchar(30),
SALAIRE integer,
constraint pk_plnum primary key(PLNUM)
);

CREATE TABLE AVION(

AVNUM integer not null,
AVNOM varchar(30),
CAPACITE integer,
LOCALISATION varchar(30),
constraint pk_avnum primary key(AVNUM)
);

CREATE TABLE VOL(

VOLNUM integer not null,
PLNUM integer,
AVNUM integer,
VILLEDEP varchar(30),
VILLEARR varchar(30),
HEUREDEP integer,
HEUREARR integer,
constraint pk_volnum primary key(VOLNUM),
constraint fg_plnum foreign key(PLNUM) references PILOTE(PLNUM),
constraint fg_avnum foreign key(AVNUM) references AVION(AVNUM)

);
--2/ Mise a jour de la base de donnees
--  Ajouter les enregistrements:
insert into VOL values(17,5,8,'Bordeaux','Clermont-Fd',12,13);

insert into VOL values(18,12,7,'Paris','Lille',11,12);


--Modifier le vol n°12 (VILLEDEP=’Lille’, HEUREARR= 17).
update VOL set VILLEDEP='Lille',HEUREARR=17 where VOLNUM=12;

--Supprimer le vol n°17
delete from VOL where VOLNUM=17;


--3 Interrogation de la base de données

--1---Liste de tous les vols.
select * from VOL;

--2---Nom, prénom et ville de tous les pilotes, par ordre alphabétique.
select PLNOM,PLPRENOM,VILLE from PILOTE order by PLNOM,PLPRENOM ASC;

--3---Nom, prénom et salaire des pilotes dont le salaire est supérieur à 20000.
select PLNOM,PLPRENOM,SALAIRE from PILOTE where SALAIRE >20000;

--4---Numéro et nom des avions localisés à Paris.
select AVNUM,AVNOM from AVION where LOCALISATION = 'Paris';

--5---Nom et prénom des pilotes dont le salaire est supérieur à un salaire plafond saisi au clavier (paramètre).
select PLNOM,PLPRENOM,SALAIRE from PILOTE where SALAIRE > '15000';
--6--- caractéristiques ( AVNUM, AVNOM, CAPACITE, LOCALISATION) des avions localisés dans la même ville qu’un
-------pilote dont le nom est saisi au clavier (paramètre).
select * from (AVION INNER JOIN (select VILLE from PILOTE where PLNOM = '&plnom') as P ON P.VILLE = AVION.LOCALISATION );
select * from (AVION INNER JOIN (select VILLE from PILOTE where PLNOM = 'block') as P ON P.VILLE = AVION.LOCALISATION );

---7--- caractéristiques (VOLNUM, VILLEDEP, VILLEARR, HEUREDEP, HEUREARR, AVNOM, PLNOM) d’un vol
---------dont le numéro est saisi au clavier (paramètre).
select VOLNUM,VILLEDEP,VILLEARR,HEUREDEP,HEUREARR,AVNOM,PLNOM from (select VOLNUM,VILLEDEP,VILLEARR,HEUREDEP,HEUREARR,PLNOM, AVNUM
from (select * from VOL where VOLNUM = '13') as V 
INNER JOIN PILOTE ON PILOTE.PLNUM = V.PLNUM) as T1 INNER JOIN AVION ON T1.AVNUM = AVION.AVNUM;

---8--Nom, prénom et numéro de vol des pilotes affectés à (au plus) un vol.
select PLNOM, PLPRENOM, VOLNUM from VOL INNER JOIN PILOTE ON PILOTE.PLNUM = VOL.PLNUM
where PILOTE.PLNUM IN (select VOL.PLNUM from VOL INNER JOIN PILOTE ON PILOTE.PLNUM = VOL.PLNUM group by VOL.PLNUM having COUNT(*) = 1);

--9--- Numéro et nom des avions affectés à des vols (éliminer les doublons).
select distinct vol.AVNUM,AVNOM from (vol inner join avion on vol.AVNUM =AVION.AVNUM);

--10--- Nombre total des vols.
select count(*) as nb from VOL;

---11-- Somme des capacités de tous les avions.
select sum(capacite) as total_cap from AVION;

--13---capacités minimales et maximales des avions.
select min(CAPACITE) as minimal, max(CAPACITE) as maximal from AVION;

---14--- Nombre total d’heures de vol, par pilote.
select PLNOM, sum(HEUREARR-HEUREDEP) as somme from VOL INNER JOIN PILOTE ON PILOTE.PLNUM=VOL.PLNUM group by PLNOM ;


---15-- Nombre total d’heures de vol, par avion.
select AVNOM, sum(HEUREARR-HEUREDEP)as somme from VOL INNER JOIN AVION ON AVION.AVNUM=VOL.AVNUM group by AVNOM;


---16-- pilote qui ont effectué plus de 3h de vol.
select PLNOM, sum(HEUREARR-HEUREDEP) as somme from VOL INNER JOIN PILOTE ON PILOTE.PLNUM=VOL.PLNUM group by PLNOM having sum(HEUREARR-HEUREDEP)>3 ;

---17-- avion qui ont effectué plus de 4h de vol.
select AVNOM, sum(HEUREARR-HEUREDEP)as somme from VOL INNER JOIN AVION ON AVION.AVNUM=VOL.AVNUM group by AVNOM having sum(HEUREARR-HEUREDEP)>2 ;
