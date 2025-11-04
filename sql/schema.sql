-- =============================================
-- TP1 Projet - Création du Schéma
-- Base Recherche Scientifique
-- =============================================

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- Institution
CREATE TABLE institution (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    institution_type VARCHAR(50) CHECK (institution_type IN ('Université','Organisme','Privé')),
    address TEXT
);

-- Laboratoire
CREATE TABLE laboratoire (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    institution_id INT NOT NULL REFERENCES institution(id) ON DELETE CASCADE
);

-- Chercheur
CREATE TABLE chercheur (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    grade VARCHAR(50),
    labo_id INT REFERENCES laboratoire(id) ON DELETE SET NULL
);

-- Projet
CREATE TABLE projet (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date_start DATE,
    date_end DATE,
    budget NUMERIC,
    laboratoire_id INT REFERENCES laboratoire(id),
    responsable_id INT REFERENCES chercheur(id),
    max_participants INT DEFAULT 50
);

-- Participation chercheur ↔ projet
CREATE TABLE participation (
    projet_id INT REFERENCES projet(id) ON DELETE CASCADE,
    chercheur_id INT REFERENCES chercheur(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (projet_id, chercheur_id)
);

-- Contrat
CREATE TABLE contrat (
    id SERIAL PRIMARY KEY,
    projet_id INT REFERENCES projet(id) ON DELETE CASCADE,
    financeur VARCHAR(200),
    intitule TEXT,
    montant NUMERIC CHECK (montant >= 0),
    date_debut DATE,
    date_fin DATE,
    dmp_status VARCHAR(20) CHECK (dmp_status IN ('brouillon','soum','valide')),
    dmp_link TEXT
);

-- Dataset
CREATE TABLE dataset (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    auteur_id INT REFERENCES chercheur(id),
    contrat_id INT REFERENCES contrat(id),
    license_type VARCHAR(50) CHECK (license_type IN ('open','restricted','closed')),
    conditions_acces TEXT,
    date_depot DATE,
    statut VARCHAR(20) CHECK (statut IN ('depose','brouillon','retire'))
);

-- Publication
CREATE TABLE publication (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    doi VARCHAR(200),
    size_kb INT,
    date_pub DATE,
    link TEXT
);

-- Auteurs publication (N-N)
CREATE TABLE auteur_publication (
    publication_id INT REFERENCES publication(id) ON DELETE CASCADE,
    chercheur_id INT REFERENCES chercheur(id) ON DELETE CASCADE,
    PRIMARY KEY (publication_id, chercheur_id)
);

