-- Script de migration pour ajouter theme et niveau à la table QCM et gérer les sessions d'examen
-- Exécutez ce script pour adapter votre base de données

-- Ajouter les colonnes theme et niveau à la table qcm
ALTER TABLE qcm 
ADD COLUMN theme VARCHAR(100),
ADD COLUMN niveau VARCHAR(10);

-- Ajouter colonne theme à la table examen
ALTER TABLE examen
ADD COLUMN theme VARCHAR(100);

-- Créer une table pour les sessions d'examen
CREATE TABLE IF NOT EXISTS session_examen (
    num_session SERIAL PRIMARY KEY,
    num_exam INT REFERENCES examen(num_exam),
    num_etudiant VARCHAR REFERENCES etudiant(num_etudiant),
    theme VARCHAR(100),
    date_session TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS',
    note INT
);

-- Créer une table pour stocker les réponses de l'étudiant à une session
CREATE TABLE IF NOT EXISTS reponse_session (
    num_reponse SERIAL PRIMARY KEY,
    num_session INT REFERENCES session_examen(num_session),
    num_quest INT REFERENCES qcm(num_quest),
    reponse_etudiant INT,
    est_correcte BOOLEAN
);

-- Notes :
-- - Les niveaux autorisés sont : L1, L2, L3, M1, M2
-- - Les thèmes peuvent être créés dynamiquement lors de la création du QCM
-- - Les colonnes theme et niveau peuvent être NULL si non spécifiées lors de la création
-- - Statuts de session : EN_COURS, TERMINEE, ABANDONNEE
-- - reponse_etudiant : 1, 2, 3 ou 4 (numéro de la réponse choisie)
