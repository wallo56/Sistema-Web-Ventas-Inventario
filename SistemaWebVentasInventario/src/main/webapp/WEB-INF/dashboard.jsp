
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.sistemaventas.modelo.Usuario"%>
<%
    Usuario usuario = (Usuario) request.getAttribute("usuarioActual");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String nombreUsuario = usuario.getUsuario();
    String nombreRol = usuario.getNombreRol();

    // Evitar que los datos del usuario se interpreten como HTML.
    String usuarioSeguro = nombreUsuario == null ? "" :
            nombreUsuario.replace("&", "&amp;")
                         .replace("<", "&lt;")
                         .replace(">", "&gt;")
                         .replace("\"", "&quot;")
                         .replace("'", "&#39;");

    String rolSeguro = nombreRol == null ? "" :
            nombreRol.replace("&", "&amp;")
                     .replace("<", "&lt;")
                     .replace(">", "&gt;")
                     .replace("\"", "&quot;")
                     .replace("'", "&#39;");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel principal | Sistema de Inventario</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f1f5f9;
            font-family: Arial, sans-serif;
            color: #1e293b;
        }

        header {
            background: #1e293b;
            color: white;
            padding: 20px 30px;
        }

        .header-content {
            max-width: 1100px;
            margin: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        header h1 {
            margin: 0;
            font-size: 22px;
        }

        .user-info {
            font-size: 14px;
        }

        main {
            max-width: 1100px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .welcome {
            background: white;
            padding: 28px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .welcome h2 {
            margin-top: 0;
        }

        .welcome p {
            color: #64748b;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(
                auto-fit, minmax(230px, 1fr)
            );
            gap: 20px;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            border: 1px solid #e2e8f0;
        }

        .card h3 {
            margin-top: 0;
        }

        .card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        .status {
            display: inline-block;
            margin-top: 12px;
            padding: 8px 12px;
            border-radius: 5px;
            background: #e2e8f0;
            color: #475569;
            font-size: 13px;
        }

        .module-button {
            display: inline-block;
            margin-top: 12px;
            padding: 10px 16px;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
        }

        .module-button:hover {
            background: #1d4ed8;
        }

        .logout-form {
            margin: 0;
        }

        .logout-button {
            padding: 10px 16px;
            border: 1px solid #f87171;
            border-radius: 6px;
            background: #dc2626;
            color: white;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .logout-button:hover {
            background: #b91c1c;
        }

        @media (max-width: 600px) {
            header {
                padding: 18px;
            }

            main {
                margin-top: 20px;
            }
        }
    </style>
</head>

<body>

<header>
    <div class="header-content">
        <h1>Sistema de Inventario</h1>

        <div class="user-info">
            Usuario:
            <strong><%= usuarioSeguro %></strong>
            | Rol:
            <strong><%= rolSeguro %></strong>
        </div>

        <form class="logout-form"
              action="<%= request.getContextPath() %>/logout"
              method="POST">

            <button type="submit" class="logout-button">
                Cerrar sesión
            </button>
        </form>
    </div>
</header>

<main>
    <section class="welcome">
        <h2>Panel principal</h2>
        <p>
            Bienvenido al sistema de gestión de inventario.
            Has iniciado sesión correctamente.
        </p>
    </section>

    <section class="cards">

        <div class="card">
            <h3>Gestión de inventario</h3>
            <p>
                Consulta, registra, actualiza y administra
                los productos, precios y existencias
                disponibles en el inventario.
            </p>

            <a class="module-button"
               href="<%= request.getContextPath() %>/productos">
                Administrar inventario
            </a>
        </div>

        <div class="card">
            <h3>Mi sesión</h3>
            <p>
                Consulta tu usuario y el rol asignado
                dentro del sistema.
            </p>

            <span class="status">
                Sesión iniciada
            </span>
        </div>

    </section>
</main>

</body>
</html>
