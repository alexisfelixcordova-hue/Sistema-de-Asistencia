<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    String tipo = (String) session.getAttribute("tipo");
    if (!"docente".equals(tipo)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Obtener parametros de filtro
    String tipoReporte = request.getParameter("tipoReporte");
    String gradoFiltro = request.getParameter("grado");
    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");
    String formato = request.getParameter("formato");
    
    // Fechas por defecto
    if (fechaInicio == null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        fechaFin = sdf.format(cal.getTime());
        cal.set(Calendar.DAY_OF_MONTH, 1);
        fechaInicio = sdf.format(cal.getTime());
    }
    
    boolean mostrarReporte = tipoReporte != null && !tipoReporte.isEmpty();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/tabla.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-school"></i>
            <span>Liceo Moderno</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard-docente.jsp"><i class="fas fa-home"></i><span>Inicio</span></a></li>
            <li><a href="alumnos.jsp"><i class="fas fa-users"></i><span>Gestion Alumnos</span></a></li>
            <li><a href="asistencia-qr.jsp"><i class="fas fa-qrcode"></i><span>istencia QR</span></a></li>
            <li class="activo"><a href="reportes.jsp"><i class="fas fa-chart-bar"></i><span>Reportes</span></a></li>
            <li class="separador"></li>
            <li><a href="index.jsp" class="salir"><i class="fas fa-sign-out-alt"></i><span>Cerrar Sesion</span></a></li>
        </ul>
    </nav>

    <main class="contenido">
        <jsp:include page="includes/header.jsp" />

        <!-- Filtros de reporte -->
        <section class="panel panel-filtros">
            <div class="panel-header">
                <h3><i class="fas fa-filter"></i> Configurar Reporte</h3>
            </div>
            <div class="panel-body">
                <form method="GET" action="reportes.jsp" class="formulario-filtros">
                    <div class="grupo-campo">
                        <label>Tipo de Reporte:</label>
                        <select name="tipoReporte" required>
                            <option value="">Seleccione...</option>
                            <option value="asistencia-diaria" <%= "asistencia-diaria".equals(tipoReporte) ? "selected" : "" %>>Asistencia Diaria</option>
                            <option value="asistencia-semanal" <%= "asistencia-semanal".equals(tipoReporte) ? "selected" : "" %>>Asistencia Semanal</option>
                            <option value="asistencia-mensual" <%= "asistencia-mensual".equals(tipoReporte) ? "selected" : "" %>>Asistencia Mensual</option>
                            <option value="inasistencias" <%= "inasistencias".equals(tipoReporte) ? "selected" : "" %>>Inasistencias</option>
                            <option value="listado-alumnos" <%= "listado-alumnos".equals(tipoReporte) ? "selected" : "" %>>Listado de Alumnos</option>
                            <option value="por-grado" <%= "por-grado".equals(tipoReporte) ? "selected" : "" %>>Reporte por Grado</option>
                            <option value="estadisticas" <%= "estadisticas".equals(tipoReporte) ? "selected" : "" %>>Estadisticas Generales</option>
                        </select>
                    </div>
                    
                    <div class="grupo-campo">
                        <label>Grado:</label>
                        <select name="grado">
                            <option value="">Todos</option>
                            <option value="Primero" <%= "Primero".equals(gradoFiltro) ? "selected" : "" %>>Primero</option>
                            <option value="Segundo" <%= "Segundo".equals(gradoFiltro) ? "selected" : "" %>>Segundo</option>
                            <option value="Tercero" <%= "Tercero".equals(gradoFiltro) ? "selected" : "" %>>Tercero</option>
                            <option value="Cuarto" <%= "Cuarto".equals(gradoFiltro) ? "selected" : "" %>>Cuarto</option>
                            <option value="Quinto" <%= "Quinto".equals(gradoFiltro) ? "selected" : "" %>>Quinto</option>
                            <option value="Sexto" <%= "Sexto".equals(gradoFiltro) ? "selected" : "" %>>Sexto</option>
                            <option value="Septimo" <%= "Septimo".equals(gradoFiltro) ? "selected" : "" %>>Septimo</option>
                            <option value="Octavo" <%= "Octavo".equals(gradoFiltro) ? "selected" : "" %>>Octavo</option>
                            <option value="Noveno" <%= "Noveno".equals(gradoFiltro) ? "selected" : "" %>>Noveno</option>
                            <option value="Decimo" <%= "Decimo".equals(gradoFiltro) ? "selected" : "" %>>Decimo</option>
                            <option value="Undecimo" <%= "Undecimo".equals(gradoFiltro) ? "selected" : "" %>>Undecimo</option>
                        </select>
                    </div>
                    
                    <div class="grupo-campo">
                        <label>Fecha Inicio:</label>
                        <input type="date" name="fechaInicio" value="<%= fechaInicio %>">
                    </div>
                    
                    <div class="grupo-campo">
                        <label>Fecha Fin:</label>
                        <input type="date" name="fechaFin" value="<%= fechaFin %>">
                    </div>
                    
                    <div class="grupo-campo">
                        <label>Formato:</label>
                        <select name="formato">
                            <option value="pantalla">Ver en Pantalla</option>
                            <option value="pdf">Exportar PDF</option>
                            <option value="excel">Exportar Excel</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn-generar">
                        <i class="fas fa-play"></i> Generar Reporte
                    </button>
                </form>
            </div>
        </section>

        <% if (mostrarReporte) { %>
        <!-- Vista previa del reporte -->
        <section class="panel" id="panel-reporte">
            <div class="panel-header">
                <h3><i class="fas fa-eye"></i> 
                    <% if ("asistencia-diaria".equals(tipoReporte)) { %>Reporte de Asistencia Diaria
                    <% } else if ("asistencia-semanal".equals(tipoReporte)) { %>Reporte de Asistencia Semanal
                    <% } else if ("asistencia-mensual".equals(tipoReporte)) { %>Reporte de Asistencia Mensual
                    <% } else if ("inasistencias".equals(tipoReporte)) { %>Reporte de Inasistencias
                    <% } else if ("listado-alumnos".equals(tipoReporte)) { %>Listado de Alumnos
                    <% } else if ("por-grado".equals(tipoReporte)) { %>Reporte por Grado
                    <% } else if ("estadisticas".equals(tipoReporte)) { %>Estadisticas Generales
                    <% } else { %>Reporte <% } %>
                </h3>
                <div class="acciones-reporte">
                    <button class="btn-icono" onclick="window.print()" title="Imprimir"><i class="fas fa-print"></i></button>
                    <button class="btn-icono" title="Descargar PDF"><i class="fas fa-file-pdf"></i></button>
                    <button class="btn-icono" title="Descargar Excel"><i class="fas fa-file-excel"></i></button>
                </div>
            </div>
            <div class="panel-body">
                <div class="reporte-encabezado">
                    <h4>Liceo Moderno</h4>
                    <p>Periodo: <%= fechaInicio %> - <%= fechaFin %></p>
                    <hr>
                </div>
                
                <% if ("asistencia-diaria".equals(tipoReporte) || "asistencia-semanal".equals(tipoReporte) || "asistencia-mensual".equals(tipoReporte)) { %>
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Presentes</th>
                            <th>Ausentes</th>
                            <th>Tarde</th>
                            <th>% Asistencia</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>23/07/2026</td>
                            <td><span class="badge badge-activo">218</span></td>
                            <td><span class="badge badge-inactivo">20</span></td>
                            <td><span class="badge badge-advertencia">7</span></td>
                            <td><strong>89%</strong></td>
                        </tr>
                        <tr>
                            <td>22/07/2026</td>
                            <td><span class="badge badge-activo">235</span></td>
                            <td><span class="badge badge-inactivo">8</span></td>
                            <td><span class="badge badge-advertencia">2</span></td>
                            <td><strong>96%</strong></td>
                        </tr>
                        <tr>
                            <td>21/07/2026</td>
                            <td><span class="badge badge-activo">210</span></td>
                            <td><span class="badge badge-inactivo">30</span></td>
                            <td><span class="badge badge-advertencia">5</span></td>
                            <td><strong>86%</strong></td>
                        </tr>
                    </tbody>
                </table>
                
                <% } else if ("inasistencias".equals(tipoReporte)) { %>
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Codigo</th>
                            <th>Alumno</th>
                            <th>Grado</th>
                            <th>Total Faltas</th>
                            <th>Ultima Falta</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="celda-codigo">LIC05P00098213</td>
                            <td class="celda-nombre">Carlos Mendoza</td>
                            <td><span class="badge badge-grado">Sexto</span></td>
                            <td><strong>8</strong> <span class="badge badge-inactivo">ALERTA</span></td>
                            <td>17/07/2026</td>
                        </tr>
                        <tr>
                            <td class="celda-codigo">LIC05P00098215</td>
                            <td class="celda-nombre">Ana Lopez</td>
                            <td><span class="badge badge-grado">Cuarto</span></td>
                            <td><strong>6</strong> <span class="badge badge-inactivo">ALERTA</span></td>
                            <td>16/07/2026</td>
                        </tr>
                        <tr>
                            <td class="celda-codigo">LIC05P00098216</td>
                            <td class="celda-nombre">Pedro Sanchez</td>
                            <td><span class="badge badge-grado">Quinto</span></td>
                            <td><strong>5</strong></td>
                            <td>15/07/2026</td>
                        </tr>
                    </tbody>
                </table>
                
                <% } else if ("listado-alumnos".equals(tipoReporte)) { %>
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Codigo</th>
                            <th>Nombre</th>
                            <th>Grado</th>
                            <th>Email</th>
                            <th>Telefono</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="celda-codigo">LIC05P00098210</td>
                            <td class="celda-nombre">Maria Gonzalez</td>
                            <td><span class="badge badge-grado">Quinto</span></td>
                            <td>maria@liceo.edu</td>
                            <td>3001234567</td>
                            <td><span class="badge badge-activo">Activo</span></td>
                        </tr>
                        <tr>
                            <td class="celda-codigo">LIC05P00098211</td>
                            <td class="celda-nombre">Alejandro Gutierrez</td>
                            <td><span class="badge badge-grado">Quinto</span></td>
                            <td>alejandro@liceo.edu</td>
                            <td>3523444251</td>
                            <td><span class="badge badge-activo">Activo</span></td>
                        </tr>
                        <tr>
                            <td class="celda-codigo">LIC05P00098212</td>
                            <td class="celda-nombre">Sofia Ramirez</td>
                            <td><span class="badge badge-grado">Cuarto</span></td>
                            <td>sofia@liceo.edu</td>
                            <td>3009876543</td>
                            <td><span class="badge badge-activo">Activo</span></td>
                        </tr>
                    </tbody>
                </table>
                
                <% } else if ("por-grado".equals(tipoReporte)) { %>
                <table class="tabla-datos">
                    <thead>
                        <tr>
                            <th>Grado</th>
                            <th>Total Alumnos</th>
                            <th>Presentes Hoy</th>
                            <th>Ausentes</th>
                            <th>% Asistencia</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Primero</strong></td>
                            <td>35</td>
                            <td><span class="badge badge-activo">32</span></td>
                            <td><span class="badge badge-inactivo">3</span></td>
                            <td><span class="badge badge-activo">91%</span></td>
                        </tr>
                        <tr>
                            <td><strong>Segundo</strong></td>
                            <td>42</td>
                            <td><span class="badge badge-activo">40</span></td>
                            <td><span class="badge badge-inactivo">2</span></td>
                            <td><span class="badge badge-activo">95%</span></td>
                        </tr>
                        <tr>
                            <td><strong>Tercero</strong></td>
                            <td>38</td>
                            <td><span class="badge badge-activo">35</span></td>
                            <td><span class="badge badge-inactivo">3</span></td>
                            <td><span class="badge badge-activo">92%</span></td>
                        </tr>
                        <tr>
                            <td><strong>Cuarto</strong></td>
                            <td>45</td>
                            <td><span class="badge badge-activo">42</span></td>
                            <td><span class="badge badge-inactivo">3</span></td>
                            <td><span class="badge badge-activo">93%</span></td>
                        </tr>
                        <tr>
                            <td><strong>Quinto</strong></td>
                            <td>40</td>
                            <td><span class="badge badge-activo">36</span></td>
                            <td><span class="badge badge-inactivo">4</span></td>
                            <td><span class="badge badge-activo">90%</span></td>
                        </tr>
                        <tr>
                            <td><strong>Sexto</strong></td>
                            <td>45</td>
                            <td><span class="badge badge-activo">33</span></td>
                            <td><span class="badge badge-inactivo">12</span></td>
                            <td><span class="badge badge-advertencia">73%</span></td>
                        </tr>
                    </tbody>
                </table>
                
                <% } else if ("estadisticas".equals(tipoReporte)) { %>
                <div class="estadisticas-reporte">
                    <div class="estadistica-item" style="background: #f0fdf4;">
                        <h3 style="color: #059669;">245</h3>
                        <p>Total Alumnos</p>
                    </div>
                    <div class="estadistica-item" style="background: #eff6ff;">
                        <h3 style="color: #2563eb;">89%</h3>
                        <p>Promedio Asistencia</p>
                    </div>
                    <div class="estadistica-item" style="background: #fef3c7;">
                        <h3 style="color: #d97706;">27</h3>
                        <p>Inasistencias Hoy</p>
                    </div>
                    <div class="estadistica-item" style="background: #fdf2f8;">
                        <h3 style="color: #db2777;">18</h3>
                        <p>Total Docentes</p>
                    </div>
                </div>
                
                <h4 style="margin: 20px 0 10px;">Tendencia Mensual</h4>
                <table class="tabla-datos">
                    <thead>
                        <tr><th>Mes</th><th>Dias Clase</th><th>Promedio Asistencia</th><th>Mejor Grado</th></tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Julio 2026</td>
                            <td>20</td>
                            <td><span class="badge badge-activo">89%</span></td>
                            <td>Cuarto (93%)</td>
                        </tr>
                        <tr>
                            <td>Junio 2026</td>
                            <td>22</td>
                            <td><span class="badge badge-activo">91%</span></td>
                            <td>Segundo (95%)</td>
                        </tr>
                        <tr>
                            <td>Mayo 2026</td>
                            <td>20</td>
                            <td><span class="badge badge-activo">87%</span></td>
                            <td>Cuarto (92%)</td>
                        </tr>
                    </tbody>
                </table>
                <% } %>
            </div>
        </section>
        <% } %>

        <!-- Reportes rapidos -->
        <section class="reportes-predefinidos">
            <h3><i class="fas fa-star"></i> Reportes Rapidos</h3>
            <div class="grid-reportes">
                <a href="reportes.jsp?tipoReporte=asistencia-diaria&fechaInicio=<%= fechaInicio %>&fechaFin=<%= fechaFin %>" class="reporte-rapido">
                    <i class="fas fa-calendar-day"></i>
                    <h4>Hoy</h4>
                    <p>Asistencia del dia</p>
                </a>
                <a href="reportes.jsp?tipoReporte=asistencia-semanal&fechaInicio=<%= fechaInicio %>&fechaFin=<%= fechaFin %>" class="reporte-rapido">
                    <i class="fas fa-calendar-week"></i>
                    <h4>Esta Semana</h4>
                    <p>Resumen semanal</p>
                </a>
                <a href="reportes.jsp?tipoReporte=asistencia-mensual&fechaInicio=<%= fechaInicio %>&fechaFin=<%= fechaFin %>" class="reporte-rapido">
                    <i class="fas fa-calendar-alt"></i>
                    <h4>Este Mes</h4>
                    <p>Reporte mensual</p>
                </a>
                <a href="reportes.jsp?tipoReporte=inasistencias&fechaInicio=<%= fechaInicio %>&fechaFin=<%= fechaFin %>" class="reporte-rapido">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h4>Alerta de Faltas</h4>
                    <p>Alumnos con +3 faltas</p>
                </a>
            </div>
        </section>
    </main>
</body>
</html>
