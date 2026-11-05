package com.sistemaventas.dao;

import com.sistemaventas.config.ConexionBD;
import com.sistemaventas.modelo.Producto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listarProductos() throws SQLException {

        List<Producto> productos = new ArrayList<>();

        String sql = """
            SELECT id_producto, nombre, descripcion, precio, stock, estado
            FROM productos
            WHERE estado = 'A'
            ORDER BY id_producto
            """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement consulta =
                     conexion.prepareStatement(sql);
             ResultSet resultado = consulta.executeQuery()) {

            while (resultado.next()) {

                Producto producto = new Producto();

                producto.setIdProducto(
                        resultado.getInt("id_producto"));

                producto.setNombre(
                        resultado.getString("nombre"));

                producto.setDescripcion(
                        resultado.getString("descripcion"));

                producto.setPrecio(
                        resultado.getBigDecimal("precio"));

                
                producto.setStock(
                    resultado.getInt("stock"));

                producto.setEstado(
                    resultado.getString("estado"));

                productos.add(producto);

            }
        }

        return productos;
    }

public boolean agregarProducto(Producto producto) throws SQLException {

    if (producto == null
            || producto.getNombre() == null
            || producto.getNombre().isBlank()
            || producto.getNombre().length() > 100
            || producto.getDescripcion() != null
               && producto.getDescripcion().length() > 255
            || producto.getPrecio() == null
            || producto.getPrecio().signum() < 0
            || producto.getPrecio().scale() > 2
            || producto.getStock() < 0) {

        throw new IllegalArgumentException(
                "Los datos del producto no son válidos"
        );
    }

    String sql = """
        INSERT INTO productos (nombre, descripcion, precio, stock)
        VALUES (?, ?, ?, ?)
        """;

    try (Connection conexion = ConexionBD.obtenerConexion();
         PreparedStatement consulta =
                 conexion.prepareStatement(sql)) {

        consulta.setString(1, producto.getNombre().trim());
        consulta.setString(2, producto.getDescripcion());
        consulta.setBigDecimal(3, producto.getPrecio());
        consulta.setInt(4, producto.getStock());

        return consulta.executeUpdate() == 1;
    }
}

public boolean actualizarProducto(Producto producto) throws SQLException {

    if (producto == null
            || producto.getIdProducto() <= 0
            || producto.getNombre() == null
            || producto.getNombre().isBlank()
            || producto.getNombre().length() > 100
            || (producto.getDescripcion() != null
                && producto.getDescripcion().length() > 255)
            || producto.getPrecio() == null
            || producto.getPrecio().signum() < 0
            || producto.getPrecio().scale() > 2
            || producto.getStock() < 0) {

        throw new IllegalArgumentException(
                "Los datos del producto no son válidos"
        );
    }

    String sql = """
        UPDATE productos
        SET nombre = ?,
            descripcion = ?,
            precio = ?,
            stock = ?
        WHERE id_producto = ?
        """;

    try (Connection conexion = ConexionBD.obtenerConexion();
         PreparedStatement consulta =
                 conexion.prepareStatement(sql)) {

        consulta.setString(1, producto.getNombre().trim());
        consulta.setString(2, producto.getDescripcion());
        consulta.setBigDecimal(3, producto.getPrecio());
        consulta.setInt(4, producto.getStock());
        consulta.setInt(5, producto.getIdProducto());

        return consulta.executeUpdate() == 1;
    }
}


public boolean eliminarProducto(int idProducto) throws SQLException {

    if (idProducto <= 0) {
        throw new IllegalArgumentException(
                "El identificador del producto no es válido"
        );
    }

    String sql = """
        UPDATE productos
        SET estado = 'I'
        WHERE id_producto = ?
          AND estado = 'A'
        """;

    try (Connection conexion = ConexionBD.obtenerConexion();
         PreparedStatement consulta =
                 conexion.prepareStatement(sql)) {

        consulta.setInt(1, idProducto);

        return consulta.executeUpdate() == 1;
    }
}


public Producto obtenerProductoPorId(int idProducto)
        throws SQLException {

    if (idProducto <= 0) {
        throw new IllegalArgumentException(
                "El identificador del producto no es válido"
        );
    }

    String sql = """
        SELECT id_producto, nombre, descripcion,
               precio, stock, estado
        FROM productos
        WHERE id_producto = ?
          AND estado = 'A'
        """;

    try (Connection conexion = ConexionBD.obtenerConexion();
         PreparedStatement consulta =
                 conexion.prepareStatement(sql)) {

        consulta.setInt(1, idProducto);

        try (ResultSet resultado = consulta.executeQuery()) {

            if (resultado.next()) {

                Producto producto = new Producto();

                producto.setIdProducto(
                        resultado.getInt("id_producto")
                );

                producto.setNombre(
                        resultado.getString("nombre")
                );

                producto.setDescripcion(
                        resultado.getString("descripcion")
                );

                producto.setPrecio(
                        resultado.getBigDecimal("precio")
                );

                producto.setStock(
                        resultado.getInt("stock")
                );

                producto.setEstado(
                        resultado.getString("estado")
                );

                return producto;
            }
        }
    }

    return null;
}

}
