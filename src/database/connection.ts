const mysql = require('mysql2');

// Créez une connexion à la base de données
const connection = mysql.createConnection({
  host: 'localhost',  // Remplacez par l'hôte de votre base de données
  user: 'root',       // Remplacez par votre nom d'utilisateur de base de données
  password: 'password', // Remplacez par votre mot de passe de base de données
  database: 'your_database' // Remplacez par le nom de votre base de données
});

// Établissez la connexion
connection.connect((err) => {
  if (err) {
    console.error('Erreur de connexion : ' + err.stack);
    return;
  }
  console.log('Connecté en tant que id ' + connection.threadId);
});

// Exportez la connexion pour une utilisation dans d'autres fichiers
module.exports = connection;