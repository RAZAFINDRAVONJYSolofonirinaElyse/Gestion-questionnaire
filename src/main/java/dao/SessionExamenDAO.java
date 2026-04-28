package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SessionExamen;
import util.DBConnection;

public class SessionExamenDAO {

    // Créer une nouvelle session d'examen
    public int creerSession(String numEtudiant, String theme) {
        String sql = "INSERT INTO session_examen (num_etudiant, theme, statut) VALUES (?, ?, 'EN_COURS') RETURNING num_session";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, numEtudiant);
            stmt.setString(2, theme);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("num_session");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Récupérer 10 questions aléatoires selon le thème et le niveau
    public List<Integer> obtenirQuestionsAleatoires(String theme, String niveau) {
        List<Integer> questionIds = new ArrayList<>();
        String sql = "SELECT num_quest FROM qcm WHERE theme = ? ORDER BY RANDOM() LIMIT 10";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, theme);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    questionIds.add(rs.getInt("num_quest"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionIds;
    }

    // Enregistrer une réponse de l'étudiant
    public void enregistrerReponse(int numSession, int numQuest, int reponseEtudiant, boolean estCorrecte) {
        String sql = "INSERT INTO reponse_session (num_session, num_quest, reponse_etudiant, est_correcte) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, numSession);
            stmt.setInt(2, numQuest);
            stmt.setInt(3, reponseEtudiant);
            stmt.setBoolean(4, estCorrecte);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Calculer et sauvegarder la note finale
    public void sauvegarderNote(int numSession, String numEtudiant, String anneeUniv) {
        String sqlCount = "SELECT COUNT(*) as nb_correctes FROM reponse_session WHERE num_session = ? AND est_correcte = true";
        String sqlGetTheme = "SELECT theme FROM session_examen WHERE num_session = ?";
        String sqlInsertExamen = "INSERT INTO examen (num_etudiant, annee_univ, note, theme) VALUES (?, ?, ?, ?) RETURNING num_exam";
        String sqlUpdateSession = "UPDATE session_examen SET note = ?, statut = 'TERMINEE', num_exam = ? WHERE num_session = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int nbCorrectes = 0;
                try (PreparedStatement stmt = conn.prepareStatement(sqlCount)) {
                    stmt.setInt(1, numSession);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) nbCorrectes = rs.getInt("nb_correctes");
                    }
                }

                int totalQuestions = 10;
                String sqlTotal = "SELECT COUNT(*) as total FROM reponse_session WHERE num_session = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlTotal)) {
                    stmt.setInt(1, numSession);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) totalQuestions = Math.max(1, rs.getInt("total"));
                    }
                }

                int note = (nbCorrectes * 10) / totalQuestions;

                String theme = null;
                try (PreparedStatement stmt = conn.prepareStatement(sqlGetTheme)) {
                    stmt.setInt(1, numSession);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) theme = rs.getString("theme");
                    }
                }

                int numExam = -1;
                try (PreparedStatement stmt = conn.prepareStatement(sqlInsertExamen)) {
                    stmt.setString(1, numEtudiant);
                    stmt.setString(2, anneeUniv);
                    stmt.setInt(3, note);
                    stmt.setString(4, theme);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) numExam = rs.getInt("num_exam");
                    }
                }

                try (PreparedStatement stmt = conn.prepareStatement(sqlUpdateSession)) {
                    stmt.setInt(1, note);
                    stmt.setInt(2, numExam);
                    stmt.setInt(3, numSession);
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

    // Récupérer une session d'examen
    public SessionExamen getSessionById(int numSession) {
        SessionExamen session = null;
        String sql = "SELECT num_session, num_etudiant, theme, date_session, statut, note FROM session_examen WHERE num_session = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, numSession);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    session = new SessionExamen();
                    session.setNumSession(rs.getInt("num_session"));
                    session.setNumEtudiant(rs.getString("num_etudiant"));
                    session.setTheme(rs.getString("theme"));
                    session.setDateSession(rs.getTimestamp("date_session").toLocalDateTime());
                    session.setStatut(rs.getString("statut"));
                    session.setNote(rs.getInt("note"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return session;
    }

    // Récupérer les thèmes disponibles
    public List<String> obtenirThemesDisponibles() {
        List<String> themes = new ArrayList<>();
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
}
