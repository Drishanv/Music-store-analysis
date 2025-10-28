# 🎵 SQL Music Database Analysis Project

## 📘 Project Overview
This project focuses on analyzing a **fictional music database** using SQL to extract valuable business insights.  
The goal is to explore relationships between **customers, sales, employees, artists, and music genres** by writing and executing SQL queries of varying complexity.

This project demonstrates practical SQL skills such as:
- Data filtering and sorting  
- Aggregations and grouping  
- Joins across multiple tables  
- Common Table Expressions (CTEs)  
- Window functions for advanced analytics  

---

## 🧩 Dataset Structure
The database contains the following tables:

| Table Name | Description |
|-------------|-------------|
| **employee** | Employee details including job title and seniority levels |
| **invoice** | Invoice data with billing and total amount information |
| **customer** | Customer details such as name, email, and contact information |
| **invoice_line** | Detailed line items within each invoice |
| **track** | Track details including name, genre, and duration |
| **album** | Album information linked to artists |
| **artist** | Artist details |
| **genre** | Genre information |

Each table is connected via key fields like `customer_id`, `invoice_id`, `track_id`, and `artist_id`.

---

## 🧠 SQL Query Tasks

### 🟢 Easy Level
1. **Find the most senior employee**  
   - Sort by job title or seniority level.  

2. **Determine which countries have the most invoices**  
   - Group by `billing_country` and count totals.  

3. **Identify the top 3 invoice totals**  
   - Sort the `invoice` table by total in descending order.  

4. **Find the city with the highest total invoice amount**  
   - Helps determine the best city for a promotional event.  

5. **Identify the customer who has spent the most money**  
   - Join `customer` and `invoice`, group by customer, and sum the totals.  

---

### 🟡 Moderate Level
1. **Find customers who listen to Rock music**  
   - Join `customer`, `invoice`, `invoice_line`, and `track`, and filter where `genre = 'Rock'`.  

2. **Identify the top 10 rock artists by track count**  
   - Join `artist`, `album`, and `track` tables, filter by Rock, and count tracks per artist.  

3. **Find all track names longer than the average track length**  
   - Calculate average track length and filter where `track.length > avg_length`.  

---

### 🔴 Advanced Level
1. **Calculate how much each customer has spent on each artist**  
   - Use a **CTE** to compute artist earnings from `invoice_line`, and join with `customer`, `invoice`, and `artist`.  

2. **Determine the most popular music genre per country**  
   - Use a **CTE** or **window function** to rank genres by purchase count per country.  

3. **Identify the top-spending customer in each country**  
   - Calculate total spending per customer per country and select the top value per group.  

---

## 🧮 Project Guidelines

1. **Step-by-Step Execution**  
   - Execute and validate each query one by one.

2. **Use of CTEs and Window Functions**  
   - For complex queries, use CTEs to make your logic modular and clear.

3. **Testing and Validation**  
   - Verify each query using sample data for accuracy and consistency.

4. **Query Documentation**  
   - Comment each query to explain logic and design choices.

5. **Final Presentation**  
   - Summarize all findings, especially customer and sales-related insights that can aid business decisions.

---

## 📊 Expected Outcomes
By the end of this project, you should have:

- A set of **optimized SQL queries** providing insights such as:
  - Most profitable cities  
  - Top-spending customers  
  - Most popular genres by country  
  - Best artists based on track sales  
- A **final report** summarizing:
  - Customer and sales trends  
  - Genre popularity distribution  
  - Event planning recommendations based on geographic insights  

---

## 🧾 Deliverables
- SQL query scripts (`.sql` file)
- README documentation (this file)
- Summary report of business insights

---

## 💡 Tools and Requirements
- **SQL Database:** SQLite / MySQL / PostgreSQL (any compatible engine)
- **SQL IDE:** DBeaver / MySQL Workbench / VS Code SQL extension
- **Skills Used:** Joins, Aggregations, CTEs, Window Functions, Sorting, Grouping

---

## 🏁 Conclusion
This SQL project helps bridge data analysis and business strategy by exploring patterns in a fictional music dataset.  
Through structured queries, you'll uncover insights into **customer behavior**, **music preferences**, and **sales performance**—essential skills for any aspiring **data analyst or business intelligence professional**.

---

### 🏷️ Author
**Subhajit SEO**  
📧 inspiredmugan@gmail.com  
💼 AN Associate Co Inc.

---

**ALL THE BEST!!!**
