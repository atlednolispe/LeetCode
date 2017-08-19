# Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.
#
# +----+-------+
# | Id | Score |
# +----+-------+
# | 1  | 3.50  |
# | 2  | 3.65  |
# | 3  | 4.00  |
# | 4  | 3.85  |
# | 5  | 4.00  |
# | 6  | 3.65  |
# +----+-------+
# For example, given the above Scores table, your query should generate the following report (order by highest score):
#
# +-------+------+
# | Score | Rank |
# +-------+------+
# | 4.00  | 1    |
# | 4.00  | 1    |
# | 3.85  | 2    |
# | 3.65  | 3    |
# | 3.65  | 3    |
# | 3.50  | 4    |
# +-------+------+

Create table If Not Exists Scores (Id int, Score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (Id, Score) values ('1', '3.5');
insert into Scores (Id, Score) values ('2', '3.65');
insert into Scores (Id, Score) values ('3', '4.0');
insert into Scores (Id, Score) values ('4', '3.85');
insert into Scores (Id, Score) values ('5', '4.0');
insert into Scores (Id, Score) values ('6', '3.65');


# answer
# STEP1: order distinct score
SELECT Score
FROM Scores
GROUP BY Score
ORDER BY Score desc;

# STEP2: get Rank
SELECT s1.Score AS Score, COUNT(1) AS Rank
FROM
  (
  SELECT Score
  FROM Scores
  GROUP BY Score
  ORDER BY Score desc) AS s1 LEFT JOIN (
                                          SELECT Score
                                          FROM Scores
                                          GROUP BY Score
                                          ORDER BY Score desc
                                         ) AS s2
  ON s1.Score <= s2.Score
GROUP BY Score
ORDER BY Rank;

# STRP3: answer
SELECT S.Score AS Score, r.Rank AS Rank
FROM Scores AS s
LEFT JOIN (
            SELECT s1.Score AS Score, COUNT(1) AS Rank
            FROM
              (
              SELECT Score
              FROM Scores
              GROUP BY Score
              ORDER BY Score desc) AS s1 LEFT JOIN (
                                                  SELECT Score
                                                  FROM Scores
                                                  GROUP BY Score
                                                  ORDER BY Score desc
                                                  ) AS s2
              ON s1.Score <= s2.Score
            GROUP BY Score
            ORDER BY Rank
    ) AS r
  ON s.Score = r.Score
ORDER BY Rank;