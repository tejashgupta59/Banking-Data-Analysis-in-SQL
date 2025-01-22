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




