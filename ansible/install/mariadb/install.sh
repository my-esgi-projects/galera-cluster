#!/bin/bash

## get the current directory
mariadb_install_dir=$(pwd)


echo "Installing  mariadb ..."
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

apt-get install -y software-properties-common dirmngr gnupg2
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
apt-get -y update

export DEBIAN_FRONTEND="noninteractive"
sudo su -c "debconf-set-selections <<< 'mariadb-server-$MARIADB_VERSION mysql-server/root_password password ${MYSQL_ROOT_PASS}"
sudo su -c "debconf-set-selections <<< 'mariadb-server-$MARIADB_VERSION mysql-server/root_password_again password ${MYSQL_ROOT_PASS}'"
apt-get install -y mariadb-client-$MARIADB_VERSION mariadb-server-$MARIADB_VERSION

echo "set default auth method.."
cat > $mariadb_install_dir/set_auth_method.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD("${MYSQL_ROOT_PASS}");
FLUSH PRIVILEGES;
EOF


mysql -u root -p${MYSQL_ROOT_PASS} < $mariadb_install_dir/set_auth_method.sql

echo "Creating database creating."

cat <<EOF | tee $mariadb_install_dir/setup_db.sql
CREATE DATABASE $FIRST_DATABASE_NAME;
GRANT ALL ON ${FIRST_DATABASE_NAME}.* TO '$PDNS_USER'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASS';
GRANT ALL ON ${FIRST_DATABASE_NAME}.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASS';
FLUSH PRIVILEGES;
EOF

#mysql -u root -p${MYSQL_PASSWORD} < $mariadb_install_dir/setup_db.sql






