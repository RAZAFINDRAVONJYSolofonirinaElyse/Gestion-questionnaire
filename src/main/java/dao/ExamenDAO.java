package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Examen;
import util.DBConnection;


public class ExamenDAO {

    public List<Examen> lister() {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT num_exam, num_etudiant, annee_univ, note, theme FROM examen ORDER BY num_exam";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Examen examen = new Examen();
                examen.setNumExam(rs.getInt("num_exam"));
                examen.setNumEtudiant(rs.getString("num_etudiant"));
                examen.setAnneeUniv(rs.getString("annee_univ"));
                examen.setNote(rs.getInt("note"));
                examen.setTheme(rs.getString("theme"));
                examens.add(examen);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return examens;
    }

    public Examen getById(int id) {
        Examen examen = null;
        String sql = "SELECT num_exam, num_etudiant, annee_univ, note, theme FROM examen WHERE num_exam = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    examen = new Examen();
                    examen.setNumExam(rs.getInt("num_exam"));
                    examen.setNumEtudiant(rs.getString("num_etudiant"));
                    examen.setAnneeUniv(rs.getString("annee_univ"));
                    examen.setNote(rs.getInt("note"));
                    examen.setTheme(rs.getString("theme"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return examen;
    }

    public void ajouter(Examen examen) {
        String sql = "INSERT INTO examen (num_etudiant, annee_univ, note) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, examen.getNumEtudiant());
            stmt.setString(2, examen.getAnneeUniv());
            stmt.setInt(3, examen.getNote());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Examen examen) {
        String sql = "UPDATE examen SET num_etudiant = ?, annee_univ = ?, note = ? WHERE num_exam = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, examen.getNumEtudiant());
            stmt.setString(2, examen.getAnneeUniv());
            stmt.setInt(3, examen.getNote());
            stmt.setInt(4, examen.getNumExam());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Examen getByEtudiantTheme(String numEtudiant, String theme) {
        String sql = "SELECT num_exam, num_etudiant, annee_univ, note, theme FROM examen WHERE num_etudiant = ? AND theme = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numEtudiant);
            stmt.setString(2, theme);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Examen e = new Examen();
                    e.setNumExam(rs.getInt("num_exam"));
                    e.setNumEtudiant(rs.getString("num_etudiant"));
                    e.setAnneeUniv(rs.getString("annee_univ"));
                    e.setNote(rs.getInt("note"));
                    e.setTheme(rs.getString("theme"));
                    return e;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<String> listerThemes() {
        List<String> themes = new ArrayList<>();
        String sql = "SELECT DISTINCT theme FROM examen WHERE theme IS NOT NULL ORDER BY theme";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) themes.add(rs.getString("theme"));
        } catch (SQLException e) { e.printStackTrace(); }
        return themes;
    }

    private List<Examen> listerJoin(String theme, String niveau, boolean classement) {
        List<Examen> examens = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ex.num_exam, ex.num_etudiant, ex.annee_univ, ex.note, ex.theme, " +
            "et.nom, et.prenoms, et.niveau " +
            "FROM examen ex LEFT JOIN etudiant et ON ex.num_etudiant = et.num_etudiant WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        if (theme != null && !theme.isEmpty()) {
            sql.append(" AND ex.theme = ?");
            params.add(theme);
        }
        if (niveau != null && !niveau.isEmpty()) {
            sql.append(" AND et.niveau = ?");
            params.add(niveau);
        }
        sql.append(classement ? " ORDER BY ex.note DESC, et.nom" : " ORDER BY ex.num_exam");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) stmt.setObject(i + 1, params.get(i));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Examen e = new Examen();
                    e.setNumExam(rs.getInt("num_exam"));
                    e.setNumEtudiant(rs.getString("num_etudiant"));
                    e.setAnneeUniv(rs.getString("annee_univ"));
                    e.setNote(rs.getInt("note"));
                    e.setTheme(rs.getString("theme"));
                    e.setNomEtudiant(rs.getString("nom"));
                    e.setPrenomsEtudiant(rs.getString("prenoms"));
                    e.setNiveauEtudiant(rs.getString("niveau"));
                    examens.add(e);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return examens;
    }

    public List<Examen> listerFiltre(String theme, String niveau) {
        return listerJoin(theme, niveau, false);
    }

    public List<Examen> getClassement(String theme, String niveau) {
        return listerJoin(theme, niveau, true);
    }

    public void delete(int id) {
        String sqlDeleteReponses = "DELETE FROM reponse_session WHERE num_session IN (SELECT num_session FROM session_examen WHERE num_exam = ?)";
        String sqlNullifySession = "UPDATE session_examen SET num_exam = NULL WHERE num_exam = ?";
        String sqlDeleteExamen = "DELETE FROM examen WHERE num_exam = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(sqlDeleteReponses)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                try (PreparedStatement stmt = conn.prepareStatement(sqlNullifySession)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                try (PreparedStatement stmt = conn.prepareStatement(sqlDeleteExamen)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
