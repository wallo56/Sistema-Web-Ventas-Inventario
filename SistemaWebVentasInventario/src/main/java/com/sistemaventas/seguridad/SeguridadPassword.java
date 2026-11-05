
package com.sistemaventas.seguridad;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class SeguridadPassword {

    private static final int ITERACIONES_MINIMAS = 600000;
    private static final int LONGITUD_HASH = 256;

    public static boolean verificar(
            String passwordIngresada,
            String passwordAlmacenada) {

        if (passwordIngresada == null
                || passwordAlmacenada == null) {
            return false;
        }

        String[] partes = passwordAlmacenada.split("\\$", -1);

        if (partes.length != 4
                || !partes[0].equals("PBKDF2-SHA256")) {
            return false;
        }

        char[] caracteres = passwordIngresada.toCharArray();
        PBEKeySpec especificacion = null;

        try {
            int iteraciones = Integer.parseInt(partes[1]);

            if (iteraciones < ITERACIONES_MINIMAS
                    || iteraciones > 2000000) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(partes[2]);
            byte[] hashEsperado =
                    Base64.getDecoder().decode(partes[3]);

            if (salt.length < 16 || hashEsperado.length != 32) {
                return false;
            }

            especificacion = new PBEKeySpec(
                    caracteres,
                    salt,
                    iteraciones,
                    LONGITUD_HASH
            );

            SecretKeyFactory fabrica =
                    SecretKeyFactory.getInstance(
                            "PBKDF2WithHmacSHA256"
                    );

            byte[] hashCalculado =
                    fabrica.generateSecret(especificacion)
                           .getEncoded();

            return MessageDigest.isEqual(
                    hashCalculado,
                    hashEsperado
            );

        } catch (IllegalArgumentException
                 | NoSuchAlgorithmException
                 | InvalidKeySpecException e) {

            return false;

        } finally {
            if (especificacion != null) {
                especificacion.clearPassword();
            }
            java.util.Arrays.fill(caracteres, '\0');
        }
    }
}
