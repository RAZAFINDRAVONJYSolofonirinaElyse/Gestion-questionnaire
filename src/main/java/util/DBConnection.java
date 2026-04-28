package util;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection(){
        Connection conn = null;
        try{
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/gestion_qcm", "postgres", "root");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
