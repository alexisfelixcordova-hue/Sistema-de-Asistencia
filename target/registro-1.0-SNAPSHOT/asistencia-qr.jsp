<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Asistencia" %>
<%@ page import="DAO.AsistenciaDAO" %>
<%@ page import="Modelo.Alumno" %>
<%@ page import="DAO.AlumnoDAO" %>
<%
    String tipo = (String) session.getAttribute("tipo");
    String tituloPagina = "docente".equals(tipo) ? "Asistencia QR" : "Mi Asistencia";
    boolean esDocente = "docente".equals(tipo);
    
    AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
    List<Asistencia> listaAsistencias = asistenciaDAO.listarAsistencias();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= tituloPagina %> - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/qr.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
</head>
<body>
    <% if (esDocente) { %>
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard-docente.jsp"><i class="fas fa-home"></i><span>Inicio</span></a></li>
            <li><a href="alumnos.jsp"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a></li>
            <li class="activo"><a href="asistencia-qr.jsp"><i class="fas fa-qrcode"></i><span>Asistencia QR</span></a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i><span>Reportes</span></a></li>
            <li class="separador"></li>
            <li><a href="index.jsp" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesion</span></a></li>
        </ul>
    </nav>
    <% } else { %>
    <header class="header-alumno">
        <div class="logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <nav class="nav-alumno">
            <a href="dashboard-alumnos.jsp"><i class="fas fa-home"></i> Inicio</a>
            <a href="asistencia-qr.jsp" class="activo"><i class="fas fa-clipboard-check"></i> Mi Asistencia</a>
            <a href="index.jsp" class="salir"><i class="fas fa-sign-out-alt"></i> Salir</a>
        </nav>
    </header>
    <% } %>

    <main class="<%= esDocente ? "contenido" : "contenido-alumno" %>">
        <% if (esDocente) { %>
        <jsp:include page="includes/header.jsp" />
        <% } %>

        <section class="panel">
            <div class="panel-header">
                <h3><i class="fas fa-qrcode"></i> <%= tituloPagina %></h3>
            </div>
            <div class="panel-body">
                
                <% if (esDocente) { %>
                <div class="qr-escaner" style="text-align: center;">
                    <h4><i class="fas fa-qrcode"></i> Código QR de la Clase de Hoy</h4>
                    <p>Proyecta este código en la pantalla para que los alumnos lo escaneen con sus celulares.</p>
                    
                    <div id="qrDocente" style="display: inline-block; padding: 15px; background: white; border-radius: 8px; margin: 15px 0;"></div>
                    <p><strong>Fecha del día: </strong> <span id="fechaHoy"></span></p>
                </div>

                <div class="qr-manual" style="margin: 30px auto; background: #f8f9fa; padding: 20px; border-radius: 8px; border: 1px solid #e9ecef; max-width: 100%; text-align: left;">
                    <h4 style="margin-bottom: 8px; color: #333;"><i class="fas fa-user-check"></i> Registro Manual (Alumnos sin celular)</h4>
                    <p style="font-size: 13px; color: #6c757d; margin-bottom: 15px;">Selecciona al alumno de la lista para registrar su asistencia de forma directa en el sistema:</p>
                    
                    <form action="AlumnoServlet" method="POST" style="display: flex; flex-direction: column; gap: 12px;">
                        <input type="hidden" name="accion" value="registrarAsistenciaManual">
                        
                        <select name="idAlumno" class="form-control" required style="padding: 10px; border-radius: 4px; border: 1px solid #ccc; width: 100%;">
                            <option value="">-- Seleccionar Alumno --</option>
                            <% 
                                AlumnoDAO daoAlumnos = new AlumnoDAO();
                                List<Alumno> todos = daoAlumnos.listarTodos();
                                for(Alumno a : todos) {
                            %>
                                <option value="<%= a.getId() %>"><%= a.getApellido() %>, <%= a.getNombre() %> (<%= a.getCodigo() %>)</option>
                            <% } %>
                        </select>
                        
                        <button type="submit" class="btn btn-primary" style="padding: 10px 20px; background: #0d6efd; color: white; border: none; border-radius: 4px; cursor: pointer; width: 100%;">
                            <i class="fas fa-check"></i> Registrar Asistencia
                        </button>
                    </form>
                </div>
                
                <div class="qr-historial" style="margin-top: 30px;">
                    <h4><i class="fas fa-history"></i> Registros de Hoy</h4>
                    <table class="tabla-datos">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>ID Alumno</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (listaAsistencias != null && !listaAsistencias.isEmpty()) {
                                    for (Asistencia item : listaAsistencias) {
                            %>
                                    <tr>
                                        <td><%= item.getId() %></td>
                                        <td><%= item.getIdAlumno() %></td>
                                        <td><%= item.getFecha() %></td>
                                        <td><%= item.getHoraEntrada() %></td>
                                        <td><span class="badge badge-activo"><i class="fas fa-check"></i> <%= item.getEstado() %></span></td>
                                    </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                    <tr><td colspan="5" style="text-align: center;">No hay registros hoy.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <% } else { %>
                <div class="mi-qr" style="text-align: center;">
                    <h4><i class="fas fa-camera"></i> Escanear Código del Docente</h4>
                    <p>Apunta con la cámara de tu celular al código QR que muestra el profesor en el aula.</p>
                    
                    <div id="readerAlumno" style="width: 100%; max-width: 350px; margin: 0 auto;"></div>
                </div>
                
                <div class="qr-resumen" style="margin-top: 20px;">
                    <h4><i class="fas fa-chart-pie"></i> Mi Resumen</h4>
                    <div class="resumen-stats">
                        <div class="resumen-item"><span class="numero">Asistencias OK</span></div>
                    </div>
                </div>
                <% } %>
                
            </div>
        </section>
    </main>

    <script>
        <% if (esDocente) { %>
            let fechaActual = new Date().toISOString().slice(0, 10);
            document.getElementById("fechaHoy").innerText = fechaActual;
            let textoQR = "ASISTENCIA-LICEO-" + fechaActual;
            
            new QRCode(document.getElementById("qrDocente"), {
                text: textoQR,
                width: 220,
                height: 220,
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });
        <% } else { %>
            function onScanSuccess(decodedText, decodedResult) {
                if(decodedText.startsWith("ASISTENCIA-LICEO-")) {
                    alert("¡Asistencia detectada correctamente!");
                    // Se envía el texto decodificado como parámetro al Servlet
                    window.location.href = "AlumnoServlet?accion=registrarAsistenciaAlumno&codigoQR=" + encodeURIComponent(decodedText);
                } else {
                    alert("Este código QR no corresponde a la clase de hoy.");
                }
            }
            
            let html5QrCode = new Html5QrcodeScanner("readerAlumno", { fps: 10, qrbox: 200 }, false);
            html5QrCode.render(onScanSuccess, (err) => {});
        <% } %>
    </script>
</body>
</html>