-- 7.Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). 
select CARTON_ID,min((c.LEN*c.WIDTH*c.HEIGHT)) as carton_vol from carton c where (c.LEN*c.WIDTH*c.HEIGHT)>
(
select sum((p.LEN*p.WIDTH*p.HEIGHT*PRODUCT_QUANTITY)) as Total_volume FROM PRODUCT p join ORDER_ITEMS oi on p.PRODUCT_ID=oi.PRODUCT_ID where oi.ORDER_ID=10006
);
 
-- 8.Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. 
select c.CUSTOMER_ID,concat(customer_fname,' ',customer_lname) as CUSTOMER_FULLNAME,sum(PRODUCT_QUANTITY),oi.ORDER_ID 
from ONLINE_CUSTOMER c
join ORDER_HEADER oh on c.CUSTOMER_ID=oh.CUSTOMER_ID
join ORDER_ITEMS oi on oh.ORDER_ID=oi.ORDER_ID
where ORDER_STATUS='Shipped'
group by oi.ORDER_ID
having sum(product_quantity)>10;

-- 9.Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060.
select oi.ORDER_ID,c.CUSTOMER_ID,concat(customer_fname,' ',customer_lname) as CUSTOMER_FULLNAME,(PRODUCT_QUANTITY) as TOTAL_QUANTITY 
from ONLINE_CUSTOMER c join ORDER_HEADER oh , ORDER_ITEMS oi
where c.CUSTOMER_ID=oh.CUSTOMER_ID
AND oh.ORDER_ID=oi.ORDER_ID
AND oi.ORDER_ID>10060 and ORDER_STATUS='Shipped'
group by oi.ORDER_ID;

-- 10.Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA?
SELECT PRODUCT_CLASS_DESC, SUM(product_quantity) as 'Total Quantity', product_price, SUM(product_quantity* product_price) as 'Total Value'
FROM PRODUCT p ,ADDRESS a, ONLINE_CUSTOMER c ,ORDER_HEADER oh,ORDER_ITEMS oi,PRODUCT_CLASS pc 
Where oh.CUSTOMER_ID = c.CUSTOMER_ID 
AND oi.PRODUCT_ID = p.PRODUCT_ID
AND pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE 
AND oi.ORDER_ID = oh.ORDER_ID
AND c.ADDRESS_ID = a.ADDRESS_ID 
AND a.COUNTRY NOT IN ('India', 'USA') and ORDER_STATUS='Shipped'
group by PRODUCT_CLASS_DESC
order by product_quantity DESC
limit 1;