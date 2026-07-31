package Modelo;

public class Asistencia {
    
    private int id;
    private int idAlumno;
    private String fecha;
    private String horaEntrada;
    private String horaSalida;
    private String estado;
    private String observacion;
    
    // Datos del alumno para mostrar
    private String nombreAlumno;
    private String codigoAlumno;
    private String gradoAlumno;
    
    public Asistencia() {
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getIdAlumno() {
        return idAlumno;
    }
    
    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }
    
    public String getFecha() {
        return fecha;
    }
    
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }
    
    public String getHoraEntrada() {
        return horaEntrada;
    }
    
    public void setHoraEntrada(String horaEntrada) {
        this.horaEntrada = horaEntrada;
    }
    
    public String getHoraSalida() {
        return horaSalida;
    }
    
    public void setHoraSalida(String horaSalida) {
        this.horaSalida = horaSalida;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public String getObservacion() {
        return observacion;
    }
    
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
    public String getNombreAlumno() {
        return nombreAlumno;
    }
    
    public void setNombreAlumno(String nombreAlumno) {
        this.nombreAlumno = nombreAlumno;
    }
    
    public String getCodigoAlumno() {
        return codigoAlumno;
    }
    
    public void setCodigoAlumno(String codigoAlumno) {
        this.codigoAlumno = codigoAlumno;
    }
    
    public String getGradoAlumno() {
        return gradoAlumno;
    }
    
    public void setGradoAlumno(String gradoAlumno) {
        this.gradoAlumno = gradoAlumno;
    }
}