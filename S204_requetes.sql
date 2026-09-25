-- =====================================================================
--  SAE S2.04 - BDCommunesBretonnes
--  Requetes et vues
--  Auteur : Kevin Boeffard - BUT Informatique - groupe C1
-- =====================================================================

USE BDCommunesBretonnes;


-- =====================================================================
--  Question 1 : 
-- =====================================================================
SELECT g.nomGare, c.nomCommune, d.nomDep
FROM GARE g
    JOIN COMMUNE c ON g.idCommune = c.idCommune
    JOIN DEPARTEMENT d ON c.idDep = d.idDep
WHERE g.estFret = TRUE
ORDER BY d.nomDep, c.nomCommune;


-- +------------------------+------------------------+---------------+
-- | nomGare                 | nomCommune              | nomDep        |
-- +------------------------+------------------------+---------------+
-- | CHATELAUDREN-PLOUAGAT   | CHATELAUDREN-PLOUAGAT   | COTES-D'ARMOR |
-- | GUINGAMP                | GUINGAMP                | COTES-D'ARMOR |
-- | LAMBALLE                | LAMBALLE-ARMOR          | COTES-D'ARMOR |
-- | CARNOET-LOCARN          | LOCARN                  | COTES-D'ARMOR |
-- | LOUDEAC                 | LOUDEAC                 | COTES-D'ARMOR |
-- | PLAINTEL                | PLAINTEL                | COTES-D'ARMOR |
-- | PLENEE-JUGON            | PLENEE-JUGON            | COTES-D'ARMOR |
-- | PLESTAN                 | PLESTAN                 | COTES-D'ARMOR |
-- | ...                     | ...                     | ...           |
-- +------------------------+------------------------+---------------+
-- (49 lignes)


-- =====================================================================
--  Question 2 : 
-- =====================================================================
SELECT c.nomCommune AS commune, cv.nomCommune AS voisine
FROM VOISINAGE v
    JOIN COMMUNE c  ON c.idCommune  = v.idCommune1
    JOIN COMMUNE cv ON cv.idCommune = v.idCommune2
WHERE c.nomCommune = 'VANNES'
UNION
SELECT c.nomCommune AS commune, cv.nomCommune AS voisine
FROM VOISINAGE v
    JOIN COMMUNE c  ON c.idCommune  = v.idCommune2
    JOIN COMMUNE cv ON cv.idCommune = v.idCommune1
WHERE c.nomCommune = 'VANNES'
ORDER BY voisine;

-- Resultat (7 lignes) :
-- +---------+--------------+
-- | commune | voisine      |
-- +---------+--------------+
-- | VANNES  | ARRADON      |
-- | VANNES  | PLESCOP      |
-- | VANNES  | PLOEREN      |
-- | VANNES  | SAINT-AVE    |
-- | VANNES  | SAINT-NOLFF  |
-- | VANNES  | SENE         |
-- | VANNES  | THEIX-NOYALO |
-- +---------+--------------+


-- =====================================================================
--  Question 3 : 
-- =====================================================================
SELECT c.idCommune, c.nomCommune, COUNT(g.codeGare) AS nbGares
FROM COMMUNE c
    LEFT JOIN GARE g ON g.idCommune = c.idCommune
WHERE c.idDep = 56
GROUP BY c.idCommune, c.nomCommune
HAVING COUNT(g.codeGare) = 0
ORDER BY c.nomCommune;

-- Resultat (240 lignes au total) - extrait :
-- +-----------+------------+---------+
-- | idCommune | nomCommune | nbGares |
-- +-----------+------------+---------+
-- | 56001     | ALLAIRE    | 0       |
-- | 56002     | AMBON      | 0       |
-- | 56003     | ARRADON    | 0       |
-- | 56004     | ARZAL      | 0       |
-- | 56005     | ARZON      | 0       |
-- | 56006     | AUGAN      | 0       |
-- | 56008     | BADEN      | 0       |
-- | 56009     | BANGOR     | 0       |
-- | ...       | ...        | ...     |
-- +-----------+------------+---------+
-- (240 lignes)


-- =====================================================================
--  Question 4 : 
-- =====================================================================
SELECT c.idCommune, c.nomCommune, s.prixMoyen
FROM COMMUNE c
    LEFT JOIN STATISTIQUES s
        ON s.idCommune = c.idCommune AND s.annee = 2018
WHERE c.idDep = 22
ORDER BY c.nomCommune;


-- +-----------+------------------------+-------------+
-- | idCommune | nomCommune             | prixMoyen   |
-- +-----------+------------------------+-------------+
-- | 22001     | ALLINEUC               |    80966.70 |
-- | 22002     | ANDEL                  |   162488.00 |
-- | 22003     | AUCALEUC               |   203500.00 |
-- | 22209     | BEAUSSAIS-SUR-MER      |   169454.00 |
-- | 22004     | BEGARD                 |   105038.00 |
-- | 22005     | BELLE-ISLE-EN-TERRE    |    88159.00 |
-- | 22006     | BERHET                 |   103625.00 |
-- | 22055     | BINIC-ETABLES-SUR-MER  |   185309.00 |
-- | 22008     | BOBITAL                |   197006.00 |
-- | 22107     | BON REPOS SUR BLAVET   |    78291.80 |
-- | ...       | ...                    | ...         |
-- +-----------+------------------------+-------------+



-- =====================================================================
--  Question 5 : 
-- =====================================================================
SELECT idCommune, nomCommune
FROM COMMUNE
WHERE idCommune IN (
    SELECT idCommune FROM GARE WHERE estFret = TRUE
)
ORDER BY nomCommune;

-- +-----------+------------------------+
-- | idCommune | nomCommune             |
-- +-----------+------------------------+
-- | 56007     | AURAY                  |
-- | 29004     | BANNALEC               |
-- | 29019     | BREST                  |
-- | 29024     | CARHAIX-PLOUGUER       |
-- | 22206     | CHATELAUDREN-PLOUAGAT  |
-- | 29039     | CONCARNEAU             |
-- | 35095     | DOL-DE-BRETAGNE        |
-- | 22070     | GUINGAMP               |
-- | ...       | ...                    |
-- +-----------+------------------------+
-- (46 lignes)


-- =====================================================================
--  Question 6 : 
-- =====================================================================
SELECT idCommune, nomCommune
FROM COMMUNE
WHERE idCommune NOT IN (
    SELECT idCommune FROM GARE
)
ORDER BY nomCommune;

-- Resultat (1087 lignes au total) - extrait :
-- +-----------+---------------------+
-- | idCommune | nomCommune          |
-- +-----------+---------------------+
-- | 35001     | ACIGNE              |
-- | 56001     | ALLAIRE             |
-- | 22001     | ALLINEUC            |
-- | 35002     | AMANLIS             |
-- | 56002     | AMBON               |
-- | 22002     | ANDEL               |
-- | 35003     | ANDOUILLE-NEUVILLE  |
-- | 35005     | ARBRISSEL           |
-- | ...       | ...                 |
-- +-----------+---------------------+
-- (1087 lignes)


-- =====================================================================
--  Question 7 : 
-- =====================================================================
SELECT idDep, nomDep
FROM DEPARTEMENT d
WHERE EXISTS (
    SELECT 1 FROM AEROPORT a WHERE a.idDep = d.idDep
);

-- Resultat (4 lignes) :
-- +-------+------------------+
-- | idDep | nomDep           |
-- +-------+------------------+
-- |    22 | COTES-D'ARMOR    |
-- |    29 | FINISTERE        |
-- |    35 | ILLE-ET-VILAINE  |
-- |    56 | MORBIHAN         |
-- +-------+------------------+



-- =====================================================================
--  Question 8 : 
-- =====================================================================
SELECT c.idCommune, c.nomCommune
FROM COMMUNE c
WHERE NOT EXISTS (
    SELECT 1 FROM STATISTIQUES s
    WHERE s.idCommune = c.idCommune
      AND s.annee = 2021
      AND s.prixMoyen IS NOT NULL
)
ORDER BY c.nomCommune;

-- Resultat (5 lignes) :
-- +-----------+---------------------+
-- | idCommune | nomCommune          |
-- +-----------+---------------------+
-- | 29083     | ILE-DE-SEIN         |
-- | 29084     | ILE-MOLENE          |
-- | 35325     | LA SELLE-GUERCHAISE |
-- | 29100     | LANARVILY           |
-- | 29116     | LANNEUFFRET         |
-- +-----------+---------------------+


-- =====================================================================
--  Question 9 : 
-- =====================================================================
SELECT ROUND(AVG(prixM2Moyen), 2) AS prixM2MoyenGlobal
FROM STATISTIQUES;

-- Resultat :
-- +--------------------+
-- | prixM2MoyenGlobal  |
-- +--------------------+
-- |            1616.23 |
-- +--------------------+


-- =====================================================================
--  Question 10 : 
-- =====================================================================
SELECT MAX(tauxInflation) AS tauxInflationMax,
       MIN(tauxInflation) AS tauxInflationMin
FROM ANNEE;

-- Resultat :
-- +-------------------+-------------------+
-- | tauxInflationMax  | tauxInflationMin  |
-- +-------------------+-------------------+
-- |              5.20 |              0.00 |
-- +-------------------+-------------------+


-- =====================================================================
--  Question 11 :
-- =====================================================================
SELECT d.nomDep, COUNT(*) AS nbCommunes
FROM COMMUNE c
    JOIN DEPARTEMENT d ON c.idDep = d.idDep
GROUP BY d.nomDep
ORDER BY nbCommunes DESC;

-- Resultat (4 lignes) :
-- +------------------+------------+
-- | nomDep           | nbCommunes |
-- +------------------+------------+
-- | COTES-D'ARMOR    |        348 |
-- | ILLE-ET-VILAINE  |        333 |
-- | FINISTERE        |        277 |
-- | MORBIHAN         |        249 |
-- +------------------+------------+


-- =====================================================================
--  Question 12 : 
-- =====================================================================
SELECT annee, ROUND(AVG(prixM2Moyen), 2) AS prixM2MoyenAnnee
FROM STATISTIQUES
WHERE prixM2Moyen IS NOT NULL
GROUP BY annee
ORDER BY annee;

-- Resultat (4 lignes) :
-- +-------+-------------------+
-- | annee | prixM2MoyenAnnee  |
-- +-------+-------------------+
-- |  2018 |           1483.22 |
-- |  2019 |           1519.31 |
-- |  2020 |           1632.86 |
-- |  2021 |           1829.27 |
-- +-------+-------------------+


-- =====================================================================
--  Question 13 :
-- =====================================================================
SELECT d.nomDep, COUNT(*) AS nbCommunes
FROM COMMUNE c
    JOIN DEPARTEMENT d ON c.idDep = d.idDep
GROUP BY d.nomDep
HAVING COUNT(*) > 250
ORDER BY nbCommunes DESC;

-- Resultat (3 lignes) :
-- +------------------+------------+
-- | nomDep           | nbCommunes |
-- +------------------+------------+
-- | COTES-D'ARMOR    |        348 |
-- | ILLE-ET-VILAINE  |        333 |
-- | FINISTERE        |        277 |
-- +------------------+------------+


-- =====================================================================
--  Question 14 : 
-- =====================================================================
SELECT c.idCommune, c.nomCommune, COUNT(*) AS nbGares
FROM GARE g
    JOIN COMMUNE c ON g.idCommune = c.idCommune
GROUP BY c.idCommune, c.nomCommune
HAVING COUNT(*) >= 2
ORDER BY nbGares DESC;

-- Resultat (13 lignes) :
-- +-----------+-----------------------+---------+
-- | idCommune | nomCommune            | nbGares |
-- +-----------+-----------------------+---------+
-- | 56234     | SAINT-PIERRE-QUIBERON |       4 |
-- | 22233     | PLOURIVO              |       3 |
-- | 35238     | RENNES                |       3 |
-- | 22025     | CALLAC                |       2 |
-- | 22070     | GUINGAMP              |       2 |
-- | 22249     | PONT-MELVEZ           |       2 |
-- | 22250     | PONTRIEUX             |       2 |
-- | 22278     | SAINT-BRIEUC          |       2 |
-- | ...       | ...                   |     ... |
-- +-----------+-----------------------+---------+



-- =====================================================================
--  Question 15 :
-- =====================================================================
SELECT c.idCommune, c.nomCommune
FROM COMMUNE c
WHERE NOT EXISTS (
    SELECT 1
    FROM (SELECT 2019 AS annee UNION SELECT 2020 UNION SELECT 2021) a
    WHERE NOT EXISTS (
        SELECT 1 FROM STATISTIQUES s
        WHERE s.idCommune = c.idCommune
          AND s.annee = a.annee
          AND s.prixMoyen IS NOT NULL
    )
)
ORDER BY c.nomCommune;

-- +-----------+--------------------+
-- | idCommune | nomCommune         |
-- +-----------+--------------------+
-- | 35001     | ACIGNE             |
-- | 56001     | ALLAIRE            |
-- | 22001     | ALLINEUC           |
-- | 35002     | AMANLIS            |
-- | 56002     | AMBON              |
-- | 22002     | ANDEL              |
-- | 35003     | ANDOUILLE-NEUVILLE |
-- | 35005     | ARBRISSEL          |
-- | ...       | ...                |
-- +-----------+--------------------+


-- =====================================================================
--  Question 16 : 
-- =====================================================================
SELECT c.idCommune, c.nomCommune
FROM COMMUNE c
WHERE NOT EXISTS (
    SELECT 1
    FROM (SELECT 2019 AS annee UNION SELECT 2020 UNION SELECT 2021) a
    WHERE NOT EXISTS (
        SELECT 1 FROM STATISTIQUES s
        WHERE s.idCommune = c.idCommune
          AND s.annee = a.annee
          AND s.prixMoyen IS NOT NULL
    )
)
AND NOT EXISTS (
    SELECT 1 FROM STATISTIQUES s2
    WHERE s2.idCommune = c.idCommune
      AND s2.annee NOT IN (2019, 2020, 2021)
      AND s2.prixMoyen IS NOT NULL
)
ORDER BY c.nomCommune;

-- Resultat (4 lignes) :
-- +-----------+------------------------------+
-- | idCommune | nomCommune                    |
-- +-----------+------------------------------+
-- | 35192     | MONTREUIL-DES-LANDES          |
-- | 35261     | SAINT-CHRISTOPHE-DE-VALAINS   |
-- | 22373     | TREOGAN                       |
-- | 35357     | VILLAMEE                      |
-- +-----------+------------------------------+


-- =====================================================================
--  Question 17 : 
-- =====================================================================
CREATE OR REPLACE VIEW GaresIncoherentes AS
SELECT codeGare, nomGare, idCommune
FROM GARE
WHERE estFret = FALSE AND estVoyageurs = FALSE;

SELECT * FROM GaresIncoherentes;

-- Resultat :
-- +----------+---------+-----------+
-- | codeGare | nomGare | idCommune |
-- +----------+---------+-----------+
-- +----------+---------+-----------+


-- =====================================================================
--  Question 18 : 
-- =====================================================================
CREATE OR REPLACE VIEW VoisinagesInvalides AS
SELECT idCommune1, idCommune2
FROM VOISINAGE
WHERE idCommune1 >= idCommune2;

SELECT * FROM VoisinagesInvalides;

-- Resultat :
-- +------------+------------+
-- | idCommune1 | idCommune2 |
-- +------------+------------+
-- +------------+------------+



-- =====================================================================
--  Question 19 : 
-- =====================================================================
CREATE OR REPLACE VIEW BilanCommune AS
SELECT c.idCommune,
       c.nomCommune,
       (SELECT COUNT(*) FROM GARE g
          WHERE g.idCommune = c.idCommune)                    AS nbGares,
       (SELECT COUNT(*) FROM VOISINAGE v
          WHERE v.idCommune1 = c.idCommune
             OR v.idCommune2 = c.idCommune)                    AS nbVoisins,
       (SELECT s.population FROM STATISTIQUES s
          WHERE s.idCommune = c.idCommune AND s.annee = 2020)  AS populationEstimee
FROM COMMUNE c;

SELECT * FROM BilanCommune WHERE nomCommune = 'VANNES';

-- Resultat :
-- +-----------+------------+---------+-----------+-------------------+
-- | idCommune | nomCommune | nbGares | nbVoisins | populationEstimee |
-- +-----------+------------+---------+-----------+-------------------+
-- |     56260 | VANNES     |       1 |         7 |           55411.0 |
-- +-----------+------------+---------+-----------+-------------------+


-- =====================================================================
--  Question 20 : 
-- =====================================================================
CREATE OR REPLACE VIEW DepensesCulturellesParHabitant AS
SELECT idCommune,
       annee,
       depensesCulturellesTotales,
       population,
       ROUND((depensesCulturellesTotales * 1000) / population, 2)
            AS depensesCulturellesParHabitant
FROM STATISTIQUES
WHERE depensesCulturellesTotales IS NOT NULL
  AND population IS NOT NULL
  AND population > 0;

SELECT c.nomCommune, dc.annee, dc.depensesCulturellesParHabitant
FROM DepensesCulturellesParHabitant dc
    JOIN COMMUNE c ON c.idCommune = dc.idCommune
ORDER BY dc.depensesCulturellesParHabitant DESC
LIMIT 5;

-- Resultat (5 lignes) :
-- +---------------------+-------+----------------------------------+
-- | nomCommune          | annee | depensesCulturellesParHabitant    |
-- +---------------------+-------+----------------------------------+
-- | SERVON-SUR-VILAINE  |  2020 |                            503.79 |
-- | LANDEVANT           |  2020 |                            446.32 |
-- | SAINT-GREGOIRE      |  2020 |                            443.02 |
-- | MORLAIX             |  2020 |                            398.65 |
-- | SERVON-SUR-VILAINE  |  2019 |                            381.55 |
-- +---------------------+-------+----------------------------------+
