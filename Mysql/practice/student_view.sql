/*
 execute the following on sqlite3

 sqlite>.read students-views.sql

 */
/*
 Let's create some views for the end-users and application programmers.
 */


CREATE VIEW [v_rollcall] AS SELECT (ryear || rccode4user || rsn) as rollnumber, (COALESCE([fname], '') || ' ' || COALESCE([mname],'') || ' ' || COALESCE([lname], '')) as fullname, [rccodeDesc] as [course] FROM students, rccodeTypes where students.rccode = rccodeTypes.rccodeType; 

CREATE VIEW [v_mcarollcall] AS SELECT (ryear || rccode4user || rsn) as rollnumber, (COALESCE([fname], '') || ' ' || COALESCE([mname],'') || ' ' || COALESCE([lname], '')) as fullname FROM students, rccodeTypes where students.rccode = rccodeTypes.rccodeType and student.rccode = 'C'; 

CREATE VIEW [v_mscrollcall] AS SELECT (ryear || rccode4user || rsn) as rollnumber, (COALESCE([fname], '') || ' ' || COALESCE([mname],'') || ' ' || COALESCE([lname], '')) as fullname FROM students, rccodeTypes where students.rccode = rccodeTypes.rccodeType and student.rccode = 'S'; 


