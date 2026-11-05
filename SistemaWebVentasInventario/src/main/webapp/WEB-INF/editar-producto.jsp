<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.sistemaventas.modelo.Producto"%>
<%@page import="com.sistemaventas.modelo.Usuario"%>
<%!
    private String escapeEditar(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    Producto producto = (Producto) request.getAttribute("producto");
    if (producto == null) {
        response.sendRedirect(request.getContextPath() + "/productos");
        return;
    }
    String error = (String) request.getAttribute("error");
    String csrfToken = (String) request.getAttribute("csrfToken");
    if (csrfToken == null) csrfToken = (String) session.getAttribute("csrfToken");
    csrfToken = escapeEditar(csrfToken);
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String precio = request.getParameter("precio");
    String stock = request.getParameter("stock");
    if (nombre == null) nombre = producto.getNombre();
    if (descripcion == null) descripcion = producto.getDescripcion();
    if (precio == null) precio = producto.getPrecio().toPlainString();
    if (stock == null) stock = String.valueOf(producto.getStock());
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String usuarioSeguro = usuario == null ? "" : escapeEditar(usuario.getUsuario());
    String rolSeguro = usuario == null ? "" : escapeEditar(usuario.getNombreRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#4f46e5">
    <title>Editar producto | Sistema de Ventas e Inventario</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/frontend.css?v=2">
    <script defer src="<%= request.getContextPath() %>/assets/js/frontend.js?v=2"></script>
</head>
<body class="app-page">
    <header class="site-header">
        <nav class="nav-container" aria-label="Navegación principal">
            <a class="brand" href="<%= request.getContextPath() %>/dashboard"><span class="brand-mark brand-mark-sm" aria-hidden="true">SV</span><span>Sistema de Ventas</span></a>
            <button class="nav-toggle" type="button" aria-label="Abrir menú" aria-controls="main-nav" aria-expanded="false" data-nav-toggle><span aria-hidden="true">☰</span></button>
            <div class="nav-links" id="main-nav" data-nav-links>
                <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                <a class="nav-link active" href="<%= request.getContextPath() %>/productos">Productos</a>
                <span class="nav-user"><%= usuarioSeguro %> <span class="role-chip"><%= rolSeguro %></span></span>
                <form class="nav-logout" action="<%= request.getContextPath() %>/logout" method="POST"><button class="nav-logout-btn" type="submit">Cerrar sesión</button></form>
            </div>
        </nav>
    </header>
    <main class="page-container form-page">
        <a class="back-link" href="<%= request.getContextPath() %>/productos">← Volver a productos</a>
        <div class="page-heading">
            <div><p class="eyebrow">INVENTARIO / EDICIÓN</p><h1>Editar producto</h1><p class="muted">Actualiza la información del producto <strong>P-<%= String.format(java.util.Locale.ROOT, "%03d", producto.getIdProducto()) %></strong>.</p></div>
        </div>
        <section class="panel form-panel" aria-labelledby="form-title">
            <h2 id="form-title">Información del producto</h2>
            <p class="muted small">Los campos marcados con * son obligatorios.</p>
            <% if (error != null) { %><div class="alert alert-danger" role="alert"><%= escapeEditar(error) %></div><% } %>
            <form action="<%= request.getContextPath() %>/productos/actualizar" method="POST" accept-charset="UTF-8" class="app-form">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
                <input type="hidden" name="id" value="<%= producto.getIdProducto() %>">
                <div class="field">
                    <label for="nombre">Nombre del producto <span aria-hidden="true">*</span></label>
                    <input id="nombre" name="nombre" type="text" maxlength="100" value="<%= escapeEditar(nombre) %>" required>
                </div>
                <div class="field">
                    <label for="descripcion">Descripción</label>
                    <textarea id="descripcion" name="descripcion" maxlength="255" rows="4" placeholder="Detalles del producto"><%= escapeEditar(descripcion) %></textarea>
                </div>
                <div class="form-grid">
                    <div class="field">
                        <label for="precio">Precio (Q) <span aria-hidden="true">*</span></label>
                        <input id="precio" name="precio" type="number" min="0" step="0.01" value="<%= escapeEditar(precio) %>" required>
                    </div>
                    <div class="field">
                        <label for="stock">Cantidad en existencia <span aria-hidden="true">*</span></label>
                        <input id="stock" name="stock" type="number" min="0" step="1" value="<%= escapeEditar(stock) %>" required>
                    </div>
                </div>
                <div class="form-actions">
                    <a class="btn btn-light" href="<%= request.getContextPath() %>/productos">Cancelar</a>
                    <button class="btn btn-primary" type="submit">Guardar cambios</button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
