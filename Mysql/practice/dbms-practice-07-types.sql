
/* rules for database */
/* 1> abstract,concrete data type wise validation of default value  of a property.*/
/* 2> sequence numbers for every validation rule should start at 1 and increment by  1 without gaps. */
/* 3> student should add at least 2 leaf types to the student assigned. */
/* 3.1> for each of the newly added type for the student must associate all the compulsory properties alongwith proper default values. */
/*3.2> for each of newly added type the student must create at least 5 properties & should fill proper default values. */

/*
 
DROP DATABASE IF EXISTS productTypeDb;

CREATE DATABASE productTypeDb;

use productTypeDb;
 */


DROP TABLE IF EXISTS productTypes;
DROP TABLE IF EXISTS productTypeHierarchy;
DROP TABLE IF EXISTS productTypePropertyTypes;
DROP TABLE IF EXISTS productTypePropertyTypeContainer;
DROP TABLE IF EXISTS requiredProductTypeProperties;
DROP TABLE IF EXISTS productTypePropertyTypeValidationValues;
DROP TABLE IF EXISTS productTypePropertyTypeValueTypes;
DROP TABLE IF EXISTS productTypePropertyTypeValidationTypes;
DROP TABLE IF EXISTS abstractProductTypePropertyValueTypeTypes;
DROP TABLE IF EXISTS concreteSQLProductTypePropertyValueTypeDataTypes;


CREATE TABLE productTypes (
  rollNo varchar(5) NOT NULL,
  productTypeId varchar(255) NOT NULL,
  typeName text NOT NULL,
  typeUrl text,
  Constraint pk_productTypes primary key( productTypeId),
  Foreign Key(rollNo) References students(rollNo)
  ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE productTypeHierarchy (
  rollNo varchar(5) NOT NULL,
  superProductTypeId varchar(25) NOT NULL,
  subProductTypeId varchar(25) NOT NULL,
  Constraint pk_typeHierarchy primary key(rollNo,superProductTypeId,subProductTypeId),
  Foreign Key(superProductTypeId) References productTypes(productTypeId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollNo) References students(rollNo)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(subProductTypeId) References  productTypes(productTypeId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE productTypePropertyTypes (
  rollNo varchar(5) NOT NULL,
  productTypePropertyTypeId varchar(255) NOT NULL,
  productTypePropertyTypeName text NOT NULL,
  productTypePropertyTypeRemark text,
  Constraint pk_productTypePropertyTypes primary key(productTypePropertyTypeId),
  Foreign Key(rollNo) References students(rollNo)
  ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE productTypePropertyTypeContainer (
   rollNo varchar(5) NOT NULL,
   parentProductTypePropertyTypeId varchar(255) NOT NULL,
   childProductTypePropertyTypeId varchar(255) NOT NULL,
   sequenceNumber varchar(25) NOT NULL,
   Constraint pk_productTypePropertyTypeHierarchy primary key(parentProductTypePropertyTypeId,childProductTypePropertyTypeId),
   Foreign Key(rollNo) References students(rollNo)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(parentProductTypePropertyTypeId) References productTypePropertyTypes(productTypePropertyTypeId)
   ON DELETE RESTRICT ON UPDATE  CASCADE,
   Foreign Key(childProductTypePropertyTypeId) References productTypePropertyTypes(productTypePropertyTypeId)
   ON DELETE RESTRICT ON UPDATE  CASCADE
);

CREATE TABLE requiredProductTypeProperties (
  rollNo varchar(5) NOT NULL,
  productTypeId varchar(25) NOT NULL,
  productTypePropertyTypeId varchar(255) NOT NULL,
  productTypePropertyDefaultValue text NOT NULL,
  Constraint pk_requiredProductTypeProperties primary key(productTypeId,productTypePropertyTypeId),
  Foreign Key(productTypeId) References  productTypes(productTypeId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollNo) References students(rollNo)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(productTypePropertyTypeId) References  productTypePropertyTypes(productTypePropertyTypeId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);




CREATE TABLE abstractProductTypePropertyValueTypeTypes (
  abstractProductTypePropertyValueTypeTypeId varchar(255) NOT NULL,
  abstractProductTypePropertyValueTypeTypeInfo text,
  Constraint pk_abstractProductTypePropertyValueTypeTypeInfo primary key(abstractProductTypePropertyValueTypeTypeId)
);


CREATE TABLE concreteSQLProductTypePropertyValueTypeDataTypes (
   concreteSQLProductTypePropertyValueTypeDataTypeId varchar(255) NOT NULL,
   concreteSQLProductTypePropertyValueTypeDataTypeInfo text,
   Constraint pk_abstractProductTypePropertyValueTypeTypeInfo primary key(concreteSQLProductTypePropertyValueTypeDataTypeId)
);




CREATE TABLE productTypePropertyTypeValidationTypes (
   rollNo varchar(5) NOT NULL,
   productTypePropertyTypeValidationTypeId varchar(255) NOT NULL,
   abstractProductTypePropertyValueTypeTypeId varchar(255) NOT NULL,
   concreteSQLProductTypePropertyValueTypeDataTypeId varchar(255) NOT NULL,
   Constraint pk_productTypePropertyTypeValidationTypes primary key(productTypePropertyTypeValidationTypeId),
   Foreign Key(rollNo) References students(rollNo)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(abstractProductTypePropertyValueTypeTypeId) References  abstractProductTypePropertyValueTypeTypes(abstractProductTypePropertyValueTypeTypeId)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(concreteSQLProductTypePropertyValueTypeDataTypeId) References concreteSQLProductTypePropertyValueTypeDataTypes(concreteSQLProductTypePropertyValueTypeDataTypeId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE productTypePropertyTypeValueTypes (
   rollNo varchar(5) NOT NULL,
   productTypeId varchar(25) NOT NULL,
   productTypePropertyTypeId varchar(255) NOT NULL,
   productTypePropertyTypeUnit varchar(255) NOT NULL,
   productTypePropertyTypeValidationId varchar(255) NOT NULL,
   Constraint pk_productTypePropertyTypeValueTypes primary key(productTypeId,productTypePropertyTypeId),
   CONSTRAINT productTypePropertyTypeValueTypes_unique UNIQUE (productTypePropertyTypeValidationId),
   Foreign Key(rollNo) References students(rollNo)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(productTypeId,productTypePropertyTypeId) References requiredProductTypeProperties(productTypeId,productTypePropertyTypeId)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(productTypePropertyTypeValidationId) References productTypePropertyTypeValidationTypes(productTypePropertyTypeValidationTypeId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE productTypePropertyTypeValidationValues (
   rollNo varchar(5) NOT NULL,
   productTypePropertyTypeValidationTypeId varchar(255) NOT NULL,
   sequenceNumber varchar(25) NOT NULL,
   productTypePropertyTypeValidationValue varchar(255) NOT NULL,
   Constraint pk_productTypePropertyTypeValidationValues primary key(productTypePropertyTypeValidationTypeId,productTypePropertyTypeValidationValue),
   Foreign Key(rollNo) References students(rollNo)
   ON DELETE RESTRICT ON UPDATE CASCADE,
   Foreign Key(productTypePropertyTypeValidationTypeId) References productTypePropertyTypeValidationTypes(productTypePropertyTypeValidationTypeId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);



