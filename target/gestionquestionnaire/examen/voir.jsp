<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Examen, model.Etudiant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détail de l'Examen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-card { max-width: 620px; }
        .note-circle {
            width: 110px; height: 110px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2em; font-weight: 700; color: white;
            margin: 0 auto 24px auto;
        }
        .note-success { background: linear-gradient(135deg, #28a745, #20c997); box-shadow: 0 6px 20px rgba(40,167,69,0.35); }
        .note-echec   { background: linear-gradient(135deg, #dc3545, #e83e8c); box-shadow: 0 6px 20px rgba(220,53,69,0.35); }
        .info-row {
            display: flex; justify-content: space-between;
            padding: 13px 0; border-bottom: 1px solid #e8e8e8; font-size: 0.97em;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #666; font-weight: 500; display: flex; align-items: center; gap: 8px; }
        .info-value { font-weight: 600; color: #222; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen" class="active"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un Examen</a></li>
        </ul>
    </div>

    <div class="main-content">
        <h2>Détail de l'Examen</h2><br>
        <%
            Examen examen   = (Examen)   request.getAttribute("examen");
            Etudiant etudiant = (Etudiant) request.getAttribute("etudiant");

            if (examen != null) {
                int note = examen.getNote();
                String noteClass = (note >= 5) ? "note-success" : "note-echec";
                String nomComplet = (etudiant != null)
                    ? (etudiant.getPrenoms() + " " + etudiant.getNom())
                    : "—";
        %>
        <div class="card detail-card">
            <div class="note-circle <%= noteClass %>">
                <%= note %>/10
            </div>

            <div class="info-row">
                <span class="info-label"><i class="fas fa-user"></i> Nom de l'étudiant</span>
                <span class="info-value"><%= nomComplet %></span>
            </div>
            <div class="info-row">
                <span class="info-label"><i class="fas fa-id-card"></i> Numéro étudiant</span>
                <span class="info-value"><%= examen.getNumEtudiant() %></span>
            </div>
            <div class="info-row">
                <span class="info-label"><i class="fas fa-book"></i> Thème</span>
                <span class="info-value"><%= examen.getTheme() != null ? examen.getTheme() : "—" %></span>
            </div>
            <div class="info-row">
                <span class="info-label"><i class="fas fa-calendar-alt"></i> Année universitaire</span>
                <span class="info-value"><%= examen.getAnneeUniv() %></span>
            </div>
            <div class="info-row">
                <span class="info-label"><i class="fas fa-star"></i> Note</span>
                <span class="info-value" style="color: <%= note >= 5 ? "#28a745" : "#dc3545" %>; font-size: 1.1em;">
                    <%= note %>/10
                </span>
            </div>

            <div style="margin-top: 24px; display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/examen" class="btn-cancel">
                    <i class="fas fa-arrow-left"></i> Retour à la liste
                </a>
            </div>
        </div>
        <% } else { %>
            <div class="error"><i class="fas fa-exclamation-circle"></i> Examen introuvable.</div>
        <% } %>
    </div>
</body>
</html>
