

\# Contrato de integración — Sistema Web de Ventas e Inventario



\## 1. Información general



\- Proyecto: SistemaWebVentasInventario

\- Backend: Java 17, Jakarta Servlet 6.0 y Tomcat 10.1

\- Base de datos: PostgreSQL

\- Comunicación: formularios HTML mediante HTTP

\- Codificación: UTF-8



URL local base:



`http://localhost:8080/SistemaWebVentasInventario`



Las rutas indicadas a continuación son relativas al contexto de la aplicación.



\## 2. Inicio de sesión



\### GET /login



Muestra el formulario de inicio de sesión.



Campos del formulario:



| Campo | Tipo | Obligatorio |

|---|---|---|

| usuario | text | Sí |

| contrasena | password | Sí |



\### POST /login



Valida las credenciales contra PostgreSQL.



Parámetros:



\- `usuario`: nombre de usuario

\- `contrasena`: contraseña ingresada



Resultado esperado:



\- Credenciales correctas: crea una sesión HTTP y redirige a `/dashboard`.

\- Credenciales incorrectas: vuelve al formulario de inicio de sesión con un mensaje de error.

\- Campos vacíos: muestra un mensaje de validación.



Las contraseñas no se almacenarán en texto plano.



\## 3. Cierre de sesión



\### POST /logout



Invalida la sesión HTTP y redirige a `/login`.



No se permitirá acceder a páginas protegidas sin una sesión válida.



\## 4. Panel principal



\### GET /dashboard



Muestra el panel principal del sistema.



Requiere una sesión válida.



El panel tendrá enlaces a los módulos disponibles, inicialmente Productos y Cerrar sesión.



\## 5. Gestión de productos



\### GET /productos



Muestra el listado de productos registrados.



Requiere una sesión válida.



Datos de cada producto:



| Campo | Tipo | Descripción |

|---|---|---|

| id\_producto | integer | Identificador único |

| nombre | text | Nombre del producto |

| descripcion | text | Descripción |

| precio | decimal | Precio de venta |

| stock | integer | Existencias disponibles |



\### GET /productos/nuevo



Muestra el formulario para registrar un producto.



\### POST /productos/crear



Registra un producto en PostgreSQL.



Parámetros:



\- `nombre`

\- `descripcion`

\- `precio`

\- `stock`



Resultado esperado:



\- Datos correctos: guarda el producto y redirige a `/productos`.

\- Datos incorrectos: muestra un mensaje de validación sin registrar el producto.



\### GET /productos/editar?id=ID



Muestra el formulario de edición con los datos del producto seleccionado.



Parámetro:



\- `id`: identificador del producto.



\### POST /productos/actualizar



Actualiza un producto existente.



Parámetros:



\- `id\_producto`

\- `nombre`

\- `descripcion`

\- `precio`

\- `stock`



Resultado esperado:



\- Actualización correcta: redirige a `/productos`.

\- Error de validación: muestra un mensaje sin modificar el registro.



\### POST /productos/eliminar



Elimina el producto seleccionado, siempre que las reglas de integridad de la base de datos lo permitan.



Parámetro:



\- `id\_producto`



Resultado esperado:



\- Eliminación correcta: redirige a `/productos`.

\- Producto inexistente o eliminación no permitida: muestra un mensaje de error.



\## 6. Validaciones



El backend verificará:



\- Que los campos obligatorios no estén vacíos.

\- Que el nombre del producto no esté vacío.

\- Que el precio sea un número mayor o igual a cero.

\- Que el stock sea un entero mayor o igual a cero.

\- Que los identificadores sean válidos.

\- Que el usuario tenga una sesión activa.



Las consultas SQL utilizarán `PreparedStatement` para evitar inyección SQL.



\## 7. Respuestas y navegación



La primera versión utilizará páginas HTML y formularios tradicionales, no una API JSON.



\- GET: muestra páginas o formularios.

\- POST: procesa operaciones.

\- Operación exitosa: redirección HTTP.

\- Validación incorrecta: muestra el formulario con un mensaje.

\- Sesión inexistente: redirección a `/login`.

\- Recurso inexistente: respuesta HTTP 404.



Las rutas deben construirse utilizando el contexto de la aplicación para permitir su despliegue local y en el VPS.



\## 8. Responsabilidades de integración



\### Backend — Integrante 2



\- Implementar los Servlets y las rutas acordadas.

\- Conectar PostgreSQL mediante JDBC.

\- Gestionar autenticación, sesiones y cierre de sesión.

\- Implementar operaciones CRUD de productos.

\- Validar los datos recibidos.

\- Preparar el archivo WAR.



\### Frontend — Integrante 3



\- Diseñar las páginas y formularios.

\- Utilizar exactamente las rutas y los nombres de campos definidos.

\- Mostrar los mensajes de validación.

\- Crear una interfaz adaptable a diferentes tamaños de pantalla.

\- Coordinar cualquier modificación del contrato antes de implementarla.



\## 9. Estado del documento



Versión: 1.0 — Contrato inicial propuesto.



Las rutas y los campos de este documento todavía deben implementarse y probarse. Cualquier cambio deberá comunicarse al integrante responsable del frontend antes de integrar los formularios.



