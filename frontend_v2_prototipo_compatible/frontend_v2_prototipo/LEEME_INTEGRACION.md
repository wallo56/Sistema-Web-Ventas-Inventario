# Frontend V2 — Sistema Web de Ventas e Inventario

## Propósito

Rediseño de la interfaz siguiendo la estética del prototipo del integrante 3: identidad violeta/índigo (`#4f46e5`), navegación clara, tarjetas, fondos suaves, botones y formularios modernos, y adaptación móvil.

**Esta entrega es un parche de frontend** para superponer en el proyecto existente. No contiene ni sustituye archivos Java, `pom.xml`, SQL, configuraciones de Tomcat, credenciales o la base de datos.

## Archivos incluidos

```
SistemaWebVentasInventario/src/main/webapp/
├── login.jsp
├── WEB-INF/
│   ├── dashboard.jsp
│   ├── productos.jsp
│   ├── crear-producto.jsp
│   └── editar-producto.jsp
└── assets/
    ├── css/frontend.css
    └── js/frontend.js
```

## Comportamiento conservado

- Login: `POST /login`, campos `usuario` y `password`.
- Navegación: `/dashboard`, `/productos`, `/productos/crear`, `/productos/actualizar?id=N`.
- Guardar producto: `POST /productos/crear`.
- Editar: `POST /productos/actualizar` con `id` y `csrfToken`.
- Eliminar: `POST /productos/eliminar` con `id` y `csrfToken`, con botón visible solo al rol `ADMINISTRADOR` y confirmación en navegador.
- Cerrar sesión: `POST /logout`.
- La autorización, validaciones importantes y operaciones de base de datos siguen siendo responsabilidad de los servlets existentes.

## Búsqueda y filtros

En `/productos` se filtran **solo las filas ya cargadas por `ProductoServlet`**, sin modificar ni consultar de nuevo PostgreSQL.

- Buscar por **nombre**, **ID** o código visual (`P-001` para ID 1). La base de datos actual no incluye un código independiente.
- Con existencia: `stock > 0`.
- Stock bajo: `1 <= stock < 10`.
- Agotado: `stock <= 0`.
- Todos: sin filtro de stock.
- El botón *Limpiar* restablece búsqueda y filtro. Se actualiza el contador y el mensaje cuando no hay coincidencias.

**Importante:** el dashboard muestra tarjetas de accesos y datos de sesión reales, no cifras ficticias de ventas o existencias. Indicadores numéricos reales requerirían consultas adicionales en el backend; no se implementan en este cambio visual.

## Instalación en Ubuntu/Azure — guía segura

1. Copiar el ZIP a `/tmp/` mediante SCP o un método seguro.
2. Extraer el ZIP a una carpeta temporal y verificar su contenido. **No extraer directamente sobre el repositorio sin respaldo.**
3. Confirmar la rama actual con `git branch --show-current` y el estado con `git status --short`. Si hay modificaciones pendientes, preservarlas antes de continuar.
4. Respaldar `SistemaWebVentasInventario/src/main/webapp` en una carpeta independiente con nombre único (preferiblemente fuera de `/tmp` si se necesita conservación a largo plazo).
5. Copiar solamente los 7 archivos del frontend desde el ZIP a las rutas equivalentes del proyecto.
6. Ejecutar `git diff --check` y revisar `git status --short`; confirmar que **no** cambiaron archivos `.java`, `.sql`, `pom.xml` ni credenciales.
7. Compilar desde `SistemaWebVentasInventario` con `mvn clean package` y confirmar `BUILD SUCCESS`.
8. Respaldar el WAR publicado con un nombre único antes de sustituirlo; conservar la copia de la versión previa fuera de un directorio temporal si se requiere rollback permanente.
9. Desplegar el nuevo WAR siguiendo el procedimiento vigente del servidor, verificar `tomcat10 active (running)` y revisar logs si falló.
10. Probar login, dashboard, listado, filtros, formularios, permisos ADMINISTRADOR/OPERADOR, cancelación de eliminación y persistencia.
11. Registrar cambios en una rama de integración y subirlos a GitHub **después** de probar. No subir credenciales, respaldos ni la carpeta `target/`.

## Pruebas recomendadas

- Computadora y móvil (navegación desplegable y tabla con desplazamiento horizontal).
- Buscar un producto por nombre, sin diferenciar mayúsculas/acentos; por ID `2` y código `P-002`.
- Filtrar stock bajo (1 a 9), agotado (0) y disponible (>0).
- Buscar un nombre inexistente y verificar mensaje/contador.
- Crear y editar un producto con los campos actuales y comprobar que se persiste tras recargar.
- Asegurar que solo el administrador ve `Eliminar`; confirmar con `Cancelar` antes de hacer pruebas destructivas.
- Verificar que los enlaces y el formulario de logout sigan siendo operativos.

## Limitaciones

- Los filtros trabajan sobre el listado recibido en esa respuesta (no paginación ni búsqueda global en la BD).
- Código `P-###` es presentación derivada del ID y no una columna SQL.
- No se usaron ventanas modales, tal como solicitó el usuario.
- No sustituir el Java de la VM por una copia de un ZIP anterior.
- El código fue revisado y las interacciones de búsqueda/filtro y menú fueron probadas en navegador con datos de ejemplo; la compilación Maven y la integración real con PostgreSQL deben comprobarse en el servidor del usuario.
