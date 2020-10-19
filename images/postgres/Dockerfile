FROM postgres:12

# Create the needed temp file before the first postgreSQL execution
# Create group and user

RUN useradd  -u5432 -U  non-root-postgres

# Set user rights to allow the on-root-postgres-user 
# to access the temp folder
RUN mkdir /pgdata && chown non-root-postgres.non-root-postgres /pgdata

RUN chmod 777 /pgdata

ARG pgdata_home=/pgdata
ENV PGDATA=$pgdata_home


# Change to non-root privilege
USER non-root-postgres

