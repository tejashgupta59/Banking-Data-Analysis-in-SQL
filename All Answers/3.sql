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




