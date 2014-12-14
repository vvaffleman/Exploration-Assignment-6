DROP SCHEMA IF EXISTS risk CASCADE;
CREATE SCHEMA risk;

SET SEARCH_PATH = risk;
--Player is a dynamic table updated at the begining of the game or creation of the game in the lobby
DROP TABLE IF EXISTS game;
CREATE TABLE game(
  gid SERIAL NOT NULL,
  num_players INT NOT NULL,
  name VARCHAR(20) NOT NULL,
  in_prog BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY(gid)
);
--User_information table
DROP TABLE IF EXISTS users;
CREATE TABLE users(
  username VARCHAR(25) NOT NULL,
  fname VARCHAR(25) NOT NULL,
  lname VARCHAR(25) NOT NULL,
  registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  gid int REFERENCES game(gid),
  host BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(username)
);
--User password information table
DROP TABLE IF EXISTS hashed;
CREATE TABLE hashed(
  username VARCHAR(25) REFERENCES users(username) NOT NULL,
  hashed_pw TEXT NOT NULL,
  salt TEXT NOT NULL,
  PRIMARY KEY(username)
);
--The player table in game.
DROP TABLE IF EXISTS player;
CREATE TABLE player(
  pid SERIAL NOT NULL,
  name VARCHAR(15) NOT NULL,
  color VARCHAR(10) NOT NULL,
  num_cards integer NOT NULL,
  num_ter int NOT NULL,
  num_cont int NOT NULL,
  gid int References game(gid) ON DELETE CASCADE,
  PRIMARY KEY(pid)
);
--Static elements in this table as well as dynamic ones
DROP TABLE IF EXISTS continents;
CREATE TABLE continents(
  cid SERIAL NOT NULL,
  name VARCHAR NOT NULL,
  bonus int NOT NULL,
  pid int references player(pid),
  gid int References game(gid) ON DELETE CASCADE,
  PRIMARY KEY(cid)
);
--static elements in this table as well as dynamic ones
DROP TABLE IF EXISTS territories;
CREATE TABLE territories(
  tid SERIAL NOT NULL,
  name VARCHAR(40) NOT NULL,
  troops int NOT NULL,
  pid int references player(pid),
  cid int references continents(cid) NOT NULL,
  gid int References game(gid) ON DELETE CASCADE,
  PRIMARY KEY(tid)
);
--Static table, all territories and their conections
DROP TABLE IF EXISTS neighbors;
CREATE TABLE neighbors(
  tid int references territories(tid) NOT NULL,
  nid int NOT NULL
);
--Static Table, all the cards that will be used in the game
DROP TABLE IF EXISTS cards;
CREATE TABLE cards(
  card_id SERIAL NOT NULL,
  type VARCHAR(10),
  tid int references territories(tid),
  PRIMARY KEY(card_id)
);
--Entirely Dynamic table for keeping track of which player has what card.
DROP TABLE IF EXISTS cards_in_play;
CREATE TABLE cards_in_play(
  pid int REFERENCES player(pid) ON DELETE CASCADE,
  card_id int REFERENCES cards(card_id),
  gid int References game(gid) ON DELETE CASCADE
);

--These statements insert the continents into the database.
INSERT INTO continents(name, bonus, pid) VALUES('North America', '5', NULL);
INSERT INTO continents(name, bonus, pid) VALUES('South America', '2', NULL);
INSERT INTO continents(name, bonus, pid) VALUES('Europe', '5', NULL);
INSERT INTO continents(name, bonus, pid) VALUES('Asia', '7', NULL);
INSERT INTO continents(name, bonus, pid) VALUES('Africa', '3', NULL);
INSERT INTO continents(name, bonus, pid) VALUES('Australia', '2', NULL);

--Inserts the individual terriroies into the database.
--North America
INSERT INTO territories(name, troops, cid) VALUES('Western United States','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Eastern United States','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Central America','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Alberta','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Ontario','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Quebec','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Greenland','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Northwest Territory','0','1');
INSERT INTO territories(name, troops, cid) VALUES('Alaska','0','1');
--South America
INSERT INTO territories(name, troops, cid) VALUES('Venezuela','0','2');
INSERT INTO territories(name, troops, cid) VALUES('Brazil','0','2');
INSERT INTO territories(name, troops, cid) VALUES('Argentina','0','2');
--Europe
INSERT INTO territories(name, troops, cid) VALUES('Iceland','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Great Britain','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Scandinavia','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Western Europe','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Northern Europe','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Southern Europe','0','3');
INSERT INTO territories(name, troops, cid) VALUES('Ukraine','0','3');
--Asia
INSERT INTO territories(name, troops, cid) VALUES('Russia','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Afghanistan','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Middle East','0','4');
INSERT INTO territories(name, troops, cid) VALUES('India','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Siam','0','4');
INSERT INTO territories(name, troops, cid) VALUES('China','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Mongolia','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Siberia','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Yakutsk','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Irkutsk','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Kamchatka','0','4');
INSERT INTO territories(name, troops, cid) VALUES('Japan','0','4');
--Africa
INSERT INTO territories(name, troops, cid) VALUES('North Africa','0','5');
INSERT INTO territories(name, troops, cid) VALUES('Egypt','0','5');
INSERT INTO territories(name, troops, cid) VALUES('Congo','0','5');
INSERT INTO territories(name, troops, cid) VALUES('East Africa','0','5');
INSERT INTO territories(name, troops, cid) VALUES('South Africa','0','5');
INSERT INTO territories(name, troops, cid) VALUES('Madagascar','0','5');
--Australia
INSERT INTO territories(name, troops, cid) VALUES('Indonesia','0','6');
INSERT INTO territories(name, troops, cid) VALUES('New Guinea','0','6');
INSERT INTO territories(name, troops, cid) VALUES('Western Australia','0','6');
INSERT INTO territories(name, troops, cid) VALUES('Eastern Australia','0','6');
INSERT INTO territories(name, troops, cid) VALUES('LotR','0','6');

--This section will insert all the bordering countries into neighbors table
--Western United States Neighbors
INSERT INTO neighbors(tid, nid) VALUES('1','2');
INSERT INTO neighbors(tid, nid) VALUES('1','3');
INSERT INTO neighbors(tid, nid) VALUES('1','4');
INSERT INTO neighbors(tid, nid) VALUES('1','5');
--Eastern United States Neighbors
INSERT INTO neighbors(tid, nid) VALUES('2','1');
INSERT INTO neighbors(tid, nid) VALUES('2','5');
INSERT INTO neighbors(tid, nid) VALUES('2','6');
--Central America
INSERT INTO neighbors(tid, nid) VALUES('3','1');
INSERT INTO neighbors(tid, nid) VALUES('3','10');
--Alberta
INSERT INTO neighbors(tid, nid) VALUES('4','1');
INSERT INTO neighbors(tid, nid) VALUES('4','5');
INSERT INTO neighbors(tid, nid) VALUES('4','8');
INSERT INTO neighbors(tid, nid) VALUES('4','9');
--Ontario
INSERT INTO neighbors(tid, nid) VALUES('5','4');
INSERT INTO neighbors(tid, nid) VALUES('5','7');
INSERT INTO neighbors(tid, nid) VALUES('5','6');
INSERT INTO neighbors(tid, nid) VALUES('5','8');
--Quebec
INSERT INTO neighbors(tid, nid) VALUES('6','5');
INSERT INTO neighbors(tid, nid) VALUES('6','7');
INSERT INTO neighbors(tid, nid) VALUES('6','2');
--Greenland
INSERT INTO neighbors(tid, nid) VALUES('7','6');
INSERT INTO neighbors(tid, nid) VALUES('7','5');
INSERT INTO neighbors(tid, nid) VALUES('7','8');
INSERT INTO neighbors(tid, nid) VALUES('7','13');
--Northwest Territory
INSERT INTO neighbors(tid, nid) VALUES('8','4');
INSERT INTO neighbors(tid, nid) VALUES('8','9');
INSERT INTO neighbors(tid, nid) VALUES('8','5');
INSERT INTO neighbors(tid, nid) VALUES('8','7');
--Alaska
INSERT INTO neighbors(tid, nid) VALUES('9','8');
INSERT INTO neighbors(tid, nid) VALUES('9','4');
INSERT INTO neighbors(tid, nid) VALUES('9','30');
--Venezuela
INSERT INTO neighbors(tid, nid) VALUES('10','3');
INSERT INTO neighbors(tid, nid) VALUES('10','11');
INSERT INTO neighbors(tid, nid) VALUES('10','12');
--Brazil
INSERT INTO neighbors(tid, nid) VALUES('11','10');
INSERT INTO neighbors(tid, nid) VALUES('11','12');
INSERT INTO neighbors(tid, nid) VALUES('11','32');
--Argentina
INSERT INTO neighbors(tid, nid) VALUES('12','10');
INSERT INTO neighbors(tid, nid) VALUES('12','11');
--Iceland
INSERT INTO neighbors(tid, nid) VALUES('13','7');
INSERT INTO neighbors(tid, nid) VALUES('13','14');
--Great Britain
INSERT INTO neighbors(tid, nid) VALUES('14','13');
INSERT INTO neighbors(tid, nid) VALUES('14','15');
INSERT INTO neighbors(tid, nid) VALUES('14','16');
INSERT INTO neighbors(tid, nid) VALUES('14','17');
--Scandinavia
INSERT INTO neighbors(tid, nid) VALUES('15','14');
INSERT INTO neighbors(tid, nid) VALUES('15','19');
--Western Europe
INSERT INTO neighbors(tid, nid) VALUES('16','14');
INSERT INTO neighbors(tid, nid) VALUES('16','17');
INSERT INTO neighbors(tid, nid) VALUES('16','18');
INSERT INTO neighbors(tid, nid) VALUES('16','32');
--Northern Europe
INSERT INTO neighbors(tid, nid) VALUES('17','14');
INSERT INTO neighbors(tid, nid) VALUES('17','16');
INSERT INTO neighbors(tid, nid) VALUES('17','18');
INSERT INTO neighbors(tid, nid) VALUES('17','19');
--Southern Europe
INSERT INTO neighbors(tid, nid) VALUES('18','32');
INSERT INTO neighbors(tid, nid) VALUES('18','33');
INSERT INTO neighbors(tid, nid) VALUES('18','17');
INSERT INTO neighbors(tid, nid) VALUES('18','16');
INSERT INTO neighbors(tid, nid) VALUES('18','19');
--Ukraine
INSERT INTO neighbors(tid, nid) VALUES('19','22');
INSERT INTO neighbors(tid, nid) VALUES('19','20');
INSERT INTO neighbors(tid, nid) VALUES('19','21');
INSERT INTO neighbors(tid, nid) VALUES('19','15');
INSERT INTO neighbors(tid, nid) VALUES('19','17');
INSERT INTO neighbors(tid, nid) VALUES('19','18');
--Russia
INSERT INTO neighbors(tid, nid) VALUES('20','19');
INSERT INTO neighbors(tid, nid) VALUES('20','21');
INSERT INTO neighbors(tid, nid) VALUES('20','27');
--Afghanistan
INSERT INTO neighbors(tid, nid) VALUES('21','23');
INSERT INTO neighbors(tid, nid) VALUES('21','25');
INSERT INTO neighbors(tid, nid) VALUES('21','27');
INSERT INTO neighbors(tid, nid) VALUES('21','20');
INSERT INTO neighbors(tid, nid) VALUES('21','22');
INSERT INTO neighbors(tid, nid) VALUES('21','19');
--Middle East
INSERT INTO neighbors(tid, nid) VALUES('22','21');
INSERT INTO neighbors(tid, nid) VALUES('22','33');
INSERT INTO neighbors(tid, nid) VALUES('22','23');
INSERT INTO neighbors(tid, nid) VALUES('22','19');
--India
INSERT INTO neighbors(tid, nid) VALUES('23','22');
INSERT INTO neighbors(tid, nid) VALUES('23','24');
INSERT INTO neighbors(tid, nid) VALUES('23','25');
INSERT INTO neighbors(tid, nid) VALUES('23','21');
--Siam
INSERT INTO neighbors(tid, nid) VALUES('24','25');
INSERT INTO neighbors(tid, nid) VALUES('24','23');
INSERT INTO neighbors(tid, nid) VALUES('24','38');
--China
INSERT INTO neighbors(tid, nid) VALUES('25','24');
INSERT INTO neighbors(tid, nid) VALUES('25','23');
INSERT INTO neighbors(tid, nid) VALUES('25','21');
INSERT INTO neighbors(tid, nid) VALUES('25','27');
INSERT INTO neighbors(tid, nid) VALUES('25','26');
--Mongolia
INSERT INTO neighbors(tid, nid) VALUES('26','31');
INSERT INTO neighbors(tid, nid) VALUES('26','25');
INSERT INTO neighbors(tid, nid) VALUES('26','27');
INSERT INTO neighbors(tid, nid) VALUES('26','29');
INSERT INTO neighbors(tid, nid) VALUES('26','30');
--Siberia
INSERT INTO neighbors(tid, nid) VALUES('27','20');
INSERT INTO neighbors(tid, nid) VALUES('27','21');
INSERT INTO neighbors(tid, nid) VALUES('27','25');
INSERT INTO neighbors(tid, nid) VALUES('27','26');
INSERT INTO neighbors(tid, nid) VALUES('27','28');
INSERT INTO neighbors(tid, nid) VALUES('27','29');
--Yakutsk
INSERT INTO neighbors(tid, nid) VALUES('28','30');
INSERT INTO neighbors(tid, nid) VALUES('28','29');
INSERT INTO neighbors(tid, nid) VALUES('28','27');
--Irkutsk
INSERT INTO neighbors(tid, nid) VALUES('29','30');
INSERT INTO neighbors(tid, nid) VALUES('29','28');
INSERT INTO neighbors(tid, nid) VALUES('29','26');
INSERT INTO neighbors(tid, nid) VALUES('29','27');
--Kamchatka
INSERT INTO neighbors(tid, nid) VALUES('30','28');
INSERT INTO neighbors(tid, nid) VALUES('30','29');
INSERT INTO neighbors(tid, nid) VALUES('30','26');
INSERT INTO neighbors(tid, nid) VALUES('30','31');
INSERT INTO neighbors(tid, nid) VALUES('30','9');
--Japan
INSERT INTO neighbors(tid, nid) VALUES('31','26');
INSERT INTO neighbors(tid, nid) VALUES('31','30');
--North Africa
INSERT INTO neighbors(tid, nid) VALUES('32','11');
INSERT INTO neighbors(tid, nid) VALUES('32','16');
INSERT INTO neighbors(tid, nid) VALUES('32','18');
INSERT INTO neighbors(tid, nid) VALUES('32','33');
--Egypt
INSERT INTO neighbors(tid, nid) VALUES('33','32');
INSERT INTO neighbors(tid, nid) VALUES('33','18');
INSERT INTO neighbors(tid, nid) VALUES('33','34');
INSERT INTO neighbors(tid, nid) VALUES('33','35');
INSERT INTO neighbors(tid, nid) VALUES('33','22');
--Congo
INSERT INTO neighbors(tid, nid) VALUES('34','35');
INSERT INTO neighbors(tid, nid) VALUES('34','36');
INSERT INTO neighbors(tid, nid) VALUES('34','32');
INSERT INTO neighbors(tid, nid) VALUES('34','33');
--East Africa
INSERT INTO neighbors(tid, nid) VALUES('35','34');
INSERT INTO neighbors(tid, nid) VALUES('35','36');
INSERT INTO neighbors(tid, nid) VALUES('35','37');
INSERT INTO neighbors(tid, nid) VALUES('35','33');
--South Africa
INSERT INTO neighbors(tid, nid) VALUES('36','34');
INSERT INTO neighbors(tid, nid) VALUES('36','35');
INSERT INTO neighbors(tid, nid) VALUES('36','37');
--Madagascar
INSERT INTO neighbors(tid, nid) VALUES('37','36');
INSERT INTO neighbors(tid, nid) VALUES('37','35');
--Indonesia
INSERT INTO neighbors(tid, nid) VALUES('38','24');
INSERT INTO neighbors(tid, nid) VALUES('38','39');
INSERT INTO neighbors(tid, nid) VALUES('38','40');
--New Guinea
INSERT INTO neighbors(tid, nid) VALUES('39','38');
INSERT INTO neighbors(tid, nid) VALUES('39','40');
INSERT INTO neighbors(tid, nid) VALUES('39','41');
--Western Australia
INSERT INTO neighbors(tid, nid) VALUES('40','41');
INSERT INTO neighbors(tid, nid) VALUES('40','38');
INSERT INTO neighbors(tid, nid) VALUES('40','39');
--Eastern Australia
INSERT INTO neighbors(tid, nid) VALUES('41','40');
INSERT INTO neighbors(tid, nid) VALUES('41','42');
INSERT INTO neighbors(tid, nid) VALUES('41','39');
--LotR
INSERT INTO neighbors(tid, nid) VALUES('42','41');


--This Section of Code will insert the cards into the table.
INSERT INTO cards(type, tid) VALUES('Cannon','1'); --Western U.S
INSERT INTO cards(type, tid) VALUES('Cannon','2'); --Eastern U.S
INSERT INTO cards(type, tid) VALUES('Soldier','3'); --Central America
INSERT INTO cards(type, tid) VALUES('Cannon','4'); --Alberta
INSERT INTO cards(type, tid) VALUES('Cannon','5'); --Ontario
INSERT INTO cards(type, tid) VALUES('Cannon','6'); --Quebec
INSERT INTO cards(type, tid) VALUES('Horse','7'); --Greanland
INSERT INTO cards(type, tid) VALUES('Horse','8'); --Northwest Territory
INSERT INTO cards(type, tid) VALUES('Cannon','9'); --Alaska
INSERT INTO cards(type, tid) VALUES('Horse','10'); --Venezuela
INSERT INTO cards(type, tid) VALUES('Soldier','11'); --Brazil
INSERT INTO cards(type, tid) VALUES('Soldier','12'); --Argentina
INSERT INTO cards(type, tid) VALUES('Horse','13'); --Iceland
INSERT INTO cards(type, tid) VALUES('Soldier','14'); --Great Britain
INSERT INTO cards(type, tid) VALUES('Soldier','15'); --Scandinavia
INSERT INTO cards(type, tid) VALUES('Soldier','16'); --Western Europe
INSERT INTO cards(type, tid) VALUES('Horse','17'); --Northern Europe
INSERT INTO cards(type, tid) VALUES('Soldier','18'); --Southern Europe
INSERT INTO cards(type, tid) VALUES('Soldier','19'); --Ukraine
INSERT INTO cards(type, tid) VALUES('Horse','20'); --Russia
INSERT INTO cards(type, tid) VALUES('Soldier','21'); --Afghanistan
INSERT INTO cards(type, tid) VALUES('Cannon','22'); --Middle East
INSERT INTO cards(type, tid) VALUES('Soldier','23'); -- India
INSERT INTO cards(type, tid) VALUES('Cannon','24'); --Siam
INSERT INTO cards(type, tid) VALUES('Horse','25'); --China
INSERT INTO cards(type, tid) VALUES('Cannon','26'); --Mongolia
INSERT INTO cards(type, tid) VALUES('Cannon','27'); --Siberia
INSERT INTO cards(type, tid) VALUES('Horse','28'); --Yakutsk
INSERT INTO cards(type, tid) VALUES('Soldier','29'); --Irkutsk
INSERT INTO cards(type, tid) VALUES('Horse','30'); --Kamchatka
INSERT INTO cards(type, tid) VALUES('Soldier','31'); --Japan
INSERT INTO cards(type, tid) VALUES('Soldier','32'); --North Africa
INSERT INTO cards(type, tid) VALUES('Soldier','33'); --Egypt
INSERT INTO cards(type, tid) VALUES('Horse','34'); --Congo
INSERT INTO cards(type, tid) VALUES('Cannon','35'); --East Africa
INSERT INTO cards(type, tid) VALUES('Cannon','36');--South Africa
INSERT INTO cards(type, tid) VALUES('Soldier','37'); --Madagascar
INSERT INTO cards(type, tid) VALUES('Horse','38'); --Indonesia
INSERT INTO cards(type, tid) VALUES('Horse','39'); --New Guinea
INSERT INTO cards(type, tid) VALUES('Cannon','40'); --Western Australia
INSERT INTO cards(type, tid) VALUES('Soldier','41'); --Eastern Australia
INSERT INTO cards(type, tid) VALUES('Horse','42');--LotR
INSERT INTO cards(type, tid) VALUES('Wild',NULL);
INSERT INTO cards(type, tid) VALUES('Wild',NULL);
