package servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ExamenDAO;
import dao.EtudiantDAO;
import model.Examen;
import model.Etudiant;

public class ExamenServlet extends HttpServlet {

    private ExamenDAO examenDAO;
    private EtudiantDAO etudiantDAO;

    @Override
    public void init() throws ServletException {
        examenDAO = new ExamenDAO();
        etudiantDAO = new EtudiantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listExamens(request, response);
                break;
            case "view":
                showViewForm(request, response);
                break;
            case "delete":
                deleteExamen(request, response);
                break;
            default:
                listExamens(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            deleteExamen(request, response);
        } else {
            listExamens(request, response);
        }
    }

    private void listExamens(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String theme  = request.getParameter("theme");
        String niveau = request.getParameter("niveau");
        String mode   = request.getParameter("mode");

        List<Examen> liste = "classement".equals(mode)
                ? examenDAO.getClassement(theme, niveau)
                : examenDAO.listerFiltre(theme, niveau);

        request.setAttribute("liste",        liste);
        request.setAttribute("themes",       examenDAO.listerThemes());
        request.setAttribute("niveaux",      Arrays.asList("L1", "L2", "L3", "M1", "M2"));
        request.setAttribute("themeFilter",  theme  != null ? theme  : "");
        request.setAttribute("niveauFilter", niveau != null ? niveau : "");
        request.setAttribute("mode",         mode   != null ? mode   : "liste");

        request.getRequestDispatcher("/examen/liste.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numExam = Integer.parseInt(request.getParameter("id"));
        Examen examen = examenDAO.getById(numExam);
        if (examen == null) {
            listExamens(request, response);
            return;
        }
        Etudiant etudiant = null;
        try {
            etudiant = etudiantDAO.getById(examen.getNumEtudiant());
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("examen", examen);
        request.setAttribute("etudiant", etudiant);
        request.getRequestDispatcher("/examen/voir.jsp").forward(request, response);
    }

    private void deleteExamen(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            examenDAO.delete(id);
            setFlash(request, "success", "L'examen #" + id + " a été supprimé avec succès.");
        } catch (Exception ex) {
            ex.printStackTrace();
            setFlash(request, "error", "Erreur lors de la suppression de l'examen.");
        }
        response.sendRedirect("examen");
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        request.getSession().setAttribute("flashType",    type);
        request.getSession().setAttribute("flashMessage", message);
    }
}
