create database customer_behavior;
use customer_behavior;

SELECT * FROM customer_shopping_behavior; 
select gender,sum(purchase_amount) as revenue 
from customer_shopping_behavior
group by gender;

#2
select customer_id,purchase_amount
from customer_shopping_behavior
where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from customer_shopping_behavior
#3
select item_purchased,Round( avg(review_rating),2)as "average product rating" 
from customer_shopping_behavior
group by item_purchased
order by avg (review_rating)desc
limit 5;

#4
select shipping_type,
round(avg(purchase_amount),2)
from customer_shopping_behavior
where shipping_type in ('Standard','Express')
group by shipping_type

#5
select subscription_status,
count(customer_id)as total_customers,
round(avg(purchase_amount),2)as avg_spend,
round(sum(purchase_amount),2)as total_revenue
from customer_shopping_behavior
group by subscription_status
order by total_revenue,avg_spend desc;

#6
select item_purchased,
round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2)as discount_rate
from customer_shopping_behavior
group by item_purchased
order by discount_rate desc
limit 5;

#7
with customer_type as (
select customer_id,previous_purchases,
case 
when previous_purchases=1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as customer_segment
from customer_shopping_behavior
)
select customer_segment,count(*)as "Number of customers"
from customer_type
group by customer_segment


#8
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_shopping_behavior
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;


#9
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer_shopping_behavior
WHERE previous_purchases > 5
GROUP BY subscription_status;

#10
SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY total_revenue desc;
