<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, Modelo.Docente" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 
    // Verificar sesión del docente de forma segura
    Docente docSesion = (session != null) ? (Docente) session.getAttribute("docente") : null;
    if (docSesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Si entra directamente a la vista sin pasar por el Servlet, lo redirigimos para que cargue los datos
    if (request.getAttribute("listaAlumnos") == null) {
        response.sendRedirect("AlumnoServlet?accion=listar");
        return;
    }
    request.setAttribute("paginaActiva", "alumnos"); 
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gesti&oacute;n de Alumnos - Control Asistencia</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>a
<body>

    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="dashboard-docente.jsp"><i class="fas fa-home"></i><span>Inicio</span></a>
            </li>
            <li class="activo">
                <a href="AlumnoServlet?accion=listar"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a>
            </li>
            <li>
                <a href="asistencia-qr.jsp"><i class="fas fa-qrcode"></i><span>Asistencia QR</span></a>
            </li>
            <li>
                <a href="reportes.jsp"><i class="fas fa-chart-bar"></i><span>Reportes</span></a>
            </li>
            <li class="separador"></li>
            <li>
                <a href="LoginServlet?accion=logout" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesion</span></a>
            </li>
        </ul>
    </nav>

<div class="app-shell">
    <div class="app-content">

        <%@ include file="includes/header.jsp" %>

        <!-- ===================== ENCABEZADO ===================== -->
        <div class="seccion-header">
            <div>
                <h2>&#128101; Gesti&oacute;n de Alumnos</h2>
                <p>Administra el registro de alumnos del sistema</p>
            </div>
            <div class="acciones-header">
                <button class="btn btn-verde" onclick="document.getElementById('inputExcel').click()">
                    &#128190; Importar Excel
                </button>
                <input type="file" id="inputExcel" name="archivoExcel" accept=".xls,.xlsx" style="display:none">
                
                <!-- BOTÓN CORREGIDO PARA QUE CARGUE LOS CURSOS DESDE EL SERVLET -->
                <button class="btn btn-morado" onclick="location.href='AlumnoServlet?accion=formRegistrar'">
                    &#10133; Registrar Alumno
                </button>
            </div>
        </div>

        <!-- ===================== FILTROS ===================== -->
        <form class="tarjeta filtros-panel" action="AlumnoServlet" method="get">
            <input type="hidden" name="accion" value="listar">
            <div class="filtro-campo">
                <label>Buscar</label>
                <input type="text" name="buscar" placeholder="C&oacute;digo, nombre o apellido">
            </div>
            <div class="filtro-campo">
                <label>Curso</label>
                <select name="idCurso">
                    <option value="">Todos los cursos</option>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conFiltro = DriverManager.getConnection("jdbc:mysql://localhost:3306/registro_estudiantes?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "");
                            PreparedStatement psFiltro = conFiltro.prepareStatement("SELECT id, nombre FROM cursos WHERE id_docente = ? ORDER BY nombre ASC");
                            psFiltro.setInt(1, docSesion.getId());
                            ResultSet rsFiltro = psFiltro.executeQuery();
                            while(rsFiltro.next()){
                    %>
                                <option value="<%= rsFiltro.getInt("id") %>"><%= rsFiltro.getString("nombre") %></option>
                    <%
                            }
                            rsFiltro.close();
                            psFiltro.close();
                            conFiltro.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>
            <div class="filtro-campo">
                <label>Semestre</label>
                <select name="semestre">
                    <option value="">Todos los semestres</option>
                    <option value="I Semestre">I Semestre</option>
                    <option value="II Semestre">II Semestre</option>
                    <option value="III Semestre">III Semestre</option>
                    <option value="IV Semestre">IV Semestre</option>
                    <option value="V Semestre">V Semestre</option>
                    <option value="VI Semestre">VI Semestre</option>
                </select>
            </div>
            <div class="filtro-campo">
                <label>Turno</label>
                <select name="turno">
                    <option value="">Todos los turnos</option>
                    <option value="Diurno">Diurno</option>
                    <option value="Vespertino">Vespertino</option>
                </select>
            </div>
            <div class="filtro-campo">
                <label>Estado</label>
                <select name="estado">
                    <option value="">Todos</option>
                    <option value="Activo">Activo</option>
                    <option value="Inactivo">Inactivo</option>
                </select>
            </div>
            <div class="filtro-campo">
                <button type="submit" class="btn btn-azul">&#128269; Buscar</button>
            </div>
        </form>

        <!-- ===================== TABLA ===================== -->
        <div class="tarjeta tabla-panel">

            <div class="tabla-toolbar">
                <div>
                    Mostrar
                    <select>
                        <option>10</option>
                        <option selected>25</option>
                        <option>50</option>
                        <option>100</option>
                    </select>
                    registros
                </div>
            </div>

            <div class="tabla-scroll">
                <table class="tabla-alumnos">
                    <thead>
                        <tr>
                            <th>C&oacute;digo <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Nombres <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Apellidos <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Curso <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Semestre <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Turno <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Email <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Tel&eacute;fono <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Estado <span class="flecha-orden">&#9650;&#9660;</span></th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="al" items="${listaAlumnos}">
                            <tr>
                                <td class="celda-codigo">${al.codigo}</td>
                                <td class="celda-nombre">${al.nombre}</td>
                                <td>${al.apellido}</td>
                                <td><span class="badge" style="background: #e0f2fe; color: #0369a1;"><c:out value="${al.nombreCurso}" default="Sin curso" /></span></td>
                                <td><span class="badge badge-grado-cian">${al.semestre}</span></td>
                                <td><span class="badge bg-secondary">${al.turno}</span></td>
                                <td class="celda-email"><a href="mailto:${al.email}">${al.email}</a></td>
                                <td>${al.telefono}</td>
                                <td>
                                    <span class="badge ${al.estado == 'Activo' ? 'badge-activo' : 'badge-inactivo'}">
                                        ${al.estado}
                                    </span>
                                </td>
                                <td>
                                    <!-- Botón Ver -->
                                    <a href="AlumnoServlet?accion=ver&id=${al.id}" class="btn-accion" title="Ver">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <!-- Botón EDITAR -->
                                    <a href="AlumnoServlet?accion=cargarEditar&id=${al.id}" class="btn-accion" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <!-- Botón CAMBIAR ESTADO -->
                                    <a href="AlumnoServlet?accion=cambiarEstado&id=${al.id}" class="btn-accion" title="Estado">
                                        <i class="fas fa-toggle-on"></i>
                                    </a>

                                    <!-- Botón ELIMINAR -->
                                    <a href="AlumnoServlet?accion=eliminar&id=${al.id}" class="btn-accion" title="Eliminar" onclick="return confirm('¿Estás seguro de eliminar este alumno?');">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>

    </div>
</div>
</body>
</html>