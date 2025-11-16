-- R2 - Version 2 : avec CTE pour plus de clarté
WITH pub_chercheur_2024 AS (
    SELECT 
        ch.id AS chercheur_id,
        ch.labo_id,
        COUNT(pub.id) AS nb_pub_2024
    FROM chercheur ch
    LEFT JOIN auteur_publication ap ON ap.chercheur_id = ch.id
    LEFT JOIN publication pub ON pub.id = ap.publication_id
    WHERE EXTRACT(YEAR FROM pub.date_pub) = 2024
    GROUP BY ch.id, ch.labo_id
),
moyenne_labo AS (
    SELECT labo_id, AVG(nb_pub_2024) AS moyenne_pub
    FROM pub_chercheur_2024
    GROUP BY labo_id
),
chercheurs_sous_moyenne AS (
    SELECT p24.chercheur_id
    FROM pub_chercheur_2024 p24
    JOIN moyenne_labo m ON p24.labo_id = m.labo_id
    WHERE p24.nb_pub_2024 < m.moyenne_pub
)
SELECT 
    p.title AS projet_titre,
    r.first_name || ' ' || r.last_name AS responsable
FROM projet p
JOIN chercheur r ON r.id = p.responsable_id
JOIN laboratoire l ON p.laboratoire_id = l.id
WHERE l.name = 'LISA'
  AND p.id NOT IN (
      SELECT pa.projet_id
      FROM participation pa
      JOIN chercheurs_sous_moyenne csm ON csm.chercheur_id = pa.chercheur_id
  );
