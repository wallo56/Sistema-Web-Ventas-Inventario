
package com.sistemaventas.config;

import com.sistemaventas.dao.UsuarioDAO;
import com.sistemaventas.modelo.Usuario;

import java.io.Console;
import java.sql.SQLException;
import java.util.Arrays;

public class PruebaConexion {

    public static void main(String[] args) {

        Console consola = System.console();

        if (consola == null) {
            System.out.println(
                    "Ejecuta esta prueba desde CMD."
            );
            return;
        }

        char[] caracteres = consola.readPassword(
                "Contraseña del usuario admin: "
        );

        if (caracteres == null) {
            return;
        }

        try {
            String password = new String(caracteres);

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.autenticar(
                    "admin", password
            );

            if (usuario != null) {
                System.out.println("AUTENTICACION EXITOSA");
                System.out.println(
                        "Usuario: " + usuario.getUsuario()
                );
                System.out.println(
                        "Rol: " + usuario.getNombreRol()
                );
            } else {
                System.out.println("CREDENCIALES INCORRECTAS");
            }

        } catch (SQLException e) {
            System.out.println("ERROR DE BASE DE DATOS");
            System.out.println(e.getMessage());

        } finally {
            Arrays.fill(caracteres, '\0');
        }
    }
}
