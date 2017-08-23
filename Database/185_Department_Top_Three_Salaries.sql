# The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.
#
# +----+-------+--------+--------------+
# | Id | Name  | Salary | DepartmentId |
# +----+-------+--------+--------------+
# | 1  | Joe   | 70000  | 1            |
# | 2  | Henry | 80000  | 2            |
# | 3  | Sam   | 60000  | 2            |
# | 4  | Max   | 90000  | 1            |
# | 5  | Janet | 69000  | 1            |
# | 6  | Randy | 85000  | 1            |
# +----+-------+--------+--------------+
# The Department table holds all departments of the company.
#
# +----+----------+
# | Id | Name     |
# +----+----------+
# | 1  | IT       |
# | 2  | Sales    |
# +----+----------+
# Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.
#
# +------------+----------+--------+
# | Department | Employee | Salary |
# +------------+----------+--------+
# | IT         | Max      | 90000  |
# | IT         | Randy    | 85000  |
# | IT         | Joe      | 70000  |
# | Sales      | Henry    | 80000  |
# | Sales      | Sam      | 60000  |
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
# STEP1: get all employees belong to any department
SELECT
 d1.Name AS dName,
 e1.Name,
 e1.Salary,
 d1.Id   AS dId,
 e1.Id
FROM Employee AS e1 LEFT JOIN Department AS d1
 ON e1.DepartmentId = d1.Id
WHERE d1.Id IS NOT NULL;

# STEP2: get different salary of all departments
SELECT ed.dId, Salary
FROM (
      SELECT
       d1.Name AS dName,
       e1.Name,
       e1.Salary,
       d1.Id   AS dId,
       e1.Id
      FROM Employee AS e1 LEFT JOIN Department AS d1
        ON e1.DepartmentId = d1.Id
      WHERE d1.Id IS NOT NULL
     ) AS ed
GROUP BY ed.dId, Salary;

# STEP3: left join salary by department id
SELECT ds1.dId, ds1.Salary AS s1, ds2.Salary AS s2
FROM (
      SELECT ed1.dId, Salary
      FROM (
            SELECT
             d1.Name AS dName,
             e1.Name,
             e1.Salary,
             d1.Id   AS dId,
             e1.Id
            FROM Employee AS e1 LEFT JOIN Department AS d1
              ON e1.DepartmentId = d1.Id
            WHERE d1.Id IS NOT NULL
           ) AS ed1
      GROUP BY ed1.dId, Salary
     ) AS ds1
LEFT JOIN (
           SELECT ed2.dId, Salary
           FROM (
                 SELECT
                   d2.Name AS dName,
                   e2.Name,
                   e2.Salary,
                   d2.Id   AS dId,
                   e2.Id
                 FROM Employee AS e2 LEFT JOIN Department AS d2
                   ON e2.DepartmentId = d2.Id
                 WHERE d2.Id IS NOT NULL
                ) AS ed2
           GROUP BY ed2.dId, Salary
           ) AS ds2
       ON ds1.dId = ds2.dId AND ds1.Salary <= ds2.Salary;

# STEP4: select top 3 salary of each department
SELECT ds1.dId, ds1.Salary AS s1, ds2.Salary AS s2
FROM (
      SELECT ed1.dId, Salary
      FROM (
            SELECT
             d1.Name AS dName,
             e1.Name,
             e1.Salary,
             d1.Id   AS dId,
             e1.Id
            FROM Employee AS e1 LEFT JOIN Department AS d1
              ON e1.DepartmentId = d1.Id
            WHERE d1.Id IS NOT NULL
           ) AS ed1
      GROUP BY ed1.dId, Salary
     ) AS ds1
LEFT JOIN (
           SELECT ed2.dId, Salary
           FROM (
                 SELECT
                   d2.Name AS dName,
                   e2.Name,
                   e2.Salary,
                   d2.Id   AS dId,
                   e2.Id
                 FROM Employee AS e2 LEFT JOIN Department AS d2
                   ON e2.DepartmentId = d2.Id
                 WHERE d2.Id IS NOT NULL
                ) AS ed2
           GROUP BY ed2.dId, Salary
           ) AS ds2
       ON ds1.dId = ds2.dId AND ds1.Salary <= ds2.Salary


SELECT dId, s1, COUNT(s2) AS Rank
FROM (
      SELECT ds1.dId, ds1.Salary AS s1, ds2.Salary AS s2
      FROM (
            SELECT ed1.dId, Salary
            FROM (
                  SELECT
                   d1.Name AS dName,
                   e1.Name,
                   e1.Salary,
                   d1.Id   AS dId,
                   e1.Id
                  FROM Employee AS e1 LEFT JOIN Department AS d1
                    ON e1.DepartmentId = d1.Id
                  WHERE d1.Id IS NOT NULL
                 ) AS ed1
            GROUP BY ed1.dId, Salary
           ) AS ds1
      LEFT JOIN (
                 SELECT ed2.dId, Salary
                 FROM (
                       SELECT
                         d2.Name AS dName,
                         e2.Name,
                         e2.Salary,
                         d2.Id   AS dId,
                         e2.Id
                       FROM Employee AS e2 LEFT JOIN Department AS d2
                         ON e2.DepartmentId = d2.Id
                       WHERE d2.Id IS NOT NULL
                      ) AS ed2
                 GROUP BY ed2.dId, Salary
                 ) AS ds2
             ON ds1.dId = ds2.dId AND ds1.Salary <= ds2.Salary
     ) AS sr
GROUP BY sr.dId, sr.s1
HAVING COUNT(s2) < 4;

# STEP4: get the employees who earn the top 3 salaries
# don't forget to order by department name and salary desc
SELECT ed3.dName AS Department, ed3.Name AS Employee, ed3.Salary AS Salary
FROM (
      SELECT
       d3.Name AS dName,
       e3.Name,
       e3.Salary,
       d3.Id   AS dId,
       e3.Id
      FROM Employee AS e3 LEFT JOIN Department AS d3
       ON e3.DepartmentId = d3.Id
      WHERE d3.Id IS NOT NULL
     ) AS ed3
RIGHT JOIN (
            SELECT dId, s1, COUNT(s2) AS Rank
            FROM (
                  SELECT ds1.dId, ds1.Salary AS s1, ds2.Salary AS s2
                  FROM (
                        SELECT ed1.dId, Salary
                        FROM (
                              SELECT
                               d1.Name AS dName,
                               e1.Name,
                               e1.Salary,
                               d1.Id   AS dId,
                               e1.Id
                              FROM Employee AS e1 LEFT JOIN Department AS d1
                                ON e1.DepartmentId = d1.Id
                              WHERE d1.Id IS NOT NULL
                             ) AS ed1
                        GROUP BY ed1.dId, Salary
                       ) AS ds1
                  LEFT JOIN (
                             SELECT ed2.dId, Salary
                             FROM (
                                   SELECT
                                     d2.Name AS dName,
                                     e2.Name,
                                     e2.Salary,
                                     d2.Id   AS dId,
                                     e2.Id
                                   FROM Employee AS e2 LEFT JOIN Department AS d2
                                     ON e2.DepartmentId = d2.Id
                                   WHERE d2.Id IS NOT NULL
                                  ) AS ed2
                             GROUP BY ed2.dId, Salary
                             ) AS ds2
                         ON ds1.dId = ds2.dId AND ds1.Salary <= ds2.Salary
                 ) AS sr
            GROUP BY sr.dId, sr.s1
            HAVING COUNT(s2) < 4
          ) AS Matched
ON ed3.dId = Matched.dId AND ed3.Salary = Matched.s1
WHERE ed3.Salary IS NOT NULL
ORDER BY Department, Salary DESC;


# wrong answer: top 3 employees of each department
SELECT ed3.dName AS Department, ed3.Name AS Employee, ed3.Salary AS Salary
FROM (
      SELECT d3.Name AS dName, e3.Name, e3.Salary, d3.Id AS dId, e3.Id
      FROM Employee AS e3 LEFT JOIN Department AS d3
      ON e3.DepartmentId = d3.Id
     ) AS ed3
WHERE ed3.Id IN (
                 SELECT Id
                 FROM (
                       SELECT
                         ed1.Id,
                         ed2.dId,
                         COUNT(ed2.dId) AS r
                       FROM (
                             SELECT
                               d1.Name AS dName,
                               e1.Name,
                               e1.Salary,
                               d1.Id   AS dId,
                               e1.Id
                             FROM Employee AS e1 LEFT JOIN Department AS d1
                               ON e1.DepartmentId = d1.Id
                            ) AS ed1
                       LEFT JOIN (
                                  SELECT
                                    d2.Name AS dName,
                                    e2.Name,
                                    e2.Salary,
                                    d2.Id   AS dId,
                                    e2.Id
                                  FROM Employee AS e2 LEFT JOIN Department AS d2
                                    ON e2.DepartmentId = d2.Id
                                  ) AS ed2
                              ON ed1.Salary < ed2.Salary AND ed1.dId = ed2.dId
                       WHERE ed1.dId IS NOT NULL
                       GROUP BY ed1.Id, ed2.dId
                       ) AS Rank
                 WHERE Rank.r < 3
                )