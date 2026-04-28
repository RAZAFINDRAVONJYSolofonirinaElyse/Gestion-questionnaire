package model;

public class Theme {
    private int idTheme;
    private String nomTheme;

    public Theme() {}

    public Theme(int idTheme, String nomTheme) {
        this.idTheme = idTheme;
        this.nomTheme = nomTheme;
    }

    public Theme(String nomTheme) {
        this.nomTheme = nomTheme;
    }

    public int getIdTheme() {
        return idTheme;
    }

    public void setIdTheme(int idTheme) {
        this.idTheme = idTheme;
    }

    public String getNomTheme() {
        return nomTheme;
    }

    public void setNomTheme(String nomTheme) {
        this.nomTheme = nomTheme;
    }

    @Override
    public String toString() {
        return "Theme{" +
                "idTheme=" + idTheme +
                ", nomTheme='" + nomTheme + '\'' +
                '}';
    }
}
