
#!/usr/bin/env bash
set -euo pipefail

# Sistema Web de Ventas e Inventario
# Instalacion de dependencias en Ubuntu 24.04 LTS
#
# Ejecutar en un servidor nuevo:
# sudo bash deploy/instalar-dependencias.sh
#
# No crea usuarios ni bases de datos.
# No configura contrasenas ni despliega la aplicacion.

if [[ $EUID -ne 0 ]]; then
    echo "Error: ejecuta este script con sudo."
    exit 1
fi

echo "Actualizando repositorios..."
apt-get update

echo "Instalando Java 17, Maven, Tomcat 10, Nginx y PostgreSQL..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-17-jdk \
    maven \
    tomcat10 \
    nginx \
    postgresql-16 \
    postgresql-client-16

echo "Habilitando servicios..."
systemctl enable tomcat10
systemctl enable nginx
systemctl enable postgresql

echo "Iniciando servicios..."
systemctl start tomcat10
systemctl start nginx
systemctl start postgresql

echo "Verificando instalaciones..."
java -version
mvn -version
psql --version

echo "Verificando servicios..."
systemctl is-active tomcat10
systemctl is-active nginx
systemctl is-active postgresql

echo "Instalacion de dependencias finalizada."
echo "Pendiente: configurar PostgreSQL, Nginx y desplegar el WAR."
