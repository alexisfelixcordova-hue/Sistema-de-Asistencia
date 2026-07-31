<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liceo Moderno - Sistema de Registro</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="body-inicio">
    <div class="contenedor-inicio">
        <div class="logo-escuela">
            <i class="fas fa-school"></i>
            <h1>Liceo Moderno</h1>
            <p>Sistema de Registro y Control de Asistencia</p>
        </div>
        
        <div class="seleccion-usuario">
            <h2>Bienvenido</h2>
            <p class="subtitulo">Seleccione su tipo de usuario para continuar</p>
            
            <div class="tarjetas-usuario">
                <a href="login.jsp?tipo=docente" class="tarjeta-usuario tarjeta-docente">
                    <div class="icono-usuario">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <h3>Docente / Administrador</h3>
                    <p>Registro de alumnos, control de asistencia y generacion de reportes</p>
                    <div class="accion-tarjeta">
                        <span>Ingresar como Docente</span>
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </a>
                
                <a href="login.jsp?tipo=alumno" class="tarjeta-usuario tarjeta-alumno">
                    <div class="icono-usuario">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <h3>Alumno</h3>
                    <p>Consulta tu historial de asistencia y datos personales</p>
                    <div class="accion-tarjeta">
                        <span>Ingresar como Alumno</span>
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </a>
            </div>
        </div>
        
        <div class="info-sistema">
            <p><i class="fas fa-shield-alt"></i> Sistema seguro y encriptado</p>
            <p><i class="fas fa-qrcode"></i> Escaneo de codigo QR para asistencia</p>
        </div>
    </div>
</body>
</html>