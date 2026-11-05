package com.sistemaventas.servlet;

import com.sistemaventas.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        Usuario usuario = (Usuario)
                sesion.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        request.setAttribute("usuarioActual", usuario);

        request.getRequestDispatcher("/WEB-INF/dashboard.jsp")
                .forward(request, response);
    }
}
