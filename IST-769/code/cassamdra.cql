CREATE KEYSPACE shopping with replication = { 'class': 'SimpleStrategy', 'replication_factor':'3'};

DESCRIBE keyspaces;
USE shopping;


CREATE TABLE shopping.wish_list ( customer_id int, list_id int, created_on timestamp, cusomter_name text, wish_list_name text, items set<text>, PRIMARY KEY ( customer_id, list_id ));
describe TABLE wish_list;

INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (1,1,'2021-01-01', 'Sam', 'groceries list', {'Milk', 'Bread', 'Coffe'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (1,2,'2021-01-02', 'Sam', 'Electronics', {'TV', 'Play Station', 'Laptop'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (1,3,'2021-01-01', 'Sam', 'Books', {'Dune', 'Titanic'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (2,1,'2021-01-01', 'George', 'groceries list', {'Potato', 'Bread', 'Tea'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (2,2,'2021-01-02', 'George', 'Electronics', {'Boom Box', 'XBOX'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (2,3,'2021-01-06', 'George', 'Books', {'Dune', 'Learn Javascript'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (3,1,'2021-01-04', 'Tina', 'groceries list', {'Cheese'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (3,2,'2021-01-01', 'Tina', 'Electronics', {'XBOX'});
INSERT INTO wish_list (customer_id, list_id, created_on, cusomter_name, wish_list_name, items) VALUES (3,3,'2021-01-02', 'Tina', 'Books', {'Learn Java', 'Learn Spanish'});

SELECT * FROM wish_list;


CREATE INDEX ix_shopping_wish_list_items ON shopping.wish_list ( items );
SELECT * FROM shopping.wish_list WHERE items CONTAINS 'XBOX';

DROP MATERIALIZED VIEW IF EXISTS vw_shopping_wish_list;
CREATE MATERIALIZED VIEW vw_shopping_wish_list  AS SELECT * FROM shopping.wish_list WHERE customer_id IS NOT NULL AND list_id IS NOT NULL AND created_on IS NOT NULL AND cusomter_name IS NOT NULL AND wish_list_name IS NOT NULL AND items IS NOT NULL PRIMARY KEY (customer_id, created_on, list_id);

SELECT * FROM vw_shopping_wish_list WHERE customer_id = 1 AND created_on = '2021-01-01'