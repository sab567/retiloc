<?php
header('Content-Type: application/json');

$host = 'localhost';
$db = 'restiloc_db';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

try {
    $bdd = new PDO($dsn, $user, $pass);
    $bdd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $idExpert = filter_input(INPUT_GET, 'idExpert', FILTER_VALIDATE_INT);

    if ($idExpert) {
        $sql = "SELECT M.idMission, M.heureDebut, G.ville, M.immatriculation, G.nom as nomGarage
                FROM MissionExpertise M
                JOIN Garage G ON M.idGarage = G.idGarage
                WHERE M.idExpert = :idExpert
                AND M.dateMission = :dateJour
                ORDER BY M.heureDebut ASC";

        $stmt = $bdd->prepare($sql);
        $stmt->execute([
            'idExpert' => $idExpert,
            'dateJour' => date('Y-m-d')
        ]);

        $resultat = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($resultat);
    } else {
        http_response_code(400);
        echo json_encode(["erreur" => "Paramètre idExpert manquant ou invalide"]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["erreur" => "Erreur interne du serveur"]);
}
?>