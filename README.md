# 🚲 VeloPoubelle

## 🚀 Introduction

**VeloPoubelle** est une application de gestion de tournées pour les vélos électriques dédiés à la collecte des déchets. Elle combine une interface utilisateur intuitive (Frontend) avec une API robuste (Backend), et utilise [OpenRouteService (ORS)](https://openrouteservice.org/) pour calculer les itinéraires optimaux.

---

## 🛠️ Recommended IDE & Tools

### **🖥️ IDE**
- [Visual Studio Code (VSCode)](https://code.visualstudio.com/) - pour un développement rapide et efficace.

### **🐋 Docker**
- [Docker](https://www.docker.com/) - pour le déploiement et la gestion de l'environnement d'exécution de l'ORS.

---

## 📂 Structure du Projet

VeloPoubelle/ ├── frontend/ # Interface utilisateur (Vue.js) ├── backend/ # API et logique métier (Node.js) ├── ors/ # Calcul des itinéraires (ORS via Docker)

---

## 🌐 Frontend

### **Installation et Exécution**

1. Rendez-vous dans le dossier **frontend** :
   ```bash
   cd frontend

2. Installez les dépendances :
   ```bash
      npm install

3. Lancez le serveur de développement :
   ```bash
   npm run dev

---

## 🖧 Backend

### **Installation et Exécution**

1. Rendez-vous dans le dossier **backend** :
   ```bash
   cd backend

2. Installez les dépendances :
   ```bash
      npm install

3. Lancez le serveur de développement :
   ```bash
   npm run dev

---

## 🗺️ OpenRouteService (ORS)

### **Installation et Exécution**

1. Rendez-vous dans le dossier **ors** :
   ```bash
   cd ors

2. Lancez le service Docker pour ORS :
   ```bash
      docker compose up

3. Accédez à l'interface ORS à l'adresse suivante : http://localhost:8080

## 🛠️ Technologies utilisées

### **Frontend**

Vue.js
Vite.js
Leaflet (cartographie interactive)

### **Backend**

Node.js
Express.js
PostgreSQL (Base de données)

### **Services Externes**

OpenRouteService pour la génération des itinéraires.

## 🌟 Contribution

1. Clonez le dépôt : :
   ```bash
    git clone https://github.com/matteorzl/VeloPoubelle.git

2. Créez une nouvelle branche :
   ```bash
        git checkout -b feature-name

3. Proposez vos modifications et ouvrez une pull request (PR).


## 🔗 Liens utiles
[Documentation ORS](https://openrouteservice.org/dev/#/api-docs)
[Guide Docker](https://docs.docker.com/)
