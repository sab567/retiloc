package fr.restiloc;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class MainApp extends Application {
    @Override
    public void start(Stage stage) throws Exception {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/fr/restiloc/view/missions.fxml"));
        stage.setScene(new Scene(loader.load()));
        stage.setTitle("Restiloc Expert");
        stage.show();
    }
}
