<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Modelo.Alumno" %>
<%
    Alumno alumnoSesion = (Alumno) session.getAttribute("alumno");
    if (alumnoSesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escanear Asistencia - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Librería para escanear códigos QR con la cámara -->
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
</head>
<body>
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="DashboardAlumnoServlet"><i class="fas fa-home"></i><span>Mi Panel</span></a></li>
            <li><a href="mis-asistencias.jsp"><i class="fas fa-calendar-check"></i><span>Mis Asistencias</span></a></li>
            <li class="activo"><a href="mi-qr.jsp"><i class="fas fa-camera"></i><span>Escanear Asistencia</span></a></li>
            <li class="separador"></li>
            <li><a href="AlumnoLoginServlet?accion=logout" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesión</span></a></li>
        </ul>
    </nav>
    
    <main class="contenido">
        <header style="padding: 15px 30px; background: #fff; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-radius: 8px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h3 style="margin: 0; color: #2c3e50;">Registro de Asistencia por Cámara</h3>
                <span style="font-size: 13px; color: #6c757d;">Apunta con tu cámara al código QR generado en la pizarra o por el docente</span>
            </div>
            <span>Estudiante, <strong><%= alumnoSesion.getNombre() %></strong></span>
        </header>

        <section class="panel" style="background: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 30px; text-align: center; max-width: 600px; margin: 0 auto;">
            
            <!-- Botón para encender la cámara -->
            <div id="contenedor-boton" style="margin-bottom: 20px;">
                <button id="btn-iniciar" onclick="iniciarScanner()" style="background: #27ae60; color: white; border: none; padding: 12px 25px; font-size: 16px; border-radius: 6px; cursor: pointer; font-weight: bold;">
                    <i class="fas fa-camera"></i> Encender Cámara para Escanear
                </button>
            </div>

            <!-- Contenedor donde se mostrará la cámara -->
            <div id="reader" style="width: 100%; max-width: 400px; margin: 0 auto; display: none;"></div>

            <!-- Resultado o mensaje de estado -->
            <div id="resultado-scan" style="margin-top: 20px; font-size: 15px; color: #2c3e50;"></div>
        </section>
    </main>

    <script>
        let html5QrCode;

        function iniciarScanner() {
            document.getElementById("btn-iniciar").style.display = "none";
            document.getElementById("reader").style.display = "block";
            
            html5QrCode = new Html5Qrcode("reader");
            
            const config = { fps: 10, qrbox: { width: 250, height: 250 } };
            
            html5QrCode.start(
                { facingMode: "environment" }, 
                config, 
                onScanSuccess, 
                onScanFailure
            ).catch(err => {
                alert("No se pudo acceder a la cámara. Asegúrate de dar permisos o usar HTTPS/Localhost.");
                document.getElementById("btn-iniciar").style.display = "block";
                document.getElementById("reader").style.display = "none";
            });
        }

        function onScanSuccess(decodedText, decodedResult) {
            // Detenemos la cámara al detectar el código con éxito
            html5QrCode.stop().then(() => {
                document.getElementById("resultado-scan").innerHTML = "<i class='fas fa-spinner fa-spin'></i> Registrando asistencia...";
                
                // Enviamos el código escaneado (del docente/clase) mediante fetch al Servlet de asistencia
                fetch('RegistrarAsistenciaAlumnoServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'codigoClase=' + encodeURIComponent(decodedText) + '&idAlumno=' + encodeURIComponent('<%= alumnoSesion.getId() %>')
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        document.getElementById("resultado-scan").innerHTML = "<div style='color: #27ae60; font-weight: bold;'><i class='fas fa-check-circle'></i> ¡Asistencia registrada correctamente!</div>";
                        setTimeout(() => {
                            window.location.href = "mis-asistencias.jsp";
                        }, 2000);
                    } else {
                        document.getElementById("resultado-scan").innerHTML = "<div style='color: #e74c3c; font-weight: bold;'><i class='fas fa-exclamation-triangle'></i> " + data.message + "</div>";
                        document.getElementById("btn-iniciar").style.display = "block";
                    }
                })
                .catch(error => {
                    document.getElementById("resultado-scan").innerHTML = "<div style='color: #e74c3c;'>Error de red al registrar la asistencia.</div>";
                    document.getElementById("btn-iniciar").style.display = "block";
                });
            }).catch(err => {
                console.error("Error al detener el escáner", err);
            });
        }

        function onScanFailure(error) {
            // Se ejecuta de manera continua mientras busca un código QR, se puede dejar vacío para evitar ruido en consola
        }
    </script>
</body>
</html>