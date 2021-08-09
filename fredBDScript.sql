drop table Teams cascade constraints;
drop table Joga cascade constraints;
drop table Ranks cascade constraints;
drop table TypeOfRune cascade constraints;
drop table TypeOfMastery cascade constraints;
drop table Atributes cascade constraints;
drop table Items cascade constraints;
drop table Class cascade constraints;
drop table Resources cascade constraints;
drop table itemAtribute cascade constraints;
drop table Champions cascade constraints;
drop table TypeOfAbility cascade constraints;
drop table temAbility cascade constraints;
drop table Runes cascade constraints;
drop table Player cascade constraints;
drop table Masteries cascade constraints;
drop table temMasteries cascade constraints;
drop table temItem cascade constraints;

create table Teams(
IDTeam number(2) check(IDteam between 1 and 20),
name varchar2(20) not null,
primary key(IDTeam)
);


create table Joga(
idteam1 number(2) not null,
idteam2 number(2) not null,
primary key(idteam1,idteam2),
foreign key(idteam1) references Teams(IDTeam),
foreign key(idteam2) references Teams(IDTeam)
);


create table Ranks(
division varchar2(10),
primary key(division)
);


create table TypeOfRune(
typeRune varchar(15),
primary key(typeRune)
);


create table TypeOfMastery(
typeMastery varchar(20) ,
primary key(typeMastery)
);


create table Atributes(
typeAtribute varchar2(20) not null,
primary key(typeAtribute)
);


create table Items(
itemName varchar2(50),
price number(4) not null,
primary key(itemName)
);


create table Class(
className varchar2(20),
primary key(className)
);


create table Resources(
resourceType varchar2(10),
primary key(resourceType)
);


create table itemAtribute(
itemName varchar2(50) not null,
typeAtribute varchar2(20) not null,
value number(3) not null check(value between 0 and 100),
primary key(itemName,typeAtribute),
foreign key(itemName) references Items,
foreign key(typeAtribute) references Atributes
);

create table Champions(
championsName varchar2(20),
yearCreated varchar2(4) not null,
className varchar2(20) not null,
primary key(championsName),
foreign key(className) references Class
);


create table TypeOfAbility(
abilityType varchar2(20),
resourceType varchar2(10) not null,
primary key(abilityType),
foreign key(resourceType) references Resources
);


create table temAbility(
championName varchar2(20) not null,
abilityType varchar2(20) not null,
primary key(championName, abilityType),
foreign key(championName) references Champions,
foreign key(abilityType) references TypeOfAbility
);


create table Runes(
runeName varchar2(100),
typeRune varchar2(15) not null ,
value number(3) not null check(value between 0 and 100),
typeAtribute varchar(20) not null,
primary key(runeName),
foreign key(typeRune) references TypeOfRune,
foreign key(typeAtribute) references Atributes
);


create table Player(
userName varchar2(20),
levelPlayer number(2) not null check(levelPlayer between 1 and 30),
IDteam number(2) not null,
division varchar2(10) not null,
runeName varchar2(100) not null,
championName varchar2(20) not null,
gold number(5) not null,
primary key(userName),
foreign key(IDTeam) references Teams,
foreign key(division) references Ranks,
foreign key(runeName) references Runes,
foreign key(championName) references Champions
);


create table Masteries(
masteryName varchar2(50),
typeMastery varchar2(20) not null,
value number(3) not null check(value between 0 and 100),
typeAtribute varchar2(20) not null,
primary key(masteryName),
foreign key(typeMastery) references TypeOfMastery,
foreign key(typeAtribute) references Atributes
);


create table temMasteries(
userName varchar2(20) not null,
masteryName varchar2(50) not null,
primary key(userName,masteryName),
foreign key(userName) references Player,
foreign key(masteryName) references Masteries
);


create table temItem(
userName varchar2(20) not null,
itemName varchar2(50) not null,
primary key(userName,itemName),
foreign key(userName) references Player,
foreign key(itemName) references Items
);

/
create or replace trigger numberItem
before insert 
on temItem
for each row
declare
num number;
BEGIN
SELECT count(*) into num
FROM temItem T
WHERE T.USERNAME = :new.USERNAME;
if num + 1 > 6 then
Raise_Application_Error(-20100, 'Já tem 6 items');
end if;
END;
/

create or replace trigger lvlRank
before insert
on Player
for each row
BEGIN
if :new.levelPlayer < 30 and :new.Division != 'Unranked' then
Raise_Application_Error(-20100, 'O Jogador não tem nivel para o rank inserido');
end if;
END;
/


create or replace trigger menos5ability
before insert
on temAbility
for each row
declare
nums number;
BEGIN
SELECT count(A.championname) into nums
FROM temAbility A
WHERE A.CHAMPIONNAME = :new.CHAMPIONNAME;
if nums+1 < 5 then
DBMS_OUTPUT.PUT_LINE('Precisa de adicionar mais abilities se quiser ganhar');
elsif nums +1 > 5 then
Raise_Application_Error(-20100, 'Já tem cinco abilities');
end if;
END;
/

create or replace trigger numMasteries
before insert
on temMasteries
for each row
declare
nums number;
lvl number;
Begin
SELECT count(M.userName) into nums
FROM temMasteries M
WHERE M.USERNAME = :new.USERNAME;
SELECT P.LEVELPLAYER into lvl
FROM Player P
WHERE P.USERNAME = :new.USERNAME;
If nums+1 > lvl then 
Raise_Application_Error (-20100,'Não tem level suficiente.');
End if;
END;
/
    
create or replace trigger hasGold
before insert
on temItem
for each row
declare
goldUser number;
totalPrice number;
priceItem number;
BEGIN
SELECT P.gold into goldUser
FROM Player P
WHERE P.username = :new.USERNAME;
SELECT SUM(S.price) into totalPrice
FROM Items S natural inner join temItem T
WHERE T.username = :new.USERNAME;
SELECT price into priceItem
FROM Items I
WHERE I.itemname = :new.ITEMNAME;
if (priceItem + totalPrice) > goldUser then
Raise_Application_Error(-20100,'Sem gold insuficiente.');
end if;
END;
/
create or replace trigger cincoplayers
before insert
on Player
for each row
declare
nums number;
BEGIN
SELECT count(A.userName) into nums
FROM Player A
WHERE A.IDTeam = :new.IDTEAM;
if nums+1 < 5 then
DBMS_OUTPUT.PUT_LINE('Precisa de adicionar mais players se quiser ganhar');
elsif nums +1 > 5 then
Raise_Application_Error(-20100, 'Já tem cinco players');
end if;
END;
/





Create or replace trigger maxTeam
Before insert
On Teams
For each row
Declare
nums number;
Begin
Select count(*) into nums
From Teams;
If nums +1 > 20 then
Raise_Application_Error(-20100,'Já tem vinte equipas');
End if;
end;
/

insert into ranks values(
'Unranked');

insert into ranks values(
'Bronze');

insert into ranks values(
'Silver');

insert into ranks values(
'Gold');

insert into ranks values(
'Platinum');

insert into ranks values(
'Diamond');

insert into ranks values(
'Master');

insert into ranks values(
'Challenger');


insert into atributes values(
'Attack Damage');

insert into atributes values(
'Ability Power');

insert into atributes values(
'Armor');

insert into atributes values(
'Magic Resistance');

insert into atributes values(
'Attack Speed');

insert into atributes values(
'Armor Penetration');

insert into atributes values(
'Magic Penetration');

insert into atributes values(
'Cooldown Reduction');

insert into atributes values(
'Letality');

insert into atributes values(
'Health Regeneration');

insert into atributes values(
'Life steal');

insert into atributes values(
'Mana');

insert into atributes values(
'Movement speed');

insert into  Class values('Assassin');
insert into  Class values('Fighter');
insert into  Class values('Mage');
insert into  Class values('Support');
insert into  Class values('Tank');
insert into  Class values('Marksman');

insert into Resources values('Mana');
insert into Resources values('Health');
insert into Resources values('Fury');
insert into Resources values('Cooldown');
    
insert into Teams values(1, 'EquipaA');
insert into Teams values(2, 'EquipaB'); 
insert into Teams values(3, 'EquipaC');
insert into Teams values(4, 'EquipaD');


    
    
insert into TypeOfMastery values('Ferocity'); 
insert into TypeOfMastery values('Cunning');
insert into TypeOfMastery values('Resolve');

insert into TypeOfRune values('Quintessences');
insert into TypeOfRune values('Seals');
insert into TypeOfRune values('Marks');
insert into TypeOfRune values('Glyphs');
insert into TypeOfAbility values('Blast Shield', 'Mana');
insert into TypeOfAbility values('Blood Rush', 'Health');
insert into TypeOfAbility values('Boomerang Blade', 'Cooldown');
insert into TypeOfAbility values('Boulder Toss', 'Fury');
insert into TypeOfAbility values('Absolute Zero', 'Mana');
insert into TypeOfAbility values('Acceleration Gate', 'Cooldown');
insert into TypeOfAbility values('Adrenaline Rush', 'Health');
insert into TypeOfAbility values('Ambush', 'Mana');
insert into TypeOfAbility values('Berserker Rage','Fury');
insert into TypeOfAbility values('Blade Caller', 'Health');
insert into TypeOfAbility values('Blinding Dart', 'Fury');
insert into TypeOfAbility values('Body Slam', 'Health');

insert into Masteries values('Sorcery', 'Ferocity', 20, 'Attack Damage');
insert into Masteries values('Fresh Blood', 'Resolve', 10, 'Life steal');
insert into Masteries values('Natural Talent', 'Cunning', 50, 'Armor');
insert into Masteries values('Recovery', 'Resolve', 30, 'Health Regeneration');
insert into Masteries values('Feast', 'Ferocity', 37, 'Letality');
insert into Masteries values('Vampirism','Ferocity', 10, 'Life steal');
insert into Masteries values('Meditation', 'Cunning', 20, 'Cooldown Reduction');
insert into Masteries values('Swiftness', 'Cunning', 30, 'Movement speed');
insert into Masteries values('Merciless', 'Resolve', 30, 'Ability Power');
insert into Masteries values('Secret Stash', 'Ferocity', 30, 'Attack Speed');


insert into Runes values('Mark of Attack Damage', 'Marks', 5, 'Attack Damage');
insert into Runes values('Seal of Armor', 'Seals', 20, 'Armor');
insert into Runes values('Glyph of Mana', 'Glyphs', 10, 'Mana');
insert into Runes values('Quintessence of Attack Speed', 'Quintessences', 40, 'Attack Speed');
insert into Runes values('Glyph of Ability Power', 'Glyphs', 20, 'Ability Power');
insert into Runes values('Mark of Movement Speed', 'Marks', 70, 'Movement speed');
insert into Runes values('Seal of Health Regeneration', 'Seals', 21, 'Health Regeneration');
insert into Runes values('Quintessence of Life Steal', 'Quintessences', 10, 'Life steal');


insert into Champions values('Aatrox', 2009, 'Fighter');
insert into Champions values('Ahri', 2010, 'Mage');
insert into Champions values('Nautilus', 2014, 'Tank');
insert into Champions values('Zed', 2004, 'Assassin');
insert into Champions values('Ashe', 2008, 'Marksman');
insert into Champions values('Taric', 2012, 'Support');
insert into Champions values('Veigar', 2001, 'Mage');
insert into Champions values('Maokai', 2010, 'Tank');
insert into Champions values('Vayne', 2013, 'Marksman');

insert into Items values('Kindlegem', 1000);
insert into Items values('Phage', 1400);
insert into Items values('Trinity Force', 8000);
insert into Items values('Void Staff', 5600);
insert into Items values('Long Sword', 400);
insert into Items values('Tiamat', 3000);
insert into Items values('Ninja Tabi', 2500);
insert into Items values('Infinity Edge', 6000);
insert into Items values('Dorans Blade', 500);
insert into Items values('Randuins', 3500);
insert into Items values('Boots of Swiftness', 1500);
insert into Player values('Fred45', 3, 1, 'Unranked', 'Mark of Attack Damage', 'Aatrox', 20000);
insert into Player values('Manel5', 20, 1, 'Unranked', 'Mark of Attack Damage', 'Ahri', 10000);
insert into Player values('Ambrosio', 30, 1, 'Gold', 'Seal of Armor', 'Nautilus', 20000);
insert into Player values('Filipe4', 30, 2, 'Silver', 'Glyph of Mana', 'Ashe', 34000);
insert into Player values('China12', 17, 2, 'Unranked', 'Seal of Armor', 'Aatrox', 26000);
insert into Player values('Inacio', 5, 1, 'Unranked', 'Quintessence of Attack Speed', 'Ahri', 20000);
insert into Player values('Rui', 30, 1, 'Diamond', 'Quintessence of Life Steal', 'Zed', 30000);
insert into Player values('Miguel', 30, 2, 'Platinum', 'Seal of Health Regeneration', 'Maokai', 15000);
insert into Player values('Bruno', 30, 2, 'Bronze', 'Quintessence of Attack Speed', 'Vayne', 20000);
insert into Player values('Antonio', 30, 2, 'Challenger', 'Mark of Movement Speed', 'Veigar', 10000);
insert into temMasteries values('Fred45', 'Sorcery');
insert into temMasteries values('Fred45', 'Natural Talent');
insert into temMasteries values('Fred45', 'Recovery');
insert into temMasteries values('Ambrosio', 'Fresh Blood');
insert into temMasteries values('Ambrosio', 'Sorcery');
insert into temMasteries values('Filipe4', 'Sorcery');
insert into temMasteries values('China12', 'Natural Talent');
insert into temMasteries values('Inacio', 'Fresh Blood');
insert into temMasteries values('Manel5', 'Sorcery');
insert into temMasteries values('Rui', 'Meditation');
insert into temMasteries values('Rui', 'Feast');
insert into temMasteries values('Rui', 'Vampirism');
insert into temMasteries values('Rui', 'Sorcery');
insert into temMasteries values('Bruno', 'Merciless');
insert into temMasteries values('Bruno', 'Secret Stash');
insert into temMasteries values('Bruno', 'Fresh Blood');
insert into temMasteries values('Miguel', 'Sorcery');





insert into TypeOfAbility values('Brushmaker', 'Mana');

insert into temAbility values('Aatrox', 'Brushmaker');
insert into temAbility values('Aatrox', 'Blood Rush');
insert into temAbility values('Aatrox', 'Boomerang Blade');
insert into temAbility values('Aatrox', 'Blast Shield');
insert into temAbility values('Aatrox', 'Boulder Toss');
insert into temAbility values('Ahri', 'Brushmaker');
insert into temAbility values('Ahri', 'Blood Rush');
insert into temAbility values('Ahri', 'Boomerang Blade');
insert into temAbility values('Ahri', 'Blast Shield');
insert into temAbility values('Ahri', 'Boulder Toss');
insert into temAbility values('Nautilus', 'Brushmaker');
insert into temAbility values('Nautilus', 'Blood Rush');
insert into temAbility values('Nautilus', 'Boomerang Blade');
insert into temAbility values('Nautilus', 'Blast Shield');
insert into temAbility values('Nautilus', 'Boulder Toss');
insert into temAbility values('Ashe', 'Brushmaker');
insert into temAbility values('Ashe', 'Blood Rush');
insert into temAbility values('Ashe', 'Boomerang Blade');
insert into temAbility values('Ashe', 'Blast Shield');
insert into temAbility values('Ashe', 'Boulder Toss');
insert into temAbility values('Zed', 'Ambush');
insert into temAbility values('Zed', 'Acceleration Gate');
insert into temAbility values('Zed', 'Absolute Zero');
insert into temAbility values('Zed', 'Blast Shield');
insert into temAbility values('Zed', 'Boulder Toss');
insert into temAbility values('Taric', 'Body Slam');
insert into temAbility values('Taric', 'Blinding Dart');
insert into temAbility values('Taric', 'Blood Rush');
insert into temAbility values('Veigar', 'Blade Caller');
insert into temAbility values('Veigar', 'Berserker Rage');
insert into temAbility values('Veigar', 'Boomerang Blade');
insert into temAbility values('Veigar', 'Boulder Toss');
insert into temAbility values('Maokai', 'Boulder Toss');
insert into temAbility values('Maokai', 'Body Slam');
insert into temAbility values('Maokai', 'Blinding Dart');
insert into temAbility values('Maokai', 'Absolute Zero');
insert into temAbility values('Maokai', 'Berserker Rage');
insert into temAbility values('Vayne', 'Blade Caller');
insert into temAbility values('Vayne', 'Boomerang Blade');
insert into temAbility values('Vayne', 'Blood Rush');
insert into temAbility values('Vayne', 'Blinding Dart');
insert into temAbility values('Vayne', 'Acceleration Gate');
insert into temItem values('Fred45', 'Kindlegem');
insert into temItem values('Fred45', 'Trinity Force');
insert into temItem values('Ambrosio', 'Kindlegem');
insert into temItem values('Filipe4', 'Phage');
insert into temItem values('China12', 'Long Sword');
insert into temItem values('China12', 'Void Staff');
insert into temItem values('Rui', 'Infinity Edge');
insert into temItem values('Rui', 'Trinity Force');
insert into temItem values('Miguel', 'Dorans Blade');
insert into temItem values('Bruno', 'Randuins');
insert into temItem values('Antonio', 'Boots of Swiftness');
insert into temItem values('Antonio', 'Void Staff');
insert into temItem values('Bruno', 'Kindlegem');

insert into itemAtribute values('Kindlegem', 'Cooldown Reduction', 10);
insert into itemAtribute values('Kindlegem', 'Armor', 50);
insert into itemAtribute values('Trinity Force', 'Attack Damage', 40);
insert into itemAtribute values('Trinity Force', 'Attack Speed', 15);
insert into itemAtribute values('Trinity Force', 'Mana', 80);
insert into itemAtribute values('Trinity Force', 'Life steal', 50);
insert into itemAtribute values('Phage', 'Attack Damage', 45);
insert into itemAtribute values('Phage', 'Health Regeneration', 20);
insert into itemAtribute values('Long Sword', 'Letality', 25);
insert into itemAtribute values('Void Staff', 'Ability Power', 60);
insert into itemAtribute values('Void Staff', 'Magic Penetration', 35);
insert into itemAtribute values('Tiamat', 'Life steal', 45);
insert into itemAtribute values('Tiamat', 'Armor Penetration', 55);
insert into itemAtribute values('Ninja Tabi', 'Armor', 15);
insert into itemAtribute values('Ninja Tabi', 'Movement speed', 20);
insert into itemAtribute values('Infinity Edge', 'Attack Damage', 60);
insert into itemAtribute values('Infinity Edge', 'Letality', 10);
insert into itemAtribute values('Randuins', 'Armor', 40);
insert into itemAtribute values('Randuins', 'Movement speed', 20);
insert into itemAtribute values('Randuins', 'Health Regeneration', 30);
insert into itemAtribute values('Boots of Swiftness', 'Movement speed', 40);
insert into itemAtribute values('Dorans Blade', 'Life steal', 5);
insert into itemAtribute values('Dorans Blade', 'Attack Damage', 10);

insert into joga values(1, 2);
insert into joga values(2, 3);
insert into joga values(3, 1);
insert into joga values(4, 2);
