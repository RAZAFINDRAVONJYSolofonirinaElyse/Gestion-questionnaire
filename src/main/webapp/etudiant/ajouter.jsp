<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Ajouter Étudiant</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="sidebar">
    <h2 class="sidebar-title">Gestion Questionnaire</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/etudiant" class="active"><i class="fas fa-users"></i>Étudiants</a></li>
        <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
        <li><a href="${pageContext.request.contextPath}/examen"><i class="fas fa-file-alt"></i>Examens</a></li>
        <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
    </ul>
</div>

<div class="main-content">
    <h2>Ajouter un étudiant</h2>

    <form action="etudiant" method="post" id="mainForm" novalidate>
        <input type="hidden" name="action" value="insert"/>

        <%-- Matricule --%>
        <label for="num">Numéro matricule :</label>
        <input type="text" id="num" name="num"
               value="${fn:escapeXml(param.num)}"
               placeholder="Ex : ETU001"
               class="${not empty erreurNum ? 'input-error' : ''}" required/>
        <span id="err_num" class="field-error"<c:if test="${empty erreurNum}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurNum}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurNum)}</c:if>
        </span>

        <%-- Nom --%>
        <label for="nom">Nom :</label>
        <input type="text" id="nom" name="nom"
               value="${fn:escapeXml(param.nom)}"
               placeholder="Ex : Rakoto"
               class="${not empty erreurNom ? 'input-error' : ''}" required/>
        <span id="err_nom" class="field-error"<c:if test="${empty erreurNom}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurNom}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurNom)}</c:if>
        </span>

        <%-- Prénoms --%>
        <label for="prenoms">Prénoms :</label>
        <input type="text" id="prenoms" name="prenoms"
               value="${fn:escapeXml(param.prenoms)}"
               placeholder="Ex : Jean Marie"
               class="${not empty erreurPrenoms ? 'input-error' : ''}" required/>
        <span id="err_prenoms" class="field-error"<c:if test="${empty erreurPrenoms}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurPrenoms}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurPrenoms)}</c:if>
        </span>

        <%-- Niveau --%>
        <label for="niveau">Niveau :</label>
        <select id="niveau" name="niveau"
                class="${not empty erreurNiveau ? 'input-error' : ''}" required>
            <option value="">-- Sélectionner un niveau --</option>
            <option value="L1" <c:if test="${param.niveau == 'L1'}">selected</c:if>>L1</option>
            <option value="L2" <c:if test="${param.niveau == 'L2'}">selected</c:if>>L2</option>
            <option value="L3" <c:if test="${param.niveau == 'L3'}">selected</c:if>>L3</option>
            <option value="M1" <c:if test="${param.niveau == 'M1'}">selected</c:if>>M1</option>
            <option value="M2" <c:if test="${param.niveau == 'M2'}">selected</c:if>>M2</option>
        </select>
        <span id="err_niveau" class="field-error"<c:if test="${empty erreurNiveau}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurNiveau}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurNiveau)}</c:if>
        </span>

        <%-- Email --%>
        <label for="email">Email :</label>
        <input type="email" id="email" name="email"
               value="${fn:escapeXml(param.email)}"
               placeholder="Ex : nom@domaine.fr"
               class="${not empty erreurEmail ? 'input-error' : ''}" required/>
        <span id="err_email" class="field-error"<c:if test="${empty erreurEmail}"> style="display:none;"</c:if>>
            <c:if test="${not empty erreurEmail}"><i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(erreurEmail)}</c:if>
        </span>

        <div style="margin-top:30px;">
            <button type="submit" id="submitBtn" disabled><i class="fas fa-plus"></i> Ajouter l'étudiant</button>
            <a href="etudiant" class="btn-cancel"><i class="fas fa-arrow-left"></i> Retour</a>
        </div>
    </form>
</div>

<script>
(function () {
    const form    = document.getElementById('mainForm');
    const btn     = document.getElementById('submitBtn');
    const ctx     = '${pageContext.request.contextPath}';

    // Regex de validation
    const reNom   = /^[a-zA-ZÀ-ÿ\s\-']+$/;
    const reEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // État du champ matricule (async)
    // 'empty' | 'pending' | 'exists' | 'ok' | 'server-error'
    let numState = (function () {
        const el = document.getElementById('num');
        if (!el.value.trim()) return 'empty';
        if (el.classList.contains('input-error')) return 'server-error';
        return 'ok'; // le serveur a validé ce champ (erreur sur un autre champ)
    })();

    let numTimer = null;

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
    function checkBtn() {
        if (numState === 'empty' || numState === 'pending' ||
            numState === 'exists' || numState === 'server-error') {
            btn.disabled = true; return;
        }
        const ids = ['nom', 'prenoms', 'email'];
        const textOk = ids.every(id => {
            const el = document.getElementById(id);
            return el && el.value.trim() !== '' && !el.classList.contains('input-error');
        });
        const niv = document.getElementById('niveau');
        btn.disabled = !textOk || !niv.value;
    }

    // ── Matricule (AJAX) ─────────────────────────────────────────────────────
    document.getElementById('num').addEventListener('input', function () {
        const val = this.value.trim();
        clearTimeout(numTimer);
        if (!val) {
            showError('num', 'Le matricule est obligatoire.');
            numState = 'empty'; checkBtn(); return;
        }
        clearF('num');
        numState = 'pending'; checkBtn();
        numTimer = setTimeout(function () { fetchCheckNum(val); }, 450);
    });

    function fetchCheckNum(val) {
        fetch(ctx + '/etudiant?action=checkNum&num=' + encodeURIComponent(val))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.exists) {
                    showError('num', 'Ce matricule est déjà attribué à un autre étudiant.');
                    numState = 'exists';
                } else {
                    showOk('num', 'Matricule disponible.');
                    numState = 'ok';
                }
                checkBtn();
            })
            .catch(function () { clearF('num'); numState = 'ok'; checkBtn(); });
    }

    // ── Nom ──────────────────────────────────────────────────────────────────
    document.getElementById('nom').addEventListener('input', function () {
        const val = this.value.trim();
        if (!val)              showError('nom', 'Le nom est obligatoire.');
        else if (!reNom.test(val)) showError('nom', 'Nom invalide : lettres, espaces, tirets et apostrophes uniquement.');
        else                   showOk('nom', '');
        checkBtn();
    });

    // ── Prénoms ──────────────────────────────────────────────────────────────
    document.getElementById('prenoms').addEventListener('input', function () {
        const val = this.value.trim();
        if (!val)              showError('prenoms', 'Les prénoms sont obligatoires.');
        else if (!reNom.test(val)) showError('prenoms', 'Prénoms invalides : lettres, espaces, tirets et apostrophes uniquement.');
        else                   showOk('prenoms', '');
        checkBtn();
    });

    // ── Niveau ───────────────────────────────────────────────────────────────
    document.getElementById('niveau').addEventListener('change', function () {
        if (!this.value) showError('niveau', 'Veuillez sélectionner un niveau.');
        else             showOk('niveau', '');
        checkBtn();
    });

    // ── Email ────────────────────────────────────────────────────────────────
    document.getElementById('email').addEventListener('input', function () {
        const val = this.value.trim();
        if (!val)                showError('email', "L'adresse email est obligatoire.");
        else if (!reEmail.test(val)) showError('email', "Format d'email invalide (ex : nom@domaine.fr).");
        else                     showOk('email', '');
        checkBtn();
    });

    checkBtn();
})();
</script>
</body>
</html>
