package Controlador;

import DAO.AlumnoDAO;
import DAO.AsistenciaDAO;
import DAO.CursoDAO;
import Modelo.Alumno;
import Modelo.Asistencia;
import Modelo.Curso;
import Modelo.Docente;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AlumnoServlet", urlPatterns = {"/AlumnoServlet"})
public class AlumnoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Docente docSesion = (Docente) session.getAttribute("docente");
        Alumno alumnoSesion = (Alumno) session.getAttribute("alumno");

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        AlumnoDAO dao = new AlumnoDAO();
        AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
        String fechaHoy = LocalDate.now().toString();

        // 1. ACCIÓN PÚBLICA DE REGISTRO
        if ("registrarPublico".equals(accion)) {
            try {
                String nombres = request.getParameter("nombres");
                String semestre = request.getParameter("grado");
                String usuario = request.getParameter("usuario");
                String password = request.getParameter("password");

                String nombre = nombres;
                String apellido = "";
                if (nombres != null && nombres.contains(" ")) {
                    int ultimoEspacio = nombres.lastIndexOf(" ");
                    nombre = nombres.substring(0, ultimoEspacio);
                    apellido = nombres.substring(ultimoEspacio + 1);
                }

                Alumno nuevoAlumno = new Alumno();
                nuevoAlumno.setNombre(nombre);
                nuevoAlumno.setApellido(apellido);
                nuevoAlumno.setSemestre(semestre);
                nuevoAlumno.setUsuario(usuario);
                nuevoAlumno.setPassword(password);

                boolean registrado = dao.registrarPublico(nuevoAlumno);

                if (registrado) {
                    response.sendRedirect("login.jsp?tipo=alumno&registro=exito");
                } else {
                    response.sendRedirect("registrar-alumno-publico.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("registrar-alumno-publico.jsp?error=1");
            }
            return;
        }

        // 2. ACCIÓN DE REGISTRO MANUAL DESDE EL PANEL DEL DOCENTE (Alumnos sin celular)
        if ("registrarAsistenciaManual".equals(accion)) {
            try {
                String idAlumnoStr = request.getParameter("idAlumno");
                if (idAlumnoStr != null && !idAlumnoStr.isEmpty()) {
                    int idAlumno = Integer.parseInt(idAlumnoStr);

                    // Validar si ya registró hoy para evitar duplicados
                    boolean yaRegistrado = asistenciaDAO.existeAsistenciaHoy(idAlumno, fechaHoy);
                    if (!yaRegistrado) {
                        Asistencia nuevaAsistencia = new Asistencia();
                        nuevaAsistencia.setIdAlumno(idAlumno);
                        asistenciaDAO.registrarAsistencia(nuevaAsistencia);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("asistencia-qr.jsp");
            return;
        }

        // 3. ACCIÓN DE REGISTRO DE ASISTENCIA DESDE EL CELULAR DEL ALUMNO (Escaneo QR)
        if ("registrarAsistenciaAlumno".equals(accion)) {
            try {
                String codigoQR = request.getParameter("codigoQR");
                
                if (alumnoSesion != null && codigoQR != null && codigoQR.startsWith("ASISTENCIA-LICEO-")) {
                    boolean yaRegistrado = asistenciaDAO.existeAsistenciaHoy(alumnoSesion.getId(), fechaHoy);
                    
                    if (!yaRegistrado) {
                        Asistencia nuevaAsistencia = new Asistencia();
                        nuevaAsistencia.setIdAlumno(alumnoSesion.getId());
                        asistenciaDAO.registrarAsistencia(nuevaAsistencia);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("asistencia-qr.jsp");
            return;
        }

        // VALIDACIÓN: Para el resto de acciones internas se exige sesión de docente activa
        if (docSesion == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        switch (accion) {
            case "listar":
                String buscar = request.getParameter("buscar");
                String idCursoFiltro = request.getParameter("idCurso");
                String semestreFiltro = request.getParameter("semestre");
                String turnoFiltro = request.getParameter("turno");
                String estadoFiltro = request.getParameter("estado");

                List<Alumno> lista = dao.listarConFiltros(docSesion.getId(), buscar, idCursoFiltro, semestreFiltro, turnoFiltro, estadoFiltro);
                int totalAlumnosDocente = dao.contarTotalPorDocente(docSesion.getId());
                
                request.setAttribute("listaAlumnos", lista);
                request.setAttribute("totalAlumnos", totalAlumnosDocente);
                request.getRequestDispatcher("alumnos.jsp").forward(request, response);
                break;

            case "formRegistrar":
                CursoDAO cursoDao = new CursoDAO();
                List<Curso> listaCursos = cursoDao.listarPorDocente(docSesion.getId());
                request.setAttribute("listaCursos", listaCursos);
                request.getRequestDispatcher("registrar-alumno.jsp").forward(request, response);
                break;

            case "registrar":
                try {
                    String codigoReg = request.getParameter("codigo");
                    
                    if (dao.existeCodigo(codigoReg)) {
                        response.sendRedirect("AlumnoServlet?accion=formRegistrar&error=duplicado");
                        return;
                    }

                    String nombreReg = request.getParameter("nombre");
                    String apellidoReg = request.getParameter("apellido");
                    
                    int idCursoReg = 0;
                    String idCursoStrReg = request.getParameter("idCurso");
                    if (idCursoStrReg != null && !idCursoStrReg.trim().isEmpty()) {
                        idCursoReg = Integer.parseInt(idCursoStrReg);
                    }

                    Alumno nuevo = new Alumno();
                    nuevo.setCodigo(codigoReg);
                    nuevo.setNombre(nombreReg);
                    nuevo.setApellido(apellidoReg);
                    nuevo.setIdCurso(idCursoReg);
                    nuevo.setSemestre(request.getParameter("semestre"));
                    nuevo.setTurno(request.getParameter("turno"));
                    nuevo.setEmail(request.getParameter("email"));
                    nuevo.setTelefono(request.getParameter("telefono"));
                    nuevo.setDireccion(request.getParameter("direccion"));
                    nuevo.setAcudiente(request.getParameter("acudiente"));
                    nuevo.setTelefonoAcudiente(request.getParameter("telefonoAcudiente"));

                    boolean insertado = dao.insertarConDocente(nuevo, docSesion.getId());

                    if (insertado) {
                        response.sendRedirect("AlumnoServlet?accion=listar");
                    } else {
                        response.sendRedirect("AlumnoServlet?accion=formRegistrar&error=1");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("AlumnoServlet?accion=formRegistrar&error=1");
                }
                break;

            case "cargarEditar":
                String idEdStr = request.getParameter("id");
                if (idEdStr != null && !idEdStr.trim().isEmpty()) {
                    int idEd = Integer.parseInt(idEdStr);
                    Alumno alumEd = dao.obtenerPorId(idEd);
                    request.setAttribute("alumno", alumEd);
                    request.getRequestDispatcher("editar-alumno.jsp").forward(request, response);
                } else {
                    response.sendRedirect("AlumnoServlet?accion=listar");
                }
                break;

            case "actualizar":
                String idActStr = request.getParameter("id");
                if (idActStr != null && !idActStr.trim().isEmpty()) {
                    int idAct = Integer.parseInt(idActStr);
                    
                    int idCursoAct = 0;
                    String idCursoStrAct = request.getParameter("idCurso");
                    if (idCursoStrAct != null && !idCursoStrAct.trim().isEmpty()) {
                        idCursoAct = Integer.parseInt(idCursoStrAct);
                    }

                    Alumno alumUp = new Alumno();
                    alumUp.setId(idAct);
                    alumUp.setCodigo(request.getParameter("codigo"));
                    alumUp.setNombre(request.getParameter("nombre"));
                    alumUp.setApellido(request.getParameter("apellido"));
                    alumUp.setIdCurso(idCursoAct);
                    alumUp.setSemestre(request.getParameter("semestre"));
                    alumUp.setTurno(request.getParameter("turno"));
                    alumUp.setEmail(request.getParameter("email"));
                    alumUp.setTelefono(request.getParameter("telefono"));
                    alumUp.setDireccion(request.getParameter("direccion"));
                    alumUp.setAcudiente(request.getParameter("acudiente"));
                    alumUp.setTelefonoAcudiente(request.getParameter("telefonoAcudiente"));

                    dao.actualizar(alumUp);
                }
                response.sendRedirect("AlumnoServlet?accion=listar");
                break;

            case "eliminar":
                String idDelStr = request.getParameter("id");
                if (idDelStr != null && !idDelStr.trim().isEmpty()) {
                    int idDel = Integer.parseInt(idDelStr);
                    dao.eliminar(idDel);
                }
                response.sendRedirect("AlumnoServlet?accion=listar");
                break;

            default:
                response.sendRedirect("AlumnoServlet?accion=listar");
                break;
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