# Write a SQL query to get the nth highest salary from the Employee table.
#
# +----+--------+
# | Id | Salary |
# +----+--------+
# | 1  | 100    |
# | 2  | 200    |
# | 3  | 300    |
# +----+--------+
# For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.
#
# +------------------------+
# | getNthHighestSalary(2) |
# +------------------------+
# | 200                    |
# +------------------------+


# answer
# if there is no matching result, FUNCTION automaticly return <null>
CREATE FUNCTION getNthHighestSalary(N INT)
  RETURNS INT
  BEGIN
  RETURN (
  SELECT res.Salary AS Nth
    FROM
      (
        SELECT
          g1.Salary AS Salary,
          COUNT(1)  AS Rank
        FROM (
               SELECT Salary
               FROM Employee
               GROUP BY Salary
             ) AS g1
          LEFT JOIN (
                      SELECT Salary
                      FROM Employee
                      GROUP BY Salary
                    ) AS g2
            ON g1.Salary <= g2.Salary
        GROUP BY g1.Salary
      ) AS res
    WHERE res.Rank = N
  );
END;

SELECT getNthHighestSalary(6);

DROP FUNCTION getNthHighestSalary;