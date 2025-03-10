/*
 Question: "How does the age of the players affect the overall performance of the team each season? Can a correlation
 be observed between the average age of the team and the number of wins?"
 */


WITH table1 AS (
    SELECT m_home.match_api_id AS match_api_id_home,
        ROUND(AVG((m_home.date - p.birthday) / 365.25), 2) AS avg_age_home
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
table2 AS (
    SELECT m_away.match_api_id AS match_api_id_away,
        ROUND(AVG((m_away.date - p.birthday) / 365.25), 2) AS avg_age_away
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
table3 AS (
    SELECT table1.*,
        table2.*
    FROM table1
        INNER JOIN table2 ON table1.match_api_id_home = table2.match_api_id_away
),
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
-- O table5 mas dinei gia kathe omada kai gia kathe season (ana year) to avg(age) ths 11adas ths.
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
-- Menei na prosthesoume tous sunolikous agwnes, tis wins, ta draws kai to win_perc gia kathe team ana season.
match_wins AS (
    -- nikes ws home omada.
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
    -- nikes ws away omada
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
-- upologismos sunolika tn nikwn tn omadwn
team_wins AS (
    SELECT team_id,
        season,
        SUM(wins) AS total_wins
    FROM match_wins
    GROUP BY team_id,
        season
),
match_draws AS (
    -- isopalies ws home team
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
    -- isopalies ws away team
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
-- sunolikes isopalies
team_draws AS (
    SELECT team_id,
        season,
        SUM(draws) AS total_draws
    FROM match_draws
    GROUP BY team_id,
        season
),
-- sunolika home paixnidia
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
-- sunolika away paixnidia
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
-- sunolika paixnidia
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