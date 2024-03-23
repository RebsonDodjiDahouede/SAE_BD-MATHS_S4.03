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
