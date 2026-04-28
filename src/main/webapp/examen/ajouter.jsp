<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Ajouter Examen</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen" class="active"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
        </ul>
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <h2>Ajouter un examen</h2>

        <form action="examen" method="post">
            <input type="hidden" name="action" value="insert"/>

            <label for="numEtudiant">Numéro Étudiant:</label>
            <input type="text" id="numEtudiant" name="numEtudiant" required/><br/>

            <label for="anneeUniv">Année Universitaire:</label>
            <input type="text" id="anneeUniv" name="anneeUniv" required/><br/>

            <label for="note">Note:</label>
            <input type="number" id="note" name="note" min="0" max="10" required/><br/>

            <div style="margin-top: 30px;">
                <button type="submit" id="submitBtn" disabled><i class="fas fa-plus"></i> Ajouter l'examen</button>
                <a href="examen" class="btn-cancel"><i class="fas fa-arrow-left"></i> Retour</a>
            </div>
        </form>
    </div>
    <script>
        (function () {
            const form = document.querySelector('form');
            const btn  = document.getElementById('submitBtn');
            function check() { btn.disabled = !form.checkValidity(); }
            form.addEventListener('input',  check);
            form.addEventListener('change', check);
            check();
        })();
    </script>
</body>
</html>