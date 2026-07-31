<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, Modelo.Docente" %>
<%
    Docente docSesion = (Docente) session.getAttribute("docente");
    if (docSesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Nuevo Alumno - Liceo Moderno</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/tabla.css">
</head>
<body>

<div class="contenido" style="max-width: 600px; margin: 40px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    <h1>Registrar Nuevo Alumno</h1>
    
    <% if (error != null) { %>
        <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
            <% if (error.equals("duplicado")) { %>
                 El código ingresado ya pertenece a otro alumno, utiliza uno diferente
            <% } else { %>
                ❌ Ocurrió un error al registrar el alumno. Verifica que todos los datos estén correctos.
            <% } %>
        </div>
    <% } %>
    
    <form action="AlumnoServlet" method="POST">
        <input type="hidden" name="accion" value="registrar">
        
        <div style="margin-bottom: 15px;">
            <label>Código:</label><br>
            <input type="text" name="codigo" required style="width: 100%; padding: 8px; margin-top: 5px;" placeholder="Ej: 12002 (Debe ser único)">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Nombre:</label><br>
            <input type="text" name="nombre" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Apellido:</label><br>
            <input type="text" name="apellido" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>Curso:</label><br>
            <select name="idCurso" required style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="">Seleccione un curso...</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conCurso = DriverManager.getConnection("jdbc:mysql://localhost:3306/registro_estudiantes?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "");
                        PreparedStatement psCurso = conCurso.prepareStatement("SELECT id, nombre FROM cursos WHERE id_docente = ? ORDER BY nombre ASC");
                        psCurso.setInt(1, docSesion.getId());
                        ResultSet rsCurso = psCurso.executeQuery();
                        while(rsCurso.next()){
                %>
                            <option value="<%= rsCurso.getInt("id") %>"><%= rsCurso.getString("nombre") %></option>
                <%
                        }
                        rsCurso.close();
                        psCurso.close();
                        conCurso.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>

        <div style="margin-bottom: 15px;">
            <label>Semestre:</label><br>
            <select name="semestre" required style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="">Seleccione semestre...</option>
                <option value="I Semestre">I Semestre</option>
                <option value="II Semestre">II Semestre</option>
                <option value="III Semestre">III Semestre</option>
                <option value="IV Semestre">IV Semestre</option>
                <option value="V Semestre">V Semestre</option>
                <option value="VI Semestre">VI Semestre</option>
            </select>
        </div>

        <div style="margin-bottom: 15px;">
            <label>Turno:</label><br>
            <select name="turno" required style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="">Seleccione turno...</option>
                <option value="Diurno">Diurno</option>
                <option value="Vespertino">Vespertino</option>
            </select>
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Email:</label><br>
            <input type="email" name="email" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Teléfono:</label><br>
            <input type="text" name="telefono" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>
        
        <button type="submit" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;">Guardar Alumno</button>
        <a href="AlumnoServlet?accion=listar" style="margin-left: 15px; text-decoration: none; color: #555;">Cancelar</a>
    </form>
</div>

</body>
</html>