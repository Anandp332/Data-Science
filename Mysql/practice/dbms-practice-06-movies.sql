/*
[ assignment

[subject - [DB17-MOVIE-TIME]]
[deadline - 05/09/2017 8pm]
[attachment - a single file [rollno].sql]
[assignment text - [

consider the movie db, the schema and data of which are given in allimdb.sql which you can find in the compressed archive file allimdb-sql.tar.xz at [0]. the file is rather large about 400MB uncompressed and 40MB compressed.

you may use the command `tar -xf allimdb-sql.tar.xz` to uncompress the file.
after this, you should read the allimdb.sql in sqlite3 in a db file, say, movies.db
reading this file may take quite a lot time [several minutes, depending upon your machine] as the total number of records is about 4 million.

the schema is given below. note that there are no constraints put in the schema at all.

CREATE TABLE [imdbcast]
(
pid TEXT,
mid TEXT,
role TEXT

);
CREATE TABLE [imdbdirector_genre]
(
did TEXT,
genre TEXT,
prob TEXT

);
CREATE TABLE [imdbdirectors]
(
id TEXT,
fname TEXT,
lname TEXT

);
CREATE TABLE [imdbgenre]
(
id TEXT,
genre TEXT

);
CREATE TABLE [imdbmovie_directors]
(
did TEXT,
mid TEXT

);
CREATE TABLE [imdbmovie]
(
id TEXT,
name TEXT,
year TEXT,
rank TEXT

);
CREATE TABLE [imdbperson]
(
id TEXT,
fname TEXT,
lname TEXT,
gender TEXT

);

your job is to 
write sql DDL/DML statements to create views for following
 - check whether desired foreign key constraints are satisfied or not and get all records which violate some foreign key constraint.
 - get all movies which have been directed by those directors who have directed a movie which has at least 3 male and 3 female actors
 - get all movies directed by an actor 
 - get all movies directed by an actor who also acted in the movie directed by him/her
 - get all actors who have acted in at least as many movies as the average number of movies done by the actors
 - get all the movies in which at least 10 actors acted 
 - get all actors who have acted in the largest number of distinct movie genres
 - get all actors who have acted in the least number of distinct movie genres
 - get genrewise movie count of each actor
 - get genrewise movie count of each director
 - get the top 30 actors according to the period of being active in the movie industry
 - get yearwise movie count
 - get yearwise movie count of each director [suppress entries with 0 count]
 - get all the movies in which all actors have acted in movies of at least 6 different genres


Note that the practice problems will NOT be considered towards continuous assessment. Refer the file about-practice-problems.txt at [0]. Barring this, you may wish to submit your solutions to these practice problems, and if you do wish so then you have to do the following - 

1. You have to send a single file with extension "sql" as attachment. No other extension will be processed further. Name of the attached file should be your roll number. Make sure that the file size doesn't exceed 80KB. Your roll number is a five digit string. If you do NOT name the file as per this rule, your practice problem submission might be ignored.

2. You have to send an email to "assignments<DOT>pucsd<AT>gmail<DOT>com" with the subject mentioned above. 

Note that I am going to filter messages on the basis of the subject text ONLY. So, you should send the email with the exact subject text given above. Even slight change might result in rejection.

If you have any doubts regarding the practice problems, you may meet me.

[0] http://tinyurl.com/pucsdJuly16

]
]
]
*/

