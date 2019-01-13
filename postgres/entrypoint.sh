#!/bin/bash

if [ "$1" = 'run-postgres' ]; then

	# Set directory permissions	
	chmod 755 "$PGDATA"
	chown -R postgres "$PGDATA"
	chown -R postgres /run/postgresql
	
	# Create postgres database cluster
	gosu postgres initdb "$PGDATA"

	# Start the server as postgres
	gosu postgres pg_ctl -D /var/lib/postgresql/data start

	# Create metastore database
	psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
		CREATE DATABASE "metastore" ;
	EOSQL

	# Make postgres user a superuser
	psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
		ALTER USER "$POSTGRES_USER" WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD' ;
	EOSQL

	# Shut down the server now that setup is complete
	gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

	# Add configuration files
	cp /pg_hba.conf "$PGDATA" 

        # Inform the user that startup is complete
        echo
        echo "================================================="
        echo "============ Postgres Setup Complete ============"
        echo "================================================="
        echo

	# start the postgres server as the postgres user
	exec gosu postgres postgres

fi

