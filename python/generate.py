from faker import Faker
import random
from datetime import timedelta, datetime

fake = Faker("fr_FR")

# configuration
N_INSTITUTIONS = 5
N_LABOS = 5
N_CHERCHEURS = 200
N_PROJETS = 8
N_CONTRATS = 120
N_DATASETS = 1200
N_PUBLICATIONS = 600

file = open("../data/data.sql", "w", encoding="utf-8")

def sql(s):
    file.write(s + ";\n")

# institutions
for _ in range(N_INSTITUTIONS):
    sql(f"""
    INSERT INTO institution(name, institution_type, address)
    VALUES ('{fake.company()}', '{random.choice(['Université','Organisme','Privé'])}', '{fake.address().replace("'", "''")}')
    """)

# laboratoires
for i in range(N_LABOS):
    sql(f"""
    INSERT INTO laboratoire(name, institution_id)
    VALUES ('Labo {fake.word().capitalize()}', {random.randint(1, N_INSTITUTIONS)})
    """)

# chercheurs
for i in range(N_CHERCHEURS):
    sql(f"""
    INSERT INTO chercheur(first_name,last_name,email,grade,labo_id)
    VALUES ('{fake.first_name()}','{fake.last_name()}','{fake.unique.email()}','{random.choice(['Doctorant','MaitreConf','Professeur'])}',{random.randint(1,N_LABOS)})
    """)

# projets
for _ in range(N_PROJETS):
    start = fake.date_between(start_date='-3y', end_date='-1y')
    sql(f"""
    INSERT INTO projet(title,description,date_start,date_end,budget,laboratoire_id,responsable_id,max_participants)
    VALUES ('Projet {fake.word().capitalize()}','{fake.text()}','{start}','{start + timedelta(days=365)}',{random.randint(20000,200000)}, {random.randint(1,N_LABOS)}, {random.randint(1,N_CHERCHEURS)}, 50)
    """)

# contrats
for _ in range(N_CONTRATS):
    sql(f"""
    INSERT INTO contrat(projet_id, financeur, intitule, montant, date_debut, date_fin, dmp_status)
    VALUES ({random.randint(1,N_PROJETS)}, '{fake.company()}','{fake.catch_phrase()}',{random.randint(10000,200000)},
    '{fake.date_between(start_date='-2y', end_date='-1y')}','{fake.date_between(start_date='-1y', end_date='today')}', '{random.choice(['brouillon','soum','valide'])}')
    """)

# datasets
for _ in range(N_DATASETS):
    sql(f"""
    INSERT INTO dataset(title,description,auteur_id,contrat_id,license_type,conditions_acces,date_depot,statut)
    VALUES ('Dataset {fake.word().capitalize()}','{fake.text()}',{random.randint(1,N_CHERCHEURS)},{random.randint(1,N_CONTRATS)},
    '{random.choice(['open','restricted','closed'])}','{fake.sentence()}','{fake.date_between(start_date='-1y', end_date='today')}',
    '{random.choice(['depose','brouillon','retire'])}')
    """)

# publications + auteurs
for pub_id in range(N_PUBLICATIONS):
    sql(f"""
    INSERT INTO publication(title,doi,size_kb,date_pub,link)
    VALUES ('{fake.sentence(3)}','{fake.uuid4()}',{random.randint(100,5000)},'{fake.date_between(start_date='-2y', end_date='today')}','{fake.url()}')
    """)
    # assign random authors
    for _ in range(random.randint(1,4)):
        sql(f"INSERT INTO auteur_publication(publication_id, chercheur_id) VALUES ({pub_id+1}, {random.randint(1,N_CHERCHEURS)})")

file.close()
print("✅ data.sql généré avec succès !")
