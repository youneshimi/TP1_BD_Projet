--On crée les rôles nécessaires pour la gestion de la base de données
DO
$$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'chercheur') THEN
        CREATE ROLE chercheur LOGIN PASSWORD 'chercheur@123';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'datamanager') THEN
        CREATE ROLE datamanager LOGIN PASSWORD 'datamanager@123';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin_bd') THEN
        CREATE ROLE admin_bd LOGIN PASSWORD 'admin@123';
    END IF;
END
$$;






