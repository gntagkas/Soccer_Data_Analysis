/*
2. Analysis of Strategy and Scoring

Question: Which strategies of the coach (e.g., offensive or defensive approach) are associated 
with a greater number of goals on offense?

Description: by combining team strategy data with match results, you can test which strategy is more effective
for scoring.
*/


-- Firstly we seperate home with away games.

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
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), table2 AS (
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
        -- Theloume perissotera apo 9 paixnidia, wste na vgaloume asfali sumperasmata.
        HAVING COUNT(*) > 9
)

SELECT *
FROM table2;

/*
Home (Balanced Build Up Speed) And Home (Normal Build Up Dribble) Vs Away (Fast Build Up Speed) And Away (Normal Build Up Dribble)

These strategies lead to the higher home scoring average, than any other combination


Home (Fast Build Up Speed) And Home (Normal Build Up Dribble) Vs Away (Balanced Build Up Speed) And Away (Normal Build Up Speed)

These strategies lead to the higher away scoring average, than any other combination
*/



-- Code if we don't separate home with away matches.
-- We can use any combination we want, this time we chose BuildUpSpeed and BuildUpDribble.



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
), table11 AS (
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
), table12 AS (
    -- Making Home and Away Goals, in one same column so we can use AVG Function.
    SELECT
        *
    FROM table10
    UNION ALL
    SELECT
        *
    FROM table11
)

SELECT
    COUNT(*) AS total_games,
    ROUND(AVG(goals),2) AS avg_goals,
    BuildUpSpeed,
    buildupDribble
FROM table12
GROUP BY  BuildUpSpeed,
    buildupDribble
ORDER BY avg_goals DESC

/*
A balanced build-up speed combined with a normal build-up dribble leads to the highest 
average goals (1.48).
*/


-- We can use any combination we want, this time we chose ChanceCreationShoot and DefensivePressure.


WITH table10 AS (
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
), table11 AS (
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
), table12 AS (
    -- Making Home and Away Goals, in one same column so we can use AVG Function.
    SELECT
        *
    FROM table10
    UNION ALL
    SELECT
        *
    FROM table11
)

SELECT
    COUNT(*) AS total_games,
    ROUND(AVG(goals),2) AS avg_goals,
    CreationShoot,
    DefensivePressure
FROM table12
GROUP BY  CreationShoot,
    DefensivePressure
ORDER BY avg_goals DESC

/*
The combination of normal creation shooting and high defensive pressure leads to the highest average goals (1.46).
*/