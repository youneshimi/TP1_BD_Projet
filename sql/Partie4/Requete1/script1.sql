-- R1 - Version 1 : via contrat pour atteindre le projet
SELECT 
    p.id AS projet_id,
    p.title AS projet_titre,
    EXTRACT(YEAR FROM d.date_depot) AS annee_depot,
    COUNT(d.id) AS nb_datasets,
    ROUND(AVG(d.date_depot - c.date_debut), 2) AS delai_moyen_jours
FROM projet p
JOIN contrat c ON c.projet_id = p.id
JOIN dataset d ON d.contrat_id = c.id
WHERE p.id IN (
    SELECT projet_id
    FROM participation
    GROUP BY projet_id
    HAVING COUNT(chercheur_id) > 5
)
AND d.date_depot >= '2018-01-01'
GROUP BY p.id, p.title, EXTRACT(YEAR FROM d.date_depot)
ORDER BY annee_depot DESC, nb_datasets DESC;
