
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
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Base64;

@WebServlet("/productos/actualizar")
public class ActualizarProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");

        HttpSession sesion = obtenerSesionAutenticada(request);

        if (sesion == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        try {
            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            Producto producto =
                    productoDAO.obtenerProductoPorId(id);

            if (producto == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Producto no encontrado."
                );
                return;
            }

            String token = obtenerToken(sesion);

            request.setAttribute("producto", producto);
            request.setAttribute("csrfToken", token);

            request.getRequestDispatcher(
                    "/WEB-INF/editar-producto.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Identificador de producto no válido."
            );

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Identificador de producto no válido."
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al consultar producto", e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No fue posible consultar el producto."
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        HttpSession sesion = obtenerSesionAutenticada(request);

        if (sesion == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

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

        try {
            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            Producto existente =
                    productoDAO.obtenerProductoPorId(id);

            if (existente == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Producto no encontrado."
                );
                return;
            }

            String nombre = request.getParameter("nombre");
            String descripcion =
                    request.getParameter("descripcion");
            String precioTexto =
                    request.getParameter("precio");
            String stockTexto =
                    request.getParameter("stock");

            if (nombre == null || nombre.isBlank()
                    || nombre.trim().length() > 100) {
                throw new IllegalArgumentException(
                        "El nombre debe tener entre 1 y 100 caracteres."
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

            if (precio.signum() < 0
                    || precio.scale() > 2
                    || stock < 0) {
                throw new IllegalArgumentException(
                        "El precio y el stock deben ser válidos y no negativos."
                );
            }

            Producto producto = new Producto();

            producto.setIdProducto(id);
            producto.setNombre(nombre.trim());
            producto.setDescripcion(descripcion);
            producto.setPrecio(precio);
            producto.setStock(stock);

            boolean actualizado =
                    productoDAO.actualizarProducto(producto);

            if (actualizado) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/productos?actualizado=1"
                );
                return;
            }

            mostrarError(
                    request,
                    response,
                    existente,
                    "No fue posible actualizar el producto."
            );

        } catch (NumberFormatException e) {

            mostrarErrorDesdeSolicitud(
                    request,
                    response,
                    "El ID, precio o stock tienen un formato incorrecto."
            );

        } catch (IllegalArgumentException e) {

            mostrarErrorDesdeSolicitud(
                    request,
                    response,
                    e.getMessage()
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al actualizar producto", e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No fue posible actualizar el producto."
            );
        }
    }

    private HttpSession obtenerSesionAutenticada(
            HttpServletRequest request) {

        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || !(sesion.getAttribute("usuario")
                        instanceof Usuario)) {
            return null;
        }

        return sesion;
    }

    private String obtenerToken(HttpSession sesion) {

        String token =
                (String) sesion.getAttribute("csrfToken");

        if (token == null) {
            byte[] bytes = new byte[32];
            new SecureRandom().nextBytes(bytes);

            token = Base64.getUrlEncoder()
                    .withoutPadding()
                    .encodeToString(bytes);

            sesion.setAttribute("csrfToken", token);
        }

        return token;
    }

    private void mostrarError(
            HttpServletRequest request,
            HttpServletResponse response,
            Producto producto,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute("producto", producto);
        request.setAttribute("error", mensaje);

        request.getRequestDispatcher(
                "/WEB-INF/editar-producto.jsp"
        ).forward(request, response);
    }

    private void mostrarErrorDesdeSolicitud(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        String idTexto = request.getParameter("id");

        try {
            int id = Integer.parseInt(idTexto);

            Producto producto =
                    productoDAO.obtenerProductoPorId(id);

            if (producto == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Producto no encontrado."
                );
                return;
            }

            mostrarError(
                    request,
                    response,
                    producto,
                    mensaje
            );

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Identificador de producto no válido."
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al consultar producto", e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No fue posible consultar el producto."
            );
        }
    }
}
