
DROP TABLE IF EXISTS dbo.shots;
GO

DROP TABLE IF EXISTS dbo.players;
GO

CREATE TABLE dbo.players (
    player_id int NOT NULL PRIMARY KEY,
    player_name varchar(255) NOT NULL,
    shots_attempted int NOT NULL,
	shots_made int NOT NULL
);
GO

CREATE TABLE dbo.shots (
    shot_id int NOT NULL PRIMARY KEY,
	player_id int FOREIGN KEY REFERENCES dbo.players(player_id),
	clock_time DATE NOT NULL,
	shot_made bit NOT NULL
);
GO

INSERT INTO dbo.players (player_id, player_name, shots_attempted, shots_made)
VALUES (1, 'Mary', 0 , 0);
GO

INSERT INTO dbo.players (player_id, player_name, shots_attempted, shots_made)
VALUES (2, 'Sue', 0 , 0);
GO
