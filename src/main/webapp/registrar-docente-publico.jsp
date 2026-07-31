<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Docente - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="body-login">
    <div class="contenedor-login" style="max-width: 500px; width: 90%; margin: 40px auto; display: flex; flex-direction: column;">
        <div class="login-derecha" style="width: 100%; padding: 35px; background: #ffffff; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
            <div class="login-formulario">
                <div class="login-tipo" style="text-align: center; margin-bottom: 25px;">
                    <i class="fas fa-user-plus" style="font-size: 38px; color: #0d6efd; margin-bottom: 10px;"></i>
                    <h2 style="color: #333; font-size: 24px; font-weight: 700; margin: 0;">Registro de Nuevo Docente</h2>
                </div>
                
                <form action="DocenteServlet" method="POST" style="display: flex; flex-direction: column; gap: 15px;">
                    <input type="hidden" name="accion" value="registrar">
                    <input type="hidden" name="origen" value="publico">
                    
                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-user"></i> Usuario:</label>
                        <input type="text" name="usuario" class="form-control" required placeholder="Ej. jperez" style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-lock"></i> Contraseña:</label>
                        <input type="password" name="password" class="form-control" required placeholder="******" style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-id-card"></i> Nombre Completo:</label>
                        <input type="text" name="nombre" class="form-control" required placeholder="Ej. Juan Pérez" style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box;">
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-envelope"></i> Correo Electrónico:</label>
                        <input type="email" name="email" class="form-control" placeholder="correo@liceo.edu.co" style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box;">
                    </div>

                    <!-- Selector de Carrera Profesional -->
                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-graduation-cap"></i> Carrera Profesional:</label>
                        <select name="carrera" class="form-control" required style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="">Seleccione un programa...</option>
                            <option value="ASISTENCIA ADMINISTRATIVA">ASISTENCIA ADMINISTRATIVA</option>
                            <option value="DISEÑO Y PROGRAMACIÓN WEB">DISEÑO Y PROGRAMACIÓN WEB</option>
                            <option value="ELECTRICIDAD INDUSTRIAL">ELECTRICIDAD INDUSTRIAL</option>
                            <option value="ELECTRÓNICA INDUSTRIAL">ELECTRÓNICA INDUSTRIAL</option>
                            <option value="MANTENIMIENTO DE MAQUINARIA PESADA">MANTENIMIENTO DE MAQUINARIA PESADA</option>
                            <option value="MECATRÓNICA AUTOMOTRIZ">MECATRÓNICA AUTOMOTRIZ</option>
                            <option value="MECÁNICA DE PRODUCCIÓN INDUSTRIAL">MECÁNICA DE PRODUCCIÓN INDUSTRIAL</option>
                            <option value="METALURGIA">METALURGIA</option>
                            <option value="TECNOLOGÍA DE ANÁLISIS QUÍMICO">TECNOLOGÍA DE ANÁLISIS QUÍMICO</option>
                        </select>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px;"><i class="fas fa-shield-alt"></i> Rol en el Sistema:</label>
                        <select name="rol" class="form-control" style="width: 100%; padding: 11px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; background-color: #fff; box-sizing: border-box;">
                            <option value="profesor">Profesor</option>
                        </select>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-top: 15px; border-top: 1px solid #eee;">
                        <a href="login.jsp?tipo=docente" style="color: #6c757d; text-decoration: none; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                            <i class="fas fa-arrow-left"></i> Ir al Login
                        </a>
                        <button type="submit" class="btn btn-primary" style="padding: 11px 22px; background: #0d6efd; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                            <i class="fas fa-save"></i> Registrarse
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>