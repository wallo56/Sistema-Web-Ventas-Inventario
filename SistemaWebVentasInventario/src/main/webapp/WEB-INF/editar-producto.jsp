
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.sistemaventas.modelo.Producto"%>
<%!
    private String escapar(String valor) {
        if (valor == null) return "";

        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    Producto producto =
            (Producto) request.getAttribute("producto");

    if (producto == null) {
        response.sendRedirect(
                request.getContextPath() + "/productos"
        );
        return;
    }

    String error = (String) request.getAttribute("error");
    String csrfToken =
            (String) request.getAttribute("csrfToken");

    if (csrfToken == null) {
        csrfToken = (String) session.getAttribute("csrfToken");
    }

    if (csrfToken == null) {
        csrfToken = "";
    }

    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String precio = request.getParameter("precio");
    String stock = request.getParameter("stock");

    if (nombre == null) nombre = producto.getNombre();
    if (descripcion == null) descripcion = producto.getDescripcion();
    if (precio == null) precio = producto.getPrecio().toPlainString();
    if (stock == null) stock = String.valueOf(producto.getStock());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Editar producto | Sistema de Inventario</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 15px;
            background: #f1f5f9;
            font-family: Arial, sans-serif;
            color: #1e293b;
        }

        .contenedor {
            max-width: 600px;
            margin: 30px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
        }

        h1 {
            margin-top: 0;
            font-size: 25px;
        }

        .descripcion {
            color: #64748b;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            font-size: 14px;
        }

        input, textarea {
            width: 100%;
            padding: 11px;
            margin-bottom: 20px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-family: Arial, sans-serif;
            font-size: 14px;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        input:focus, textarea:focus {
            outline: 2px solid #93c5fd;
            border-color: #2563eb;
        }

        .acciones {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: center;
        }

        .guardar {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .guardar:hover {
            background: #1d4ed8;
        }

        .cancelar {
            padding: 12px 20px;
            border-radius: 6px;
            background: #e2e8f0;
            color: #334155;
            text-decoration: none;
            font-size: 14px;
        }

        .error {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>

<body>

<div class="contenedor">

    <h1>Editar producto</h1>

    <p class="descripcion">
        Modifica los datos del producto seleccionado.
    </p>

    <% if (error != null) { %>
        <div class="error" role="alert">
            <%= escapar(error) %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/productos/actualizar"
          method="POST"
          accept-charset="UTF-8">

        <input type="hidden"
               name="csrfToken"
               value="<%= escapar(csrfToken) %>">

        <input type="hidden"
               name="id"
               value="<%= producto.getIdProducto() %>">

        <label for="nombre">Nombre del producto</label>
        <input type="text"
               id="nombre"
               name="nombre"
               maxlength="100"
               value="<%= escapar(nombre) %>"
               required>

        <label for="descripcion">Descripción</label>
        <textarea id="descripcion"
                  name="descripcion"
                  maxlength="255"><%= escapar(descripcion) %></textarea>

        <label for="precio">Precio (Q)</label>
        <input type="number"
               id="precio"
               name="precio"
               min="0"
               step="0.01"
               value="<%= escapar(precio) %>"
               required>

        <label for="stock">Cantidad en existencia</label>
        <input type="number"
               id="stock"
               name="stock"
               min="0"
               step="1"
               value="<%= escapar(stock) %>"
               required>

        <div class="acciones">
            <button type="submit" class="guardar">
                Guardar cambios
            </button>

            <a class="cancelar"
               href="<%= request.getContextPath() %>/productos">
                Cancelar
            </a>
        </div>

    </form>

</div>

</body>
</html>
