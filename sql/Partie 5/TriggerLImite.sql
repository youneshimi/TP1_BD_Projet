-- Ajout de la capacité maximale à chaque projet
ALTER TABLE projet ADD COLUMN capacite_max INT DEFAULT 10;


-- Fonction du trigger -- 

CREATE OR REPLACE FUNCTION check_participation_limit()
RETURNS TRIGGER AS $$
DECLARE
    nb_participants INT;
    max_participants INT;
BEGIN
    -- Récupérer le nombre actuel de participants du projet
    SELECT COUNT(*) INTO nb_participants
    FROM participation
    WHERE projet_id = NEW.projet_id;

    -- Récupérer la capacité maximale du projet
    SELECT capacite_max INTO max_participants
    FROM projet
    WHERE id = NEW.projet_id;

    -- Vérification de la limite
    IF nb_participants >= max_participants THEN
        RAISE EXCEPTION 'Impossible d’ajouter un nouveau participant : capacité maximale de % atteinte pour le projet %.', 
            max_participants, NEW.projet_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- Définition du trigger -- 

CREATE TRIGGER trg_check_participation_limit
BEFORE INSERT ON participation
FOR EACH ROW
EXECUTE FUNCTION check_participation_limit();


-- Test du trigger -- 

-- Exemple de projet avec une capacité max
INSERT INTO projet (title, capacite_max) VALUES ('Projet IA', 2);

-- Deux chercheurs
INSERT INTO chercheur (first_name, last_name) VALUES ('Meldi', 'User');
INSERT INTO chercheur (first_name, last_name) VALUES ('Sara', 'Khalil');

-- Ajouter leurs participations (OK)
INSERT INTO participation VALUES (1, 1);
INSERT INTO participation VALUES (1, 2);

-- Tentative d’ajout d’un troisième chercheur (Erreur)
INSERT INTO chercheur (first_name, last_name) VALUES ('Younes', 'Shimi');
INSERT INTO participation VALUES (1, 3); -- Doit lever une exception
