-- Requête choisie : Version 2 (avec CTE) --

-- 1. Accélère les jointures entre chercheur et labo
CREATE INDEX idx_chercheur_labo_id ON chercheur(labo_id);

-- 2. Accélère la jointure entre publication et auteur_publication
CREATE INDEX idx_auteur_pub_chercheur_id ON auteur_publication(chercheur_id);
CREATE INDEX idx_auteur_pub_publication_id ON auteur_publication(publication_id);

-- 3. Accélère le filtre temporel sur publication.date_pub
CREATE INDEX idx_publication_date_pub ON publication(date_pub);

-- 4. Accélère la jointure entre projet et laboratoire
CREATE INDEX idx_projet_laboratoire_id ON projet(laboratoire_id);

-- 5. Accélère la recherche du labo "LISA"
CREATE INDEX idx_laboratoire_name ON laboratoire(name);
