/*

if we need to insert very large number of records, then it takes quite a bit of time to insert these records in sqlite3.
we can improve the performance very much by setting few pragmas

http://www.sqlite.org/pragma.html
*/
PRAGMA foreign_keys=0; /* foreign key check is set to off */
PRAGMA cache_size=10000; /* speeds up operations much */
PRAGMA synchronous = OFF; /* don't need to wait for OS signals */
PRAGMA journal_mode = MEMORY; 

/*
before creating new schema, drop any tables that may already exist
*/

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS ryearTypes;
DROP TABLE IF EXISTS rsnTypes;
DROP TABLE IF EXISTS rccodeTypes;
DROP TABLE IF EXISTS ageTypes;
DROP TABLE IF EXISTS gradeTypes;

BEGIN TRANSACTION; /* this will also add to speed up in our large operation */

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS students (
  ryear INT NOT NULL,
  rsn varchar(2) NOT NULL,
  rccode varchar(1) NOT NULL,
  fname text NOT NULL,
  mname text,
  lname text NOT NULL,
  age INT NOT NULL,
  grade varchar(1) NOT NULL,
  CONSTRAINT pkc_students Primary Key(ryear,rsn,rccode),
  Foreign Key (age) References ageTypes(ageType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (grade) References gradeTypes(gradeType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (ryear) References ryearTypes(ryearType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (rsn) References rsnTypes(rsnType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (rccode) References rccodeTypes(rccodeType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT cc_minLengthFname CHECK (LENGTH(fname) > 3),
  CONSTRAINT cc_minLengthLname CHECK (LENGTH(lname) > 3)
);

CREATE TABLE IF NOT EXISTS studentResults (
  ryear INT NOT NULL,
  rsn varchar(2) NOT NULL,
  rccode varchar(1) NOT NULL,
  subject text NOT NULL,
  grade varchar(1) NOT NULL,
  CONSTRAINT pkc_students Primary Key(ryear,rsn,rccode,subject),
  Foreign Key (grade) References gradeTypes(gradeType)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (ryear,rsn,rccode) References students(ryearType,rsnType,rccodeType)
  ON DELETE RESTRICT ON UPDATE CASCADE
);
/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS ryearTypes (
  ryearType INT NOT NULL,
  CONSTRAINT pkc_ryearTypes Primary Key(ryearType)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS rsnTypes (
  rsnType varchar(2) NOT NULL,
  CONSTRAINT pkc_rsnTypes Primary Key(rsnType)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS rccodeTypes (
  rccodeType INT NOT NULL,
  CONSTRAINT pkc_rccodeTypes Primary Key(rccodeType)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS ageTypes (
  ageType INT NOT NULL,
  CONSTRAINT pkc_ageTypes Primary Key(ageType)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS gradeTypes (
  gradeType varchar(1) NOT NULL,
  CONSTRAINT pkc_gradeTypes Primary Key(gradeType),
  CONSTRAINT cc_gradeType CHECK (gradeType in ('O','A','B','C','D','F'))
);

/* ---------------------------------------------------------  */


INSERT INTO [gradeTypes] ([gradeType]) VALUES ('O');
INSERT INTO [gradeTypes] ([gradeType]) VALUES ('A');
INSERT INTO [gradeTypes] ([gradeType]) VALUES ('B');
INSERT INTO [gradeTypes] ([gradeType]) VALUES ('C');
INSERT INTO [gradeTypes] ([gradeType]) VALUES ('D');
INSERT INTO [gradeTypes] ([gradeType]) VALUES ('F');

INSERT INTO [ageTypes] ([ageType]) VALUES (20);
INSERT INTO [ageTypes] ([ageType]) VALUES (21);
INSERT INTO [ageTypes] ([ageType]) VALUES (22);
INSERT INTO [ageTypes] ([ageType]) VALUES (23);
INSERT INTO [ageTypes] ([ageType]) VALUES (24);

INSERT INTO [rccodeTypes] ([rccodeType]) VALUES ('C'); /* mca */
INSERT INTO [rccodeTypes] ([rccodeType]) VALUES ('S'); /* msc */
INSERT INTO [rccodeTypes] ([rccodeType]) VALUES ('T'); /* mtech */

INSERT INTO [ryearTypes] ([ryearType]) VALUES (2012);
INSERT INTO [ryearTypes] ([ryearType]) VALUES (2013);
INSERT INTO [ryearTypes] ([ryearType]) VALUES (2014);
INSERT INTO [ryearTypes] ([ryearType]) VALUES (2015);
INSERT INTO [ryearTypes] ([ryearType]) VALUES (2016);
INSERT INTO [ryearTypes] ([ryearType]) VALUES (2017);

INSERT INTO [rsnTypes] ([rsnType]) VALUES ('01');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('02');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('03');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('04');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('05');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('06');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('07');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('08');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('09');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('10');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('11');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('12');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('13');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('14');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('15');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('16');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('17');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('18');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('19');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('20');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('21');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('22');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('23');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('24');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('25');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('26');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('27');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('28');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('29');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('30');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('31');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('32');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('33');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('34');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('35');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('36');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('37');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('38');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('39');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('40');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('41');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('42');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('43');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('44');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('45');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('46');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('47');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('48');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('49');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('50');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('51');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('52');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('53');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('54');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('55');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('56');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('57');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('58');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('59');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('60');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('61');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('62');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('63');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('64');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('65');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('66');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('67');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('68');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('69');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('70');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('71');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('72');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('73');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('74');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('75');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('76');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('77');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('78');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('79');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('80');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('81');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('82');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('83');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('84');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('85');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('86');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('87');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('88');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('89');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('90');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('91');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('92');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('93');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('94');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('95');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('96');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('97');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('98');
INSERT INTO [rsnTypes] ([rsnType]) VALUES ('99');

END TRANSACTION;


PRAGMA foreign_keys=1; 


PRAGMA cache_size=10000;


PRAGMA synchronous = ON;


PRAGMA journal_mode = PERSIST; 

