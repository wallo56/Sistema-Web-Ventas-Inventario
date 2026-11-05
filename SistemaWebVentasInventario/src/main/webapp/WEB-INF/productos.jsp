
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="com.sistemaventas.modelo.Producto"%>
<%@page import="com.sistemaventas.modelo.Usuario"%>
<%!
    private String escapeProductos(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    List<Producto> productos =
            (List<Producto>) request.getAttribute("productos");

    if (productos == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    Usuario usuarioActual =
            (Usuario) session.getAttribute("usuario");

    boolean esAdministrador = usuarioActual != null
            && "ADMINISTRADOR".equalsIgnoreCase(
                    usuarioActual.getNombreRol());

    String usuarioSeguro = usuarioActual == null ? ""
            : escapeProductos(usuarioActual.getUsuario());

    String rolSeguro = usuarioActual == null ? ""
            : escapeProductos(usuarioActual.getNombreRol());

    String csrfToken = (String) session.getAttribute("csrfToken");
    csrfToken = escapeProductos(csrfToken);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#4f46e5">
    <title>Productos | Sistema de Ventas e Inventario</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/frontend.css?v=2">
    <script defer
            src="<%= request.getContextPath() %>/assets/js/frontend.js?v=2"></script>
</head>
<body class="app-page">

<header class="site-header">
    <nav class="nav-container" aria-label="Navegación principal">
        <a class="brand"
           href="<%= request.getContextPath() %>/dashboard">
            <span class="brand-mark brand-mark-sm" aria-hidden="true">SV</span>
            <span>Sistema de Ventas</span>
        </a>

        <button class="nav-toggle" type="button"
                aria-label="Abrir menú"
                aria-controls="main-nav"
                aria-expanded="false"
                data-nav-toggle>
            <span aria-hidden="true">☰</span>
        </button>

        <div class="nav-links" id="main-nav" data-nav-links>
            <a class="nav-link"
               href="<%= request.getContextPath() %>/dashboard">
                Dashboard
            </a>

            <a class="nav-link active" aria-current="page"
               href="<%= request.getContextPath() %>/productos">
                Productos
            </a>

            <span class="nav-user">
                <%= usuarioSeguro %>
                <span class="role-chip"><%= rolSeguro %></span>
            </span>

            <form class="nav-logout"
                  action="<%= request.getContextPath() %>/logout"
                  method="POST">
                <button class="nav-logout-btn" type="submit">
                    Cerrar sesión
                </button>
            </form>
        </div>
    </nav>
</header>

<main class="page-container">
    <div class="page-heading">
        <div>
            <p class="eyebrow">INVENTARIO</p>
            <h1>Productos</h1>
            <p class="muted">
                Consulta, busca y administra los productos registrados.
            </p>
        </div>

        <a class="btn btn-primary"
           href="<%= request.getContextPath() %>/productos/crear">
            <span aria-hidden="true">＋ </span>Nuevo producto
        </a>
    </div>

    <section class="panel inventory-panel"
             aria-labelledby="inventory-title">

        <div class="panel-heading">
            <div>
                <h2 id="inventory-title">Listado de productos</h2>
                <p class="muted small">
                    Búsqueda y filtros sobre los productos
                    cargados desde PostgreSQL.
                </p>
            </div>

            <span class="panel-counter" id="contador"
                  role="status" aria-live="polite">
                <%= productos.size() %>
                <%= productos.size() == 1 ? "producto" : "productos" %>
            </span>
        </div>

        <div class="filters-row" data-product-filters>
            <div class="field filter-search">
                <label for="buscar">Buscar por nombre o código</label>
                <input type="search" id="buscar"
                       placeholder="Ej. teclado, 2 o P-002"
                       autocomplete="off"
                       aria-controls="productos-body">
            </div>

            <div class="field filter-select">
                <label for="filtro-stock">Existencias</label>
                <select id="filtro-stock"
                        aria-controls="productos-body">
                    <option value="todos">Todos los productos</option>
                    <option value="disponible">Con existencia</option>
                    <option value="bajo">Stock bajo (1 a 9)</option>
                    <option value="agotado">Agotados (0)</option>
                </select>
            </div>

            <button id="limpiar-filtros" type="button"
                    class="btn btn-light filter-reset">
                Limpiar
            </button>
        </div>

        <div class="table-wrap" role="region"
             aria-label="Tabla de productos" tabindex="0">

            <table class="inventory-table">
                <thead>
                    <tr>
                        <th scope="col">Código</th>
                        <th scope="col">Producto</th>
                        <th scope="col">Descripción</th>
                        <th scope="col">Precio</th>
                        <th scope="col">Stock</th>
                        <th scope="col">Disponibilidad</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Acciones</th>
                    </tr>
                </thead>

                <tbody id="productos-body">
                <%
                    for (Producto producto : productos) {
                        int stock = producto.getStock();

                        String codigo = String.format(
                                Locale.ROOT, "P-%03d",
                                producto.getIdProducto());

                        String disponibilidad = stock <= 0
                                ? "Agotado"
                                : stock < 10 ? "Stock bajo" : "Disponible";

                        String claseDisponibilidad = stock <= 0
                                ? "badge-danger"
                                : stock < 10
                                    ? "badge-warning"
                                    : "badge-success";
                %>
                    <tr data-product-row
                        data-code="<%= codigo %>"
                        data-id="<%= producto.getIdProducto() %>"
                        data-name="<%= escapeProductos(producto.getNombre()) %>"
                        data-stock="<%= stock %>">

                        <td class="code-cell"><%= codigo %></td>

                        <td class="product-name">
                            <%= escapeProductos(producto.getNombre()) %>
                        </td>

                        <td class="description-cell">
                            <%= escapeProductos(producto.getDescripcion()) %>
                        </td>

                        <td class="money-cell">
                            Q <%= producto.getPrecio() %>
                        </td>

                        <td><strong><%= stock %></strong></td>

                        <td>
                            <span class="badge <%= claseDisponibilidad %>">
                                <%= disponibilidad %>
                            </span>
                        </td>

                        <td>
                            <span class="badge badge-neutral">
                                <%= escapeProductos(producto.getEstado()) %>
                            </span>
                        </td>

                        <td class="action-cell">
                            <a class="btn btn-outline btn-sm"
                               href="<%= request.getContextPath() %>/productos/actualizar?id=<%= producto.getIdProducto() %>">
                                Editar
                            </a>

                            <% if (esAdministrador) { %>
                            <form class="inline-form"
                                  action="<%= request.getContextPath() %>/productos/eliminar"
                                  method="POST"
                                  onsubmit="return confirm('¿Estás seguro de que deseas eliminar este producto?');">

                                <input type="hidden" name="id"
                                       value="<%= producto.getIdProducto() %>">

                                <input type="hidden" name="csrfToken"
                                       value="<%= csrfToken %>">

                                <button class="btn btn-danger-outline btn-sm"
                                        type="submit">
                                    Eliminar
                                </button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <p class="empty-state" id="sin-resultados"
           role="status"
           <%= productos.isEmpty() ? "" : "hidden" %>>
            <%= productos.isEmpty()
                    ? "Todavía no hay productos registrados."
                    : "No se encontraron productos con esos filtros." %>
        </p>

        <div class="table-footer">
            <span>
                Productos activos cargados:
                <strong><%= productos.size() %></strong>
            </span>
            <span>Stock bajo: 1 a 9 unidades</span>
        </div>
    </section>
</main>

</body>
</html>
