<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("paginaActiva", "dashboard"); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Control Asistencia</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
</head>
<body>
<div class="app-shell">

    <%@ include file="includes/header.jsp" %>

    <div class="app-content">

        <h1 class="page-titulo">Panel de control principal</h1>

        <!-- ===================== TARJETAS KPI ===================== -->
        <div class="estadisticas">

            <div class="tarjeta tarjeta-estadistica tarjeta-azul">
                <div class="info">
                    <h3>Total Alumnos</h3>
                    <div class="numero">1,277</div>
                </div>
                <div class="icono">&#128101;</div>
            </div>

            <div class="tarjeta tarjeta-estadistica tarjeta-verde">
                <div class="info">
                    <h3>Total Asistencias</h3>
                    <div class="numero">19,079</div>
                </div>
                <div class="icono">&#9989;</div>
            </div>

            <div class="tarjeta tarjeta-estadistica tarjeta-naranja">
                <div class="info">
                    <h3>Asistencias Hoy</h3>
                    <div class="numero">589</div>
                </div>
                <div class="icono">&#128197;</div>
            </div>

            <div class="tarjeta tarjeta-estadistica tarjeta-morado">
                <div class="info">
                    <h3>Porcentaje Hoy</h3>
                    <div class="numero">46.1%</div>
                </div>
                <div class="icono">&#128200;</div>
            </div>

        </div>

        <!-- ===================== GRAFICO + TOP 5 ===================== -->
        <div class="dashboard-fila">

            <div class="tarjeta">
                <div class="panel-header">
                    <h3>Asistencias &mdash; &Uacute;ltimos 7 D&iacute;as</h3>
                </div>
                <div class="grafico-wrap">
                    <canvas id="graficoAsistencias"></canvas>
                </div>
            </div>

            <div class="tarjeta">
                <div class="panel-header">
                    <h3>Top 5 Alumnos</h3>
                    <span class="panel-subtexto">Asistencias</span>
                </div>
                <ul class="top-alumnos-lista">

                    <li class="top-alumno-item">
                        <span class="top-alumno-rank">1</span>
                        <span class="avatar-iniciales" style="background:#3b82f6;">SM</span>
                        <div class="top-alumno-info">
                            <div class="nombre">Santiago Mendoza Guti&eacute;rrez</div>
                            <div class="codigo">LIC05P00120066</div>
                        </div>
                        <span class="badge badge-count">23</span>
                    </li>

                    <li class="top-alumno-item">
                        <span class="top-alumno-rank">2</span>
                        <span class="avatar-iniciales" style="background:#16b768;">SR</span>
                        <div class="top-alumno-info">
                            <div class="nombre">Sebasti&aacute;n Rivera Jim&eacute;nez</div>
                            <div class="codigo">LIC05P00103058</div>
                        </div>
                        <span class="badge badge-count">22</span>
                    </li>

                    <li class="top-alumno-item">
                        <span class="top-alumno-rank">3</span>
                        <span class="avatar-iniciales" style="background:#f5a623;">AG</span>
                        <div class="top-alumno-info">
                            <div class="nombre">Ana Guti&eacute;rrez Flores</div>
                            <div class="codigo">LIC05P00098211</div>
                        </div>
                        <span class="badge badge-count">21</span>
                    </li>

                    <li class="top-alumno-item">
                        <span class="top-alumno-rank">4</span>
                        <span class="avatar-iniciales" style="background:#7c3aed;">VO</span>
                        <div class="top-alumno-info">
                            <div class="nombre">Valentina Ortiz Mart&iacute;nez</div>
                            <div class="codigo">LIC05P00087345</div>
                        </div>
                        <span class="badge badge-count">21</span>
                    </li>

                    <li class="top-alumno-item">
                        <span class="top-alumno-rank">5</span>
                        <span class="avatar-iniciales" style="background:#17c9c0;">DC</span>
                        <div class="top-alumno-info">
                            <div class="nombre">Diego Castillo Rojas</div>
                            <div class="codigo">LIC05P00076210</div>
                        </div>
                        <span class="badge badge-count">20</span>
                    </li>

                </ul>
            </div>

        </div>

    </div>
</div>

<script>
    var etiquetas = ['Jun 6', 'Jun 8', 'Jun 9', 'Jun 10', 'Jun 11', 'Jun 12'];
    var datos = [430, 470, 455, 500, 460, 480];

    var ctx = document.getElementById('graficoAsistencias').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: etiquetas,
            datasets: [{
                label: 'Asistencias',
                data: datos,
                borderColor: '#17c9c0',
                backgroundColor: 'rgba(23,201,192,0.12)',
                pointBackgroundColor: '#17c9c0',
                fill: true,
                tension: 0.35,
                borderWidth: 2.5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: false, grid: { color: '#f0f0f5' } },
                x: { grid: { display: false } }
            }
        }
    });
</script>

</body>
</html>