package Controlador;

import DAO.DashboardDAO;
import Modelo.Docente;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Docente docSesion = (Docente) session.getAttribute("docente");
        
        if (docSesion == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        int idDocente = docSesion.getId();

        // Obtener datos mediante el DAO
        int totalAlumnos = dao.obtenerTotalAlumnos(idDocente);
        Map<String, Integer> stats = dao.obtenerEstadisticasHoy(idDocente);
        List<Map<String, String>> ultimasAsistencias = dao.obtenerUltimasAsistencias(idDocente);

        int asistenciaHoy = stats.get("asistenciaHoy");
        int inasistenciasHoy = stats.get("inasistenciasHoy");
        int porcentajeAsistencia = (totalAlumnos > 0) ? Math.round((asistenciaHoy * 100f) / totalAlumnos) : 0;

        // Enviar atributos a la vista
        request.setAttribute("totalAlumnos", totalAlumnos);
        request.setAttribute("asistenciaHoy", asistenciaHoy);
        request.setAttribute("inasistenciasHoy", inasistenciasHoy);
        request.setAttribute("porcentajeAsistencia", porcentajeAsistencia);
        request.setAttribute("ultimasAsistencias", ultimasAsistencias);

        // CORREGIDO: Redirigir exactamente a tu archivo dashboard-docente.jsp
        request.getRequestDispatcher("dashboard-docente.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}