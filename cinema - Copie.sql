DROP DATABASE IF EXISTS CINEMAS;
CREATE DATABASE CINEMAS;

USE CINEMAS;

CREATE TABLE Ville (
	CodePostal INT,
	NomVille VARCHAR(45),
    PRIMARY KEY (CodePostal)
);

CREATE TABLE Cinema (
	NumCinema INT,
	NomCinema VARCHAR(45),
	RueCinema VARCHAR(45),
	Codepostal INT,
    PRIMARY KEY (NumCinema),
	FOREIGN KEY (CodePostal) REFERENCES Ville(CodePostal)
);

CREATE TABLE Salle (
	NumSalle INT,
	Capacite INT,
	NumCinema INT,
	FOREIGN KEY (NumCinema) REFERENCES Cinema(NumCinema),
	PRIMARY KEY(NumSalle)
);

CREATE TABLE Film (
	NumFilm INT,
	Titre VARCHAR(45),
	Duree INT,
	Producteur VARCHAR(45),
	PRIMARY KEY (NumFilm)
);

CREATE TABLE Projection (
	NumFilm INT,
	NumSalle INT,
	DateP DATE,
	NbreEntree INT,
	FOREIGN KEY (NumFilm) REFERENCES Film(NumFilm),
	FOREIGN KEY (NumSalle) REFERENCES Salle(NumSalle),
	PRIMARY KEY (NumFilm, NumSalle, DateP)
);

INSERT INTO Ville VALUES
(11111, "VILLE1"),
(22222,"VILLE2"),
(33333,"VILLE3");

INSERT INTO Cinema VALUES
(1,"CINEMA1","RUE1",11111),
(2,"CINEMA2","RUE2",22222),
(3,"CINEMA3","RUE3",33333);

INSERT INTO Salle VALUES
(1,40,1),
(2,35,1),
(3,60,2),
(4,90,3),
(5,40,2);

INSERT INTO Film VALUES
(1,"FILM1",90,"PROD1"),
(2,"FILM2",90,"PROD2"),
(3,"FILM3",80,"PROD3"),
(4,"FILM4",70,"PROD4");

INSERT INTO Projection VALUES
(1,2,"2011-10-21",30),
(2,1,"2011-10-24",80),
(3,1,"2011-10-25",50),
(4,4,"2011-10-16",70),
(1,3,"2011-10-25",60),
(2,2,"2011-10-23",20),
(1,4,"2011-08-25",50),
(1,4,"2011-08-27",50),
(1,4,"2014-10-24",50),
(2,1,"2015-10-24",50);

-- 1- Afficher la liste des projections où le nombre d’entrées a dépassé 80% de la capacité de la salle de projection.
SELECT p.*
FROM Projection p 
INNER JOIN Salle s ON p.NumSalle = s.NumSalle
WHERE p.NbreEntree >= 0.8 * s.Capacite;

SELECT p.*
FROM Projection p , Salle s
WHERE p.NumSalle = s.NumSalle AND p.NbreEntree >= 0.8 * s.Capacite;

-- 2- Afficher le nombre de salles de cinéma par ville (nom ville)
SELECT COUNT(s.NumSalle) AS "Nombre de salles de cinéma", v.NomVille
FROM Cinema c 
INNER JOIN Salle s ON c.NumCinema=s.NumCinema 
INNER JOIN Ville v ON c.CodePostal=v.CodePostal
GROUP BY v.NomVille;

-- 3- Afficher la capacité totale de chaque cinéma (nom du cinéma).
SELECT c.NomCinema, SUM(s.Capacite) AS "Capacité totale"
FROM Salle s 
INNER JOIN Cinema c ON s.NumCinema= c.NumCinema
GROUP BY c.NomCinema;

-- 4- Afficher le nombre de films projetés le 25/08/2011 par producteur.
SELECT COUNT(f.NumFilm) AS "Nombre de films", f.Producteur
FROM Projection p 
INNER JOIN Film f ON p.NumFilm=f.NumFilm
WHERE DateP = '2011-10-25'
GROUP BY f.Producteur;

-- 5- Afficher pour chaque film (titre du film) le nombre de projections entre le
-- 20/10/2011 et 25/10/2011.
SELECT f.Titre,COUNT(*) AS "Nombre de projections"
FROM Projection p 
INNER JOIN Film f ON p.NumFilm=f.NumFilm
WHERE p.DateP BETWEEN '2011-10-20' AND '2011-10-25'
-- WHERE p.DateP >= '2011-10-20' AND p.DateP <= '2011-10-25'
GROUP BY f.Titre;