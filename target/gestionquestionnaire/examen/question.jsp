<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Qcm" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Examen en cours</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f5f7fa; }
        .exam-wrapper { max-width: 860px; margin: 40px auto; padding: 0 20px 60px; }
        .exam-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 30px;
        }
        .exam-header h2 { border-bottom: none; margin-bottom: 0; font-size: 1.5em; }
        .exam-badge {
            background: #003d7a; color: white; padding: 8px 18px;
            border-radius: 20px; font-weight: 600; font-size: 0.9em;
        }
        .question-card {
            background: white; border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,61,122,0.08);
            padding: 24px 28px; margin-bottom: 20px;
            border-left: 4px solid #003d7a;
        }
        .question-meta {
            display: flex; gap: 8px; margin-bottom: 14px;
        }
        .question-num {
            background: #003d7a; color: white; border-radius: 50%;
            width: 30px; height: 30px; display: inline-flex;
            align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.9em; flex-shrink: 0; margin-right: 6px;
        }
        .question-text {
            font-size: 1.05em; font-weight: 600; color: #222;
            line-height: 1.5; margin-bottom: 18px;
            display: flex; align-items: flex-start; gap: 10px;
        }
        .question-text span { flex: 1; }
        .reponse-option {
            display: flex; align-items: center;
            padding: 11px 16px; border: 2px solid #e0e0e0;
            border-radius: 8px; margin-bottom: 10px; cursor: pointer;
            transition: all 0.2s ease;
        }
        .reponse-option:hover { border-color: #003d7a; background: #f0f4ff; }
        .reponse-option:has(input:checked) { border-color: #003d7a; background: #e8f0ff; }
        .reponse-option input[type="radio"] {
            margin-right: 12px; width: 17px; height: 17px; accent-color: #003d7a; flex-shrink: 0;
        }
        .submit-bar {
            position: sticky; bottom: 0; background: white;
            border-top: 2px solid #e0e0e0; padding: 16px 28px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.08); border-radius: 12px 12px 0 0;
            margin: 0 -20px;
        }
        .submit-bar .btn-submit {
            padding: 14px 40px; font-size: 1.05em; border-radius: 8px;
        }
        .progress-info { color: #666; font-size: 0.95em; }
        .required-note { color: #dc3545; font-size: 0.85em; }
    </style>
</head>
<body>
    <%!
        private String esc(String s) {
            if (s == null) return "";
            return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
        }
    %>
    <%
        @SuppressWarnings("unchecked")
        List<Qcm> questions = (List<Qcm>) request.getAttribute("questions");
        String theme = (String) request.getAttribute("theme");
    %>

    <div class="exam-wrapper">
        <div class="exam-header">
            <h2><i class="fas fa-file-alt" style="color:#003d7a; margin-right:10px;"></i>Examen — <%= theme %></h2>
            <span class="exam-badge"><i class="fas fa-list-ol"></i> <%= questions != null ? questions.size() : 0 %> questions</span>
        </div>

        <form action="${pageContext.request.contextPath}/SessionExamen" method="POST" id="examForm">
            <input type="hidden" name="action" value="soumettreExamen">

            <% if (questions != null) {
                int i = 1;
                for (Qcm q : questions) { %>
            <div class="question-card">
                <div class="question-meta">
                    <span class="tag tag-theme"><i class="fas fa-tag"></i><%= esc(q.getTheme()) %></span>
                    <span class="tag tag-niveau"><i class="fas fa-layer-group"></i><%= esc(q.getNiveau()) %></span>
                </div>
                <div class="question-text">
                    <span class="question-num"><%= i %></span>
                    <span><%= esc(q.getQuestion()) %></span>
                </div>
                <label class="reponse-option">
                    <input type="radio" name="reponse_<%= q.getNumQuest() %>" value="1" required>
                    <span><%= esc(q.getReponse1()) %></span>
                </label>
                <label class="reponse-option">
                    <input type="radio" name="reponse_<%= q.getNumQuest() %>" value="2">
                    <span><%= esc(q.getReponse2()) %></span>
                </label>
                <label class="reponse-option">
                    <input type="radio" name="reponse_<%= q.getNumQuest() %>" value="3">
                    <span><%= esc(q.getReponse3()) %></span>
                </label>
                <label class="reponse-option">
                    <input type="radio" name="reponse_<%= q.getNumQuest() %>" value="4">
                    <span><%= esc(q.getReponse4()) %></span>
                </label>
            </div>
            <% i++; } } %>

            <div class="submit-bar">
                <span class="progress-info">
                    <span class="required-note">*</span> Toutes les questions sont obligatoires
                </span>
                <button type="submit" class="add-button btn-submit">
                    <i class="fas fa-paper-plane"></i> Soumettre l'Examen
                </button>
            </div>
        </form>
    </div>
</body>
</html>
