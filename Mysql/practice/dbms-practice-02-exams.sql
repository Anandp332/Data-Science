/*
[ assignment

[subject - [DB17-EXAM]]
[deadline - 03/10/2017 11am]
[attachment - a single file [rollno].sql]
[assignment text - [

refer exams-data.sql.tar.xz at [0] for the sample database and data.
note - you have to download the file and then extract it; you may use the following command
$ tar -xJf exams-data.sql.tar.xz

then load the exams-data.sql in sqlite

-----------------------

consider the record keeping problem of exams conducted in a university

some meta information about the exams

grades = [('F',0,39),('E',40,44),('D',45,49),('C',50,54),('B',55,64),('A',65,74),('O',75,100)]
number of subjects = 20
maximum number of allowed attempts = 8
fees per subject per exam - Rs. 100
the fees are increased by Rs. 10 after every 3 batches
batch 1 is the oldest batch

-----------------------
write sql queries for the following

1. get the final marksheet of all students; note that the marksheet should include marks obtained in the final attempted exam along with the grade
2. get the list of those students who have exhausted the maximum number of allowed attempts and still have not passed
3. get the list of those students who have not exhausted the maximum number of allowed attempts and still have not passed
4. get the list of those students who have not exhausted the maximum number of allowed attempts and have passed
5. get the list of those students who have passed all their subjects in the first attempt only
6. get the list of those students who have passed all their subjects in less than 4 attempts 
7. get the list of those students who have obtained at least a C grade in at least 7 subjects
8. get the list of those students who have obtained at least a C grade in at least 8 subjects by exhausting 4 attempts at most per subject
9. get the list of those students who have obtained at least a C grade in at least 9 subjects by exhausting 50 attempts at most in total across all subjects
10. prepare the list of student-wise fees obtained
11. prepare the list of batch-wise fees obtained
12. prepare the list of top high scoring 1% students
13. order the batches according to descending order of marks scored by the students of that batch (note that this is tricky)
14. get all exams in which at least 15 or more students failed in at least 12 subjects


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


