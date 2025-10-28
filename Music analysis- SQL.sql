CREATE DATABASE IF NOT EXISTS music_store;
USE music_store;

-- Drop in dependency-safe order
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS playlist_track;
DROP TABLE IF EXISTS playlist;
DROP TABLE IF EXISTS invoice_line;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS media_type;
DROP TABLE IF EXISTS genre;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. artist
CREATE TABLE artist (
  artist_id INT PRIMARY KEY,
  name VARCHAR(255)
);

-- 2. album
CREATE TABLE album (
  album_id INT PRIMARY KEY,
  title VARCHAR(255),
  artist_id INT,
  FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

-- 3. genre
CREATE TABLE genre (
  genre_id INT PRIMARY KEY,
  name VARCHAR(100)
);

-- 4. media_type
CREATE TABLE media_type (
  media_type_id INT PRIMARY KEY,
  name VARCHAR(100)
);

-- 5. employee
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  last_name VARCHAR(100),
  first_name VARCHAR(100),
  title VARCHAR(100),
  reports_to INT NULL,
  levels VARCHAR(10),
  birthdate DATETIME NULL,
  hire_date DATETIME NULL,
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(40),
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(255),
  INDEX idx_employee_reports_to (reports_to)
);

-- 6. customer
CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  company VARCHAR(255),
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(40),
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(255),
  support_rep_id INT,
  FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id)
);

-- 7. invoice
CREATE TABLE invoice (
  invoice_id INT PRIMARY KEY,
  customer_id INT,
  invoice_date DATETIME NULL,
  billing_address VARCHAR(255),
  billing_city VARCHAR(100),
  billing_state VARCHAR(100),
  billing_country VARCHAR(100),
  billing_postal_code VARCHAR(40),
  total DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 8. invoice_line
CREATE TABLE invoice_line (
  invoice_line_id INT PRIMARY KEY,
  invoice_id INT,
  track_id INT,
  unit_price DECIMAL(10,4),
  quantity INT,
  FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);

-- 9. playlist
CREATE TABLE playlist (
  playlist_id INT PRIMARY KEY,
  name VARCHAR(255)
);

-- 10. playlist_track
CREATE TABLE playlist_track (
  playlist_id INT,
  track_id INT,
  PRIMARY KEY (playlist_id, track_id),
  FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id)
);

-- 11. Track

CREATE TABLE track (
  track_id      INT PRIMARY KEY,
  name          VARCHAR(255),
  album_id      INT,
  media_type_id INT,
  genre_id      INT,
  composer      VARCHAR(255),
  milliseconds  INT,
  bytes         INT,
  unit_price    DECIMAL(10,4)
);

-- Easy level questions 

-- Q1: Most senior employee (levels like 'L1'...'L7')
SELECT *
FROM employee
ORDER BY CAST(SUBSTRING(levels, 2) AS UNSIGNED) DESC
LIMIT 1;

-- Q2: Countries with the most invoices
SELECT billing_country, COUNT(*) AS invoice_count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

-- Q3: Top 3 invoice totals
SELECT invoice_id, total
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4: City with the highest total invoice amount
SELECT billing_city, SUM(total) AS city_revenue
FROM invoice
GROUP BY billing_city
ORDER BY city_revenue DESC
LIMIT 1;

-- Q5: Customer who has spent the most money
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(i.total) AS lifetime_value
FROM customer c
JOIN invoice  i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_value DESC
LIMIT 1;

-- Moderate level questions

-- Q1: Email + name of customers who listen to Rock
WITH rock_invoices AS (
  SELECT DISTINCT i.customer_id
  FROM invoice i
  JOIN invoice_line il ON il.invoice_id = i.invoice_id
  JOIN track t        ON t.track_id    = il.track_id
  JOIN genre g        ON g.genre_id    = t.genre_id
  WHERE g.name = 'Rock'
)
SELECT c.email, c.first_name, c.last_name
FROM customer c
JOIN rock_invoices r ON r.customer_id = c.customer_id
ORDER BY c.email;

-- Q2: Top 10 Rock artists by track count
SELECT ar.artist_id, ar.name AS artist_name, COUNT(*) AS rock_track_count
FROM artist ar
JOIN album  al ON al.artist_id = ar.artist_id
JOIN track  t  ON t.album_id   = al.album_id
JOIN genre  g  ON g.genre_id   = t.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY rock_track_count DESC
LIMIT 10;

-- Q3: Tracks longer than the average track length (milliseconds)
WITH avg_len AS (
  SELECT AVG(milliseconds) AS avg_ms FROM track
)
SELECT t.track_id, t.name, t.milliseconds
FROM track t
JOIN avg_len a ON t.milliseconds > a.avg_ms
ORDER BY t.milliseconds DESC;

-- Advanced level questions

-- Q1: How much each customer has spent on each artist
WITH line_value AS (
  SELECT il.invoice_line_id,
         il.invoice_id,
         (il.unit_price * il.quantity) AS line_total,
         t.track_id,
         al.album_id,
         ar.artist_id
  FROM invoice_line il
  JOIN track t  ON t.track_id  = il.track_id
  JOIN album al ON al.album_id = t.album_id
  JOIN artist ar ON ar.artist_id = al.artist_id
),
cust_artist_spend AS (
  SELECT i.customer_id, lv.artist_id, SUM(lv.line_total) AS spend
  FROM line_value lv
  JOIN invoice i ON i.invoice_id = lv.invoice_id
  GROUP BY i.customer_id, lv.artist_id
)
SELECT c.customer_id, c.first_name, c.last_name,
       ar.name AS artist_name, cas.spend
FROM cust_artist_spend cas
JOIN customer c ON c.customer_id = cas.customer_id
JOIN artist   ar ON ar.artist_id = cas.artist_id
ORDER BY cas.spend DESC, c.customer_id, ar.name;

-- Q2: Most popular music genre for each country (by purchase count)
WITH country_genre AS (
  SELECT i.billing_country,
         g.genre_id,
         g.name AS genre_name,
         COUNT(*) AS purchases
  FROM invoice i
  JOIN invoice_line il ON il.invoice_id = i.invoice_id
  JOIN track t  ON t.track_id = il.track_id
  JOIN genre g  ON g.genre_id = t.genre_id
  GROUP BY i.billing_country, g.genre_id, g.name
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY billing_country
           ORDER BY purchases DESC, genre_name
         ) AS rn
  FROM country_genre
)
SELECT billing_country, genre_id, genre_name, purchases
FROM ranked
WHERE rn = 1
ORDER BY billing_country;

-- Q3: Top-spending customer per country
WITH country_customer AS (
  SELECT i.billing_country,
         c.customer_id, c.first_name, c.last_name,
         SUM(i.total) AS spend
  FROM invoice i
  JOIN customer c ON c.customer_id = i.customer_id
  GROUP BY i.billing_country, c.customer_id, c.first_name, c.last_name
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY billing_country
           ORDER BY spend DESC, last_name, first_name
         ) AS rn
  FROM country_customer
)
SELECT billing_country, customer_id, first_name, last_name, spend
FROM ranked
WHERE rn = 1
ORDER BY billing_country;

