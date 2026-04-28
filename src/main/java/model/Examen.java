package model;

public class Examen {
    private int numExam;
    private String numEtudiant;
    private String anneeUniv;
    private int note;
    private String theme;

    // Champs d'affichage issus de la jointure avec etudiant
    private String nomEtudiant;
    private String prenomsEtudiant;
    private String niveauEtudiant;

    public Examen() {}

    public Examen(int numExam, String numEtudiant, String anneeUniv, int note, String theme) {
        this.numExam = numExam;
        this.numEtudiant = numEtudiant;
        this.anneeUniv = anneeUniv;
        this.note = note;
        this.theme = theme;
    }

    public int getNumExam() {
        return numExam;
    }

    public void setNumExam(int numExam) {
        this.numExam = numExam;
    }

    public String getNumEtudiant() {
        return numEtudiant;
    }

    public void setNumEtudiant(String numEtudiant) {
        this.numEtudiant = numEtudiant;
    }

    public String getAnneeUniv() {
        return anneeUniv;
    }

    public void setAnneeUniv(String anneeUniv) {
        this.anneeUniv = anneeUniv;
    }

    public int getNote() {
        return note;
    }

    public void setNote(int note) {
        this.note = note;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getNomEtudiant() { return nomEtudiant; }
    public void setNomEtudiant(String nomEtudiant) { this.nomEtudiant = nomEtudiant; }

    public String getPrenomsEtudiant() { return prenomsEtudiant; }
    public void setPrenomsEtudiant(String prenomsEtudiant) { this.prenomsEtudiant = prenomsEtudiant; }

    public String getNiveauEtudiant() { return niveauEtudiant; }
    public void setNiveauEtudiant(String niveauEtudiant) { this.niveauEtudiant = niveauEtudiant; }
}

