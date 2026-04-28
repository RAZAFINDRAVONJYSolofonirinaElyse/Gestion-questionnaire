<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Étudiants</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .header-controls {
            display: flex;
            gap: 16px;
            margin-bottom: 20px;
            align-items: center;
            width: 100%;
        }
        .header-right {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-left: auto;
        }
        .add-button {
            padding: 0 15px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
            transition: background-color 0.3s ease;
            height: 36px;
            box-sizing: border-box;
            flex-shrink: 0;
        }
        .add-button:hover {
            background-color: #218838;
            text-decoration: none;
            color: white;
        }
        .filter-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
        }
        .filter-group label {
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            color: #555;
            font-weight: 500;
            margin: 0;
            padding: 0;
            white-space: nowrap;
            height: 36px;
        }
        .filter-group select,
        .niveau-select {
            width: auto;
            padding: 0 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background-color: white;
            cursor: pointer;
            min-width: 130px;
            height: 36px;
            box-sizing: border-box;
            margin-bottom: 0;
            transition: border-color 0.3s ease;
        }
        .filter-group select:focus,
        .niveau-select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.15);
        }
        .search-container {
            margin: 0;
            padding: 0;
            background: none;
            border-radius: 0;
            box-shadow: none;
            max-width: none;
        }
        .search-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            height: 36px;
        }
        .search-wrapper .search-icon {
            position: absolute;
            left: 10px;
            color: #aaa;
            font-size: 13px;
            pointer-events: none;
            z-index: 1;
        }
        .search-wrapper input[type="text"] {
            width: auto;
            height: 36px;
            padding: 0 36px 0 32px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            min-width: 230px;
            box-sizing: border-box;
            margin-bottom: 0;
            transition: border-color 0.3s ease;
            background-color: white;
        }
        .search-wrapper input[type="text"]:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.15);
        }
        .clear-search {
            position: absolute;
            right: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 18px;
            height: 18px;
            background-color: #aaa;
            color: white;
            border-radius: 50%;
            font-size: 10px;
            text-decoration: none;
            transition: background-color 0.2s ease;
            flex-shrink: 0;
        }
        .clear-search:hover {
            background-color: #888;
            text-decoration: none;
        }
        .stats-section {
            background-color: #f9f9f9;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
        }
        .stats-section h3 {
            margin-top: 0;
            color: #333;
        }
        .stats-table {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .stat-item {
            background-color: white;
            padding: 10px 15px;
            border-radius: 4px;
            border-left: 4px solid #007bff;
            min-width: 150px;
        }
        .stat-item strong {
            color: #007bff;
            font-size: 16px;
        }
        .stat-item span {
            display: block;
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .table-footer {
            display: flex;
            justify-content: flex-end;
            margin-top: 10px;
            font-weight: bold;
            color: #333;
        }
        .total-count {
            background-color: #e7f3ff;
            padding: 8px 15px;
            border-radius: 4px;
            border: 1px solid #007bff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        table th {
            background-color: #003d7a;
            font-weight: bold;
            color: white;
        }
        table tr:hover {
            background-color: #f5f5f5;
        }
        a {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        a:hover {
            text-decoration: underline;
        }
        .no-results {
            text-align: center;
            color: #999;
            padding: 30px;
        }
        .pagination {
            display: flex;
            gap: 4px;
            align-items: center;
            justify-content: center;
            margin-top: 16px;
        }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            height: 34px;
            padding: 0 10px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            border: 1px solid #ddd;
            background: white;
            color: #333;
            transition: all 0.2s;
        }
        .page-btn:hover { background: #003d7a; color: white; border-color: #003d7a; text-decoration: none; }
        .page-btn.active { background: #003d7a; color: white; border-color: #003d7a; cursor: default; pointer-events: none; }
        .page-btn.disabled { color: #ccc; cursor: default; pointer-events: none; border-color: #eee; }
        .action-icons {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .btn-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 6px;
            font-size: 14px;
            text-decoration: none;
            transition: background 0.2s, color 0.2s, transform 0.1s;
            margin: 0;
        }
        .btn-icon:hover {
            text-decoration: none;
            transform: translateY(-1px);
        }
        .btn-icon-edit {
            background: #e3f2fd;
            color: #0d47a1;
            border: 1px solid #90caf9;
        }
        .btn-icon-edit:hover {
            background: #0d47a1;
            color: white;
        }
        .btn-icon-delete {
            background: #ffebee;
            color: #b71c1c;
            border: 1px solid #ef9a9a;
        }
        .btn-icon-delete:hover {
            background: #b71c1c;
            color: white;
        }
    </style>
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
        <h2>Liste des étudiants</h2>

        <!-- Barre de contrôles (Ajout, Filtre, Recherche) -->
        <div class="header-controls">
            <a href="etudiant?action=new" class="add-button"><i class="fas fa-plus"></i> Ajouter un étudiant</a>

            <div class="header-right">
                <div class="filter-group">
                    <label for="niveauFilter">Niveau :</label>
                    <select id="niveauFilter" class="niveau-select" onchange="filterByNiveauURL(this.value)">
                        <option value="">Tous</option>
                        <c:if test="${stats != null}">
                            <c:forEach var="entry" items="${stats}">
                                <option value="${entry.key}" <c:if test="${niveauFilter == entry.key}">selected</c:if>>${entry.key}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <form id="searchForm" method="GET" action="etudiant" class="search-container">
                    <div class="search-wrapper">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchInput" name="search" placeholder="Rechercher un étudiant..." value="${search != null ? search : ''}">
                        <c:if test="${search != null}">
                            <a href="etudiant" class="clear-search"><i class="fas fa-times"></i></a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>

        <!-- Affichage des statistiques -->
        <c:if test="${stats != null && !search && !niveauFilter}">
            <div class="stats-section">
                <h3>Statistiques par niveau</h3>
                <div class="stats-table">
                    <c:set var="totalEffectif" value="0" />
                    <c:forEach var="entry" items="${stats}">
                        <div class="stat-item">
                            <strong>${entry.key}</strong>
                            <span>${entry.value} étudiant(s)</span>
                        </div>
                        <c:set var="totalEffectif" value="${totalEffectif + entry.value}" />
                    </c:forEach>
                    <div class="stat-item" style="border-left-color: #28a745;">
                        <strong style="color: #28a745;">Total</strong>
                        <span>${totalEffectif} étudiant(s)</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Affichage de la liste plate ou filtrée -->
        <c:if test="${search == null}">
            <table>
                <tr>
                    <th>Num</th>
                    <th>Nom</th>
                    <th>Prénoms</th>
                    <th>Niveau</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
                <c:choose>
                    <c:when test="${empty liste}">
                        <tr><td colspan="6" class="no-results"><i class="fas fa-inbox"></i> Aucun étudiant.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="e" items="${liste}">
                            <tr>
                                <td>${e.numEtudiant}</td>
                                <td>${e.nom}</td>
                                <td>${e.prenoms}</td>
                                <td>${e.niveau}</td>
                                <td>${e.adr_email}</td>
                                <td>
                                    <c:url var="editUrl" value="etudiant">
                                        <c:param name="action" value="edit" />
                                        <c:param name="num" value="${e.numEtudiant}" />
                                    </c:url>
                                    <c:url var="deleteUrl" value="etudiant">
                                        <c:param name="action" value="delete" />
                                        <c:param name="num" value="${e.numEtudiant}" />
                                    </c:url>
                                    <div class="action-icons">
                                        <a href="${editUrl}" class="btn-icon btn-icon-edit" title="Modifier"><i class="fas fa-pencil-alt"></i></a>
                                        <a href="#" onclick="confirmDelete('${deleteUrl}', 'Êtes-vous sûr de vouloir supprimer cet étudiant ?'); return false;" class="btn-icon btn-icon-delete" title="Supprimer"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>

            <!-- Total -->
            <div class="table-footer">
                <div class="total-count">
                    <c:choose>
                        <c:when test="${not empty niveauFilter}">
                            <i class="fas fa-filter"></i> ${niveauFilter} : <strong>${totalCount}</strong> étudiant(s)
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-users"></i> Total : <strong>${totalCount}</strong> étudiant(s)
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:choose>
                        <c:when test="${currentPage <= 1}">
                            <span class="page-btn disabled"><i class="fas fa-chevron-left"></i></span>
                        </c:when>
                        <c:otherwise>
                            <c:url var="prevUrl" value="etudiant">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}" /></c:if>
                            </c:url>
                            <a href="${prevUrl}" class="page-btn"><i class="fas fa-chevron-left"></i></a>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <span class="page-btn active">${p}</span>
                            </c:when>
                            <c:otherwise>
                                <c:url var="pageUrl" value="etudiant">
                                    <c:param name="page" value="${p}" />
                                    <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}" /></c:if>
                                </c:url>
                                <a href="${pageUrl}" class="page-btn">${p}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage >= totalPages}">
                            <span class="page-btn disabled"><i class="fas fa-chevron-right"></i></span>
                        </c:when>
                        <c:otherwise>
                            <c:url var="nextUrl" value="etudiant">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:if test="${not empty niveauFilter}"><c:param name="niveau" value="${niveauFilter}" /></c:if>
                            </c:url>
                            <a href="${nextUrl}" class="page-btn"><i class="fas fa-chevron-right"></i></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </c:if>

        <!-- Affichage des résultats de recherche -->
        <c:if test="${search != null}">
            <c:set var="resultCount" value="0" />
            <table>
                <tr>
                    <th>Num</th>
                    <th>Nom</th>
                    <th>Prénoms</th>
                    <th>Niveau</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
                <c:if test="${empty liste}">
                    <tr>
                        <td colspan="6" class="no-results">
                            <i class="fas fa-search"></i> Aucun étudiant trouvé pour: <strong>${search}</strong>
                        </td>
                    </tr>
                </c:if>
                <c:forEach var="e" items="${liste}">
                    <c:set var="resultCount" value="${resultCount + 1}" />
                    <tr>
                        <td>${e.numEtudiant}</td>
                        <td>${e.nom}</td>
                        <td>${e.prenoms}</td>
                        <td>${e.niveau}</td>
                        <td>${e.adr_email}</td>
                        <td>
                            <c:url var="editUrl" value="etudiant">
                                <c:param name="action" value="edit" />
                                <c:param name="num" value="${e.numEtudiant}" />
                            </c:url>
                            <c:url var="deleteUrl" value="etudiant">
                                <c:param name="action" value="delete" />
                                <c:param name="num" value="${e.numEtudiant}" />
                            </c:url>
                            <div class="action-icons">
                                <a href="${editUrl}" class="btn-icon btn-icon-edit" title="Modifier"><i class="fas fa-pencil-alt"></i></a>
                                <a href="${deleteUrl}" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet étudiant ?')" class="btn-icon btn-icon-delete" title="Supprimer"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <!-- Total des résultats de recherche -->
            <c:if test="${!empty liste}">
                <div class="table-footer">
                    <div class="total-count">
                        <i class="fas fa-search"></i> Résultats: <strong>${resultCount}</strong> étudiant(s) trouvé(s)
                    </div>
                </div>
            </c:if>
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

        let searchTimeout;

        // Recherche instantanée avec debounce
        document.getElementById('searchInput').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                document.getElementById('searchForm').submit();
            }, 300); // Attendre 300ms après la fin de la frappe
        });
        
        function filterByNiveauURL(niveau) {
            if (niveau === '') {
                window.location.href = 'etudiant';
            } else {
                window.location.href = 'etudiant?niveau=' + niveau;
            }
        }
    </script>
</body>
</html>