/*Q1 As a data analyst at a prestigious educational institution, you are tasked with analyzing the project submission patterns of students in different batches. The institution has two tables: Students and Project_Submissions. The Students table contains information about each student, including their unique identifier stu_id, name stu_name, and batch. The Project_Submissions table contains information about each project submission, including the submitting student's ID stu_id, project ID project_id, and submission date submitted_on.

Write a SQL query to find the following categories of students:

Students who have never submitted a project.
Students who have submitted exactly one project.
Students who have submitted multiple projects.
Your query should return the student names, batches, and submission counts for each category.*/

SELECT
    s.stu_name,
    s.batch,
    COUNT(p.project_id) AS submission_count,
    CASE
        WHEN COUNT(p.project_id) = 0 THEN 'Never submitted'
        WHEN COUNT(p.project_id) = 1 THEN 'Submitted exactly one project'
        ELSE 'Submitted multiple projects'
    END AS submission_category
FROM Students s
LEFT JOIN Project_Submissions p
    ON s.stu_id = p.stu_id
GROUP BY s.stu_id, s.stu_name, s.batch;


/*Q2 E-commerce company "ShoppingZone" wants to create a comprehensive product catalog that includes product information, category details, and applicable discounts. The company has three tables: Products, Categories, and Discounts.

The Products table contains the following columns:

| Column Name | Data Type | Description |
| --- | --- | --- |
| prod_id | int | Unique product identifier |
| prod_name | varchar(50) | Product name |
| category_id | int | Foreign key referencing the Categories table |
The Categories table contains the following columns:

| Column Name | Data Type | Description |
| --- | --- | --- |
| category_id | int | Unique category identifier |
| category_name | varchar(50) | Category name |
The Discounts table contains the following columns:

| Column Name | Data Type | Description |
| --- | --- | --- |
| prod_id |int 	|unique product identifier|
isdcount_percent 	decimal   Discount percentage |
Write a SQL query to show all products, categories, and discounts including categories without products and products without categories or discounts.

Hint: You may need to use multiple JOIN operations to achieve this.*/

SELECT
    p.prod_id,
    p.prod_name,
    c.category_id,
    c.category_name,
    d.isdcount_percent
FROM Products p
LEFT JOIN Categories c
    ON p.category_id = c.category_id
LEFT JOIN Discounts d
    ON p.prod_id = d.prod_id

UNION

SELECT
    p.prod_id,
    p.prod_name,
    c.category_id,
    c.category_name,
    NULL AS isdcount_percent
FROM Categories c
LEFT JOIN Products p
    ON p.category_id = c.category_id;


/*Q3 The social media platform, "ConnectMe", wants to analyze its user base to understand their behavior and preferences. The platform has three tables: Customers, Transactions, and Complaints. The Customers table contains the customer ID (cust_id) and customer name (cust_name). The Transactions table contains the transaction ID (txn_id), customer ID (cust_id), and transaction amount. The Complaints table contains the complaint ID (complaint_id), customer ID (cust_id), and a flag indicating whether the complaint is resolved or not.

Write a SQL query to generate a report that lists all customers along with their total transaction amount and complaint status (if any). Include customers with no transactions or complaints in the report.

Assume that the tables are already created, and you only need to write the SQL query to generate the desired report.

Mark your answer using markdown for code formatting.*/

SELECT
    c.cust_id,
    c.cust_name,
    COALESCE(SUM(DISTINCT t.transaction_amount), 0) AS total_transaction_amount,
    MAX(co.complaint_status) AS complaint_status
FROM Customers c
LEFT JOIN Transactions t
    ON c.cust_id = t.cust_id
LEFT JOIN Complaints co
    ON c.cust_id = co.cust_id
GROUP BY
    c.cust_id,
    c.cust_name;
    

/*Q4 A leading airline company is looking to analyze its flight routes and airport connections. They have two tables, Flights and Airports. The Flights table contains information about each flight, including its ID, source airport, and destination airport. The Airports table contains information about each airport, including its code and city.

The company wants to generate every possible combination of flights and airports for analysis. This means they want to combine each flight with every airport in the system, regardless of whether the airport is the source or destination of the flight.

Write a SQL query using JOIN operations to generate this combined data. Your query should return a table with the following columns: flight_id, source_airport_code, source_city, destination_airport_code, destination_city, all_airport_codes.

Assume that the Flights table has 10,000 rows and the Airports table has 1,000 rows.*/

SELECT
    f.flight_id,
    f.source_airport AS source_airport_code,
    src.city AS source_city,
    f.destination_airport AS destination_airport_code,
    dest.city AS destination_city,
    a.airport_code AS all_airport_codes
FROM Flights f
JOIN Airports src
    ON f.source_airport = src.airport_code
JOIN Airports dest
    ON f.destination_airport = dest.airport_code
CROSS JOIN Airports a;

/*Q5 The school administration wants to generate a report that lists all teachers and the subjects they teach. The report should also include teachers who do not teach any subjects and subjects that have no teacher assigned. The database contains two tables: Teachers and Subjects. The Teachers table has columns t_id (teacher ID) and t_name (teacher name). The Subjects table has columns sub_id (subject ID), subject_name, and t_id (foreign key referencing the teacher who teaches the subject).

Write a SQL query to generate this report.

Assumptions:

Each teacher can teach multiple subjects.
Each subject can be taught by only one teacher.
There are no duplicate entries in either table.*/

SELECT
    t.t_id,
    t.t_name,
    s.subject_name
FROM Teachers t
LEFT JOIN Subjects s
    ON t.t_id = s.t_id

UNION

SELECT
    t.t_id,
    t.t_name,
    s.subject_name
FROM Teachers t
RIGHT JOIN Subjects s
    ON t.t_id = s.t_id;


/*Q6 A popular book review website needs to analyze the performance of its authors and their books. The website has three tables: Authors, Books, and Reviews. The Authors table contains information about each author, including their unique author_id and author_name. The Books table contains information about each book, including its unique book_id, title, and the author_id of the author who wrote it. The Reviews table contains information about each review, including its unique review_id, the book_id of the reviewed book, and the rating given by the reviewer.

Your task is to write a SQL query that retrieves a list of all authors along with their books and ratings. This list should include authors who have not written any books as well as books that have not received any reviews.*/

select
a.author_id,
a.author_name,
b.book_id,
b.title,
r.rating
from authors a
left join books b on a.author_id = b.author_id
left join reviews r on b.book_id = r.book_id;
