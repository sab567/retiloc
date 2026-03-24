-- 1. Création du schéma des experts
CREATE TABLE Expert (
    idExpert INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100),
    login VARCHAR(50),
    mdp_hash VARCHAR(255) -- Stockage sécurisé (RGPD)
) ENGINE=InnoDB;

-- 2. Création du schéma des garages
CREATE TABLE Garage (
    idGarage INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    ville VARCHAR(50),
    tel VARCHAR(20)
) ENGINE=InnoDB;

-- 3. Création des missions d'expertise
CREATE TABLE MissionExpertise (
    idMission INT PRIMARY KEY AUTO_INCREMENT,
    dateMission DATE,
    heureDebut TIME,
    idGarage INT,
    idExpert INT,
    immatriculation VARCHAR(15),
    CONSTRAINT fk_garage FOREIGN KEY (idGarage) REFERENCES Garage(idGarage),
    CONSTRAINT fk_expert FOREIGN KEY (idExpert) REFERENCES Expert(idExpert)
) ENGINE=InnoDB;

-- 4. Table d'audit pour la Mission 4 (Trigger)
CREATE TABLE AUDIT_SUPPRESSION (
    idAudit INT PRIMARY KEY AUTO_INCREMENT,
    idMissionSupprimee INT,
    dateSuppression DATETIME
) ENGINE=InnoDB;

-- 5. Données de test
INSERT INTO Expert (nom, prenom, email, login, mdp_hash)
VALUES ('Lupin', 'Arsène', 'a.lupin@restiloc.fr', 'alupin', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHeFOnNVatB.9.2DkXzZ.v7Xv6YmN9Z9y6');

INSERT INTO Garage (nom, ville, tel) VALUES ('Garage de l\'Orb', 'Béziers', '0467000000');

-- 1. Ajout de nouveaux garages pour varier les lieux
INSERT INTO Garage (nom, ville, tel) VALUES
('Garage des Cimes', 'Montpellier', '0467112233'),
('Auto Citronelle', 'Lavérune', '0467445566'),
('Espace Carrosserie', 'Castelnau-le-Lez', '0467778899');

-- 2. Ajout de nouveaux experts (MDP par défaut : "Resti2026!")
-- Note : idExpert 1 est déjà Lupin
INSERT INTO Expert (nom, prenom, email, login, mdp_hash) VALUES
('Holmes', 'Sherlock', 's.holmes@restiloc.fr', 'sholmes', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHeFOnNVatB.9.2DkXzZ.v7Xv6YmN9Z9y6'),
('Poirot', 'Hercule', 'h.poirot@restiloc.fr', 'hpoirot', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHeFOnNVatB.9.2DkXzZ.v7Xv6YmN9Z9y6'),
('Maigret', 'Jules', 'j.maigret@restiloc.fr', 'jmaigret', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHeFOnNVatB.9.2DkXzZ.v7Xv6YmN9Z9y6');

-- 3. Ajout de missions pour AUJOURD'HUI (apparaîtront dans l'API)
INSERT INTO MissionExpertise (dateMission, heureDebut, idGarage, idExpert, immatriculation) VALUES
(CURDATE(), '08:30:00', 1, 1, 'AA-229-XY'),
(CURDATE(), '10:45:00', 2, 1, 'BC-548-ZX'),
(CURDATE(), '14:00:00', 3, 2, 'AB-346-TU'),
(CURDATE(), '16:15:00', 4, 2, 'DE-998-RS'),
(CURDATE(), '09:00:00', 2, 3, 'FG-112-HI');

-- 4. Ajout de missions pour DEMAIN (pour tester le filtrage temporel)
INSERT INTO MissionExpertise (dateMission, heureDebut, idGarage, idExpert, immatriculation) VALUES
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', 1, 1, 'ZZ-999-ZZ'),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00', 4, 3, 'XY-001-AB');

-- 5. Ajout de missions PASSÉES (pour l'historique)
INSERT INTO MissionExpertise (dateMission, heureDebut, idGarage, idExpert, immatriculation) VALUES
(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '15:00:00', 2, 1, 'OLD-123-OK');

DELIMITER //

CREATE TRIGGER trig_audit_delete_mission
AFTER DELETE ON MissionExpertise
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_SUPPRESSION (idMissionSupprimee, dateSuppression)
    VALUES (OLD.idMission, NOW());
END //

DELIMITER ;