/*
2. Analysis of Strategy and Scoring

Question: Which strategies of the coach (e.g., offensive or defensive approach) are associated 
with a greater number of goals on offense?

Description: by combining team strategy data with match results, you can test which strategy is more effective
for scoring.
*/




/*
In our first attempt, we will separate the home and away games and draw separate conclusions for the 
performance at home and away.
*/


-- Team Strategies: BuildUpSpeed and BuildUpDribble.


/*
Table 1 provides for each match_api_id, the home_team_api_id and away_team_api_id, along 
with the home_team_goals and away_team_goals. Additionally, it includes the strategies used by 
both the home and away teams in BuildUpSpeed and BuildUpDribble.
*/
WITH table1 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.buildUpPlaySpeedClass AS home_BuildUpSpeed,
        ta_away.buildUpPlaySpeedClass AS away_buildupspeed,
        ta_home.buildUpPlayDribblingClass AS home_buildupDribble,
        ta_away.buildUpPlayDribblingClass AS away_buildupDribble
    FROM match m
    INNER JOIN team_attributes ta_home
    ON  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
    INNER JOIN team_attributes ta_away
    ON m.away_team_api_id = ta_away.team_api_id
    -- We use the strategy that is closest to and obviously before (in terms of calendar) each game, provided it exists.
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
/*
Table 2, for each possible combination of BuildUpSpeed and BuildUpDribble strategies for both 
home and away teams, gives us the total number of games, the Average amount of home and away goals.
*/
table2 AS (
        SELECT
            COUNT(*) AS total_games,
            ROUND(AVG(home_team_goal),2) AS avg_home_goals,
            ROUND(AVG(away_team_goal),2) AS avg_away_goals,
            home_BuildUpSpeed,
            away_buildupspeed,
            home_buildupDribble,
            away_buildupDribble
        FROM table1
        GROUP BY  home_BuildUpSpeed,
            away_buildupspeed,
            home_buildupDribble,
            away_buildupDribble
        -- We want more than 9 games in order to draw reliable conclusions.
        HAVING COUNT(*) > 9
)

SELECT *
FROM table2;

/*
Home (Balanced Build Up Speed) And Home (Normal Build Up Dribble) Vs Away (Fast Build Up Speed) And Away (Normal Build Up Dribble)

These strategies lead to the higher home scoring average (2.4 goals per game), than any other combination.


Home (Fast Build Up Speed) And Home (Normal Build Up Dribble) Vs Away (Balanced Build Up Speed) And Away (Normal Build Up Speed)

These strategies lead to the higher away scoring average (1.7 goal per game), than any other combination.
*/




/*
In our second attempt, we will not make a distinction between home and away games. Also, here we can choose any combination of 
strategies we prefer.

We chose BuildUpSpeed and BuildUpDribble.
*/



/*
Table10 provides for each match_api_id, the home_team_api_id, along with the home_team_goals. Additionally, it includes 
the strategies used by the home team in BuildUpSpeed and BuildUpDribble.
*/
WITH table10 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.home_team_goal AS goals,
        ta_home.buildUpPlaySpeedClass AS BuildUpSpeed,
        ta_home.buildUpPlayDribblingClass AS buildupDribble
    FROM match m
    INNER JOIN team_attributes ta_home
    on  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
/*
Table11 provides for each match_api_id, the away_team_api_id, along with the away_team_goals. Additionally, it includes 
the strategies used by the away team in BuildUpSpeed and BuildUpDribble.
*/
table11 AS (
    SELECT
        m.match_api_id,
        m.away_team_api_id,
        m.away_team_goal AS goals,
        ta_away.buildUpPlaySpeedClass AS BuildUpSpeed,
        ta_away.buildUpPlayDribblingClass AS buildupDribble
    FROM match m
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
/*
Table12 combines the data from both table10 and table11, in a single dataset.
*/
table12 AS (
    -- Making Home and Away Goals, in one same column so we can use AVG Function.
    SELECT
        *
    FROM table10
    UNION ALL
    SELECT
        *
    FROM table11
)
/*
Finally, we perform a GROUP BY on our data based on the strategies (BuildUpSpeed and BuildUpDribble) 
and use the AVG function to calculate the average number of goals for each different strategy. 
Additionally, with the help of the COUNT(*) function, we count the total number of games.
*/
SELECT
    COUNT(*) AS total_games,
    ROUND(AVG(goals),2) AS avg_goals,
    BuildUpSpeed,
    buildupDribble
FROM table12
GROUP BY  BuildUpSpeed,
    buildupDribble
ORDER BY avg_goals DESC;

/*
A balanced build-up speed combined with a normal build-up dribble leads to the highest 
average goals (1.48 goals per game).
*/



/*
We are using the same method, but this time we are selecting different team strategies.

Team Strategies: ChanceCreationShoot and DefensivePressure.
*/

WITH table20 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.home_team_goal AS goals,
        ta_home.chanceCreationShootingClass AS CreationShoot,
        ta_home.defencepressureclass AS DefensivePressure
    FROM match m
    INNER JOIN team_attributes ta_home
    on  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
table21 AS (
    SELECT
        m.match_api_id,
        m.away_team_api_id,
        m.away_team_goal AS goals,
        ta_away.chanceCreationShootingClass AS CreationShoot,
        ta_away.defencepressureclass AS DefensivePressure
    FROM match m
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
table22 AS (
    -- Making Home and Away Goals, in one same column so we can use AVG Function.
    SELECT
        *
    FROM table20
    UNION ALL
    SELECT
        *
    FROM table21
)

SELECT
    COUNT(*) AS total_games,
    ROUND(AVG(goals),2) AS avg_goals,
    CreationShoot,
    DefensivePressure
FROM table22
GROUP BY  CreationShoot,
    DefensivePressure
ORDER BY avg_goals DESC;

/*
The combination of normal creation shooting and high defensive pressure leads to the highest average 
goals (1.46 goals per game).
*/



-- Let's use now only one Team Strategy, Defensive Pressure.


WITH table30 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.home_team_goal AS goals,
        ta_home.defencepressureclass AS DefensivePressure
    FROM match m
    INNER JOIN team_attributes ta_home
    on  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
table31 AS (
    SELECT
        m.match_api_id,
        m.away_team_api_id,
        m.away_team_goal AS goals,
        ta_away.defencepressureclass AS DefensivePressure
    FROM match m
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), 
table32 AS (
    -- Making Home and Away Goals, in one same column so we can use AVG Function.
    SELECT
        *
    FROM table30
    UNION ALL
    SELECT
        *
    FROM table31
)

SELECT
    COUNT(*) AS total_games,
    ROUND(AVG(goals),2) AS avg_goals,
    DefensivePressure
FROM table32
GROUP BY DefensivePressure
ORDER BY avg_goals DESC;


-- High defensive pressure leads to the highest average goals (1.46 goals per game).



-- We can continue in the same way to draw meaningful conclusions for any combinations we want (one way, two way etc).
