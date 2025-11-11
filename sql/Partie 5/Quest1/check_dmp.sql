-- Fonction du trigger --


CREATE OR REPLACE FUNCTION check_dmp_before_dataset_validation()
RETURNS TRIGGER AS $$
DECLARE
    dmp_statut VARCHAR(20);
BEGIN
    -- Vérifier le DMP associé
    SELECT dmp_status INTO dmp_statut
    FROM contrat
    WHERE id = NEW.contrat_id;

    -- Si DMP non validé et statut du dataset = 'validé', bloquer
    IF NEW.statut = 'validé' AND dmp_statut <> 'valide' THEN
        RAISE EXCEPTION 'Impossible de valider le dataset : le contrat associé n’a pas un DMP validé.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Définition du trigger --

CREATE TRIGGER trg_check_dmp_before_validation
BEFORE INSERT OR UPDATE ON dataset
FOR EACH ROW
EXECUTE FUNCTION check_dmp_before_dataset_validation();


-- Test du trigger --

-- Créer un contrat non validé
INSERT INTO contrat (projet_id, dmp_status) VALUES (1, 'brouillon');

-- Dataset lié (devrait échouer)
INSERT INTO dataset (title, contrat_id, statut) VALUES ('Données Test', 1, 'validé'); 

-- Contrat validé
UPDATE contrat SET dmp_status = 'valide' WHERE id = 1;

-- Cette fois, le dataset passe
INSERT INTO dataset (title, contrat_id, statut) VALUES ('Données Valides', 1, 'validé');


