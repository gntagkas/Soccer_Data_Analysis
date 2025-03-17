/*
https://www.kaggle.com/datasets/hugomathien/soccer/data
*/

-- Common column for Tables: Player and Player_attributes -> player_api_id

-- Common column for Tables: Team and Team_attributes -> team_api_id AND team_fifa_api_id

-- Common column for Tables: Match and Team -> match.home_team_api_id AND team.team_api_id OR match.away_team_api_id AND team.team_api_id

-- Creating 7 different tables (country, league, match, player, player_attributes, team, team_attributes)

CREATE TABLE country (
    id INTEGER PRIMARY KEY,
    country_name TEXT
);

CREATE TABLE league (
    id INTEGER PRIMARY KEY,
    country_id INT,
    League_Name TEXT,
    FOREIGN KEY (id) REFERENCES public.country (id)
);

DROP TABLE match;

CREATE TABLE match (
    match_id NUMERIC PRIMARY KEY,
    country_id NUMERIC,
    league_id NUMERIC,
    season TEXT,
    stage NUMERIC,
    date DATE,
    match_api_id NUMERIC,
    home_team_api_id NUMERIC,
    away_team_api_id NUMERIC,
    home_team_goal NUMERIC,
    away_team_goal NUMERIC,
    home_player_X1 NUMERIC,
    home_player_X2 NUMERIC,
    home_player_X3 NUMERIC,
    home_player_X4 NUMERIC,
    home_player_X5 NUMERIC,
    home_player_X6 NUMERIC,
    home_player_X7 NUMERIC,
    home_player_X8 NUMERIC,
    home_player_X9 NUMERIC,
    home_player_X10 NUMERIC,
    home_player_X11 NUMERIC,
    away_player_X1 NUMERIC,
    away_player_X2 NUMERIC,
    away_player_X3 NUMERIC,
    away_player_X4 NUMERIC,
    away_player_X5 NUMERIC,
    away_player_X6 NUMERIC,
    away_player_X7 NUMERIC,
    away_player_X8 NUMERIC,
    away_player_X9 NUMERIC,
    away_player_X10 NUMERIC,
    away_player_X11 NUMERIC,
    home_player_Y1 NUMERIC,
    home_player_Y2 NUMERIC,
    home_player_Y3 NUMERIC,
    home_player_Y4 NUMERIC,
    home_player_Y5 NUMERIC,
    home_player_Y6 NUMERIC,
    home_player_Y7 NUMERIC,
    home_player_Y8 NUMERIC,
    home_player_Y9 NUMERIC,
    home_player_Y10 NUMERIC,
    home_player_Y11 NUMERIC,
    away_player_Y1 NUMERIC,
    away_player_Y2 NUMERIC,
    away_player_Y3 NUMERIC,
    away_player_Y4 NUMERIC,
    away_player_Y5 NUMERIC,
    away_player_Y6 NUMERIC,
    away_player_Y7 NUMERIC,
    away_player_Y8 NUMERIC,
    away_player_Y9 NUMERIC,
    away_player_Y10 NUMERIC,
    away_player_Y11 NUMERIC,
    home_player_1 NUMERIC,
    home_player_2 NUMERIC,
    home_player_3 NUMERIC,
    home_player_4 NUMERIC,
    home_player_5 NUMERIC,
    home_player_6 NUMERIC,
    home_player_7 NUMERIC,
    home_player_8 NUMERIC,
    home_player_9 NUMERIC,
    home_player_10 NUMERIC,
    home_player_11 NUMERIC,
    away_player_1 NUMERIC,
    away_player_2 NUMERIC,
    away_player_3 NUMERIC,
    away_player_4 NUMERIC,
    away_player_5 NUMERIC,
    away_player_6 NUMERIC,
    away_player_7 NUMERIC,
    away_player_8 NUMERIC,
    away_player_9 NUMERIC,
    away_player_10 NUMERIC,
    away_player_11 NUMERIC,
    goal TEXT,
    shoton TEXT,
    shotoff TEXT,
    foulcommit TEXT,
    card TEXT,
    crosss TEXT,
    corner TEXT,
    possession TEXT,
    B365H NUMERIC,
    B365D NUMERIC,
    B365A NUMERIC,
    BWH NUMERIC,
    BWD NUMERIC,
    BWA NUMERIC,
    IWH NUMERIC,
    IWD NUMERIC,
    IWA NUMERIC,
    LBH NUMERIC,
    LBD NUMERIC,
    LBA NUMERIC,
    PSH NUMERIC,
    PSD NUMERIC,
    PSA NUMERIC,
    WHH NUMERIC,
    WHD NUMERIC,
    WHA NUMERIC,
    SJH NUMERIC,
    SJD NUMERIC,
    SJA NUMERIC,
    VCH NUMERIC,
    VCD NUMERIC,
    VCA NUMERIC,
    GBH NUMERIC,
    GBD NUMERIC,
    GBA NUMERIC,
    BSH NUMERIC,
    BSD NUMERIC,
    BSA NUMERIC
);


CREATE TABLE player (
    player_id INTEGER PRIMARY KEY,
    player_api_id INT,
    player_name TEXT,
    player_fifa_api_id INT,
    birthday DATE,
    height NUMERIC,
    weight NUMERIC
);

DROP TABLE player_attributes;



CREATE TABLE player_attributes (
    player_attributes_id INTEGER PRIMARY KEY,
    player_fifa_api_id INTEGER,
    player_api_id INTEGER,
    date DATE,
    overall_rating INTEGER,
    potential INTEGER,
    preferred_foot TEXT,
    attacking_work_rate TEXT,
    defensive_work_rate TEXT,
    crossing INTEGER,
    finishing INTEGER,
    heading_accuracy INTEGER,
    short_passing INTEGER,
    volleys INTEGER,
    dribbling INTEGER,
    curve INTEGER,
    free_kick_accuracy INTEGER,
    long_passing INTEGER,
    ball_control INTEGER,
    acceleration INTEGER,
    sprint_speed INTEGER,
    agility INTEGER,
    reactions INTEGER,
    balance INTEGER,
    shot_power INTEGER,
    jumping INTEGER,
    stamina INTEGER,
    strength INTEGER,
    long_shots INTEGER,
    aggression INTEGER,
    interceptions INTEGER,
    positioning INTEGER,
    vision INTEGER,
    penalties INTEGER,
    marking INTEGER,
    standing_tackle INTEGER,
    sliding_tackle INTEGER,
    gk_diving INTEGER,
    gk_handling INTEGER,
    gk_kicking INTEGER,
    gk_positioning INTEGER,
    gk_reflexes INTEGER
);

-- home_player_1 = ID GK, home_player_2 = ID DEFENDER etc (starting eleven home ID).
-- away_player_1 = ID GK, away_player_2 = ID DEFENDER etc (starting eleven away ID).

CREATE TABLE team (
    team_id INTEGER PRIMARY KEY,
    team_api_id INT,
    team_fifa_api_id INT,
    team_long_name TEXT,
    team_short_name TEXT
);

DROP TABLE team_attributes;


CREATE TABLE team_attributes (
    team_attributes_id INTEGER PRIMARY KEY,
    team_fifa_api_id INTEGER,
    team_api_id INTEGER,
    date DATE,
    buildUpPlaySpeed INTEGER,
    buildUpPlaySpeedClass TEXT,
    buildUpPlayDribbling INTEGER,
    buildUpPlayDribblingClass TEXT,
    buildUpPlayPassing INTEGER,
    buildUpPlayPassingClass TEXT,
    buildUpPlayPositioningClass TEXT,
    chanceCreationPassing INTEGER,
    chanceCreationPassingClass TEXT,
    chanceCreationCrossing INTEGER,
    chanceCreationCrossingClass TEXT,
    chanceCreationShooting INTEGER,
    chanceCreationShootingClass TEXT,
    chanceCreationPositioningClass TEXT,
    defencePressure INTEGER,
    defencePressureClass TEXT,
    defenceAggression INTEGER,
    defenceAggressionClass TEXT,
    defenceTeamWidth INTEGER,
    defenceTeamWidthClass TEXT,
    defenceDefenderLineClass TEXT
);

-- Set ownership of the tables to the postgres user.

ALTER TABLE country OWNER TO postgres;
ALTER TABLE league OWNER TO postgres;
ALTER TABLE match OWNER TO postgres;
ALTER TABLE player OWNER TO postgres;
ALTER TABLE player_attributes OWNER TO postgres;
ALTER TABLE team OWNER TO postgres;
ALTER TABLE team_attributes OWNER TO postgres;


