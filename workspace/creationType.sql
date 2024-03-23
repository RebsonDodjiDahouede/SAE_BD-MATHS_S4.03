DROP TYPE IndiceArray FORCE;
DROP TYPE IndiceQualite FORCE;
DROP TYPE PointsInteretTable FORCE;
DROP TYPE PointsInteret FORCE;

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