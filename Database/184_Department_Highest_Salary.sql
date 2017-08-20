# The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
#
# +----+-------+--------+--------------+
# | Id | Name  | Salary | DepartmentId |
# +----+-------+--------+--------------+
# | 1  | Joe   | 70000  | 1            |
# | 2  | Henry | 80000  | 2            |
# | 3  | Sam   | 60000  | 2            |
# | 4  | Max   | 90000  | 1            |
# +----+-------+--------+--------------+
# The Department table holds all departments of the company.
#
# +----+----------+
# | Id | Name     |
# +----+----------+
# | 1  | IT       |
# | 2  | Sales    |
# +----+----------+
# Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.
#
# +------------+----------+--------+
# | Department | Employee | Salary |
# +------------+----------+--------+
# | IT         | Max      | 90000  |
# | Sales      | Henry    | 80000  |
# +------------+----------+--------+

Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, DepartmentId int);
Create table If Not Exists Department (Id int, Name varchar(255));
Truncate table Employee;
insert into Employee (Id, Name, Salary, DepartmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('4', 'Max', '90000', '1');
Truncate table Department;
insert into Department (Id, Name) values ('1', 'IT');
insert into Department (Id, Name) values ('2', 'Sales');


# answer
# STEP1: get the max salary of each department
SELECT DepartmentId, MAX(Salary)
FROM Employee
GROUP BY DepartmentId;

# STEP2: filter the employee doesn't belongs to any department
SELECT d.Name AS Department, e.Name AS Employee, e.Salary AS Salary
FROM Employee AS e
LEFT JOIN Department AS d
  ON e.DepartmentId = d.Id
LEFT JOIN ( SELECT DepartmentId AS id, MAX(Salary) AS maxs
            FROM Employee
            GROUP BY DepartmentId) AS m
  ON e.DepartmentId = m.id and e.Salary = m.maxs
WHERE d.Name IS NOT NULL AND m.maxs IS NOT NULL;