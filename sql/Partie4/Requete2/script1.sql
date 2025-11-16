-- R2 - Version 1 : avec sous-requêtes imbriquées
SELECT 
    p.title AS projet_titre,
    ch_resp.first_name || ' ' || ch_resp.last_name AS responsable
FROM projet p
JOIN chercheur ch_resp ON ch_resp.id = p.responsable_id
JOIN laboratoire l ON p.laboratoire_id = l.id
WHERE l.name = 'LISA'
  AND NOT EXISTS (
      SELECT 1
      FROM participation pa
      JOIN chercheur ch ON ch.id = pa.chercheur_id
      WHERE pa.projet_id = p.id
        AND ch.labo_id = l.id
        AND (
            SELECT COUNT(ap.publication_id)
            FROM auteur_publication ap
            JOIN publication pub ON pub.id = ap.publication_id
            WHERE ap.chercheur_id = ch.id
              AND EXTRACT(YEAR FROM pub.date_pub) = 2024
        ) < (
            SELECT AVG(pub_count)
            FROM (
                SELECT COUNT(ap2.publication_id) AS pub_count
                FROM chercheur c2
                JOIN auteur_publication ap2 ON ap2.chercheur_id = c2.id
                JOIN publication pub2 ON pub2.id = ap2.publication_id
                WHERE c2.labo_id = l.id
                  AND EXTRACT(YEAR FROM pub2.date_pub) = 2024
                GROUP BY c2.id
            ) AS moy_lab
        )
  );
