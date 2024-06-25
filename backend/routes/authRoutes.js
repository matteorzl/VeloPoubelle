// authRoutes.js
const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise'); // Utilisation de mysql2/promise

const router = express.Router();

// Configuration de la connexion à la base de données(à adapter)
const pool = mysql.createPool({
    host: 'agweco.fr',
    user: 'pma-admin',  
    database: 'veloPoubelle',
    password: 'Agweco@SQL31',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Route de création de compte
router.post('/signup', async (req, res) => {
  const { nom, prenom, email, mot_de_passe, role } = req.body;
  const hashedPassword = await bcrypt.hash(mot_de_passe, 10);
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)',
      [nom, prenom, email, hashedPassword, role]
    );
    connection.release();

    res.status(201).json({ message: 'Utilisateur créé avec succès' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erreur lors de la création du compte' });
  }
});

// Route de connexion
router.post('/login', async (req, res) => {
  const { email, mot_de_passe } = req.body;

  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT * FROM Utilisateur WHERE email = ?',
      [email]
    );
    connection.release();

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
    }

    const user = rows[0];
    const passwordMatch = await bcrypt.compare(mot_de_passe, user.mot_de_passe);

    if (!passwordMatch) {
      return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
    }

    // Génération du token JWT (à adapter avec votre secret)
    const token = jwt.sign({ userId: user.id_utilisateur }, 'votre_secret', { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erreur lors de la connexion' });
  }
});

module.exports = router;
