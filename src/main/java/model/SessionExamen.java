package model;

import java.time.LocalDateTime;

public class SessionExamen {
    private int numSession;
    private int numExam;
    private String numEtudiant;
    private String theme;
    private LocalDateTime dateSession;
    private String statut;
    private int note;

    public SessionExamen() {}

    public SessionExamen(int numSession, int numExam, String numEtudiant, String theme, 
                         LocalDateTime dateSession, String statut, int note) {
        this.numSession = numSession;
        this.numExam = numExam;
        this.numEtudiant = numEtudiant;
        this.theme = theme;
        this.dateSession = dateSession;
        this.statut = statut;
        this.note = note;
    }

    public int getNumSession() {
        return numSession;
    }

    public void setNumSession(int numSession) {
        this.numSession = numSession;
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

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public LocalDateTime getDateSession() {
        return dateSession;
    }

    public void setDateSession(LocalDateTime dateSession) {
        this.dateSession = dateSession;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public int getNote() {
        return note;
    }

    public void setNote(int note) {
        this.note = note;
    }
}
