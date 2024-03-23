DROP TABLE Troncon;
DROP TABLE Etape;
DROP TABLE Confort;



CREATE TABLE Confort (
    categorieConfort INT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE Etape (
    codeEtape INT PRIMARY KEY,
    nomEtape VARCHAR(255),
    latitude FLOAT,
    longitude FLOAT,
    categorieConfort INT,
    FOREIGN KEY (categorieConfort) REFERENCES Confort(categorieConfort)
);

CREATE TABLE Troncon (
    idTroncon INT PRIMARY KEY,
    nomUsuel VARCHAR(255),
    distance_km FLOAT,
    typeSol VARCHAR(50),
    denivele_moyen INT,
    pointDepart INT,
    pointArrivee INT,
    pointsInteret PointsInteretTable,
    indiceQualite IndiceArray,
    FOREIGN KEY (pointDepart) REFERENCES Etape(codeEtape),
    FOREIGN KEY (pointArrivee) REFERENCES Etape(codeEtape)
) nested table pointsInteret store as pointsInteret_nt;





