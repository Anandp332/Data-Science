/*

write a schema that will ensure the following constraints on the dept database we discussed

- no student from nth stadandard/semester should be able to register for courses from mth semester where m > n
- no student should be allowed to register for the courses he/she has already passed
- no student should be allowed to register for the courses if he/she has taken admission 6 or more years before the current date

you may use triggers

the trigger discussed in today's lecture is listed below

*/


CREATE TRIGGER trigger_validate_input BEFORE INSERT ON students
WHEN length(NEW.studentfname) >= 40
BEGIN
  SELECT RAISE(ABORT,'error: name length should not exceed 40.');

