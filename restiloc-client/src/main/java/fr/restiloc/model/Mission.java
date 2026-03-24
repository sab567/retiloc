package fr.restiloc.model;

public class Mission {
    private int idMission;
    private String heureDebut;
    private String ville;
    private String immatriculation;
    private String nomGarage;

    public Mission(int id, String heure, String ville, String immat, String garage) {
        this.idMission = id;
        this.heureDebut = heure;
        this.ville = ville;
        this.immatriculation = immat;
        this.nomGarage = garage;
    }

    public int getIdMission() { return idMission; }
    public String getHeureDebut() { return heureDebut; }
    public String getVille() { return ville; }
    public String getImmatriculation() { return immatriculation; }
    public String getNomGarage() { return nomGarage; }
}