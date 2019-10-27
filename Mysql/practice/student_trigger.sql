/*
 execute the following on sqlite3

 sqlite>.read students-triggers.sql

 */

/*
 Let's create some triggers for some more validations.

 Make sure the trigger is really needed or not.
 */

CREATE TRIGGER validate_names BEFORE INSERT ON students
BEGIN
 SELECT
 CASE
   WHEN NEW.fname NOT LIKE '%a%' AND NEW.fname NOT LIKE '%e%' THEN
        RAISE ( ABORT, 'trigger validate_names error: name should contain at least one vowel.' )
 END;
END;


/* ---------------------------------------------------------  */


