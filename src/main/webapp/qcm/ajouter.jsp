<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Ajouter QCM</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm" class="active"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
        </ul>
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <h2>Ajouter un QCM</h2>

        <form action="qcm" method="post">
            <input type="hidden" name="action" value="insert"/>

            <label for="niveau">Niveau:</label>
            <select id="niveau" name="niveau" required>
                <option value="">-- Sélectionnez un niveau --</option>
                <c:forEach var="n" items="${niveaux}">
                    <option value="${n}">${n}</option>
                </c:forEach>
            </select><br/>

            <label for="theme">Thème:</label>
            <select id="theme" name="theme">
                <option value="">-- Créer un nouveau thème --</option>
                <c:forEach var="t" items="${themes}">
                    <option value="${t}">${t}</option>
                </c:forEach>
            </select>
            <input type="text" id="themeNew" name="themeNew" placeholder="Ou tapez un nouveau thème"/><br/>

            <label for="question">Question:</label>
            <textarea id="question" name="question" rows="2" required></textarea><br/>

            <label for="reponse1">Réponse 1:</label>
            <input type="text" id="reponse1" name="reponse1" required/><br/>

            <label for="reponse2">Réponse 2:</label>
            <input type="text" id="reponse2" name="reponse2" required/><br/>

            <label for="reponse3">Réponse 3:</label>
            <input type="text" id="reponse3" name="reponse3" required/><br/>

            <label for="reponse4">Réponse 4:</label>
            <input type="text" id="reponse4" name="reponse4" required/><br/>

            <label for="bonneReponse">Bonne Réponse (1-4):</label>
            <input type="number" id="bonneReponse" name="bonneReponse" min="1" max="4" required/><br/>

            <div style="margin-top: 30px;">
                <button type="submit" id="submitBtn" disabled><i class="fas fa-plus"></i> Ajouter le QCM</button>
                <a href="qcm" class="btn-cancel"><i class="fas fa-arrow-left"></i> Retour</a>
            </div>
        </form>

        <script>
            const form       = document.querySelector('form');
            const btn        = document.getElementById('submitBtn');
            const themeSelect   = document.getElementById('theme');
            const themeNewInput = document.getElementById('themeNew');

            function checkBtn() {
                const themeOk = !!(themeSelect.value || themeNewInput.value.trim());
                btn.disabled = !(form.checkValidity() && themeOk);
            }

            themeSelect.addEventListener('change', function () {
                if (themeSelect.value) {
                    themeNewInput.value = '';
                    themeNewInput.disabled = true;
                } else {
                    themeNewInput.disabled = false;
                }
                checkBtn();
            });

            form.addEventListener('input',  checkBtn);
            form.addEventListener('change', checkBtn);

            form.addEventListener('submit', function (e) {
                if (!themeSelect.value && !themeNewInput.value.trim()) {
                    e.preventDefault();
                    showAlert('Veuillez sélectionner ou créer un thème');
                    return;
                }
                if (themeNewInput.value.trim()) {
                    const hidden = document.createElement('input');
                    hidden.type = 'hidden';
                    hidden.name = 'theme';
                    hidden.value = themeNewInput.value.trim();
                    form.appendChild(hidden);
                }
            });

            checkBtn();
        </script>

    <!-- Modal alerte -->
    <div id="alertModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:white;border-radius:12px;padding:32px 28px;max-width:380px;width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.3);text-align:center;">
            <div style="width:60px;height:60px;border-radius:50%;background:#e3f2fd;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                <i class="fas fa-info-circle" style="font-size:1.6em;color:#003d7a;"></i>
            </div>
            <p id="alertModalMsg" style="color:#444;margin:0 0 24px;font-size:0.95em;line-height:1.5;"></p>
            <button onclick="closeAlertModal()" style="background:#003d7a;color:white;padding:10px 28px;border:none;border-radius:6px;font-size:0.95em;font-weight:600;cursor:pointer;box-shadow:none;">
                OK
            </button>
        </div>
    </div>
    <script>
        function showAlert(message) {
            document.getElementById('alertModalMsg').textContent = message;
            document.getElementById('alertModal').style.display = 'flex';
        }
        function closeAlertModal() {
            document.getElementById('alertModal').style.display = 'none';
        }
    </script>
    </div>
</body>
</html>