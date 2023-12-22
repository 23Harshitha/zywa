Use analytics_assignment1;
SELECT * FROM analytics_assignment1.transactions;

/*Query 1: Monthly transactions
Need how much amount we have processed each month commutative and every month.*/
SELECT 
    YEAR(transaction_timestamp) AS year,
    MONTH(transaction_timestamp) AS month,
    SUM(transaction_amount) AS monthly_amount,
    SUM(SUM(transaction_amount)) OVER (ORDER BY YEAR(transaction_timestamp), MONTH(transaction_timestamp)) AS cumulative_amount
FROM transactions
group by YEAR(transaction_timestamp), MONTH(transaction_timestamp)
order by year, month;
/*This Query helps us to identify the monthly amount and running summations that is current month and previous month+current month. This helps us to 
identify whether the amount being paid by customers is increasing consistently or change of plans required.*/
SELECT 
    YEAR(transaction_timestamp) AS year,
    MONTH(transaction_timestamp) AS month,
    SUM(transaction_amount) AS monthly_amount,
    SUM(SUM(transaction_amount)) OVER (ORDER BY YEAR(transaction_timestamp), MONTH(transaction_timestamp)) AS cumulative_amount
FROM transactions
group by YEAR(transaction_timestamp), MONTH(transaction_timestamp) with rollup 
order by year, month;



/*Query 2: Most Popular Products/Services
Design a SQL query to identify the top 5 most popular products or services based on transaction counts.*/
SELECT distinct(merchant_type) from transactions;
SELECT count(merchant_type), merchant_type from transactions group by merchant_type order by 1 desc limit 5;

/*This gives the most popular businesses customers are spending, this always helps to give incentives or perks to retain those businesses*/


/*Query 3: Daily Revenue Trend
Formulate a SQL query to visualize the daily revenue trend over time.*/
SELECT billing_amount, transaction_timestamp from transactions group by 2;
SELECT 
    YEAR(transaction_timestamp) AS year,
    MONTH(transaction_timestamp) AS month,
    SUM(billing_amount) AS monthly_amount,
    SUM(SUM(billing_amount)) OVER (ORDER BY YEAR(transaction_timestamp), MONTH(transaction_timestamp)) AS Total_amount
FROM transactions
group by YEAR(transaction_timestamp), MONTH(transaction_timestamp)
order by year, month;

/*This also gives the monthly finances with respect to billing amount, it is very important to know the difference 
between transaction amount and billing amount, and this helps us to acheive that.*/

/*Query 4: Average Transaction Amount by Product Category:
Formulate a SQL query to find the average transaction amount for each product category.*/
SELECT avg(transaction_amount) as Avg_Trasaction_Amt, merchant_name from transactions group by 2;
SELECT distinct(merchant_name) from transactions;

/*This gives clear picture of amount spent on different categories, this is useful to know which products the customers are spending more
because when this is known then similar businesses can be attracted to tie up with zywa payment application */


/*Query 5: Transaction Funnel Analysis
Create a SQL query to analyze the transaction funnel, including completed, pending, and cancelled transactions.
*/
SELECT distinct(card_entry) from transactions;
SELECT distinct(transaction_status) from transactions;
SELECT distinct(transaction_type) from transactions;
SELECT transaction_type,transaction_timestamp,
case when transaction_type = 'PURCHASE' then 'Completed'
     when transaction_type = 'ACCOUNT_VERIFICATION' then 'Pending'
     when transaction_type = 'CASH_WITHDRAWAL'  then 'Cancelled'
     else 'refund'
     end as transaction_funnel
     from transactions order by 2;
SELECT 
    transaction_type,
    COUNT(*) AS total_transactions from  transactions group by  
    transaction_type;

/*This query gives the successful transactions and also where the customers are failing and where immedeate damage control is required*/

/*Query 6: Monthly Retention Rate
Design a SQL query to calculate the Monthly Retention Rate, grouping users into monthly cohorts.*/
Select id, extract(month from transaction_timestamp) as months, transaction_timestamp 
from transactions group by 2 order by 2;

with masters as(
Select id, extract(month from transaction_timestamp) as months, transaction_timestamp 
from transactions
),

consolidated as (select this_month.months,this_month.id as current_month_customer, last_month.id as last_month_customer from masters this_month
left join masters last_month on 
this_month.id = last_month.id and this_month.months-last_month.months=1)

Select months, count(distinct(current_month_customer)) as current_month, count(distinct(last_month_customer)) as prev_customers from consolidated
group by months;

/*This is the most favorite aspect to be knoen to business and this was the tugh query for me, 
full honesty: I used little help 
for this query alone, because i kept confusing a lot . This helps to identify those customers who have been great in their payments 
and who are repitative*/