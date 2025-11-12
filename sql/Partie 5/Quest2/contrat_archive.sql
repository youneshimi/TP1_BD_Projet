-- Création de la table archive -- 
CREATE TABLE contrat_archive AS TABLE contrat WITH NO DATA;


-- Procédure -- 

CREATE OR REPLACE PROCEDURE archiver_contrats(p_date_seuil DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO contrat_archive
    SELECT * FROM contrat
    WHERE date_fin < p_date_seuil;

    DELETE FROM contrat
    WHERE date_fin < p_date_seuil;
END;
$$;


--Test-- 

CALL archiver_contrats('2025-01-01');
SELECT * FROM contrat_archive;


