# Configuración y despliegue del VPS Linux

## Proyecto
Sistema Web de Ventas e Inventario

Proyecto Integrador de Sistemas Operativos.

## Objetivo
Configurar un servidor Linux en Microsoft Azure para alojar y publicar una aplicación web desarrollada en Java, permitiendo su acceso desde Internet mediante una dirección IP pública.

## Infraestructura utilizada
- Plataforma: Microsoft Azure.
- Máquina virtual: vm-sistema-ventas.
- Sistema operativo: Ubuntu Server 24.04 LTS.
- Servidor de aplicaciones: Apache Tomcat 10.
- Servidor web y proxy inverso: Nginx.
- Lenguaje y entorno: Java 17 y Maven.
- Base de datos: PostgreSQL 16.
- Control de versiones: Git y GitHub.
- Acceso remoto: SSH.

## Arquitectura del sistema
Navegador web -> Nginx -> Apache Tomcat -> Aplicación Java -> PostgreSQL.

Nginx recibe las solicitudes HTTP y las redirige a Tomcat, donde se ejecuta la aplicación Java. La aplicación se comunica con PostgreSQL para gestionar los datos del sistema.

## Actividades realizadas
1. Creación y configuración de una máquina virtual Ubuntu Server en Azure.
2. Configuración del acceso remoto mediante SSH.
3. Administración del usuario del servidor y permisos.
4. Preparación del entorno Linux para ejecutar la aplicación.
5. Instalación de Java 17 y Maven.
6. Instalación y configuración de Apache Tomcat 10.
7. Instalación y configuración de Nginx como proxy inverso.
8. Instalación y configuración de PostgreSQL 16.
9. Obtención del proyecto desde GitHub.
10. Compilación del proyecto Java mediante Maven.
11. Generación y despliegue del archivo WAR en Tomcat.
12. Publicación del sistema mediante la IP pública de Azure.
13. Verificación del inicio de sesión y las funciones principales.
14. Integración y despliegue del frontend V2.

## Acceso al sistema
http://57.156.71.74/SistemaWebVentasInventario/login

## Estado actual
Servidor configurado y aplicación web desplegada correctamente en Azure.

El sistema permite acceder al inicio de sesión, dashboard y módulo de productos. Se verificó el funcionamiento del frontend V2 y su integración con el backend.

## Seguridad
Las contraseñas, claves SSH privadas y credenciales de PostgreSQL no se almacenan en este repositorio.

## Documentación
La configuración técnica, los comandos de administración y las evidencias del despliegue se documentarán dentro del directorio deploy/.

