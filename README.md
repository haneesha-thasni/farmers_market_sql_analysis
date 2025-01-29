# Farmers Market SQL Queries

## 📌 Overview
This repository contains a collection of SQL queries designed for analyzing and managing data in a **Farmers Market** database. The queries cover various operations including data retrieval, filtering, aggregation, and joins.

## 📂 Database Schema
The database consists of the following key tables:
- **product**: Stores product details.
- **vendor_booth_assignments**: Tracks vendors and their booth assignments.
- **customer_purchases**: Logs purchase transactions made by customers.
- **customer**: Stores customer details.
- **market_date_info**: Contains market dates and weather-related information.
- **vendor**: Stores vendor details.
- **product_category**: Categorizes different products.
- **vendor_inventory**: Holds inventory details of vendors.

## 🚀 SQL Queries
### 📌 Basic Queries
1. **Retrieve all available products**
   ```sql
   SELECT product_name FROM product;
   ```
2. **List 10 vendor booth assignments**
   ```sql
   SELECT market_date, vendor_id, booth_number FROM vendor_booth_assignments LIMIT 10;
   ```
3. **Calculate total amount paid by customers**
   ```sql
   SELECT market_date, customer_id, vendor_id, quantity, cost_to_customer_per_qty,
          quantity * cost_to_customer_per_qty AS total_amount
   FROM customer_purchases;
   ```

### 📌 Filtering & Aggregation
4. **Merge customer first and last name**
   ```sql
   SELECT CONCAT(customer_first_name, ' ', customer_last_name) AS customer_name FROM customer;
   ```
5. **Extract product names from category 1**
   ```sql
   SELECT product_name FROM product WHERE product_category_id = 1;
   ```
6. **Count products sold on each market date**
   ```sql
   SELECT market_date, COUNT(*) FROM market_date_info GROUP BY market_date;
   ```

### 📌 Advanced Queries
7. **Get purchase history of customer ID 4**
   ```sql
   SELECT * FROM customer_purchases WHERE customer_id = 4
   ORDER BY market_date, vendor_id, product_id;
   ```
8. **Retrieve products within specific ID range**
   ```sql
   SELECT * FROM product WHERE product_id = 10 OR product_id BETWEEN 3 AND 8;
   ```
9. **Find details of all purchases by customer 4 from vendor 7**
   ```sql
   SELECT *, quantity * cost_to_customer_per_qty AS total_amt
   FROM customer_purchases WHERE customer_id = 4 AND vendor_id = 7;
   ```

### 📌 Join Queries
10. **List all products with their categories**
    ```sql
    SELECT p.product_name, pc.product_category_name
    FROM product p
    LEFT JOIN product_category pc ON p.product_category_id = pc.product_category_id;
    ```
11. **Get customers who have not made any purchases**
    ```sql
    SELECT customer_id FROM customer
    EXCEPT
    SELECT customer_id FROM customer_purchases;
    ```
12. **Find total spending of each customer per vendor**
    ```sql
    SELECT c.customer_first_name, c.customer_last_name, c.customer_id, v.vendor_id, v.vendor_name,
           SUM(cp.quantity * cp.cost_to_customer_per_qty) AS total_spend
    FROM customer c
    LEFT JOIN customer_purchases cp ON c.customer_id = cp.customer_id
    LEFT JOIN vendor v ON cp.vendor_id = v.vendor_id
    GROUP BY c.customer_id, v.vendor_id;
    ```

### 📌 Analytical Queries
13. **Find the highest and lowest prices in each product category**
    ```sql
    SELECT p.product_category_id, pc.product_category_name,
           MIN(cp.quantity * cp.cost_to_customer_per_qty) AS lowest_price,
           MAX(cp.quantity * cp.cost_to_customer_per_qty) AS highest_price
    FROM product p
    LEFT JOIN product_category pc ON p.product_category_id = pc.product_category_id
    LEFT JOIN customer_purchases cp ON p.product_id = cp.product_id
    GROUP BY pc.product_category_name, p.product_category_id;
    ```
14. **Count different products available on each market date**
    ```sql
    SELECT cp.market_date, COUNT(DISTINCT p.product_id) AS product_for_sale
    FROM customer_purchases cp
    INNER JOIN product p ON cp.product_id = p.product_id
    GROUP BY cp.market_date;
    ```
15. **Calculate average price of products per vendor**
    ```sql
    SELECT v.vendor_id, v.vendor_name, COUNT(DISTINCT vi.product_id) AS product_count,
           AVG(vi.original_price) AS average_price
    FROM vendor v
    LEFT JOIN vendor_inventory vi ON v.vendor_id = vi.vendor_id
    GROUP BY v.vendor_id, v.vendor_name;
    ```

## 💡 How to Use
1. Clone the repository:
   ```sh
   git clone https://github.com/haneesha-thasni/farmers-market-sql.git
   ```
2. Open your SQL client and import the **farmers_market** database.
3. Run queries in your preferred SQL environment.
4. Modify and extend queries based on your needs.

## 📜 License
This project is licensed under the MIT License.

## 🤝 Contributing
Contributions are welcome! Feel free to fork the repo and submit a pull request.

## 📬 Contact
For questions or suggestions, feel free to reach out via GitHub Issues.

---
📌 **Happy Querying!** 🚀

