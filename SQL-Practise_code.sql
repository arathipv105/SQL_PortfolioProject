
# Basics- 
Select * 
from employee_demographics;

Select * 
from employee_salary; 

Select Distinct gender
from employee_demographics;


#Using Where Clause - 
Select * from employee_demographics
where first_name ='Leslie';


#Using Like clause
-- % and _
Select *
From employee_demographics
where first_name like 'A__%' and Year(birth_date)=1989;


#using Where Clause and INNER/OUTER/SELF-
-- InnerJoin / Join
Select e.First_name, e.Last_name, e.gender, es.salary 
from employee_demographics e
Join employee_salary es on es.employee_id = e.employee_id
where salary >=50000 ;

-- OuterJOIN-(Left & Right Join)
Select es.salary , e.First_name, e.Last_name, e.gender,e.employee_id
from employee_salary es
Right Join employee_demographics e on es.employee_id = e.employee_id
where salary >=50000 ;

Select es.salary , e.First_name, e.Last_name, e.gender,e.employee_id
from employee_salary es
left Join employee_demographics e on es.employee_id = e.employee_id
where salary >=50000 ;

-- SelfJoin
#Here joining same table- eg:choosing secret santa- the employee previous is the secret santa for next employee in the table--

Select emp1.employee_id as emp_santa,
emp1.first_name as FN_santa,
emp1.last_name as LN_Santa,
emp2.employee_id as emp_emp,
emp2.first_name as FN_emp,
emp2.last_name as LN_emp
 from employee_salary emp1
Join employee_salary emp2 on emp1.employee_id + 1 = emp2.employee_id;


-- Joining multiple tables together-
-- i Displaying employee id, firstname, lastname,occupation,salary and department name -
 
Select e.employee_id, 
e.first_name,
e.last_name,
es.occupation,
es.salary,
pd.department_name
from employee_demographics e
Inner Join employee_salary es on es.employee_id = e.employee_id
Inner Join parks_departments pd on pd.department_id = es.dept_id
;

-- ii Ordering the above table based on first_name and salary:
Select e.employee_id, 
e.first_name,
e.last_name,
es.occupation,
es.salary,
pd.department_name
from employee_demographics e
Inner Join employee_salary es on es.employee_id = e.employee_id
Inner Join parks_departments pd on pd.department_id = es.dept_id
order by e.first_name,es.salary
;


-- iii Using where clause( filtering based on salary)- 
Select e.employee_id, 
e.first_name,
e.last_name,
es.occupation,
es.salary,
pd.department_name
from employee_demographics e
Inner Join employee_salary es on es.employee_id = e.employee_id
Inner Join parks_departments pd on pd.department_id = es.dept_id
where es.salary >= 55000
order by e.first_name,es.salary
;

-- iv grouping employees based on department_name, using Having Clause
-- round average of salary to 2 decimal place-

Select count(*) as Num_of_Employee,
pd.department_name Department,
Round(avg(es.salary), 2) as Average_salary
from employee_demographics e
Inner Join employee_salary es on es.employee_id = e.employee_id
Inner Join parks_departments pd on pd.department_id = es.dept_id
group by pd.department_name
having avg(es.salary) >=20000
;


select * from parks_departments;
select * from employee_demographics;
select * from employee_salary;


-- Union

select first_name,last_name
from employee_demographics
union
select first_name,last_name
from employee_salary;

-- using union to combine multiple select statements--
select first_name,last_name, 'Old Men' as Label
from employee_demographics
where age> 40 and gender ='Male'
Union
select first_name,last_name, 'Old Women' as Label
from employee_demographics
where age> 40 and gender ='Female'
Union
select first_name,last_name, 'Higly paid employee' as Label
from employee_salary
where Salary > 70000
order by first_name,last_name;


-- String function -
-- i- length
select length('Management');

Select first_name, Length(first_name) as num_of_char
from employee_demographics
order by num_of_char;

-- the above code can also be written as- 
-- order by 2 --Gives same output
Select first_name, Length(first_name) as num_of_char
from employee_demographics
order by 2;

-- ii To convert it to uppercase/lowercase
Select Upper('management');
Select lower('MANAGEMENT');

Select first_name, upper(last_name) as LASTNAME
from employee_demographics
order by first_name desc;

-- iii Trim function--
select trim('     sky     ');
select Ltrim('     sky     ');
select Rtrim('     sky     ');

-- iv left/right/substring
-- month(birth_date), substring(birth_date,6,2) - both gives same output
Select first_name, 
left(first_name, 3), 
right(first_name, 3),
substring(first_name,3,2),
month(birth_date),
substring(birth_date,6,2)
from employee_demographics;


-- Replace 
-- replace a with z
select first_name, replace(first_name,'a', 'z')
from employee_demographics;

-- Locate
-- return the postion of the letter-
select locate('t', 'Arathi');

select first_name, locate('An', first_name)
from employee_demographics;

-- Concat
select first_name, last_name, concat(first_name,' ', last_name) as Full_name
from employee_demographics;


 -- case statements-
 
select first_name, last_name,age,
case
 when age <= 30 then 'Young'
 when age between 30 and 50 then 'Old'
 when age >50 then 'Senior citizen'
end As Age_Category
from employee_demographics
order by age;
-- OR --
select first_name, last_name,age,
case
 when age <= 30 then 'Young'
 when age between 30 and 50 then 'Old'
 Else 'Senior citizen'
end As Age_Category
from employee_demographics
order by age;

-- Pay Increase and Bonus --
-- <50000 = 5% bonus
-- >50000 = 7% bonus
-- If employee in finance = 10% bonus
select first_name, last_name,dept_id,salary,
case
 when salary < 50000 then (salary+ (salary*0.05))
 when salary >50000 then (salary+ (salary*0.07)) 
 when dept_id = 6 then (salary + (salary*0.1))
end As New_salary
from employee_salary
;

select * from employee_salary;


-- Subqueries
select * 
from employee_demographics
where employee_id in 
     (select employee_id
       from employee_salary
       where dept_id = 1);
 

select avg(avg_age), avg(Max_age) 
from 
(select gender, avg(age) avg_age, Max(age) as Max_age ,Min(age) as Min_age, count(age) as Count_age
       from employee_demographics
        group by gender) as Agg_table;