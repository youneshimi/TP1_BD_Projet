-- ===============================================================
-- PRIVILÈGES GÉNÉRAUX
-- ===============================================================
GRANT CONNECT ON DATABASE postgres TO chercheur, datamanager, admin_bd;
GRANT USAGE ON SCHEMA public TO chercheur, datamanager, admin_bd;

-- ===============================================================
-- 1- RÔLE : CHERCHEUR 
-- ===============================================================
-- ➤ Accès restreint à ses projets, publications et informations personnelles
-- ➤ Lecture seule, aucun droit de modification

GRANT SELECT ON vue_projets_chercheur TO chercheur;
GRANT SELECT ON vue_publications_auteurs TO chercheur;
GRANT SELECT ON vue_infos_chercheur TO chercheur;

-- Empêcher toute modification
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM chercheur;

COMMENT ON ROLE chercheur IS
'Rôle destiné aux chercheurs : accès limité en lecture à leurs projets, publications et informations personnelles.';

-- ===============================================================
-- 2- RÔLE : DATA MANAGER
-- ===============================================================
-- ➤ Accès élargi aux métadonnées : contrats, datasets, projets, supervision
-- ➤ Lecture seule, pas d’écriture dans les tables

GRANT SELECT ON vue_projets_chercheur TO datamanager;
GRANT SELECT ON vue_publications_auteurs TO datamanager;
GRANT SELECT ON vue_contrats_datasets_chercheurs TO datamanager;
GRANT SELECT ON vue_infos_chercheur TO datamanager;
GRANT SELECT ON vue_supervision_admin TO datamanager;

REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM datamanager;

COMMENT ON ROLE datamanager IS
'Rôle Data Manager : accès étendu en lecture à toutes les métadonnées (projets, contrats, datasets, supervision).';

-- ===============================================================
-- 3- RÔLE : ADMINISTRATEUR 
-- ===============================================================
-- ➤ Accès complet : gestion totale de la base, des vues et des séquences

GRANT ALL PRIVILEGES ON DATABASE postgres TO admin_bd;
GRANT ALL PRIVILEGES ON SCHEMA public TO admin_bd;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_bd;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_bd;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_bd;

-- Garantir les privilèges sur les objets créés à l’avenir
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO admin_bd;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO admin_bd;

COMMENT ON ROLE admin_bd IS
'Administrateur complet de la base : création, suppression et gestion des données, utilisateurs et vues.';

-- ===============================================================
-- 4- VÉRIFICATION DES PRIVILÈGES (facultatif pour le rapport)
-- ===============================================================
SELECT grantee, privilege_type, table_name
FROM information_schema.role_table_grants
WHERE grantee IN ('chercheur','datamanager','admin_bd')
ORDER BY grantee, table_name;