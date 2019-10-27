/* thanks Deepak for the code */

PRAGMA foreign_keys=1;

DROP TABLE IF EXISTS [cityCodes];
DROP TABLE IF EXISTS [aux_cityCodes];

CREATE TABLE [cityCodes]
(
    [cityCode] NVARCHAR(5)  NOT NULL,
    CONSTRAINT [PKC_cityCodes] PRIMARY KEY  ([cityCode])
);

CREATE TABLE [aux_1_cityCodes]
(
    [cityCode] NVARCHAR(5)  NOT NULL,
    CONSTRAINT [PKC_aux_cityCodes] PRIMARY KEY  ([cityCode])
);

CREATE TABLE [aux_2_cityCodes]
(
    [cityCode] NVARCHAR(5)  NOT NULL,
    CONSTRAINT [PKC_aux_cityCodes] PRIMARY KEY  ([cityCode])
);

create trigger trig_copyInsertedCitycode_1 after insert on cityCodes
Begin
  insert into aux_1_cityCodes values (new.cityCode);
End;

create trigger trig_copyInsertedCitycode_2 after insert on cityCodes
when new.cityCode = (select 'c4')
Begin
  insert into aux_2_cityCodes values (new.cityCode);
End;


insert into cityCodes values("c1");
insert into cityCodes values("c2");
insert into cityCodes values("c3");
insert into cityCodes values("c4");

/* problem given to implement

create a database system containing atleast these two tables :-

input_LotNumberLimit - limit (Int)

aux_LotNumberDomain - lotNumber (Int)

problem specifications :-

if user inserts any number in table "input_LotNumberLimit" (for ex- say 5 ) then those many values has to be inserted on "aux_LotNumberDomain" (here -->1,2,3,4,5)

also again if user inserts say 2 in table "input_LotNumberLimit" then "aux_LotNumberDomain" should contain entries (1,2) only.

note - you can create additional tables if required but you are not allowed to use stored procedures

hint - think whether triggers can be of any use here. Also you can create multiple triggers on same table if required.

 */







