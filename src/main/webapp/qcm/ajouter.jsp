<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
<div class="sidebar">
    <h2 class="sidebar-title">Gestion Questionnaire</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
        <li><a href="${pageContext.request.contextPath}/qcm" class="active"><i class="fas fa-question-circle"></i>QCM</a></li>
        <li><a href="${pageContext.request.contextPath}/examen"><i class="fas fa-file-alt"></i>Examens</a></li>
        <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
    </ul>
</div>

<div class="main-content">
    <h2>Ajouter un QCM</h2>

    <form action="qcm" method="post" id="mainForm" novalidate>
        <input type="hidden" name="action" value="insert"/>

        <%-- Niveau --%>
        <label for="niveau">Niveau :</label>
        <select id="niveau" name="niveau"
                class="${not empty erreurNiveau ? 'input-error' : ''}" required>
            <option value="">-- Sélectionnez un niveau --</option>
            <c:forEach var="n" items="${niveaux}">
                <option value="${n}" <c:if test="${param.niveau == n}">selected</c:if>>${n}</option>
            </c:forEach>
        </select>
        <span id="err_niveau" class="field-error"<c:if test="${empty erreurNiveau}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurNiveau}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurNiveau)}</c:if>
        </span>

        <%-- Thème --%>
        <label for="theme">Thème :</label>
        <select id="theme" name="theme"
                class="${not empty erreurTheme ? 'input-error' : ''}">
            <option value="">-- Créer un nouveau thème --</option>
            <c:forEach var="t" items="${themes}">
                <option value="${t}" <c:if test="${param.theme == t}">selected</c:if>>${t}</option>
            </c:forEach>
        </select>
        <input type="text" id="themeNew" name="themeNew"
               value="${fn:escapeXml(param.themeNew)}"
               placeholder="Ou tapez un nouveau thème"
               class="${not empty erreurTheme ? 'input-error' : ''}"/>
        <span id="err_theme" class="field-error"<c:if test="${empty erreurTheme}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurTheme}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurTheme)}</c:if>
        </span>

        <%-- Question --%>
        <label for="question">Question :</label>
        <textarea id="question" name="question" rows="2"
                  class="${not empty erreurQuestion ? 'input-error' : ''}" required><c:out value="${param.question}"/></textarea>
        <span id="err_question" class="field-error"<c:if test="${empty erreurQuestion}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurQuestion}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurQuestion)}</c:if>
        </span>

        <%-- Réponse 1 --%>
        <label for="reponse1">Réponse 1 :</label>
        <input type="text" id="reponse1" name="reponse1"
               value="${fn:escapeXml(param.reponse1)}"
               class="${not empty erreurR1 ? 'input-error' : ''}" required/>
        <span id="err_reponse1" class="field-error"<c:if test="${empty erreurR1}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurR1}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurR1)}</c:if>
        </span>

        <%-- Réponse 2 --%>
        <label for="reponse2">Réponse 2 :</label>
        <input type="text" id="reponse2" name="reponse2"
               value="${fn:escapeXml(param.reponse2)}"
               class="${not empty erreurR2 ? 'input-error' : ''}" required/>
        <span id="err_reponse2" class="field-error"<c:if test="${empty erreurR2}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurR2}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurR2)}</c:if>
        </span>

        <%-- Réponse 3 --%>
        <label for="reponse3">Réponse 3 :</label>
        <input type="text" id="reponse3" name="reponse3"
               value="${fn:escapeXml(param.reponse3)}"
               class="${not empty erreurR3 ? 'input-error' : ''}" required/>
        <span id="err_reponse3" class="field-error"<c:if test="${empty erreurR3}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurR3}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurR3)}</c:if>
        </span>

        <%-- Réponse 4 --%>
        <label for="reponse4">Réponse 4 :</label>
        <input type="text" id="reponse4" name="reponse4"
               value="${fn:escapeXml(param.reponse4)}"
               class="${not empty erreurR4 ? 'input-error' : ''}" required/>
        <span id="err_reponse4" class="field-error"<c:if test="${empty erreurR4}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurR4}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurR4)}</c:if>
        </span>

        <%-- Bonne réponse --%>
        <label for="bonneReponse">Bonne Réponse (1-4) :</label>
        <input type="number" id="bonneReponse" name="bonneReponse"
               min="1" max="4"
               value="${fn:escapeXml(param.bonneReponse)}"
               class="${not empty erreurBonneRep ? 'input-error' : ''}" required/>
        <span id="err_bonneReponse" class="field-error"<c:if test="${empty erreurBonneRep}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurBonneRep}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurBonneRep)}</c:if>
        </span>

        <div style="margin-top:30px;">
            <button type="submit" id="submitBtn" disabled><i class="fas fa-plus"></i> Ajouter le QCM</button>
            <a href="qcm" class="btn-cancel"><i class="fas fa-arrow-left"></i> Retour</a>
        </div>
    </form>

    <!-- Modal alerte -->
    <div id="alertModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:white;border-radius:12px;padding:32px 28px;max-width:380px;width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.3);text-align:center;">
            <div style="width:60px;height:60px;border-radius:50%;background:#e3f2fd;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                <i class="fas fa-info-circle" style="font-size:1.6em;color:#003d7a;"></i>
            </div>
            <p id="alertModalMsg" style="color:#444;margin:0 0 24px;font-size:0.95em;line-height:1.5;"></p>
            <button onclick="closeAlertModal()" style="background:#003d7a;color:white;padding:10px 28px;border:none;border-radius:6px;font-size:0.95em;font-weight:600;cursor:pointer;">OK</button>
        </div>
    </div>
</div>

<script>
(function () {
    const form          = document.getElementById('mainForm');
    const btn           = document.getElementById('submitBtn');
    const themeSelect   = document.getElementById('theme');
    const themeNewInput = document.getElementById('themeNew');

    // ── Helpers affichage ────────────────────────────────────────────────────
    function showError(id, msg) {
        const el = document.getElementById(id);
        const sp = document.getElementById('err_' + id);
        if (el) { el.classList.add('input-error'); el.classList.remove('input-ok'); }
        if (sp) {
            sp.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + msg;
            sp.className = 'field-error';
            sp.style.display = '';
        }
    }
    function showOk(id, msg) {
        const el = document.getElementById(id);
        const sp = document.getElementById('err_' + id);
        if (el) { el.classList.remove('input-error'); el.classList.add('input-ok'); }
        if (sp) {
            if (msg) {
                sp.innerHTML = '<i class="fas fa-check-circle"></i> ' + msg;
                sp.className = 'field-ok';
                sp.style.display = '';
            } else {
                sp.innerHTML = '';
                sp.style.display = 'none';
            }
        }
    }
    function clearF(id) {
        const el = document.getElementById(id);
        const sp = document.getElementById('err_' + id);
        if (el) { el.classList.remove('input-error', 'input-ok'); }
        if (sp) { sp.innerHTML = ''; sp.style.display = 'none'; }
    }

    // ── Bouton ───────────────────────────────────────────────────────────────
    function themeOk() {
        return !!(themeSelect.value || themeNewInput.value.trim());
    }
    function checkBtn() {
        const ids = ['question', 'reponse1', 'reponse2', 'reponse3', 'reponse4'];
        const textOk = ids.every(id => {
            const el = document.getElementById(id);
            return el && el.value.trim() !== '' && !el.classList.contains('input-error');
        });
        const brEl = document.getElementById('bonneReponse');
        const brVal = parseInt(brEl.value, 10);
        const brOk  = !isNaN(brVal) && brVal >= 1 && brVal <= 4;
        const nivOk = !!document.getElementById('niveau').value;
        btn.disabled = !textOk || !brOk || !nivOk || !themeOk();
    }

    // ── Niveau ───────────────────────────────────────────────────────────────
    document.getElementById('niveau').addEventListener('change', function () {
        if (!this.value) showError('niveau', 'Le niveau est obligatoire.');
        else             showOk('niveau', '');
        checkBtn();
    });

    // ── Thème ────────────────────────────────────────────────────────────────
    function validateTheme() {
        if (!themeOk()) showError('theme', 'Sélectionnez un thème existant ou saisissez-en un nouveau.');
        else            showOk('theme', '');
        checkBtn();
    }
    themeSelect.addEventListener('change', function () {
        if (themeSelect.value) {
            themeNewInput.value    = '';
            themeNewInput.disabled = true;
            clearF('theme');
            // retire aussi input-error sur themeNew
            themeNewInput.classList.remove('input-error', 'input-ok');
        } else {
            themeNewInput.disabled = false;
        }
        validateTheme();
    });
    themeNewInput.addEventListener('input', function () {
        if (themeSelect.value) return;
        validateTheme();
    });

    // ── Question ─────────────────────────────────────────────────────────────
    document.getElementById('question').addEventListener('input', function () {
        if (!this.value.trim()) showError('question', 'La question ne peut pas être vide.');
        else                    showOk('question', '');
        checkBtn();
    });

    // ── Réponses 1-4 ─────────────────────────────────────────────────────────
    ['reponse1', 'reponse2', 'reponse3', 'reponse4'].forEach(function (id, i) {
        document.getElementById(id).addEventListener('input', function () {
            if (!this.value.trim()) showError(id, 'La réponse ' + (i + 1) + ' est obligatoire.');
            else                    showOk(id, '');
            checkBtn();
        });
    });

    // ── Bonne réponse ────────────────────────────────────────────────────────
    document.getElementById('bonneReponse').addEventListener('input', function () {
        const val = parseInt(this.value, 10);
        if (!this.value.trim()) {
            showError('bonneReponse', 'La bonne réponse est obligatoire (1 à 4).');
        } else if (isNaN(val) || val < 1 || val > 4) {
            showError('bonneReponse', 'La bonne réponse doit être un chiffre entre 1 et 4.');
        } else {
            showOk('bonneReponse', '');
        }
        checkBtn();
    });

    // ── Soumission ───────────────────────────────────────────────────────────
    form.addEventListener('submit', function (e) {
        if (!themeOk()) {
            e.preventDefault();
            showAlert('Veuillez sélectionner un thème existant ou saisir un nouveau thème.');
            return;
        }
        if (themeNewInput.value.trim() && !themeSelect.value) {
            const hidden = document.createElement('input');
            hidden.type  = 'hidden';
            hidden.name  = 'theme';
            hidden.value = themeNewInput.value.trim();
            form.appendChild(hidden);
        }
    });

    checkBtn();
})();

function showAlert(message) {
    document.getElementById('alertModalMsg').textContent = message;
    document.getElementById('alertModal').style.display  = 'flex';
}
function closeAlertModal() {
    document.getElementById('alertModal').style.display = 'none';
}
</script>
</body>
</html>
