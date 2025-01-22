 SELECT branch_id, AVG(balance) AS average_balance
FROM accounts
GROUP BY Branch_id
ORDER BY average_balance DESC limit 1;




