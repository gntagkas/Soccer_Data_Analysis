# European Soccer Database Analysis

This project utilizes the **European Soccer Database** dataset from [Kaggle](https://www.kaggle.com/datasets/hugomathien/soccer/data) to conduct various analyses on soccer data. The main goal is to explore team strategies, player performance, and match outcomes using **PostgreSQL** and **SQL** queries. The objective is to enhance SQL skills by working with real, large datasets that contain multiple tables and columns, all sourced from Kaggle.


## Technologies Used
- **Visual Studio Code** for development.
- **PostgreSQL** for managing the database and performing data analysis.

## Project Structure
The project consists of several SQL scripts designed to work with the European Soccer Database. Here's the breakdown:

### 1. **Create_Database.sql**
   This script is used to create the PostgreSQL database that will store all the soccer data.

### 2. **Create_Table.sql**
   This script creates seven tables in the database: `country`, `league`, `match`, `player`, `player_attributes`, `team`, and `team_attributes`.

### 3. **Fill_with_Data.sql**
   This script is responsible for populating the tables with data from `.txt` files that contain soccer data.

### 4. **Practice.sql**
   In this script, we run some basic queries to practice and answer specific questions to extract useful insights from the data.

## Key Questions & Analyses

### 1. **Team Strategy Analysis and Opponent Ranking**
   **Question:** Which team strategies (e.g., `buildUpPlayPassing`, `chanceCreationShooting`) lead to better performance against teams with different strategies?

   **Description:** By combining team strategy data with match results, we analyze which strategies are most effective when a team faces opponents with specific strategies. This helps us understand how a team's tactics influence their performance based on the opponent's approach.

### 2. **Analysis of Strategy and Scoring**
   **Question:** Which strategies of the coach (e.g., `offensive` or `defensive approach`) are associated with a greater number of goals on offense?

   **Description:** By combining team strategy data with match results, we test which strategy is more effective for scoring. This analysis helps identify whether an offensive or defensive approach leads to more goals.

### 3. **Creating Groups with Specific Statistics**
**Question:** Which teams have players with high stats in specific areas, such as foul shooting, and how does this affect team performance?

 **Description:** This analysis involves creating teams with high-performance characteristics (e.g., more players with high scores in shot power or free kick accuracy) and analyzing the effect of these players on team performance. We aim to understand how specific player attributes contribute to the overall success of the team.

 ### 4. Player Age and Team Performance Analysis
**Question:** How does the age of the players affect the overall performance of the team each season? Can a correlation be observed between the average age of the team and the number of wins?

 **Description:** This analysis explores the relationship between the average age of players on a team and the team’s overall performance each season. By examining this correlation, we aim to determine whether teams with younger or older players tend to perform better or worse in terms of wins and overall success.

---

> **Note:** For the four questions in this project, our primary focus was on writing correct SQL queries. Analyzing the results was not our main objective; instead, we focused on ensuring the code was accurate and that it generated reliable outputs.





