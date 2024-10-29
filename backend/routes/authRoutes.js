const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');

const router = express.Router();

const pool = mysql.createPool({
    host: 'agweco.fr',
    user: 'pma-admin',  
    database: 'veloPoubelle',
    password: 'Agweco@SQL31',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Register route
router.post('/register', async (req, res) => {
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

// Login route
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

    // Génération du token JWT
    const token = jwt.sign({ userId: user.id_utilisateur }, 'votre_secret', { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erreur lors de la connexion' });
  }
});

router.get('/app', authenticationToken, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT nom, prenom, role FROM Utilisateur WHERE id_utilisateur = ?', 
      [req.user.userId] // Fetch only the necessary fields
    );
    connection.release();

    const user = rows[0];

    res.status(200).json({ message: user }); // Send the user data with a 200 status
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' }); 
  }
});

function authenticationToken(req,res,next){
  const autHeader = req.headers['authorization'];
  const token =autHeader && autHeader.split(' ')[1]; // jwt passe "bearer (token)" donc on split pour recup que le token  
  

  if(!token){
    return res.status(401);
  }

  jwt.verify(token, 'votre_secret',(err,user)=>{
      if(err){
        return res.status(401);
      }
      req.user = user;
      next();
  });
}

router.get('/users', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT id_utilisateur, nom, prenom, email, role FROM Utilisateur' // Select only necessary fields
    );
    connection.release();

    res.status(200).json(rows); // Send the sanitized user data
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.get('/user/:id', async (req, res) => {
  try {
    const userId = req.params.id; // Extract the user ID from the URL parameter

    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT id_utilisateur, nom, prenom, email, role FROM Utilisateur WHERE id_utilisateur = ?',
      [userId] // Bind the user ID to the query
    );
    connection.release();

    if (rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json(rows[0]); // Send the first (and only) user object
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.put('/users/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const { nom, prenom, email, role } = req.body;

    const connection = await pool.getConnection();
    const [result] = await connection.execute(
      'UPDATE Utilisateur SET nom = ?, prenom = ?, email = ?, role = ? WHERE id_utilisateur = ?',
      [nom, prenom, email, role, userId]
    );
    connection.release();

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({ message: 'User updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({   
 error: 'Internal Server Error' });
  }
});


module.exports = router;
