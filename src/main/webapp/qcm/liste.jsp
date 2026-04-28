<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - QCM</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .controls-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        .controls-right {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-left: auto;
        }
        .filter-label {
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            color: #555;
            font-weight: 500;
            margin: 0;
            white-space: nowrap;
            height: 36px;
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
        }
        .filter-select:focus {
            outline: none;
            border-color: #003d7a;
            box-shadow: 0 0 0 2px rgba(0,61,122,0.15);
        }
        .active-filters {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .filter-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
        }
        .chip-theme  { background: #f3e5f5; color: #6a1b9a; border: 1px solid #ce93d8; }
        .chip-niveau { background: #e3f2fd; color: #1565c0; border: 1px solid #90caf9; }
        .chip-remove { text-decoration: none; color: inherit; opacity: 0.7; font-size: 11px; }
        .chip-remove:hover { opacity: 1; text-decoration: none; }
        .count-line {
            font-size: 13px;
            color: #777;
            margin-bottom: 14px;
        }
        .count-line strong { color: #333; }
        .pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            margin-top: 24px;
            flex-wrap: wrap;
        }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background: white;
            color: #003d7a;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.15s;
        }
        .page-btn:hover { background: #e8f0fe; text-decoration: none; }
        .page-btn.active { background: #003d7a; color: white; border-color: #003d7a; font-weight: 700; }
        .page-btn.disabled { color: #bbb; border-color: #eee; pointer-events: none; background: #fafafa; }
    </style>
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
        <h2>Liste des QCM</h2>

        <!-- Barre de contrôles -->
        <div class="controls-bar">
            <a href="qcm?action=new" class="add-button"><i class="fas fa-plus"></i> Ajouter un QCM</a>

            <div class="controls-right">
                <label class="filter-label" for="themeSelect">Thème :</label>
                <select id="themeSelect" class="filter-select" onchange="applyFilters()">
                    <option value="">Tous</option>
                    <c:forEach var="t" items="${themes}">
                        <option value="${t}" <c:if test="${themeFilter == t}">selected</c:if>>${t}</option>
                    </c:forEach>
                </select>

                <label class="filter-label" for="niveauSelect">Niveau :</label>
                <select id="niveauSelect" class="filter-select" onchange="applyFilters()">
                    <option value="">Tous</option>
                    <c:forEach var="n" items="${niveaux}">
                        <option value="${n}" <c:if test="${niveauFilter == n}">selected</c:if>>${n}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- Chips des filtres actifs -->
        <c:if test="${not empty themeFilter || not empty niveauFilter}">
        <div class="active-filters">
            <span style="font-size:13px; color:#777;">Filtres actifs :</span>
            <c:if test="${not empty themeFilter}">
                <span class="filter-chip chip-theme">
                    <i class="fas fa-bookmark"></i> ${themeFilter}
                    <c:url var="removeTheme" value="qcm">
                        <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}"/></c:if>
                    </c:url>
                    <a href="${removeTheme}" class="chip-remove" title="Retirer"><i class="fas fa-times"></i></a>
                </span>
            </c:if>
            <c:if test="${not empty niveauFilter}">
                <span class="filter-chip chip-niveau">
                    <i class="fas fa-layer-group"></i> ${niveauFilter}
                    <c:url var="removeNiveau" value="qcm">
                        <c:if test="${not empty themeFilter}"><c:param name="theme" value="${themeFilter}"/></c:if>
                    </c:url>
                    <a href="${removeNiveau}" class="chip-remove" title="Retirer"><i class="fas fa-times"></i></a>
                </span>
            </c:if>
            <a href="qcm" style="font-size:13px; color:#999;">Réinitialiser</a>
        </div>
        </c:if>

        <!-- Compteur -->
        <div class="count-line">
            <strong>${totalCount}</strong> QCM trouvé(s)
        </div>

        <div class="qcm-cards-container">
            <c:choose>
                <c:when test="${empty liste}">
                    <div class="no-data">
                        <i class="fas fa-inbox"></i>
                        <c:choose>
                            <c:when test="${not empty themeFilter || not empty niveauFilter}">
                                <p>Aucun QCM pour ce filtre.</p>
                            </c:when>
                            <c:otherwise>
                                <p>Aucun QCM disponible. <a href="qcm?action=new">Créer un nouveau QCM</a></p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="q" items="${liste}">
                    <div class="qcm-card">
                        <div class="qcm-card-content">
                            <h3 class="qcm-question">${q.question}</h3>

                            <div class="qcm-tags">
                                <span class="tag tag-niveau">
                                    <i class="fas fa-layer-group"></i> ${q.niveau}
                                </span>
                                <span class="tag tag-theme">
                                    <i class="fas fa-bookmark"></i> ${q.theme}
                                </span>
                            </div>
                        </div>

                        <div class="qcm-card-actions">
                            <c:url var="editUrl" value="qcm">
                                <c:param name="action" value="edit" />
                                <c:param name="id" value="${q.numQuest}" />
                            </c:url>
                            <c:url var="deleteUrl" value="qcm">
                                <c:param name="action" value="delete" />
                                <c:param name="id" value="${q.numQuest}" />
                            </c:url>

                            <a href="qcm?action=view&id=${q.numQuest}" class="btn-action btn-view" title="Voir les détails">
                                    <i class="fas fa-eye"></i> 
                            </a>
                            <a href="${editUrl}" class="btn-action btn-edit" title="Modifier">
                                <i class="fas fa-edit"></i> 
                            </a>
                            <a href="#" class="btn-action btn-delete" title="Supprimer" onclick="confirmDelete('${deleteUrl}', 'Êtes-vous sûr de vouloir supprimer ce QCM ?'); return false;">
                                <i class="fas fa-trash"></i> 
                            </a>
                        </div>
                    </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
        <div class="pagination">
            <%-- Précédent --%>
            <c:choose>
                <c:when test="${currentPage <= 1}">
                    <span class="page-btn disabled"><i class="fas fa-chevron-left"></i></span>
                </c:when>
                <c:otherwise>
                    <c:url var="prevUrl" value="qcm">
                        <c:param name="page" value="${currentPage - 1}"/>
                        <c:if test="${not empty themeFilter}"><c:param name="theme" value="${themeFilter}"/></c:if>
                        <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}"/></c:if>
                    </c:url>
                    <a href="${prevUrl}" class="page-btn"><i class="fas fa-chevron-left"></i></a>
                </c:otherwise>
            </c:choose>

            <%-- Numéros de pages --%>
            <c:forEach begin="1" end="${totalPages}" var="p">
                <c:url var="pageUrl" value="qcm">
                    <c:param name="page" value="${p}"/>
                    <c:if test="${not empty themeFilter}"><c:param name="theme" value="${themeFilter}"/></c:if>
                    <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}"/></c:if>
                </c:url>
                <a href="${pageUrl}" class="page-btn ${p == currentPage ? 'active' : ''}">${p}</a>
            </c:forEach>

            <%-- Suivant --%>
            <c:choose>
                <c:when test="${currentPage >= totalPages}">
                    <span class="page-btn disabled"><i class="fas fa-chevron-right"></i></span>
                </c:when>
                <c:otherwise>
                    <c:url var="nextUrl" value="qcm">
                        <c:param name="page" value="${currentPage + 1}"/>
                        <c:if test="${not empty themeFilter}"><c:param name="theme" value="${themeFilter}"/></c:if>
                        <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}"/></c:if>
                    </c:url>
                    <a href="${nextUrl}" class="page-btn"><i class="fas fa-chevron-right"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
        </c:if>
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
            const theme  = document.getElementById('themeSelect').value;
            const niveau = document.getElementById('niveauSelect').value;
            let url = 'qcm?';
            if (theme)  url += 'theme='  + encodeURIComponent(theme)  + '&';
            if (niveau) url += 'niveau=' + encodeURIComponent(niveau) + '&';
            window.location.href = url.replace(/&$/, '') || 'qcm';
        }
    </script>
</body>
</html>
