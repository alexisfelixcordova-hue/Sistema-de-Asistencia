<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String tipo = request.getParameter("tipo");
    if (tipo == null || tipo.isEmpty()) {
        tipo = "docente";
    }
    String titulo = "docente".equals(tipo) ? "Docente" : "Alumno";
    String icono = "docente".equals(tipo) ? "fa-chalkboard-teacher" : "fa-user-graduate";
    session.setAttribute("tipoLogin", tipo);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login <%= titulo %> - Liceo Moderno</title>
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
                <p><i class="fas fa-check-circle"></i> Control de asistencia en tiempo real</p>
                <p><i class="fas fa-check-circle"></i> Reportes detallados por alumno y grado</p>
                <p><i class="fas fa-check-circle"></i> Escaneo QR para registro rapido</p>
            </div>
        </div>
        
        <div class="login-derecha">
            <div class="login-formulario">
                <div class="login-tipo">
                    <i class="fas <%= icono %>"></i>
                    <h2>Ingreso <%= titulo %></h2>
                </div>
                
                <form action="<%= request.getContextPath() %>/<%= "docente".equals(tipo) ? "LoginServlet" : "AlumnoLoginServlet" %>" method="POST" class="form-login">
                    <input type="hidden" name="tipo" value="<%= tipo %>">
                    
                    <div class="campo-login">
                        <label for="usuario"><i class="fas fa-user"></i> Usuario</label>
                        <input type="text" id="usuario" name="usuario" placeholder="Ingrese su usuario" required>
                    </div>
                    
                    <div class="campo-login">
                        <label for="password"><i class="fas fa-lock"></i> Contraseña</label>
                        <input type="password" id="password" name="password" placeholder="Ingrese su contraseña" required>
                    </div>
                    
                    <button type="submit" class="btn-login">
                        <i class="fas fa-sign-in-alt"></i> Ingresar
                    </button>
                    
                    <a href="index.jsp" class="btn-volver">
                        <i class="fas fa-arrow-left"></i> Volver al inicio
                    </a>
                </form>

                <% if ("docente".equals(tipo)) { %>
                    <div style="text-align: center; margin-top: 15px;">
                        <p style="font-size: 14px; color: #666; margin-bottom: 5px;">¿No tienes cuenta de docente?</p>
                        <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/registrar-docente-publico.jsp'" style="background: none; border: none; color: #0d6efd; font-size: 14px; font-weight: bold; text-decoration: underline; cursor: pointer; padding: 0;">
                            Regístrate aquí
                        </button>
                    </div>
                <% } else { %>
                    <div style="text-align: center; margin-top: 15px;">
                        <p style="font-size: 14px; color: #666; margin-bottom: 5px;">¿No tienes cuenta de alumno?</p>
                        <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/registrar-alumno-publico.jsp'" style="background: none; border: none; color: #0d6efd; font-size: 14px; font-weight: bold; text-decoration: underline; cursor: pointer; padding: 0;">
                            Regístrate aquí
                        </button>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>