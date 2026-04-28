package model;

public class Etudiant {
    private String numEtudiant;
    private String nom;
    private String prenoms;
    private String niveau;
    private String adr_email;


public Etudiant(){}

public Etudiant(String numEtudiant, String nom, String prenoms, String niveau, String adr_email) {
    this.numEtudiant = numEtudiant;
    this.nom = nom;
    this.prenoms = prenoms;
    this.niveau = niveau;
    this.adr_email = adr_email;
}

public String getNumEtudiant(){
    return this.numEtudiant;
}

public String getNom(){
    return this.nom;
}

public String getPrenoms(){
    return this.prenoms;
}

public String getNiveau(){
    return this.niveau;
}

public String getAdr_email(){
    return this.adr_email;
}

public void setNumEtudiant(String numEtudiant){
    this.numEtudiant = numEtudiant;
}

public void setNom(String nom){
    this.nom = nom;
}

public void setPrenoms(String prenoms){
    this.prenoms = prenoms;
}

public void setNiveau(String niveau){
    this.niveau = niveau;
}

public void setAdr_email(String adr_email){
    this.adr_email = adr_email;
}

}