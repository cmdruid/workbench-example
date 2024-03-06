#!/bin/bash

DATABASE=db_name
USER=db_admin
PASSWORD=db_pass
PGDATA="$DATA/pg"

# Set the path for postgres binaries.
BIN="/usr/lib/postgresql/13/bin"

# Ensure that proper binary exists.
if [ ! -f "$BIN/initdb" ] || [ ! -f "$BIN/pg_ctl" ]; then
  echo "Unable to find postgres binaries!" && exit 1
fi

# Ensure that data directory exists for pg.
if [ ! -d "$PGDATA" ]; then
  mkdir -p $PGDATA
  chown -R postgres:postgres $PGDATA
fi

# Move into data directory.
cd $DATA/pg

# Ensure that database is initialized.
if [ ! -f "$PGDATA/PG_VERSION" ]; then
  sudo -u postgres rm -r $PGDATA/*
  sudo -u postgres $BIN/initdb -D $PGDATA
fi

# Check and modify pg_hba.conf
if ! grep -q "host all all 0.0.0.0/0 trust" "$PGDATA/pg_hba.conf"; then
    echo "Updating pg_hba.conf ..."
    echo "host all all 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
fi

# Check and modify postgresql.conf
if ! grep -q "^listen_addresses = '\*'" "$PGDATA/postgresql.conf"; then
    echo "Updating postgresql.conf ..."

    # Comment out the existing listen_addresses line
    sed -i "/^listen_addresses/s/^/# /" "$PGDATA/postgresql.conf"

    # Add the desired listen_addresses configuration
    echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"
fi

# Start the database.
sudo -u postgres $BIN/pg_ctl -D $PGDATA -l logfile start

# Switch to postgres user and set up database
DB_EXISTS=$(sudo -u postgres psql -t -c "SELECT 1 FROM pg_database WHERE datname='$DATABASE'" | grep -q 1 && echo "yes" || echo "no")
USER_EXISTS=$(sudo -u postgres psql -t -c "SELECT 1 FROM pg_roles WHERE rolname='$USER'" | grep -q 1 && echo "yes" || echo "no")

if [ $USER_EXISTS = 'no' ]; then
  sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD '$PASSWORD' CREATEDB;"
  echo "User $USER created."
fi

if [ $DB_EXISTS = 'no' ]; then
  sudo -u postgres createdb -O $USER $DATABASE
  echo "Database $DATABASE created."
fi
