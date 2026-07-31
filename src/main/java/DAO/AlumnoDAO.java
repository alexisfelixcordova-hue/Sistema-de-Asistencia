package DAO;

import Conexion.ConexionDB;
import Modelo.Alumno;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * AlumnoDAO - CRUD de alumnos filtrado por docente y curso
 */
public class AlumnoDAO {
    
    /**
     * Verificar si un código de alumno ya existe en la base de datos
     */
    public boolean existeCodigo(String codigo) {
        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM alumnos WHERE codigo = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, codigo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    existe = true;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar código existente: " + e.getMessage());
        }
        return existe;
    }
    
    /**
     * Listar alumnos por docente con filtros dinámicos (Búsqueda, Curso, Semestre, Turno, Estado)
     */
    public List<Alumno> listarConFiltros(int idDocente, String buscar, String idCurso, String semestre, String turno, String estado) {
        List<Alumno> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, c.nombre AS nombre_curso FROM alumnos a " +
            "LEFT JOIN cursos c ON a.id_curso = c.id " +
            "WHERE a.id_docente = ?"
        );
        
        List<Object> parametros = new ArrayList<>();
        parametros.add(idDocente);
        
        if (buscar != null && !buscar.trim().isEmpty()) {
            sql.append(" AND (a.codigo LIKE ? OR a.nombre LIKE ? OR a.apellido LIKE ?)");
            String patron = "%" + buscar.trim() + "%";
            parametros.add(patron);
            parametros.add(patron);
            parametros.add(patron);
        }
        
        if (idCurso != null && !idCurso.trim().isEmpty()) {
            sql.append(" AND a.id_curso = ?");
            parametros.add(Integer.parseInt(idCurso));
        }
        
        if (semestre != null && !semestre.trim().isEmpty()) {
            sql.append(" AND a.semestre = ?");
            parametros.add(semestre);
        }
        
        if (turno != null && !turno.trim().isEmpty()) {
            sql.append(" AND a.turno = ?");
            parametros.add(turno);
        }
        
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append(" AND a.estado = ?");
            parametros.add(estado);
        } else {
            sql.append(" AND a.estado = 'Activo'");
        }
        
        sql.append(" ORDER BY a.id DESC");
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearAlumno(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar alumnos con filtros: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Listar todos los alumnos activos de UN DOCENTE ESPECÍFICO (Compatibilidad)
     */
    public List<Alumno> listarPorDocente(int idDocente) {
        return listarConFiltros(idDocente, null, null, null, null, "Activo");
    }

    /**
     * Mantener compatibilidad si se requiere listar todos de manera general
     */
    public List<Alumno> listarTodos() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT a.*, c.nombre AS nombre_curso FROM alumnos a LEFT JOIN cursos c ON a.id_curso = c.id WHERE a.estado = 'Activo' ORDER BY a.id DESC";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                lista.add(mapearAlumno(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error al listar alumnos: " + e.getMessage());
        }
        return lista;
    }
    
    /**
     * Buscar alumno por codigo
     */
    public Alumno buscarPorCodigo(String codigo) {
        String sql = "SELECT a.*, c.nombre AS nombre_curso FROM alumnos a LEFT JOIN cursos c ON a.id_curso = c.id WHERE a.codigo = ? AND a.estado = 'Activo'";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, codigo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearAlumno(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar alumno: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Obtener alumno por ID (Incluyendo nombre del curso)
     */
    public Alumno obtenerPorId(int id) {
        String sql = "SELECT a.*, c.nombre AS nombre_curso FROM alumnos a LEFT JOIN cursos c ON a.id_curso = c.id WHERE a.id = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearAlumno(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener alumno: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Insertar nuevo alumno vinculado a un docente específico y un curso
     */
    public boolean insertarConDocente(Alumno alumno, int idDocente) {
        String sql = "INSERT INTO alumnos (codigo, nombre, apellido, id_curso, semestre, turno, email, telefono, estado, id_docente) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Activo', ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, alumno.getCodigo());
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getApellido());
            ps.setInt(4, alumno.getIdCurso());
            ps.setString(5, alumno.getSemestre());
            ps.setString(6, alumno.getTurno());
            ps.setString(7, alumno.getEmail());
            ps.setString(8, alumno.getTelefono());
            ps.setInt(9, idDocente);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al insertar alumno con docente: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Actualizar alumno (Incluyendo id_curso, semestre, turno, direccion, acudiente, telefono_acudiente)
     */
    public boolean actualizar(Alumno alumno) {
        String sql = "UPDATE alumnos SET codigo=?, nombre=?, apellido=?, id_curso=?, semestre=?, turno=?, email=?, " +
                     "telefono=?, direccion=?, acudiente=?, telefono_acudiente=? WHERE id=?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, alumno.getCodigo());
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getApellido());
            ps.setInt(4, alumno.getIdCurso());
            ps.setString(5, alumno.getSemestre());
            ps.setString(6, alumno.getTurno());
            ps.setString(7, alumno.getEmail());
            ps.setString(8, alumno.getTelefono());
            ps.setString(9, alumno.getDireccion());
            ps.setString(10, alumno.getAcudiente());
            ps.setString(11, alumno.getTelefonoAcudiente());
            ps.setInt(12, alumno.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar alumno: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Eliminar alumno físicamente de la base de datos
     */
    public boolean eliminar(int id) {
        String sql = "DELETE FROM alumnos WHERE id = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar alumno físicamente: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Contar total de alumnos de un docente específico
     */
    public int contarTotalPorDocente(int idDocente) {
        String sql = "SELECT COUNT(*) FROM alumnos WHERE estado = 'Activo' AND id_docente = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idDocente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al contar alumnos por docente: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Mapear ResultSet a Alumno (Incluyendo campos de curso y carrera)
     */
    private Alumno mapearAlumno(ResultSet rs) throws SQLException {
        Alumno a = new Alumno();
        a.setId(rs.getInt("id"));
        a.setCodigo(rs.getString("codigo"));
        a.setNombre(rs.getString("nombre"));
        a.setApellido(rs.getString("apellido"));
        a.setIdCurso(rs.getInt("id_curso"));
        
        try {
            a.setNombreCurso(rs.getString("nombre_curso"));
        } catch (SQLException e) {
            a.setNombreCurso("Sin curso");
        }
        
        a.setSemestre(rs.getString("semestre"));
        a.setTurno(rs.getString("turno"));
        a.setEmail(rs.getString("email"));
        a.setTelefono(rs.getString("telefono"));
        
        try { a.setDireccion(rs.getString("direccion")); } catch (Exception e) {}
        try { a.setAcudiente(rs.getString("acudiente")); } catch (Exception e) {}
        try { a.setTelefonoAcudiente(rs.getString("telefono_acudiente")); } catch (Exception e) {}
        
        // Mapeo seguro para la carrera del alumno
        try { 
            a.setCarrera(rs.getString("carrera")); 
        } catch (Exception e) { 
            a.setCarrera("No especificada"); 
        }
        
        a.setEstado(rs.getString("estado"));
        return a;
    }

    /**
     * Validar inicio de sesión de alumno por usuario y contraseña
     */
    public Alumno validarLogin(String usuario, String password) {
        Alumno alumno = null;
        String sql = "SELECT a.*, c.nombre AS nombre_curso FROM alumnos a LEFT JOIN cursos c ON a.id_curso = c.id WHERE a.usuario = ? AND a.password = ? AND a.estado = 'Activo'";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, usuario);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    alumno = mapearAlumno(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al validar login de alumno: " + e.getMessage());
        }
        return alumno;
    }

    /**
     * Registrar un nuevo alumno públicamente con usuario y contraseña
     */
    public boolean registrarPublico(Alumno alumno) {
        String sql = "INSERT INTO alumnos (codigo, nombre, apellido, semestre, usuario, password, estado) VALUES (?, ?, ?, ?, ?, ?, 'Activo')";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Generar código automático ya que el formulario público no lo solicita directamente
            String codigoAuto = "ALU" + System.currentTimeMillis() % 10000;
            
            ps.setString(1, codigoAuto);
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getApellido());
            ps.setString(4, alumno.getSemestre());
            ps.setString(5, alumno.getUsuario());
            ps.setString(6, alumno.getPassword());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al registrar alumno públicamente: " + e.getMessage());
            return false;
        }
    }
}