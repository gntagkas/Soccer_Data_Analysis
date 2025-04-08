/*
1. Team Strategy Analysis and Opponent Ranking

Question: Which team strategies (e.g., buildUpPlayPassing, chanceCreationShooting) lead to better performance against teams with
different strategies?

Description: By combining team strategy data with match results, you can analyze which strategies are most effective
when a team faces specific opponent strategies.
*/


-- Team Strategies: BuildUpSpeed and ChanceCreationShoot


/*
Table 1 provides, for each match_api_id, the home_team_api_id and away_team_api_id, along 
with the home_team_goals and away_team_goals. Additionally, it includes the strategies used by 
both the home and away teams in BuildUpSpeed and ChanceCreationShoot.
*/


WITH table1 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.buildUpPlaySpeedClass AS home_buildUpPlaySpeed,
        ta_home.chanceCreationShootingClass AS home_chancecreationshoot,
        ta_away.buildUpPlaySpeedClass AS away_buildUpPlaySpeed,
        ta_away.chanceCreationShootingClass AS away_chanceCreationShoot
    FROM match m
    INNER JOIN team_attributes ta_home
    on m.home_team_api_id = ta_home.team_api_id 
    -- We use the strategy that is closest to and obviously before (in terms of calendar) each game, provided it exists.
    AND ta_home.date = (
        SELECT max(ta2.date)
        FROM team_attributes ta2
        WHERE ta2.team_api_id = m.home_team_api_id
        AND ta2.date <= m.date
)
    INNER JOIN team_attributes ta_away
    on m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
            SELECT MAX(ta2.date)
            FROM team_attributes ta2
            WHERE ta2.team_api_id = m.away_team_api_id
            AND ta2.date <= m.date
    )
/*
Table 2, for each possible combination of BuildUpSpeed and ChanceCreationShoot strategies for both 
home and away teams, gives us the total number of games, home wins, away wins, draws, and finally, 
the winning percentages excluding and including draws.
*/
), table2 AS (
    SELECT
        table1.home_buildUpPlaySpeed,
        table1.away_buildUpPlaySpeed,
        table1.home_chancecreationshoot,
        table1.away_chanceCreationShoot,
        COUNT(*) AS total_matches,
        SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS home_wins,
        SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END) AS away_wins,
        SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draw,
        ROUND (SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS home_win_percentage,
        ROUND (SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) AS away_win_percentage
    FROM table1
    GROUP BY table1.home_buildUpPlaySpeed,
            table1.home_chancecreationshoot,
            table1.away_buildUpPlaySpeed,
            table1.away_chanceCreationShoot
    -- We want more than 10 games in order to draw reliable conclusions.
    HAVING COUNT(*) > 10
)

SELECT
*
FROM table2

/*
Home (Fast Build Up) + Home (Normal Chance Creation) vs Away (Slow Build Bup) + Away (Normal Chance Creation).

These combination of strategies lead to a higher win percentage for the home team (63.64%), than any other combination.
*/




-- Team Strategies: BuildUpPlaySpeed and DefencePressure


/*
We are using the same method, but this time, we are selecting different team strategies.
*/

WITH table20 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.BuildUpPlaySpeedClass AS home_BuildUpSpeed,
        ta_away.BuildUpPlaySpeedClass AS away_BuildUpSpeed,
        ta_home.defencepressureclass AS home_DefensivePressure,
        ta_away.defencepressureclass AS away_DefensivePressure
    FROM match m
    INNER JOIN team_attributes ta_home
    ON  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT 
            MAX(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
    INNER JOIN team_attributes ta_away
    on m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            MAX(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), table21 AS (
    SELECT
        table20.home_BuildUpSpeed,
        table20.away_BuildUpSpeed,
        table20.home_DefensivePressure,
        table20.away_DefensivePressure,
        COUNT(*) AS Total_Matches,
        SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS home_wins,
        SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) AS away_wins,
        SUM (CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draw,
        ROUND (SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Home_Win_Percentage,
        ROUND (SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Away_Win_Percentage
    FROM table20
    GROUP BY table20.home_BuildUpSpeed,
        table20.away_BuildUpSpeed,
        table20.home_DefensivePressure,
        table20.away_DefensivePressure
        -- We want more than 10 games in order to draw reliable conclusions.
    HAVING COUNT(*) > 10
)

SELECT *
FROM table21

/*
Home (Balanced Build Up) And Home (Medium Defensive Pressure) vs Away (Slow Build Up) And Away (Medium Defensive Pressure).

These combination of strategies lead to a higher win percentage for the home team (66.67%), than any other combination.
*/




-- Team Strategies: ChanceCreationShoot and DefencePressure


/*
We are using the same method, but this time, we are selecting different team strategies.
*/


WITH table30 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.defencepressureclass AS home_Defensivepressure,
        ta_away.defencepressureclass AS away_DefensivePressure,
        ta_home.chanceCreationShootingClass AS home_chancecreationshoot,
        ta_away.chanceCreationShootingClass AS away_chanceCreationShoot
    FROM match m
    INNER JOIN team_attributes ta_home
    on  m.home_team_api_id = ta_home.team_api_id
    AND ta_home.date = (
        SELECT
            MAX(ta2.date)
        FROM team_attributes ta2
        WHERE m.home_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            MAX(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), table31 AS (
    SELECT
        table30.home_DefensivePressure,
        table30.away_DefensivePressure,
        table30.home_chancecreationshoot,
        table30.away_chanceCreationShoot,
        COUNT(*) AS total_matches,
        SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS home_wins,
        SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) AS away_wins,
        SUM (CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draw,
        ROUND (SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Home_Win_Percentage,
        ROUND (SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Away_Win_Percentage
    FROM table30
    GROUP BY   table30.home_DefensivePressure,
        table30.away_DefensivePressure,
        table30.home_chancecreationshoot,
        table30.away_chanceCreationShoot
    -- We want more than 10 games in order to draw reliable conclusions.
    HAVING COUNT(*) > 10
)

SELECT *
FROM table31


/*
Home (Medium Defensive Pressure) And Home (Normal Chance Creation) VS Away (Deep Defensive Pressure) And Away (Lots of Chance Creation).

These combination of strategies lead to a higher win percentage for the home team (69.23%), than any other combination.
*/


-- We can continue in the same way to combine each team's strategies and draw meaningful conclusions.



-- Let's combine now only one team strategy, Defensive pressure.

WITH table40 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.defencepressureclass AS home_DefPressure,
        ta_away.defencepressureclass AS away_DefPressure
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
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), table41 AS (
    SELECT
        table40.home_DefPressure,
        table40.away_DefPressure,
        COUNT(*) AS total_matches,
        SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS home_wins,
        SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END) AS away_wins,
        SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draws,
        ROUND (SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Home_Win_Percentage,
        ROUND (SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Away_Win_Percentage
    FROM table40
    GROUP BY  table40.home_DefPressure, table40.away_DefPressure
    -- We want more than 10 games in order to draw reliable conclusions.
    HAVING COUNT(*) > 10
)

SELECT *
FROM table41

/*
Home (Medium Def Pressure) vs Away (Deep Defensive Pressure) .

These strategies lead to a higher win percentage for the home team (67.24%), than any other combination.
*/




-- Let's continue with, buildUpPlaySpeed


WITH table40 AS (
    SELECT
        m.match_api_id,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        ta_home.buildUpPlaySpeedClass AS home_BuildUpSpeed,
        ta_away.buildUpPlaySpeedClass AS away_BuildUpSpeed
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
    INNER JOIN team_attributes ta_away
    on  m.away_team_api_id = ta_away.team_api_id
    AND ta_away.date = (
        SELECT
            max(ta2.date)
        FROM team_attributes ta2
        WHERE m.away_team_api_id = ta2.team_api_id
        AND ta2.date <= m.date
    )
), table41 AS (
    SELECT
        table40.home_BuildUpSpeed,
        table40.away_BuildUpSpeed,
        COUNT(*) AS total_matches,
        SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS home_wins,
        SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END) AS away_wins,
        SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draws,
        ROUND (SUM (CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Home_Win_Percentage,
        ROUND (SUM (CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS Away_Win_Percentage
    FROM table40
    GROUP BY     table40.home_BuildUpSpeed,
        table40.away_BuildUpSpeed
    -- We want more than 10 games in order to draw reliable conclusions.
    HAVING COUNT(*) > 10
)

SELECT *
FROM table41

/*
Home (Balanced Build Up) Vs Away (Slow Build Up).

These strategies lead to a higher win percentage for the home team (63.64%), than any other combination.
*/



-- We can continue in the same way to draw meaningful conclusions for any combinations we want (one way, two way etc).
