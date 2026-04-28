package dao;

import model.Etudiant;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EtudiantDAO {
    
    public void ajouterEtudiant(Etudiant etudiant){
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO etudiant  VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, etudiant.getNumEtudiant());
            stmt.setString(2, etudiant.getNom());
            stmt.setString(3, etudiant.getPrenoms());
            stmt.setString(4, etudiant.getNiveau());
            stmt.setString(5, etudiant.getAdr_email());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<Etudiant> lister() throws Exception {
        List<Etudiant> liste = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM etudiant ORDER BY num_etudiant");

        while (rs.next()) {
            Etudiant e = new Etudiant(
                rs.getString("num_etudiant"),
                rs.getString("nom"),
                rs.getString("prenoms"),
                rs.getString("niveau"),
                rs.getString("adr_email")
            );
            liste.add(e);
        }
        conn.close();
        return liste;
    }


    public Etudiant getById(String num) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT * FROM etudiant WHERE num_etudiant=?"
        );
        ps.setString(1, num);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return new Etudiant(
                rs.getString("num_etudiant"),
                rs.getString("nom"),
                rs.getString("prenoms"),
                rs.getString("niveau"),
                rs.getString("adr_email")
            );
        }
        return null;
    }


    public void update(Etudiant e) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE etudiant SET nom=?, prenoms=?, niveau=?, adr_email=? WHERE num_etudiant=?"
        );

        ps.setString(1, e.getNom());
        ps.setString(2, e.getPrenoms());
        ps.setString(3, e.getNiveau());
        ps.setString(4, e.getAdr_email());
        ps.setString(5, e.getNumEtudiant());

        ps.executeUpdate();
        conn.close();
    }

    public void delete(String num) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "DELETE FROM etudiant WHERE num_etudiant=?"
        );
        ps.setString(1, num);
        ps.executeUpdate();
        conn.close();
    }

    public List<Etudiant> searchByNumOrName(String searchTerm) throws Exception {
        List<Etudiant> liste = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM etudiant WHERE num_etudiant LIKE ? OR nom LIKE ? OR prenoms LIKE ? ORDER BY num_etudiant";
        PreparedStatement ps = conn.prepareStatement(sql);
        String searchPattern = "%" + searchTerm + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        ps.setString(3, searchPattern);
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Etudiant e = new Etudiant(
                rs.getString("num_etudiant"),
                rs.getString("nom"),
                rs.getString("prenoms"),
                rs.getString("niveau"),
                rs.getString("adr_email")
            );
            liste.add(e);
        }
        conn.close();
        return liste;
    }

    public List<Etudiant> listerByNiveauSorted() throws Exception {
        List<Etudiant> liste = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT e.*, COALESCE(AVG(se.note), 0) as moyenne_note " +
                    "FROM etudiant e " +
                    "LEFT JOIN session_examen se ON e.num_etudiant = se.num_etudiant AND se.statut = 'TERMINEE' " +
                    "GROUP BY e.num_etudiant " +
                    "ORDER BY e.niveau, moyenne_note DESC, e.nom";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Etudiant e = new Etudiant(
                rs.getString("num_etudiant"),
                rs.getString("nom"),
                rs.getString("prenoms"),
                rs.getString("niveau"),
                rs.getString("adr_email")
            );
            liste.add(e);
        }
        conn.close();
        return liste;
    }

    public java.util.Map<String, Object> getStatsByNiveau() throws Exception {
        java.util.Map<String, Object> stats = new java.util.LinkedHashMap<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT niveau, COUNT(*) as effectif FROM etudiant GROUP BY niveau ORDER BY niveau";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            String niveau = rs.getString("niveau");
            int effectif = rs.getInt("effectif");
            stats.put(niveau, effectif);
        }
        conn.close();
        return stats;
    }
}
