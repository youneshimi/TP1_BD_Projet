-- ---------------------------------------------------------------
--  Vue 1 : Liste des informations liées aux projets d’un chercheur
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vue_projets_chercheur AS
SELECT 
    ch.id AS chercheur_id,
    ch.first_name || ' ' || ch.last_name AS chercheur_nom,
    p.id AS projet_id,
    p.title AS projet_titre,
    p.discipline,
    p.budget,
    p.date_start,
    p.date_end,
    l.name AS laboratoire,
    i.name AS institution
FROM chercheur ch
JOIN participation pa ON ch.id = pa.chercheur_id
JOIN projet p ON p.id = pa.projet_id
LEFT JOIN laboratoire l ON p.laboratoire_id = l.id
LEFT JOIN institution i ON l.institution_id = i.id;

-- ---------------------------------------------------------------
--  Vue 2 : Liste des publications et de leurs auteurs
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vue_publications_auteurs AS
SELECT 
    pub.id AS publication_id,
    pub.title AS publication_titre,
    pub.date_pub,
    pub.doi,
    c.first_name || ' ' || c.last_name AS auteur_nom,
    l.name AS laboratoire
FROM publication pub
JOIN auteur_publication ap ON pub.id = ap.publication_id
JOIN chercheur c ON ap.chercheur_id = c.id
LEFT JOIN laboratoire l ON c.labo_id = l.id;

-- ---------------------------------------------------------------
--  Vue 3 : Informations des contrats et datasets des chercheurs du même projet
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vue_contrats_datasets_chercheurs AS
SELECT 
    ch.first_name || ' ' || ch.last_name AS chercheur_nom,
    p.title AS projet_titre,
    c.id AS contrat_id,
    c.financeur,
    c.contrat_type,
    c.montant,
    d.id AS dataset_id,
    d.title AS dataset_titre,
    d.license_type,
    d.statut
FROM chercheur ch
JOIN projet p ON ch.labo_id = p.laboratoire_id
JOIN contrat c ON c.projet_id = p.id
JOIN dataset d ON d.contrat_id = c.id;

-- ---------------------------------------------------------------
--  Vue 4 : Informations complètes sur un chercheur
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vue_infos_chercheur AS
SELECT 
    ch.id AS chercheur_id,
    ch.first_name, ch.last_name, ch.email, ch.phone, ch.grade, ch.is_active,
    ch.date_of_birth, ch.Nationality, ch.gender,
    a.ville, a.pays, a.nom_rue, a.boite_postale,
    l.name AS laboratoire,
    i.name AS institution
FROM chercheur ch
LEFT JOIN adresse a ON ch.adresse_id = a.id
LEFT JOIN laboratoire l ON ch.labo_id = l.id
LEFT JOIN institution i ON l.institution_id = i.id;

-- ---------------------------------------------------------------
--  Vue 5 : Vue de supervision administrative (ADMIN)
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vue_supervision_admin AS
SELECT 
    p.title AS projet,
    COUNT(DISTINCT ch.id) AS nb_chercheurs,
    COUNT(DISTINCT d.id) AS nb_datasets,
    COUNT(DISTINCT pub.id) AS nb_publications,
    SUM(c.montant) AS total_budget
FROM projet p
LEFT JOIN participation pa ON pa.projet_id = p.id
LEFT JOIN chercheur ch ON ch.id = pa.chercheur_id
LEFT JOIN contrat c ON c.projet_id = p.id
LEFT JOIN dataset d ON d.contrat_id = c.id
LEFT JOIN publication pub ON pub.id IN (
    SELECT publication_id FROM auteur_publication ap 
    JOIN chercheur c2 ON ap.chercheur_id = c2.id 
    WHERE c2.labo_id = p.laboratoire_id
)
GROUP BY p.title;