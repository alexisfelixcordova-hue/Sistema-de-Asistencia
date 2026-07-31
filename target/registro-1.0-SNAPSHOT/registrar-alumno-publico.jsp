<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro Alumnos - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="body-login">
    <div class="contenedor-login">
        <div class="login-izquierda">
            <div class="login-logo">
                <i class="fas fa-school"></i>
                <h1>Liceo Moderno</h1>
            </div>
            <p class="login-descripcion">Sistema de Control de Asistencia y Registro de Estudiantes</p>
            <div class="login-info">
                <p><i class="fas fa-check-circle"></i> Registro de nuevos estudiantes</p>
                <p><i class="fas fa-check-circle"></i> Acceso con tu propio usuario y contraseña</p>
                <p><i class="fas fa-check-circle"></i> Consulta tu historial académico</p>
            </div>
        </div>
        
        <div class="login-derecha">
            <div class="login-formulario">
                <div class="login-tipo">
                    <i class="fas fa-user-plus"></i>
                    <h2>Registro de Alumno</h2>
                </div>
                
                <form action="AlumnoServlet" method="POST" class="form-login">
                    <input type="hidden" name="accion" value="registrarPublico">
                    
                    <div class="campo-login">
                        <label for="nombres"><i class="fas fa-user"></i> Nombres y Apellidos</label>
                        <input type="text" id="nombres" name="nombres" placeholder="Ingrese sus nombres completos" required>
                    </div>

                    <div class="campo-login">
                        <label for="grado"><i class="fas fa-graduation-cap"></i> Grado / Sección</label>
                        <input type="text" id="grado" name="grado" placeholder="Ej. 5to Secundaria" required>
                    </div>

                    <div class="campo-login">
                        <label for="usuario"><i class="fas fa-id-badge"></i> Usuario</label>
                        <input type="text" id="usuario" name="usuario" placeholder="Cree un usuario" required>
                    </div>
                    
                    <div class="campo-login">
                        <label for="password"><i class="fas fa-lock"></i> Contraseña</label>
                        <input type="password" id="password" name="password" placeholder="Cree una contraseña" required>
                    </div>
                    
                    <button type="submit" class="btn-login">
                        <i class="fas fa-user-check"></i> Registrarse
                    </button>
                    
                    <a href="login.jsp?tipo=alumno" class="btn-volver">
                        <i class="fas fa-arrow-left"></i> Volver al Login
                    </a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>