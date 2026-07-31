package DAO;

import Conexion.ConexionDB;
import Modelo.Docente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DocenteDAO {
    
    public Docente validarLogin(String usuario, String password) {
        Docente doc = null;
        String sql = "SELECT * FROM docentes WHERE usuario = ? AND password = ?";
        try {
            Connection con = ConexionDB.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                doc = new Docente();
                doc.setId(rs.getInt("id"));
                doc.setNombre(rs.getString("nombre"));
                doc.setUsuario(rs.getString("usuario"));
                doc.setEmail(rs.getString("email"));
                doc.setCarrera(rs.getString("carrera"));
                doc.setRol(rs.getString("rol"));
                doc.setEstado(rs.getString("estado"));
            }
        } catch (Exception e) {
            System.out.println("Error en login: " + e.getMessage());
        }
        return doc;
    }
    
    public boolean registrarDocente(Docente docente) {
        boolean registrado = false;
        String sql = "INSERT INTO docentes (usuario, password, nombre, email, carrera, rol, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, docente.getUsuario());
            ps.setString(2, docente.getPassword());
            ps.setString(3, docente.getNombre());
            ps.setString(4, docente.getEmail());
            ps.setString(5, docente.getCarrera());
            ps.setString(6, docente.getRol());
            ps.setString(7, docente.getEstado());
            
            int filas = ps.executeUpdate();
            if (filas > 0) {
                registrado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al registrar docente: " + e.getMessage());
        }
        return registrado;
    }
    
    public boolean validarAlumno(String codigo) {
        String sql = "SELECT * FROM alumnos WHERE codigo = ? AND estado = 'Activo'";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, codigo);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.out.println("Error al validar alumno: " + e.getMessage());
        }
        return false;
    }

    public boolean existeUsuario(String usuario) {
        String sql = "SELECT id FROM docentes WHERE usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.out.println("Error al verificar usuario existente: " + e.getMessage());
        }
        return false;
    }
}