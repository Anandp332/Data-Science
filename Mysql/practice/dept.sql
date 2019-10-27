
/*

to load this database schema and data in the sqlite use the following command
on the sqlite shell

to support foreign key first run

PRAGMA foreign_keys=1;

.read dept.sql

rough outline of the dept schema

teachers - teacherid, teacherfname, teachermname, teacherlname, temail, tmobile, tphone
courses - courseid, coursename, courseinfo
teachercourses - teacherid, courseid
students - rollno, studentfname, studentmname, studentlname, semail, smobile, sphone
studentcourses - rollno, courseid

to view data you may use queries like the following ones -
  
  select count(*) from students where studentDegree='MCA';
  select * from students where studentDegree='MCA';
  select count(*) from students;
  select * from students;
select * from studentcourses where courseid='cmgt';
select count(*) from studentcourses;
select * from studentcourses;

try deleting a course for which some students have registered

delete from courses where courseid='ip';

some joins

select studentcourses.rollno, students.studentfname from studentcourses, students where studentcourses.rollno=students.rollno limit 20; 
  show only 20 records

select studentcourses.rollno, students.studentfname from studentcourses, students where studentcourses.rollno=students.rollno and students.rollno='99101';

select studentcourses.rollno, students.studentfname, studentcourses.courseid, courses.coursename from studentcourses, students,courses where studentcourses.rollno=students.rollno and students.rollno='99101' and studentcourses.courseid=courses.courseid;

update course id

 */

/*
before creating new schema, drop any tables that may already exist
*/
PRAGMA foreign_keys=1; /* or else you will get some unpleasant surprises !!! i hate such things, but no use hating if you wish to use it */
DROP TABLE IF EXISTS [teachers];
DROP TABLE IF EXISTS [students];
DROP TABLE IF EXISTS [courses];
DROP TABLE IF EXISTS [studentcourses];
DROP TABLE IF EXISTS [teachercourses];
DROP TABLE IF EXISTS [log_courses];

/*

now we will create the relations (tables)
note that we will write as many constraints in the schema as possible

teachers - teacherid, teacherfname, teachermname, teacherlname, temail, tmobile, tphone, tgender, ttitle
courses - courseid, coursename, courseinfo
teachercourses - teacherid, courseid
students - rollno, studentfname, studentmname, studentlname, semail, smobile, sphone, sgender, stitle
studentcourses - rollno, courseid

*/

CREATE TABLE [teachers]
(
    [teacherid] NVARCHAR(5)  NOT NULL,
    [teacherfname] NVARCHAR(100)  NOT NULL,
    [teachermname] NVARCHAR(100),
    [teacherlname] NVARCHAR(100)  NOT NULL,
    [teacherTitle] NVARCHAR(5)  NOT NULL,
    [teacherEmail] NVARCHAR(200)  NOT NULL,
    [teacherMobile] NVARCHAR(20)  NOT NULL,
    [teacherPhone] NVARCHAR(20)  NOT NULL,
    /* now add constraints */
    CONSTRAINT [PKC_Teachers] PRIMARY KEY  ([teacherid])
);

CREATE TABLE [students]
(
    [rollno] NVARCHAR(5)  NOT NULL,
    [studentfname] NVARCHAR(100)  NOT NULL,
    [studentmname] NVARCHAR(100),
    [studentlname] NVARCHAR(100)  NOT NULL,
    [studentTitle] NVARCHAR(5)  NOT NULL,
    [studentDegree] NVARCHAR(5)  NOT NULL, /* mca/msc/mtech */
    [studentEmail] NVARCHAR(200)  NOT NULL,
    [studentMobile] NVARCHAR(20)  NOT NULL,
    /* now add constraints */
    CONSTRAINT [PKC_students] PRIMARY KEY  ([rollno])
);

CREATE TABLE [courses]
(
    [courseid] NVARCHAR(10)  NOT NULL,
    [coursename] NVARCHAR(100)  NOT NULL,
    [courseinfo] NVARCHAR(1000),
    /* now add constraints */
    CONSTRAINT [PKC_courses] PRIMARY KEY  ([courseid])
    /* additional check constraints */
    CONSTRAINT [CHK_courseid] CHECK ([courseid] in ('ip', 'mf', 'cmgt', 'dbms', 'co'))
);

CREATE TABLE [teachercourses]
(
    [teacherid] NVARCHAR(5)  NOT NULL,
    [courseid] NVARCHAR(10)  NOT NULL,
    /* now add constraints */
    CONSTRAINT [PKC_teachercourses] PRIMARY KEY  ([teacherid], [courseid]),
    FOREIGN KEY ([teacherid]) REFERENCES [teachers] ([teacherid]) 
		ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY ([courseid]) REFERENCES [courses] ([courseid]) 
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE [studentcourses]
(
    [rollno] NVARCHAR(5)  NOT NULL,
    [courseid] NVARCHAR(10)  NOT NULL,
    /* now add constraints */
    CONSTRAINT [PKC_studentcourses] PRIMARY KEY  ([rollno], [courseid]),
    FOREIGN KEY ([rollno]) REFERENCES [students] ([rollno]) 
		ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY ([courseid]) REFERENCES [courses] ([courseid]) 
		ON DELETE RESTRICT ON UPDATE CASCADE
);

/*
now create some triggers for fun

we will add a trigger that will record the attempts to insert or update records in courses table 
user input values will be stored in a table called log_courses along with the time of operation

select * from log_courses;

*/

CREATE TABLE [log_courses]
(
    [eventtime] TEXT  NOT NULL,
    [courseid] NVARCHAR(10)  NOT NULL,
    [coursename] NVARCHAR(100)  NOT NULL,
    [courseinfo] NVARCHAR(1000)
    /* 
       no additional constraints are needed per se as this table will be 
       used only interally by the trigger 
     */
);

CREATE TRIGGER trigger_log_courses BEFORE INSERT ON courses 
BEGIN
  insert into [log_courses] ([eventtime], [courseid], [coursename], [courseinfo]) values (datetime('now'), NEW.courseid, NEW.coursename, NEW.courseinfo);
END;

/*
   now insert some values in the tables

  note that end users will not like to insert values in the database
  using sql statements as shown here

  that's why we need to create those fancy gui applications where endusers can happily click with a mouse and/or tap with their fingers on the touchscreens of the smart-devices and dance around joyfully when a window pops up and shows them "Operation successfully done!"

  They will be much more happy if a voice is heard from the speakers saying "Operation successfully done!"

okay, enough about and of application programming, let's get back to rdbms business.

*/

INSERT INTO [courses] ([courseid], [coursename], [courseinfo]) VALUES ('ip', 'introduction to programming', 'a super simple course to learn programming from grounds up');
INSERT INTO [courses] ([courseid], [coursename], [courseinfo]) VALUES ('mf', 'math foundations', 'a super simple course to learn math foundations required for some serious programming');
INSERT INTO [courses] ([courseid], [coursename], [courseinfo]) VALUES ('cmgt2', 'concrete math and graph theory', 'a course to learn math foundations required for some more serious programming');
INSERT INTO [courses] ([courseid], [coursename], [courseinfo]) VALUES ('co', 'computer orgnization', 'a course to learn how those electronic machines work at all');
INSERT INTO [courses] ([courseid], [coursename], [courseinfo]) VALUES ('dbms', 'database management systems', 'a course to learn how to read/write this sql file and some other interesting things');

/*

now insert few teachers records
 */

INSERT INTO [teachers] ([teacherid], [teacherfname], [teachermname], [teacherlname], [teacherTitle], [teacherEmail], [teacherMobile], [teacherPhone]) VALUES ('t01', 'tfname', 'tmname', 'tlname', 'mr', 't01@cs.unipune.ac.in', '3334445556', '222229999');
INSERT INTO [teachers] ([teacherid], [teacherfname], [teachermname], [teacherlname], [teacherTitle], [teacherEmail], [teacherMobile], [teacherPhone]) VALUES ('t02', 'tfname', 'tmname', 'tlname', 'dr', 't02@cs.unipune.ac.in', '3331115556', '222229999');
INSERT INTO [teachers] ([teacherid], [teacherfname], [teachermname], [teacherlname], [teacherTitle], [teacherEmail], [teacherMobile], [teacherPhone]) VALUES ('t03', 'tfname', 'tmname', 'tlname', 'ms', 't03@cs.unipune.ac.in', '3332225556', '222229999');
INSERT INTO [teachers] ([teacherid], [teacherfname], [teachermname], [teacherlname], [teacherTitle], [teacherEmail], [teacherMobile], [teacherPhone]) VALUES ('t04', 'tfname', 'tmname', 'tlname', 'ms', 't04@cs.unipune.ac.in', '3334447776', '222229999');
INSERT INTO [teachers] ([teacherid], [teacherfname], [teachermname], [teacherlname], [teacherTitle], [teacherEmail], [teacherMobile], [teacherPhone]) VALUES ('t05', 'tfname', 'tmname', 'tlname', 'mr', 't05@cs.unipune.ac.in', '3338885556', '222229999');

/*
  now insert some student records 
note that these are the students from the 99 batch, not the 1999 batch but from the 2999 batch

welcome to future! this is sci-fi!!

(of course, the teachers are also from the future, haven't you read their names yet?)

  select * from students where studentDegree='MCA';
 */

INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99101','FnZeroZero','MnNineNine','LnZeroZero','Ms','MSc','3331008999','fnzerozero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99102','FnZeroOne','MnNineEight','LnZeroOne','Mr','MCA','3331018998','fnzeroone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99103','FnZeroTwo','MnNineSeven','LnZeroTwo','Mr','MTech','3331028997','fnzerotwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99104','FnZeroThree','MnNineSix','LnZeroThree','Ms','MSc','3331038996','fnzerothree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99105','FnZeroFour','MnNineFive','LnZeroFour','Ms','MCA','3331048995','fnzerofour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99106','FnZeroFive','MnNineFour','LnZeroFive','Mr','MTech','3331058994','fnzerofive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99107','FnZeroSix','MnNineThree','LnZeroSix','Mr','MSc','3331068993','fnzerosix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99108','FnZeroSeven','MnNineTwo','LnZeroSeven','Ms','MCA','3331078992','fnzeroseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99109','FnZeroEight','MnNineOne','LnZeroEight','Ms','MTech','3331088991','fnzeroeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99110','FnZeroNine','MnNineZero','LnZeroNine','Mr','MSc','3331098990','fnzeronine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99111','FnOneZero','MnEightNine','LnOneZero','Mr','MCA','3331108989','fnonezero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99112','FnOneOne','MnEightEight','LnOneOne','Ms','MTech','3331118988','fnoneone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99113','FnOneTwo','MnEightSeven','LnOneTwo','Ms','MSc','3331128987','fnonetwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99114','FnOneThree','MnEightSix','LnOneThree','Mr','MCA','3331138986','fnonethree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99115','FnOneFour','MnEightFive','LnOneFour','Mr','MTech','3331148985','fnonefour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99116','FnOneFive','MnEightFour','LnOneFive','Ms','MSc','3331158984','fnonefive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99117','FnOneSix','MnEightThree','LnOneSix','Ms','MCA','3331168983','fnonesix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99118','FnOneSeven','MnEightTwo','LnOneSeven','Mr','MTech','3331178982','fnoneseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99119','FnOneEight','MnEightOne','LnOneEight','Mr','MSc','3331188981','fnoneeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99120','FnOneNine','MnEightZero','LnOneNine','Ms','MCA','3331198980','fnonenine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99121','FnTwoZero','MnSevenNine','LnTwoZero','Ms','MTech','3331208979','fntwozero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99122','FnTwoOne','MnSevenEight','LnTwoOne','Mr','MSc','3331218978','fntwoone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99123','FnTwoTwo','MnSevenSeven','LnTwoTwo','Mr','MCA','3331228977','fntwotwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99124','FnTwoThree','MnSevenSix','LnTwoThree','Ms','MTech','3331238976','fntwothree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99125','FnTwoFour','MnSevenFive','LnTwoFour','Ms','MSc','3331248975','fntwofour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99126','FnTwoFive','MnSevenFour','LnTwoFive','Mr','MCA','3331258974','fntwofive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99127','FnTwoSix','MnSevenThree','LnTwoSix','Mr','MTech','3331268973','fntwosix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99128','FnTwoSeven','MnSevenTwo','LnTwoSeven','Ms','MSc','3331278972','fntwoseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99129','FnTwoEight','MnSevenOne','LnTwoEight','Ms','MCA','3331288971','fntwoeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99130','FnTwoNine','MnSevenZero','LnTwoNine','Mr','MTech','3331298970','fntwonine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99131','FnThreeZero','MnSixNine','LnThreeZero','Mr','MSc','3331308969','fnthreezero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99132','FnThreeOne','MnSixEight','LnThreeOne','Ms','MCA','3331318968','fnthreeone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99133','FnThreeTwo','MnSixSeven','LnThreeTwo','Ms','MTech','3331328967','fnthreetwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99134','FnThreeThree','MnSixSix','LnThreeThree','Mr','MSc','3331338966','fnthreethree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99135','FnThreeFour','MnSixFive','LnThreeFour','Mr','MCA','3331348965','fnthreefour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99136','FnThreeFive','MnSixFour','LnThreeFive','Ms','MTech','3331358964','fnthreefive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99137','FnThreeSix','MnSixThree','LnThreeSix','Ms','MSc','3331368963','fnthreesix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99138','FnThreeSeven','MnSixTwo','LnThreeSeven','Mr','MCA','3331378962','fnthreeseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99139','FnThreeEight','MnSixOne','LnThreeEight','Mr','MTech','3331388961','fnthreeeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99140','FnThreeNine','MnSixZero','LnThreeNine','Ms','MSc','3331398960','fnthreenine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99141','FnFourZero','MnFiveNine','LnFourZero','Ms','MCA','3331408959','fnfourzero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99142','FnFourOne','MnFiveEight','LnFourOne','Mr','MTech','3331418958','fnfourone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99143','FnFourTwo','MnFiveSeven','LnFourTwo','Mr','MSc','3331428957','fnfourtwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99144','FnFourThree','MnFiveSix','LnFourThree','Ms','MCA','3331438956','fnfourthree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99145','FnFourFour','MnFiveFive','LnFourFour','Ms','MTech','3331448955','fnfourfour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99146','FnFourFive','MnFiveFour','LnFourFive','Mr','MSc','3331458954','fnfourfive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99147','FnFourSix','MnFiveThree','LnFourSix','Mr','MCA','3331468953','fnfoursix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99148','FnFourSeven','MnFiveTwo','LnFourSeven','Ms','MTech','3331478952','fnfourseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99149','FnFourEight','MnFiveOne','LnFourEight','Ms','MSc','3331488951','fnfoureight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99150','FnFourNine','MnFiveZero','LnFourNine','Mr','MCA','3331498950','fnfournine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99151','FnFiveZero','MnFourNine','LnFiveZero','Mr','MTech','3331508949','fnfivezero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99152','FnFiveOne','MnFourEight','LnFiveOne','Ms','MSc','3331518948','fnfiveone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99153','FnFiveTwo','MnFourSeven','LnFiveTwo','Ms','MCA','3331528947','fnfivetwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99154','FnFiveThree','MnFourSix','LnFiveThree','Mr','MTech','3331538946','fnfivethree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99155','FnFiveFour','MnFourFive','LnFiveFour','Mr','MSc','3331548945','fnfivefour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99156','FnFiveFive','MnFourFour','LnFiveFive','Ms','MCA','3331558944','fnfivefive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99157','FnFiveSix','MnFourThree','LnFiveSix','Ms','MTech','3331568943','fnfivesix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99158','FnFiveSeven','MnFourTwo','LnFiveSeven','Mr','MSc','3331578942','fnfiveseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99159','FnFiveEight','MnFourOne','LnFiveEight','Mr','MCA','3331588941','fnfiveeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99160','FnFiveNine','MnFourZero','LnFiveNine','Ms','MTech','3331598940','fnfivenine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99161','FnSixZero','MnThreeNine','LnSixZero','Ms','MSc','3331608939','fnsixzero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99162','FnSixOne','MnThreeEight','LnSixOne','Mr','MCA','3331618938','fnsixone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99163','FnSixTwo','MnThreeSeven','LnSixTwo','Mr','MTech','3331628937','fnsixtwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99164','FnSixThree','MnThreeSix','LnSixThree','Ms','MSc','3331638936','fnsixthree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99165','FnSixFour','MnThreeFive','LnSixFour','Ms','MCA','3331648935','fnsixfour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99166','FnSixFive','MnThreeFour','LnSixFive','Mr','MTech','3331658934','fnsixfive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99167','FnSixSix','MnThreeThree','LnSixSix','Mr','MSc','3331668933','fnsixsix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99168','FnSixSeven','MnThreeTwo','LnSixSeven','Ms','MCA','3331678932','fnsixseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99169','FnSixEight','MnThreeOne','LnSixEight','Ms','MTech','3331688931','fnsixeight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99170','FnSixNine','MnThreeZero','LnSixNine','Mr','MSc','3331698930','fnsixnine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99171','FnSevenZero','MnTwoNine','LnSevenZero','Mr','MCA','3331708929','fnsevenzero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99172','FnSevenOne','MnTwoEight','LnSevenOne','Ms','MTech','3331718928','fnsevenone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99173','FnSevenTwo','MnTwoSeven','LnSevenTwo','Ms','MSc','3331728927','fnseventwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99174','FnSevenThree','MnTwoSix','LnSevenThree','Mr','MCA','3331738926','fnseventhree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99175','FnSevenFour','MnTwoFive','LnSevenFour','Mr','MTech','3331748925','fnsevenfour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99176','FnSevenFive','MnTwoFour','LnSevenFive','Ms','MSc','3331758924','fnsevenfive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99177','FnSevenSix','MnTwoThree','LnSevenSix','Ms','MCA','3331768923','fnsevensix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99178','FnSevenSeven','MnTwoTwo','LnSevenSeven','Mr','MTech','3331778922','fnsevenseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99179','FnSevenEight','MnTwoOne','LnSevenEight','Mr','MSc','3331788921','fnseveneight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99180','FnSevenNine','MnTwoZero','LnSevenNine','Ms','MCA','3331798920','fnsevennine@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99181','FnEightZero','MnOneNine','LnEightZero','Ms','MTech','3331808919','fneightzero@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99182','FnEightOne','MnOneEight','LnEightOne','Mr','MSc','3331818918','fneightone@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99183','FnEightTwo','MnOneSeven','LnEightTwo','Mr','MCA','3331828917','fneighttwo@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99184','FnEightThree','MnOneSix','LnEightThree','Ms','MTech','3331838916','fneightthree@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99185','FnEightFour','MnOneFive','LnEightFour','Ms','MSc','3331848915','fneightfour@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99186','FnEightFive','MnOneFour','LnEightFive','Mr','MCA','3331858914','fneightfive@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99187','FnEightSix','MnOneThree','LnEightSix','Mr','MTech','3331868913','fneightsix@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99188','FnEightSeven','MnOneTwo','LnEightSeven','Ms','MSc','3331878912','fneightseven@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99189','FnEightEight','MnOneOne','LnEightEight','Ms','MCA','3331888911','fneighteight@cs.unipune.ac.in');
INSERT INTO [students] ([rollno], [studentfname], [studentmname], [studentlname], [studentTitle], [studentDegree], [studentEmail], [studentMobile]) VALUES ('99190','FnEightNine','MnOneZero','LnEightNine','Mr','MTech','3331898910','fneightnine@cs.unipune.ac.in');

/* now add some records in studentcourses */

INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99101','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99102','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99103','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99104','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99105','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99106','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99107','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99108','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99109','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99110','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99111','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99112','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99113','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99114','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99115','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99116','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99117','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99118','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99119','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99120','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99121','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99122','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99123','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99124','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99125','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99126','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99127','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99128','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99129','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99130','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99131','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99132','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99133','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99134','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99135','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99136','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99137','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99138','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99139','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99140','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99141','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99142','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99143','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99144','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99145','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99146','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99147','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99148','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99149','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99150','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99151','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99152','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99153','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99154','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99155','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99156','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99157','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99158','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99159','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99160','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99161','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99162','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99163','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99164','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99165','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99166','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99167','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99168','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99169','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99170','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99171','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99172','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99173','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99174','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99175','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99176','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99177','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99178','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99179','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99180','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99181','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99182','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99183','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99184','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99185','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99186','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99187','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99188','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99189','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99190','ip');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99101','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99102','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99103','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99104','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99105','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99106','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99107','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99108','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99109','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99110','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99111','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99112','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99113','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99114','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99115','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99116','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99117','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99118','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99119','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99120','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99121','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99122','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99123','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99124','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99125','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99126','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99127','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99128','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99129','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99130','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99131','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99132','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99133','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99134','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99135','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99136','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99137','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99138','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99139','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99140','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99141','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99142','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99143','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99144','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99145','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99146','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99147','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99148','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99149','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99150','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99151','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99152','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99153','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99154','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99155','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99156','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99157','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99158','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99159','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99160','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99161','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99162','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99163','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99164','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99165','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99166','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99167','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99168','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99169','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99170','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99171','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99172','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99173','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99174','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99175','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99176','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99177','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99178','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99179','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99180','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99181','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99182','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99183','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99184','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99185','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99186','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99187','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99188','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99189','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99190','mf');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99101','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99102','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99103','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99104','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99105','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99106','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99107','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99108','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99109','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99110','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99111','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99112','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99113','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99114','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99115','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99116','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99117','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99118','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99119','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99120','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99121','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99122','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99123','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99124','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99125','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99126','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99127','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99128','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99129','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99130','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99131','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99132','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99133','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99134','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99135','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99136','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99137','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99138','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99139','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99140','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99141','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99142','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99143','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99144','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99145','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99146','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99147','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99148','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99149','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99150','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99151','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99152','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99153','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99154','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99155','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99156','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99157','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99158','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99159','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99160','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99161','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99162','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99163','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99164','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99165','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99166','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99167','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99168','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99169','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99170','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99171','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99172','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99173','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99174','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99175','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99176','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99177','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99178','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99179','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99180','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99181','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99182','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99183','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99184','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99185','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99186','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99187','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99188','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99189','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99190','cmgt');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99101','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99102','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99103','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99104','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99105','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99106','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99107','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99108','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99109','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99110','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99111','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99112','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99113','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99114','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99115','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99116','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99117','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99118','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99119','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99120','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99121','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99122','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99123','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99124','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99125','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99126','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99127','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99128','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99129','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99130','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99131','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99132','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99133','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99134','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99135','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99136','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99137','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99138','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99139','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99140','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99141','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99142','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99143','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99144','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99145','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99146','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99147','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99148','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99149','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99150','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99151','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99152','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99153','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99154','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99155','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99156','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99157','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99158','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99159','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99160','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99161','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99162','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99163','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99164','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99165','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99166','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99167','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99168','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99169','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99170','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99171','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99172','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99173','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99174','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99175','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99176','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99177','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99178','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99179','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99180','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99181','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99182','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99183','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99184','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99185','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99186','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99187','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99188','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99189','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99190','dbms');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99101','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99102','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99103','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99104','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99105','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99106','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99107','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99108','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99109','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99110','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99111','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99112','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99113','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99114','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99115','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99116','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99117','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99118','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99119','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99120','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99121','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99122','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99123','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99124','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99125','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99126','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99127','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99128','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99129','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99130','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99131','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99132','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99133','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99134','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99135','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99136','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99137','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99138','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99139','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99140','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99141','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99142','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99143','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99144','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99145','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99146','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99147','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99148','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99149','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99150','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99151','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99152','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99153','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99154','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99155','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99156','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99157','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99158','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99159','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99160','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99161','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99162','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99163','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99164','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99165','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99166','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99167','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99168','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99169','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99170','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99171','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99172','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99173','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99174','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99175','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99176','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99177','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99178','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99179','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99180','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99181','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99182','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99183','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99184','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99185','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99186','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99187','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99188','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99189','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('99190','co');
INSERT INTO [studentcourses] ([rollno], [courseid]) VALUES ('89190','co');


