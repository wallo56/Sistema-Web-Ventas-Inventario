<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#4f46e5">
    <title>Iniciar sesión | Sistema de Ventas e Inventario</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/frontend.css?v=2">
    <script defer src="<%= request.getContextPath() %>/assets/js/frontend.js?v=2"></script>
</head>
<body class="login-page">
    <main class="login-shell">
        <section class="login-card" aria-labelledby="login-heading">
            <div class="brand-mark brand-mark-lg" aria-hidden="true">SV</div>
            <p class="eyebrow login-eyebrow">ACCESO AL SISTEMA</p>
            <h1 id="login-heading">Sistema de Ventas</h1>
            <p class="muted login-intro">Ingresa tus credenciales para gestionar el inventario.</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">Usuario o contraseña incorrectos, o faltan datos.</div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="POST" class="app-form">
                <div class="field">
                    <label for="usuario">Usuario</label>
                    <input id="usuario" name="usuario" type="text" placeholder="Tu usuario"
                           autocomplete="username" maxlength="50" required autofocus>
                </div>
                <div class="field">
                    <label for="password">Contraseña</label>
                    <input id="password" name="password" type="password" placeholder="Tu contraseña"
                           autocomplete="current-password" required>
                </div>
                <button class="btn btn-primary btn-block" type="submit">Iniciar sesión</button>
            </form>
            <p class="login-footer">Gestión de inventario · Acceso autorizado</p>
        </section>
    </main>
</body>
</html>
