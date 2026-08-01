package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * ConexionDB - Conecta con MySQL
 * 
 * En Railway, lee la configuración desde variables de entorno.
 * En tu PC (desarrollo local), si esas variables no existen, usa los valores
 * de respaldo (localhost) para que sigas trabajando igual que antes.
 */
public class ConexionDB {

    // Lee cada variable de entorno; si no existe, usa el valor de respaldo (localhost)
    private static final String HOST = getEnvOrDefault("MYSQLHOST", "localhost");
    private static final String PORT = getEnvOrDefault("MYSQLPORT", "3306");
    private static final String DATABASE = getEnvOrDefault("MYSQLDATABASE", "registro_estudiantes");
    private static final String USUARIO = getEnvOrDefault("MYSQLUSER", "root");
    private static final String PASSWORD = getEnvOrDefault("MYSQLPASSWORD", "");

    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
            + "?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";

    private static String getEnvOrDefault(String nombre, String valorPorDefecto) {
        String valor = System.getenv(nombre);
        return (valor != null && !valor.isEmpty()) ? valor : valorPorDefecto;
    }

    /**
     * Obtiene conexion a la base de datos
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Cargar driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Conectar
            conn = DriverManager.getConnection(URL, USUARIO, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.out.println("ERROR: No se encontro el driver de MySQL");
            System.out.println("Descarga el driver JDBC de MySQL y agregalo al proyecto");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("ERROR al conectar: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }

    /**
     * Cierra la conexion
     */
    public static void close(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}