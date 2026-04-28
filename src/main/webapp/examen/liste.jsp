<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Examens</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .controls-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .controls-right {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-left: auto;
        }
        .filter-select {
            height: 36px;
            padding: 0 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            width: auto;
            margin-bottom: 0;
            box-sizing: border-box;
        }
        .filter-select:focus {
            outline: none;
            border-color: #003d7a;
            box-shadow: 0 0 0 2px rgba(0,61,122,0.15);
        }
        .filter-label {
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            color: #555;
            font-weight: 500;
            margin: 0;
            padding: 0;
            height: 36px;
            white-space: nowrap;
        }
        .mode-toggle {
            display: inline-flex;
            border: 1px solid #003d7a;
            border-radius: 4px;
            overflow: hidden;
            height: 36px;
        }
        .mode-toggle a {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 0 14px;
            font-size: 14px;
            font-weight: 500;
            color: #003d7a;
            background: white;
            text-decoration: none;
            border-right: 1px solid #003d7a;
            height: 36px;
            transition: background 0.2s, color 0.2s;
            white-space: nowrap;
        }
        .mode-toggle a:last-child { border-right: none; }
        .mode-toggle a.active,
        .mode-toggle a:hover {
            background: #003d7a;
            color: white;
            text-decoration: none;
        }
        .start-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 36px;
            padding: 0 14px;
            background: #28a745;
            color: white;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            white-space: nowrap;
            transition: background 0.2s;
            flex-shrink: 0;
        }
        .start-btn:hover { background: #218838; color: white; text-decoration: none; }

        /* Classement */
        .rank-medal { font-size: 1.3em; }
        .rank-num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #e9ecef;
            color: #555;
            font-weight: 700;
            font-size: 13px;
        }
        .note-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
        }
        .note-good  { background: #d4edda; color: #155724; }
        .note-mid   { background: #fff3cd; color: #856404; }
        .note-bad   { background: #f8d7da; color: #721c24; }
        .niveau-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
            background: #e3f2fd;
            color: #1565c0;
            border: 1px solid #90caf9;
        }
        .section-title-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        .section-title-bar h3 {
            margin: 0;
            font-size: 1.1em;
            color: #333;
        }
        .count-badge {
            background: #e9ecef;
            color: #555;
            border-radius: 10px;
            padding: 2px 10px;
            font-size: 13px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 class="sidebar-title">Gestion Questionnaire</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/etudiant"><i class="fas fa-users"></i>Étudiants</a></li>
            <li><a href="${pageContext.request.contextPath}/qcm"><i class="fas fa-question-circle"></i>QCM</a></li>
            <li><a href="${pageContext.request.contextPath}/examen" class="active"><i class="fas fa-file-alt"></i>Examens</a></li>
            <li><a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer"><i class="fas fa-play-circle"></i>Passer un examen</a></li>
        </ul>
    </div>

    <div class="main-content">
        <h2>Examens</h2>

        <!-- Barre de contrôles -->
        <div class="controls-bar">
            <a href="${pageContext.request.contextPath}/SessionExamen?action=demarrer" class="start-btn">
                <i class="fas fa-play"></i> Commencer un examen
            </a>

            <div class="controls-right">
                <!-- Filtre Thème -->
                <label class="filter-label" for="themeSelect">Thème :</label>
                <select id="themeSelect" class="filter-select" onchange="applyFilters()">
                    <option value="">Tous</option>
                    <c:forEach var="t" items="${themes}">
                        <option value="${t}" <c:if test="${themeFilter == t}">selected</c:if>>${t}</option>
                    </c:forEach>
                </select>

                <!-- Filtre Niveau -->
                <label class="filter-label" for="niveauSelect">Niveau :</label>
                <select id="niveauSelect" class="filter-select" onchange="applyFilters()">
                    <option value="">Tous</option>
                    <c:forEach var="n" items="${niveaux}">
                        <option value="${n}" <c:if test="${niveauFilter == n}">selected</c:if>>${n}</option>
                    </c:forEach>
                </select>

                <!-- Toggle Liste / Classement -->
                <div class="mode-toggle">
                    <a href="#" id="btnListe" onclick="setMode('liste'); return false;"
                       class="${mode == 'liste' ? 'active' : ''}">
                        <i class="fas fa-list"></i> Liste
                    </a>
                    <a href="#" id="btnClassement" onclick="setMode('classement'); return false;"
                       class="${mode == 'classement' ? 'active' : ''}">
                        <i class="fas fa-trophy"></i> Classement
                    </a>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty liste}">
                <div class="no-data">
                    <i class="fas fa-inbox"></i>
                    <p>Aucun examen trouvé<c:if test="${themeFilter != '' || niveauFilter != ''}"> pour ce filtre</c:if>.</p>
                </div>
            </c:when>

            <%-- Vue Liste --%>
            <c:when test="${mode == 'liste'}">
                <div class="section-title-bar">
                    <h3><i class="fas fa-history"></i> Historique des examens</h3>
                    <span class="count-badge">${fn:length(liste)} résultat(s)</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th><i class="fas fa-user"></i> Étudiant</th>
                            <th><i class="fas fa-layer-group"></i> Niveau</th>
                            <th><i class="fas fa-book"></i> Thème</th>
                            <th><i class="fas fa-calendar"></i> Année</th>
                            <th><i class="fas fa-star"></i> Note</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${liste}">
                        <tr>
                            <td>${e.numExam}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty e.nomEtudiant}">
                                        <strong>${e.nomEtudiant}</strong> ${e.prenomsEtudiant}
                                        <br><small style="color:#888">${e.numEtudiant}</small>
                                    </c:when>
                                    <c:otherwise>${e.numEtudiant}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not empty e.niveauEtudiant}">
                                    <span class="niveau-badge">${e.niveauEtudiant}</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty e.theme}">
                                    <span class="tag tag-theme"><i class="fas fa-tag"></i> ${e.theme}</span>
                                </c:if>
                            </td>
                            <td>${e.anneeUniv}</td>
                            <td>
                                <span class="note-badge ${e.note >= 8 ? 'note-good' : e.note >= 5 ? 'note-mid' : 'note-bad'}">
                                    ${e.note}/10
                                </span>
                            </td>
                            <td>
                                <c:url var="viewUrl" value="examen">
                                    <c:param name="action" value="view"/>
                                    <c:param name="id" value="${e.numExam}"/>
                                </c:url>
                                <c:url var="deleteUrl" value="examen">
                                    <c:param name="action" value="delete"/>
                                    <c:param name="id" value="${e.numExam}"/>
                                </c:url>
                                <a href="${viewUrl}" class="btn-edit-icon" title="Voir"><i class="fas fa-eye"></i></a>
                                <a href="#" onclick="confirmDelete('${deleteUrl}', 'Supprimer cet examen ?'); return false;" class="btn-delete-icon" title="Supprimer"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>

            <%-- Vue Classement --%>
            <c:otherwise>
                <div class="section-title-bar">
                    <h3><i class="fas fa-trophy" style="color:#f0a500"></i> Classement par mérite</h3>
                    <span class="count-badge">${fn:length(liste)} étudiant(s)</span>
                    <c:if test="${not empty themeFilter}">
                        <span class="tag tag-theme"><i class="fas fa-tag"></i> ${themeFilter}</span>
                    </c:if>
                    <c:if test="${not empty niveauFilter}">
                        <span class="niveau-badge">${niveauFilter}</span>
                    </c:if>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th style="width:60px; text-align:center">Rang</th>
                            <th><i class="fas fa-user"></i> Étudiant</th>
                            <th><i class="fas fa-layer-group"></i> Niveau</th>
                            <th><i class="fas fa-book"></i> Thème</th>
                            <th><i class="fas fa-calendar"></i> Année</th>
                            <th><i class="fas fa-star"></i> Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="rang" value="0"/>
                        <c:forEach var="e" items="${liste}">
                            <c:set var="rang" value="${rang + 1}"/>
                            <tr>
                                <td style="text-align:center">
                                    <c:choose>
                                        <c:when test="${rang == 1}"><span class="rank-medal">🥇</span></c:when>
                                        <c:when test="${rang == 2}"><span class="rank-medal">🥈</span></c:when>
                                        <c:when test="${rang == 3}"><span class="rank-medal">🥉</span></c:when>
                                        <c:otherwise><span class="rank-num">${rang}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty e.nomEtudiant}">
                                            <strong>${e.nomEtudiant}</strong> ${e.prenomsEtudiant}
                                            <br><small style="color:#888">${e.numEtudiant}</small>
                                        </c:when>
                                        <c:otherwise>${e.numEtudiant}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${not empty e.niveauEtudiant}">
                                        <span class="niveau-badge">${e.niveauEtudiant}</span>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty e.theme}">
                                        <span class="tag tag-theme"><i class="fas fa-tag"></i> ${e.theme}</span>
                                    </c:if>
                                </td>
                                <td>${e.anneeUniv}</td>
                                <td>
                                    <span class="note-badge ${e.note >= 15 ? 'note-good' : e.note >= 10 ? 'note-mid' : 'note-bad'}">
                                        ${e.note}/20
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Modal de confirmation -->
    <div id="confirmModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:white;border-radius:12px;padding:32px 28px;max-width:400px;width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.3);text-align:center;">
            <div style="width:60px;height:60px;border-radius:50%;background:#fff3cd;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                <i class="fas fa-exclamation-triangle" style="font-size:1.6em;color:#e65c00;"></i>
            </div>
            <h3 style="margin:0 0 10px;color:#333;font-size:1.15em;font-weight:600;">Confirmation</h3>
            <p id="confirmModalMsg" style="color:#666;margin:0 0 24px;font-size:0.95em;line-height:1.5;"></p>
            <div style="display:flex;gap:12px;justify-content:center;">
                <button onclick="closeConfirmModal()" style="background:#e0e0e0;color:#333;padding:10px 22px;border:none;border-radius:6px;font-size:0.95em;font-weight:600;cursor:pointer;box-shadow:none;">
                    <i class="fas fa-times"></i> Annuler
                </button>
                <a id="confirmModalBtn" href="#" style="background:#dc3545;color:white;padding:10px 22px;border-radius:6px;font-size:0.95em;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
                    <i class="fas fa-trash"></i> Supprimer
                </a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(url, message) {
            document.getElementById('confirmModalMsg').textContent = message;
            document.getElementById('confirmModalBtn').href = url;
            document.getElementById('confirmModal').style.display = 'flex';
        }
        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function applyFilters() {
            const theme   = document.getElementById('themeSelect').value;
            const niveau  = document.getElementById('niveauSelect').value;
            const mode    = document.querySelector('.mode-toggle a.active')?.dataset.mode
                         || '${mode}';
            buildUrl(theme, niveau, mode);
        }

        function setMode(mode) {
            document.querySelectorAll('.mode-toggle a').forEach(a => a.classList.remove('active'));
            document.getElementById(mode === 'classement' ? 'btnClassement' : 'btnListe').classList.add('active');
            const theme  = document.getElementById('themeSelect').value;
            const niveau = document.getElementById('niveauSelect').value;
            buildUrl(theme, niveau, mode);
        }

        function buildUrl(theme, niveau, mode) {
            let url = 'examen?mode=' + encodeURIComponent(mode);
            if (theme)  url += '&theme='  + encodeURIComponent(theme);
            if (niveau) url += '&niveau=' + encodeURIComponent(niveau);
            window.location.href = url;
        }
    </script>
</body>
</html>
