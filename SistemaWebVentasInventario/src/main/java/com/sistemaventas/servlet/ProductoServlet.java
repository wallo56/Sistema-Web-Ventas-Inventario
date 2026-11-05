package com.sistemaventas.servlet;

import com.sistemaventas.dao.ProductoDAO;
import com.sistemaventas.modelo.Producto;
import com.sistemaventas.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/productos")
public class ProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        // Comprobar que exista una sesión activa.
        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        Object usuarioSesion = sesion.getAttribute("usuario");

        if (!(usuarioSesion instanceof Usuario)) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        Usuario usuario = (Usuario) usuarioSesion;
        

        String csrfToken =
                (String) sesion.getAttribute("csrfToken");

        if (csrfToken == null) {

            byte[] bytes = new byte[32];

            new SecureRandom().nextBytes(bytes);

            csrfToken = Base64.getUrlEncoder()
                    .withoutPadding()
                    .encodeToString(bytes);

            sesion.setAttribute("csrfToken", csrfToken);
        }

        request.setAttribute("csrfToken", csrfToken);
        

        try {
            // Consultar productos activos en PostgreSQL.
            List<Producto> productos =
                    productoDAO.listarProductos();

            // Compartir datos con la página JSP.
            request.setAttribute("productos", productos);
            request.setAttribute("usuarioActual", usuario);

            // Mostrar la página de productos.
            request.getRequestDispatcher(
                    "/WEB-INF/productos.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            // Registrar el error sin mostrar detalles al usuario.
            getServletContext().log(
                    "Error al consultar los productos", e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No fue posible consultar los productos."
            );
        }
    }
}
