/*
Question 1
You are given an employees table containing employee name, salary, and department ID.
Write a query to find the employees who earn less than the average salary of their own
department.
*/

select *
from employees e1
where e1.salary < (
	select avg(e2.salary)
    from employees e2
    where e1.department_id = e2.department_id
);

/*
Question 2
From the employees table, retrieve the names of employees whose salary is equal to the
minimum salary in their department.
*/

select *
from employees e1
where e1.salary = (
	select min(e2.salary)
    from employees e2
    where e1.department_id = e2.department_id
);


/*
Question 3
Given an employee table, fetch employee details of those who earn the third highest salary
in each department.
If multiple employees share the same salary, include all.
*/

-- Approach 1 (Using Subqueries)
select *
from employees e1
where 2 = (
	select count(distinct e2.salary)
    from employees e1
    where e1.department_id = e2.department_id
    and e2.salary > e1.salary
);


-- Approach 2 (Using Window Functions)
select *
from
(
	select employees_name,
    dense_rank() over(partition by department order by salary desc) as salary_rank
    from employees
) query2
where salary_rank = 3;


/*
Question 4
Write a query to find employees who earn the highest salary in their department but are
not the highest-paid employee in the company.
*/

-- Approach 1 (Using Subqueries)
select *
from employees e1
where e1.salary = (
		select max(e2.salary)
        from employees e2
        where e1.department_id = e2.department_id
)
and e1.salary > (
	select max(salary)
    from employees
);

-- Approach 2 (Using Window Functions)

select *
from (
	select salary,
    max(salary) over(partition by department_id) as department_max,
    max(salary) over() as company_max
    from employees
) ranked
where salary = department_max
and salary < company_max;


/*
Question 5
You are given students and exam_results tables.
Find the names of students who never appeared for any exam.
*/

-- Approach 1 (Using Subqueries)
select s.student_name
from students s
where not exists (
	select 1
    from exam_results e
    where e.student_id = s.student_id
);

-- Approach 2 (Using Joins)

select s.student_name
from students s
left join exam_results e on s.student_id = e.student_id
where e.student_id is null;

/*
Question 6
From customers and payments tables, find customers who have placed orders but
never made any payment.
*/

-- Approach 1 (Using Subqueries)
select c.customer_name
from customers c
where exists (
	select 1
    from orders o
    where o.customer_id = c.customer_id
)
and not exists (
	select 1
    from payments p
    where p.customer_id = c.customer_id
);

-- Approach 2 (Using Joins)
select c.customer_name
from customers c
join orders o on c.customer_id = o.customer_id
left join payments p on c.customer_id = p.customer_id
where p.payment_id is null;


/*
Question 7
Write a query to find the employee(s) who earn the lowest salary among employees
earning above the company’s average salary.
*/

select *
from employees
where salary = (
	select min(e1.salary)
	from employees e1
	where e1.salary > (
		select avg(e2.salary)
		from employees e2
	)
);


/*
Question 8
From an employee table, retrieve name and salary of employees who earn more than their
department’s average salary, and among them, earn the highest salary overall.
*/

-- Approach 1 (Using Subqueries)
select
e1.employee_name,
e1.salary
from employees e1
where salary > (
	select avg(e2.salary)
    from employees e2
    where e1.department_id = e2.department_id
)
and (
	select max(e3.salary)
    from employees e3
    where e3.salary > (
		select avg(e4.salary)
        from employees e4
        where e3.department_id = e4.department_id
	)
);


-- Approach 2 (Using Window Functions)
select
employee_name,
salary
from (
	select *,
    avg(salary) over(partition by department_id) as department_avg
    from employees
) dpt_avg
where salary > department_avg
and salary = (
		select max(e2.salary)
        from employees e2
        where e2.salary > (
			select avg(e3.salary)
            from employees e3
            where e2.department_id = e3.department_id
		)
);

-- Cleaner Window Function Approach
select
employee_name,
salary
from (
	select *,
		avg(salary) over(partition by department_id) as department_avg,
        max(
			case 
				when salary > avg(salary) over(partition by department_id)
            then salary
            end
		) over() as maximum_above_department_average
	from employees
) t
where salary = maximum_above_department_average;