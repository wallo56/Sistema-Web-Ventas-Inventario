
package com.sistemaventas.seguridad;

import java.io.Console;
import java.util.Arrays;

public class PruebaGeneradorPassword {

    public static void main(String[] args) {

        Console consola = System.console();

        if (consola == null) {
            System.out.println(
                "No hay consola segura disponible. " +
                "Ejecuta esta clase desde una terminal."
            );
            return;
        }

        char[] password = consola.readPassword(
                "Escribe la nueva contraseña de operador: "
        );

        if (password == null || password.length < 12) {
            System.out.println(
                "La contraseña debe tener al menos 12 caracteres."
            );
            if (password != null) {
                Arrays.fill(password, '\0');
            }
            return;
        }

        try {
            String hash = GeneradorPassword.generarHash(password);

            System.out.println("HASH GENERADO:");
            System.out.println(hash);

        } catch (Exception e) {
            System.out.println("Error al generar el hash.");

        } finally {
            Arrays.fill(password, '\0');
        }
    }
}
