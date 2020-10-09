#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE carejoy;
    GRANT ALL PRIVILEGES ON DATABASE carejoy TO carejoy_usr;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE fhirbase;
    GRANT ALL PRIVILEGES ON DATABASE fhirbase TO carejoy_usr;
EOSQL


# populating fhirbase DB
psql -U carejoy_usr fhirbase < /tmp/psql/fhirbase/aa_fhirbase-1.4.0.0.sql

# populating Dynamo tables in Carejoy DB 
psql -U carejoy_usr carejoy < /tmp/psql/dynamo/dynamo_organization.sql
psql -U carejoy_usr carejoy < /tmp/psql/dynamo/dynamo_apps.sql
psql -U carejoy_usr carejoy < /tmp/psql/dynamo/dynamo_auth.sql
psql -U carejoy_usr carejoy < /tmp/psql/dynamo/dynamo_audit.sql
psql -U carejoy_usr carejoy < /tmp/psql/dynamo/dynamo_config.sql

# populating Cadence tables in Carejoy DB
psql -U carejoy_usr carejoy < /tmp/psql/cadence/cadence_domain.sql

# populating Carejoy tables in Carejoy DB 
psql -U carejoy_usr carejoy < /tmp/psql/carejoy/carejoy.sql
psql -U carejoy_usr carejoy < /tmp/psql/carejoy/fitbit.sql