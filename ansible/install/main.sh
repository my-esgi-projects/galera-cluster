#!/bin/bash

install_dir=$(pwd)

echo "load config"
source $install_dir/config/config.env 

echo "install mariadb"
source $install_dir/mariadb/install.sh
