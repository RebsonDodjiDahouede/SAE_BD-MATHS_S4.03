# SAE BD MATHS

## Membres du groupe

[![Yannis Barache](https://img.shields.io/badge/Yannis%20Barache-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Yannis-barache)
[![Hajar El Kasmi](https://img.shields.io/badge/Hajar%20El%20Kasmi-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Hajarelkasmi)
[![Rebson Dodji Da](https://img.shields.io/badge/Rebson%20Dodji%20Dahouede-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RebsonDodjiDahouede)
[![Roland Rakotomalala](https://img.shields.io/badge/Roland%20Rakotomalala-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rolandrkt)

## La base de données

### Description

Voici le script de création de la base de données :
    Ce script combine le début de la première partie du sujet de la SAE contenant les tables Confort, Etape et Troncon.
    Voici la description de la base de données:

    Nous consid´erons une base de données simplifiée qui stocke des informations des
    tronçons faisant partie des parcours de randonnée. Un tronçon a un identificateur
    et est caractérisé par un point de d´epart et un point d’arrivée. Nous pouvons avoir
    plusieurs tronçons différents entre un point de départ et un point d’arrivée. Pour
    chaque tronçon, la base stocke, son nom usuel (s’il existe) ; la distance à parcourir,
    en kilomètre ; le type de sol (terre, bitume, gravier, etc), la dénivelé moyenne entre
    les points de départ et d’arrivée. Un point d’arrivée ou de départ est considéré
    comme une étape. La base stocke des informations sur les étapes : codeEtape
    (unique) nom de l’´etape (par exemple, Prati, L’Onda), latitude, longitude et
    son niveau de confort. Le niveau de confort d’une étape est défini par un indice
    de catégorie. Il existe 10 catégories de confort (pour indiquer, par exemple que
    l’étape correspond à une ville, à un refuge, à un placement de camping, etc ). La
    base stocke une description pour chaque catégorie.

Le première partie du script correspond à la création du modèle objet-relationnel. 
En effet, nous créons les deux types suivants:
    PointsInteretTable & IndiceArray

L'objet PointsInteret possède une simple fonction permettant de renvoyer son nom, l'objet IndiceQualite, lui, possède une fonction get_impact qui nous servira plus tard pour une requête.
Le type PointsInteretTable est une table contenant différents PointsInteret et le type IndiceArray est un Array de plusieurs IndiceQualite.

Une fois les types créés la table Troncon peut enfin les utiliser en tant que type pour ses deux attributs suivants : **pointInteret** et **indiceQualite**

Enfin la commande `nested table pointsInteret store as pointsInteret_nt;` nous permet de créer en mémoire une table pointsinteret_nt directement accessible à laquelle l'utilisateur pourra faire des requêtes.

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
### Jeu de données

```oracle

```

### Requêtes partie 3.2

```oracle
SELECT DISTINCT e.nomEtape
FROM Troncon t
JOIN Etape e ON t.pointArrivee = e.codeEtape
WHERE t.pointDepart = (SELECT codeEtape FROM Etape WHERE nomEtape = 'Orleans');

SELECT DISTINCT e3.nomEtape
FROM Troncon t1
JOIN Troncon t2 ON t1.pointArrivee = t2.pointDepart
JOIN Etape e1 ON t1.pointDepart = e1.codeEtape
JOIN Etape e2 ON t1.pointArrivee = e2.codeEtape
JOIN Etape e3 ON t2.pointArrivee = e3.codeEtape
WHERE e1.nomEtape = 'Orleans';

WITH Chemin(codeEtape, niveau) AS (
    SELECT pointArrivee AS codeEtape, 1 AS niveau
    FROM Troncon
    WHERE pointDepart = (SELECT codeEtape FROM Etape WHERE nomEtape = 'Orleans')
    UNION ALL
    SELECT t.pointArrivee, c.niveau + 1
    FROM Troncon t
    JOIN Chemin c ON t.pointDepart = c.codeEtape
)
SELECT DISTINCT e.nomEtape, c.niveau
FROM Chemin c
JOIN Etape e ON c.codeEtape = e.codeEtape;
```

### Requêtes partie 3.3

```oracle
SELECT 
    t.idTroncon,
    pi.type AS type_de_point,
    COUNT(*) AS nombre_de_points
FROM 
    Troncon t,
    TABLE(t.pointsInteret) pi
GROUP BY 
    t.idTroncon, 
    pi.type;

SELECT 
    t.idTroncon,
    iq.Nom AS nom_indice,
    iq.valeur AS valeur_indice,
    iq.poids AS poids_indice,
    iq.get_impact() AS impact_indice
FROM 
    Troncon t,
    TABLE(t.indiceQualite) iq;
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





