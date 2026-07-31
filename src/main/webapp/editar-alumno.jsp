<%@page import="Modelo.Curso"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Curso> listaCursos = (List<Curso>) request.getAttribute("listaCursos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Nuevo Alumno - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/formularios.css">
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
            <li class="activo"><a href="alumnos.jsp"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a></li>
            <li><a href="asistencia-qr.jsp"><i class="fas fa-qrcode"></i><span>Asistencia QR</span></a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i><span>Reportes</span></a></li>
            <li class="separador"></li>
            <li><a href="index.jsp" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesion</span></a></li>
        </ul>
    </nav>

    <main class="contenido">
        <jsp:include page="includes/header.jsp" />

        <section class="panel">
            <div class="panel-header">
                <h3><i class="fas fa-user-plus"></i> Registrar Nuevo Alumno</h3>
            </div>
            <div class="panel-body">
                
                <form action="AlumnoServlet" method="POST" class="form-registro">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <div class="form-group">
                        <label>Código:</label>
                        <input type="text" name="codigo" class="form-control" required placeholder="Ej. 12001">
                    </div>

                    <div class="form-group">
                        <label>Nombre:</label>
                        <input type="text" name="nombre" class="form-control" required placeholder="Nombres del alumno">
                    </div>

                    <div class="form-group">
                        <label>Apellido:</label>
                        <input type="text" name="apellido" class="form-control" required placeholder="Apellidos del alumno">
                    </div>

                    <div class="form-group">
                        <label>Curso:</label>
                        <select name="idCurso" class="form-control" required>
                            <option value="">Seleccione un curso...</option>
                            <% if (listaCursos != null) {
                                for (Curso c : listaCursos) { %>
                                    <option value="<%= c.getId() %>"><%= c.getNombre() %></option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Semestre:</label>
                        <select name="semestre" class="form-control" required>
                            <option value="">Seleccione semestre...</option>
                            <option value="Primer Semestre">Primer Semestre</option>
                            <option value="Segundo Semestre">Segundo Semestre</option>
                            <option value="Tercer Semestre">Tercer Semestre</option>
                            <option value="Cuarto Semestre">Cuarto Semestre</option>
                            <option value="Quinto Semestre">Quinto Semestre</option>
                            <option value="Sexto Semestre">Sexto Semestre</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Turno:</label>
                        <select name="turno" class="form-control" required>
                            <option value="">Seleccione turno...</option>
                            <option value="Mañana">Mañana</option>
                            <option value="Tarde">Tarde</option>
                            <option value="Noche">Noche</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="email" class="form-control" placeholder="correo@ejemplo.com">
                    </div>

                    <div class="form-group">
                        <label>Teléfono:</label>
                        <input type="text" name="telefono" class="form-control" placeholder="Número de celular">
                    </div>

                    <div class="form-actions" style="margin-top: 20px; display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-success" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;">
                            <i class="fas fa-save"></i> Guardar Alumno
                        </button>
                        <a href="AlumnoServlet?accion=listar" class="btn btn-secondary" style="background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">
                            Cancelar
                        </a>
                    </div>
                </form>

            </div>
        </section>
    </main>
</body>
</html>