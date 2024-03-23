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

