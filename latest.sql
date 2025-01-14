-- looking through both database to check out the structure

-- cards data contains id, user_id, created_by_name, updated_at, created_at, active, type, event_at, event_id
select * from events.cards;
-- id column is related to the created_by_name
-- each rows contains information about the metadata of each cards issued

select * from events.users;
-- users data contains type, event_at, event_id, id, name, address, job, score
-- each row contains information about the bank users. 


-- Check for missing values in Users table
SELECT COUNT(*) AS missing_count
FROM events.users
WHERE id IS NULL OR name IS NULL OR address IS NULL OR job IS NULL OR score IS NULL;

-- Check for missing values in Cards table
SELECT COUNT(*) AS missing_count
FROM events.cards
WHERE id IS NULL OR user_id IS NULL OR created_by_name IS NULL OR created_at IS NULL OR active IS NULL;


-- Check for duplicate users
SELECT id, COUNT(*) AS users_duplicate
FROM events.users
GROUP BY id
HAVING COUNT(*) > 1;

-- Check for duplicate cards
SELECT id, COUNT(*) AS cards_duplicates
FROM events.cards
GROUP BY id
HAVING COUNT(*) > 1;



-- check if the event_at, event_id from both table are similar, and join both table on the users.id and cards.user_id
select u.id, u.event_id u_event_id, c.event_id c_event_id
from events.users u 
join events.cards c 
on c.user_id = u.id;

-- so basically the cards and users data contain different event_id 


-- Check for users without corresponding cards
SELECT u.id AS user_id, c.user_id c_user_id
--select u.event_id u_event_id, c.event_id c_event_id
FROM events.users u
LEFT JOIN events.cards c ON u.id = c.user_id
WHERE c.user_id IS NULL;



--user scores distribution
SELECT COUNT(*) AS score_count, AVG(score) AS avg_score, MIN(score) AS min_score, MAX(score) AS max_score
FROM events.users
WHERE score IS NOT NULL;


-- Identify users with unusually high or low scores
select id, name, score
FROM events.users
WHERE score > 0.998 OR score < 0.0008;


--The top 5 users with the highest score
select "name", score
from events.users 
group by score, "name" 
order by score desc
limit 5;

-- The 5 users with the least score
select "name", score
from events.users 
group by score, "name" 
order by score
limit 5;


--The 5 active users with the highest score
select u."name", u.score, c.active 
from events.users u 
join events.cards c 
on c.user_id = u.id
group by u.score, u."name", c.active 
having c.active = true 
order by u.score desc
limit 5;


--The 5 inactive users with highes score

select u."name", u.score, c.active 
from events.users u 
join events.cards c 
on c.user_id = u.id
group by u.score, u."name", c.active 
having c.active = false 
order by u.score desc
limit 5;

-- the 5 active user with the least score 

select u."name", u.score, c.active 
from events.users u 
join events.cards c 
on c.user_id = u.id
group by u.score, u."name", c.active 
having c.active = true
order by u.score
limit 5;

--The 5 inactive users with the least score

select u."name", u.score, c.active 
from events.users u 
join events.cards c 
on c.user_id = u.id
group by u.score, u."name", c.active 
having c.active = false
order by u.score
limit 5;

-- active cards and their users
SELECT c.*, u.*
FROM cards c
JOIN users u ON c.user_id = u.id
WHERE c.active = true;


-- number of cards created by each staf members

SELECT created_by_name, COUNT(*) as card_count
FROM cards
GROUP BY created_by_name;

--average score of users associated with each cards
SELECT c.user_id, AVG(u.score) as avg_user_score
FROM cards c
JOIN users u ON c.user_id = u.id
GROUP BY c.user_id;

-- average score for active cards
SELECT AVG(u.score) as avg_user_score
FROM cards c
JOIN users u ON c.user_id = u.id
WHERE c.active = true;

--Latest Update Time for Each Card
SELECT id, MAX(updated_at) as latest_update
FROM cards
GROUP BY id;


--check user details for a specific event_id
SELECT u.*
FROM users u
JOIN cards c ON u.id = c.user_id
WHERE c.event_id = '00101c06-31ac-452a-b3ab-973bf1456869';

--average score for each profession

select job, avg(score) average_score
from users
group by 1
order by 2 desc;
