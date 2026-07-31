package Controlador;

import DAO.AsistenciaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistrarAsistenciaAlumnoServlet", urlPatterns = {"/RegistrarAsistenciaAlumnoServlet"})
public class RegistrarAsistenciaAlumnoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String codigoClase = request.getParameter("codigoClase");
            String idAlumnoStr = request.getParameter("idAlumno");
            
            int idAlumno = Integer.parseInt(idAlumnoStr);
            
            AsistenciaDAO dao = new AsistenciaDAO();
            boolean registrado = dao.registrarAsistenciaPorQR(idAlumno, codigoClase);
            
            if (registrado) {
                out.write("{\"status\":\"success\", \"message\":\"Asistencia guardada con éxito\"}");
            } else {
                out.write("{\"status\":\"error\", \"message\":\"Código de clase inválido o ya registrado\"}");
            }
        } catch (Exception e) {
            out.write("{\"status\":\"error\", \"message\":\"Error interno: " + e.getMessage() + "\"}");
        }
    }
}