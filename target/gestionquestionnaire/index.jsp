<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Questionnaires - Accueil</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .menu-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 30px 0;
        }
        .menu-item {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            color: #333;
            border: 2px solid #ddd;
        }
        .menu-item:hover {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
            transform: translateY(-5px);
        }
        .menu-item h3 {
            margin: 0 0 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestion des Questionnaires</h1>
        <p>Bienvenue dans l'application de gestion des questionnaires</p>

        <div class="menu-container">
            <a href="etudiant?action=list" class="menu-item">
                <h3>Gérer les Étudiants</h3>
                <p>Ajouter, modifier ou consulter les étudiants</p>
            </a>

            <a href="qcm?action=list" class="menu-item">
                <h3>Gérer les Questions</h3>
                <p>Ajouter, modifier ou consulter les questions (QCM)</p>
            </a>

            <a href="examen?action=list" class="menu-item">
                <h3>Gérer les Examens</h3>
                <p>Consulter l'historique des examens passés</p>
            </a>

            <a href="SessionExamen?action=demarrer" class="menu-item">
                <h3>Passer un Examen</h3>
                <p>Démarrer une nouvelle session d'examen</p>
            </a>
        </div>
    </div>
</body>
</html>
