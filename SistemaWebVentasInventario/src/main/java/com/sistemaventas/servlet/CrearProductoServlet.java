
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
import java.math.BigDecimal;
import java.sql.SQLException;


import java.security.SecureRandom;
import java.util.Base64;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@WebServlet("/productos/crear")
public class CrearProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");

        if (!estaAutenticado(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }


HttpSession sesion = request.getSession(false);

String token = (String) sesion.getAttribute("csrfToken");

if (token == null) {
    byte[] bytes = new byte[32];
    new SecureRandom().nextBytes(bytes);

    token = Base64.getUrlEncoder()
            .withoutPadding()
            .encodeToString(bytes);

    sesion.setAttribute("csrfToken", token);
}

request.setAttribute("csrfToken", token);

request.getRequestDispatcher(
        "/WEB-INF/crear-producto.jsp"
).forward(request, response);

    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        if (!estaAutenticado(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }
        

HttpSession sesion = request.getSession(false);

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


        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precioTexto = request.getParameter("precio");
        String stockTexto = request.getParameter("stock");

        try {
            if (nombre == null || nombre.isBlank()
                    || nombre.trim().length() > 100) {
                throw new IllegalArgumentException(
                        "El nombre es obligatorio y debe tener máximo 100 caracteres."
                );
            }

            if (descripcion != null
                    && descripcion.length() > 255) {
                throw new IllegalArgumentException(
                        "La descripción no puede superar 255 caracteres."
                );
            }

            if (precioTexto == null || precioTexto.isBlank()
                    || stockTexto == null || stockTexto.isBlank()) {
                throw new IllegalArgumentException(
                        "El precio y el stock son obligatorios."
                );
            }

            BigDecimal precio =
                    new BigDecimal(precioTexto.trim());

            int stock = Integer.parseInt(stockTexto.trim());

            if (precio.signum() < 0 || precio.scale() > 2
                    || stock < 0) {
                throw new IllegalArgumentException(
                        "El precio y el stock deben ser válidos y no negativos."
                );
            }

            Producto producto = new Producto();

            producto.setNombre(nombre.trim());
            producto.setDescripcion(descripcion);
            producto.setPrecio(precio);
            producto.setStock(stock);

            boolean registrado =
                    productoDAO.agregarProducto(producto);

            if (registrado) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/productos?registrado=1"
                );
                return;
            }

            mostrarError(
                    request,
                    response,
                    "No fue posible registrar el producto."
            );

        } catch (NumberFormatException e) {

            mostrarError(
                    request,
                    response,
                    "El precio o el stock tienen un formato incorrecto."
            );

        } catch (IllegalArgumentException e) {

            mostrarError(request, response, e.getMessage());

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al registrar producto", e
            );

            mostrarError(
                    request,
                    response,
                    "Ocurrió un error al guardar el producto."
            );
        }
    }

    private boolean estaAutenticado(
            HttpServletRequest request) {

        HttpSession sesion = request.getSession(false);

        return sesion != null
                && sesion.getAttribute("usuario")
                instanceof Usuario;
    }

    private void mostrarError(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute("error", mensaje);

        request.getRequestDispatcher(
                "/WEB-INF/crear-producto.jsp"
        ).forward(request, response);
    }
}
