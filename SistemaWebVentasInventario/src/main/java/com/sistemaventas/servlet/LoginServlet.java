
package com.sistemaventas.servlet;

import com.sistemaventas.dao.UsuarioDAO;
import com.sistemaventas.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion != null
                && sesion.getAttribute("usuario") != null) {

            response.sendRedirect(
                    request.getContextPath() + "/dashboard"
            );
            return;
        }

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombreUsuario =
                request.getParameter("usuario");

        String password =
                request.getParameter("password");
        

        if (nombreUsuario == null
                || nombreUsuario.isBlank()
                || password == null
                || password.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Debes ingresar usuario y contraseña."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        try {
            Usuario usuario = usuarioDAO.autenticar(
                    nombreUsuario.trim(), password
            );
            


            if (usuario == null) {

                request.setAttribute(
                        "error",
                        "Usuario o contraseña incorrectos."
                );

                request.getRequestDispatcher("/login.jsp")
                        .forward(request, response);
                return;
            }

            HttpSession sesionAnterior =
                    request.getSession(false);

            if (sesionAnterior != null) {
                sesionAnterior.invalidate();
            }

            HttpSession sesion = request.getSession(true);

            sesion.setAttribute("usuario", usuario);
            sesion.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(
                    request.getContextPath() + "/dashboard"
            );

        } catch (SQLException e) {

            log("Error durante la autenticación", e);

            request.setAttribute(
                    "error",
                    "No se pudo iniciar sesión. Intenta nuevamente."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
        }
    }
}
