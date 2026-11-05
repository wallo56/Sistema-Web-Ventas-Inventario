
package com.sistemaventas.dao;

import com.sistemaventas.config.ConexionBD;
import com.sistemaventas.modelo.Usuario;
import com.sistemaventas.seguridad.SeguridadPassword;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario autenticar(String nombreUsuario,
                             String password) throws SQLException {

        if (nombreUsuario == null || nombreUsuario.isBlank()
                || password == null || password.isEmpty()) {
            return null;
        }

        String sql = """
            SELECT u.id_usuario, u.usuario, u.password,
                   u.estado, u.id_rol, r.nombre AS nombre_rol
            FROM usuario u
            INNER JOIN rol r ON u.id_rol = r.id_rol
            WHERE u.usuario = ?
              AND u.estado = 'A'
            """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement consulta =
                     conexion.prepareStatement(sql)) {

            consulta.setString(1, nombreUsuario.trim());

            try (ResultSet resultado = consulta.executeQuery()) {

                if (!resultado.next()) {
                    return null;
                }

                String hashAlmacenado =
                        resultado.getString("password");

                if (!SeguridadPassword.verificar(
                        password, hashAlmacenado)) {
                    return null;
                }

                Usuario usuario = new Usuario();

                usuario.setIdUsuario(
                        resultado.getInt("id_usuario"));
                usuario.setUsuario(
                        resultado.getString("usuario"));
                usuario.setEstado(
                        resultado.getString("estado"));
                usuario.setIdRol(
                        resultado.getInt("id_rol"));
                usuario.setNombreRol(
                        resultado.getString("nombre_rol"));

                return usuario;
            }
        }
    }
}
