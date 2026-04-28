# Implémentation du Système d'Examen Interactif

## Vue d'ensemble

Ce document décrit les modifications apportées à l'application de gestion des questionnaires pour implémenter un système complet d'examen interactif permettant aux étudiants de passer des examens avec sélection aléatoire de questions.

## Architecture de la Solution

### 1. Modifications de la Base de Données

#### Fichier: `migration_database.sql`

Nouvelles tables créées :

**Table `session_examen`**
- `num_session` : Identifiant unique de la session (SERIAL PRIMARY KEY)
- `num_etudiant` : Référence à l'étudiant (FK vers `etudiant`)
- `theme` : Thème de l'examen
- `date_session` : Timestamp de création
- `statut` : État de la session (EN_COURS, TERMINEE, ABANDONNEE)
- `note` : Note finale (null jusqu'à la fin de l'examen)

**Table `reponse_session`**
- `num_reponse` : Identifiant unique
- `num_session` : Référence à la session (FK vers `session_examen`)
- `num_quest` : Référence à la question (FK vers `qcm`)
- `reponse_etudiant` : Réponse sélectionnée (1-4)
- `est_correcte` : Boolean indiquant si la réponse est correcte

**Modification de la table `examen`**
- Ajout de la colonne `theme` pour conserver le thème de l'examen

### 2. Modèles Java Créés

#### `SessionExamen.java`
Représente une session d'examen avec :
- Les informations de session (numéro, étudiant, thème)
- La date et l'heure de création
- Le statut et la note finale
- Getters/setters complets

#### `ReponsesSession.java`
Représente une réponse de l'étudiant avec :
- Le lien vers la session et la question
- La réponse sélectionnée
- Un booléen indiquant si c'est correct

### 3. DAO Créé

#### `SessionExamenDAO.java`

Méthodes principales :

| Méthode | Description |
|---------|-------------|
| `creerSession()` | Crée une nouvelle session d'examen pour un étudiant |
| `obtenirQuestionsAleatoires()` | Sélectionne 10 questions aléatoires selon le thème et le niveau |
| `enregistrerReponse()` | Enregistre la réponse de l'étudiant |
| `sauvegarderNote()` | Calcule la note (sur 20) et la sauvegarde |
| `getSessionById()` | Récupère les détails d'une session |
| `obtenirThemesDisponibles()` | Retourne la liste des thèmes disponibles |

**Logique de calcul de la note :**
```
Note = (Nombre de réponses correctes / 10) × 20
```

### 4. Servlet Créée

#### `SessionExamenServlet.java`

Actions supportées :

| Action | Méthode | Description |
|--------|---------|-------------|
| `demarrer` | GET | Affiche le formulaire de démarrage |
| `commencer` | GET | Crée une session et redirige vers la première question |
| `question` | GET | Affiche la question courante |
| `soumettreReponse` | POST | Enregistre la réponse et passe à la question suivante |
| `terminerExamen` | - | Calcule la note et affiche le résultat |

**Flux de l'application :**
1. L'étudiant entre son numéro et sélectionne un thème
2. La servlet crée une session d'examen
3. 10 questions aléatoires sont sélectionnées selon le thème et le niveau de l'étudiant
4. Les questions sont posées une par une
5. Chaque réponse est enregistrée dans la base de données
6. À la fin, la note est calculée et affichée

### 5. Pages JSP Créées

#### `demarrer.jsp`
- Formulaire pour saisir le numéro d'étudiant
- Liste déroulante des thèmes disponibles
- Instructions d'utilisation
- Gestion des erreurs

#### `question.jsp`
- Affiche la question courante
- Barre de progression du questionnaire
- Affiche les 4 options de réponse sous forme de radio buttons
- Informations sur le thème et le niveau
- Bouton pour soumettre la réponse

#### `resultat.jsp`
- Affiche la note finale sur 20
- Couleur selon le résultat (rouge < 10, orange 10-15, vert ≥ 15)
- Message de feedback approprié
- Boutons pour recommencer ou consulter l'historique

#### `index.jsp` (Modifié)
- Page d'accueil avec un menu principal
- Accès à : Gestion des étudiants, QCM, Examens, Passer un examen

### 6. Configuration Web

#### `web.xml` (Modifié)

Ajout de la mapping pour la nouvelle servlet :
```xml
<servlet>
    <servlet-name>SessionExamenServlet</servlet-name>
    <servlet-class>servlet.SessionExamenServlet</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>SessionExamenServlet</servlet-name>
    <url-pattern>/SessionExamen</url-pattern>
</servlet-mapping>
```

## Flux d'Utilisation Complet

### Scénario : Un étudiant passe un examen

1. **Démarrage** : L'étudiant accède à `/SessionExamen?action=demarrer`
   - Remplit le formulaire avec :
     - Numéro d'étudiant (ex: E001)
     - Thème choisi (ex: Mathématiques)

2. **Création de session** : La servlet crée une session d'examen
   - Récupère le niveau de l'étudiant (ex: L1)
   - Sélectionne 10 questions aléatoires où `theme = 'Mathématiques' AND niveau = 'L1'`

3. **Présentation des questions** : Chaque question s'affiche avec :
   - La question texte
   - 4 réponses possibles
   - Barre de progression (ex: 3/10)

4. **Enregistrement des réponses** : Pour chaque réponse :
   - La réponse est comparée avec la bonne réponse
   - Le résultat (correct/incorrect) est enregistré dans `reponse_session`

5. **Calcul et affichage de la note** :
   - Nombre de réponses correctes × 20 / 10
   - Affichage du résultat avec feedback
   - Enregistrement dans `session_examen` et `examen`

## Données Techniques

### Session HTTP
```
numSession : int
numEtudiant : String
theme : String
questionIds : List<Integer>
questionActuelle : int
```

### Base de données
```
SELECT COUNT(*) FROM reponse_session 
WHERE num_session = ? AND est_correcte = true

INSERT INTO examen (num_etudiant, annee_univ, note, theme)
VALUES (?, ?, ?, ?)
```

## Points Importants

✅ **Fonctionnalités implémentées :**
- Sélection aléatoire de 10 questions
- Prise en compte du thème ET du niveau de l'étudiant
- Validation des réponses en temps réel
- Calcul automatique de la note
- Sauvegarde dans la base de données
- Interface utilisateur intuitive avec progression

✅ **Sécurité :**
- Validation de l'existence de l'étudiant
- Vérification du nombre de questions disponibles
- Enregistrement de toutes les réponses

✅ **Performance :**
- Utilisation de `ORDER BY RANDOM() LIMIT 10` pour la sélection aléatoire
- Requêtes SQL optimisées
- Connexions à la base de données fermées correctement

## Installation

1. Exécuter le script `migration_database.sql` sur la base de données PostgreSQL
2. Redéployer l'application (WAR compilé généré)
3. Accéder à l'application et cliquer sur "Passer un Examen"

## Exemple de Données Test

```sql
-- Ajouter un étudiant
INSERT INTO etudiant VALUES ('E001', 'Dupont', 'Jean', 'L1', 'jean.dupont@example.com');

-- Ajouter des questions (thème: Mathématiques, niveau: L1)
INSERT INTO qcm (question, reponse1, reponse2, reponse3, reponse4, bonne_reponse, theme, niveau)
VALUES ('Quel est 2+2?', '3', '4', '5', '6', 2, 'Mathématiques', 'L1');
```

## Fichiers Modifiés/Créés

**Créés :**
- `src/main/java/model/SessionExamen.java`
- `src/main/java/model/ReponsesSession.java`
- `src/main/java/dao/SessionExamenDAO.java`
- `src/main/java/servlet/SessionExamenServlet.java`
- `src/main/webapp/examen/demarrer.jsp`
- `src/main/webapp/examen/question.jsp`
- `src/main/webapp/examen/resultat.jsp`

**Modifiés :**
- `migration_database.sql` (ajout des tables)
- `src/main/webapp/WEB-INF/web.xml` (mapping servlet)
- `src/main/webapp/index.jsp` (accueil)
