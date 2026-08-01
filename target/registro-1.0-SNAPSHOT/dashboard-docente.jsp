<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, java.text.SimpleDateFormat, Modelo.Docente, Conexion.ConexionDB" %>
<%
    // Verificar sesión de forma segura con el objeto que guardamos en el LoginServlet
    Docente docSesion = (Docente) session.getAttribute("docente");
    if (docSesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Validación de seguridad para obligar a pasar por el Servlet si entran directo al JSP
    if (request.getAttribute("totalAlumnos") == null) {
        response.sendRedirect("DashboardServlet");
        return;
    }

    // Obtener el total de alumnos enviados desde el DashboardServlet
    Integer totalAlumnosObj = (Integer) request.getAttribute("totalAlumnos");
    int totalAlumnos = (totalAlumnosObj != null) ? totalAlumnosObj : 0;

    // Variables restantes para estadísticas
    int asistenciaHoy = 0;
    int inasistenciasHoy = 0;
    int totalCursosDocente = 0;
    int porcentajeAsistencia = 0;

    // Conexión temporal para los contadores y carga de cursos
    try {
        Connection con = ConexionDB.getConnection();

        // 1. Asistencia de Hoy (Presentes o Tarde) para los alumnos de ESTE docente
        PreparedStatement ps2 = con.prepareStatement(
            "SELECT COUNT(*) FROM asistencias ast " +
            "JOIN alumnos a ON ast.id_alumno = a.id " +
            "WHERE ast.fecha = CURDATE() AND ast.estado IN ('Presente', 'Tarde') AND a.id_docente = ?"
        );
        ps2.setInt(1, docSesion.getId());
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) { asistenciaHoy = rs2.getInt(1); }
        rs2.close();
        ps2.close();

        // 2. Inasistencias de Hoy para los alumnos de ESTE docente
        PreparedStatement ps3 = con.prepareStatement(
            "SELECT COUNT(*) FROM asistencias ast " +
            "JOIN alumnos a ON ast.id_alumno = a.id " +
            "WHERE ast.fecha = CURDATE() AND ast.estado = 'Ausente' AND a.id_docente = ?"
        );
        ps3.setInt(1, docSesion.getId());
        ResultSet rs3 = ps3.executeQuery();
        if (rs3.next()) { inasistenciasHoy = rs3.getInt(1); }
        rs3.close();
        ps3.close();

        // 3. Total de Cursos de ESTE docente
        PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(*) FROM cursos WHERE id_docente = ?");
        ps4.setInt(1, docSesion.getId());
        ResultSet rs4 = ps4.executeQuery();
        if (rs4.next()) { totalCursosDocente = rs4.getInt(1); }
        rs4.close();
        ps4.close();

        // Cálculo del porcentaje de asistencia
        if (totalAlumnos > 0) {
            porcentajeAsistencia = Math.round((asistenciaHoy * 100f) / totalAlumnos);
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docente - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Ajuste para que las 3 tarjetas se distribuyan de forma equilibrada */
        .estadisticas {
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)) !important;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li class="activo">
                <a href="DashboardServlet"><i class="fas fa-home"></i><span>Inicio</span></a>
            </li>
            <li>
                <a href="alumnos.jsp"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a>
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

    <!-- Contenido -->
    <main class="contenido">
        <header style="padding: 15px 30px; background: #fff; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h3>Panel de Control</h3>
                <span style="font-size: 13px; color: #6c757d;"><i class="fas fa-graduation-cap"></i> Carrera: <strong><%= docSesion.getCarrera() != null ? docSesion.getCarrera() : "No asignada" %></strong></span>
            </div>
            <span>Bienvenido, <strong><%= docSesion.getNombre() %></strong></span>
        </header>

        <!-- Estadisticas (Modificado a 3 tarjetas principales) -->
        <section class="estadisticas">
            <div class="tarjeta-estadistica tarjeta-azul">
                <div class="info">
                    <h3>Total Alumnos</h3>
                    <p class="numero"><%= totalAlumnos %></p>
                    <span class="tendencia"><i class="fas fa-users"></i> Registrados</span>
                </div>
                <div class="icono"><i class="fas fa-user-graduate"></i></div>
            </div>
            
            <div class="tarjeta-estadistica tarjeta-verde">
                <div class="info">
                    <h3>Asistencia Hoy</h3>
                    <p class="numero"><%= asistenciaHoy %></p>
                    <span class="tendencia"><%= porcentajeAsistencia %>% presentes</span>
                </div>
                <div class="icono"><i class="fas fa-check-circle"></i></div>
            </div>
            
            <div class="tarjeta-estadistica tarjeta-roja">
                <div class="info">
                    <h3>Inasistencias</h3>
                    <p class="numero"><%= inasistenciasHoy %></p>
                    <span class="tendencia">Hoy</span>
                </div>
                <div class="icono"><i class="fas fa-times-circle"></i></div>
            </div>
        </section>

        <!-- Acciones rapidas -->
        <section class="acciones-rapidas">
            <h3><i class="fas fa-bolt"></i> Acciones Rapidas</h3>
            <div class="botones-accion">
                <a href="alumnos.jsp?accion=nuevo" class="btn-accion btn-nuevo">
                    <i class="fas fa-plus"></i><span>Nuevo Alumno</span>
                </a>
                <a href="asistencia-qr.jsp" class="btn-accion btn-qr">
                    <i class="fas fa-qrcode"></i><span>Escanear QR</span>
                </a>
                <a href="reportes.jsp?tipo=asistencia" class="btn-accion btn-reporte">
                    <i class="fas fa-file-alt"></i><span>Reporte Asistencia</span>
                </a>
                <a href="reportes.jsp?tipo=alumnos" class="btn-accion btn-listado">
                    <i class="fas fa-list"></i><span>Listado Alumnos</span>
                </a>
            </div>
        </section>

        <!-- Sección para Registrar Cursos del Docente -->
        <section class="panel" id="seccion-cursos" style="margin-top: 20px;">
            <div class="panel-header">
                <h3><i class="fas fa-book"></i> Mis Cursos Asignados</h3>
            </div>
            <div class="panel-body">
                <form action="CursoServlet#seccion-cursos" method="POST" style="display: flex; gap: 10px; align-items: flex-end; margin-bottom: 20px;">
                    <input type="hidden" name="accion" value="registrarCurso">
                    <div style="flex-grow: 1;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 600; font-size: 14px; color: #495057;">Escribir Nombre del Curso:</label>
                        <input type="text" name="nombreCurso" required placeholder="Ej. Programación Web I" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px;">
                    </div>
                    <button type="submit" class="btn" style="padding: 10px 20px; background: #0d6efd; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600;">
                        <i class="fas fa-plus"></i> Agregar Curso
                    </button>
                </form>

                <div style="border-top: 1px solid #e9ecef; padding-top: 15px; margin-top: 15px;">
                    <h4 style="font-size: 15px; color: #343a40; margin-bottom: 12px;">Cursos Registrados:</h4>
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                    <%
                        try {
                            Connection conCursos = ConexionDB.getConnection();
                            PreparedStatement psCursos = conCursos.prepareStatement("SELECT id, nombre FROM cursos WHERE id_docente = ?");
                            psCursos.setInt(1, docSesion.getId());
                            ResultSet rsCursos = psCursos.executeQuery();
                            
                            boolean hayCursos = false;
                            while (rsCursos.next()) {
                                hayCursos = true;
                                int idCurso = rsCursos.getInt("id");
                                String nombreCursoActual = rsCursos.getString("nombre");
                    %>
                        <div style="background: #ffffff; padding: 10px 15px; border-radius: 6px; border: 1px solid #e9ecef; font-size: 14px; color: #495057; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 3px rgba(0,0,0,0.02);">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-book-open" style="color: #0d6efd;"></i> 
                                <span><%= nombreCursoActual %></span>
                            </div>
                            <form action="CursoServlet#seccion-cursos" method="POST" style="margin: 0;">
                                <input type="hidden" name="accion" value="eliminarCurso">
                                <input type="hidden" name="idCurso" value="<%= idCurso %>">
                                <button type="submit" title="Eliminar curso" style="background: none; border: none; color: #dc3545; cursor: pointer; font-size: 15px; padding: 5px;" onclick="return confirm('¿Estás seguro de eliminar este curso?');">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                    <%
                            }
                            rsCursos.close();
                            psCursos.close();
                            conCursos.close();
                            
                            if (!hayCursos) {
                    %>
                        <div style="color: #6c757d; font-size: 14px; font-style: italic;">Aún no tienes cursos registrados.</div>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                        <div style="color: red; font-size: 14px;">Error al cargar los cursos.</div>
                    <%
                        }
                    %>
                    </div>
                </div>
            </div>
        </section>

        <!-- Ultimas asistencias -->
        <section class="panel">
            <div class="panel-header">
                <h3><i class="fas fa-clock"></i> Ultimos Registros de Asistencia</h3>
                <a href="reportes.jsp" class="btn-ver-todo">Ver todo <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="panel-body">
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Codigo</th>
                            <th>Alumno</th>
                            <th>Semestre</th>
                            <th>Turno</th>
                            <th>Hora Entrada</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            Connection conTabla = ConexionDB.getConnection();
                            String sqlTabla = "SELECT a.codigo, CONCAT(a.nombre, ' ', a.apellido) AS alumno, a.semestre, a.turno, ast.hora_entrada, ast.estado " +
                                              "FROM asistencias ast JOIN alumnos a ON ast.id_alumno = a.id " +
                                              "WHERE ast.fecha = CURDATE() AND a.id_docente = ? ORDER BY ast.hora_entrada DESC LIMIT 5";
                            PreparedStatement psTabla = conTabla.prepareStatement(sqlTabla);
                            psTabla.setInt(1, docSesion.getId());
                            ResultSet rsTabla = psTabla.executeQuery();
                            
                            boolean hayRegistros = false;
                            while (rsTabla.next()) {
                                hayRegistros = true;
                                String estadoAsistencia = rsTabla.getString("estado");
                                String claseBadge = "badge-activo";
                                if ("Tarde".equalsIgnoreCase(estadoAsistencia)) {
                                    claseBadge = "badge-advertencia";
                                } else if ("Ausente".equalsIgnoreCase(estadoAsistencia)) {
                                    claseBadge = "badge-inactivo";
                                }
                    %>
                        <tr>
                            <td class="celda-codigo"><%= rsTabla.getString("codigo") %></td>
                            <td class="celda-nombre"><%= rsTabla.getString("alumno") %></td>
                            <td><span class="badge badge-grado"><%= rsTabla.getString("semestre") %></span></td>
                            <td><span class="badge" style="background: #e2e8f0; color: #334155;"><%= rsTabla.getString("turno") %></span></td>
                            <td><%= rsTabla.getString("hora_entrada") %></td>
                            <td><span class="badge <%= claseBadge %>"><%= estadoAsistencia %></span></td>
                        </tr>
                    <%
                            }
                            rsTabla.close();
                            psTabla.close();
                            if (!hayRegistros) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #666;">No hay registros de asistencia para el día de hoy.</td>
                        </tr>
                    <%
                            }
                            conTabla.close();
                        } catch (Exception e) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: red;">Error al cargar los últimos registros.</td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Reportes disponibles -->
        <section class="panel">
            <div class="panel-header">
                <h3><i class="fas fa-file-download"></i> Reportes Disponibles</h3>
            </div>
            <div class="panel-body reportes-grid">
                <a href="reportes.jsp?tipo=asistencia-diaria" class="reporte-card">
                    <i class="fas fa-calendar-day"></i>
                    <h4>Asistencia Diaria</h4>
                    <p>Reporte de asistencia del dia actual</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
                <a href="reportes.jsp?tipo=asistencia-semanal" class="reporte-card">
                    <i class="fas fa-calendar-week"></i>
                    <h4>Asistencia Semanal</h4>
                    <p>Resumen semanal de asistencias</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
                <a href="reportes.jsp?tipo=asistencia-mensual" class="reporte-card">
                    <i class="fas fa-calendar-alt"></i>
                    <h4>Asistencia Mensual</h4>
                    <p>Reporte mensual completo</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
                <a href="reportes.jsp?tipo=alumnos-activos" class="reporte-card">
                    <i class="fas fa-users"></i>
                    <h4>Listado de Alumnos</h4>
                    <p>Alumnos activos registrados</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
                <a href="reportes.jsp?tipo=inasistencias" class="reporte-card">
                    <i class="fas fa-user-times"></i>
                    <h4>Inasistencias</h4>
                    <p>Reporte de faltas por alumno</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
                <a href="reportes.jsp?tipo=por-grado" class="reporte-card">
                    <i class="fas fa-layer-group"></i>
                    <h4>Reporte por Semestre</h4>
                    <p>Asistencia agrupada por semestre</p>
                    <span class="btn-descargar"><i class="fas fa-eye"></i> Ver Reporte</span>
                </a>
            </div>
        </section>
    </main>
</body>
</html>
