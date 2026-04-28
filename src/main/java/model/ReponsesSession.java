package model;

public class ReponsesSession {
    private int numReponse;
    private int numSession;
    private int numQuest;
    private int reponseEtudiant;
    private boolean estCorrecte;

    public ReponsesSession() {}

    public ReponsesSession(int numReponse, int numSession, int numQuest, 
                          int reponseEtudiant, boolean estCorrecte) {
        this.numReponse = numReponse;
        this.numSession = numSession;
        this.numQuest = numQuest;
        this.reponseEtudiant = reponseEtudiant;
        this.estCorrecte = estCorrecte;
    }

    public int getNumReponse() {
        return numReponse;
    }

    public void setNumReponse(int numReponse) {
        this.numReponse = numReponse;
    }

    public int getNumSession() {
        return numSession;
    }

    public void setNumSession(int numSession) {
        this.numSession = numSession;
    }

    public int getNumQuest() {
        return numQuest;
    }

    public void setNumQuest(int numQuest) {
        this.numQuest = numQuest;
    }

    public int getReponseEtudiant() {
        return reponseEtudiant;
    }

    public void setReponseEtudiant(int reponseEtudiant) {
        this.reponseEtudiant = reponseEtudiant;
    }

    public boolean isEstCorrecte() {
        return estCorrecte;
    }

    public void setEstCorrecte(boolean estCorrecte) {
        this.estCorrecte = estCorrecte;
    }
}
