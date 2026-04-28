package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Qcm;
import util.DBConnection;

public class QcmDAO {

    public List<Qcm> listerFiltre(String theme, String niveau) {
        List<Qcm> qcms = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT num_quest, question, reponse1, reponse2, reponse3, reponse4, bonne_reponse, theme, niveau FROM qcm WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        if (theme != null && !theme.isEmpty()) { sql.append(" AND theme = ?"); params.add(theme); }
        if (niveau != null && !niveau.isEmpty()) { sql.append(" AND niveau = ?"); params.add(niveau); }
        sql.append(" ORDER BY num_quest");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) stmt.setObject(i + 1, params.get(i));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Qcm qcm = mapRow(rs);
                    qcms.add(qcm);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return qcms;
    }

    private Qcm mapRow(ResultSet rs) throws SQLException {
        Qcm qcm = new Qcm();
        qcm.setNumQuest(rs.getInt("num_quest"));
        qcm.setQuestion(rs.getString("question"));
        qcm.setReponse1(rs.getString("reponse1"));
        qcm.setReponse2(rs.getString("reponse2"));
        qcm.setReponse3(rs.getString("reponse3"));
        qcm.setReponse4(rs.getString("reponse4"));
        qcm.setBonneReponse(rs.getInt("bonne_reponse"));
        qcm.setTheme(rs.getString("theme"));
        qcm.setNiveau(rs.getString("niveau"));
        return qcm;
    }

    public List<Qcm> lister() {
        return listerFiltre(null, null);
    }

    public Qcm getById(int numQuest) {
        Qcm qcm = null;
        String sql = "SELECT num_quest, question, reponse1, reponse2, reponse3, reponse4, bonne_reponse, theme, niveau FROM qcm WHERE num_quest = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, numQuest);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) qcm = mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return qcm;
    }

    public void ajouter(Qcm qcm) {
        String sql = "INSERT INTO qcm (question, reponse1, reponse2, reponse3, reponse4, bonne_reponse, theme, niveau) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, qcm.getQuestion());
            stmt.setString(2, qcm.getReponse1());
            stmt.setString(3, qcm.getReponse2());
            stmt.setString(4, qcm.getReponse3());
            stmt.setString(5, qcm.getReponse4());
            stmt.setInt(6, qcm.getBonneReponse());
            stmt.setString(7, qcm.getTheme());
            stmt.setString(8, qcm.getNiveau());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Qcm qcm) {
        String sql = "UPDATE qcm SET question = ?, reponse1 = ?, reponse2 = ?, reponse3 = ?, reponse4 = ?, bonne_reponse = ?, theme = ?, niveau = ? WHERE num_quest = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, qcm.getQuestion());
            stmt.setString(2, qcm.getReponse1());
            stmt.setString(3, qcm.getReponse2());
            stmt.setString(4, qcm.getReponse3());
            stmt.setString(5, qcm.getReponse4());
            stmt.setInt(6, qcm.getBonneReponse());
            stmt.setString(7, qcm.getTheme());
            stmt.setString(8, qcm.getNiveau());
            stmt.setInt(9, qcm.getNumQuest());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int numQuest) {
        String sql = "DELETE FROM qcm WHERE num_quest = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, numQuest);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Récupère la liste des thèmes uniques présents dans la base de données
     */
    public List<String> obtenirThemesByNiveau(String niveau) {
        List<String> themes = new ArrayList<>();
        String sql = "SELECT DISTINCT theme FROM qcm WHERE niveau = ? AND theme IS NOT NULL ORDER BY theme";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, niveau);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) themes.add(rs.getString("theme"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return themes;
    }

    public Set<String> obtenirThemes() {
        Set<String> themes = new HashSet<>();
        String sql = "SELECT DISTINCT theme FROM qcm WHERE theme IS NOT NULL ORDER BY theme";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                themes.add(rs.getString("theme"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return themes;
    }

    /**
     * Récupère la liste des niveaux prédéfinis (L1, L2, L3, M1, M2)
     */
    public List<String> obtenirNiveaux() {
        List<String> niveaux = new ArrayList<>();
        niveaux.add("L1");
        niveaux.add("L2");
        niveaux.add("L3");
        niveaux.add("M1");
        niveaux.add("M2");
        return niveaux;
    }

    /**
     * Vérifie si un thème existe dans la base de données
     */
    public boolean themeExiste(String theme) {
        String sql = "SELECT COUNT(*) as count FROM qcm WHERE theme = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, theme);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
