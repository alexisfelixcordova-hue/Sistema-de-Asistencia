package DAO;

import Conexion.ConexionDB;
import Modelo.Curso;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CursoDAO {

    // --- LO QUE YA TENÍAS FUNCIONANDO (Intacto) ---
    public List<Curso> listarPorDocente(int idDocente) {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT * FROM cursos WHERE id_docente = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idDocente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Curso c = new Curso();
                    c.setId(rs.getInt("id"));
                    c.setNombre(rs.getString("nombre"));
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar cursos por docente: " + e.getMessage());
        }
        return lista;
    }

    // --- NUEVO: Listar todos los cursos disponibles para que el alumno pueda unirse ---
    public List<Curso> listarCursosDisponibles() {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT * FROM cursos";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Curso c = new Curso();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                // Si tienes las columnas adicionales en tu BD, las cargamos de forma segura
                try { c.setCarrera(rs.getString("carrera")); } catch (Exception ignored) {}
                try { c.setIdDocente(rs.getInt("id_docente")); } catch (Exception ignored) {}
                try { c.setCodigoAcceso(rs.getString("codigo_acceso")); } catch (Exception ignored) {}
                lista.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar cursos disponibles: " + e.getMessage());
        }
        return lista;
    }

    // --- NUEVO: Listar solo los cursos en los que un alumno específico está matriculado ---
    public List<Curso> obtenerCursosPorAlumno(int idAlumno) {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT c.* FROM cursos c JOIN alumno_curso ac ON c.id = ac.id_curso WHERE ac.id_alumno = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAlumno);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Curso c = new Curso();
                    c.setId(rs.getInt("id"));
                    c.setNombre(rs.getString("nombre"));
                    try { c.setCarrera(rs.getString("carrera")); } catch (Exception ignored) {}
                    try { c.setIdDocente(rs.getInt("id_docente")); } catch (Exception ignored) {}
                    try { c.setCodigoAcceso(rs.getString("codigo_acceso")); } catch (Exception ignored) {}
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar cursos del alumno: " + e.getMessage());
        }
        return lista;
    }

    // --- NUEVO: Método para que el alumno se una a un curso ---
    public boolean unirAlumnoACurso(int idAlumno, int idCurso) {
        String sql = "INSERT INTO alumno_curso (id_alumno, id_curso) VALUES (?, ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAlumno);
            ps.setInt(2, idCurso);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            // Retorna falso si ya estaba inscrito o ocurre un error
            return false;
        }
    }
}