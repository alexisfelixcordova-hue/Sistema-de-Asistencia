<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, Modelo.Alumno, Modelo.Asistencia, DAO.AsistenciaDAO" %>
<%
    Alumno alumnoSesion = (Alumno) session.getAttribute("alumno");
    if (alumnoSesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Consultamos el historial completo del alumno usando AsistenciaDAO y objetos Asistencia
    AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
    List<Asistencia> misAsistencias = asistenciaDAO.obtenerAsistenciasPorAlumno(alumnoSesion.getId());
    int totalAsistencias = (misAsistencias != null) ? misAsistencias.size() : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Asistencias - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Barra lateral con diseño idéntico al del docente -->
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="DashboardAlumnoServlet"><i class="fas fa-home"></i><span>Inicio</span></a></li>
            <li class="activo"><a href="mis-asistencias.jsp"><i class="fas fa-calendar-check"></i><span>Mis Asistencias</span></a></li>
            <li><a href="mi-qr.jsp"><i class="fas fa-qrcode"></i><span>Mi Código QR</span></a></li>
            <li class="separador"></li>
            <li><a href="AlumnoLoginServlet?accion=logout" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesión</span></a></li>
        </ul>
    </nav>
    
    <main class="contenido">
        <!-- Cabecera moderna -->
        <header style="padding: 15px 30px; background: #fff; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-radius: 8px;">
            <div>
                <h3 style="margin: 0; color: #2c3e50;">Historial de Asistencias</h3>
                <span style="font-size: 13px; color: #6c757d;"><i class="fas fa-id-card"></i> Código: <strong><%= alumnoSesion.getCodigo() %></strong> | Sincronizado con el registro del docente</span>
            </div>
            <span style="color: #2c3e50; font-size: 15px;">Estudiante, <strong><%= alumnoSesion.getNombre() %></strong></span>
        </header>

        <!-- Tarjetas de Resumen Rápido -->
        <section class="estadisticas" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 25px;">
            <div class="tarjeta-estadistica tarjeta-azul" style="background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-left: 5px solid #27ae60;">
                <div class="info">
                    <h3 style="margin: 0 0 10px 0; font-size: 14px; color: #7f8c8d;">Asistencias Validas</h3>
                    <p class="numero" style="margin: 0; font-size: 28px; font-weight: bold; color: #2c3e50;"><%= totalAsistencias %></p>
                    <span class="tendencia" style="font-size: 12px; color: #27ae60;"><i class="fas fa-check-circle"></i> Escaneadas por QR</span>
                </div>
                <div class="icono" style="font-size: 35px; color: #27ae60; background: rgba(39, 174, 96, 0.1); padding: 15px; border-radius: 10px;"><i class="fas fa-clipboard-check"></i></div>
            </div>
            
            <div class="tarjeta-estadistica tarjeta-roja" style="background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-left: 5px solid #e74c3c;">
                <div class="info">
                    <h3 style="margin: 0 0 10px 0; font-size: 14px; color: #7f8c8d;">Faltas / Tardanzas</h3>
                    <p class="numero" style="margin: 0; font-size: 28px; font-weight: bold; color: #2c3e50;">0</p>
                    <span class="tendencia" style="font-size: 12px; color: #e74c3c;">Registros del periodo</span>
                </div>
                <div class="icono" style="font-size: 35px; color: #e74c3c; background: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 10px;"><i class="fas fa-user-clock"></i></div>
            </div>
        </section>

        <!-- Panel de la Tabla de Historial Completo -->
        <section class="panel" style="background: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); overflow: hidden;">
            <div class="panel-header" style="padding: 20px; border-bottom: 1px solid #f1f1f1; display: flex; justify-content: space-between; align-items: center;">
                <h3 style="margin: 0; color: #2c3e50; font-size: 16px;"><i class="fas fa-list-alt"></i> Registro Oficial de Asistencia por Código QR</h3>
                <span style="font-size: 12px; color: #7f8c8d; background: #f8f9fa; padding: 6px 12px; border-radius: 6px; border: 1px solid #e9ecef;">
                    <i class="fas fa-info-circle"></i> Capturado desde la cuenta del docente
                </span>
            </div>
            <div class="panel-body" style="padding: 20px;">
                <table class="tabla-datos" style="width: 100%; border-collapse: collapse;">
                  <thead>
                      <tr>
                          <th style="padding: 12px 10px;">Fecha</th>
                          <th style="padding: 12px 10px;">Hora de Escaneo</th>
                          <th style="padding: 12px 10px;">Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                    <%
                        if (misAsistencias != null && !misAsistencias.isEmpty()) {
                            for (Asistencia reg : misAsistencias) {
                    %>
                        <tr style="border-bottom: 1px solid #f9f9f9;">
                            <td style="padding: 12px 10px; color: #2c3e50;"><%= reg.getFecha() %></td>
                            <td style="padding: 12px 10px; color: #2c3e50;"><%= reg.getHoraEntrada() %></td>
                            <td style="padding: 12px 10px;"><span class="badge badge-activo" style="background: #e8f8f5; color: #27ae60; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: 500;"><%= reg.getEstado() %></span></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="3" style="text-align: center; padding: 40px; color: #95a5a6;">
                                <i class="fas fa-qrcode" style="font-size: 40px; margin-bottom: 10px; display: block; color: #bdc3c7;"></i>
                                No hay registros de asistencia todavía. Muestra tu código QR al docente para que sea escaneado y aparezca aquí automáticamente.
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