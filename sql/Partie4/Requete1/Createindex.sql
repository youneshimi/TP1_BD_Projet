-- Requête choisie : Version 2 (avec CTE) --

-- 1. Accélère les jointures entre contrat et projet
CREATE INDEX idx_contrat_projet_id ON contrat(projet_id);

-- 2. Accélère les jointures et les filtres par date sur dataset
CREATE INDEX idx_dataset_contrat_id_date ON dataset(contrat_id, date_depot);

-- 3. Accélère le calcul du nombre de chercheurs par projet
CREATE INDEX idx_participation_projet_id ON participation(projet_id);

-- 4. Index sur la colonne de filtrage temporel
CREATE INDEX idx_dataset_date_depot ON dataset(date_depot);
