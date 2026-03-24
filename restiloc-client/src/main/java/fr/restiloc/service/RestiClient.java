package fr.restiloc.service;

import java.net.URI;
import java.net.http.*;
import java.util.*;
import org.json.JSONArray;
import fr.restiloc.model.Mission;

public class RestiClient {
    private static final String URL_API = "http://localhost/restiloc/api/getLesMissionsByIdExpert.php?idExpert=";

    public static List<Mission> fetchMissions(int idExpert) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(URL_API + idExpert)).build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        List<Mission> missions = new ArrayList<>();
        JSONArray jsonArray = new JSONArray(response.body());
        for (int i = 0; i < jsonArray.length(); i++) {
            var obj = jsonArray.getJSONObject(i);
            missions.add(new Mission(
                obj.getInt("idMission"), obj.getString("heureDebut"),
                obj.getString("ville"), obj.getString("immatriculation"),
                obj.getString("nomGarage")
            ));
        }
        return missions;
    }
}
