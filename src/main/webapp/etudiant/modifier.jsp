<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Modifier Étudiant</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant" class="active"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
        </ul>
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <h2>Modifier un étudiant</h2>

        <form action="etudiant" method="post">
            <input type="hidden" name="action" value="update"/>

            <label for="num">Numéro étudiant:</label>
            <input type="text" id="num" name="num" value="${etudiant.numEtudiant}" readonly/><br/>

            <label for="nom">Nom:</label>
            <input type="text" id="nom" name="nom" value="${etudiant.nom}" required/><br/>

            <label for="prenoms">Prénoms:</label>
            <input type="text" id="prenoms" name="prenoms" value="${etudiant.prenoms}" required/><br/>

            <label for="niveau">Niveau:</label>
            <input type="text" id="niveau" name="niveau" value="${etudiant.niveau}" required/><br/>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${etudiant.adr_email}" required/><br/>

            <div style="margin-top: 30px;">
                <button type="submit" id="submitBtn"><i class="fas fa-save"></i> Modifier l'étudiant</button>
                <a href="etudiant" class="btn-cancel"><i class="fas fa-arrow-left"></i> Retour</a>
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