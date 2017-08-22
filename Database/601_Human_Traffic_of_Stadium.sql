# X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, date, people
#
# Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).
#
# For example, the table stadium:
# +------+------------+-----------+
# | id   | date       | people    |
# +------+------------+-----------+
# | 1    | 2017-01-01 | 10        |
# | 2    | 2017-01-02 | 109       |
# | 3    | 2017-01-03 | 150       |
# | 4    | 2017-01-04 | 99        |
# | 5    | 2017-01-05 | 145       |
# | 6    | 2017-01-06 | 1455      |
# | 7    | 2017-01-07 | 199       |
# | 8    | 2017-01-08 | 188       |
# +------+------------+-----------+
# For the sample data above, the output is:
#
# +------+------------+-----------+
# | id   | date       | people    |
# +------+------------+-----------+
# | 5    | 2017-01-05 | 145       |
# | 6    | 2017-01-06 | 1455      |
# | 7    | 2017-01-07 | 199       |
# | 8    | 2017-01-08 | 188       |
# +------+------------+-----------+

Create table If Not Exists stadium (id int, date DATE NULL, people int);
Truncate table stadium;
insert into stadium (id, date, people) values ('1', '2017-01-01', '10');
insert into stadium (id, date, people) values ('2', '2017-01-02', '109');
insert into stadium (id, date, people) values ('3', '2017-01-03', '150');
insert into stadium (id, date, people) values ('4', '2017-01-04', '99');
insert into stadium (id, date, people) values ('5', '2017-01-05', '145');
insert into stadium (id, date, people) values ('6', '2017-01-06', '1455');
insert into stadium (id, date, people) values ('7', '2017-01-07', '199');
insert into stadium (id, date, people) values ('8', '2017-01-08', '188');


# answer
# order by id is necessary or can't be accepted
SELECT * FROM
  (
    SELECT
      s1.id,
      s1.date,
      s1.people
    FROM stadium AS s1
      LEFT JOIN stadium AS s2
        ON s1.id + 1 = s2.id
      LEFT JOIN stadium AS s3
        ON s1.id + 2 = s3.id
    WHERE s1.people >= 100 AND s2.people >= 100 AND s3.people >= 100
    UNION
    SELECT
      s1.id,
      s1.date,
      s1.people
    FROM stadium AS s1
      LEFT JOIN stadium AS s2
        ON s1.id - 1 = s2.id
      LEFT JOIN stadium AS s3
        ON s1.id - 2 = s3.id
    WHERE s1.people >= 100 AND s2.people >= 100 AND s3.people >= 100
    UNION
    SELECT
      s1.id,
      s1.date,
      s1.people
    FROM stadium AS s1
      LEFT JOIN stadium AS s2
        ON s1.id - 1 = s2.id
      LEFT JOIN stadium AS s3
        ON s1.id + 1 = s3.id
    WHERE s1.people >= 100 AND s2.people >= 100 AND s3.people >= 100
  ) AS u
ORDER BY u.id;


