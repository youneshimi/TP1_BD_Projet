-- Procédure — Archivage des contrats échus -- 

-- Afficher les publications et datasets associés à un projet. -- 

CREATE OR REPLACE FUNCTION fiche_projet(p_projet_id INT)
RETURNS TABLE(
    type_element TEXT,
    titre TEXT,
    annee INT,
    info TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        'Publication' AS type_element,
        pub.title::TEXT,
        EXTRACT(YEAR FROM pub.date_pub)::INT AS annee,
        pub.doi::TEXT AS info
    FROM publication pub
    JOIN auteur_publication ap ON ap.publication_id = pub.id
    JOIN participation pa ON pa.chercheur_id = ap.chercheur_id
    WHERE pa.projet_id = p_projet_id

    UNION ALL

    SELECT 
        'Dataset',
        d.title::TEXT,
        EXTRACT(YEAR FROM d.date_depot)::INT,
        d.statut::TEXT
    FROM dataset d
    JOIN contrat c ON c.id = d.contrat_id
    WHERE c.projet_id = p_projet_id;
END;
$$ LANGUAGE plpgsql;



-- Test -- 

SELECT * FROM fiche_projet(1);
