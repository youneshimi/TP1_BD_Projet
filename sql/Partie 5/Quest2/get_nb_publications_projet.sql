-- Fonction — Nombre de publications d’un projet et d’une année ---

CREATE OR REPLACE FUNCTION get_nb_publications_projet(
    p_projet_id INT,
    p_annee INT
)
RETURNS INT AS $$
DECLARE
    nb_pub INT;
BEGIN
    SELECT COUNT(DISTINCT pub.id) INTO nb_pub
    FROM publication pub
    JOIN auteur_publication ap ON ap.publication_id = pub.id
    JOIN participation pa ON pa.chercheur_id = ap.chercheur_id
    WHERE pa.projet_id = p_projet_id
      AND EXTRACT(YEAR FROM pub.date_pub) = p_annee;

    RETURN nb_pub;
END;
$$ LANGUAGE plpgsql;



