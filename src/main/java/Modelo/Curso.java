package Modelo;

public class Curso {
    private int id;
    private String nombre;
    private String carrera;
    private int idDocente;
    private String codigoAcceso;

    public Curso() {
    }

    public Curso(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public Curso(int id, String nombre, String carrera, int idDocente, String codigoAcceso) {
        this.id = id;
        this.nombre = nombre;
        this.carrera = carrera;
        this.idDocente = idDocente;
        this.codigoAcceso = codigoAcceso;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCarrera() {
        return carrera;
    }

    public void setCarrera(String carrera) {
        this.carrera = carrera;
    }

    public int getIdDocente() {
        return idDocente;
    }

    public void setIdDocente(int idDocente) {
        this.idDocente = idDocente;
    }

    public String getCodigoAcceso() {
        return codigoAcceso;
    }

    public void setCodigoAcceso(String codigoAcceso) {
        this.codigoAcceso = codigoAcceso;
    }
}