
package com.sistemaventas.servlet;

import com.sistemaventas.dao.ProductoDAO;
import com.sistemaventas.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;

@WebServlet("/productos/eliminar")
public class EliminarProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // La eliminación no se permite mediante GET.
        response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "Esta operación requiere una solicitud POST."
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        // Verificar que exista una sesión autenticada.
        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || !(sesion.getAttribute("usuario")
                        instanceof Usuario)) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }


        // Verificar que el usuario sea ADMINISTRADOR.
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (!"ADMINISTRADOR".equalsIgnoreCase(
                usuario.getNombreRol())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para eliminar productos."
            );
            return;
        }
        
        
        // Validar el token CSRF.
        String tokenSesion =
                (String) sesion.getAttribute("csrfToken");

        String tokenFormulario =
                request.getParameter("csrfToken");

        if (tokenSesion == null
                || tokenFormulario == null
                || !MessageDigest.isEqual(
                        tokenSesion.getBytes(StandardCharsets.UTF_8),
                        tokenFormulario.getBytes(StandardCharsets.UTF_8))) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Solicitud no autorizada."
            );
            return;
        }

        // Obtener el identificador del producto.
        int idProducto;

        try {
            idProducto = Integer.parseInt(
                    request.getParameter("id")
            );

            if (idProducto <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Identificador de producto no válido."
                );
                return;
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Identificador de producto no válido."
            );
            return;
        }

        // Desactivar el producto en PostgreSQL.
        try {
            boolean eliminado =
                    productoDAO.eliminarProducto(idProducto);

            if (!eliminado) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Producto no encontrado o ya inactivo."
                );
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/productos?eliminado=1"
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al desactivar producto", e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No fue posible desactivar el producto."
            );
        }
    }
}
