/*
4. Player Age and Team Performance Analysis

Question: How does the age of the players affect the overall performance of the team each season? Can a correlation
be observed between the average age of the team and the number of wins?
*/



/*
Table1 provides, for each match and each home team, the average age of the starting 11 players.
*/
WITH table1 AS (
    SELECT m_home.match_api_id AS match_api_id_home,
        ROUND(AVG((m_home.date - p.birthday) / 365), 2) AS avg_age_home
    FROM player p
        INNER JOIN match m_home ON p.player_api_id IN (
            m_home.home_player_1,
            m_home.home_player_2,
            m_home.home_player_3,
            m_home.home_player_4,
            m_home.home_player_5,
            m_home.home_player_6,
            m_home.home_player_7,
            m_home.home_player_8,
            m_home.home_player_9,
            m_home.home_player_10,
            m_home.home_player_11
        )
    GROUP BY m_home.match_api_id
),
/*
Table2 provides, for each match and each away team, the average age of the starting 11 players.
*/
table2 AS (
    SELECT m_away.match_api_id AS match_api_id_away,
        ROUND(AVG((m_away.date - p.birthday) / 365), 2) AS avg_age_away
    FROM player p
        INNER JOIN match m_away ON p.player_api_id IN (
            m_away.away_player_1,
            m_away.away_player_2,
            m_away.away_player_3,
            m_away.away_player_4,
            m_away.away_player_5,
            m_away.away_player_6,
            m_away.away_player_7,
            m_away.away_player_8,
            m_away.away_player_9,
            m_away.away_player_10,
            m_away.away_player_11
        )
    GROUP BY m_away.match_api_id
),
/*
In table3, we merge Tables 1 and 2.
*/
table3 AS (
    SELECT table1.*,
        table2.*
    FROM table1
        INNER JOIN table2 ON table1.match_api_id_home = table2.match_api_id_away
),
/*
In Table4, we have, for each match, the average age of the home and away teams. Additionally, we 
include the IDs of the home and away teams, as well as the home and away team goals. Finally, we 
have the match date and the year it occurred.
*/
table4 AS (
    SELECT table3.match_api_id_home AS match_api_id,
        table3.avg_age_home,
        table3.avg_age_away,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        m.date,
        EXTRACT(
            YEAR
            FROM m.date
        ) AS year_of_match
    FROM table3
        INNER JOIN match m ON table3.match_api_id_home = m.match_api_id
),
/*
Table5 provides, for each team and each season (per year), the average age of the team.
*/
table5 AS (
    SELECT t.team_long_name,
        ROUND(
            AVG(
                COALESCE(avg_age_home, 0) + COALESCE(avg_age_away, 0)
            ) / 2,
            2
        ) AS avg_age_per_year,
        year_of_match
    FROM table4
        INNER JOIN team t ON table4.home_team_api_id = t.team_api_id
    GROUP BY t.team_long_name,
        year_of_match
),
/*
In the match_wins table, we calculate the wins for both the home and away teams.
*/
match_wins AS (
    -- Wins as home teams.
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        home_team_api_id AS team_id,
        COUNT(*) AS wins
    FROM match
    WHERE home_team_goal > away_team_goal
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        home_team_api_id
    UNION ALL
    -- Wins as away teams.
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        away_team_api_id AS team_id,
        COUNT(*) AS wins
    FROM match
    WHERE away_team_goal > home_team_goal
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        away_team_api_id
),
/*
In the team_wins table, we calculate the total wins of teams.
*/
team_wins AS (
    SELECT team_id,
        season,
        SUM(wins) AS total_wins
    FROM match_wins
    GROUP BY team_id,
        season
),
/*
In the match_draws table, we calculate draws for the home and away teams.
*/
match_draws AS (
    -- Draws as home team.
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        home_team_api_id AS team_id,
        COUNT(*) AS draws
    FROM match
    WHERE home_team_goal = away_team_goal
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        home_team_api_id
    UNION ALL
    -- Draws as away taem.
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        away_team_api_id AS team_id,
        COUNT(*) AS draws
    FROM match
    WHERE home_team_goal = away_team_goal
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        away_team_api_id
),
/*
In the team_draws table, we calculate the total draws of teams.
*/
team_draws AS (
    SELECT team_id,
        season,
        SUM(draws) AS total_draws
    FROM match_draws
    GROUP BY team_id,
        season
),
/* 
In the total_home_games table, we calculate the total home games played.
*/
total_home_games AS (
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        home_team_api_id AS team_id,
        COUNT(*) AS games
    FROM match
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        home_team_api_id
),
/* 
In the total_away_games table, we calculate the total away games played.
*/
total_away_games AS (
    SELECT EXTRACT(
            YEAR
            FROM date
        ) AS season,
        away_team_api_id AS team_id,
        COUNT(*) AS games
    FROM match
    GROUP BY EXTRACT(
            YEAR
            FROM date
        ),
        away_team_api_id
),
/*
In the total_games table, we calculate the total games played (both home and away).
*/
total_games AS (
    SELECT team_id,
        season,
        SUM(games) AS total_games
    FROM (
            SELECT *
            FROM total_home_games
            UNION ALL
            SELECT *
            FROM total_away_games
        ) AS all_games
    GROUP BY team_id,
        season
),
/*
In the team_stats table, we add team names, team IDs, seasons, total wins, total draws, and total games. 
We also calculate the win percentage using data from the four tables: team_wins, total_games, team_draws, and team.
*/
team_stats AS (
    SELECT t.team_long_name,
        tw.team_id,
        tw.season,
        tw.total_wins,
        COALESCE(td.total_draws, 0) AS total_draws,
        tg.total_games,
        ROUND(
            (tw.total_wins * 100.0) / NULLIF(tg.total_games, 0),
            2
        ) AS win_percentage
    FROM team_wins tw
        JOIN total_games tg ON tw.team_id = tg.team_id
        AND tw.season = tg.season
        LEFT JOIN team_draws td ON tw.team_id = td.team_id
        AND tw.season = td.season
        JOIN team t ON tw.team_id = t.team_api_id
)
/*
Finally, for each team, we have the average age for that season, as well as the total number of games played, 
the number of wins, the total draws, and the win percentage.
*/
SELECT 
    ts.team_long_name,
    ts.season,
    t5.avg_age_per_year,
    ts.total_games,
    ts.total_wins,
    ts.total_draws,
    ts.win_percentage
FROM team_stats ts
JOIN table5 t5 ON ts.team_long_name = t5.team_long_name 
               AND ts.season = t5.year_of_match
ORDER BY ts.team_long_name, ts.season;

/*
Here, we can draw conclusions for each team for every season. We can analyze the average age of 
each team per season, their total matches, draws, and win percentage.

This allows us to reach valuable insights.
*/