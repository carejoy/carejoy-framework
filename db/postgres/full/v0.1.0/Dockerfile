# Version: 0.0.1

FROM clkao/postgres-plv8:9.6-1.5
MAINTAINER Karthik Muthukumaraswamy <karthik@breezeware.net>

# Set password for 'postgres' system (not DB) user
RUN echo 'postgres:secret' | chpasswd

# Setup Carejoy DB
ENV POSTGRES_USER carejoy_usr
ENV POSTGRES_PASSWORD carejoy123

# make temporary directory in Docker container for storing DB scripts
RUN mkdir -p /tmp/psql/
RUN mkdir -p /tmp/psql/dynamo
RUN mkdir -p /tmp/psql/carejoy
RUN mkdir -p /tmp/psql/cadence

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

# And add ``listen_addresses`` to postgresql.conf
RUN echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# Copy script files to Docker container entry point directory
COPY *.sh /docker-entrypoint-initdb.d/

# Copy SQL files to Docker container temporary directory
COPY dynamo/ /tmp/psql/dynamo/
COPY carejoy/ /tmp/psql/carejoy/
COPY fhirbase/ /tmp/psql/fhirbase/
COPY cadence/ /tmp/psql/cadence/

# Set Port Configurations
EXPOSE 5432

# Docker build & run commands
# docker build -t carejoy .
# docker run --name carejoy -p 5432:5432 -i -t carejoy