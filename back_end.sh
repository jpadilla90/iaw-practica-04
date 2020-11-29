#!/bin/bash

# BACK_END
# Configuración del scritp
# Definimos la contraseña de root como variable
DB_ROOT_PASSWD=root
DB_USU_PASSWD=usuario
# ------------------------------------------------------------------------------ Instalación y configuración de MySQL ------------------------------------------------------------------------------ 

# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x
# Actualizamos y actualizamos la lista de paquetes
apt update  
apt upgrade -y
# Instalamos el sistema gestor de base de datos
apt install mysql-server -y

# Copiamos el archivo de configuración de MySQL copiando uno previamente ya modificado mysqld.cnf 
# mv mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Editamos el archivo de configuración de MySQL, modificando la línea (Loop/cualquiera)
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf 
# Reiniciamos el servicio
sudo /etc/init.d/mysql restart
# Clonamos el repositorio
cd /home/ubuntu
rm -rf iaw-practica-lamp 
git clone https://github.com/josejuansanchez/iaw-practica-lamp
# Actualizamos la contraseña de root de MySQL
mysql -u root  <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_ROOT_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

# Creamos usuario para la aplicación web y asignamos privilegios
# mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE USER 'lamp_user'@'%' IDENTIFIED BY '$DB_USU_PASSWD';"
# mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON 'lamp_db'.* TO 'lamp_user'@'%';"
# mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

# Introducimos la base de tados
mysql -u root -p$DB_ROOT_PASSWD < /home/ubuntu/iaw-practica-lamp/db/database.sql