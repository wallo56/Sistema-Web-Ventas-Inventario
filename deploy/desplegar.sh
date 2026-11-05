
#!/usr/bin/env bash
set -euo pipefail

# Sistema Web de Ventas e Inventario
# Script de compilacion y despliegue en Tomcat 10
# Ubuntu 24.04 LTS - Microsoft Azure
#
# Ejecutar desde la raiz del repositorio:
# bash deploy/desplegar.sh
#
# Requiere permisos sudo para instalar el WAR.
# Puede interrumpir temporalmente la aplicacion.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROYECTO_DIR="$REPO_DIR/SistemaWebVentasInventario"

WAR_ORIGEN="$PROYECTO_DIR/target/SistemaWebVentasInventario.war"
WAR_DESTINO="/var/lib/tomcat10/webapps/SistemaWebVentasInventario.war"
DIRECTORIO_DESPLEGADO="/var/lib/tomcat10/webapps/SistemaWebVentasInventario"

echo "Verificando proyecto Maven..."

if [[ ! -f "$PROYECTO_DIR/pom.xml" ]]; then
    echo "Error: no se encontro pom.xml."
    exit 1
fi

echo "Compilando aplicacion Java..."

cd "$PROYECTO_DIR"
mvn clean package

if [[ ! -f "$WAR_ORIGEN" ]]; then
    echo "Error: no se genero el archivo WAR."
    exit 1
fi

echo "Verificando Tomcat..."

if ! systemctl is-active --quiet tomcat10; then
    echo "Error: Tomcat 10 no esta activo."
    exit 1
fi

echo "Creando respaldo del WAR anterior..."

if [[ -f "$WAR_DESTINO" ]]; then
    sudo cp "$WAR_DESTINO" \
        "${WAR_DESTINO}.backup-$(date +%Y%m%d-%H%M%S)"
fi

echo "Deteniendo Tomcat..."
sudo systemctl stop tomcat10

echo "Eliminando despliegue anterior..."
sudo rm -rf -- "$DIRECTORIO_DESPLEGADO"

echo "Instalando nuevo WAR..."
sudo install -m 644 "$WAR_ORIGEN" "$WAR_DESTINO"

echo "Iniciando Tomcat..."
sudo systemctl start tomcat10

echo "Verificando servicio..."

if systemctl is-active --quiet tomcat10; then
    echo "Tomcat esta activo."
else
    echo "Error: Tomcat no inicio correctamente."
    exit 1
fi

echo "Despliegue finalizado."
echo "Verifica el funcionamiento de la aplicacion desde el navegador."
