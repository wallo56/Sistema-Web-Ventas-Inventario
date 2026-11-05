<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.sistemaventas.modelo.Usuario"%>
<%!
    private String escapeDashboard(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    Usuario usuario = (Usuario) request.getAttribute("usuarioActual");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String usuarioSeguro = escapeDashboard(usuario.getUsuario());
    String rolSeguro = escapeDashboard(usuario.getNombreRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#4f46e5">
    <title>Dashboard | Sistema de Ventas e Inventario</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/frontend.css?v=2">
    <script defer src="<%= request.getContextPath() %>/assets/js/frontend.js?v=2"></script>
</head>
<body class="app-page">
    <header class="site-header">
        <nav class="nav-container" aria-label="Navegación principal">
            <a class="brand" href="<%= request.getContextPath() %>/dashboard">
                <span class="brand-mark brand-mark-sm" aria-hidden="true">SV</span>
                <span>Sistema de Ventas</span>
            </a>
            <button class="nav-toggle" type="button" aria-label="Abrir menú" aria-controls="main-nav" aria-expanded="false" data-nav-toggle>
                <span aria-hidden="true">☰</span>
            </button>
            <div class="nav-links" id="main-nav" data-nav-links>
                <a class="nav-link active" aria-current="page" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                <a class="nav-link" href="<%= request.getContextPath() %>/productos">Productos</a>
                <span class="nav-user" title="Sesión actual"><%= usuarioSeguro %> <span class="role-chip"><%= rolSeguro %></span></span>
                <form class="nav-logout" action="<%= request.getContextPath() %>/logout" method="POST">
                    <button class="nav-logout-btn" type="submit">Cerrar sesión</button>
                </form>
            </div>
        </nav>
    </header>

    <main class="page-container">
        <div class="page-heading">
            <div>
                <p class="eyebrow">RESUMEN</p>
                <h1>Dashboard</h1>
                <p class="muted">Bienvenido, <strong><%= usuarioSeguro %></strong>. Gestiona tu inventario desde un solo lugar.</p>
            </div>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/productos">Ver productos <span aria-hidden="true">→</span></a>
        </div>

        <!-- Tarjetas informativas: no se muestran cifras inventadas ni datos de demostración. -->
        <section class="stat-grid" aria-label="Accesos y resumen de sesión">
            <article class="stat-card">
                <div class="stat-icon" aria-hidden="true">▦</div>
                <p class="stat-label">Inventario</p>
                <h2 class="stat-value stat-value-text">Productos</h2>
                <a class="stat-link" href="<%= request.getContextPath() %>/productos">Consultar inventario →</a>
            </article>
            <article class="stat-card">
                <div class="stat-icon" aria-hidden="true">＋</div>
                <p class="stat-label">Registro</p>
                <h2 class="stat-value stat-value-text">Nuevo producto</h2>
                <a class="stat-link" href="<%= request.getContextPath() %>/productos/crear">Abrir formulario →</a>
            </article>
            <article class="stat-card">
                <div class="stat-icon" aria-hidden="true">◉</div>
                <p class="stat-label">Cuenta activa</p>
                <h2 class="stat-value stat-value-text"><%= usuarioSeguro %></h2>
                <span class="stat-note">Sesión iniciada correctamente</span>
            </article>
            <article class="stat-card">
                <div class="stat-icon" aria-hidden="true">✓</div>
                <p class="stat-label">Nivel de acceso</p>
                <h2 class="stat-value stat-value-text"><%= rolSeguro %></h2>
                <span class="stat-note">Permisos definidos por el servidor</span>
            </article>
        </section>

        <section class="panel quick-panel">
            <div>
                <p class="eyebrow">ACCESOS RÁPIDOS</p>
                <h2>Administración de inventario</h2>
                <p class="muted">Consulta los productos registrados, revisa existencias y administra sus datos.</p>
            </div>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/productos">Ir a productos</a>
        </section>
        <p class="page-note">Los indicadores numéricos de ventas y stock requieren consultas adicionales del backend; esta vista no presenta cifras ficticias.</p>
    </main>
</body>
</html>
