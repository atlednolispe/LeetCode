# Write a SQL query to find all numbers that appear at least three times consecutively.
#
# +----+-----+
# | Id | Num |
# +----+-----+
# | 1  |  1  |
# | 2  |  1  |
# | 3  |  1  |
# | 4  |  2  |
# | 5  |  1  |
# | 6  |  2  |
# | 7  |  2  |
# +----+-----+
# For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.
#
# +-----------------+
# | ConsecutiveNums |
# +-----------------+
# | 1               |
# +-----------------+

Create table If Not Exists Logs (Id int, Num int);
Truncate table Logs;
insert into Logs (Id, Num) values ('1', '1');
insert into Logs (Id, Num) values ('2', '1');
insert into Logs (Id, Num) values ('3', '1');
insert into Logs (Id, Num) values ('4', '2');
insert into Logs (Id, Num) values ('5', '1');
insert into Logs (Id, Num) values ('6', '2');
insert into Logs (Id, Num) values ('7', '2');


# answer
# STEP1 : combine continuous 3 id to a row
SELECT f.Id, f.Num, s.Num, t.Num
FROM Logs AS f
LEFT JOIN Logs AS s
  ON f.Id = s.Id - 1
LEFT JOIN Logs AS t
  ON f.Id = t.Id - 2;

# STEP2 : answer
SELECT DISTINCT(f.Num) AS ConsecutiveNums
FROM Logs AS f
LEFT JOIN Logs AS s
  ON f.Id = s.Id - 1
LEFT JOIN Logs AS t
  ON f.Id = t.Id - 2
WHERE t.Num IS NOT NULL AND f.Num = s.Num AND f.Num = t.Num;