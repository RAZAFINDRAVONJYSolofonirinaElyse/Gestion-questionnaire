<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, model.Examen, model.Etudiant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passer un Examen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        <h2>Passer un Examen</h2><br>

        <% if (request.getAttribute("examenExistant") != null) {
            Examen ex = (Examen) request.getAttribute("examenExistant");
            Etudiant etu = (Etudiant) request.getAttribute("etudiantBloque");
            String nomEtu = (etu != null) ? etu.getPrenoms() + " " + etu.getNom() : ex.getNumEtudiant();
        %>
            <div style="background:#fff3cd; border:1px solid #ffc107; border-left:5px solid #e65c00; border-radius:6px; padding:18px 20px; margin-bottom:22px; display:flex; gap:16px; align-items:flex-start;">
                <i class="fas fa-lock" style="color:#e65c00; font-size:1.6em; margin-top:2px; flex-shrink:0;"></i>
                <div>
                    <strong style="color:#7a3a00; font-size:1.05em;">Examen déjà passé pour ce thème</strong>
                    <p style="margin:8px 0 4px 0; color:#555;">
                        <strong><%= nomEtu %></strong> (<%= ex.getNumEtudiant() %>) a déjà passé l'examen
                        <strong>"<%= ex.getTheme() %>"</strong> avec la note
                        <strong style="color:<%= ex.getNote() >= 5 ? "#155724" : "#721c24" %>"><%= ex.getNote() %>/10</strong>
                        (année <%= ex.getAnneeUniv() %>).
                    </p>
                    <p style="margin:0; color:#777; font-size:0.92em;">
                        Pour recommencer, supprimez d'abord cet examen depuis la liste.
                    </p>
                    <a href="${pageContext.request.contextPath}/examen?mode=liste&theme=<%= java.net.URLEncoder.encode(ex.getTheme(), "UTF-8") %>"
                       style="display:inline-flex; align-items:center; gap:6px; margin-top:12px; padding:7px 14px; background:#e65c00; color:white; border-radius:4px; text-decoration:none; font-size:0.9em; font-weight:600;">
                        <i class="fas fa-trash-alt"></i> Voir et supprimer l'examen
                    </a>
                </div>
            </div>
        <% } else if (request.getAttribute("erreur") != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("erreur") %>
            </div>
        <% } %>

        <%
            int year = LocalDate.now().getYear();
            int month = LocalDate.now().getMonthValue();
            String defaultAnnee = (month >= 9) ? year + "-" + (year + 1) : (year - 1) + "-" + year;
        %>

        <div style="display:flex; flex-direction:column; align-items:center; width:100%;">
        <div class="card" style="max-width: 600px; width:100%;">
            <div class="card-header">
                <span class="card-title"><i class="fas fa-clipboard-list" style="margin-right: 10px; color: #003d7a;"></i>Nouvelle Session</span>
            </div>

            <form action="${pageContext.request.contextPath}/SessionExamen" method="POST" style="box-shadow: none; padding: 20px 0 0 0; margin: 0; max-width: 100%;">
                <input type="hidden" name="action" value="commencer">

                <label for="numEtudiant"><i class="fas fa-id-card"></i> Numéro d'étudiant</label>
                <input type="text" id="numEtudiant" name="numEtudiant" placeholder="Ex: ETU001" required autocomplete="off">
                <div id="etudiantStatus" style="min-height:20px; margin:4px 0 8px 0; font-size:0.88em;"></div>

                <label for="theme"><i class="fas fa-book"></i> Thème</label>
                <select id="theme" name="theme" disabled style="background:#f5f5f5; color:#aaa; cursor:not-allowed;">
                    <option value="">-- Entrez d'abord votre matricule --</option>
                </select>
                <div id="themeError" style="color:#d32f2f; font-size:0.88em; margin-top:4px; display:none;">
                    <i class="fas fa-exclamation-circle"></i> Veuillez sélectionner un thème.
                </div>

                <label for="anneeUniv"><i class="fas fa-calendar-alt"></i> Année universitaire</label>
                <input type="text" id="anneeUniv" name="anneeUniv"
                       placeholder="Ex: 2024-2025"
                       value="<%= defaultAnnee %>" required>

                <div style="margin-top: 10px;">
                    <button type="submit" id="submitBtn" class="add-button" disabled>
                        <i class="fas fa-play"></i> Commencer l'Examen
                    </button>
                    <a href="${pageContext.request.contextPath}/examen" class="btn-cancel">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
            </form>
        </div>

        <div class="card" style="max-width: 600px; width:100%; margin-top: 20px; background: #f8f9ff;">
            <div class="card-header">
                <span class="card-title"><i class="fas fa-info-circle" style="color: #003d7a; margin-right: 10px;"></i>Instructions</span>
            </div>
            <ul style="list-style: none; padding: 10px 0 0 0;">
                <li style="padding: 8px 0; border-bottom: 1px solid #e0e0e0;">
                    <i class="fas fa-check-circle" style="color: #28a745; margin-right: 10px;"></i>
                    Entrez votre numéro d'étudiant et l'année universitaire
                </li>
                <li style="padding: 8px 0; border-bottom: 1px solid #e0e0e0;">
                    <i class="fas fa-check-circle" style="color: #28a745; margin-right: 10px;"></i>
                    Sélectionnez le thème de l'examen
                </li>
                <li style="padding: 8px 0; border-bottom: 1px solid #e0e0e0;">
                    <i class="fas fa-check-circle" style="color: #28a745; margin-right: 10px;"></i>
                    10 questions s'afficheront sur une seule page
                </li>
                <li style="padding: 8px 0;">
                    <i class="fas fa-check-circle" style="color: #28a745; margin-right: 10px;"></i>
                    Répondez à tout puis soumettez en une seule fois
                </li>
            </ul>
        </div>
        </div><%-- fin wrapper centré --%>
    </div>
    <script>
        const ctx = '${pageContext.request.contextPath}';
        let debounceTimer = null;
        const submitBtn = document.getElementById('submitBtn');

        function checkBtn() {
            const sel    = document.getElementById('theme');
            const annee  = document.getElementById('anneeUniv').value.trim();
            const numEtu = document.getElementById('numEtudiant').value.trim();
            submitBtn.disabled = sel.disabled || !sel.value || !annee || !numEtu;
        }

        document.getElementById('numEtudiant').addEventListener('input', function () {
            clearTimeout(debounceTimer);
            const val = this.value.trim();
            if (!val) { resetTheme(); setStatus('', ''); checkBtn(); return; }
            setStatus('loading', '<i class="fas fa-spinner fa-spin"></i> Recherche…');
            debounceTimer = setTimeout(() => fetchEtudiantInfo(val), 500);
        });

        document.getElementById('anneeUniv').addEventListener('input', checkBtn);
        document.getElementById('theme').addEventListener('change', checkBtn);

        document.querySelector('form').addEventListener('submit', function (e) {
            const sel = document.getElementById('theme');
            const err = document.getElementById('themeError');
            if (sel.disabled || !sel.value) {
                e.preventDefault();
                err.style.display = 'block';
                return;
            }
            err.style.display = 'none';
            sel.disabled = false;
        });

        function fetchEtudiantInfo(numEtudiant) {
            fetch(ctx + '/SessionExamen?action=etudiantInfo&numEtudiant=' + encodeURIComponent(numEtudiant))
                .then(r => r.json())
                .then(data => {
                    if (data.found) {
                        setStatus('ok', '<i class="fas fa-check-circle"></i> ' + data.nom + ' &mdash; Niveau <strong>' + data.niveau + '</strong>');
                        populateThemes(data.themes);
                    } else {
                        setStatus('error', '<i class="fas fa-times-circle"></i> Matricule introuvable');
                        resetTheme();
                    }
                    checkBtn();
                })
                .catch(() => {
                    setStatus('error', '<i class="fas fa-times-circle"></i> Erreur de connexion');
                    resetTheme();
                    checkBtn();
                });
        }

        function populateThemes(themes) {
            const sel = document.getElementById('theme');
            if (themes.length === 0) {
                sel.innerHTML = '<option value="">Aucun thème disponible pour ce niveau</option>';
                sel.disabled = true;
                sel.style.background = '#f5f5f5';
                sel.style.color = '#aaa';
                sel.style.cursor = 'not-allowed';
            } else {
                sel.innerHTML = '<option value="">-- Sélectionner un thème --</option>';
                themes.forEach(t => {
                    const opt = document.createElement('option');
                    opt.value = t; opt.textContent = t;
                    sel.appendChild(opt);
                });
                sel.disabled = false;
                sel.style.background = '';
                sel.style.color = '';
                sel.style.cursor = '';
            }
            document.getElementById('themeError').style.display = 'none';
        }

        function resetTheme() {
            const sel = document.getElementById('theme');
            sel.innerHTML = '<option value="">-- Entrez d\'abord votre matricule --</option>';
            sel.disabled = true;
            sel.style.background = '#f5f5f5';
            sel.style.color = '#aaa';
            sel.style.cursor = 'not-allowed';
            document.getElementById('themeError').style.display = 'none';
        }

        function setStatus(type, html) {
            const el = document.getElementById('etudiantStatus');
            el.innerHTML = html;
            el.style.color = type === 'ok' ? '#2e7d32' : type === 'error' ? '#c62828' : '#666';
        }

        checkBtn();
    </script>
</body>
</html>
