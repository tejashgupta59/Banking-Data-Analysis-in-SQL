# Banking-Data-Analysis-in-SQL
## Introduction:

Welcome to my SQL banking data analysis project! This project delves into a comprehensive dataset comprising Customers, Accounts, Transactions, and Branches tables. By leveraging SQL queries, I sought to uncover valuable insights and answer specific questions that can help a bank enhance its services, detect potential fraud, and optimize operations.

In this project, I used the STAR (Situation, Task, Action, Result) method to structure my approach and findings. The analysis addresses ten critical insights, ranging from identifying inactive customers to calculating average balances and ranking branch performance. The detailed explanation of each step, along with the SQL queries used, provides a clear and actionable understanding of the banking data.

Feel free to explore the insights and findings, and I hope you find this analysis both informative and useful!


## Situation:


In a banking environment, it's crucial to understand customer behaviors, transaction patterns, and overall financial health. I was tasked with analyzing banking data to derive actionable insights. The dataset included several tables: Customers, Accounts, Transactions, and Branches, with relationships established between them. The goal was to answer specific questions that would help the bank improve its services and operations.

## Task:

1.The objective was to analyze the banking data to answer the following ten questions:

2.Identify customers who haven't made transactions in the last year and suggest strategies to re-engage them.

3.Summarize the total transaction amount per account per month.

4.Rank branches based on the total deposits made in the last quarter.

5.Find the customer who deposited the highest amount.

6.Detect accounts with more than two transactions in a single day, which may indicate fraudulent activity, and propose verification methods.

7.Calculate the average number of transactions per customer per account per month over the last year.

8.Determine the daily transaction volume for the past month.

9.Calculate the total transaction amount performed by each age group in the past year.

10.Find the branch with the highest average account balance.

11.Calculate the average balance per customer at the end of each month over the past year.


## Action:

To achieve these objectives, I performed the following actions:



### Data Preparation:

Loaded the data from the respective tables (Customers, Accounts, Transactions, Branches).

Ensured that the relationships between tables were correctly established for accurate querying.


### Query Development:


Query 1: Identified customers with no transactions in the last year using a JOIN between Customers and Transactions tables, and filtered by transaction date.

```bash
SELECT DISTINCT(c.customer_id)  
FROM customers AS c 
JOIN accounts AS A
ON c.customer_id=A.customer_id
JOIN transactions AS T 
ON A.account_number=T.account_number
WHERE YEAR(transaction_date)<>2023
ORDER BY c.customer_id;
```

Query 2: Aggregated transaction amounts per account per month using GROUP BY on account number and month.

```bash
SELECT T.account_number, MONTH(t.transaction_date) AS Months,
ROUND(SUM(t.amount),2) AS total_amount
FROM accounts AS A
JOIN transactions AS T 
ON A.account_number=T.account_number
GROUP BY t.account_number, Months
ORDER BY t.account_number, Months;
```

Query 3: Calculated total deposits per branch in the last quarter, and used RANK() to rank the branches.

```bash
SELECT b.branch_id, ROUND(SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END),2) AS totaldeposit,
DENSE_RANK() OVER (ORDER BY SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END)DESC) AS branch_rank 
FROM Transactions AS t
JOIN Accounts AS a 
ON t.account_number=a.account_number
JOIN branches AS b
ON b.branch_id=a.branch_id 
WHERE t.transaction_date>= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY b.branch_id
ORDER BY totaldeposit DESC;
```

Query 4: Used a group by and order by functionn to find the maximum deposit amount and joined it with the Customers table to get the customer's name.

```bash
SELECT c.customer_id, concat(c.first_name, " " ,c.Last_name) 
AS customer_name, 
MAX(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) 
AS maximum_deposit 
FROM customers AS c 
JOIN accounts AS A
ON c.customer_id=A.customer_id
JOIN transactions AS T 
ON t.account_number=a.account_number
GROUP BY customer_id, customer_name 
ORDER BY maximum_deposit DESC LIMIT 1;
```

Query 5: Identified accounts with more than two transactions in a single day using GROUP BY and HAVING clauses, and proposed verification via transaction time analysis and customer confirmation.

```bash
SELECT account_number, 
DATE(transaction_date) AS transaction_date, 
COUNT(transaction_id) AS transaction_count
FROM Transactions
GROUP BY account_number, DATE(transaction_date)
HAVING COUNT(transaction_date) >2;
```

Query 6: Calculated the average number of transactions per customer per account per month using aggregate functions.

```bash
SELECT a.customer_id, a.account_number, 
YEAR(t.transaction_date) AS transaction_year, 
MONTH(t.transaction_date) AS transaction_month,
    COUNT(t.transaction_id) AS transaction_count,
    COUNT(t.transaction_id) / 12 AS avg_transactions_per_month_last_year
FROM transactions t
JOIN accounts a ON t.account_number = a.account_number
WHERE t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY a.customer_id, a.account_number, transaction_year, transaction_month
ORDER BY a.customer_id, a.account_number, transaction_year, transaction_month;
```

Query 7: Summed up daily transaction volume (total amount of all transactions) for the past month.

```bash
SELECT DATE(transaction_date) AS dates, 
ROUND(SUM(amount),2) AS transaction_volume 
FROM transactions
WHERE transaction_date>=DATE_SUB(CURDATE(), INTERVAL 1 month) 
GROUP BY  dates
ORDER BY dates;
```

Query 8: Grouped customers by age using case when and calculated the total transaction amount for each age group.

```bash
SELECT 
CASE WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURRENT_DATE())<=17 THEN "0-17" 
	 WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURRENT_DATE()) BETWEEN 18 AND 30 THEN "18-30"
     WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURRENT_DATE()) BETWEEN 31 AND 60 THEN "31-60"
     ELSE "60+" END AS Age_group,
     ROUND(SUM(t.amount),2) AS total_transaction_amount
FROM Customers AS c
JOIN Accounts AS a ON c.customer_id = a.customer_id
JOIN Transactions AS t ON a.account_number = t.account_number
WHERE t.transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY Age_group
ORDER BY AGE_group;
```

Query 9: Calculated the average account balance per branch and identified the highest using aggregation.

```bash
 SELECT branch_id, AVG(balance) AS average_balance
FROM accounts
GROUP BY Branch_id
ORDER BY average_balance DESC limit 1;
```

Query 10: Calculated the average balance per customer at the end of each month using joins and subquery.

```bash
  SELECT 
    c.customer_id, 
    YEAR(t.transaction_date) AS year, 
    MONTH(t.transaction_date) AS month,
    ROUND(AVG(a.balance), 3) AS avg_balance_per_customer
FROM accounts as a
INNER JOIN customers c ON a.customer_id = c.customer_id
INNER JOIN transactions t ON t.account_number = a.account_number
WHERE 
    t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- > 2023-7-11
    AND t.transaction_date = (
        SELECT MAX(t2.transaction_date)
        FROM transactions t2
        WHERE t2.account_number = t.account_number
        AND YEAR(t2.transaction_date) = YEAR(t.transaction_date)
        AND MONTH(t2.transaction_date) = MONTH(t.transaction_date))
GROUP BY 
    c.customer_id, 
    YEAR(t.transaction_date), 
    MONTH(t.transaction_date)
    order by  MONTH(t.transaction_date), YEAR(t.transaction_date);
```

## Result:

The analysis provided valuable insights into customer behavior, branch performance, and transaction patterns. Key results included:

A list of inactive customers with recommendations for re-engagement, such as targeted promotions and personalized offers.
Monthly transaction summaries that helped identify peak transaction periods and customer preferences.
Branch rankings that highlighted top-performing branches and those needing support.
Identification of potential fraudulent activities, with a proposed action plan for verification.
Average transaction metrics that informed customer service improvements and operational adjustments.
Demographic analysis that guided marketing strategies and product development.

















