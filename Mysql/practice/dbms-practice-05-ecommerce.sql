/*
[ assignment

[subject - [DBMS17_PRACTICE_FLOP_1]]
[deadline - 12/09/2017 11am]
[attachment - a single file [rollno].tar.xz]
[assignment text - [

Read the following story of an e-commerce website.

Mr. Salman Khan [see [s]] and Mr. Sam Harris [h] were great friends since the world started [i.e. exactly since 39th February 1999 according to some "the" book]. Once they decided to open a grand online shopping business in partnership. They thought that others are making so much money opening online shops these days that they should not be left behind. So they started a online business named "flipZon" [z].

Mr. Khan went ahead and studied the market and somehow found out that the queries to retrieve the following type of information are very crucial for their business: 

 q1. get all orders in which at least 5 or more products were ordered
 q2. get all orders in which products of at least 3 or more different types were ordered
 q3. get all orders in which the total discount given exceeds Rs. 300
 q3. get the details of all those customer who have ordered more than Rs. 2000 in total in the previous month
 q4. get product wise sales quantity and amount
 q5. get product wise sales quantity and amount per month
 q6. get product-type wise sales quantity and amount
 q7. get product-type wise sales quantity and amount per month
 q8. get customer wise sales quantity and amount
 q9. get month wise sales quantity and amount
 q10. get the product which has sold the most
 q11. get the product which has brought the most revenue
 q12. get the product which has brought the most profit
 q13. get the product-type which has sold the most
 q14. get the product-type which has brought the most revenue
 q15. get the product-type which has brought the most profit
 q16. get the product which has been returned the most by the customers
 q17. get the product-type which has been returned the most by the customers
 q18. get the customers who have returned the most number of products
 q20. get those lists of products such that there are at least 3 customers who bought all products from one of these lists in the same order 
 q21. get those lists of products such that there are at least 3 customers who bought all products from one of these lists in the same month 
 q22. get city-wise list of product sale amounts
 q23. get city-wise list of product-type sale amounts
 q24. get city-wise customer-wise list of product sale amounts

 also
 consider the following rules of the business

 r1. a customer cannot place orders totaling less than Rs. 500 unless he/she has placed at least one order on that same day
 r2. a customer will receive additional discount (if applicable) only if the order amount exceeds Rs. 10000 (note that the customer is eligible to receive nominal discount (if offered on the product) irrespective of total order amount
 r3. if total number of individual items in the order exceeds 25 then extra handling charges will be applicable
 r4. a customer cannot order more quantity of a product than the maximum allowed quantity per order per month
 r5. a customer cannot return a returnable product after 7 days are past the order date
 r6. a non-returnable product cannot be returned

Mr. Harris, being a man of reason, got very much bored with all this query and rules business and hence they, i.e. Mr. Khan and Mr. Harris, hired Mr. Bill Maher [b] (who calls himself the great manager but indeed is more like a "the clown in the town" - you know just like a typical manager with an mba) to manage their business. The clown in the town Mr. Maher, being a typical MBA style manager, hired a person named Mr. Kamodar Dulkarni [k] (who considers himself a programmer, but in fact is a low level coder of extreme dubious quality: the only program he had written successfully till date could successfully print the string: "successfully, hello world" without error!)

Mr. Dulkarni went ahead with full gusto without any thought to design based on a solid database theory (that is typical of a lowly coder) and implemented a schema that was so full of redundancy that hundreds of 4TB disks got filled to the brim in matter of few weeks and the flipzon website became so slow that customers had to wait for days to just select and add products to the carts. the payment transactions started taking even more time than the time taken by bitcoin transactions [btc], which is several hours or even days. Those long transaction delays were still acceptable (at least to Mr. Maher, the clown of the town), but that one trigger written by Mr. Dulkarni was so buggy that it gave 100% discount to all customers on all orders and due to this, you know, flipzon just flipped the day they announced their discount scheme.

When interviewed later about the collapse of flipzon, Mr. Dulkarni told the reporter that somewhere he had read that redundancy is good for more reliability. He puts all the blame on bad books. But when asked about the buggy trigger, he just said "no comments". (And in fact, he had not written any comments in the SQL file containing that trigger!) He later heard saying that all these problems could have been solved by using nosql! Now he wakes in the middle of the night on some *days* and screams "Nosql is the way to go". Thankfully, no one takes him too seriously, except those managers (the clowns of their respective towns) who find the sql too hard to comprehend and who consider the relational calculus to be a useless difficult math stuff.

See, because of all this foolishness on the part of Mr. Maher and Mr. Dulkarni, FlipZon collapsed in matter of few days. Mr. Harris has lost all faith in almost everything and started to write books instead. Mr. Khan has lost all interest in shopping online and started an academy instead, so sad. So, now it is your job to restore the faith of Mr. Harris in sql and rdbms and bring Mr. Khan back to online shopping business by writing a better schema.

So design a schema that will ensure that all the relevant information can be stored and will reduce the redundancy as much as possible.

also make sure that your schema checks the modification requests before executing them using triggers i.e. write needed triggers to validate the input information before updating the database or after executing the insert/update/delete queries as desired

also make sure that your schema and queries are as general as possible, the more the general your schema/query the better it is

you may use the facilities provided by the sql supported by sqlite3

Refer the file about-practice-problems.txt at [0]. Barring this, you may wish to submit your solutions to these practice problems, and if you do wish so then you have to do the following - 

you have to send a single file with extension "tar.xz" as attachment. 
No other extension will be processed further. Name of the attached file should be your roll number. 
make sure that the file size doesn't exceed 50KB. Your roll number is a five digit string. If you do NOT name the file as per this rule, your practice problem submission might be ignored.

You have to send an email to "assignments<DOT>pucsd<AT>gmail<DOT>com" with the subject mentioned above. 

Note that I am going to filter messages on the basis of the subject text ONLY. So, you should send the email with the exact subject text given above. Even slight change might result in rejection.

If you have any doubts regarding the practice problems, you may meet me.

Ref:

[0] http://tinyurl.com/pucsdJuly16
[h] You may read more about some Sam Harris (not necessarily the Sam Harris who started flipzon) here https://en.wikipedia.org/wiki/Sam_Harris
[s] You may read more about some Salman Khan (not necessarily the Salman Khan who started flipzon) here https://en.wikipedia.org/wiki/Sal_Khan
[m] You may read more about some Bill Maher (not necessarily the Bill Maher who was hired by flipzon) here https://en.wikipedia.org/wiki/Bill_Maher
[k] You may read something about Mr. Kamodar Dulkarni (necessarily the Kamodar Dulkarni who designed and programmed flipzon) http://tinyurl.com/kamodar-dulkarni 
[z] You could have visited the great online shop flipzon at wwwww.flipzon.don.key but alas, as you already know the site is down as the business is shut due to the foolishness of you know who.
[btc] [it's funny that now many people are seen running behind bitcoin, the so called currency, and stuff like that; but that's a different story] https://bitcoinfees.21.co/ [see the estimated time in minutes per unit fee per byte, to entertain yourself]

Now start coding!

]
]
]
*/

