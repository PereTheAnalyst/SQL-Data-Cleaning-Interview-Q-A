-- I will be creating a step by step basic data cleaning in SQL and answer some questions
-- lets view our data
Use [sql first]
go
select*
from EmployeeDemographics

--- lets count our duplicates
select employeeid, firstname, count(*) as dup
from EmployeeDemographics
group by EmployeeID,FirstName
Having count(*) >1 and count(employeeid)>1 and  count(firstname) >1

-- let us now see the data without any duplicates
select distinct *
from EmployeeDemographics

-- lets see if we have any nulls 
select distinct *
from EmployeeDemographics
where EmployeeID is null Or age is null

-- Now we can either try to replace the null values or work without them 
Select Distinct(isnull(d.EmployeeID,'0')), FirstName,LastName,isnull(null,'30') as age
from EmployeeSalary as s
right join EmployeeDemographics as d
on d.EmployeeID=s.EmployeeID
where s.EmployeeID is null 

Select distinct(isnull(EmployeeID,'0')) as EmployeeID, FirstName,LastName,isnull(Age,'30') as age, ISNULL(Gender,'Genderless') as Gendet
from EmployeeDemographics

--so now we have distinct records now lets get rid of nulls
select distinct *
from EmployeeDemographics

-- Now we are going to create a temp table that replaces our null and duplicate values and creates a clean table 
Create Table #Clean_Table(
employeeid int,
firstname varchar(100),
lastname varchar(100),
Age int,
Gender varchar(100)
)
Select *
from #Clean_Table
--- Next we are going to insert a  query that cleans our data into the temp table 
Insert into #Clean_Table
Select distinct(isnull(EmployeeID,'0')) as EmployeeID, FirstName,LastName,isnull(Age,'30') as age, ISNULL(Gender,'Genderless') as Gendet
from EmployeeDemographics

select * 
from #Clean_Table

--- Now lets Practice joins
select *
from #Clean_Table as c
join EmployeeSalary as s
on c.employeeid=s.EmployeeID

--- NOW SQL INTERVIEW QUESTIONS 
--Max salary 
select d.firstName, s.salary, s.jobtitle
from dbo.employeeDemographics as d
Join EmployeeSalary as s
on s.EmployeeID = d.EmployeeID
Where s.Salary = (Select max(salary) from EmployeeSalary)

-- I want to find the max salary in each departmet 
select max(s.salary), s.jobtitle
from dbo.employeeDemographics as d
Join EmployeeSalary as s
on s.EmployeeID = d.EmployeeID
group by s.jobtitle
-- I want to find  mutiple or all details of the people who hold the max salary in each department 
select d.firstName, s.salary, s.jobtitle
from dbo.employeeDemographics as d
Join EmployeeSalary as s
on s.EmployeeID = d.EmployeeID
where Salary in (select max(salary) from EmployeeSalary group by JobTitle)


-- I want to find the 2nd highest salary 
select  Top 1 d.firstName, s.salary, s.jobtitle
from dbo.employeeDemographics as d
Join EmployeeSalary as s
on s.EmployeeID = d.EmployeeID
Where Salary NOT IN(Select max(Salary) from EmployeeSalary)


-- I want to find the number of  duplicates in the table
Select firstname,age, e.EmployeeID , Count(*) as NUM_Duplicates 
From EmployeeDemographics as e
Join EmployeeSalary as s
ON e.EmployeeID = s.EmployeeID
group by e.EmployeeID,FirstName, Age
Having Count(*) = 1 And count(firstname) =1 and Count(Age) =1

-- I want to find the average alary of all employees and compare to the employees current salaries
Select employeeID, Jobtitle, Salary, (Select avg(salary) as jeff from EmployeeSalary ) as Avg_salary
From employeesalary
Where Salary < 48555 

select SUBSTRING('Perebibowei', 1,10)

--- Here I am using a self Join to find every employees manager
use stakeholder
Go
select e.EMPLOYEE_ID ,e.FIRST_NAME as manager_name, m.FIRST_NAME  ,m.MANAGER_ID
from dbo.practice as e
Join practice as m
On m.MANAGER_ID = e.EMPLOYEE_ID  

-- Now I want to find all employees with the same salary
Select Distinct e.First_name, e.salary ,e.EMPLOYEE_ID
from practice as e , practice pl
Where e.SALARY = pl.SALARY And e.EMPLOYEE_ID != pl.EMPLOYEE_ID
order by SALARY desc

-- Now I want to print each row twice using union all
select e.JOB_ID, e.FIRST_NAME
from practice as e
where JOB_ID ='ST_CLERK'
Union all
select e1.JOB_ID, e1.FIRST_NAME
from practice as e1
where JOB_ID ='ST_CLERK'
--- Now I will you use Case and When to add numbers to employee id that meet and criteria 
select EMPLOYEE_ID,
	case when EMPLOYEE_ID Like '%1%' then EMPLOYEE_ID +10
	When EMPLOYEE_ID Like '%2%' then EMPLOYEE_ID +20
	Else EMPLOYEE_ID
End as num_add
from practice

-- PART 2 SQL INTERVIEW QUESTIONS 
Use [sql first]

Select JobTitle ,min(salary) as minsal
from EmployeeDemographics as d
join EmployeeSalary as s
on d.EmployeeID = s.EmployeeID
group by JobTitle
-- minminal salary by job department 

Select *
from EmployeeDemographics as d
join EmployeeSalary as s
on d.EmployeeID = s.EmployeeID
Where JobTitle <> 'Salesman'
-- finding salaries of people who are not salesmen 

-- find the 3rd highest salary
select top 1 salary, EmployeeID  from (
select DISTINCT  top 3 salary, EmployeeID from EmployeeSalary order by salary desc  ) as comp
order by salary 
--- print alternate id or get  evens or odds employeeids
select *
from EmployeeSalary
Where EmployeeID % 2=1
select *
from EmployeeSalary
Where EmployeeID % 2=0
-- Noww find to find the employee id of people who are missing a salary id number 
Select distinct(d.EmployeeID), FirstName,LastName,Age
from EmployeeSalary as s
right join EmployeeDemographics as d
on d.EmployeeID=s.EmployeeID
where s.EmployeeID is null 


--- primary keys can not have any duplicates and can not accept null values clustered 
--- Union Can be more than one unique key in table, can accept nulls non clustered index
-- index is a quick look up table for finding records users need to search Frequently 