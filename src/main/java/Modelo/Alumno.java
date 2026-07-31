package Modelo;

public class Alumno {
    private int id;
    private String codigo;
    private String nombre;
    private String apellido;
    private int idCurso;
    private String nombreCurso;
    private String semestre;
    private String turno;
    private String email;
    private String telefono;
    private String direccion;
    private String acudiente;
    private String telefonoAcudiente;
    private String estado;
    private String usuario;
    private String password;
    private String carrera; // <--- Atributo agregado

    public Alumno() {
    }

    // Getters y Setters requeridos por el DAO
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public int getIdCurso() { return idCurso; }
    public void setIdCurso(int idCurso) { this.idCurso = idCurso; }

    public String getNombreCurso() { return nombreCurso; }
    public void setNombreCurso(String nombreCurso) { this.nombreCurso = nombreCurso; }

    public String getSemestre() { return semestre; }
    public void setSemestre(String semestre) { this.semestre = semestre; }

    public String getTurno() { return turno; }
    public void setTurno(String turno) { this.turno = turno; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getAcudiente() { return acudiente; }
    public void setAcudiente(String acudiente) { this.acudiente = acudiente; }

    public String getTelefonoAcudiente() { return telefonoAcudiente; }
    public void setTelefonoAcudiente(String telefonoAcudiente) { this.telefonoAcudiente = telefonoAcudiente; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    // --- Métodos de la carrera agregados para el JSP ---
    public String getCarrera() { return carrera; }
    public void setCarrera(String carrera) { this.carrera = carrera; }
}