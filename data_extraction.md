# Data Extraction Process from SQLite to .txt Files

The data I used is from the [Kaggle Soccer Dataset](https://www.kaggle.com/datasets/hugomathien/soccer/data), which is in **SQLite format**.

Since I’m working with **Visual Studio Code** and **PostgreSQL**, I can't directly use the SQLite file. Therefore, I need to export the tables into **.txt files**.

## Steps to Extract Data:

### 1. Install SQLite3  
I’ve already downloaded and installed **SQLite3** on my machine. I can use the **SQLite CLI** to interact with the `.sqlite` database file.

### 2. Open the Command Prompt  
I open **CMD** and navigate to the folder containing my SQLite database file:  
```sh
cd /d D:\SQL_Data_For_Projects
```

### 3. Open the SQLite Database
Once in the correct directory, I open the database in the SQLite CLI:

```sh
sqlite3 database.sqlite
```

### 4. List the Tables
To see all available tables in the database, I use the `.tables` command:

```sh
.tables
```

### 5. Set the Output Format
To export the data with columns separated by tabs, I set the output mode to `tabs`:

```sh
.mode tabs
```

### 6. Export Data to .txt Files
For each table, I use the `.output` command to specify the output `.txt` file, followed by the `SELECT * FROM table_name` query to export the data from that table.
For example, to export the League table:

```sh
.output league.txt
SELECT * FROM League;
```

### 7. Location of Exported Files
The exported `.txt` files are saved in the same folder as the database file.






