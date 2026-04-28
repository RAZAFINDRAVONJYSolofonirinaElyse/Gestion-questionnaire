package util;

import java.io.InputStream;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {

    private static final Properties smtpProps = new Properties();
    private static String username;
    private static String password;
    private static String from;

    static {
        try (InputStream in = EmailService.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (in != null) {
                Properties raw = new Properties();
                raw.load(in);
                username = raw.getProperty("mail.username");
                password = raw.getProperty("mail.password");
                from     = raw.getProperty("mail.from", username);
                // Keep only javax.mail SMTP properties
                for (String key : raw.stringPropertyNames()) {
                    if (!key.equals("mail.username") && !key.equals("mail.password") && !key.equals("mail.from")) {
                        smtpProps.setProperty(key, raw.getProperty(key));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendExamResult(String to, String nomEtudiant, String numEtudiant,
                                      String theme, String anneeUniv, int note) {
        if (to == null || to.isEmpty()) return;

        Session session = Session.getInstance(smtpProps, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Résultat de votre examen — " + theme);

            String body = "Bonjour " + nomEtudiant + ",\n\n"
                + "Voici le résultat de votre examen :\n\n"
                + "  Numéro étudiant  : " + numEtudiant + "\n"
                + "  Thème            : " + theme + "\n"
                + "  Année univers.   : " + anneeUniv + "\n"
                + "  Note             : " + note + "/10\n\n"
                + "Cordialement,\nGestion Questionnaire";

            message.setText(body, "UTF-8");
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
