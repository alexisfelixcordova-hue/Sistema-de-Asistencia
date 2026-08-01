package Controlador;

import DAO.AlumnoDAO;
import DAO.DocenteDAO;
import Modelo.Alumno;
import Modelo.Docente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");
        String tipo = request.getParameter("tipo"); // Viene del formulario (docente o alumno)

        HttpSession session = request.getSession();

        // Si el tipo es alumno o intenta iniciar sesión como alumno
        if ("alumno".equals(tipo)) {
            AlumnoDAO alumnoDAO = new AlumnoDAO();
            Alumno alumno = alumnoDAO.validarLogin(usuario, password); 

            if (alumno != null) {
                session.setAttribute("alumno", alumno); // <-- AQUÍ SE GUARDA LA SESIÓN DEL ALUMNO
                session.setAttribute("tipo", "alumno");
                response.sendRedirect(request.getContextPath() + "/mi-qr.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?tipo=alumno&error=1");
            }
        } else {
            // Lógica por defecto para Docentes
            DocenteDAO docenteDAO = new DocenteDAO();
            Docente docente = docenteDAO.validarLogin(usuario, password);

            if (docente != null) {
                session.setAttribute("docente", docente);
                session.setAttribute("tipo", "docente");
                session.setAttribute("usuario", docente.getUsuario());

                AlumnoDAO alumnoDAO = new AlumnoDAO();
                int totalAlumnos = alumnoDAO.contarTotalPorDocente(docente.getId());
                session.setAttribute("totalAlumnos", totalAlumnos);

                response.sendRedirect(request.getContextPath() + "/DashboardServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?tipo=docente&error=1");
            }
        }
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