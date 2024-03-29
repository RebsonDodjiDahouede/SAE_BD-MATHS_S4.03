# SAE BD MATHS

## Membres du groupe

[![Yannis Barache](https://img.shields.io/badge/Yannis%20Barache-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Yannis-barache)
[![Hajar El Kasmi](https://img.shields.io/badge/Hajar%20El%20Kasmi-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Hajarelkasmi)
[![Rebson Dodji Da](https://img.shields.io/badge/Rebson%20Dodji%20Dahouede-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RebsonDodjiDahouede)
[![Roland Rakotomalala](https://img.shields.io/badge/Roland%20Rakotomalala-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rolandrkt)

## La base de données

### Description

Voici le script de création de la base de données :

```oracle

CREATE OR REPLACE type PointsInteret as object (
    Nom VARCHAR(255), 
    type VARCHAR(255),
    member function get_name RETURN VARCHAR
);
/
create or replace type BODY PointsInteret AS
member function get_name RETURN VARCHAR IS
    BEGIN
        return self.Nom;
    END;
END;

/
create type PointsInteretTable as table of PointsInteret;
/
CREATE OR REPLACE type IndiceQualite as object (
    Nom VARCHAR(255), 
    valeur INT,
    poids INT,
    member function get_impact RETURN INT
);
/
create or replace type BODY IndiceQualite AS
member function get_impact RETURN INT IS
    BEGIN
        return self.poids * self.valeur;
    END;
END;
/
CREATE TYPE IndiceArray AS VARRAY(10) OF IndiceQualite; 

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
```




## DATALOG


### Requete 1

La requête 1 consiste à afficher les chemins possibles qui partent d'un point X et qui arrivent à un point Y, 
peu importe le nombre de tronçons.


```datalog
troncon(t1, orleans, blois, terre).
troncon(t2, blois, tours, terre).
troncon(t3, blois, chartres, goudron).
troncon(t5, chartres, paris, goudron).
troncon(t6, paris, lille, sable).
troncon(t7, lille, bruxelles, sable).

chemin(X, Y) :- tronçon(_, X, Y, _).
chemin(X, Z) :- tronçon(_, X, Y, _), chemin(Y, Z).
```

#### Query pour avoir tous les chemins possibles entre deux points

```datalog
chemin(orleans,Y)?
```

La requête 1 est donc une requête récursive qui permet de trouver tous les chemins possibles entre deux points X et Y.


### Requete 2

La requête 2 consiste à faire afficher tous les chemins possibles entre deux points X et Y en ne passant que par des chemins de terre.

```datalog
troncon(t1, orleans, blois, terre).
troncon(t2, blois, tours, go).
troncon(t3, blois, chartre, goudron).
troncon(t4, tours, paris, terre).
troncon(t5, tours, dunkerque, sable).
troncon(t6, blois, marseille, terre).
troncon(t7, tours, orleans, terre).

chemin(X, Y) :- troncon(_, X, Y, terre).
chemin(X, Z) :- troncon(_, X, Y, terre), chemin(X, Y), chemin(Y, Z).
chemin(X, Y) :- troncon(_, X, Z, terre), chemin(Z, W), chemin(W, Y).
```


### Query chemin impair

```datalog
troncon(t1, orleans, blois, terre).
troncon(t2, blois, tours, terre).
troncon(t3, blois, chartre, goudron).
troncon(t4, tours, paris, terre).
troncon(t5, tours, dunkerque, sable).
troncon(t6, blois, marseille, terre).
troncon(t7, paris, marseille, terre).
troncon(t7, marseille, nancy, terre).
troncon(t8, nancy, neuneu, terre).
troncon(t9, neuneu, prout, terre).




chemin1(X, Y) :- troncon(_, X, Y, _).
chemin1(X,Z) :- troncon(_, X, Y, _), chemin2(Y, Z).

chemin2(X, Z) :- troncon(_, X, Y, _), chemin1(Y,Z).

odd_chemin(X, Y) :- chemin1(X, Y).
```


### Query circuit

```datalog
troncon(t1, orleans, blois, terre).
troncon(t2, blois, tours, terre).
troncon(t3, blois, chartre, goudron).
troncon(t4, tours, paris, terre).
troncon(t5, tours, dunkerque, sable).
troncon(t6, blois, marseille, terre).
troncon(t7, paris, marseille, terre).
troncon(t7, marseille, nancy, terre).
troncon(t8, nancy, neuneu, terre).
troncon(t9, neuneu, prout, terre).
troncon(t20, paris, orleans, terre).

chemin(X, Y) :- troncon(_, X, Y, _).
chemin(X, Z) :- troncon(_, X, Y, _), chemin(Y, Z).

circuit(X) :- chemin(X, Y), chemin(Y, X).
```





