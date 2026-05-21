package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.QcmDAO;
import model.Qcm;

public class QcmServlet extends HttpServlet {

    private QcmDAO qcmDAO;

    @Override
    public void init() throws ServletException {
        qcmDAO = new QcmDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":   listQcms(request, response);    break;
            case "new":    showNewForm(request, response);  break;
            case "view":   showDetails(request, response);  break;
            case "edit":   showEditForm(request, response); break;
            case "delete": deleteQcm(request, response);   break;
            default:       listQcms(request, response);     break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        switch (action) {
            case "insert": insertQcm(request, response); break;
            case "update": updateQcm(request, response); break;
            case "delete": deleteQcm(request, response); break;
            default:       listQcms(request, response);  break;
        }
    }

    // ── Liste ────────────────────────────────────────────────────────────────

    private void listQcms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String theme  = request.getParameter("theme");
        String niveau = request.getParameter("niveau");

        final int PAGE_SIZE = 5;
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
            if (page < 1) page = 1;
        }

        List<Qcm> tous = qcmDAO.listerFiltre(theme, niveau);
        int total      = tous.size();
        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / PAGE_SIZE);
        if (page > totalPages) page = totalPages;
        int fromIndex  = (page - 1) * PAGE_SIZE;
        int toIndex    = Math.min(fromIndex + PAGE_SIZE, total);
        List<Qcm> pageListe = (fromIndex < total)
            ? tous.subList(fromIndex, toIndex)
            : new ArrayList<>();

        request.setAttribute("liste",        pageListe);
        request.setAttribute("themes",       qcmDAO.obtenirThemes());
        request.setAttribute("niveaux",      qcmDAO.obtenirNiveaux());
        request.setAttribute("themeFilter",  theme  != null ? theme  : "");
        request.setAttribute("niveauFilter", niveau != null ? niveau : "");
        request.setAttribute("currentPage",  page);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("totalCount",   total);
        request.getRequestDispatcher("/qcm/liste.jsp").forward(request, response);
    }

    // ── Formulaire Ajout ─────────────────────────────────────────────────────

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getAttribute("niveaux") == null)
            request.setAttribute("niveaux", qcmDAO.obtenirNiveaux());
        if (request.getAttribute("themes") == null)
            request.setAttribute("themes", qcmDAO.obtenirThemes());
        request.getRequestDispatcher("/qcm/ajouter.jsp").forward(request, response);
    }

    // ── Formulaire Modification ──────────────────────────────────────────────

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        Qcm qcm = qcmDAO.getById(numQuest);
        showEditFormWithData(request, response, qcm);
    }

    private void showEditFormWithData(HttpServletRequest request, HttpServletResponse response, Qcm qcm)
            throws ServletException, IOException {
        request.setAttribute("qcm",     qcm);
        request.setAttribute("niveaux", qcmDAO.obtenirNiveaux());
        request.setAttribute("themes",  qcmDAO.obtenirThemes());
        request.getRequestDispatcher("/qcm/modifier.jsp").forward(request, response);
    }

    // ── Insérer ──────────────────────────────────────────────────────────────

    private void insertQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String question    = trim(request.getParameter("question"));
        String reponse1    = trim(request.getParameter("reponse1"));
        String reponse2    = trim(request.getParameter("reponse2"));
        String reponse3    = trim(request.getParameter("reponse3"));
        String reponse4    = trim(request.getParameter("reponse4"));
        String bonneRepStr = trim(request.getParameter("bonneReponse"));
        String theme       = trim(request.getParameter("theme"));
        String themeNew    = trim(request.getParameter("themeNew"));
        String niveau      = trim(request.getParameter("niveau"));

        if (!themeNew.isEmpty()) theme = themeNew;

        boolean hasErrors = setQcmErrors(request, niveau, theme, question,
                                         reponse1, reponse2, reponse3, reponse4, bonneRepStr);
        if (hasErrors) {
            request.setAttribute("niveaux", qcmDAO.obtenirNiveaux());
            request.setAttribute("themes",  qcmDAO.obtenirThemes());
            request.getRequestDispatcher("/qcm/ajouter.jsp").forward(request, response);
            return;
        }

        Qcm qcm = new Qcm();
        qcm.setQuestion(question);
        qcm.setReponse1(reponse1);
        qcm.setReponse2(reponse2);
        qcm.setReponse3(reponse3);
        qcm.setReponse4(reponse4);
        qcm.setBonneReponse(Integer.parseInt(bonneRepStr));
        qcm.setTheme(theme);
        qcm.setNiveau(niveau);

        try {
            qcmDAO.ajouter(qcm);
            setFlash(request, "success", "Le QCM a été ajouté avec succès (thème : « " + theme + " »).");
            response.sendRedirect("qcm");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("erreurQuestion", "Erreur lors de l'ajout du QCM.");
            request.setAttribute("niveaux", qcmDAO.obtenirNiveaux());
            request.setAttribute("themes",  qcmDAO.obtenirThemes());
            request.getRequestDispatcher("/qcm/ajouter.jsp").forward(request, response);
        }
    }

    // ── Mettre à jour ────────────────────────────────────────────────────────

    private void updateQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idStr       = trim(request.getParameter("id"));
        String question    = trim(request.getParameter("question"));
        String reponse1    = trim(request.getParameter("reponse1"));
        String reponse2    = trim(request.getParameter("reponse2"));
        String reponse3    = trim(request.getParameter("reponse3"));
        String reponse4    = trim(request.getParameter("reponse4"));
        String bonneRepStr = trim(request.getParameter("bonneReponse"));
        String theme       = trim(request.getParameter("theme"));
        String themeNew    = trim(request.getParameter("themeNew"));
        String niveau      = trim(request.getParameter("niveau"));

        if (!themeNew.isEmpty()) theme = themeNew;

        int numQuest = 0;
        try { numQuest = Integer.parseInt(idStr); } catch (NumberFormatException ignored) {}

        boolean hasErrors = setQcmErrors(request, niveau, theme, question,
                                          reponse1, reponse2, reponse3, reponse4, bonneRepStr);
        if (hasErrors) {
            Qcm qcmForm = new Qcm();
            qcmForm.setNumQuest(numQuest);
            qcmForm.setQuestion(question);
            qcmForm.setReponse1(reponse1);
            qcmForm.setReponse2(reponse2);
            qcmForm.setReponse3(reponse3);
            qcmForm.setReponse4(reponse4);
            try { qcmForm.setBonneReponse(Integer.parseInt(bonneRepStr)); } catch (NumberFormatException ignored) {}
            qcmForm.setTheme(theme);
            qcmForm.setNiveau(niveau);
            showEditFormWithData(request, response, qcmForm);
            return;
        }

        Qcm qcm = new Qcm();
        qcm.setNumQuest(numQuest);
        qcm.setQuestion(question);
        qcm.setReponse1(reponse1);
        qcm.setReponse2(reponse2);
        qcm.setReponse3(reponse3);
        qcm.setReponse4(reponse4);
        qcm.setBonneReponse(Integer.parseInt(bonneRepStr));
        qcm.setTheme(theme);
        qcm.setNiveau(niveau);

        try {
            qcmDAO.update(qcm);
            setFlash(request, "success", "Le QCM #" + numQuest + " a été modifié avec succès.");
            response.sendRedirect("qcm");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la modification du QCM.");
            showEditFormWithData(request, response, qcm);
        }
    }

    // ── Détails ──────────────────────────────────────────────────────────────

    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        Qcm qcm = qcmDAO.getById(numQuest);
        request.setAttribute("qcm", qcm);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/qcm/details.jsp");
        dispatcher.forward(request, response);
    }

    // ── Supprimer ────────────────────────────────────────────────────────────

    private void deleteQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int numQuest = Integer.parseInt(request.getParameter("id"));
            qcmDAO.delete(numQuest);
            setFlash(request, "success", "Le QCM #" + numQuest + " a été supprimé avec succès.");
        } catch (Exception ex) {
            ex.printStackTrace();
            setFlash(request, "error", "Erreur lors de la suppression du QCM.");
        }
        response.sendRedirect("qcm");
    }

    // ── Utilitaires ──────────────────────────────────────────────────────────

    private String trim(String s) { return s != null ? s.trim() : ""; }

    private boolean setQcmErrors(HttpServletRequest req,
                                  String niveau, String theme, String question,
                                  String r1, String r2, String r3, String r4, String bonneRepStr) {
        boolean err = false;
        if (niveau.isEmpty())   { req.setAttribute("erreurNiveau",    "Le niveau est obligatoire.");                                                      err = true; }
        if (theme.isEmpty())    { req.setAttribute("erreurTheme",     "Le thème est obligatoire (sélectionnez-en un ou saisissez-en un nouveau).");        err = true; }
        if (question.isEmpty()) { req.setAttribute("erreurQuestion",  "La question ne peut pas être vide.");                                               err = true; }
        if (r1.isEmpty())       { req.setAttribute("erreurR1",        "La réponse 1 est obligatoire.");                                                    err = true; }
        if (r2.isEmpty())       { req.setAttribute("erreurR2",        "La réponse 2 est obligatoire.");                                                    err = true; }
        if (r3.isEmpty())       { req.setAttribute("erreurR3",        "La réponse 3 est obligatoire.");                                                    err = true; }
        if (r4.isEmpty())       { req.setAttribute("erreurR4",        "La réponse 4 est obligatoire.");                                                    err = true; }
        if (bonneRepStr.isEmpty()) {
            req.setAttribute("erreurBonneRep", "La bonne réponse est obligatoire (chiffre entre 1 et 4).");
            err = true;
        } else {
            try {
                int val = Integer.parseInt(bonneRepStr);
                if (val < 1 || val > 4) { req.setAttribute("erreurBonneRep", "La bonne réponse doit être un chiffre entre 1 et 4."); err = true; }
            } catch (NumberFormatException e) {
                req.setAttribute("erreurBonneRep", "La bonne réponse doit être un chiffre entre 1 et 4.");
                err = true;
            }
        }
        return err;
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        request.getSession().setAttribute("flashType",    type);
        request.getSession().setAttribute("flashMessage", message);
    }
}
