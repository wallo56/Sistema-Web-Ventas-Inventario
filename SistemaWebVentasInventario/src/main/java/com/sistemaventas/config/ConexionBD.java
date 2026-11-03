package com.sistemaventas.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {


    private static final String URL =
            System.getenv("DB_URL") != null
            && !System.getenv("DB_URL").isBlank()
            ? System.getenv("DB_URL")
            : "jdbc:postgresql://localhost:5432/sistema_inventario_web";

    private static final String USUARIO = "app_inventario";


    public static Connection obtenerConexion() throws SQLException {

        String password = System.getenv("DB_PASSWORD");
        
        if (password == null || password.isBlank()) {
            throw new SQLException(
                "No se ha configurado la variable DB_PASSWORD"
            );
        }

        

try {
    Class.forName("org.postgresql.Driver");
} catch (ClassNotFoundException e) {
    throw new SQLException(
        "No se pudo cargar el controlador PostgreSQL", e
    );
}

        return DriverManager.getConnection(
                URL,
                USUARIO,
                password
        );
    }
}