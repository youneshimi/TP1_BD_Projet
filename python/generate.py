from faker import Faker
import random
from datetime import timedelta

fake = Faker("fr_FR")

# Configuration conforme au sujet
N_ADRESSES = 300
N_INSTITUTIONS = 5
N_LABOS = 5
N_CHERCHEURS = 200
N_PROJETS = 10   # Dont 8 à l'Université de Corse
N_CONTRATS = 100
N_DATASETS = 1000
N_PUBLICATIONS = 500

file = open("../data/data.sql", "w", encoding="utf-8")

def sql(q):
    file.write(q + ";\n")

# Nettoyage des textes
def clean(text, max_length=200):
    if not text:
        return ""
    text = text.replace("'", "''")
    text = text.replace("\n", " ").replace("\r", " ")
    return text[:max_length]


# ---- Adresses ----
for _ in range(N_ADRESSES):
    sql(f"""
    INSERT INTO adresse(ville, pays, boite_postale, nom_rue, numero_batiment)
    VALUES ('{clean(fake.city(),50)}', 'France', '{fake.postcode()}',
    '{clean(fake.street_name(),100)}', '{random.randint(1,200)}')
    """)

# ---- Institution #1 : Université de Corse ----
sql(f"""
INSERT INTO institution(name, institution_type, adresse_id)
VALUES ('Université de Corse Pasquale Paoli', 'Université', 1)
""")

# ---- Autres institutions ----
for _ in range(N_INSTITUTIONS - 1):
    sql(f"""
    INSERT INTO institution(name, institution_type, adresse_id)
    VALUES ('{clean(fake.company(),80)}', 
    '{random.choice(['Université','Organisme','Privé'])}',
    {random.randint(1, N_ADRESSES)})
    """)

# ---- Laboratoires ----
for _ in range(N_LABOS):
    sql(f"""
    INSERT INTO laboratoire(name, institution_id, adresse_id)
    VALUES ('Labo {clean(fake.word().capitalize(),50)}',
    {random.randint(1, N_INSTITUTIONS)},
    {random.randint(1, N_ADRESSES)})
    """)

# ---- Chercheurs ----
for _ in range(N_CHERCHEURS):
    is_active = True if random.random() > 0.3 else False
    sql(f"""
    INSERT INTO chercheur(first_name, last_name, date_of_birth, Nationality, gender, email, phone, grade, is_active, labo_id, adresse_id)
    VALUES ('{clean(fake.first_name(),50)}','{clean(fake.last_name(),50)}','{fake.date_of_birth(minimum_age=25, maximum_age=65)}',
    'Française','{random.choice(['M','F'])}','{fake.unique.email()}','{clean(fake.phone_number(),30)}',
    '{random.choice(['Doctorant','MaitreConf','Professeur'])}', {is_active},
    {random.randint(1, N_LABOS)}, {random.randint(1, N_ADRESSES)})
    """)

# ---- 8 Projets Université de Corse ----
for _ in range(8):
    start = fake.date_between(start_date='-3y', end_date='-1y')
    end = start + timedelta(days=random.randint(200, 800))
    sql(f"""
    INSERT INTO projet(title, description, discipline, date_start, date_end, budget, laboratoire_id, responsable_id)
    VALUES ('Projet Structurant {clean(fake.word().capitalize(),50)}', '{clean(fake.text(),200)}',
    '{random.choice(['IA','Physique','Biologie','Math','Chimie'])}',
    '{start}','{end}', {random.randint(50000,300000)},
    1, {random.randint(1, N_CHERCHEURS)})
    """)

# ---- Autres projets ----
for _ in range(N_PROJETS - 8):
    start = fake.date_between(start_date='-3y', end_date='-1y')
    end = start + timedelta(days=random.randint(200, 800))
    sql(f"""
    INSERT INTO projet(title, description, discipline, date_start, date_end, budget, laboratoire_id, responsable_id)
    VALUES ('Projet {clean(fake.word().capitalize(),50)}', '{clean(fake.text(),200)}',
    '{random.choice(['IA','Physique','Biologie','Math','Chimie'])}',
    '{start}','{end}', {random.randint(20000,200000)},
    {random.randint(1, N_LABOS)}, {random.randint(1, N_CHERCHEURS)})
    """)

# ---- Participation (sans doublons) ----
participations = set()

while len(participations) < N_CHERCHEURS * 2:
    projet = random.randint(1, N_PROJETS)
    chercheur = random.randint(1, N_CHERCHEURS)

    if (projet, chercheur) not in participations:
        participations.add((projet, chercheur))
        sql(f"""
        INSERT INTO participation(projet_id, chercheur_id)
        VALUES ({projet}, {chercheur})
        """)

# ---- Contrats ----
for _ in range(N_CONTRATS):
    sql(f"""
    INSERT INTO contrat(projet_id, contrat_type, financeur, intitule, montant, date_debut, date_fin, dmp_status)
    VALUES ({random.randint(1, N_PROJETS)}, '{random.choice(['ANR','H2020','Région'])}',
    '{clean(fake.company(),80)}', '{clean(fake.catch_phrase(),120)}',
    {random.randint(20000,200000)},
    '{fake.date_between(start_date='-2y', end_date='-1y')}',
    '{fake.date_between(start_date='-1y', end_date='today')}',
    '{random.choice(['brouillon','soum','valide'])}')
    """)

# ---- Datasets ----
for proj_id in range(1, N_PROJETS+1):
    sql(f"""
    INSERT INTO dataset(title, description, chercheur_id, contrat_id, license_type, conditions_acces, date_depot, statut)
    VALUES ('Dataset Projet {proj_id}', '{clean(fake.text(),200)}',
    {random.randint(1,N_CHERCHEURS)}, {random.randint(1,N_CONTRATS)},
    '{random.choice(['open','restricted','closed'])}',
    '{clean(fake.sentence(),120)}',
    '{fake.date_between(start_date='-1y', end_date='today')}',
    '{random.choice(['soumis','brouillon','validé'])}')
    """)

for _ in range(N_DATASETS - N_PROJETS):
    sql(f"""
    INSERT INTO dataset(title, description, chercheur_id, contrat_id, license_type, conditions_acces, date_depot, statut)
    VALUES ('Dataset {clean(fake.word(),50)}', '{clean(fake.text(),200)}',
    {random.randint(1,N_CHERCHEURS)}, {random.randint(1,N_CONTRATS)},
    '{random.choice(['open','restricted','closed'])}',
    '{clean(fake.sentence(),120)}',
    '{fake.date_between(start_date='-1y', end_date='today')}',
    '{random.choice(['soumis','brouillon','validé'])}')
    """)

# ---- Publications & auteurs ----
auteur_publication_set = set()

for pub_id in range(N_PUBLICATIONS):
    sql(f"""
    INSERT INTO publication(title, doi, size_kb, date_pub, link)
    VALUES ('{clean(fake.sentence(),120)}', '{fake.uuid4()}', {random.randint(100,5000)},
    '{fake.date_between(start_date='-2y', end_date='today')}', '{clean(fake.url(),150)}')
    """)

    # 1 à 4 auteurs sans duplications
    n_authors = random.randint(1, 4)
    authors_for_pub = set()

    while len(authors_for_pub) < n_authors:
        chercheur = random.randint(1, N_CHERCHEURS)

        if (pub_id+1, chercheur) not in auteur_publication_set:
            auteur_publication_set.add((pub_id+1, chercheur))
            authors_for_pub.add(chercheur)

            sql(f"""
            INSERT INTO auteur_publication(publication_id, chercheur_id)
            VALUES ({pub_id+1}, {chercheur})
            """)

file.close()
print("✅ Données générées avec succès")

# Fin du fichier generate.py