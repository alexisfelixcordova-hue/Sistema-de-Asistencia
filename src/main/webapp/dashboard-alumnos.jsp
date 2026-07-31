<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, Modelo.Alumno, Modelo.Asistencia, Modelo.Curso" %>
<%
    Alumno alumnoSesion = (Alumno) session.getAttribute("alumno");
    if (alumnoSesion == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Asistencia> misAsistencias = (List<Asistencia>) request.getAttribute("misAsistencias");
    int totalAsistencias = (misAsistencias != null) ? misAsistencias.size() : 0;

    // Recibimos los cursos asignados al alumno desde el servlet
    List<Curso> misCursos = (List<Curso>) request.getAttribute("misCursos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Alumno - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li class="activo"><a href="DashboardAlumnoServlet"><i class="fas fa-home"></i><span>Mi Panel</span></a></li>
            <li><a href="mis-asistencias.jsp"><i class="fas fa-calendar-check"></i><span>Mis Asistencias</span></a></li>
            <li><a href="mi-qr.jsp"><i class="fas fa-qrcode"></i><span>Mi Código QR</span></a></li>
            <li class="separador"></li>
            <li><a href="AlumnoLoginServlet?accion=logout" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesión</span></a></li>
        </ul>
    </nav>
    
    <main class="contenido">
        <header style="padding: 15px 30px; background: #fff; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-radius: 8px;">
            <div>
                <h3 style="margin: 0 0 5px 0; color: #2c3e50;">Panel del Estudiante</h3>
                <span style="font-size: 13px; color: #6c757d;"><i class="fas fa-id-card"></i> Código: <strong><%= alumnoSesion.getCodigo() %></strong> | <i class="fas fa-graduation-cap"></i> Semestre: <strong><%= alumnoSesion.getSemestre() != null ? alumnoSesion.getSemestre() : "No asignado" %></strong></span>
            </div>
            <span style="color: #2c3e50; font-size: 15px;">Bienvenido, <strong><%= alumnoSesion.getNombre() %></strong></span>
        </header>

        <section class="panel" style="margin-bottom: 25px;">
            <div class="panel-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h3><i class="fas fa-book"></i> Mi Carrera y Cursos</h3>
                <span style="font-size: 12px; color: #27ae60;"><i class="fas fa-check-circle"></i> Matrícula Activa</span>
            </div>
            <div class="panel-body">
                <p style="margin-bottom: 15px; font-size: 15px;">
                    <strong>Carrera:</strong> <span class="badge" style="background: #3498db; color: white; padding: 5px 10px; border-radius: 4px;"><%= alumnoSesion.getCarrera() != null ? alumnoSesion.getCarrera() : "No especificada" %></span>
                </p>
                <hr style="border: 0; border-top: 1px solid #eee; margin: 15px 0;">
                <h4 style="color: #2c3e50; font-size: 16px; margin-bottom: 12px;"><i class="fas fa-graduation-cap"></i> Cursos Matriculados</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 15px;">
                    <%
                        if (misCursos != null && !misCursos.isEmpty()) {
                            for (Curso curso : misCursos) {
                    %>
                        <div style="background: #f8f9fa; border-left: 4px solid #3498db; padding: 15px; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                            <h5 style="margin: 0 0 5px 0; color: #2c3e50; font-size: 15px;"><%= curso.getNombre() %></h5>
                            <span style="font-size: 12px; color: #7f8c8d;">Curso asignado por docente</span>
                        </div>
                    <%
                            }
                        } else {
                    %>
                        <p style="color: #7f8c8d; font-style: italic; grid-column: 1 / -1;">Aún no te has unido o no tienes cursos asignados en este periodo.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>

        <section class="estadisticas">
            <div class="tarjeta-estadistica tarjeta-azul">
                <div class="info">
                    <h3>Asistencias</h3>
                    <p class="numero"><%= totalAsistencias %></p>
                    <span class="tendencia"><i class="fas fa-check-circle"></i> Total registradas por QR</span>
                </div>
                <div class="icono"><i class="fas fa-user-check"></i></div>
            </div>
            
            <div class="tarjeta-estadistica tarjeta-roja">
                <div class="info">
                    <h3>Tardanzas / Faltas</h3>
                    <p class="numero">0</p>
                    <span class="tendencia">Periodo actual</span>
                </div>
                <div class="icono"><i class="fas fa-exclamation-triangle"></i></div>
            </div>
        </section>

        <section style="margin-bottom: 25px;">
            <h4 style="color: #2c3e50; margin-bottom: 15px;"><i class="fas fa-bolt"></i> Acciones Rápidas</h4>
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <a href="mi-qr.jsp" style="background: #3498db; color: white; padding: 12px 20px; border-radius: 8px; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <i class="fas fa-qrcode"></i> Ver Mi Código QR
                </a>
                <a href="mis-asistencias.jsp" style="background: #27ae60; color: white; padding: 12px 20px; border-radius: 8px; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <i class="fas fa-calendar-check"></i> Historial Completo
                </a>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h3><i class="fas fa-clock"></i> Mis Últimos Registros</h3>
                <span style="font-size: 12px; color: #7f8c8d;"><i class="fas fa-sync-alt"></i> Sincronizado con el docente</span>
            </div>
            <div class="panel-body">
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora de Entrada</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (misAsistencias != null && !misAsistencias.isEmpty()) {
                            for (Asistencia reg : misAsistencias) {
                    %>
                        <tr>
                            <td><%= reg.getFecha() %></td>
                            <td><%= reg.getHoraEntrada() %></td>
                            <td><span class="badge badge-activo"><%= reg.getEstado() %></span></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="3" style="text-align: center; color: #666; padding: 30px;">
                                <i class="fas fa-qrcode" style="font-size: 30px; margin-bottom: 8px; display: block; color: #bdc3c7;"></i>
                                No tienes registros de asistencia recientes. Muestra tu código QR al docente para que lo escanee.
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>