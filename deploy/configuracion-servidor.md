# Configuración del servidor Linux en Microsoft Azure

## 1. Información general

**Proyecto:** Sistema Web de Ventas e Inventario
**Plataforma:** Microsoft Azure
**Máquina virtual:** vm-sistema-ventas
**Sistema operativo:** Ubuntu Server 24.04.5 LTS
**Kernel:** 7.0.0-1017-azure
**IP pública:** 57.156.71.74

El servidor fue preparado para alojar una aplicación web desarrollada en Java y permitir su acceso desde Internet.

## 2. Tecnologías instaladas

| Tecnología | Versión o estado |
|---|---|
| OpenJDK | 17.0.20.1 |
| Apache Maven | 3.8.7 |
| Apache Tomcat 10 | Servicio activo |
| Nginx | Servicio activo |
| PostgreSQL | Servicio activo |
| Git | Utilizado para el control de versiones |

## 3. Acceso remoto

La administración del servidor se realiza mediante SSH, utilizando un usuario con permisos administrativos y autenticación mediante clave SSH.

Ejemplo de conexión:

```bash
ssh -i ~/.ssh/CLAVE_PRIVADA sysadmin@57.156.71.74
```

La clave privada debe permanecer en el equipo autorizado y nunca debe incluirse en GitHub.

## 4. Verificación del sistema operativo

```bash
lsb_release -ds
uname -r
```

Resultado verificado: Ubuntu 24.04.5 LTS.

## 5. Verificación de Java y Maven

```bash
java -version
mvn -version
```

Versiones verificadas:

- OpenJDK 17.0.20.1.
- Apache Maven 3.8.7.

## 6. Verificación de los servicios

Los siguientes comandos permiten consultar el estado de los servicios:

```bash
sudo systemctl status tomcat10
sudo systemctl status nginx
sudo systemctl status postgresql
```

En la verificación realizada, los tres servicios se encontraban activos.

## 7. Seguridad y firewall

El acceso remoto se realiza mediante SSH.

Se verificó el estado del firewall local con:

```bash
sudo ufw status
```

Resultado obtenido:

```text
Status: inactive
```

Por tanto, UFW no se encuentra activo en el servidor. Se deberá revisar la configuración de las reglas de seguridad de red de Azure y evaluar la habilitación segura del firewall local.

No se almacenan contraseñas, claves privadas ni credenciales de bases de datos en el repositorio.

## 8. Arquitectura del despliegue

El sistema utiliza la siguiente arquitectura:

**Cliente web → Nginx → Apache Tomcat → Aplicación Java → PostgreSQL**

Nginx actúa como proxy inverso para las solicitudes HTTP. Tomcat ejecuta la aplicación Java desplegada mediante un archivo WAR y PostgreSQL almacena la información del sistema.

## 9. Estado del proyecto

La aplicación se encuentra desplegada y accesible mediante la IP pública de la máquina virtual.

Dirección de acceso:

http://57.156.71.74/SistemaWebVentasInventario/login

Se verificó el funcionamiento del inicio de sesión, la interfaz principal y el módulo de productos con el frontend V2.

## 10. Conclusión

Se implementó un entorno Linux en Microsoft Azure capaz de ejecutar y publicar una aplicación web Java utilizando Tomcat, Nginx y PostgreSQL.

Las verificaciones realizadas confirman que los servicios principales se encuentran activos y que la aplicación puede utilizarse desde un navegador externo.
