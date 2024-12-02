const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');

const router = express.Router();

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',  
    database: 'velopoubelle',
    password: '',
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
      'SELECT nom, prenom, role, id_utilisateur, isSick FROM Utilisateur WHERE id_utilisateur = ?', 
      [req.user.userId]
    );
    connection.release();

    const user = rows[0];

    res.status(200).json({ message: user });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' }); 
  }
});

router.get('/cycliste', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT nom, prenom, id_utilisateur ,isSick FROM utilisateur WHERE role = ? AND isSick = 0',
      ['cycliste']
    );
    connection.release();

    res.status(200).json({ 
      count: rows.length,
      rows,   });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' }); 
  }
});

router.get('/map/arret', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT id_arret, nom, lat, lng FROM arret', 
    );
    connection.release();

    res.status(200).json({ rows });
  } catch (error) {
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
      'SELECT id_utilisateur, nom, prenom, email, role, isSick FROM Utilisateur' // Select only necessary fields
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

router.put('/user/:id', async (req, res) => {
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

    res.status(200).json({ message: 'Utilisateur mis à jour avec succès' });
  } catch (error) {
    console.log(error);
    res.status(500).json({   
 error: 'Internal Server Error'});
  }
});

router.delete('/user/:id', async (req, res) => {
  try {
    const userId = req.params.id;

    const connection = await pool.getConnection();
    const [result] = await connection.execute(
      'DELETE FROM Utilisateur WHERE id_utilisateur = ?',
      [userId]
    );
    connection.release();

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Utilisateur introuvable' });
    }

    res.status(200).json({ message: 'Utilisateur supprimé avec succès' });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.put('/user/password/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const { ancien_mot_de_passe, nouveau_mot_de_passe } = req.body;

    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      'SELECT mot_de_passe FROM Utilisateur WHERE id_utilisateur = ?',
      [userId]
    );

    if (rows.length === 0) {
      connection.release();
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }

    const user = rows[0];
    const passwordMatch = await bcrypt.compare(ancien_mot_de_passe, user.mot_de_passe);

    if (!passwordMatch) {
      connection.release();
      return res.status(403).json({ error: 'L\'ancien mot de passe est incorrect' });
    }

    const hashedNewPassword = await bcrypt.hash(nouveau_mot_de_passe, 10);

    const [result] = await connection.execute(
      'UPDATE Utilisateur SET mot_de_passe = ? WHERE id_utilisateur = ?',
      [hashedNewPassword, userId]
    );
    connection.release();

    if (result.affectedRows === 0) {
      return res.status(500).json({ error: 'Erreur lors de la mise à jour du mot de passe' });
    }

    res.status(200).json({ message: 'Mot de passe modifié avec succès' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});

router.post('/tournee', async (req, res) => {
  const { tournees } = req.body;
  const connection = await pool.getConnection();

  if (!Array.isArray(tournees) || tournees.length === 0) {
    return res.status(400).json({ error: 'Aucune tournée fournie.' });
  }

  try {
    await connection.execute('DELETE FROM Trajet');
    await connection.execute('DELETE FROM Tournee');

    // Réinitialiser l'auto-incrément
    await connection.execute('ALTER TABLE Tournee AUTO_INCREMENT = 1');

    // Préparer les données pour l'insertion
    const values = tournees.map(t => [t.date, t.utilisateur_id, t.etat, t.nom]);
    const placeholders = values.map(() => '(?, ?, ?, ?)').join(', ');

    const query = `
      INSERT INTO Tournee (date, cycliste_id, etat, nom)
      VALUES ${placeholders}
    `;

    // Insérer les nouvelles données
    await connection.execute(query, values.flat());

    connection.release();
    res.json({ message: 'Tournées enregistrées avec succès.' });
  } catch (error) {
    console.error('Erreur lors de l\'insertion des tournées:', error);
    connection.release(); // Toujours relâcher la connexion
    res.status(500).json({ error: 'Erreur serveur lors de l\'insertion des tournées.' });
  }
});

router.get('/tournee', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(`
      SELECT 
          t.id_tournee,
          t.nom AS nom_tournee,
          u.nom AS nom_cycliste,
          u.prenom AS prenom_cycliste,
          t.etat AS state_tournee,
          COUNT(tr.id_trajet) AS nombre_arrets
      FROM 
          Tournee t
      LEFT JOIN 
          Utilisateur u ON t.cycliste_id = u.id_utilisateur
      LEFT JOIN 
          Trajet tr ON t.id_tournee = tr.tournee_id
      GROUP BY 
          t.id_tournee, t.nom, u.nom, u.prenom
      ORDER BY 
          t.id_tournee;
    `);
    connection.release();

    // Transforme les résultats pour les rendre plus lisibles côté frontend
    const tournees = rows.map(row => ({
      id_tournee: row.id_tournee,
      nom: row.nom_tournee,
      cycliste: `${row.prenom_cycliste} ${row.nom_cycliste}`.trim(),
      status: row.state_tournee,
      nombre_arrets: row.nombre_arrets,
    }));

    res.status(200).json({ rows: tournees });
  } catch (error) {
    console.error('Erreur lors de la récupération des tournées:', error);
    res.status(500).json({ error: 'Erreur interne du serveur.' });
  }
});

router.patch('/tournee/encours/:id', async (req, res) => {
  const userId = req.params.id;
  const connection = await pool.getConnection();
  try {
    const [tourneeRows] = await connection.execute(
      `SELECT * FROM Tournee WHERE cycliste_id = ?`,
      [userId]
    );

    const tourneeId = tourneeRows[0].id_tournee

    const result = await connection.execute(
      'UPDATE Tournee SET etat = ? WHERE id_tournee = ?',
      ['en_cours', tourneeId]
    );

    connection.release();

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Tournée introuvable." });
    }

    res.status(200).json({ message: "Cycliste attribué avec succès.", tournee: result });
  } catch (error) {
    console.error("Erreur lors de l'attribution :", error);
    res.status(500).json({ error: "Erreur serveur lors de l'attribution." });
  }
});

router.get('/tournee/:id/trajet/user', async (req, res) => {
  const userId = req.params.id;
  try {
    const connection = await pool.getConnection();
    const [tourneeRows] = await connection.execute(
      `SELECT * FROM Tournee WHERE cycliste_id = ?`,
      [userId]
    );

    const tourneeId = tourneeRows[0].id_tournee

    // Si la tournée n'existe pas pour cet utilisateur, retournez une erreur
    if (tourneeRows.length === 0) {
      connection.release();
      return res.status(404).json({ error: 'Tournée non trouvée pour cet utilisateur.' });
    }

    // Récupérer les trajets associés à cette tournée
    const [trajetsRows] = await connection.execute(
      `SELECT 
        t.id_trajet,
        t.id_arret,
        t.lat,
        t.lng,
        a.nom,
        t.isDone
       FROM Trajet t
       JOIN Arret a ON t.id_arret = a.id_arret
       WHERE t.tournee_id = ? 
       ORDER BY t.ordre_passage`,
      [tourneeId]
    );
    connection.release();
    res.status(200).json({ trajets: trajetsRows });
  } catch (error) {
    console.error('Erreur lors de la récupération des trajets:', error);
    res.status(500).json({ error: 'Erreur interne du serveur.' });
  }
});

router.get('/tournee/:id/trajets', async (req, res) => {
  const tourneeId = req.params.id;
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.execute(
      `SELECT 
        t.id_trajet, -- Ajouter l'id_trajet ici
        t.id_arret, 
        t.lat, 
        t.lng, 
        a.nom ,
        t.isDone
       FROM Trajet t 
       JOIN Arret a ON t.id_arret = a.id_arret 
       WHERE t.tournee_id = ? 
       ORDER BY t.ordre_passage`,
      [tourneeId]
    );
    connection.release();
    res.status(200).json({ trajets: rows });
  } catch (error) {
    console.error('Erreur lors de la récupération des trajets:', error);
    res.status(500).json({ error: 'Erreur interne du serveur.' });
  }
});

router.post('/trajet', async (req, res) => {
  const { trajets } = req.body;
  const connection = await pool.getConnection();

  if (!Array.isArray(trajets) || trajets.length === 0) {
    return res.status(400).json({ error: 'Aucun trajet fourni.' });
  }

  try {

    // Réinitialiser l'auto-incrément
    await connection.execute('ALTER TABLE Trajet AUTO_INCREMENT = 1');

    const values = trajets.map(t => [t.tournee_id, t.id_arret, t.lat, t.lng, t.ordre_passage]);
    const placeholders = values.map(() => '(?, ?, ?, ?, ?)').join(', ');

    const query = `
      INSERT INTO Trajet (tournee_id, id_arret, lat, lng, ordre_passage)
      VALUES ${placeholders}
    `;

    await connection.execute(query, values.flat());
    connection.release();
    res.json({ message: 'Trajets enregistrés avec succès.' });
  } catch (error) {
    console.error('Erreur lors de l\'insertion des trajets:', error);
    connection.release();
    res.status(500).json({ error: 'Erreur serveur lors de l\'insertion des trajets.' });
  }
});

router.patch('/trajet/:id_trajet', async (req, res) => {
  const trajetId = req.params.id_trajet;
  try {
    const connection = await pool.getConnection();
    const [result] = await connection.execute(
      'UPDATE Trajet SET isDone = 1 WHERE id_trajet = ?',
      [trajetId]
    );
    connection.release();

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Arrêt introuvable' });
    }

    res.status(200).json({ message: 'Arrêt marqué comme terminé' });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de isDone:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

router.patch('/user/sick/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const { isSick } = req.body; // Récupère la valeur à mettre à jour (0 ou 1)

    if (isSick !== 0 && isSick !== 1) {
      return res.status(400).json({ error: "Valeur invalide pour isSick" });
    }

    const connection = await pool.getConnection();

    // Mettre à jour le statut de maladie
    const [result] = await connection.execute(
      'UPDATE Utilisateur SET isSick = ? WHERE id_utilisateur = ?',
      [isSick, userId]
    );
    connection.release();

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Utilisateur introuvable" });
    }

    const message = isSick === 1 
      ? "Utilisateur marqué comme malade" 
      : "Utilisateur marqué comme rétabli";
    res.status(200).json({ message });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erreur interne du serveur" });
  }
});

router.patch('/tournee/:tourneeId', async (req, res) => {
  const { tourneeId } = req.params;
  const { id_utilisateur } = req.body;

  if (!id_utilisateur || !tourneeId) {
    return res.status(400).json({ error: "ID utilisateur ou ID tournée manquant." });
  }

  try {
    const connection = await pool.getConnection();

    const result = await connection.execute(
      'UPDATE Tournee SET cycliste_id = ? WHERE id_tournee = ?',
      [id_utilisateur, tourneeId]
    );

    connection.release();

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Tournée introuvable." });
    }

    res.status(200).json({ message: "Cycliste attribué avec succès.", tournee: result });
  } catch (error) {
    console.error("Erreur lors de l'attribution :", error);
    res.status(500).json({ error: "Erreur serveur lors de l'attribution." });
  }
});
module.exports = router;