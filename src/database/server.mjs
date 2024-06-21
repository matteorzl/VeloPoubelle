import express from 'express';
import mysql from 'mysql2';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors()); // Pour permettre les requêtes depuis un autre domaine

const connection = mysql.createConnection({
    host: 'agweco.fr',  // Remplacez par l'hôte de votre base de données
    user: 'pma-admin',       // Remplacez par votre nom d'utilisateur de base de données
    password: 'Agweco@SQL31', // Remplacez par votre mot de passe de base de données
    database: 'veloPoubelle' // Remplacez par le nom de votre base de données
});

connection.connect((err) => {
  if (err) {
    console.error('Erreur de connexion : ' + err.stack);
    return;
  }
  console.log('Connecté en tant que id ' + connection.threadId);
});


app.get('/api/utilisateurs', (req, res) => {
  connection.query('SELECT * FROM Utilisateur', (error, results) => {
    if (error) {
      res.status(500).send(error);
      return;
    }
    res.json(results);
  });
});

app.post('/api/utilisateurs', (req, res) => {
  const { nom, prenom, email, mot_de_passe, role } = req.body;

  const query = `INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)`;
  connection.query(query, [nom, prenom, email, mot_de_passe, role], (error, results) => {
    if (error) {
      res.status(500).send(error);
      return;
    }
    res.status(201).send(results);
  });
});

app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
