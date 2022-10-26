FROM postgres
COPY init.sql /docker-entrypoint-initdb.d
COPY pg_hba.conf /usr/share/postgresql/
COPY init.sql /usr/share/postgresql/