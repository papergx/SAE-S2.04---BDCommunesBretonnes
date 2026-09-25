-- =====================================================================
--  SAE S2.04 - BDCommunesBretonnes
--  Script de creation de la base de donnees (MySQL)
--  Auteur : Kevin Boeffard - BUT Informatique - groupe C1
-- =====================================================================


-- =====================================================================
--  1) SCHEMA RELATIONNEL
--
--
--  DEPARTEMENT ( _idDep_, nomDep, investissementCulturel2019 )
--
--  AEROPORT ( _nom_, adresse, idDep# )
--      idDep# references DEPARTEMENT.idDep
--
--  COMMUNE ( _idCommune_, nomCommune, idDep# )
--      idDep# references DEPARTEMENT.idDep
--
--  GARE ( _codeGare_, nomGare, estFret, estVoyageurs, idCommune# )
--      idCommune# references COMMUNE.idCommune
--
--  ANNEE ( _annee_, tauxInflation )
--
--  STATISTIQUES ( _idCommune#_, _annee#_, nbMaisons,
--                  nbAppart, prixMoyen, prixM2Moyen, surfaceMoy,
--                  depensesCulturellesTotales, budgetTotal, population )
--      idCommune# references COMMUNE.idCommune
--      annee#     references ANNEE.annee
--      (cle primaire composee de idCommune + annee)
--
--  VOISINAGE ( _idCommune1#_, _idCommune2#_ )
--      idCommune1# references COMMUNE.idCommune
--      idCommune2# references COMMUNE.idCommune
--      (cle primaire composee de idCommune1 + idCommune2)
--
--
--  CONTRAINTES TEXTUELLES :
--
--  C1 - Une commune appartient obligatoirement a l'un des 4
--       departements bretons : idDep IN (22, 29, 35, 56).
--
--  C2 - Une gare doit assurer au moins un type de trafic : on ne peut
--       pas avoir estFret = FAUX et estVoyageurs = FAUX en meme temps
--       (estFret = VRAI OU estVoyageurs = VRAI).
--
--
--  C3 - Dans STATISTIQUES, l'annee doit correspondre a une periode ou
--       des donnees immobilieres/culturelles sont disponibles
--       (annee >= 2018).
--
--  C4 - Les attributs numeriques (population, surfaces, prix,
--       budgets, depenses...) doivent etre positifs ou nuls.
-- =====================================================================


-- =====================================================================
--  2) SCRIPT DE CREATION DE LA BASE
-- =====================================================================

DROP DATABASE IF EXISTS BDCommunesBretonnes;
CREATE DATABASE BDCommunesBretonnes
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE BDCommunesBretonnes;

-- ---------------------------------------------------------------------
--  Table DEPARTEMENT
-- ---------------------------------------------------------------------
CREATE TABLE DEPARTEMENT (
    idDep                         INT          NOT NULL,
    nomDep                        VARCHAR(50)  NOT NULL,
    investissementCulturel2019    INT          NULL,

    CONSTRAINT pk_departement PRIMARY KEY (idDep),
    CONSTRAINT chk_dep_breton CHECK (idDep IN (22, 29, 35, 56)),
    CONSTRAINT chk_dep_invest CHECK (investissementCulturel2019 IS NULL
                                      OR investissementCulturel2019 >= 0)
);

-- ---------------------------------------------------------------------
--  Table AEROPORT
-- ---------------------------------------------------------------------
CREATE TABLE AEROPORT (
    nom     VARCHAR(100)    NOT NULL,
    adresse         VARCHAR(150)    NULL,
    idDep           INT             NOT NULL,

    CONSTRAINT pk_aeroport PRIMARY KEY (nom),
    CONSTRAINT fk_aeroport_dep FOREIGN KEY (idDep)
        REFERENCES DEPARTEMENT (idDep)
);

-- ---------------------------------------------------------------------
--  Table COMMUNE
-- ---------------------------------------------------------------------
CREATE TABLE COMMUNE (
    idCommune       INT             NOT NULL,
    nomCommune      VARCHAR(100)    NOT NULL,
    idDep           INT             NOT NULL,

    CONSTRAINT pk_commune PRIMARY KEY (idCommune),
    CONSTRAINT fk_commune_dep FOREIGN KEY (idDep)
        REFERENCES DEPARTEMENT (idDep)
);

-- ---------------------------------------------------------------------
--  Table GARE
-- ---------------------------------------------------------------------
CREATE TABLE GARE (
    codeGare        INT             NOT NULL,
    nomGare         VARCHAR(100)    NOT NULL,
    estFret         BOOLEAN         NOT NULL DEFAULT FALSE,
    estVoyageurs    BOOLEAN         NOT NULL DEFAULT FALSE,
    idCommune       INT             NOT NULL,

    CONSTRAINT pk_gare PRIMARY KEY (codeGare),
    CONSTRAINT chk_gare_type CHECK (estFret = TRUE OR estVoyageurs = TRUE),
    CONSTRAINT fk_gare_commune FOREIGN KEY (idCommune)
        REFERENCES COMMUNE (idCommune)
);

-- ---------------------------------------------------------------------
--  Table ANNEE
-- ---------------------------------------------------------------------
CREATE TABLE ANNEE (
    annee           INT             NOT NULL,
    tauxInflation   FLOAT    NULL,

    CONSTRAINT pk_annee PRIMARY KEY (annee)
);

-- ---------------------------------------------------------------------
--  Table STATISTIQUES
-- ---------------------------------------------------------------------
CREATE TABLE STATISTIQUES (
    idCommune                       INT             NOT NULL,
    annee                           INT             NOT NULL,
    nbMaisons                INT             NULL,
    nbAppart                 INT             NULL,
    prixMoyen                       FLOAT   NULL,
    prixM2Moyen                     FLOAT   NULL,
    surfaceMoy                      FLOAT    NULL,
    depensesCulturellesTotales      FLOAT   NULL,  
    budgetTotal                     FLOAT   NULL,  
    population                      FLOAT   NULL,

    CONSTRAINT pk_statistiques PRIMARY KEY (idCommune, annee),
    CONSTRAINT chk_stat_annee CHECK (annee >= 2018),
    CONSTRAINT fk_stat_commune FOREIGN KEY (idCommune)
        REFERENCES COMMUNE (idCommune),
    CONSTRAINT fk_stat_annee FOREIGN KEY (annee)
        REFERENCES ANNEE (annee)
);

-- ---------------------------------------------------------------------
--  Table VOISINAGE
-- ---------------------------------------------------------------------
CREATE TABLE VOISINAGE (
    idCommune1      INT     NOT NULL,
    idCommune2      INT     NOT NULL,

    CONSTRAINT pk_voisinage PRIMARY KEY (idCommune1, idCommune2),
    CONSTRAINT chk_voisinage_ordre CHECK (idCommune1 < idCommune2),
    CONSTRAINT fk_voisinage_c1 FOREIGN KEY (idCommune1)
        REFERENCES COMMUNE (idCommune),
    CONSTRAINT fk_voisinage_c2 FOREIGN KEY (idCommune2)
        REFERENCES COMMUNE (idCommune)
);
