

[ assignment

[subject - [DB17-STUDENTS-TRIGGER-HAPPY]]
[deadline - 16/08/2017 11am]
[attachment - a single file [rollno].sql]
[assignment text - [

write and submit a single sql file, named [rollno].sql, containing the following - 
 consider the schema for the groups relation as discussed in the class.

CREATE TABLE IF NOT EXISTS groups (
  groupId TEXT NOT NULL,
  memberId TEXT NOT NULL,
  groupName TEXT,
  groupStartDate TEXT,
  groupDescription TEXT,
  groupContactPerson TEXT,
  CONSTRAINT pkc_groups Primary Key(groupId, memberId)
);

Write appropriate triggers to enforce the following constraint -
 the attributes groupName, groupStartDate, groupDescription, groupContactPerson should not
    repeat in the relation
 at the time of insert/delete/update of records in the groups relation.

Also, create a required view as discussed in the class, so that end-users can get the required information as desired.


Notes - 
a note about naming the file to be attached - if your rollno is abcde, then you should name the file abcde.sql 
e.g. if your roll number is 17101, then you should name the file 17101.sql

Also note that i filter the messages based on subject text and attachment file names. so make sure that you set those values correctly. slight errors in those values may result in automatic rejection of your submission.

]
]
]

