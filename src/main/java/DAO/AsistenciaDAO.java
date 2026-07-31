package DAO;

import Conexion.ConexionDB;
import Modelo.Asistencia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AsistenciaDAO {
    Connection con;
    ConexionDB cn = new ConexionDB();
    PreparedStatement ps;
    ResultSet rs;

    // Método para listar todas las asistencias
    public List<Asistencia> listarAsistencias() {
        List<Asistencia> lista = new ArrayList<>();
        String sql = "SELECT * FROM asistencias ORDER BY id DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Asistencia asistencia = new Asistencia();
                asistencia.setId(rs.getInt("id"));
                asistencia.setIdAlumno(rs.getInt("id_alumno"));
                asistencia.setFecha(rs.getString("fecha"));
                asistencia.setHoraEntrada(rs.getString("hora_entrada"));
                asistencia.setEstado(rs.getString("estado"));
                asistencia.setObservacion(rs.getString("observacion"));
                lista.add(asistencia);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar asistencias: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException ignored) {}
        }
        return lista;
    }

    // Método flexible para registrar asistencia manual permitiendo definir hora límite y tolerancia en minutos
    public boolean registrarAsistenciaFlexible(int idAlumno, String horaLimite, int minutosTolerancia) {
        // Lógica SQL: Compara la hora actual con la hora límite + los minutos de tolerancia definidos
        String sql = "INSERT INTO asistencias (id_alumno, fecha, hora_entrada, estado) " +
                     "VALUES (?, CURDATE(), CURTIME(), " +
                     "IF(CURTIME() <= ADDTIME(?, SEC_TO_TIME(? * 60)), 'Presente', 'Tarde'))";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idAlumno);
            ps.setString(2, horaLimite);          // Ej: "08:00:00"
            ps.setInt(3, minutosTolerancia);      // Ej: 15 minutos de tolerancia
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error al registrar asistencia flexible: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException ignored) {}
        }
    }

    // Método estándar que ya usabas (por compatibilidad, usa por defecto 08:15:00)
    public boolean registrarAsistencia(Asistencia asistencia) {
        return registrarAsistenciaFlexible(asistencia.getIdAlumno(), "08:00:00", 15);
    }

    // Método para que el alumno vea su historial de asistencias en su dashboard
    public List<Asistencia> obtenerAsistenciasPorAlumno(int idAlumno) {
        List<Asistencia> lista = new ArrayList<>();
        String sql = "SELECT * FROM asistencias WHERE id_alumno = ? ORDER BY id DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idAlumno);
            rs = ps.executeQuery();
            while (rs.next()) {
                Asistencia asistencia = new Asistencia();
                asistencia.setId(rs.getInt("id"));
                asistencia.setIdAlumno(rs.getInt("id_alumno"));
                asistencia.setFecha(rs.getString("fecha"));
                asistencia.setHoraEntrada(rs.getString("hora_entrada"));
                asistencia.setEstado(rs.getString("estado"));
                asistencia.setObservacion(rs.getString("observacion"));
                lista.add(asistencia);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar asistencias del alumno: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException ignored) {}
        }
        return lista;
    }

    // Método para que el alumno registre su asistencia escaneando el código QR
    public boolean registrarAsistenciaPorQR(int idAlumno, String codigoClase) {
        // Escaneando por QR usa la regla general flexible (Ej: límite 08:00 AM con 15 min de tolerancia)
        return registrarAsistenciaFlexible(idAlumno, "08:00:00", 15);
    }

    // Método para validar si el alumno ya registró asistencia hoy
    public boolean existeAsistenciaHoy(int idAlumno, String fecha) {
        boolean existe = false;
        String sql = "SELECT * FROM asistencias WHERE id_alumno = ? AND fecha = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idAlumno);
            ps.setString(2, fecha);
            rs = ps.executeQuery();
            if (rs.next()) {
                existe = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar asistencia de hoy: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException ignored) {}
        }
        return existe;
    }

    /**
     * NUEVO: Método para considerar una FALTA (Ausente).
     * Registra automáticamente como 'Ausente' a todos los alumnos matriculados que 
     * NO hayan marcado su asistencia al finalizar el día actual.
     */
    public void procesarFaltasDelDia() {
        String sql = "INSERT INTO asistencias (id_alumno, fecha, estado, observacion) " +
                     "SELECT id, CURDATE(), 'Ausente', 'Falta automática por no registro' " +
                     "FROM alumnos WHERE id NOT IN " +
                     "(SELECT id_alumno FROM asistencias WHERE fecha = CURDATE())";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.executeUpdate();
            System.out.println("Faltas procesadas exitosamente para el día de hoy.");
        } catch (SQLException e) {
            System.out.println("Error al procesar las faltas automáticas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException ignored) {}
        }
    }
}