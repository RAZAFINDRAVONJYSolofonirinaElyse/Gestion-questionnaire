package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.SessionExamenDAO;
import dao.QcmDAO;
import dao.EtudiantDAO;
import dao.ExamenDAO;
import model.Qcm;
import model.Etudiant;
import model.Examen;
import model.SessionExamen;
import util.EmailService;

public class SessionExamenServlet extends HttpServlet {

    private SessionExamenDAO sessionExamenDAO;
    private QcmDAO qcmDAO;
    private EtudiantDAO etudiantDAO;
    private ExamenDAO examenDAO;

    @Override
    public void init() throws ServletException {
        sessionExamenDAO = new SessionExamenDAO();
        qcmDAO = new QcmDAO();
        etudiantDAO = new EtudiantDAO();
        examenDAO = new ExamenDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "demarrer";

        switch (action) {
            case "demarrer":
                showDemarrerForm(request, response);
                break;
            case "etudiantInfo":
                getEtudiantInfo(request, response);
                break;
            case "question":
                afficherExamen(request, response);
                break;
            default:
                showDemarrerForm(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        switch (action) {
            case "commencer":
                commencerExamen(request, response);
                break;
            case "soumettreExamen":
                soumettreExamen(request, response);
                break;
            default:
                showDemarrerForm(request, response);
                break;
        }
    }

    private void showDemarrerForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/examen/demarrer.jsp").forward(request, response);
    }

    private void getEtudiantInfo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String numEtudiant = request.getParameter("numEtudiant");
        if (numEtudiant == null || numEtudiant.trim().isEmpty()) {
            response.getWriter().write("{\"found\":false}");
            return;
        }
        try {
            Etudiant etudiant = etudiantDAO.getById(numEtudiant.trim());
            if (etudiant == null) {
                response.getWriter().write("{\"found\":false}");
                return;
            }
            String niveau = etudiant.getNiveau();
            List<String> themes = qcmDAO.obtenirThemesByNiveau(niveau);
            StringBuilder json = new StringBuilder();
            json.append("{\"found\":true");
            json.append(",\"niveau\":\"").append(escapeJson(niveau)).append("\"");
            json.append(",\"nom\":\"").append(escapeJson(etudiant.getPrenoms() + " " + etudiant.getNom())).append("\"");
            json.append(",\"themes\":[");
            for (int i = 0; i < themes.size(); i++) {
                if (i > 0) json.append(",");
                json.append("\"").append(escapeJson(themes.get(i))).append("\"");
            }
            json.append("]}");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"found\":false}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private void commencerExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String numEtudiant = request.getParameter("numEtudiant");
        String theme = request.getParameter("theme");
        String anneeUniv = request.getParameter("anneeUniv");

        Etudiant etudiant = null;
        try {
            etudiant = etudiantDAO.getById(numEtudiant);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la récupération de l'étudiant");
            showDemarrerForm(request, response);
            return;
        }

        if (etudiant == null) {
            request.setAttribute("erreur", "Étudiant non trouvé");
            showDemarrerForm(request, response);
            return;
        }

        Examen examenExistant = examenDAO.getByEtudiantTheme(numEtudiant, theme);
        if (examenExistant != null) {
            request.setAttribute("examenExistant", examenExistant);
            request.setAttribute("etudiantBloque", etudiant);
            showDemarrerForm(request, response);
            return;
        }

        String niveau = etudiant.getNiveau();
        List<Integer> questionIds = sessionExamenDAO.obtenirQuestionsAleatoires(theme, niveau);

        if (questionIds.isEmpty()) {
            request.setAttribute("erreur", "Aucune question disponible pour ce thème et ce niveau");
            showDemarrerForm(request, response);
            return;
        }

        int numSession = sessionExamenDAO.creerSession(numEtudiant, theme);

        HttpSession httpSession = request.getSession();
        httpSession.setAttribute("numSession", numSession);
        httpSession.setAttribute("numEtudiant", numEtudiant);
        httpSession.setAttribute("anneeUniv", anneeUniv);
        httpSession.setAttribute("theme", theme);
        httpSession.setAttribute("questionIds", questionIds);

        response.sendRedirect("SessionExamen?action=question");
    }

    private void afficherExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession();

        Integer numSession = (Integer) httpSession.getAttribute("numSession");
        @SuppressWarnings("unchecked")
        List<Integer> questionIds = (List<Integer>) httpSession.getAttribute("questionIds");
        String theme = (String) httpSession.getAttribute("theme");

        if (numSession == null || questionIds == null) {
            response.sendRedirect("SessionExamen?action=demarrer");
            return;
        }

        List<Qcm> questions = new ArrayList<>();
        for (Integer id : questionIds) {
            Qcm q = qcmDAO.getById(id);
            if (q != null) questions.add(q);
        }

        request.setAttribute("questions", questions);
        request.setAttribute("theme", theme);
        request.getRequestDispatcher("/examen/question.jsp").forward(request, response);
    }

    private void soumettreExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession();

        Integer numSession = (Integer) httpSession.getAttribute("numSession");
        String numEtudiant = (String) httpSession.getAttribute("numEtudiant");
        String anneeUniv = (String) httpSession.getAttribute("anneeUniv");
        @SuppressWarnings("unchecked")
        List<Integer> questionIds = (List<Integer>) httpSession.getAttribute("questionIds");

        if (numSession == null || questionIds == null) {
            response.sendRedirect("SessionExamen?action=demarrer");
            return;
        }

        for (Integer numQuest : questionIds) {
            String param = request.getParameter("reponse_" + numQuest);
            if (param == null) continue;
            int reponseEtudiant = Integer.parseInt(param);
            Qcm question = qcmDAO.getById(numQuest);
            boolean estCorrecte = (question != null && question.getBonneReponse() == reponseEtudiant);
            sessionExamenDAO.enregistrerReponse(numSession, numQuest, reponseEtudiant, estCorrecte);
        }

        sessionExamenDAO.sauvegarderNote(numSession, numEtudiant, anneeUniv);

        SessionExamen sessionExamen = sessionExamenDAO.getSessionById(numSession);

        httpSession.removeAttribute("numSession");
        httpSession.removeAttribute("numEtudiant");
        httpSession.removeAttribute("anneeUniv");
        httpSession.removeAttribute("questionIds");

        try {
            Etudiant etudiant = etudiantDAO.getById(numEtudiant);
            if (etudiant != null && etudiant.getAdr_email() != null && !etudiant.getAdr_email().isEmpty()) {
                String nomComplet = etudiant.getPrenoms() + " " + etudiant.getNom();
                EmailService.sendExamResult(
                    etudiant.getAdr_email(), nomComplet, numEtudiant,
                    sessionExamen != null ? sessionExamen.getTheme() : "",
                    anneeUniv,
                    sessionExamen != null ? sessionExamen.getNote() : 0
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (sessionExamen == null) {
            request.setAttribute("erreur", "Impossible de charger le résultat.");
            showDemarrerForm(request, response);
            return;
        }

        request.setAttribute("sessionExamen", sessionExamen);
        request.setAttribute("note", sessionExamen.getNote());
        request.getRequestDispatcher("/examen/resultat.jsp").forward(request, response);
    }
}
