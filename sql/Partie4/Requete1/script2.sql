-- R1 - Version 2 : avec CTE pour plus de clarté et performance
WITH projets_valides AS (
    SELECT projet_id
    FROM participation
    GROUP BY projet_id
    HAVING COUNT(chercheur_id) > 5
)
SELECT 
    p.id AS projet_id,
    p.title AS projet_titre,
    EXTRACT(YEAR FROM d.date_depot) AS annee_depot,
    COUNT(d.id) AS nb_datasets,
    ROUND(AVG(d.date_depot - c.date_debut), 2) AS delai_moyen_jours
FROM dataset d
JOIN contrat c ON d.contrat_id = c.id
JOIN projet p ON p.id = c.projet_id
JOIN projets_valides pv ON pv.projet_id = p.id
WHERE d.date_depot >= '2018-01-01'
GROUP BY p.id, p.title, EXTRACT(YEAR FROM d.date_depot)
ORDER BY annee_depot DESC, nb_datasets DESC;
