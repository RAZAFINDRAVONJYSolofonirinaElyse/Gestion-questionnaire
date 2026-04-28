<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Questionnaire - Détails QCM</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .details-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 61, 122, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .detail-section {
            margin-bottom: 30px;
        }

        .detail-label {
            font-weight: 600;
            color: #003d7a;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: block;
        }

        .detail-value {
            color: #333;
            font-size: 1.05em;
            line-height: 1.6;
            padding: 12px 15px;
            background-color: #f8f9fa;
            border-radius: 6px;
            border-left: 4px solid #003d7a;
        }

        .reponse-item {
            padding: 12px 15px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .reponse-numero {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: #e3f2fd;
            color: #003d7a;
            border-radius: 50%;
            font-weight: 600;
            flex-shrink: 0;
        }

        .reponse-numero.correct {
            background-color: #e8f5e9;
            color: #1b5e20;
        }

        .tags-section {
            display: flex;
            gap: 15px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
        }

        .tag-niveau {
            background-color: #e3f2fd;
            color: #1565c0;
            border: 1px solid #90caf9;
        }

        .tag-theme {
            background-color: #f3e5f5;
            color: #6a1b9a;
            border: 1px solid #ce93d8;
        }

        .actions-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            border-radius: 6px;
            font-size: 0.95em;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-back {
            background-color: #e0e0e0;
            color: #333;
        }

        .btn-back:hover {
            background-color: #b0b0b0;
            transform: translateY(-2px);
        }

        .btn-edit {
            background-color: #e3f2fd;
            color: #0d47a1;
            border: 1px solid #64b5f6;
        }

        .btn-edit:hover {
            background-color: #0d47a1;
            color: white;
            transform: translateY(-2px);
        }

        .btn-delete {
            background-color: #ffebee;
            color: #b71c1c;
            border: 1px solid #ef9a9a;
        }

        .btn-delete:hover {
            background-color: #b71c1c;
            color: white;
            transform: translateY(-2px);
        }

        .question-title {
            font-size: 1.4em;
            font-weight: 700;
            color: #003d7a;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #003d7a;
        }
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
        <h2>Détails du QCM</h2>

        <c:if test="${not empty qcm}">
        <div class="details-container">
            <h3 class="question-title">${qcm.question}</h3>

            <div class="tags-section">
                <span class="tag tag-niveau">
                    <i class="fas fa-layer-group"></i> ${qcm.niveau}
                </span>
                <span class="tag tag-theme">
                    <i class="fas fa-bookmark"></i> ${qcm.theme}
                </span>
            </div>

            <div class="detail-section" style="margin-top: 30px;">
                <label class="detail-label"><i class="fas fa-list"></i> Réponses</label>
                
                <div class="reponse-item">
                    <div class="reponse-numero ${qcm.bonneReponse == 1 ? 'correct' : ''}">1</div>
                    <div>
                        ${qcm.reponse1}
                        <c:if test="${qcm.bonneReponse == 1}">
                            <span style="margin-left: 10px; color: #1b5e20; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Correcte
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="reponse-item">
                    <div class="reponse-numero ${qcm.bonneReponse == 2 ? 'correct' : ''}">2</div>
                    <div>
                        ${qcm.reponse2}
                        <c:if test="${qcm.bonneReponse == 2}">
                            <span style="margin-left: 10px; color: #1b5e20; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Correcte
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="reponse-item">
                    <div class="reponse-numero ${qcm.bonneReponse == 3 ? 'correct' : ''}">3</div>
                    <div>
                        ${qcm.reponse3}
                        <c:if test="${qcm.bonneReponse == 3}">
                            <span style="margin-left: 10px; color: #1b5e20; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Correcte
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="reponse-item">
                    <div class="reponse-numero ${qcm.bonneReponse == 4 ? 'correct' : ''}">4</div>
                    <div>
                        ${qcm.reponse4}
                        <c:if test="${qcm.bonneReponse == 4}">
                            <span style="margin-left: 10px; color: #1b5e20; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Correcte
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="actions-buttons">
                <a href="qcm" class="btn btn-back">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
                <c:url var="editUrl" value="qcm">
                    <c:param name="action" value="edit" />
                    <c:param name="id" value="${qcm.numQuest}" />
                </c:url>
                <a href="${editUrl}" class="btn btn-edit">
                    <i class="fas fa-edit"></i> Modifier
                </a>
                <c:url var="deleteUrl" value="qcm">
                    <c:param name="action" value="delete" />
                    <c:param name="id" value="${qcm.numQuest}" />
                </c:url>
                <a href="#" class="btn btn-delete" onclick="confirmDelete('${deleteUrl}', 'Êtes-vous sûr de vouloir supprimer ce QCM ?'); return false;">
                    <i class="fas fa-trash"></i> Supprimer
                </a>
            </div>
        </div>
        </c:if>

        <c:if test="${empty qcm}">
        <div class="no-data">
            <i class="fas fa-exclamation-circle"></i>
            <p>QCM non trouvé.</p>
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
    </script>
</body>
</html>
