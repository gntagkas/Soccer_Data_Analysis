/*
Fill country table with data
*/

COPY country(id,country_name)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Country.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8');

SELECT * FROM country;

/*
Fill league table with data
*/


COPY league(id,country_id,League_name)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\League.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8');

SELECT * FROM league;

/*
Fill match table with data
*/


COPY match (
    match_id,
    country_id,
    league_id,
    season,
    stage,
    date,
    match_api_id,
    home_team_api_id,
    away_team_api_id,
    home_team_goal,
    away_team_goal,
    home_player_X1,
    home_player_X2,
    home_player_X3,
    home_player_X4,
    home_player_X5,
    home_player_X6,
    home_player_X7,
    home_player_X8,
    home_player_X9,
    home_player_X10,
    home_player_X11,
    away_player_X1,
    away_player_X2,
    away_player_X3,
    away_player_X4,
    away_player_X5,
    away_player_X6,
    away_player_X7,
    away_player_X8,
    away_player_X9,
    away_player_X10,
    away_player_X11,
    home_player_Y1,
    home_player_Y2,
    home_player_Y3,
    home_player_Y4,
    home_player_Y5,
    home_player_Y6,
    home_player_Y7,
    home_player_Y8,
    home_player_Y9,
    home_player_Y10,
    home_player_Y11,
    away_player_Y1,
    away_player_Y2,
    away_player_Y3,
    away_player_Y4,
    away_player_Y5,
    away_player_Y6,
    away_player_Y7,
    away_player_Y8,
    away_player_Y9,
    away_player_Y10,
    away_player_Y11,
    home_player_1,
    home_player_2,
    home_player_3,
    home_player_4,
    home_player_5,
    home_player_6,
    home_player_7,
    home_player_8,
    home_player_9,
    home_player_10,
    home_player_11,
    away_player_1,
    away_player_2,
    away_player_3,
    away_player_4,
    away_player_5,
    away_player_6,
    away_player_7,
    away_player_8,
    away_player_9,
    away_player_10,
    away_player_11,
    goal,
    shoton,
    shotoff,
    foulcommit,
    card,
    crosss,
    corner,
    possession,
    B365H,
    B365D,
    B365A,
    BWH,
    BWD,
    BWA,
    IWH,
    IWD,
    IWA,
    LBH,
    LBD,
    LBA,
    PSH,
    PSD,
    PSA,
    WHH,
    WHD,
    WHA,
    SJH,
    SJD,
    SJA,
    VCH,
    VCD,
    VCA,
    GBH,
    GBD,
    GBA,
    BSH,
    BSD,
    BSA
)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Match3.txt'
WITH (FORMAT text, DELIMITER '|', HEADER TRUE, ENCODING 'UTF8', NULL '');


SELECT * FROM match;

/*
Fill player table with data
*/


COPY player(player_id,player_api_id,player_name,player_fifa_api_id,birthday,
height,weight)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Player.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8');

SELECT * FROM player;

/*
Fill player_attributes table with data
*/


COPY player_attributes (
    player_attributes_id, 
    player_fifa_api_id, 
    player_api_id, 
    date, 
    overall_rating, 
    potential, 
    preferred_foot, 
    attacking_work_rate, 
    defensive_work_rate,
    crossing, 
    finishing, 
    heading_accuracy, 
    short_passing, 
    volleys, 
    dribbling, 
    curve, 
    free_kick_accuracy, 
    long_passing, 
    ball_control, 
    acceleration, 
    sprint_speed, 
    agility, 
    reactions, 
    balance, 
    shot_power, 
    jumping, 
    stamina, 
    strength, 
    long_shots, 
    aggression, 
    interceptions, 
    positioning, 
    vision, 
    penalties,
    marking, 
    standing_tackle, 
    sliding_tackle, 
    gk_diving, 
    gk_handling, 
    gk_kicking, 
    gk_positioning, 
    gk_reflexes
)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Player_Attributes.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8', NULL '')

SELECT * FROM player_attributes;

/*
Fill team table with data
*/



COPY team(team_id,team_api_id,team_fifa_api_id,team_long_name,team_short_name)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Team.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8');

SELECT * FROM Team;

/*
Fill team_attributes table with data
*/


COPY team_attributes (
    team_attributes_id, 
    team_fifa_api_id, 
    team_api_id, 
    date, 
    buildUpPlaySpeed, 
    buildUpPlaySpeedClass, 
    buildUpPlayDribbling, 
    buildUpPlayDribblingClass,
    buildUpPlayPassing, 
    buildUpPlayPassingClass, 
    buildUpPlayPositioningClass,
    chanceCreationPassing, 
    chanceCreationPassingClass, 
    chanceCreationCrossing, 
    chanceCreationCrossingClass,
    chanceCreationShooting, 
    chanceCreationShootingClass, 
    chanceCreationPositioningClass,
    defencePressure, 
    defencePressureClass, 
    defenceAggression, 
    defenceAggressionClass,
    defenceTeamWidth, 
    defenceTeamWidthClass, 
    defenceDefenderLineClass
)
FROM 'D:\SQL_Data_For_Projects\Data_For_Practice3\Team_Attributes.txt'
WITH (FORMAT text, DELIMITER E'\t', HEADER TRUE, ENCODING 'UTF8', NULL '');


SELECT * FROM team_attributes;