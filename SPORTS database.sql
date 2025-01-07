USE SPORTS;
--1
Create table team_coach(
team_coach_id int primary key,
coach_id int,
team_id int,
start_date  date,
end_date date,
foreign key (coach_id) references coach(coach_id),
foreign key (team_id) references team(team_id)
);
INSERT INTO Team_Coach (team_coach_id, team_id, coach_id, start_date, end_date) VALUES
  (1, 41, 11, '2016-07-01', '2024-06-30'),
  (2, 42, 12, '2021-06-01', '2024-06-29'),
  (3, 43, 13, '2015-10-08', '2024-06-30'),
  (4, 44, 14, '2019-03-11', '2024-06-29');
--EVEN RECORDS
select * from team_coach where team_coach_id % 2 = 0;
--ODD RECORDS
select * from team_coach where team_coach_id % 2 <> 0;

select * from team_coach order by RAND();
--2
Create table team(
team_id int primary key,
team_name varchar(40)
);
INSERT INTO Team (team_id, team_name) VALUES
  (41, 'Manchester City'),
  (42, 'Real Madrid'),
  (43, 'Liverpool'),
  (44, 'Real Madrid');
select * from team;

--3
Create table coach(
coach_id int primary key,
coach_name varchar(50),
country_id int,
foreign key (country_id) references country(country_id)
);
INSERT INTO Coach (coach_id, coach_name, country_id) VALUES
  (11, 'Pep Guardiola', 31),
  (12, 'Carlo Ancelotti', 32),
  (13, 'Jurgen Klopp', 33),
  (14, 'Zinedine Zidane', 34);
select * from coach;

--4
Create table country(
country_id int primary key,
country_name varchar(30)
);
INSERT INTO Country (country_id, country_name) VALUES
  (31, 'England'),
  (32, 'Spain'),
  (33, 'Germany'),
  (34, 'France');
select * from country;
select * from country where country_id % 2 <> 0;
--5
Create table player(
player_id int primary key,
player_name varchar(50),
country_id int,
team_id int,
player_dob date,
column_6 int NOT NULL,
foreign key (country_id) references country(country_id),
foreign key (team_id) references team(team_id)
);
INSERT INTO Player (player_id, player_name, country_id, team_id, player_dob, column_6) VALUES
  (51, 'Kevin De Bruyne', 31, 41, '1991-06-28', 111),
  (52, 'Karim Benzema', 32, 42, '1987-12-19', 112),
  (53, 'Mohamed Salah', 33, 43, '1992-06-15', 113),
  (54, 'Vinicius Junior', 34, 44, '2000-07-12', 114);
select * from player;

--6
create table goal(
goal_id int primary key,
match_id int,
player_id int,
goal_order int,
own_goal int,
column_6 int,
foreign key (match_id) references matches(match_id),
foreign key (player_id) references player(player_id)
);
INSERT INTO Goal (goal_id, match_id, player_id, goal_order, own_goal, column_6) VALUES
  (61, 71, 51, 1, 0, 1),
  (62, 72, 52, 2, 1, 2),
  (63, 73, 53, 1, 0, 3),
  (64, 74, 54, 2, 3, 4);
select * from goal;

--7
Create table matches(
match_id int primary key,
match_date date,
home_team_id int,
away_team int,
home_score int,
away_score int,
competition_id int,
foreign key (competition_id) references competition(competition_id)
);
INSERT INTO Matches (match_id, match_date, home_team_id, away_team,
home_score, away_score, competition_id) 
VALUES
  (71, '2023-05-01', 81, 91, 2, 1, 121),
  (72, '2024-04-02', 82, 92, 3, 0, 122),
  (73, '2023-04-02', 83, 93, 3, 0, 123),
  (74, '2024-05-02', 84, 94, 3, 0, 124);
select * from matches;
alter table competition alter column home_team_id to home_team;

--8
Create table competition(
competition_id int primary key,
competition_name int UNIQUE
);

alter table competition alter column competition_name varchar(50);

INSERT INTO Competition (competition_id, competition_name) VALUES
  (121, 'Premier League'),
  (122, 'La Liga'),
  (123, 'Italian Serie A'),
  (124, 'Spanish La Liga');
select * from competition;


--Queries
select distinct match_id from matches;
select * from country where country_name != 'England';
select * from team order by team_name desc;
select player_id, player_name, country_id, team_id, 
count(player_dob) as total_dob from player group by player_id, player_name, country_id, team_id;
select * from player where player_dob IN ('1987-12-19', '2000-07-12');
select * from player where player_dob BETWEEN '1991-08-28' AND '1992-06-15';
select * from team where team_name LIKE '%L';
select team_id, team_name from team where team_name = 
(SELECT TEAM_NAME FROM TEAM WHERE TEAM_NAME = 'Manchester City');

--1
select c.coach_id, c.coach_name, co.country_name from coach c join 
country co on c.country_id = co.country_id;
--2
select t.team_name, c.coach_name, tc.team_id, tc.start_date, tc.end_date
from coach c join team_coach tc on c.coach_id = tc.coach_id
inner join team t on t.team_id = tc.team_id;
--3
select t.team_name, tc.team_coach_id, tc.start_date from
team t full join team_coach tc on t.team_id = tc.team_id;
--4
 select p.player_name, p.player_dob, c.country_name from player p join
country c on p.country_id = c.country_id;
--5
select m.match_id, m.match_date, m.home_team_id, m.away_team, m.home_score, m.away_score,
c.competition_name from matches m inner join competition c 
on m.competition_id = c.competition_id;
--6
select p.player_name, g.goal_order, g.own_goal from player p 
join goal g on p.player_id = g.player_id;
--7
select * from goal;
create view v1_goal as select goal_id, goal_order, own_goal from goal;
select * from v1_goal;
delete from v1_goal where goal_id = 61;
insert into goal (goal_id, match_id, player_id, goal_order, own_goal, column_6) Values 
(61, 71, 51, 1, 0, 1); 
create index idx_goal on goal(goal_order);
drop index idx_goal on goal;
EXEC sp_helpindex 'Goal';
create index idx_country on country(country_name);
drop index idx_country on country;
select * from country;
select c.coach_id, c.coach_name, co.country_name from coach c join 
country co on c.country_id = co.country_id;
select * from team;

Create Table Friends(
friend_id int primary key,
friend_name varchar(50) NOT NULL,
friend_age int UNIQUE
);
Insert into Friends Values (1, 'Ali', 20);
Insert into Friends Values (2, 'Ahmad', 21);
Insert into Friends Values (3, 'Basit', 19);
Insert into Friends Values (4, 'Ali', 22);
Insert into Friends Values (5, 'Danish', 23);
Insert into Friends Values (6, 'A-Rehman', 25);
SELECT * FROM Friends;

SELECT friend_name, SUM(friend_age) AS total_age FROM Friends GROUP BY friend_name;
SELECT friend_name, MIN(friend_age) AS minimum_age FROM Friends GROUP BY friend_name;
SELECT friend_name, MAX(friend_age) AS maximum_age FROM Friends GROUP BY friend_name;
SELECT friend_name, AVG(friend_age) AS total_age FROM Friends GROUP BY friend_name;
SELECT friend_name, COUNT(friend_age) AS total_age FROM Friends GROUP BY friend_name;

SELECT * FROM FRIENDS WHERE FRIEND_NAME LIKE '[AB]%';
SELECT * FROM FRIENDS WHERE FRIEND_NAME LIKE '[A-D]%';
SELECT * FROM FRIENDS WHERE FRIEND_NAME LIKE 'D__%';

SELECT * FROM FRIENDS WHERE FRIEND_AGE IN (19, 20);

SELECT FRIEND_ID, FRIEND_NAME,
CASE 
   WHEN FRIEND_AGE = 20 THEN 'YOUNGSTER'
   WHEN FRIEND_AGE > 20 THEN 'OLDER'
   ELSE 'CHILD'
   END AS AGE_FACTOR
FROM FRIENDS;

select * from friends;
select * from friends where friend_id % 2 = 0 ;
select * from friends where friend_id % 2 <> 0 ;

create index idx_coach ON COACH(coach_name);

select * from friends;




--Stored Procedure
Create Procedure AllRecord
as 
Select * from friends
Go;
Exec AllRecord;

--SP with Single Parameter
Create Procedure AllRecord2 @friend_name varchar (25)
as 
Select * from friends where friend_name = @friend_name;
exec AllRecord2 @friend_name = 'Danish';

--SP with Multiple Parameters
Create Procedure AllRecord3 @friend_name varchar (50), @friend_age int
as
Select * from friends where friend_name = @friend_name AND friend_age = @friend_age;
exec AllRecord3 @friend_name = 'Ali' , @friend_age = 20;
select * from friends;

--Triggers
CREATE TABLE FriendUpdateLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    FriendID INT,
    OldName VARCHAR(100),
    NewName VARCHAR(100),
    OldAge INT,
    NewAge INT,
    UpdatedDate DATETIME DEFAULT GETDATE()
);
select * from Friendupdatelog;

create trigger trg_afterfriendupdate
on friends
after update
as 
begin
insert into Friendupdatelog (FriendID, OldName, NewName, OldAge, NewAge)
select d.friend_id, d.friend_name, i.friend_name, d.friend_age, i.friend_age
from deleted d
Join inserted i on d.friend_id = i.friend_id;
END;

select * from friends;
Update friends set friend_age = 36 where friend_name = 'Ali';
UPDATE dbo.Friends set Column1 = 'newvalue', column2 = 'newvalue' where youruniquecolumn = 36;
SELECT * FROM dbo.Friends WHERE friend_age = 36;

select * from friends;


-- Stored Procedure

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2),
    Quantity INT NOT NULL
);

-- Insert some sample data into the table
INSERT INTO Product (ProductID, ProductName, Price, Quantity)
VALUES 
(1, 'Laptop', 1200.00, 10),
(2, 'Smartphone', 800.00, 20),
(3, 'Tablet', 400.00, 15),
(4, 'Watch', 1000.00, 10),
(5, 'Perfume', 800.00, 25);

select * from product;

-- SP
CREATE PROCEDURE GetProductDetails
    @ProductID INT
AS
BEGIN
    SELECT ProductName, Price, Quantity
    FROM Product
    WHERE ProductID = @ProductID;
END;

--RUN COMMAND
EXEC GetProductDetails @ProductID = 4;

COMMIT;

select * from product;

create table customer(
customer_ID int primary key,
name varchar (50),
city char(25),
productID INT,
FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);

exec sp_spaceused;