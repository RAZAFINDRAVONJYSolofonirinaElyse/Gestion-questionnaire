package model;

public class Niveau {
    private int idNiveau;
    private String nomNiveau;

    public Niveau() {}

    public Niveau(int idNiveau, String nomNiveau) {
        this.idNiveau = idNiveau;
        this.nomNiveau = nomNiveau;
    }

    public Niveau(String nomNiveau) {
        this.nomNiveau = nomNiveau;
    }

    public int getIdNiveau() {
        return idNiveau;
    }

    public void setIdNiveau(int idNiveau) {
        this.idNiveau = idNiveau;
    }

    public String getNomNiveau() {
        return nomNiveau;
    }

    public void setNomNiveau(String nomNiveau) {
        this.nomNiveau = nomNiveau;
    }

    @Override
    public String toString() {
        return "Niveau{" +
                "idNiveau=" + idNiveau +
                ", nomNiveau='" + nomNiveau + '\'' +
                '}';
    }
}
