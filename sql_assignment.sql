create database customers;
use customers;
-- Create Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    rating DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Order Details table
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Customers
INSERT INTO customers (first_name, last_name, email, phone, address, city, country) VALUES
('John', 'Doe', 'john.doe@email.com', '1234567890', '123 Main St', 'New York', 'USA'),
('Alice', 'Smith', 'alice.smith@email.com', '2345678901', '456 Elm St', 'Los Angeles', 'USA'),
('Michael', 'Johnson', 'michael.johnson@email.com', '3456789012', '789 Pine St', 'Chicago', 'USA'),
('Emma', 'Williams', 'emma.williams@email.com', '4567890123', '321 Oak St', 'Houston', 'USA'),
('Oliver', 'Brown', 'oliver.brown@email.com', '5678901234', '654 Maple St', 'Phoenix', 'USA'),
('Sophia', 'Jones', 'sophia.jones@email.com', '6789012345', '987 Birch St', 'Philadelphia', 'USA'),
('Liam', 'Garcia', 'liam.garcia@email.com', '7890123456', '741 Cedar St', 'San Antonio', 'USA'),
('Isabella', 'Martinez', 'isabella.martinez@email.com', '8901234567', '852 Spruce St', 'San Diego', 'USA'),
('Noah', 'Davis', 'noah.davis@email.com', '9012345678', '963 Willow St', 'Dallas', 'USA'),
('Mia', 'Rodriguez', 'mia.rodriguez@email.com', '0123456789', '147 Palm St', 'San Jose', 'USA');

-- Insert Products
INSERT INTO products (product_name, category, price, stock_quantity, rating) VALUES
('iPhone 14', 'Electronics', 999.99, 50, 4.8),
('Samsung Galaxy S22', 'Electronics', 899.99, 40, 4.7),
('MacBook Pro 16', 'Electronics', 2499.99, 30, 4.9),
('Dell XPS 13', 'Electronics', 1299.99, 20, 4.6),
('Sony WH-1000XM4', 'Accessories', 349.99, 100, 4.8),
('Apple Watch Series 8', 'Wearables', 429.99, 70, 4.7),
('Samsung Galaxy Watch 5', 'Wearables', 329.99, 60, 4.5),
('Nintendo Switch', 'Gaming', 299.99, 80, 4.9),
('PlayStation 5', 'Gaming', 499.99, 25, 4.9),
('Xbox Series X', 'Gaming', 499.99, 30, 4.8),
('Bose QuietComfort 45', 'Accessories', 299.99, 90, 4.7),
('Google Pixel 7', 'Electronics', 599.99, 45, 4.6),
('Amazon Echo Dot', 'Smart Home', 49.99, 150, 4.5),
('Samsung 55 QLED TV', 'Electronics', 1299.99, 20, 4.8),
('LG 65 OLED TV', 'Electronics', 1999.99, 15, 4.9);

-- Insert Orders
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 1999.98, 'Shipped'),
(2, 899.99, 'Pending'),
(3, 2499.99, 'Delivered'),
(4, 1299.99, 'Shipped'),
(5, 349.99, 'Pending'),
(6, 429.99, 'Cancelled'),
(7, 299.99, 'Delivered'),
(8, 499.99, 'Shipped'),
(9, 499.99, 'Pending'),
(10, 1299.99, 'Delivered');

-- Insert Order Details
INSERT INTO order_details (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 2, 1999.98),
(2, 2, 1, 899.99),
(3, 3, 1, 2499.99),
(4, 4, 1, 1299.99),
(5, 5, 1, 349.99),
(6, 6, 1, 429.99),
(7, 7, 1, 299.99),
(8, 8, 1, 499.99),
(9, 9, 1, 499.99),
(10, 10, 1, 1299.99);

select * from customers;


01.total_revenue_per_month_(only_delivered_orders)

SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month DESC;

02.TOP 5 best-selling products_by_quantity 
SELECT 
p.product_name,
SUM(od.quantity) AS total_units_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;

---03.Customer who spent the most
SELECT 
c.first_name,
c.last_name,
SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

---04.Products out_of_stock
SELECT product_name
FROM products
WHERE stock_quantity = 0;

----05.Orders with_more_than one product
SELECT 
order_id,
COUNT(product_id) AS product_count
FROM order_details
GROUP BY order_id
HAVING COUNT(product_id) > 1
ORDER BY product_count DESC;

---06.Rank_customers by_total purchase (Top 3)
SELECT 
c.first_name,
c.last_name,
SUM(o.total_amount) AS total_spent,
RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank_no
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
LIMIT 3;

---07.Delivered orders (order_ID, customer, total, status)
SELECT 
o.order_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
o.total_amount,
o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered';

---08.Orders without_any products
SELECT o.order_id, o.status
FROM orders o
LEFT JOIN order_details od ON o.order_id = od.order_id
WHERE od.order_id IS NULL;

---09.Delivered or Pending orders (no duplicates)
SELECT DISTINCT order_id, status
FROM orders
WHERE status IN ('Delivered', 'Pending');

---10.Total revenue per product category
SELECT 
p.category,
SUM(od.subtotal) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category;

---11.Best-selling product in_each category
SELECT category, product_name, total_sold
FROM (
SELECT 
p.category,
p.product_name,
SUM(od.quantity) AS total_sold,
RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.quantity) DESC) AS rnk
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category, p.product_name
) ranked
WHERE rnk = 1;

---12.Total spending per customer (highest → lowest)
SELECT 
c.first_name,
c.last_name,
SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

---13.average_order_value

SELECT 
SUM(total_amount) / COUNT(order_id) AS avg_order_value
FROM orders;

---14.customers_with_number_of_orders
SELECT 
c.first_name,
c.last_name,
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

---15.Cumulative revenue over_time
SELECT 
order_date,
SUM(total_amount) OVER (ORDER BY order_date) AS cumulative_revenue
FROM orders
ORDER BY order_date;

---16.customers_with nore than one order
SELECT 
c.first_name,
c.last_name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1;











