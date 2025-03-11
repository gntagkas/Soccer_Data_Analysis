/*
We run some basic queries to practice and answer specific questions.
*/


--Number of matches per season.


SELECT 
    season,
    COUNT(*) AS Matches_Per_Season
FROM match
GROUP BY season
ORDER BY season DESC;



--Matches that ended in a draw.


SELECT
    match_id,
    season,
    country_id,
    league_id
FROM match
WHERE home_team_goal = away_team_goal;



-- Top players based on their rating (with their names attached) from all seasons.


SELECT
    player.player_name,
    player_attributes.overall_rating
FROM player
LEFT JOIN player_attributes
ON  player.player_api_id = player_attributes.player_api_id
WHERE overall_rating IS NOT NULL
ORDER BY overall_rating DESC
LIMIT 50;



-- Top players based on their average rating (with their names attached) from all seasons.


SELECT
    player.player_name,
    ROUND(AVG(player_attributes.overall_rating),1) AS AVG_Rating
FROM player
LEFT JOIN player_attributes
ON  player.player_api_id = player_attributes.player_api_id
WHERE overall_rating IS NOT NULL
GROUP BY player.player_name
ORDER BY AVG_Rating DESC
LIMIT 50;



-- Most successful teams in their homes (best winning percentange).


WITH name1 AS (
SELECT
    home_team_api_id,
    COUNT(*) AS Home_Wins
FROM match
WHERE home_team_goal > away_team_goal
GROUP BY home_team_api_id
),
name2 AS (
SELECT
    home_team_api_id,
    COUNT(*) AS Home_Games
FROM match
GROUP BY home_team_api_id
),
name3 AS (
SELECT 
    name1.home_team_api_id,
    name2.home_games,
    name1.Home_Wins,
    ROUND (
    (CAST(name1.Home_Wins AS DECIMAL(10,0)) / NULLIF(name2.Home_Games, 0)) * 100, 
        1 -- NULLIF if home_games is zero returns NULL, CAST convers the value from the column in data type DECIMAL(10,2)
        -- DECIMAL(10,2) = up to 10 digits in total, 2 of them after subdivision (e.g 1050.22)
    ) AS Win_Percentage
FROM name1
INNER JOIN name2
on  name1.home_team_api_id = name2.home_team_api_id
)

SELECT
    team.team_long_name,
    name3.home_games,
    name3.Home_Wins,
    name3.Win_Percentage
FROM name3
LEFT JOIN team
ON  name3.home_team_api_id = team.team_api_id
ORDER BY Win_Percentage DESC;



-- Most wins for a team in their home.


SELECT
    team.team_long_name,
    COUNT(*) AS Home_Wins
FROM match
INNER JOIN team
on match.home_team_api_id = team.team_api_id
WHERE home_team_goal > away_team_goal
GROUP BY team.team_long_name
ORDER BY Home_Wins DESC
LIMIT 20;



-- Largest goal difference in a match.


SELECT
    match.match_api_id,
    team.team_long_name,
    ABS(home_team_goal-away_team_goal) AS goal_difference
FROM match
INNER JOIN team
on match.home_team_api_id = team.team_api_id
ORDER BY goal_difference DESC;



/*
Average scoring performance (both home and away) for each season. Find me the seasons with the biggest home/away
goal difference.
*/


SELECT
    season,
    ROUND(AVG(home_team_goal),2) AS avg_home_goals,
    ROUND(AVG(away_team_goal),2) AS avg_away_goals,
    ABS (ROUND(AVG(home_team_goal),2) - ROUND(AVG(away_team_goal),2)) AS goal_difference
FROM match
GROUP BY season
ORDER BY goal_difference DESC;



-- Top 100 players with biggest potential.


SELECT
    player.player_name,
    player_attributes.potential
FROM player
LEFT JOIN player_attributes
on player.player_id = player_attributes.player_attributes_id
WHERE player_attributes.potential is NOT NULL
ORDER BY player_attributes.potential DESC 
LIMIT 100;



-- Top 100 players U30 with biggest potential.


SELECT
    player.player_name,
    player_attributes.potential
FROM player
LEFT JOIN player_attributes
on player.player_id = player_attributes.player_attributes_id
WHERE player_attributes.potential is NOT NULL
and BIRTHDAY > '1995-02-28'
ORDER BY player_attributes.potential DESC 
LIMIT 100;



-- Top 10 players with the biggest improvement in rating between games.


SELECT
    player.player_name,
    MAX(overall_rating) - MIN(overall_rating) AS rating_improvement
FROM player_attributes
INNER JOIN player
ON  player_attributes.player_api_id = player.player_api_id
GROUP BY player_name
ORDER BY rating_improvement DESC
LIMIT 10;



-- Analysis of defensive pressure performance per team. What's the worst teams?


SELECT
    team.team_long_name,
    ROUND(AVG(team_attributes.defencePressure),1) AS avg_def_pressure
FROM team_attributes
RIGHT JOIN team
on team_attributes.team_attributes_id = team.team_id
WHERE team_attributes.defencePressure is NOT NULL
GROUP BY team.team_long_name
ORDER BY avg_def_pressure;



-- Has the average number of goals per season changed over the years?


SELECT
    EXTRACT(year from DATE) AS years,
    COUNT(*) AS games_per_year,
    ROUND(AVG(home_team_goal+away_team_goal),2) AS total_avg_goals,
    ROUND(AVG(home_team_goal),2) AS home_avg_goals,
    ROUND(AVG(away_team_goal),2) AS away_avg_goals
FROM match 
GROUP BY years
ORDER BY total_avg_goals DESC;
