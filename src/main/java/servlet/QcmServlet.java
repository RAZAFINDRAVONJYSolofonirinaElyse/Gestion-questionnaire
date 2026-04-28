package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listQcms(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "view":
                showDetails(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteQcm(request, response);
                break;
            default:
                listQcms(request, response);
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
            case "insert":
                insertQcm(request, response);
                break;
            case "update":
                updateQcm(request, response);
                break;
            case "delete":
                deleteQcm(request, response);
                break;
            default:
                listQcms(request, response);
                break;
        }
    }

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
        int total = tous.size();
        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / PAGE_SIZE);
        if (page > totalPages) page = totalPages;
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex   = Math.min(fromIndex + PAGE_SIZE, total);
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

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> niveaux = qcmDAO.obtenirNiveaux();
        Set<String> themes = qcmDAO.obtenirThemes();
        request.setAttribute("niveaux", niveaux);
        request.setAttribute("themes", themes);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/qcm/ajouter.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        Qcm qcm = qcmDAO.getById(numQuest);
        List<String> niveaux = qcmDAO.obtenirNiveaux();
        Set<String> themes = qcmDAO.obtenirThemes();
        request.setAttribute("qcm", qcm);
        request.setAttribute("niveaux", niveaux);
        request.setAttribute("themes", themes);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/qcm/modifier.jsp");
        dispatcher.forward(request, response);
    }

    private void insertQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String question = request.getParameter("question");
        String reponse1 = request.getParameter("reponse1");
        String reponse2 = request.getParameter("reponse2");
        String reponse3 = request.getParameter("reponse3");
        String reponse4 = request.getParameter("reponse4");
        int bonneReponse = Integer.parseInt(request.getParameter("bonneReponse"));
        String theme = request.getParameter("theme");
        String themeNew = request.getParameter("themeNew");
        String niveau = request.getParameter("niveau");
        
        // Si un nouveau thème est saisi, l'utiliser; sinon utiliser le thème du select
        if (themeNew != null && !themeNew.trim().isEmpty()) {
            theme = themeNew.trim();
        }

        Qcm qcm = new Qcm();
        qcm.setQuestion(question);
        qcm.setReponse1(reponse1);
        qcm.setReponse2(reponse2);
        qcm.setReponse3(reponse3);
        qcm.setReponse4(reponse4);
        qcm.setBonneReponse(bonneReponse);
        qcm.setTheme(theme);
        qcm.setNiveau(niveau);

        qcmDAO.ajouter(qcm);
        response.sendRedirect("qcm");
    }

    private void updateQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        String question = request.getParameter("question");
        String reponse1 = request.getParameter("reponse1");
        String reponse2 = request.getParameter("reponse2");
        String reponse3 = request.getParameter("reponse3");
        String reponse4 = request.getParameter("reponse4");
        int bonneReponse = Integer.parseInt(request.getParameter("bonneReponse"));
        String theme = request.getParameter("theme");
        String themeNew = request.getParameter("themeNew");
        String niveau = request.getParameter("niveau");
        
        // Si un nouveau thème est saisi, l'utiliser; sinon utiliser le thème du select
        if (themeNew != null && !themeNew.trim().isEmpty()) {
            theme = themeNew.trim();
        }

        Qcm qcm = new Qcm();
        qcm.setNumQuest(numQuest);
        qcm.setQuestion(question);
        qcm.setReponse1(reponse1);
        qcm.setReponse2(reponse2);
        qcm.setReponse3(reponse3);
        qcm.setReponse4(reponse4);
        qcm.setBonneReponse(bonneReponse);
        qcm.setTheme(theme);
        qcm.setNiveau(niveau);

        qcmDAO.update(qcm);
        response.sendRedirect("qcm");
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        Qcm qcm = qcmDAO.getById(numQuest);
        request.setAttribute("qcm", qcm);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/qcm/details.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteQcm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        qcmDAO.delete(numQuest);
        response.sendRedirect("qcm");
    }
}
