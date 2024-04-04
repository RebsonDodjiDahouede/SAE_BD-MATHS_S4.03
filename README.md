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

    Nous considérons une base de données simplifiée qui stocke des informations des
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

Voici le jeu de données de notre Database:

```oracle
-- Insertion des catégories de confort
INSERT INTO Confort (categorieConfort, description) VALUES (1, 'Ville');
INSERT INTO Confort (categorieConfort, description) VALUES (2, 'Refuge');
INSERT INTO Confort (categorieConfort, description) VALUES (3, 'Camping');
INSERT INTO Confort (categorieConfort, description) VALUES (4, 'Auberge');
INSERT INTO Confort (categorieConfort, description) VALUES (5, 'Gite');
INSERT INTO Confort (categorieConfort, description) VALUES (6, 'Chalet');
INSERT INTO Confort (categorieConfort, description) VALUES (7, 'Bivouac');
INSERT INTO Confort (categorieConfort, description) VALUES (8, 'Abri de montagne');
INSERT INTO Confort (categorieConfort, description) VALUES (9, 'Cabane isolee');
INSERT INTO Confort (categorieConfort, description) VALUES (10, 'Autre');

-- Insertion des étapes
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (1, 'Orleans', 47.902964, 1.909251, 1);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (2, 'Prati', 43.970675, 9.232572, 2);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (3, 'L''Onda', 42.105156, 9.066107, 3);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (4, 'Refuge de la Tonnara', 42.141295, 9.098731, 2);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (5, 'Camping de la Plage', 42.075527, 9.136216, 3);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (6, 'Auberge du Lac', 45.871016, 6.665229, 4);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (7, 'Gite de Montagne', 46.179213, 6.720354, 5);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (8, 'Chalet de la Cascade', 45.956285, 6.732328, 6);
INSERT INTO Etape (codeEtape, nomEtape, latitude, longitude, categorieConfort) VALUES (9, 'Bivouac des Cimes', 45.913623, 6.866788, 7);


INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    1, 
    'Orleans - Prati', 
    500, 
    'bitume', 
    100, 
    1, 
    2, 
    PointsInteretTable(
        PointsInteret('Point A', 'Type A'),
        PointsInteret('Point B', 'Type B')
    ),
    IndiceArray(
        IndiceQualite('Indice 1', 10, 3),
        IndiceQualite('Indice 2', 8, 2)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    2, 
    'Prati - L''Onda', 
    700, 
    'terre', 
    200, 
    2, 
    3, 
    PointsInteretTable(
        PointsInteret('Point C', 'Type C'),
        PointsInteret('Point D', 'Type D')
    ),
    IndiceArray(
        IndiceQualite('Indice 3', 12, 5),
        IndiceQualite('Indice 4', 6, 3)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    3, 
    'L''Onda - Refuge de la Tonnara', 
    800, 
    'terre', 
    150, 
    3, 
    4, 
    PointsInteretTable(
        PointsInteret('Point E', 'Type E'),
        PointsInteret('Point F', 'Type F')
    ),
    IndiceArray(
        IndiceQualite('Indice 5', 15, 7),
        IndiceQualite('Indice 6', 8, 4)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    4, 
    'L''Onda - Camping de la Plage', 
    1000, 
    'terre', 
    50, 
    3, 
    5, 
    PointsInteretTable(
        PointsInteret('Point G', 'Type G'),
        PointsInteret('Point H', 'Type H')
    ),
    IndiceArray(
        IndiceQualite('Indice 7', 20, 10),
        IndiceQualite('Indice 8', 5, 2)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    5, 
    'Orleans - Auberge du Lac', 
    600, 
    'bitume', 
    120, 
    1, 
    6, 
    PointsInteretTable(
        PointsInteret('Point I', 'Type I'),
        PointsInteret('Point J', 'Type J')
    ),
    IndiceArray(
        IndiceQualite('Indice 9', 18, 6),
        IndiceQualite('Indice 10', 10, 3)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    6, 
    'Auberge du Lac - Gite de Montagne', 
    400, 
    'terre', 
    180, 
    6, 
    7, 
    PointsInteretTable(
        PointsInteret('Point K', 'Type K'),
        PointsInteret('Point L', 'Type L')
    ),
    IndiceArray(
        IndiceQualite('Indice 11', 16, 4),
        IndiceQualite('Indice 12', 9, 3)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    7, 
    'Gite de Montagne - Chalet de la Cascade', 
    300, 
    'terre', 
    150, 
    7, 
    8, 
    PointsInteretTable(
        PointsInteret('Point M', 'Type M'),
        PointsInteret('Point N', 'Type N')
    ),
    IndiceArray(
        IndiceQualite('Indice 13', 14, 2),
        IndiceQualite('Indice 14', 12, 4)
    )
);

INSERT INTO Troncon (idTroncon, nomUsuel, distance_km, typeSol, denivele_moyen, pointDepart, pointArrivee, pointsInteret, indiceQualite) VALUES (
    8, 
    'Gite de Montagne - Bivouac des Cimes', 
    500, 
    'terre', 
    250, 
    7, 
    9, 
    PointsInteretTable(
        PointsInteret('Point O', 'Type O'),
        PointsInteret('Point P', 'Type P')
    ),
    IndiceArray(
        IndiceQualite('Indice 15', 22, 6),
        IndiceQualite('Indice 16', 18, 5)
    )
);
```

### Requêtes partie 3.2

**_Donner les noms des étapes que nous pouvons atteindre directement en suivant
les tronçons qui partent d’Orléans_**

```oracle
SELECT DISTINCT e.nomEtape
FROM Troncon t
JOIN Etape e ON t.pointArrivee = e.codeEtape
WHERE t.pointDepart = (SELECT codeEtape FROM Etape WHERE nomEtape = 'Orleans');
```

**_Veuillez fournir la liste des étapes accessibles depuis Orléans avec une seule étape
intermédiaire._**

```oracle
SELECT DISTINCT e3.nomEtape
FROM Troncon t1
JOIN Troncon t2 ON t1.pointArrivee = t2.pointDepart
JOIN Etape e1 ON t1.pointDepart = e1.codeEtape
JOIN Etape e2 ON t1.pointArrivee = e2.codeEtape
JOIN Etape e3 ON t2.pointArrivee = e3.codeEtape
WHERE e1.nomEtape = 'Orleans';
```

**_Veuillez fournir la liste des étapes accessibles depuis Orléans, avec un nombre
quelconque d’étapes intermédiaires._**

_CTE_ : Common Table Expression

`WITH Chemin(codeEtape, niveau) AS (...)` : C'est la déclaration de la CTE. Elle commence par le mot-clé WITH, suivi du nom de la CTE (Chemin) et des colonnes qu'elle va retourner (codeEtape et niveau). Dans cette partie, deux sous-requêtes sont unies à l'aide de UNION ALL.

La première sous-requête : Elle sélectionne le point d'arrivée (pointArrivee) des tronçons partant d'Orléans. Elle attribue ces valeurs à codeEtape et initialise le niveau à 1.

La deuxième sous-requête : Cette partie est récursive. Elle sélectionne le point d'arrivée des tronçons (pointArrivee) et incrémente le niveau de 1 pour chaque itération. Elle rejoint également la CTE elle-même (Chemin) pour obtenir les étapes précédentes dans le chemin.

`SELECT DISTINCT e.nomEtape, c.niveau` : C'est la requête principale qui sélectionne les noms des étapes (nomEtape) et les niveaux correspondants à partir de la CTE (Chemin). La clause DISTINCT assure que chaque paire (nom d'étape, niveau) est unique.

`JOIN Etape e ON c.codeEtape = e.codeEtape` : Cette partie de la requête joint la CTE (Chemin) avec la table Etape sur le champ codeEtape pour obtenir les noms des étapes correspondant aux codes d'étape générés dans la CTE.

```oracle
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
_En résumé, cette requête génère tous les chemins possibles à partir de la ville d'Orléans en suivant les tronçons successifs, en utilisant une CTE récursive pour itérer à travers les tronçons jusqu'à ce qu'il n'y ait plus de nouveaux tronçons à explorer._

### Requêtes partie 3.3

**_Pour chaque tronçon, donner le nombre de points d’intérêt, par type._**

`SELECT t.idTroncon, pi.type AS type_de_point, COUNT(*) AS nombre_de_points` : Cette partie spécifie les colonnes à sélectionner dans le résultat de la requête. t.idTroncon représente l'identifiant du tronçon. pi.type AS type_de_point renomme la colonne type de la table pointsInteret en type_de_point. COUNT(*) AS nombre_de_points calcule le nombre de lignes (points d'intérêt) pour chaque combinaison de idTroncon et type.

`FROM Troncon t, TABLE(t.pointsInteret) pi` : Cette partie spécifie les tables à partir desquelles les données sont sélectionnées. Troncon t est la table principale. TABLE(t.pointsInteret) pi est une fonction de table qui transforme le type de collection pointsInteret de la table Troncon en lignes individuelles pouvant être utilisées dans une requête SQL.

`GROUP BY t.idTroncon, pi.type` : Cette partie de la requête spécifie comment les résultats doivent être regroupés. Les résultats sont regroupés par idTroncon et type_de_point.
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
```

**_L’impact d’un indice de qualité est donné par le produit de sa valeur et du poids
que lui est attribué. Pour chaque tronçon, indiquer l’impact de chaque indice de
qualité._**

**Ici nous pouvons voir que la fonction `get_impact` défini lors de la création de l'objet IndiceQualite est réutilisée ici dans l'intérêt de la requête ce qui la rend plus simple.**
```
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


### Requête chemin possible

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


### Requete passage par terre

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


### Datalog chemin impair

Cette requête consiste à afficher les chemins possibles entre deux points X et Y en passant par un nombre impair de tronçons.

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
troncon(t9, neuneu, erecup, terre).

chemin1(X, Y) :- troncon(_, X, Y, _).
chemin1(X,Z) :- troncon(_, X, Y, _), chemin2(Y, Z).

chemin2(X, Z) :- troncon(_, X, Y, _), chemin1(Y,Z).

odd_chemin(X, Y) :- chemin1(X, Y).
```

### Query

```datalog
odd_chemin(tours, Y)?
```

### Résultat

```datalog
odd_chemin(tours, dunkerque)
odd_chemin(tours, erecup)
odd_chemin(tours, nancy)
odd_chemin(tours, paris)
```

### Explication

C'est une requête récursive qui donc récupère tous les chemins entre X et Y si le nombre de tronçons empruntés est impair.
On a ainsi tous les chemins directs entre tours et les autres villes, ici, c'est Paris et Dunkerque. 
Et on doit ensuite rajouter les impairs.
Donc on passe le chemin de Tours à Paris (on récupère), puis de Paris à Marseille (on ne récupère pas),
ensuite de Marseille à Nancy (on récupère), ensuite de Nancy à Neuneu (on ne récupère pas) et enfin de Neuneu à EreCup (on récupère).

### Datalog circuit

Cette query permet de déterminer si une étape est dans un circuit.

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

### Query

```datalog
circuit(X)?
```

### Result

```datalog
circuit(blois)
circuit(orleans)
circuit(paris)
circuit(tours)
```






