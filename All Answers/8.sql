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




