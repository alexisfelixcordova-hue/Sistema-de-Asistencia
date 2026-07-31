<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Verificamos si existe la sesión de docente o tipoLogin iniciada
    String tipo = (String) session.getAttribute("tipo");
    if (tipo == null) {
        tipo = (String) session.getAttribute("tipoLogin");
    }
    
    // Si aún no hay sesión, puedes descomentar temporalmente la siguiente línea si deseas probar directo:
    /*
    if (tipo == null) {
        response.sendRedirect("login.jsp?tipo=docente");
        return;
    }
    */
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Docente - Liceo Moderno</title>
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
            <li><a href="dashboard-docente.jsp"><i class="fas fa-home"></i><span>Inicio</span></a></li>
            <li><a href="alumnos.jsp"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a></li>
            <li class="activo"><a href="registrar-docente.jsp"><i class="fas fa-user-plus"></i><span>Nuevo Docente</span></a></li>
            <li><a href="asistencia-qr.jsp"><i class="fas fa-qrcode"></i><span>Asistencia QR</span></a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i><span>Reportes</span></a></li>
            <li class="separador"></li>
            <li><a href="LoginServlet?accion=logout" class="salir"><i class="fas fa-sign-out-alt"></i><span>Salir</span></a></li>
        </ul>
    </nav>

    <main class="contenido">
        <jsp:include page="includes/header.jsp" />

        <section class="panel">
            <div class="panel-header">
                <h3><i class="fas fa-user-plus"></i> Registrar Nuevo Docente / Administrador</h3>
            </div>
            <div class="panel-body">
                <form action="DocenteServlet" method="POST" style="max-width: 600px; margin: 0 auto; display: flex; flex-direction: column; gap: 15px;">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Usuario:</label>
                        <input type="text" name="usuario" class="form-control" required placeholder="Ej. jperez" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contraseña:</label>
                        <input type="password" name="password" class="form-control" required placeholder="******" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Nombre Completo:</label>
                        <input type="text" name="nombre" class="form-control" required placeholder="Ej. Juan Pérez" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Correo Electrónico:</label>
                        <input type="email" name="email" class="form-control" placeholder="correo@liceo.edu.co" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Rol en el Sistema:</label>
                        <select name="rol" class="form-control" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                            <option value="profesor">Profesor</option>
                            <option value="admin">Administrador</option>
                        </select>
                    </div>

                    <div style="text-align: right; margin-top: 15px;">
                        <button type="submit" class="btn btn-primary" style="padding: 10px 20px; background: #0d6efd; color: white; border: none; border-radius: 4px; cursor: pointer;">
                            <i class="fas fa-save"></i> Guardar Docente
                        </button>
                    </div>
                </form>
            </div>
        </section>
    </main>
</body>
</html>