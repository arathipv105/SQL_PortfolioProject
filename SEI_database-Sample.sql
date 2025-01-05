DROP DATABASE IF exists `SEI_EMPLOYEE`;
CREATE DATABASE `SEI_EMPLOYEE`;
USE `SEI_EMPLOYEE`;

Create table Employees(
Employee_id INT Not Null ,
First_name varchar(60),
Last_name varchar(60),
Gender varchar(20),
Age Int,
Birth_date date,
primary key (Employee_id)
);

Create table Employee_Salary(
Employee_id Int not null,
First_name Varchar(60) not null,
Last_name varchar(60)not null,
Occupation varchar(60),
Salary int,
Dept_id int);

Insert into Employees(Employee_id,First_name, Last_name,Gender, Age,Birth_date)
Values 
('12230','John','Smith','M','49','1976-12-02'),
('12231','James','Ken','M','48','1977-11-08'),
('12233','Lorna','Birdwatch','F','26','1999-07-14'),
('12232','Michael','Taylor','M','60','1965-03-30'),
('12234','Christine','Mike','M','57','1967-02-02'),
('12235','Jessie','Locker','M','22','2003-06-19'),
('12236','Katherine','James','M','30','1995-06-22'),
('12237','Maria','Lorne','M','26','1999-10-05'),
('12238','varun','Neelaman','M','31','1993-07-18');

Insert into Employee_Salary(Employee_id,First_name, Last_name, Occupation, Salary, Dept_id)
Values 
(12230,'John','Smith', 'Deputy Director of SEI' ,30000, 1),
(12231,'James','Ken', 'Director of SEI' ,500300, 1),
(12233,'Lorna','Birdwatch', 'Nurse' ,120000, 3),
(12232,'Michael','Taylor', 'Senior Nurse' ,346300, 3),
(12234,'Christine','Mike', 'Team Lead of SEI' ,154000, 1),
(12235,'Jessie','Locker', 'Librarian-RPL' ,80000, 4),
(12236,'Katherine','James', 'Social worker' ,200000, 2),
(12237,'Maria','Lorne', 'Team Lead of SEI' ,154000, 1),
(12238,'varun','Neelaman', 'Business Analyst' ,250000, 5);

CREATE TABLE SEI_departments (
  dept_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (dept_id)
);

INSERT INTO SEI_departments (department_name)
VALUES
('SEI '),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

select * from Employees
where age between 20 and 40;

select * from Employees;
Select * from employee_salary
order by employee_id;

select e.employee_id, e.First_name, e.Last_name, es.Salary, es.Occupation, d.Dept_id
from Employees e 
join Employee_Salary es on es.Employee_id= e.Employee_id 
Join SEI_departments d on d.dept_id = es.dept_id
order by es.Salary,First_name ; 