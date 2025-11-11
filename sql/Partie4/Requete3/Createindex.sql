-- Requête choisie : Version 2 (avec LEFT JOIN) --

-- 1. Accélère la jointure entre chercheur et labo
CREATE INDEX idx_chercheur_labo_id ON chercheur(labo_id);

-- 2. Accélère la jointure et le filtre sur dataset
CREATE INDEX idx_dataset_chercheur_id ON dataset(chercheur_id);

-- 3. Accélère la recherche des datasets non conformes par année
CREATE INDEX idx_dataset_date_depot_license ON dataset(date_depot, license_type);
