<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediPlan - Système de Gestion de Clinique</title>
    <style>
        /* Variables CSS */
        :root {
            --primary: #2c7fb8;
            --primary-dark: #1d5a82;
            --secondary: #7fcdbb;
            --accent: #edf8b1;
            --light: #f7f7f7;
            --dark: #333;
            --success: #2ca25f;
            --warning: #fec44f;
            --danger: #e34a33;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        /* Reset et styles de base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: var(--light);
        }

        /* Header et Navigation */
        header {
            background-color: white;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 5%;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            color: var(--primary);
            font-size: 1.8rem;
        }

        .logo-text {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .auth-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-outline {
            border: 2px solid var(--primary);
            color: var(--primary);
            background: transparent;
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: 2px solid var(--primary);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        /* Section Hero */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 5rem 5%;
            text-align: center;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 2.8rem;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        /* Section Présentation */
        .presentation {
            padding: 5rem 5%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title h2 {
            font-size: 2.2rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .section-title p {
            color: #666;
            max-width: 700px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 4rem;
        }

        .feature-card {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }

        .feature-card h3 {
            font-size: 1.4rem;
            margin-bottom: 1rem;
            color: var(--primary-dark);
        }

        /* Section Fonctionnalités */
        .functionality {
            background-color: #f0f8ff;
            padding: 5rem 5%;
        }

        .functionality-content {
            max-width: 1200px;
            margin: 0 auto;
        }

        .functionality-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .functionality-item {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .functionality-item i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        /* Section Rôles */
        .roles {
            padding: 5rem 5%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .roles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .role-card {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: var(--shadow);
            text-align: center;
            border-top: 4px solid var(--primary);
        }

        .role-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }

        .role-card h3 {
            font-size: 1.4rem;
            margin-bottom: 1rem;
            color: var(--primary-dark);
        }

        .role-card ul {
            text-align: left;
            margin-top: 1rem;
        }

        .role-card li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
        }

        .role-card li:before {
            content: "•";
            color: var(--primary);
            position: absolute;
            left: 0;
        }

        /* Section CTA */
        .cta {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            color: white;
            padding: 4rem 5%;
            text-align: center;
        }

        .cta-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .cta h2 {
            font-size: 2.2rem;
            margin-bottom: 1.5rem;
        }

        .cta p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-light {
            background-color: white;
            color: var(--primary);
            border: 2px solid white;
        }

        .btn-light:hover {
            background-color: transparent;
            color: white;
        }

        /* Footer */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 3rem 5% 1.5rem;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-column h3 {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            color: var(--secondary);
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column li {
            margin-bottom: 0.8rem;
        }

        .footer-column a {
            color: #ccc;
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-column a:hover {
            color: white;
        }

        .copyright {
            text-align: center;
            padding-top: 1.5rem;
            border-top: 1px solid #444;
            color: #aaa;
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-links {
                gap: 1rem;
            }

            .auth-buttons {
                width: 100%;
                justify-content: center;
            }

            .hero h1 {
                font-size: 2.2rem;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 250px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Header avec Navigation -->
<header>
    <nav class="navbar">
        <div class="logo">
            <i class="fas fa-hospital-alt logo-icon"></i>
            <span class="logo-text">MediPlan</span>
        </div>
        <div class="nav-links">
            <a href="#presentation">Présentation</a>
            <a href="#fonctionnalites">Fonctionnalités</a>
            <a href="#roles">Rôles</a>
        </div>
        <div class="auth-buttons">
            <a href="login" class="btn btn-outline">Login</a>
            <a href="register" class="btn btn-primary">Registre</a>
        </div>
    </nav>
</header>

<!-- Section Hero -->
<section class="hero">
    <div class="hero-content">
        <h1>Système de Gestion de Clinique MediPlan</h1>
        <p>Automatisez la planification, assurez le suivi médical et garantissez la traçabilité complète des opérations de votre clinique.</p>
        <div class="auth-buttons">
            <a href="#" class="btn btn-light">S'inscrire</a>
            <a href="#" class="btn btn-outline" style="border-color: white; color: white;">Se connecter</a>
        </div>
    </div>
</section>

<!-- Section Présentation -->
<section class="presentation" id="presentation">
    <div class="section-title">
        <h2>Notre Solution Complète</h2>
        <p>Développée avec les technologies Java EE modernes pour une gestion optimale de votre clinique</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <i class="fas fa-laptop-code feature-icon"></i>
            <h3>Architecture Moderne</h3>
            <p>Solution basée sur JPA/Hibernate, Servlets, JSP/JSTL et Maven, déployée sur Tomcat, GlassFish ou WildFly.</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-users-cog feature-icon"></i>
            <h3>Gestion Multi-Rôles</h3>
            <p>Interface adaptée pour les administrateurs, médecins, patients et personnel administratif.</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-calendar-check feature-icon"></i>
            <h3>Planification Intelligente</h3>
            <p>Générez automatiquement des créneaux sans chevauchement selon les disponibilités des médecins.</p>
        </div>
    </div>
</section>

<!-- Section Fonctionnalités -->
<section class="functionality" id="fonctionnalites">
    <div class="functionality-content">
        <div class="section-title">
            <h2>Fonctionnalités Principales</h2>
            <p>Découvrez les capacités complètes de notre système de gestion</p>
        </div>
        <div class="functionality-grid">
            <div class="functionality-item">
                <i class="fas fa-user-plus"></i>
                <h4>Inscription & Profil</h4>
                <p>Email unique, mot de passe sécurisé, rôle, mise à jour du profil</p>
            </div>
            <div class="functionality-item">
                <i class="fas fa-user-injured"></i>
                <h4>Gestion des Patients</h4>
                <p>Création, mise à jour, désactivation logique, historique des rendez-vous</p>
            </div>
            <div class="functionality-item">
                <i class="fas fa-user-md"></i>
                <h4>Gestion des Médecins</h4>
                <p>Matricule unique, titre, spécialité, département, disponibilités</p>
            </div>
            <div class="functionality-item">
                <i class="fas fa-calendar-alt"></i>
                <h4>Gestion des Rendez-vous</h4>
                <p>Planification automatique, statuts, historique, annulation limitée</p>
            </div>
            <div class="functionality-item">
                <i class="fas fa-stethoscope"></i>
                <h4>Notes Médicales</h4>
                <p>Création pour rendez-vous terminés, figées après validation</p>
            </div>
            <div class="functionality-item">
                <i class="fas fa-chart-bar"></i>
                <h4>Tableaux de Bord</h4>
                <p>Statistiques, taux d'occupation, annulations, supervision</p>
            </div>
        </div>
    </div>
</section>

<!-- Section Rôles -->
<section class="roles" id="roles">
    <div class="section-title">
        <h2>Rôles et Permissions</h2>
        <p>Interface adaptée à chaque type d'utilisateur</p>
    </div>
    <div class="roles-grid">
        <div class="role-card">
            <i class="fas fa-user-shield role-icon"></i>
            <h3>Administrateur</h3>
            <ul>
                <li>Gestion de tous les comptes</li>
                <li>Configuration des spécialités et départements</li>
                <li>Supervision des plannings et statistiques</li>
                <li>Paramètres globaux de la clinique</li>
            </ul>
        </div>
        <div class="role-card">
            <i class="fas fa-user-md role-icon"></i>
            <h3>Médecin</h3>
            <ul>
                <li>Définition des disponibilités</li>
                <li>Gestion de l'agenda quotidien/hebdomadaire</li>
                <li>Validation des rendez-vous</li>
                <li>Rédaction des notes médicales</li>
            </ul>
        </div>
        <div class="role-card">
            <i class="fas fa-user-injured role-icon"></i>
            <h3>Patient</h3>
            <ul>
                <li>Création et mise à jour du profil</li>
                <li>Recherche de médecins par spécialité</li>
                <li>Prise de rendez-vous en ligne</li>
                <li>Consultation de l'historique</li>
            </ul>
        </div>
        <div class="role-card">
            <i class="fas fa-user-tie role-icon"></i>
            <h3>Personnel Administratif</h3>
            <ul>
                <li>Planification manuelle des rendez-vous</li>
                <li>Suivi du planning global</li>
                <li>Gestion des listes d'attente</li>
                <li>Redistribution des créneaux libérés</li>
            </ul>
        </div>
    </div>
</section>

<!-- Section CTA -->
<section class="cta">
    <div class="cta-content">
        <h2>Prêt à optimiser la gestion de votre clinique ?</h2>
        <p>Rejoignez notre plateforme dès aujourd'hui et bénéficiez d'un système complet et personnalisé.</p>
        <div class="cta-buttons">
            <a href="#" class="btn btn-light">Créer un compte</a>
            <a href="#" class="btn btn-outline" style="border-color: white; color: white;">Se connecter</a>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <div class="footer-column">
            <h3>MediPlan</h3>
            <p>Système de gestion de clinique développé avec Java EE pour une automatisation complète des processus médicaux.</p>
        </div>
        <div class="footer-column">
            <h3>Liens Rapides</h3>
            <ul>
                <li><a href="#presentation">Présentation</a></li>
                <li><a href="#fonctionnalites">Fonctionnalités</a></li>
                <li><a href="#roles">Rôles</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Technologies</h3>
            <ul>
                <li>Java EE</li>
                <li>JPA/Hibernate</li>
                <li>Servlets & JSP</li>
                <li>Maven</li>
                <li>Tomcat/GlassFish</li>
            </ul>
        </div>
    </div>
    <div class="copyright">
        <p>&copy; 2023 MediPlan - Système de Gestion de Clinique. Tous droits réservés.</p>
    </div>
</footer>
</body>
</html>