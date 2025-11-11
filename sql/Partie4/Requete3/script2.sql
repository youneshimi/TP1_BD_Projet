SELECT l.*
FROM laboratoire l
LEFT JOIN chercheur c ON c.labo_id = l.id
LEFT JOIN dataset d
  ON d.chercheur_id = c.id
  AND (
    d.license_type IS NULL OR d.date_depot IS NULL
  )
  AND EXTRACT(YEAR FROM d.date_depot) = 2024
WHERE d.id IS NULL;
