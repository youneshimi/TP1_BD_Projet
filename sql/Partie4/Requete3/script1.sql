SELECT l.*
FROM laboratoire l
WHERE NOT EXISTS (
  SELECT 1
  FROM chercheur c
  JOIN dataset d ON d.chercheur_id = c.id
  WHERE c.labo_id = l.id
    AND (
      d.license_type IS NULL OR d.date_depot IS NULL
    )
    AND EXTRACT(YEAR FROM d.date_depot) = 2024
);
