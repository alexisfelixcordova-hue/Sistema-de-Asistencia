package Controlador;

import Conexion.ConexionDB;
import Modelo.Docente;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CursoServlet", urlPatterns = {"/CursoServlet"})
public class CursoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("dashboard-docente.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Docente docSesion = (Docente) session.getAttribute("docente");
        
        if (docSesion == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        int idDocente = docSesion.getId();
        
        // 1. Registrar Curso
        if ("registrarCurso".equals(accion)) {
            String nombreCurso = request.getParameter("nombreCurso");
            if (nombreCurso != null && !nombreCurso.trim().isEmpty()) {
                String cursoLimpio = nombreCurso.trim();
                String sqlCheck = "SELECT COUNT(*) FROM cursos WHERE nombre = ? AND id_docente = ?";
                String sqlInsert = "INSERT INTO cursos (nombre, id_docente) VALUES (?, ?)";
                
                try (Connection con = ConexionDB.getConnection();
                     PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                    
                    psCheck.setString(1, cursoLimpio);
                    psCheck.setInt(2, idDocente);
                    
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next() && rs.getInt(1) == 0) {
                            try (PreparedStatement psInsert = con.prepareStatement(sqlInsert)) {
                                psInsert.setString(1, cursoLimpio);
                                psInsert.setInt(2, idDocente);
                                psInsert.executeUpdate();
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        
        // 2. Eliminar Curso por ID exacto
        else if ("eliminarCurso".equals(accion)) {
            String idCursoStr = request.getParameter("idCurso");
            if (idCursoStr != null && !idCursoStr.trim().isEmpty()) {
                String sqlDelete = "DELETE FROM cursos WHERE id = ? AND id_docente = ?";
                
                try (Connection con = ConexionDB.getConnection();
                     PreparedStatement psDelete = con.prepareStatement(sqlDelete)) {
                    
                    psDelete.setInt(1, Integer.parseInt(idCursoStr));
                    psDelete.setInt(2, idDocente);
                    psDelete.executeUpdate();
                    
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        
        response.sendRedirect("dashboard-docente.jsp");
    }
}