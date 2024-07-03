CREATE KEYSPACE vendor_search_app 
WITH replication={'class':'SimpleStrategy','replication_factor':1};

DESCRIBE keyspaces;

DESCRIBE keyspace vendor_search_app;

USE vendor_search_app;
-- to select the keyspace

-- to create the vendor table in the selected keyspace 
CREATE TABLE vendor(
	id int,
	name text,
	location text,
	ratings int, 
	type int,
	primary key(id)
);	

-- vendor is table in the keyspace "vendor_search_app"
-- id is the partition key  
-- id is the primary key 
-- the partition key is before the first comma 
--      if composite key 

CREATE TABLE vendor(
	id int PRIMARY KEY,
	name text,
	location text,
	ratings int, 
	type int
);	


-- redefine the vendor table based location based partition 
CREATE TABLE vendor(
	id int,
	name text,
	location text,
	ratings int, 
	type int,
	primary key(location,id)
);	

-- location is the partition key 
-- location + id is the clusturing primary key 

-- redefine the vendor table based location and vendor type based partition
CREATE TABLE vendor(
	id int,
	name text,
	location text,
	ratings int, 
	type int,
	primary key(location,type,id)
);	
-- mistake is there 
-- here we defined location as the partition key 


CREATE TABLE vendor(
	id int,
	name text,
	location text,
	ratings int, 
	type int,
	primary key((location,type),id)
);

--- (location,type) is the partition key 
--- (location,type) + id is the primary key 


--- Note: the columns if they are under filtering ie WHERE
---       those columns should have been indexed 
---       either primary index or secondary 


DROP TABLE vendor;


-- - final vendor applied for vendor_search application 


CREATE TABLE vendor(
	id int,
	name text,
	location text,
	ratings int, 
	type int,
	primary key((location,type),id)
);

INSERT INTO vendor(location,type,id, name, ratings)
VALUES('bangalore',1,1001,'aptech international',4);
INSERT INTO vendor(location,type,id, name, ratings)
VALUES('mysore',1,1002,'mtdn',4);
INSERT INTO vendor(location,type,id, name, ratings)
VALUES('bangalore',1,1003,'10 seconds',2);
INSERT INTO vendor(location,type,id, name, ratings)
VALUES('bangalore',2,1004,'sfj',4);
INSERT INTO vendor(location,type,id, name, ratings)
VALUES('mysore',1,1005,'delithe',5);


SELECT * FROM vendor;

-- column selector + filtering 
-- query the name ratings of the mysore college vendors
SELECT id, name, ratings FROM vendor
WHERE location='mysore' and type=1;

-- query the mtdn vendor 
SELECT id,name, location, type, ratings from vendor WHERE name='mtdn';
-- the above query will not run coz name is not indexed

-- to make this query run -- with "allow filtering"
SELECT id,name, location, type, ratings from vendor WHERE name='mtdn' allow filtering;
-- with "allow filtering" is not the best practice 

-- without "allow filtering", we can have the second index for the name field.

CREATE INDEX name_vendor ON vendor(name);

-- after indexed without "allow filtering"
SELECT id,name, location, type, ratings from vendor WHERE name='mtdn';

-- query the mtdn details based on id 
SELECT id,name, location, type, ratings from vendor WHERE id=1002;

-- only clustering key in the primary key will not work
-- to make the clustering key to work, include 
--  the partition keys along with 
SELECT id,name, location, type, ratings 
from vendor 
WHERE location='mysore' and type=1 
	and id=1002;


--- change the ratings of mtdn from 4 to 5 
UPDATE vendor 
SET ratings=5
WHERE location='mysore' and type=1 
	  and id=1002;


--- change the ratings of college mysore vendors to 3
UPDATE vendor 
SET ratings=3
WHERE location='mysore' and type=1;
-- not working coz of not id is included in update filtering

-- to delete entire vendor
DELETE FROM vendor;
-- not working

-- to delete vendor based on primary key 
DELETE FROM vendor WHERE location='mysore' and type=1 and id=1002;
-- deleted successfully 









