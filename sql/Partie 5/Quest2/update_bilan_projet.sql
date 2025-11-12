-- Création de la table de bilan -- 
CREATE TABLE bilan_projet (
    projet_id INT,
    annee INT,
    nb_publications INT,
    nb_datasets INT,
    PRIMARY KEY (projet_id, annee)
);


-- Procédure --

CREATE OR REPLACE PROCEDURE update_bilan_projet(p_annee INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM bilan_projet WHERE annee = p_annee;

    INSERT INTO bilan_projet (projet_id, annee, nb_publications, nb_datasets)
    SELECT 
        p.id,
        p_annee,
        COALESCE(
            (SELECT COUNT(DISTINCT pub.id)
             FROM publication pub
             JOIN auteur_publication ap ON ap.publication_id = pub.id
             JOIN participation pa ON pa.chercheur_id = ap.chercheur_id
             WHERE pa.projet_id = p.id
             AND EXTRACT(YEAR FROM pub.date_pub) = p_annee), 0),
        COALESCE(
            (SELECT COUNT(d.id)
             FROM contrat c
             JOIN dataset d ON d.contrat_id = c.id
             WHERE c.projet_id = p.id
             AND EXTRACT(YEAR FROM d.date_depot) = p_annee), 0)
    FROM projet p;
END;
$$;



-- Test -- 

CALL update_bilan_projet(2024);
SELECT * FROM bilan_projet;
