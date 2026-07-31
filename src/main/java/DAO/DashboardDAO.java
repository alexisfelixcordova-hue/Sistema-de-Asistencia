package DAO;

import Conexion.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    // 1. Obtener total de alumnos del docente (Modificado para contar directamente por id_docente)
    public int obtenerTotalAlumnos(int idDocente) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM alumnos WHERE id_docente = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idDocente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // 2. Obtener estadísticas del día (Asistencias e Inasistencias)
    public Map<String, Integer> obtenerEstadisticasHoy(int idDocente) {
        Map<String, Integer> stats = new HashMap<>();
        int asistenciaHoy = 0;
        int inasistenciasHoy = 0;

        // Presentes o Tarde
        String sqlPresentes = "SELECT COUNT(*) FROM asistencias ast " +
                              "JOIN alumnos a ON ast.id_alumno = a.id " +
                              "WHERE ast.fecha = CURDATE() AND ast.estado IN ('Presente', 'Tarde') AND a.id_docente = ?";
        
        // Ausentes
        String sqlAusentes = "SELECT COUNT(*) FROM asistencias ast " +
                             "JOIN alumnos a ON ast.id_alumno = a.id " +
                             "WHERE ast.fecha = CURDATE() AND ast.estado = 'Ausente' AND a.id_docente = ?";

        try (Connection con = ConexionDB.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sqlPresentes)) {
                ps.setInt(1, idDocente);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) asistenciaHoy = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlAusentes)) {
                ps.setInt(1, idDocente);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) inasistenciasHoy = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        stats.put("asistenciaHoy", asistenciaHoy);
        stats.put("inasistenciasHoy", inasistenciasHoy);
        return stats;
    }

    // 3. Obtener los últimos registros de asistencia para la tabla
    public List<Map<String, String>> obtenerUltimasAsistencias(int idDocente) {
        List<Map<String, String>> lista = new ArrayList<>();
        String sql = "SELECT a.codigo, CONCAT(a.nombre, ' ', a.apellido) AS alumno, a.semestre, a.turno, ast.hora_entrada, ast.estado " +
                     "FROM asistencias ast JOIN alumnos a ON ast.id_alumno = a.id " +
                     "WHERE ast.fecha = CURDATE() AND a.id_docente = ? ORDER BY ast.hora_entrada DESC LIMIT 5";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idDocente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> reg = new HashMap<>();
                    reg.put("codigo", rs.getString("codigo"));
                    reg.put("alumno", rs.getString("alumno"));
                    reg.put("semestre", rs.getString("semestre"));
                    reg.put("turno", rs.getString("turno"));
                    reg.put("horaEntrada", rs.getString("hora_entrada"));
                    reg.put("estado", rs.getString("estado"));
                    lista.add(reg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}