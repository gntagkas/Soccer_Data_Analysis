/*
3. Creating Groups with Specific Statistics

Question: Which teams have players with high stats in specific areas, 
such as foul shooting, and how does this affect team performance?

Description: Create teams with high performance characteristics 
(e.g., more players with high scores in shot power or free kick accuracy) and analyze the effect of these 
players on team performance.
*/



/*
Table1 give us the players who have a free kick accuracy above 89.
*/
WITH table1 AS (
    SELECT player_api_id,
        free_kick_accuracy,
        date
    FROM player_attributes pa
    WHERE free_kick_accuracy > 89
),
/*
Table2 provides, for each match and each home team, the number of players with a free kick accuracy above 89 (home_player column).
*/
table2 AS (
    SELECT m_home.match_api_id AS match_api_id1,
        -- Count home team players with fka > 89.
        COUNT(*) AS home_player
    FROM table1 t1
        LEFT JOIN match m_home ON t1.player_api_id = m_home.home_player_1
        OR t1.player_api_id = m_home.home_player_2
        OR t1.player_api_id = m_home.home_player_3
        OR t1.player_api_id = m_home.home_player_4
        OR t1.player_api_id = m_home.home_player_5
        OR t1.player_api_id = m_home.home_player_6
        OR t1.player_api_id = m_home.home_player_7
        OR t1.player_api_id = m_home.home_player_8
        OR t1.player_api_id = m_home.home_player_9
        OR t1.player_api_id = m_home.home_player_10
        OR t1.player_api_id = m_home.home_player_11 
        -- We use the overall free kick accuracy, which is closer and before the match.
        AND m_home.date = (
            SELECT MAX(t1.date)
            FROM table1 t1
            WHERE t1.player_api_id = m_home.home_player_1
                OR t1.player_api_id = m_home.home_player_2
                OR t1.player_api_id = m_home.home_player_3
                OR t1.player_api_id = m_home.home_player_4
                OR t1.player_api_id = m_home.home_player_5
                OR t1.player_api_id = m_home.home_player_6
                OR t1.player_api_id = m_home.home_player_7
                OR t1.player_api_id = m_home.home_player_8
                OR t1.player_api_id = m_home.home_player_9
                OR t1.player_api_id = m_home.home_player_10
                OR t1.player_api_id = m_home.home_player_11
                AND t1.date <= m_home.date
        )
    GROUP BY m_home.match_api_id
),
/*
In Table3, we keep the columns from Table 2 and add the goals of the home team.
*/
table3 AS (
    SELECT table2.*,
        match.home_team_goal
    FROM table2
        LEFT JOIN match on table2.match_api_id1 = match.match_api_id
    WHERE match_api_id1 IS NOT NULL
),
/*
Table4 provides, for each match and each away team, the number of players with a free kick accuracy above 89 (away_player column).
Same as Table2 but for away teams.
*/
table4 AS (
    SELECT m_away.match_api_id AS match_api_id2,
        -- Count away team players with fka > 89.
        COUNT(*) AS away_player
    FROM table1 t1
        LEFT JOIN match m_away ON t1.player_api_id = m_away.away_player_1
        OR t1.player_api_id = m_away.away_player_2
        OR t1.player_api_id = m_away.away_player_3
        OR t1.player_api_id = m_away.away_player_4
        OR t1.player_api_id = m_away.away_player_5
        OR t1.player_api_id = m_away.away_player_6
        OR t1.player_api_id = m_away.away_player_7
        OR t1.player_api_id = m_away.away_player_8
        OR t1.player_api_id = m_away.away_player_9
        OR t1.player_api_id = m_away.away_player_10
        OR t1.player_api_id = m_away.away_player_11
        AND m_away.date = (
            SELECT MAX(t1.date)
            FROM table1 t1
            WHERE t1.player_api_id = m_away.away_player_1
                OR t1.player_api_id = m_away.away_player_2
                OR t1.player_api_id = m_away.away_player_3
                OR t1.player_api_id = m_away.away_player_4
                OR t1.player_api_id = m_away.away_player_5
                OR t1.player_api_id = m_away.away_player_6
                OR t1.player_api_id = m_away.away_player_7
                OR t1.player_api_id = m_away.away_player_8
                OR t1.player_api_id = m_away.away_player_9
                OR t1.player_api_id = m_away.away_player_10
                OR t1.player_api_id = m_away.away_player_11
                AND t1.date <= m_away.date
        )
    GROUP BY m_away.match_api_id
),
/*
In Table5, we keep the columns from Table 4 and add the goals of the away team.
*/
table5 AS (
    SELECT table4.*,
        match.away_team_goal
    FROM table4
        LEFT JOIN match on table4.match_api_id2 = match.match_api_id
    WHERE match_api_id2 IS NOT NULL
),
/*
In Table6, we merge Tables 3 and 5 using the FULL OUTER JOIN function.
*/
table6 AS (
    SELECT table3.*,
        table5.*
    FROM table3
        FULL OUTER JOIN table5 on table3.match_api_id1 = table5.match_api_id2
),
/*
In Table7, we separate the match_api_id, home, and away, keeping the remaining columns from Table 6.
*/
table7 AS (
    SELECT 
    -- COALESCE returns the first non-NULL value.
        COALESCE (table6.match_api_id1, table6.match_api_id2) AS match_api_id_home,
        COALESCE (table6.match_api_id1, table6.match_api_id2) AS match_api_id_away,
        table6.home_player,
        table6.away_player,
        table6.home_team_goal,
        table6.away_team_goal
    FROM table6
),
/*
In Table 8, we fill in the missing values in the home_team_goals and away_team_goals columns using the 
COALESCE function and the match table.
 */
table8 AS (
    SELECT table7.match_api_id_home,
        table7.match_api_id_away,
        table7.home_player,
        table7.away_player,
        -- We fill in the missing values of Table7 for home and away goals with the data from the match table using the COALESCE function.
        COALESCE (table7.home_team_goal, m.home_team_goal) AS home_team_goal,
        COALESCE (table7.away_team_goal, m.away_team_goal) AS away_team_goal
    FROM table7
        INNER JOIN match m on table7.match_api_id_home = m.match_api_id
)
/*
Now we are ready to calculate the wins for teams with more good free kickers.
*/
SELECT COUNT(*) AS total_games,
    -- Wins for teams with more good free kickers than the other team (wins_with_more_fka)
    SUM(
        CASE
            WHEN (
                home_player > away_player
                AND home_team_goal > away_team_goal
            )
            OR (
                home_player < away_player
                AND home_team_goal < away_team_goal
            )
            OR (
                home_player IS NULL
                AND away_player IS NOT NULL
                AND home_team_goal < away_team_goal
            )
            OR (
                home_player IS NOT NULL
                AND away_player IS NULL
                AND home_team_goal > away_team_goal
            ) THEN 1
            ELSE 0
        END
    ) AS wins_with_more_fka,
    SUM(
        CASE
            WHEN home_team_goal = away_team_goal THEN 1
            ELSE 0
        END
    ) AS draws,
    -- Wins for teams with less good free kickers (wins_with_less_fka).
    SUM(
        CASE
            WHEN (
                home_player > away_player
                AND home_team_goal < away_team_goal
            )
            OR (
                home_player < away_player
                AND home_team_goal > away_team_goal
            )
            OR (
                home_player IS NULL
                AND away_player IS NOT NULL
                AND home_team_goal > away_team_goal
            )
            OR (
                home_player IS NOT NULL
                AND away_player IS NULL
                AND home_team_goal < away_team_goal
            ) THEN 1
            ELSE 0
        END
    ) AS wins_with_less_fka,
    -- Win percentange for teams with more good free kickers in one match than the other team.
    ROUND (
        SUM(
            CASE
                WHEN (
                    home_player > away_player
                    AND home_team_goal > away_team_goal
                )
                OR (
                    home_player < away_player
                    AND home_team_goal < away_team_goal
                )
                OR (
                    home_player IS NULL
                    AND away_player IS NOT NULL
                    AND home_team_goal < away_team_goal
                )
                OR (
                    home_player IS NOT NULL
                    AND away_player IS NULL
                    AND home_team_goal > away_team_goal
                ) THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS win_percentange
FROM table8

/*
Teams with more top-rated FK takers (with a rating above 89) than their opponents have recorded 69 wins and 
38 losses, while 38 matches ended in a draw. Overall, in 148 games, these teams achieved a win percentage of 46.62%.

A similar study can be conducted for other player performance metrics to assess their impact on match outcomes.
*/