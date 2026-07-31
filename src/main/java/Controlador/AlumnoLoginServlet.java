package Controlador;

import Conexion.ConexionDB;
import Modelo.Alumno;
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

@WebServlet(name = "AlumnoLoginServlet", urlPatterns = {"/AlumnoLoginServlet"})
public class AlumnoLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("logout".equalsIgnoreCase(accion)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
            return;
        }
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Usamos tu clase ConexionDB centralizada del proyecto
            con = ConexionDB.getConnection();
            
            String sql = "SELECT * FROM alumnos WHERE usuario = ? AND password = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                Alumno alumno = new Alumno();
                alumno.setId(rs.getInt("id"));
                alumno.setCodigo(rs.getString("codigo"));
                alumno.setNombre(rs.getString("nombre"));
                alumno.setApellido(rs.getString("apellido"));
                alumno.setSemestre(rs.getString("semestre"));
                alumno.setTurno(rs.getString("turno"));
                alumno.setUsuario(rs.getString("usuario"));

                // Creamos la sesión y guardamos el objeto "alumno" obligatorio para el QR
                HttpSession session = request.getSession();
                session.setAttribute("alumno", alumno);
                session.setAttribute("tipo", "alumno");

                response.sendRedirect("dashboard-alumnos.jsp");
            } else {
                response.sendRedirect("login.jsp?tipo=alumno&error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?tipo=alumno&error=2");
        } finally {
            // Cerramos conexiones de forma segura para evitar fugas en la BD
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}