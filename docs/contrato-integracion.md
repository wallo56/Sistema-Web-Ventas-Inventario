# Contrato de integración — Sistema Web de Ventas e Inventario

**Versión:** 2.0  
**Proyecto:** SistemaWebVentasInventario  
**Backend:** Integrante 2  
**Frontend:** Integrante 3  
**Estado:** Backend principal implementado y probado localmente. Integración con frontend pendiente.

---

## 1. Información general

El presente documento establece las rutas, parámetros, respuestas y reglas de integración entre el backend y el frontend del Sistema Web de Ventas e Inventario.

### Tecnologías utilizadas

- Java 17.
- Jakarta Servlet 6.0.
- Apache Tomcat 10.1.
- PostgreSQL 17.
- JDBC para conexión a la base de datos.
- Maven para compilación y generación del archivo WAR.
- JSP, HTML, CSS y JavaScript.
- Codificación UTF-8.

### URL base local

`http://localhost:8080/SistemaWebVentasInventario`

Todas las rutas documentadas son relativas al contexto de la aplicación.

El frontend deberá utilizar el contexto de la aplicación para construir las direcciones, evitando depender de una URL fija.

La comunicación entre frontend y backend se realiza mediante formularios HTML y solicitudes HTTP GET y POST. Actualmente no se utiliza una API REST con respuestas JSON.

---

## 2. Autenticación de usuarios

### GET /login

Muestra el formulario de inicio de sesión.

**Campos del formulario:**

| Campo | Tipo | Obligatorio |
|---|---|---|
| usuario | text | Sí |
| contrasena | password | Sí |

### POST /login

Recibe las credenciales del usuario y verifica su autenticidad contra PostgreSQL.

**Parámetros:**

- `usuario`: nombre de usuario.
- `contrasena`: contraseña ingresada.

**Funcionamiento:**

1. Comprueba que los campos requeridos estén completos.
2. Consulta el usuario en PostgreSQL mediante `UsuarioDAO`.
3. Verifica que el usuario esté activo.
4. Comprueba la contraseña mediante PBKDF2-SHA256.
5. Recupera el identificador y nombre del rol.
6. Establece la sesión HTTP correspondiente.

**Resultados esperados:**

- Credenciales correctas: redirección a `/dashboard`.
- Credenciales incorrectas: mensaje de error en el formulario.
- Campos vacíos: mensaje de validación.
- Error de conexión: respuesta de error controlada.

Las contraseñas se almacenan mediante hashes seguros, nunca en texto plano.

---

## 3. Cierre de sesión

### POST /logout

Finaliza la sesión del usuario autenticado.

**Funcionamiento:**

- Invalida la sesión HTTP.
- Redirige al formulario `/login`.
- Impide acceder a las páginas protegidas sin iniciar sesión nuevamente.

Las páginas protegidas utilizan controles de sesión y cabeceras para evitar el almacenamiento innecesario de información sensible en caché.

---

## 4. Panel principal

### GET /dashboard

Muestra el panel principal de la aplicación.

**Requisitos:**

- El usuario debe tener una sesión activa.
- La sesión debe contener un objeto `Usuario` válido.

**Información disponible:**

- Nombre de usuario autenticado.
- Rol asignado.
- Acceso al módulo de productos.
- Opción para cerrar sesión.

El diseño definitivo del dashboard corresponde al integrante de frontend.

---

## 5. Gestión de productos

El módulo de productos permite registrar, consultar, actualizar y desactivar productos del inventario.

La información se almacena en PostgreSQL.

### 5.1. GET /productos

Muestra el listado de productos activos.

**Requisitos:**

- Sesión autenticada.

**Datos mostrados:**

| Campo | Tipo | Descripción |
|---|---|---|
| id_producto | integer | Identificador único |
| nombre | text | Nombre del producto |
| descripcion | text | Descripción del producto |
| precio | decimal | Precio de venta |
| stock | integer | Cantidad disponible |
| estado | char | Estado del producto |

**Funcionamiento:**

- Consulta los productos mediante `ProductoDAO`.
- Muestra únicamente productos activos (`estado = 'A'`).
- Envía los resultados a `productos.jsp`.
- Permite acceder a los formularios de registro y edición.
- Muestra la opción de eliminación únicamente a los administradores.

### 5.2. GET /productos/crear

Muestra el formulario para registrar un nuevo producto.

**Campos:**

| Campo | Tipo | Obligatorio |
|---|---|---|
| nombre | text | Sí |
| descripcion | textarea | No |
| precio | number | Sí |
| stock | number | Sí |

El formulario incluye un campo oculto denominado `csrfToken`.

### 5.3. POST /productos/crear

Registra un producto nuevo en PostgreSQL.

**Parámetros:**

- `nombre`
- `descripcion`
- `precio`
- `stock`
- `csrfToken`

**Validaciones:**

- Nombre obligatorio y máximo 100 caracteres.
- Descripción de máximo 255 caracteres.
- Precio numérico, mayor o igual a cero y con máximo dos decimales.
- Stock entero, mayor o igual a cero.
- Token CSRF válido.
- Sesión autenticada.

**Resultados esperados:**

- Registro correcto: redirección a `/productos`.
- Datos incorrectos: mensaje de validación.
- Token CSRF inválido: HTTP 403.
- Error de base de datos: respuesta controlada.

### 5.4. GET /productos/actualizar?id=ID

Muestra el formulario de edición del producto seleccionado.

**Parámetro:**

- `id`: identificador del producto.

**Funcionamiento:**

- Comprueba que exista una sesión activa.
- Busca el producto mediante `ProductoDAO`.
- Recupera únicamente productos activos.
- Carga sus datos en `editar-producto.jsp`.
- Proporciona un token CSRF para el formulario.

Si el producto no existe o está inactivo, no debe permitirse su edición.

### 5.5. POST /productos/actualizar

Actualiza la información de un producto existente.

**Parámetros:**

- `id`
- `nombre`
- `descripcion`
- `precio`
- `stock`
- `csrfToken`

**Validaciones:**

- Identificador válido.
- Producto existente y activo.
- Nombre obligatorio.
- Descripción dentro del límite permitido.
- Precio mayor o igual a cero.
- Stock mayor o igual a cero.
- Token CSRF válido.
- Sesión autenticada.

**Resultados esperados:**

- Actualización correcta: redirección a `/productos`.
- Datos incorrectos: mensaje de validación.
- Producto inexistente: respuesta de error.
- Token CSRF inválido: HTTP 403.

### 5.6. POST /productos/eliminar

Realiza la eliminación lógica del producto seleccionado.

**Parámetros:**

- `id`
- `csrfToken`

**Funcionamiento:**

1. Comprueba que exista una sesión autenticada.
2. Verifica que el usuario tenga rol `ADMINISTRADOR`.
3. Valida el token CSRF.
4. Comprueba el identificador del producto.
5. Ejecuta la eliminación lógica mediante `ProductoDAO`.
6. Cambia el estado del producto de `A` a `I`.
7. Redirige al listado de productos.

**Resultados esperados:**

- Eliminación correcta: redirección a `/productos?eliminado=1`.
- Usuario sin permisos: HTTP 403.
- Token CSRF inválido: HTTP 403.
- Identificador incorrecto: HTTP 400.
- Producto inexistente o inactivo: HTTP 404.
- Error de base de datos: HTTP 500 con mensaje controlado.

**Importante:** La eliminación no borra físicamente el registro de PostgreSQL. Únicamente cambia su estado a inactivo.

No está permitida la eliminación mediante GET. Una solicitud GET a esta ruta devuelve HTTP 405.

---

## 6. Roles y permisos

El sistema utiliza dos roles principales:

- `ADMINISTRADOR`
- `OPERADOR`

### Matriz de permisos

| Funcionalidad | ADMINISTRADOR | OPERADOR |
|---|---|---|
| Iniciar sesión | Sí | Sí |
| Acceder al dashboard | Sí | Sí |
| Consultar productos | Sí | Sí |
| Registrar productos | Sí | Sí |
| Actualizar productos | Sí | Sí |
| Eliminar productos | Sí | No |
| Cerrar sesión | Sí | Sí |

Los permisos se determinan utilizando el rol recuperado desde PostgreSQL durante la autenticación.

El backend valida los permisos antes de ejecutar operaciones restringidas.

El frontend también debe respetar estas reglas al mostrar las opciones disponibles.

Por ejemplo, el botón **Eliminar** no debe aparecer cuando el usuario tenga el rol `OPERADOR`.

Ocultar botones no sustituye las validaciones de seguridad implementadas en el servidor.

---

## 7. Seguridad del sistema

### 7.1. Contraseñas

Las contraseñas se protegen mediante:

- PBKDF2 con HMAC-SHA256.
- 600,000 iteraciones.
- Sal aleatoria de 16 bytes.
- Hash de 256 bits.

El sistema verifica las contraseñas utilizando la clase `SeguridadPassword`.

### 7.2. Sesiones HTTP

Las operaciones protegidas requieren una sesión válida.

La información del usuario autenticado se almacena en la sesión mediante el atributo:

`usuario`

Este atributo contiene un objeto de la clase `Usuario`, que incluye su identificador, nombre de usuario, estado y rol.

La sesión tiene un tiempo de expiración configurado de 30 minutos.

### 7.3. Protección CSRF

Los formularios que modifican información utilizan un token CSRF.

**Nombre obligatorio del parámetro:**

`csrfToken`

El backend genera el token y lo almacena en la sesión.

El frontend debe incluirlo en los formularios POST de:

- Registro de productos.
- Actualización de productos.
- Eliminación de productos.

Ejemplo de campo oculto en JSP:

```jsp
<input type="hidden"
       name="csrfToken"
       value="<%= csrfToken %>">
```

El valor debe obtenerse del backend y escaparse correctamente al insertarlo en HTML.

No debe utilizarse un token fijo ni generarse uno independiente en el frontend.

### 7.4. Protección contra SQL Injection

Las operaciones SQL utilizan `PreparedStatement` y parámetros preparados.

No deben construirse consultas SQL concatenando directamente los datos recibidos del usuario.

### 7.5. Protección contra XSS

Los datos dinámicos deben escaparse antes de mostrarse en HTML.

Esto incluye:

- Nombres de productos.
- Descripciones.
- Valores recuperados de formularios.
- Mensajes de error.
- Valores dinámicos insertados en atributos HTML.

Los formularios provisionales del backend ya incorporan medidas de escape HTML.

El frontend definitivo debe conservar estas protecciones.

---

## 8. Validaciones de datos

El backend es responsable de validar todos los datos recibidos, independientemente de las validaciones HTML o JavaScript.

### Productos

| Campo | Regla |
|---|---|
| id | Entero positivo |
| nombre | Obligatorio, máximo 100 caracteres |
| descripcion | Máximo 255 caracteres |
| precio | Decimal mayor o igual a cero, máximo dos decimales |
| stock | Entero mayor o igual a cero |
| estado | A (activo) o I (inactivo) |

Las validaciones del frontend sirven para mejorar la experiencia de usuario, pero no reemplazan las del servidor.

---

## 9. Respuestas HTTP y navegación

El sistema utiliza las siguientes respuestas:

| Código | Significado |
|---|---|
| 200 | Solicitud procesada correctamente |
| 302 | Redirección después de una operación |
| 400 | Parámetros incorrectos |
| 403 | Acceso denegado o token CSRF inválido |
| 404 | Recurso no encontrado |
| 405 | Método HTTP no permitido |
| 500 | Error interno del servidor |

### Reglas de navegación

- GET: consultar información o mostrar formularios.
- POST: procesar operaciones que modifican información.
- Operación exitosa: redirigir a la página correspondiente.
- Validación incorrecta: mostrar un mensaje de error.
- Sesión inexistente: redirigir a `/login`.
- Acceso sin permisos: responder HTTP 403.

Las rutas deben construirse utilizando el contexto de la aplicación.

---

## 10. Conexión con PostgreSQL

La conexión se implementa mediante la clase:

`com.sistemaventas.config.ConexionBD`

### Configuración local

- Motor: PostgreSQL 17.
- Puerto: 5432.
- Base de datos: `sistema_inventario_web`.
- Usuario de aplicación: `app_inventario`.

### Variables de entorno

**DB_PASSWORD**

Contiene la contraseña del usuario de PostgreSQL utilizado por la aplicación.

Es obligatoria.

**DB_URL**

Permite configurar la URL JDBC de conexión.

Si no está definida, se utiliza la siguiente dirección local:

`jdbc:postgresql://localhost:5432/sistema_inventario_web`

En el VPS podrá configurarse la dirección correspondiente sin modificar el código Java.

Las contraseñas no deben incluirse en el repositorio GitHub ni escribirse directamente en el código fuente.

---

## 11. Estructura del backend

### Paquete de configuración

`com.sistemaventas.config`

- `ConexionBD.java`: conexión JDBC con PostgreSQL.

### Paquete de modelos

`com.sistemaventas.modelo`

- `Usuario.java`: representación de usuarios y roles.
- `Producto.java`: representación de productos.

### Paquete DAO

`com.sistemaventas.dao`

- `UsuarioDAO.java`: autenticación y consulta de usuarios.
- `ProductoDAO.java`: operaciones de productos en PostgreSQL.

### Paquete de seguridad

`com.sistemaventas.seguridad`

- `SeguridadPassword.java`: verificación segura de contraseñas.
- `GeneradorPassword.java`: generación de hashes.
- `PruebaGeneradorPassword.java`: herramienta de prueba para generar hashes desde una terminal.

### Paquete de Servlets

`com.sistemaventas.servlet`

- `LoginServlet.java`
- `DashboardServlet.java`
- `LogoutServlet.java`
- `ProductoServlet.java`
- `CrearProductoServlet.java`
- `ActualizarProductoServlet.java`
- `EliminarProductoServlet.java`

### Páginas JSP

- `login.jsp`
- `WEB-INF/dashboard.jsp`
- `WEB-INF/productos.jsp`
- `WEB-INF/crear-producto.jsp`
- `WEB-INF/editar-producto.jsp`

Estas páginas constituyen la interfaz provisional utilizada para probar las funcionalidades del backend.

El integrante de frontend podrá mejorar su diseño respetando las rutas, parámetros y validaciones establecidos en este documento.

---

## 12. Responsabilidades de integración

### 12.1. Backend — Integrante 2

Responsabilidades:

- Implementar las rutas HTTP.
- Desarrollar los Servlets.
- Conectar PostgreSQL mediante JDBC.
- Implementar autenticación.
- Administrar sesiones.
- Implementar el CRUD de productos.
- Validar los datos recibidos.
- Implementar permisos por rol.
- Proteger las operaciones mediante CSRF.
- Manejar errores del servidor.
- Preparar el archivo WAR.
- Coordinar la integración con frontend y despliegue.

### 12.2. Frontend — Integrante 3

Responsabilidades:

- Diseñar las páginas del sistema.
- Mejorar la apariencia visual.
- Crear una interfaz adaptable a diferentes pantallas.
- Implementar formularios utilizando las rutas acordadas.
- Respetar exactamente los nombres de los parámetros.
- Incorporar los tokens CSRF proporcionados por el backend.
- Mostrar mensajes de validación.
- Respetar la visibilidad de opciones según el rol.
- Implementar confirmaciones visuales para operaciones como eliminar productos.
- Coordinar cualquier cambio de rutas o parámetros con el integrante de backend.

### 12.3. Integración

Antes de reemplazar las páginas provisionales:

1. Verificar que el frontend utilice las rutas documentadas.
2. Confirmar que los formularios envíen los parámetros correctos.
3. Conservar los tokens CSRF.
4. Mantener la autenticación mediante sesiones.
5. Respetar los permisos de cada rol.
6. Probar nuevamente las operaciones CRUD.
7. Confirmar que los errores se muestren correctamente.
8. Comprobar el funcionamiento después de generar el WAR.

---

## 13. Pruebas realizadas

Durante el desarrollo local se han realizado las siguientes pruebas:

| Prueba | Resultado |
|---|---|
| Conexión JDBC con PostgreSQL | Correcto |
| Autenticación de administrador | Correcto |
| Autenticación de operador | Correcto |
| Protección de páginas sin sesión | Correcto |
| Cierre de sesión | Correcto |
| Listado de productos activos | Correcto |
| Registro de productos | Correcto |
| Actualización de productos | Correcto |
| Eliminación lógica | Correcto |
| Verificación del estado inactivo en PostgreSQL | Correcto |
| Restricción de eliminación para operador | Correcto |
| Visibilidad del botón según rol | Correcto |
| Compilación del proyecto Maven | Correcto |
| Conexión local después de configurar DB_URL | Correcto |

### Pruebas pendientes

- Integración con el diseño definitivo del frontend.
- Pruebas conjuntas de todos los formularios.
- Revisión de funcionalidades adicionales que requiera el proyecto.
- Generación y verificación final del archivo WAR.
- Despliegue en el VPS Linux.
- Pruebas de funcionamiento desde el servidor.
- Verificación final de seguridad y permisos después de la integración.

---

## 14. Consideraciones para el despliegue

El backend utiliza Java 17 y Jakarta Servlet 6.0, por lo que el servidor de aplicaciones debe ser compatible con estas tecnologías.

Para el despliegue se utilizará Apache Tomcat 10.1.

El proyecto se empaquetará como archivo WAR mediante Maven.

Antes del despliegue será necesario:

- Configurar Java y Tomcat en el VPS.
- Preparar PostgreSQL y sus usuarios.
- Establecer `DB_PASSWORD`.
- Configurar `DB_URL` cuando corresponda.
- Confirmar que el controlador JDBC esté incluido en el WAR.
- Configurar las conexiones y permisos de base de datos.
- Verificar las rutas de acceso.
- Probar el inicio y cierre de sesión.
- Probar el CRUD de productos.
- Verificar los permisos de administrador y operador.

El despliegue final será coordinado con el integrante responsable de Linux y DevOps.

---

## 15. Estado actual del proyecto

**Versión del contrato:** 2.0

**Backend:** Funcional y probado localmente en sus módulos principales.

**Frontend definitivo:** Pendiente de integración.

**Base de datos PostgreSQL:** Implementada y utilizada por el backend.

**Autenticación:** Implementada.

**CRUD de productos:** Implementado.

**Seguridad por roles:** Implementada para las operaciones de productos definidas.

**Protección CSRF:** Implementada en las operaciones de creación, actualización y eliminación de productos.

**Despliegue en VPS:** Pendiente.

Este documento reemplaza la versión inicial del contrato de integración y establece las rutas y parámetros que deberá utilizar el frontend.

Cualquier modificación posterior deberá coordinarse entre los integrantes responsables para evitar incompatibilidades.

---

**Fin del contrato de integración — Versión 2.0**