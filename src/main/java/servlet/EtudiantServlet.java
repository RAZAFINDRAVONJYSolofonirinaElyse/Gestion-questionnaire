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
        if (action == null) action = "list";

        switch (action) {

            // ── Vérification AJAX unicité matricule ──────────────────────────
            case "checkNum": {
                res.setContentType("application/json");
                res.setCharacterEncoding("UTF-8");
                String num = trim(req.getParameter("num"));
                try {
                    boolean exists = !num.isEmpty() && dao.existsByNum(num);
                    res.getWriter().write("{\"exists\":" + exists + "}");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    res.getWriter().write("{\"exists\":false}");
                }
                break;
            }

            // ── Formulaire ajout ─────────────────────────────────────────────
            case "new":
                req.getRequestDispatcher("etudiant/ajouter.jsp").forward(req, res);
                break;

            // ── Insérer ──────────────────────────────────────────────────────
            case "insert": {
                String num     = trim(req.getParameter("num"));
                String nom     = trim(req.getParameter("nom"));
                String prenoms = trim(req.getParameter("prenoms"));
                String niveau  = trim(req.getParameter("niveau"));
                String email   = trim(req.getParameter("email"));

                boolean hasErrors = false;

                // Matricule
                if (num.isEmpty()) {
                    req.setAttribute("erreurNum", "Le matricule est obligatoire.");
                    hasErrors = true;
                } else {
                    try {
                        if (dao.existsByNum(num)) {
                            req.setAttribute("erreurNum", "Ce matricule est déjà attribué à un autre étudiant.");
                            hasErrors = true;
                        }
                    } catch (Exception ex) { ex.printStackTrace(); }
                }

                // Nom
                if (nom.isEmpty()) {
                    req.setAttribute("erreurNom", "Le nom est obligatoire.");
                    hasErrors = true;
                } else if (!isValidName(nom)) {
                    req.setAttribute("erreurNom", "Nom invalide : lettres, espaces, tirets et apostrophes uniquement.");
                    hasErrors = true;
                }

                // Prénoms
                if (prenoms.isEmpty()) {
                    req.setAttribute("erreurPrenoms", "Les prénoms sont obligatoires.");
                    hasErrors = true;
                } else if (!isValidName(prenoms)) {
                    req.setAttribute("erreurPrenoms", "Prénoms invalides : lettres, espaces, tirets et apostrophes uniquement.");
                    hasErrors = true;
                }

                // Niveau
                if (niveau.isEmpty()) {
                    req.setAttribute("erreurNiveau", "Le niveau est obligatoire.");
                    hasErrors = true;
                }

                // Email
                if (email.isEmpty()) {
                    req.setAttribute("erreurEmail", "L'adresse email est obligatoire.");
                    hasErrors = true;
                } else if (!isValidEmail(email)) {
                    req.setAttribute("erreurEmail", "Format d'email invalide (ex : nom@domaine.fr).");
                    hasErrors = true;
                }

                if (hasErrors) {
                    req.getRequestDispatcher("etudiant/ajouter.jsp").forward(req, res);
                    return;
                }

                try {
                    dao.ajouterEtudiant(new Etudiant(num, nom, prenoms, niveau, email));
                    setFlash(req, "success", "L'étudiant " + prenoms + " " + nom + " a été ajouté avec succès.");
                    res.sendRedirect("etudiant");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    req.setAttribute("erreurNum", "Erreur lors de l'ajout : le matricule « " + num + " » existe peut-être déjà.");
                    req.getRequestDispatcher("etudiant/ajouter.jsp").forward(req, res);
                }
                break;
            }

            // ── Formulaire modification ───────────────────────────────────────
            case "edit": {
                try {
                    Etudiant et = dao.getById(req.getParameter("num"));
                    if (et == null) {
                        setFlash(req, "error", "Étudiant introuvable.");
                        res.sendRedirect("etudiant");
                        return;
                    }
                    req.setAttribute("etudiant", et);
                    req.getRequestDispatcher("etudiant/modifier.jsp").forward(req, res);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    setFlash(req, "error", "Erreur lors du chargement de l'étudiant.");
                    res.sendRedirect("etudiant");
                }
                break;
            }

            // ── Mettre à jour ─────────────────────────────────────────────────
            case "update": {
                String num     = trim(req.getParameter("num"));
                String nom     = trim(req.getParameter("nom"));
                String prenoms = trim(req.getParameter("prenoms"));
                String niveau  = trim(req.getParameter("niveau"));
                String email   = trim(req.getParameter("email"));

                boolean hasErrors = false;

                if (nom.isEmpty()) {
                    req.setAttribute("erreurNom", "Le nom est obligatoire.");
                    hasErrors = true;
                } else if (!isValidName(nom)) {
                    req.setAttribute("erreurNom", "Nom invalide : lettres, espaces, tirets et apostrophes uniquement.");
                    hasErrors = true;
                }

                if (prenoms.isEmpty()) {
                    req.setAttribute("erreurPrenoms", "Les prénoms sont obligatoires.");
                    hasErrors = true;
                } else if (!isValidName(prenoms)) {
                    req.setAttribute("erreurPrenoms", "Prénoms invalides : lettres, espaces, tirets et apostrophes uniquement.");
                    hasErrors = true;
                }

                if (niveau.isEmpty()) {
                    req.setAttribute("erreurNiveau", "Le niveau est obligatoire.");
                    hasErrors = true;
                }

                if (email.isEmpty()) {
                    req.setAttribute("erreurEmail", "L'adresse email est obligatoire.");
                    hasErrors = true;
                } else if (!isValidEmail(email)) {
                    req.setAttribute("erreurEmail", "Format d'email invalide (ex : nom@domaine.fr).");
                    hasErrors = true;
                }

                if (hasErrors) {
                    req.setAttribute("etudiant", new Etudiant(num, nom, prenoms, niveau, email));
                    req.getRequestDispatcher("etudiant/modifier.jsp").forward(req, res);
                    return;
                }

                try {
                    dao.update(new Etudiant(num, nom, prenoms, niveau, email));
                    setFlash(req, "success", "L'étudiant " + prenoms + " " + nom + " a été modifié avec succès.");
                    res.sendRedirect("etudiant");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    req.setAttribute("etudiant", new Etudiant(num, nom, prenoms, niveau, email));
                    req.setAttribute("erreurNom", "Erreur lors de la modification de l'étudiant.");
                    req.getRequestDispatcher("etudiant/modifier.jsp").forward(req, res);
                }
                break;
            }

            // ── Supprimer ─────────────────────────────────────────────────────
            case "delete": {
                String num = req.getParameter("num");
                try {
                    Etudiant eDel = dao.getById(num);
                    String nomDel = (eDel != null) ? eDel.getPrenoms() + " " + eDel.getNom() : num;
                    dao.delete(num);
                    setFlash(req, "success", "L'étudiant " + nomDel + " a été supprimé avec succès.");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    setFlash(req, "error", "Erreur lors de la suppression de l'étudiant.");
                }
                res.sendRedirect("etudiant");
                break;
            }

            // ── Liste ─────────────────────────────────────────────────────────
            default: {
                try {
                    String searchTerm   = req.getParameter("search");
                    String niveauFilter = req.getParameter("niveau");

                    req.setAttribute("stats", dao.getStatsByNiveau());

                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        req.setAttribute("liste",  dao.searchByNumOrName(searchTerm));
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

                        int total      = filtre.size();
                        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / PAGE_SIZE);
                        if (page > totalPages) page = totalPages;
                        int fromIndex  = (page - 1) * PAGE_SIZE;
                        int toIndex    = Math.min(fromIndex + PAGE_SIZE, total);
                        List<Etudiant> pageListe = (fromIndex < total)
                            ? filtre.subList(fromIndex, toIndex)
                            : new ArrayList<>();

                        req.setAttribute("liste",        pageListe);
                        req.setAttribute("niveauFilter", niveauFilter != null ? niveauFilter : "");
                        req.setAttribute("currentPage",  page);
                        req.setAttribute("totalPages",   totalPages);
                        req.setAttribute("totalCount",   total);
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                    setFlash(req, "error", "Erreur lors du chargement de la liste des étudiants.");
                }
                req.getRequestDispatcher("etudiant/liste.jsp").forward(req, res);
                break;
            }
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        doGet(req, res);
    }

    // ── Utilitaires ───────────────────────────────────────────────────────────

    private String trim(String s) { return s != null ? s.trim() : ""; }

    private boolean isValidName(String name) {
        return name.matches("[\\p{L}\\s\\-']+");
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }

    private void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flashType",    type);
        req.getSession().setAttribute("flashMessage", message);
    }
}
