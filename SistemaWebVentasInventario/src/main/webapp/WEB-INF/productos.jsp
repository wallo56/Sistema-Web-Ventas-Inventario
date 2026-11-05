<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.sistemaventas.modelo.Producto"%>

<%@page import="com.sistemaventas.modelo.Usuario"%>


<%!
    private String escaparHTML(String texto) {
        if (texto == null) {
            return "";
        }

        return texto
                .replace("&", "&amp;")
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
        response.sendRedirect(
                request.getContextPath() + "/dashboard"
        );
        return;
    }


String csrfToken = (String) session.getAttribute("csrfToken");

if (csrfToken == null) {
    csrfToken = "";
}


Usuario usuarioActual =
        (Usuario) session.getAttribute("usuario");

boolean esAdministrador =
        usuarioActual != null
        && "ADMINISTRADOR".equalsIgnoreCase(
                usuarioActual.getNombreRol()
        );

%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Productos - Sistema de Inventario</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f4f6f9;
            color: #222;
        }

        h1 {
            margin-bottom: 10px;
        }

        .contenedor {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #263b59;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f5f5f5;
        }

        .volver {
            display: inline-block;
            margin-top: 20px;
            color: #263b59;
        }


.nuevo-producto {
    display: inline-block;
    margin-top: 15px;
    padding: 11px 18px;
    background-color: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
}

.nuevo-producto:hover {
    background-color: #1d4ed8;
}


.editar-producto {
    display: inline-block;
    padding: 8px 12px;
    background-color: #f59e0b;
    color: #1e293b;
    text-decoration: none;
    border-radius: 5px;
    font-size: 13px;
    font-weight: bold;
}

.editar-producto:hover {
    background-color: #d97706;
    color: white;
}


.desactivar-form {
    display: inline-block;
    margin-left: 8px;
}

.desactivar-producto {
    padding: 8px 12px;
    background-color: #dc2626;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
}

.desactivar-producto:hover {
    background-color: #b91c1c;
}

    </style>
</head>

<body>

<div class="contenedor">

    <h1>Gestión de productos</h1>
    <p>Listado de productos activos del inventario.</p>

<a class="nuevo-producto"
   href="<%= request.getContextPath() %>/productos/crear">
    + Nuevo producto
</a>


    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>

        <tbody>
            <% if (productos.isEmpty()) { %>
                <tr>
                    <td colspan="7">
                        No hay productos registrados.
                    </td>
                </tr>
            <% } else { %>
                <% for (Producto producto : productos) { %>
                    <tr>
                        <td><%= producto.getIdProducto() %></td>

                        <td><%= escaparHTML(producto.getNombre()) %></td>
                        <td><%= escaparHTML(producto.getDescripcion()) %></td>

                        <td><%= producto.getPrecio() %></td>
                        <td><%= producto.getStock() %></td>
                        <td><%= producto.getEstado() %></td>


                        <td>
                            <a class="editar-producto"
                               href="<%= request.getContextPath() %>/productos/actualizar?id=<%= producto.getIdProducto() %>">
                                Editar
                            </a>
                            <% if (esAdministrador) { %>
                            <form class="desactivar-form"
                                  action="<%= request.getContextPath() %>/productos/eliminar"
                                  method="POST"
                                  onsubmit="return confirm('¿Estás seguro de que deseas eliminar este producto?');">

                                <input type="hidden"
                                       name="id"
                                       value="<%= producto.getIdProducto() %>">

                                <input type="hidden"
                                       name="csrfToken"
                                       value="<%= csrfToken %>">

                                <button type="submit" class="desactivar-producto">
                                    Eliminar
                                </button>
                            </form>
                            <% } %>
                        </td>


                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>

    <a class="volver"
       href="<%= request.getContextPath() %>/dashboard">
        Volver al dashboard
    </a>

</div>

</body>
</html>
