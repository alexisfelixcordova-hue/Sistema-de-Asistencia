package Controlador;

import DAO.AsistenciaDAO;
import Modelo.Alumno;
import Modelo.Asistencia;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DashboardAlumnoServlet")
public class DashboardAlumnoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Alumno alumno = (Alumno) session.getAttribute("alumno");
        
        if (alumno == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Consultamos la Base de Datos usando AsistenciaDAO para traer las asistencias reales del alumno
        AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
        List<Asistencia> misAsistencias = asistenciaDAO.obtenerAsistenciasPorAlumno(alumno.getId());
        
        // Mandamos los datos reales a la vista
        request.setAttribute("misAsistencias", misAsistencias);
        request.getRequestDispatcher("dashboard-alumnos.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}