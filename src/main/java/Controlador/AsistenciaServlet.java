package Controlador;

import DAO.AsistenciaDAO;
import Modelo.Asistencia;
import Modelo.Alumno;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AsistenciaServlet", urlPatterns = {"/AsistenciaServlet"})
public class AsistenciaServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            response.sendRedirect("qr-docente.jsp");
            return;
        }

        AsistenciaDAO dao = new AsistenciaDAO();
        String fechaHoy = LocalDate.now().toString();

        if ("registrarManual".equals(accion) || "registrarAsistenciaAlumno".equals(accion)) {
            try {
                String idAlumnoStr = request.getParameter("idAlumno");
                
                // Si viene del celular del alumno (QR), tomamos el ID de la sesión
                if ((idAlumnoStr == null || idAlumnoStr.isEmpty()) && session.getAttribute("alumno") != null) {
                    Alumno alu = (Alumno) session.getAttribute("alumno");
                    idAlumnoStr = String.valueOf(alu.getId());
                }

                if (idAlumnoStr != null && !idAlumnoStr.isEmpty()) {
                    int idAlumno = Integer.parseInt(idAlumnoStr);

                    // Validamos que no tenga asistencia registrada hoy
                    boolean yaRegistrado = dao.existeAsistenciaHoy(idAlumno, fechaHoy);

                    if (!yaRegistrado) {
                        Asistencia nueva = new Asistencia();
                        nueva.setIdAlumno(idAlumno);
                        dao.registrarAsistencia(nueva);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Redirigimos según quién hizo la petición
            if ("registrarManual".equals(accion)) {
                response.sendRedirect("qr-docente.jsp?exito=1");
            } else {
                response.sendRedirect("asistencia-qr.jsp?exito=1");
            }
            return;
        }
        
        response.sendRedirect("qr-docente.jsp");
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