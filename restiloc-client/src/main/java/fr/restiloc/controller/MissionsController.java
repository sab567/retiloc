package fr.restiloc.controller;

import fr.restiloc.model.Mission;
import fr.restiloc.service.RestiClient;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;

import java.util.HashSet;
import java.util.Set;

public class MissionsController {
    @FXML
    private TableView<Mission> tableMissions;
    @FXML
    private TableColumn<Mission, String> colHeure, colVille, colGarage, colImmat;

    private Set<Integer> missionsIndisponibles = new HashSet<>();

    @FXML
    public void initialize() {
        colHeure.setCellValueFactory(new PropertyValueFactory<>("heureDebut"));
        colVille.setCellValueFactory(new PropertyValueFactory<>("ville"));
        colGarage.setCellValueFactory(new PropertyValueFactory<>("nomGarage"));
        colImmat.setCellValueFactory(new PropertyValueFactory<>("immatriculation"));

        tableMissions.setRowFactory(tv -> new TableRow<Mission>() {
            @Override
            protected void updateItem(Mission mission, boolean empty) {
                super.updateItem(mission, empty);
                if (empty || mission == null) {
                    setStyle("");
                } else if (missionsIndisponibles.contains(mission.getIdMission())) {
                    setStyle("-fx-background-color: #e74c3c; -fx-text-fill: white;");
                } else {
                    setStyle("");
                }
            }
        });

        chargerDonnees();
    }

    @FXML
    private void chargerDonnees() {
        try {
            tableMissions.getItems().setAll(RestiClient.fetchMissions(1));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void marquerIndisponible() {
        Mission selection = tableMissions.getSelectionModel().getSelectedItem();
        if (selection != null) {
            missionsIndisponibles.add(selection.getIdMission());
            tableMissions.refresh();

            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle("Mission Indisponible");
            alert.setHeaderText(null);
            alert.setContentText("La mission n°" + selection.getIdMission()
                    + " a été marquée comme Indisponible (client absent).");
            alert.showAndWait();
        } else {
            Alert alert = new Alert(Alert.AlertType.WARNING);
            alert.setTitle("Aucune sélection");
            alert.setHeaderText(null);
            alert.setContentText("Veuillez sélectionner une mission dans le tableau.");
            alert.showAndWait();
        }
    }
}