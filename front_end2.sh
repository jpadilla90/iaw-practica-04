#!/bin/bash
###
###Script para máquina### FRONT_END
###
# Ruta donde guardamos el archivo .htpasswd, variables.
HTTPASSWD_DIR=/home/ubuntu
HTTPASSWD_USER=usuario
HTTPASSWD_PASSWD=usuario

### IP del Servidor MySQL. ¡Hay que ajustarla cada vez que se cambia el servidor!
IP_PRIVADA=
### Contraseña aleatoria para el parámetro blowfish_secret de nuestro config.inc.php
BLOWFISH=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 64`
# ------------------------------------------------------------------------------ Instalación de Apache ------------------------------------------------------------------------------ 
# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x
# Actualizamos la lista de paquetes
apt update
apt upgrade -y
# Instalamos el servidor web Apache
apt install apache2 -y
# Instalamos los módulos necesarios de PHP
apt install php libapache2-mod-php php-mysql php-mbstring -y

# ------------------------------------------------------------------------------ Instalación aplicación web ------------------------------------------------------------------------------ 
# Clonamos el repositorio de la aplicación
cd /var/www/html 
rm -rf iaw-practica-lamp 
git clone https://github.com/josejuansanchez/iaw-practica-lamp

# Movemos el contenido del repositorio al home de html
mv /var/www/html/iaw-practica-lamp/src/*  /var/www/html/

# Configuramos el archivo php de la aplicacion. En https://linuxhint.com/bash_sed_examples/ podemos leer sobre las especificaciones del comando sed y el operador -i, que reemplazarán la línea. Ojo a las comillas, tienen que ser dobles.
sed -i "s/localhost/$IP_PRIVADA/" /var/www/html/config.php
sed -i "s/localhost/$IP_PRIVADA/" /var/www/html/config.php

# Eliminamos el archivo Index.html de apache
rm -rf /var/www/html/index.html
rm -rf /var/www/html/iaw-practica-lamp/

# Cambiamos permisos 
chown www-data:www-data * -R

# ------------------------------------------------------------------------------ Instalación de herramientas adicionales --------------------------------------------------------------------
# Descargamos Adminer
mkdir /var/www/html/adminer 
cd /var/www/html/adminer 
wget https://github.com/vrana/adminer/releases/download/v4.7.7/adminer-4.7.7-mysql.php 
mv adminer-4.7.7-mysql.php index.php

# Instalación de GoAccess
echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/goaccess.list 
wget -O - https://deb.goaccess.io/gnugpg.key | sudo apt-key add - 
apt-get update 
apt-get install goaccess -y

# Creamos el directorio stats.
mkdir /var/www/html/stats

# Lanzamos el proceso en segundo plano
nohup goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html &
htpasswd -c -b $HTTPASSWD_DIR/.htpasswd $HTTPASSWD_USER $HTTPASSWD_PASSWD

# Instalamos phpMyAdmin #
# Nos situamos en el directorio de usuario
cd $HTTPASSWD_DIR

# Nos aseguramos que no existe ya el directorio phpMyAdmin-5.0.4-all-languages.zip
rm -rf phpMyAdmin-5.0.4-all-languages.zip

# Descargamos el paquete phpMyAdmin 
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip

# Instalamos unzip
apt install unzip -y

# Descomprimimos phpMyAdmin-5.0.4-all-languages.zip
unzip phpMyAdmin-5.0.4-all-languages.zip

# Borramos el archivo zip
rm -rf phpMyAdmin-5.0.4-all-languages.zip

# Movemos el directorio de phpMyAdmin al directorio /var/www/html
mv phpMyAdmin-5.0.4-all-languages/ /var/www/html/phpmyadmin
# Configuramos el archivo config.inc.php de phpMyAdmin 
# Nos situamos en el directorio /var/www/html/phpmyadmin
cd /var/www/html/phpmyadmin
# Cambiamos el nombre del archivo. 
mv config.sample.inc.php config.inc.php
sed -i "s/localhost/$IP_PRIVADA/" /var/www/html/phpmyadmin/config.inc.php
sed -i "s/'blowfish_secret'] = '';/'blowfish_secret'] = '$BLOWFISH';/" /var/www/html/phpmyadmin/config.inc.php
# Cambiamos permisos de /var/www/html
cd /var/www/html
chown www-data:www-data * -R

# Copiamos el archivo de configuracion de apache
cp /home/ubuntu/000-default.conf /etc/apache2/sites-available/
systemctl restart apache2

# Haremos comprobaciones de conectividad con Telnet (:23)
# Si queremos hacer comprobaciones de conexión interna de MySQL(:3305), usaremos el siguiente comando para hacer consultas desde el cliente, pero en principio no es necesario instalarlo.
# apt install mysql-client-core-8.0