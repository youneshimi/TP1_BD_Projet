--On crée les rôles nécessaires pour la gestion de la base de données
DO
$$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'chercheur') THEN
        CREATE ROLE chercheur LOGIN PASSWORD 'chercheur@123';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'datamanager') THEN
        CREATE ROLE datamanager LOGIN PASSWORD 'datamanager@123';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin_bd') THEN
        CREATE ROLE admin_bd LOGIN PASSWORD 'admin@123';
    END IF;
END
$$;

-- Vue des chercheurs et de leurs laboratoires

CREATE OR REPLACE VIEW vue_chercheurs_laboratoires AS
SELECT c.id AS chercheur_id, c.first_name, c.last_name, c.email,
       l.name AS laboratoire, i.name AS institution
FROM chercheur c
LEFT JOIN laboratoire l ON c.labo_id = l.id
LEFT JOIN institution i ON l.institution_id = i.id;


-- Vue des projets avec leur responsable et labo

CREATE OR REPLACE VIEW vue_projets_complets AS
SELECT p.id AS projet_id, p.title, p.discipline, p.budget,
       c.first_name || ' ' || c.last_name AS responsable,
       l.name AS laboratoire, i.name AS institution
FROM projet p
JOIN chercheur c ON p.responsable_id = c.id
JOIN laboratoire l ON p.laboratoire_id = l.id
JOIN institution i ON l.institution_id = i.id;



