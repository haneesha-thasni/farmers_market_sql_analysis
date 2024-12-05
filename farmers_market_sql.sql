use farmers_market;

 -- 1. Get all the products available in the market 
 select product_name from product;
 
 /* 2. List down 10 rows of vendor booth assignments, displaying the market date,
 vendor ID, and booth number from the vendor_booth_assignments table.
 */
 select market_date,vendor_id,booth_number from vendor_booth_assignments limit 10;
 
 /* 3.  In the customer purchases, we have quantity and cost per qty separate, query 
the total amount that the customer has paid along with date, customer id, 
vendor_id, qty, cost per qty and the total amt.?
*/
select market_date,customer_id,vendor_id,quantity,cost_to_customer_per_qty, quantity*cost_to_customer_per_qty as total_amount from customer_purchases;

/* 4. Merge each customer’s name into a single column that contains the first 
name, then a space, and then the last name. 
*/
select concat(customer_first_name," ",customer_last_name)customer_name from customer;

-- 5. Extract all the product names that are part of product category 1.
select product_name from product where product_category_id=1;

--  6. How many products where for sale on each market date.
select market_date,count(*) from market_date_info GROUP BY market_date;

/* 7. Print a report of everything customer_id 4 has ever purchased at the 
farmer’s market, sorted by market date, vendor ID, and product ID. 
*/
select * from customer_purchases where customer_id=4 ORDER BY market_date,vendor_id,product_id;

/* 8. Get all the product info for products with id between 3 and 8 (not inclusive) 
or product with id 10.
*/
select * from product where product_id=10 or product_id BETWEEN 3 and 8;
select * from product where product_id=10 or product_id>3 and product_id<8;

/* 9. Details of all the purchases made by customer_id 4 at vendor_id 7, along 
with the total_amt.
*/
select *,quantity*cost_to_customer_per_qty as total_amt from customer_purchases where customer_id=4 and vendor_id=7;

 /* 10. Find the customer detail with the first name of “carlos” or the last name of 
“diaz”.
*/
select * from customer where customer_first_name="carlos" and customer_last_name="diaz";

/* 11. Find the booth assignments for vendor 7 for any market date that occurred 
between april 3, 2019, and may 16, 2019.
*/
select * from vendor_booth_assignments where vendor_id=7 and market_date between "2019-04-03" and "2019-05-16";

/* 12. Return a list of customers with selected last names - [diaz, edwards and 
wilson]. 
*/
select concat(customer_first_name," ",customer_last_name)customer_name from customer where customer_last_name IN("diaz","edwards","wilson");
 
-- 13. Analyze purchases made at the farmer’s market on days when it rained. 
select market_rain_flag from market_date_info;
select * from customer_purchases where market_date IN(select market_date from market_date_info where  market_rain_flag=1);
 -- 14. Return all products without sizes.
 select * from product where product_size is NULL or product_size=" ";
 
 /* 15.  You want to get data about a customer you knew as “jerry,” but you aren’t 
sure if he was listed in the database as “jerry” or “jeremy” or “jeremiah.”  
How would you get the data from this partial string? 
*/
select customer_id,customer_zip,concat(customer_first_name," ",customer_last_name)customer_name from customer where customer_first_name LIKE "jer%";
select * from customer where customer_last_name LIKE"jer%";

/* 16. We want to merge each customer’s name into a single column that contains 
the first name, then a space, and then the last name in upper case.
*/
select upper(concat(customer_first_name," ",customer_last_name))customer_name from customer;

/* 17. Find out what booths vendor 2 was assigned to on or before (less than or 
equal to) april 20, 2019.
*/
select booth_number from vendor_booth_assignments where vendor_id=2 and market_date<="2019-04-20";

-- 18. Find out which vendors primarily sell fresh produce and which don’t. 
select vendor_type from vendor;
select *,
case 
when vendor_type like "%fresh%" 
THEN 'Sells Fresh Produce'
ELSE 
'Do Not Sell Fresh Produce' 
end as fresh_or_not 
from vendor;

-- 19. Calculate the total quantity purchased by each customer per market_date.
select customer_id,market_date, sum(quantity) as total_quantity from customer_purchases GROUP BY customer_id,market_date;

 /* 20. How many different kinds of products were purchased by each customer 10 
in each market date .
*/
select market_date,count(DISTINCT product_id) as product_count from customer_purchases where customer_id=10 GROUP BY market_date;


-- joins
-- 1. 1.	List all the products and their product categories.
select product.product_name,product_category.product_category_name from product left join product_category on product.product_category_id=product_category.product_category_id;

-- 2. Get all the Customers who have purchased nothing from the market yet.
select customer_id from customer 
except 
select customer_id from customer_purchases;

-- 3. List all the customers and their associated purchases
select customer.customer_id,customer_purchases.product_id from customer 
left join customer_purchases on customer.customer_id=customer_purchases.customer_id GROUP BY customer.customer_id,customer_purchases.product_id;

-- 4. Write a query that returns a list of all customers who did not purchase on March 2, 2019
select customer_id from customer
except
select customer_id from customer_purchases where market_date='2019-03-02';

-- 5. filter out vendors who brought at least 10 items to the farmer’s market over the time period - 2019-05-02 and 2019-05-16
select v.vendor_id from vendor as v
left join customer_purchases as cp on v.vendor_id=cp.vendor_id
where cp.market_date between "2019-05-02" and "2019-05-16" 
GROUP BY v.vendor_id having count(cp.product_id)>=10;

-- 6. Show details about all farmer’s market booths and every vendor booth assignment for every market date
select b.booth_number,booth_type,vba.market_date,v.vendor_id,vendor_name from booth b left join vendor_booth_assignments as vba
on vba.booth_number=b.booth_number
left join vendor as v on v.vendor_id=vba.vendor_id
ORDER BY vba.market_date,b.booth_number;

-- 7.find out how much this customer had spent at each vendor, regardless of date? (Include customer_first_name, customer_last_name, customer_id, vendor_name, vendor_id, price)
select c.customer_first_name,c.customer_last_name,c.customer_id,v.vendor_id,v.vendor_name,cp.quantity*cost_to_customer_per_qty as total_spend from customer as c
left join customer_purchases as cp on c.customer_id=cp.customer_id
left join vendor as v on cp.vendor_id=v.vendor_id;

-- 8. get the lowest and highest prices within each product category include (product_category_name, product_category_id, lowest price, highest _price)
select p.product_category_id,pc.product_category_name,min(cp.quantity*cost_to_customer_per_qty)as lowest_price,max(cp.quantity*cost_to_customer_per_qty)as highest_price from product as p 
left join product_category as pc on p.product_category_id=pc.product_category_id
left join customer_purchases as cp on p.product_id=cp.product_id GROUP BY pc.product_category_name,p.product_category_id;

-- 9. Count how many products were for sale on each market date, or how many different products each vendor offered.
select cp.market_date,count(DISTINCT p.product_id)as product_for_sale from customer_purchases as cp inner join product as p 
on cp.product_id=p.product_id GROUP BY cp.market_date;
select v.vendor_id,v.vendor_name,count(DISTINCT cp.product_id) as count_of_different_product from customer_purchases as cp right join vendor as v
on cp.vendor_id=v.vendor_id GROUP BY v.vendor_id,v.vendor_name;

-- 10. In addition to the count of different products per vendor, we also want the average original price of a product per vendor?
select v.vendor_id,v.vendor_name,count(DISTINCT vi.product_id) as count_of_different_product,avg(vi.original_price) as average_price
from vendor as v left join vendor_inventory as vi on v.vendor_id=vi.vendor_id GROUP BY v.vendor_id,v.vendor_name;


