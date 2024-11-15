CREATE TABLE Utilisateur (
    id_utilisateur INT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    email VARCHAR(255),
    mot_de_passe VARCHAR(255),
    role ENUM('cycliste', 'gestionnaire_reseau', 'RH', 'administrateur')
);

CREATE TABLE Velo (
    id_velo INT PRIMARY KEY,
    autonomie INT,
    capacite INT,
    etat ENUM('disponible', 'utilisé', 'en_maintenance')
);

CREATE TABLE Tournee (
    id_tournee INT PRIMARY KEY,
    date DATE,
    etat ENUM('planifiee', 'en_cours', 'terminee')
);

CREATE TABLE Rue (
    id_rue INT PRIMARY KEY,
    nom VARCHAR(255)
);

CREATE TABLE Arret (
    id_arret INT PRIMARY KEY,
    nom VARCHAR(255),
    rue_id INT,
    FOREIGN KEY (rue_id) REFERENCES Rue(id_rue)
);

CREATE TABLE Trajet (
    id_trajet INT PRIMARY KEY,
    tournee_id INT,
    velo_id INT,
    cycliste_id INT,
    FOREIGN KEY (tournee_id) REFERENCES Tournee(id_tournee),
    FOREIGN KEY (velo_id) REFERENCES Velo(id_velo),
    FOREIGN KEY (cycliste_id) REFERENCES Utilisateur(id_utilisateur)
);

CREATE TABLE Etape (
    id_etape INT PRIMARY KEY,
    trajet_id INT,
    arret_id INT,
    ordre INT,
    heure_arrivee DATETIME,
    heure_depart DATETIME,
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id_trajet),
    FOREIGN KEY (arret_id) REFERENCES Arret(id_arret)
);

CREATE TABLE Incident (
    id_incident INT PRIMARY KEY,
    trajet_id INT,
    type ENUM('accident', 'arret_supprime', 'panne', 'rue_bloquee'),
    description TEXT,
    heure DATETIME,
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id_trajet)
);

-- Relations multiples
CREATE TABLE Utilisateur_Tournee (
    utilisateur_id INT,
    tournee_id INT,
    PRIMARY KEY (utilisateur_id, tournee_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (tournee_id) REFERENCES Tournee(id_tournee)
);

CREATE TABLE Utilisateur_Trajet (
    utilisateur_id INT,
    trajet_id INT,
    PRIMARY KEY (utilisateur_id, trajet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id_trajet)
);
