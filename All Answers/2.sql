SELECT T.account_number, MONTH(t.transaction_date) AS Months,
ROUND(SUM(t.amount),2) AS total_amount
FROM accounts AS A
JOIN transactions AS T 
ON A.account_number=T.account_number
GROUP BY t.account_number, Months
ORDER BY t.account_number, Months;




