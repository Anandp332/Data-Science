/*
[ assignment

[subject - [DB17-TYPES]]
[deadline - 24/10/2017 11am]
[attachment - a single file [rollno].sql]
[assignment text - [

as discussed in the class you are required to submit the following

a file containing, 2 parts, part-simple [compulsory] and part-bonus [optional] as described below
[ part-simple
SQL insert statements to do the following 

 - add 2 concrete types corresponding to the (abstract type) assigned to you
 - add new supertype-subtype associations
 - for the assigned type, you must provide an URL to the page on which the product-type information is found
 - for each type entry, define the mandatory properties
      - weight
      - dim1
      - dim2
      - dim3
      - color
      - manufacturer
      - price
      - mfgDate - date
      - instructions [container type property]
      - url
    
 - for every new type added, you must add at least 5 new properties that are more specific to that product type; and 1 of the newly added properties is of the abstract type container with depth at least 3 and at least 10 total elements involving all 3 concrete data types i.e. int, float and string

hint: note that the order of insert statements must be as follows [table names], else you may get foreign key constraint errors

           1) productTypes
           2) productTypeHierarchy
           3) productTypePropertyTypes
           4) productTypePropertyTypeContainer
           5) requiredProductTypeProperties
           6) productTypePropertyTypeValidationTypes
           7) productTypePropertyTypeValueTypes
           8) productTypePropertyTypeValidationValues

]
[part-bonus

note - this part is for the students who like to be challenged more. but this part will be evaluated ONLY if part-simple is correctly done.

 - write a query to check whether a given type has been properly defined according to the rules stated in this assignment. [hint: you may find triggers useful to solve this.]
 - write a query to create a view that has the following two attributes - typeId and typeInfo
 where
 the typeInfo attribute contains all values corresponding to all properties associated with the typeId as a single string.
   [hint: solve the marksheet problem first, before attempting this problem]
 - there may be some errors/shortcomings in the schema provided for this practice problem. state the errors/shortcomings in brief and improve the schema to remove the errors/shortcomings.
]

Note that the practice problems will NOT be considered towards continuous assessment. Refer the file about-practice-problems.txt at [0]. Barring this, you may wish to submit your solutions to these practice problems, and if you do wish so then you have to do the following - 

1. You have to send a single file with extension "sql" as attachment. No other extension will be processed further. Name of the attached file should be your roll number. Your roll number is a five digit string. If you do NOT name the file as per this rule, your practice problem submission might be ignored.

2. You have to send an email to "assignments<DOT>pucsd<AT>gmail<DOT>com" with the subject mentioned above. 

Note that I am going to filter messages on the basis of the subject text ONLY. So, you should send the email with the exact subject text given above. Even slight change might result in rejection.

If you have any doubts regarding the practice problems, you may meet me.

[0] http://tinyurl.com/pucsdJuly16

]
]
]
*/

