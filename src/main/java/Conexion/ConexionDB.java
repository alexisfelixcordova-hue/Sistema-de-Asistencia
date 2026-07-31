package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * ConexionDB - Conecta con MySQL Workbench
 */
public class ConexionDB {
    
    // ============================================
    // CONFIGURACION DE MySQL - CAMBIA EL PASSWORD
    // ============================================
    private static final String URL = "jdbc:mysql://localhost:3306/registro_estudiantes?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";
    private static final String USUARIO = "root";
    private static final String PASSWORD = "";  // <-- CAMBIA ESTO POR TU PASSWORD DE MySQL
    
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