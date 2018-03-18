'''
------------------------------------------------------------------
SQL
------------------------------------------------------------------
'''
--#Shell
--Initiate Postgres shell
psql

--View table and column definitions
\d

--See the column definitions
\d tablename


--#Basic
select price, userid from buyclicks where price > 10;


--#Join
SELECT adid, buyid, adclicks.userid
FROM adclicks JOIN buyclicks on adclicks.userid = buyclicks.userid;


--#Subquery
--Using function (aggregate query)
--Contain implicit join
SELECT beer, price
FROM Sells s1
WHERE price > (
    SELECT AVG(price)
    FROM Sells s2
    WHERE s1.bar = s2.bar
);


--#Groupby
--Logic operant
SELECT drinker, AVG(price)
FROM Frequents, Sells
WHERE beer = 'Bud' AND Frequents.bar = Sells.bar
GROUP BY drinker;








'''
------------------------------------------------------------------
MongoDB
------------------------------------------------------------------
'''
--#Basic operations
--MongoDB is a collection of documents (with JSON structure)
--collection = table in RMDB
SELECT * FROM Beers
db.Beers.find()

SELECT beer, price FROM Sells
db.Sells.find(
    --The 1st arg is query condition, similar to WHERE in SQL; here we have no condition and therefore empty
    {},

    --1 if it's output; 0 if not
    --_id is an item generated by the MongoDB and is default to return in every query; we can cancel the return by setting 0
    {beer:1, price:1, _id:0}
)

SELECT manf FROM Beers WHERE name = 'Heineken'
db.Beers.find(
    {name:"Heineken"}, --MongDB accept only ""
    {manf:1, _id:0}
)


--#Distinct operation
--MongoDB operators
SELECT DISTINCT beer, price FROM Sells WHERE price > 15
db.Sells.distinct(
    {price:{$gt:15}}, --$gt = greater than; $eq = equal; $gte; $in; $or; $not
    {beer:1, price:1, _id:0}}
)


--#MongDB use regular expression in partial comparison
--Use of function
--regex string is surrounded "/ /"; i as marker = case insensitive
db.Beers.find(
    name:{$regex:/am/i}
).count()

--Equivalent to above
db.Beers.count(
    name:{$regex:/am/i}
)


--#Use array in searching
--$nin = not in
db.Inventory.find(
    {tags:{$nin:["popular", "organic"]}}
)


--#Slice the result
db.Inventory.find(
    {},
    --The second and third elements of tags
    --$slice:[skip count, return how many]
    {tags:{$slice:[1, 2]}}
)


--#Logic operation
SELECT * FROM Inventory
WHERE ((price = 3.99) OR (price = 4.99)) AND ((rating = "good") OR (qty < 20)) AND item != "Coors"
db.Inventory.find(
    {
        $and:[
            {$or:[{price:3.99}, {price:4.99}]},
            {$or:[{rating:good}, {qty:{$lt:20}}]}, --$lt = less than
            {item:{$ne:"Coors"}} --$ne = unequal
        ]
    }
)

--Comma is implicitly deemed as $and operation in a {}
db.Users.find(
    {name:"test", name:"test2"}
)


--#Search nested obj
--Use '' to mark as an obj
--The first element of 'points' (a list), whose value of 'point'
db.Users.find(
    {'points.0.point':{$lte:80}}
)

--The first element of 'points' (a list), whose value of 'point'
--Any elements of the 'points' <= 80
db.Users.find(
    {'points.point':{$lte:80}}
)


--#Count
SELECT COUNT(*) FROM Drinkers
db.Drinfers.count()


--#Distinct
--Distinct value
SELECT COUNT(DISTINCT addr) FROM Drinkers
db.Drinkers.count(addr:{$exists:true}) --A bit stupid way

--Distinct an array element
db.Country.distinct(places) --'places' is an array
db.Country.distinct(places).length --As count


--#Aggregation framework
--A pipeline, transform the doc in each stage
db.Orders.aggregate([
    --Filter (= WHERE)
    {$match:{status:"A"}},

    --Group by 'cust_id' as new column '_id', and calculate sum of 'amount' as new column 'total'
    {$group:{_id:"$cust_id", total:{$sum:"$amount"}}},

    --Sort result
    --First by count
    --1 = ascending order; -1 = descending
    {$sort:{count:1, category:-1}}
])

--Multi-attribute grouping
db.Orders.aggregate([
    --Group by 'brand' and 'title' as new column '_id', and calculate sum of 'amount' as new column 'total'
    {
        $group:{_id:{brand:"$brand", title:"$title"}}, --_id with sub elements
        total:{$sum:"$amount"}}
    }
])


--#Text search (similar to Solr by Apache)
db.Articles.aggregate([
    --Using 'search' function of 'text'
    {$match:{$text:{$search:"Hillary Democrat"}}},

    --'textScore' is a metadata generated by the text search function
    --Assign 'textScore' to a new attribute 'score', and sort by 'score'
    {$sort:{score:{$meta:"textScore"}}},

    --Display option
    {$project:{title:1, _id:0}}
])


--#Join
db.Orders.aggregate([
    {
        $lookup:{
            from:"Inventory", --Another table to be joined with 'Orders'
            localField:"item", --Attribute used in 'Orders'
            foreignField:"sku", --Attribute used in 'Inventory'
            as:"inventory_docs" --Output a list of sub docs as 'inventory_docs' attribute
        }
    }
])








'''
------------------------------------------------------------------
Aerospike
------------------------------------------------------------------
'''