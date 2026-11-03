
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión | Sistema de Inventario</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f5f9;
            font-family: Arial, sans-serif;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 32px;
            margin: 16px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 28px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin: 0 0 8px;
            color: #1e293b;
            font-size: 26px;
            text-align: center;
        }

        .subtitle {
            margin-bottom: 28px;
            color: #64748b;
            text-align: center;
            font-size: 14px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-weight: bold;
            font-size: 14px;
        }

        input {
            width: 100%;
            height: 44px;
            padding: 10px 12px;
            margin-bottom: 20px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #2563eb;
        }

        button {
            width: 100%;
            height: 46px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .error {
            margin-bottom: 18px;
            padding: 12px;
            border-radius: 6px;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 14px;
        }
    </style>
</head>

<body>
    <main class="login-container">
        <h1>Sistema de Inventario</h1>
        <p class="subtitle">Ingresa tus credenciales para continuar</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error" role="alert">
                Usuario o contraseña incorrectos, o faltan datos.
            </div>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/login"
              method="POST">

            <label for="usuario">Usuario</label>
            <input type="text"
                   id="usuario"
                   name="usuario"
                   placeholder="Ingresa tu usuario"
                   autocomplete="username"
                   required>

            <label for="password">Contraseña</label>
            <input type="password"
                   id="password"
                   name="password"
                   placeholder="Ingresa tu contraseña"
                   autocomplete="current-password"
                   required>

            <button type="submit">
                Iniciar sesión
            </button>
        </form>
    </main>
</body>
</html>
