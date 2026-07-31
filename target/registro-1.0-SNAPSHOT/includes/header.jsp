<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Variables para los contadores de la base de datos
    int totalAlumnos = 0;
    int asistenciaHoy = 0;
    int inasistenciasHoy = 0;
    int totalDocentes = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Conexión corregida con soporte UTF-8 para tildes y la letra Ñ
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/registro_estudiantes?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", 
            "root", 
            ""
        );

        // 1. Contar Alumnos Activos
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM alumnos WHERE estado = 'Activo'");
        if (rs1.next()) { totalAlumnos = rs1.getInt(1); }
        rs1.close();
        st1.close();

        // 2. Contar Asistencia de Hoy (Presentes o Tarde)
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM asistencias WHERE fecha = CURDATE() AND estado IN ('Presente', 'Tarde')");
        if (rs2.next()) { asistenciaHoy = rs2.getInt(1); }
        rs2.close();
        st2.close();

        // 3. Contar Inasistencias de Hoy
        Statement st3 = con.createStatement();
        ResultSet rs3 = st3.executeQuery("SELECT COUNT(*) FROM asistencias WHERE fecha = CURDATE() AND estado = 'Ausente'");
        if (rs3.next()) { inasistenciasHoy = rs3.getInt(1); }
        rs3.close();
        st3.close();

        // 4. Contar Docentes Activos
        Statement st4 = con.createStatement();
        ResultSet rs4 = st4.executeQuery("SELECT COUNT(*) FROM docentes WHERE estado = 'Activo'");
        if (rs4.next()) { totalDocentes = rs4.getInt(1); }
        rs4.close();
        st4.close();

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>