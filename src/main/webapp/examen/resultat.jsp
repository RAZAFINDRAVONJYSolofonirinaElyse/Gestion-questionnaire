<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.SessionExamen" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Résultat de l'Examen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .resultat-card {
            max-width: 600px;
            text-align: center;
            padding: 40px 30px;
        }
        .note-circle {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px auto;
            font-size: 2.5em;
            font-weight: 700;
            color: white;
        }
        .note-success { background: linear-gradient(135deg, #28a745, #20c997); box-shadow: 0 8px 25px rgba(40,167,69,0.4); }
        .note-moyen   { background: linear-gradient(135deg, #ffc107, #fd7e14); box-shadow: 0 8px 25px rgba(255,193,7,0.4); }
        .note-echec   { background: linear-gradient(135deg, #dc3545, #e83e8c); box-shadow: 0 8px 25px rgba(220,53,69,0.4); }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
            font-size: 0.95em;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #666; font-weight: 500; }
        .info-value { font-weight: 600; color: #333; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer" class="active"><i class="fas fa-play-circle"></i>Passer un Examen</a></li>
        </ul>
    </div>

    <div class="main-content">
        <h2>Résultat de l'Examen</h2><br>

        <%
            SessionExamen sessionExamen = (SessionExamen) request.getAttribute("sessionExamen");
            Integer note = (Integer) request.getAttribute("note");

            if (sessionExamen != null && note != null) {
                String noteClass, mention, mentionIcon, mentionColor;
                if (note >= 8) {
                    noteClass = "note-success"; mention = "Excellent !";
                    mentionIcon = "fa-trophy"; mentionColor = "#28a745";
                } else if (note >= 5) {
                    noteClass = "note-moyen"; mention = "Résultat moyen";
                    mentionIcon = "fa-thumbs-up"; mentionColor = "#f57c00";
                } else {
                    noteClass = "note-echec"; mention = "Insuffisant";
                    mentionIcon = "fa-redo"; mentionColor = "#dc3545";
                }
        %>

        <div class="card resultat-card">
            <i class="fas fa-graduation-cap" style="font-size: 2em; color: #003d7a;"></i>
            <div class="note-circle <%= noteClass %>">
                <%= note %>/10
            </div>

            <div style="margin: 15px 0; font-size: 1.1em; font-weight: 600; color: <%= mentionColor %>;">
                <i class="fas <%= mentionIcon %>"></i> <%= mention %>
            </div>

            <div style="margin-top: 25px; text-align: left;">
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-user" style="margin-right: 8px;"></i>Étudiant</span>
                    <span class="info-value"><%= sessionExamen.getNumEtudiant() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-book" style="margin-right: 8px;"></i>Thème</span>
                    <span class="info-value"><%= sessionExamen.getTheme() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-calendar" style="margin-right: 8px;"></i>Date</span>
                    <span class="info-value"><%= sessionExamen.getDateSession() != null ? sessionExamen.getDateSession().toLocalDate() : "—" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-check-circle" style="margin-right: 8px;"></i>Statut</span>
                    <span class="info-value" style="color: #28a745;"><%= sessionExamen.getStatut() %></span>
                </div>
            </div>

            <div style="margin-top: 25px; display: flex; gap: 12px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer" class="add-button">
                    <i class="fas fa-redo"></i> Nouvel Examen
                </a>
                <a href="${pageContext.request.contextPath}/examen" class="btn-cancel">
                    <i class="fas fa-list"></i> Voir Historique
                </a>
            </div>
        </div>

        <% } else { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> Impossible de charger le résultat. Veuillez réessayer.
            </div>
        <% } %>
    </div>
</body>
</html>
