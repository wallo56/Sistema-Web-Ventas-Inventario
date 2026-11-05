
package com.sistemaventas.seguridad;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class GeneradorPassword {

    public static String generarHash(char[] password)
            throws Exception {

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        int iteraciones = 600000;

        KeySpec especificacion = new PBEKeySpec(
                password, salt, iteraciones, 256
        );

        SecretKeyFactory fabrica =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256"
                );

        byte[] hash =
                fabrica.generateSecret(especificacion)
                       .getEncoded();

        return "PBKDF2-SHA256$"
                + iteraciones + "$"
                + Base64.getEncoder().encodeToString(salt) + "$"
                + Base64.getEncoder().encodeToString(hash);
    }
}
