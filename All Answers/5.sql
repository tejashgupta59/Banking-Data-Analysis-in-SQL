SELECT account_number, 
DATE(transaction_date) AS transaction_date, 
COUNT(transaction_id) AS transaction_count
FROM Transactions
GROUP BY account_number, DATE(transaction_date)
HAVING COUNT(transaction_date) >2;




