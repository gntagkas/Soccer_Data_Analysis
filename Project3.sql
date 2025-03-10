/*
3. Creating Groups with Specific Statistics

Question: Which teams have players with high stats in specific areas, 
such as foul shooting, and how does this affect team performance?

Description: create teams with high performance characteristics 
(e.g., more players with high scores in shot power or free kick accuracy) and analyze the effect of these 
players on team performance.
*/



/*
Tha asxolithoume me ta free kick_accuracy (fka). Asxoloumaste me paixtes pou exoun fka>89. Epilegoume autous tous paixtes
prwta gia tis omades pou paizoun entos edras kai metrame posoi tetoioi paixtes uparxoun se kathe agwna. Antistoixa gia tis 
omades pou paizoun ektos edras kanoume to idio, kai metrame posoi tetoioi paixtes paizoun se mia omada.
Sthn sunexeia enwnoume autous tous pinakes wste gia kathe paixnidi na exoume se mia grammi ton arithmo tn paixtwn entos
kai ektos edras me fka > 89. Prosthetoume kai ta home_goals kai away_goals.
Telos upologizoume se posous agwnes pou h mia omada eixe perissoterous kalous fka apo thn antipali nikise, pote egine to antitheto
kai posa paixnidia irthan isopalia wste na vgaloume xrisima apotelesmata.
*/


-- Table1: Ksexwrizoume tous paixtes me free_kick_accuracy over 89.
WITH table1 AS (
    SELECT player_api_id,
        free_kick_accuracy,
        date
    FROM player_attributes pa
    WHERE free_kick_accuracy > 89
),
-- kanoume left join ton table1 me ton table match (gia ta home games)
table2 AS (
    SELECT m_home.match_api_id AS match_api_id1,
        --count tous paixtes mia omadas me free_kickers > 89 (ana agwna) se home matches.
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
        -- pairnoume to pio kontino overall ston agwna (profanws prin)
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
-- kanoume join tn table2 me to match kai prosthetoume ta home_goals
table3 AS (
    SELECT 
        table2.*,
        match.home_team_goal
    FROM table2
        LEFT JOIN match on table2.match_api_id1 = match.match_api_id
    WHERE match_api_id1 IS NOT NULL
),
-- kanoume left join ton table1 me ton table match (gia ta away games)
table4 AS (
    SELECT m_away.match_api_id AS match_api_id2,
    --count tous paixtes mia omadas me free_kickers > 89 (ana agwna) se away matches.
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
-- kanoume join tn table4 me to match kai prosthetoume ta away_goals
table5 AS (
    SELECT 
        table4.*,
        match.away_team_goal
    FROM table4
        LEFT JOIN match on table4.match_api_id2 = match.match_api_id
    WHERE match_api_id2 IS NOT NULL
),
-- kanoume FULL OUTER JOIN table3-table5 (wste na mhn xasoume dedomena kai opou den uparxei tairiasma na exoume NULL times)
table6 AS (
    SELECT 
        table3.*,
        table5.*
    FROM table3
    FULL OUTER JOIN table5 on table3.match_api_id1 = table5.match_api_id2
),
-- ksexwrizoume to match_api_id_home me to match_api_id_away
table7 AS (
    SELECT
    -- simplirwnoume ta kena sto match_api_id1 (opou uparxoun) me to match_api_id2
        COALESCE (table6.match_api_id1 , table6.match_api_id2) AS match_api_id_home,
        COALESCE (table6.match_api_id1 , table6.match_api_id2) AS match_api_id_away,
        table6.home_player,
        table6.away_player,
        table6.home_team_goal,
        table6.away_team_goal
    FROM table6
),
-- prosthetoume stis NULL times me thn voitheia ths function COALESCE ta home_goals kai ta away_goals me inner join match table
table8 AS (
    SELECT
        table7.match_api_id_home,
        table7.match_api_id_away,
        table7.home_player,
        table7.away_player,
        -- simplirwnoume ta kena tou table7 sta home,away goals me ta data apo ton table match pou exoume.
        COALESCE (table7.home_team_goal , m.home_team_goal) AS home_team_goal,
        COALESCE (table7.away_team_goal , m.away_team_goal) AS away_team_goal
    FROM table7
    INNER JOIN match m
    on table7.match_api_id_home = m.match_api_id
)

-- menei na upologisoume tis nikes
SELECT 
    COUNT(*) AS total_games,
    -- wins for teams with more good free kickers than the other team (WinA)
    SUM(CASE 
    WHEN (home_player > away_player AND home_team_goal > away_team_goal) OR
         (home_player < away_player AND home_team_goal < away_team_goal) OR 
         (home_player IS NULL AND away_player IS NOT NULL AND home_team_goal < away_team_goal ) OR 
         (home_player IS NOT NULL AND away_player IS NULL AND home_team_goal > away_team_goal)  
    THEN 1 
    ELSE 0 
    END) AS WinA,
    SUM(CASE 
    WHEN home_team_goal = away_team_goal THEN 1 
    ELSE 0 
    END) AS draws,
    -- wins for teams with less good free kickers.
    SUM(CASE 
    WHEN (home_player > away_player AND home_team_goal < away_team_goal) OR
         (home_player < away_player AND home_team_goal > away_team_goal) OR 
         (home_player IS NULL AND away_player IS NOT NULL AND home_team_goal > away_team_goal ) OR 
         (home_player IS NOT NULL AND away_player IS NULL AND home_team_goal < away_team_goal)  
    THEN 1 
    ELSE 0 
    END) AS WinB,
    -- win percentange for teams with more good free kickers in one match than the other team.
    ROUND (
        SUM(CASE 
    WHEN (home_player > away_player AND home_team_goal > away_team_goal) OR
         (home_player < away_player AND home_team_goal < away_team_goal) OR 
         (home_player IS NULL AND away_player IS NOT NULL AND home_team_goal < away_team_goal ) OR 
         (home_player IS NOT NULL AND away_player IS NULL AND home_team_goal > away_team_goal)  
    THEN 1 
    ELSE 0 
    END) * 100.0 / COUNT(*) ,2
    ) AS win_percentange
FROM table8


/*
Teams with more top-rated FK takers (with a rating above 89) than their opponents have recorded 69 wins and 
38 losses, while 38 matches ended in a draw. Overall, in 148 games, these teams achieved a win percentage of 46.62%.

A similar study can be conducted for other player performance metrics to assess their impact on match outcomes.
*/