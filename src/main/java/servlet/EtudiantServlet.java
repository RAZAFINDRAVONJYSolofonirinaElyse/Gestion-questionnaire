package servlet;

import dao.EtudiantDAO;
import model.Etudiant;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class EtudiantServlet extends HttpServlet {

    private EtudiantDAO dao = new EtudiantDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if (action == null) action = "list";

            switch (action) {
                case "new":
                    req.getRequestDispatcher("etudiant/ajouter.jsp").forward(req, res);
                    break;

                case "insert":
                    Etudiant e = new Etudiant(
                        req.getParameter("num"),
                        req.getParameter("nom"),
                        req.getParameter("prenoms"),
                        req.getParameter("niveau"),
                        req.getParameter("email")
                    );
                    dao.ajouterEtudiant(e);
                    res.sendRedirect("etudiant");
                    break;

                case "edit":
                    Etudiant et = dao.getById(req.getParameter("num"));
                    req.setAttribute("etudiant", et);
                    req.getRequestDispatcher("etudiant/modifier.jsp").forward(req, res);
                    break;

                case "update":
                    Etudiant e2 = new Etudiant(
                        req.getParameter("num"),
                        req.getParameter("nom"),
                        req.getParameter("prenoms"),
                        req.getParameter("niveau"),
                        req.getParameter("email")
                    );
                    dao.update(e2);
                    res.sendRedirect("etudiant");
                    break;

                case "delete":
                    dao.delete(req.getParameter("num"));
                    res.sendRedirect("etudiant");
                    break;

                default:
                    String searchTerm = req.getParameter("search");
                    String niveauFilter = req.getParameter("niveau");

                    req.setAttribute("stats", dao.getStatsByNiveau());

                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        req.setAttribute("liste", dao.searchByNumOrName(searchTerm));
                        req.setAttribute("search", searchTerm);
                    } else {
                        final int PAGE_SIZE = 8;
                        int page = 1;
                        String pageParam = req.getParameter("page");
                        if (pageParam != null) {
                            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
                            if (page < 1) page = 1;
                        }

                        List<Etudiant> tous = dao.lister();
                        List<Etudiant> filtre = new ArrayList<>();
                        for (Etudiant a : tous) {
                            if (niveauFilter == null || niveauFilter.isEmpty() || niveauFilter.equals(a.getNiveau())) {
                                filtre.add(a);
                            }
                        }

                        int total = filtre.size();
                        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / PAGE_SIZE);
                        if (page > totalPages) page = totalPages;
                        int fromIndex = (page - 1) * PAGE_SIZE;
                        int toIndex = Math.min(fromIndex + PAGE_SIZE, total);
                        List<Etudiant> pageListe = (fromIndex < total)
                            ? filtre.subList(fromIndex, toIndex)
                            : new ArrayList<>();

                        req.setAttribute("liste",       pageListe);
                        req.setAttribute("niveauFilter", niveauFilter != null ? niveauFilter : "");
                        req.setAttribute("currentPage",  page);
                        req.setAttribute("totalPages",   totalPages);
                        req.setAttribute("totalCount",   total);
                    }
                    req.getRequestDispatcher("etudiant/liste.jsp").forward(req, res);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        doGet(req, res);
    }
}