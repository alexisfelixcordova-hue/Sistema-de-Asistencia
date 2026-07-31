package Controlador;

import DAO.DocenteDAO;
import Modelo.Docente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DocenteServlet", urlPatterns = {"/DocenteServlet"})
public class DocenteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        
        if ("registrar".equals(accion)) {
            String usuario = request.getParameter("usuario");
            String password = request.getParameter("password");
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String carrera = request.getParameter("carrera");
            String rol = request.getParameter("rol");
            String origen = request.getParameter("origen");
            
            DocenteDAO dao = new DocenteDAO();
            
            if (dao.existeUsuario(usuario)) {
                if ("publico".equals(origen)) {
                    response.sendRedirect("registrar-docente-publico.jsp?error=usuario_duplicado");
                } else {
                    response.sendRedirect("registrar-docente.jsp?error=usuario_duplicado");
                }
                return;
            }
            
            Docente nuevoDocente = new Docente();
            nuevoDocente.setUsuario(usuario);
            nuevoDocente.setPassword(password);
            nuevoDocente.setNombre(nombre);
            nuevoDocente.setEmail(email);
            nuevoDocente.setCarrera(carrera);
            nuevoDocente.setRol(rol != null && !rol.trim().isEmpty() ? rol : "profesor");
            nuevoDocente.setEstado("Activo");
            
            boolean registrado = dao.registrarDocente(nuevoDocente);
            
            if (registrado) {
                if ("publico".equals(origen)) {
                    response.sendRedirect("login.jsp?tipo=docente&registro=exito");
                } else {
                    response.sendRedirect("registrar-docente.jsp?exito=1");
                }
            } else {
                if ("publico".equals(origen)) {
                    response.sendRedirect("registrar-docente-publico.jsp?error=1");
                } else {
                    response.sendRedirect("registrar-docente.jsp?error=1");
                }
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