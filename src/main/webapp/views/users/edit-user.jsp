<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.clinique_digital.dto.UserDTO" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<%
    UserDTO userToEdit = (UserDTO) request.getAttribute("userToEdit");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Utilisateur - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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
            --info: #3b82f6;
            --gray: #64748b;
            --white: #ffffff;
            --sidebar-width: 280px;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            line-height: 1.6;
        }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: var(--sidebar-width);
            height: 100vh;
            background: linear-gradient(180deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 24px 0;
            overflow-y: auto;
            z-index: 1000;
            transition: transform 0.3s ease;
        }

        .sidebar-logo {
            padding: 0 24px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            margin-bottom: 24px;
        }

        .logo-content {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-icon {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }

        .logo-text h2 {
            color: white;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .logo-text p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 12px;
        }

        .sidebar-user {
            padding: 0 24px 24px;
            margin-bottom: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .user-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            backdrop-filter: blur(10px);
        }

        .user-avatar-large {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--secondary), #059669);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 18px;
        }

        .user-info-text h4 {
            color: white;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .role-admin { background: rgba(255, 255, 255, 0.3); color: white; }
        .role-doctor { background: rgba(124, 205, 187, 0.3); color: white; }
        .role-patient { background: rgba(237, 248, 177, 0.3); color: var(--dark); }
        .role-staff { background: rgba(254, 196, 79, 0.3); color: var(--dark); }

        .nav-menu {
            padding: 0 16px;
        }

        .nav-section {
            margin-bottom: 32px;
        }

        .nav-section-title {
            color: rgba(255, 255, 255, 0.7);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 0 12px 12px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            margin-bottom: 4px;
            border-radius: 10px;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: var(--transition);
            cursor: pointer;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            color: white;
        }

        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .nav-item i {
            font-size: 18px;
            width: 24px;
        }

        .nav-item span {
            font-size: 14px;
            font-weight: 500;
        }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        .topbar {
            background: white;
            padding: 20px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .topbar-left h1 {
            color: var(--dark);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .topbar-left p {
            color: var(--gray);
            font-size: 14px;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .menu-toggle {
            display: none;
            width: 44px;
            height: 44px;
            background: var(--light);
            border: none;
            border-radius: 10px;
            cursor: pointer;
            align-items: center;
            justify-content: center;
        }

        .menu-toggle i {
            color: var(--dark);
            font-size: 20px;
        }

        /* Content */
        .content {
            padding: 32px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Alert Messages */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .alert i {
            font-size: 20px;
        }

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 2px solid var(--light);
        }

        .page-title h1 {
            color: var(--dark);
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title h1 i {
            color: var(--primary);
        }

        .page-title p {
            color: var(--gray);
            font-size: 14px;
        }

        .btn-primary {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.3);
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 16px;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .form-card-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 24px 30px;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-card-header h2 {
            color: var(--dark);
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-card-header h2 i {
            color: var(--primary);
        }

        .form-card-body {
            padding: 40px 30px;
        }

        /* Form Styles */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            color: var(--dark);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-label.required::after {
            content: '*';
            color: var(--danger);
            margin-left: 4px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: var(--transition);
            background: white;
            color: var(--dark);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(44, 127, 184, 0.1);
        }

        .form-control:disabled {
            background: #f8fafc;
            cursor: not-allowed;
        }

        .form-help {
            font-size: 12px;
            color: var(--gray);
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Section Divider */
        .section-divider {
            margin: 40px 0 32px;
            padding-top: 32px;
            border-top: 2px solid #e2e8f0;
        }

        .section-title {
            color: var(--dark);
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        /* Type Badge */
        .type-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 24px;
        }

        .type-badge.patient {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
        }

        .type-badge.doctor {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
        }

        .type-badge.staff {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: #92400e;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            padding-top: 32px;
            border-top: 2px solid #e2e8f0;
            margin-top: 40px;
        }

        .btn-secondary {
            padding: 12px 24px;
            background: white;
            color: var(--gray);
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-secondary:hover {
            background: #f8fafc;
            border-color: var(--gray);
        }

        .btn-submit {
            padding: 12px 32px;
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 162, 95, 0.3);
        }

        /* Info Box */
        .info-box {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            border: 2px solid #93c5fd;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .info-box h4 {
            color: #1e40af;
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-box p {
            color: #1e3a8a;
            font-size: 13px;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .menu-toggle {
                display: flex;
            }

            .content {
                padding: 20px;
            }

            .form-card-body {
                padding: 24px 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-secondary,
            .btn-submit {
                width: 100%;
                justify-content: center;
            }
        }

        /* Scrollbar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-content">
            <div class="logo-icon">
                <i class="fas fa-hospital-alt"></i>
            </div>
            <div class="logo-text">
                <h2>MediPlan</h2>
                <p>Système Clinique</p>
            </div>
        </div>
    </div>

    <% User user = (User) session.getAttribute("user"); %>
    <div class="sidebar-user">
        <div class="user-card">
            <div class="user-avatar-large">
                <%= user != null ? user.getNom().substring(0,1).toUpperCase() : "U" %>
            </div>
            <div class="user-info-text">
                <h4><%= user != null ? user.getNom() : "Utilisateur" %></h4>
                <span class="role-badge role-admin">
                    <%= user != null ? user.getRole() : "USER" %>
                </span>
            </div>
        </div>
    </div>

    <nav class="nav-menu">
        <div class="nav-section">
            <div class="nav-section-title">Principal</div>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
                <i class="fas fa-home"></i>
                <span>Tableau de Bord</span>
            </a>
            <a href="${pageContext.request.contextPath}/appointments" class="nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Rendez-vous</span>
            </a>
            <a href="${pageContext.request.contextPath}/patients" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
            <a href="${pageContext.request.contextPath}/doctors" class="nav-item">
                <i class="fas fa-user-md"></i>
                <span>Docteurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active">
                <i class="fas fa-users-cog"></i>
                <span>Utilisateurs</span>
            </a>
            <a href="${pageContext.request.contextPath}/departments" class="nav-item">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="${pageContext.request.contextPath}/specialties" class="nav-item">
                <i class="fas fa-stethoscope"></i>
                <span>Spécialités</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Système</div>
            <a href="${pageContext.request.contextPath}/settings" class="nav-item">
                <i class="fas fa-cog"></i>
                <span>Paramètres</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item">
                <i class="fas fa-sign-out-alt"></i>
                <span>Déconnexion</span>
            </a>
        </div>
    </nav>
</aside>

<!-- Main Content -->
<div class="main-content">
    <!-- Top Bar -->
    <div class="topbar">
        <div class="topbar-left">
            <h1>Modifier l'Utilisateur</h1>
            <p>Mettez à jour les informations de l'utilisateur</p>
        </div>
        <div class="topbar-right">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </div>

    <!-- Content -->
    <div class="content">
        <!-- Alert Messages -->
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <%= successMessage %>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <%= errorMessage %>
        </div>
        <% } %>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h1>
                    <i class="fas fa-user-edit"></i>
                    Modifier Utilisateur
                </h1>
                <p>Mettez à jour les informations de <%= userToEdit != null ? userToEdit.getNom() : "l'utilisateur" %></p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn-primary">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
        </div>

        <% if (userToEdit != null) { %>
        <!-- Form Card -->
        <div class="form-card">
            <div class="form-card-header">
                <h2>
                    <i class="fas fa-edit"></i>
                    Formulaire de modification
                </h2>
            </div>

            <div class="form-card-body">
                <!-- Type Badge -->
                <% if ("Patient".equals(userToEdit.getTypeSpecifique())) { %>
                <div class="type-badge patient">
                    <i class="fas fa-user"></i>
                    Type: Patient
                </div>
                <% } else if ("Docteur".equals(userToEdit.getTypeSpecifique())) { %>
                <div class="type-badge doctor">
                    <i class="fas fa-user-md"></i>
                    Type: Docteur
                </div>
                <% } else { %>
                <div class="type-badge staff">
                    <i class="fas fa-user-cog"></i>
                    Type: Admin or Staff
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= userToEdit.getId() %>">
                    <input type="hidden" name="role" value="<%= userToEdit.getRole() %>">

                    <!-- Informations de base -->
                    <div class="section-title">
                        <i class="fas fa-id-card"></i>
                        Informations de base
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom" class="form-label required">Nom complet</label>
                            <input type="text" id="nom" name="nom" class="form-control"
                                   value="<%= userToEdit.getNom() %>" required>
                            <div class="form-help">
                                <i class="fas fa-info-circle"></i>
                                Nom et prénom de l'utilisateur
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label required">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   value="<%= userToEdit.getEmail() %>" required>
                            <div class="form-help">
                                <i class="fas fa-envelope"></i>
                                Adresse email valide
                            </div>
                        </div>
                    </div>

                    <!-- Informations spécifiques Patient -->
                    <% if ("Patient".equals(userToEdit.getTypeSpecifique())) { %>
                    <div class="section-divider">
                        <div class="section-title">
                            <i class="fas fa-notes-medical"></i>
                            Informations Patient
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="cin" class="form-label required">CIN</label>
                            <input type="text" id="cin" name="cin" class="form-control"
                                   value="<%= userToEdit.getInfoSupplementaire() != null ? userToEdit.getInfoSupplementaire() : "" %>"
                                   placeholder="Ex: AB123456" required>
                        </div>

                        <div class="form-group">
                            <label for="telephone" class="form-label">Téléphone</label>
                            <input type="tel" id="telephone" name="telephone" class="form-control"
                                   value="<%= userToEdit.getInfoSupplementaire() != null ? userToEdit.getInfoSupplementaire() : "" %>"
                                   placeholder="+212 6XX XXX XXX">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="adresse" class="form-label">Adresse</label>
                        <input type="text" id="adresse" name="adresse" class="form-control"
                               value="<%= userToEdit.getInfoSupplementaire() != null ? userToEdit.getInfoSupplementaire() : "" %>"
                               placeholder="Adresse complète">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="dateNaissance" class="form-label">Date de naissance</label>
                            <input type="date" id="dateNaissance" name="dateNaissance" class="form-control"
                                   value="<%= userToEdit.getInfoSupplementaire() != null ? userToEdit.getInfoSupplementaire() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="sexe" class="form-label">Sexe</label>
                            <select id="sexe" name="sexe" class="form-control">
                                <option value="">Sélectionnez</option>
                                <option value="MASCULIN">Masculin</option>
                                <option value="FEMININ">Féminin</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="groupeSanguin" class="form-label">Groupe sanguin</label>
                        <select id="groupeSanguin" name="groupeSanguin" class="form-control">
                            <option value="">Sélectionnez</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                        </select>
                    </div>
                    <% } %>

                    <!-- Informations spécifiques Docteur -->
                    <% if ("Docteur".equals(userToEdit.getTypeSpecifique())) { %>
                    <div class="section-divider">
                        <div class="section-title">
                            <i class="fas fa-user-md"></i>
                            Informations Docteur
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="matricule" class="form-label required">Matricule</label>
                            <input type="text" id="matricule" name="matricule" class="form-control"
                                   value="<%= userToEdit.getInfoSupplementaire() != null ? userToEdit.getInfoSupplementaire() : "" %>"
                                   placeholder="MAT2024001" required>
                            <div class="form-help">
                                <i class="fas fa-fingerprint"></i>
                                Identifiant unique du médecin
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="titre" class="form-label">Titre</label>
                            <select id="titre" name="titre" class="form-control">
                                <option value="Dr.">Docteur</option>
                                <option value="Prof.">Professeur</option>
                                <option value="Ch.">Chef de service</option>
                            </select>
                            <div class="form-help">
                                <i class="fas fa-graduation-cap"></i>
                                Titre professionnel
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <!-- Info Standard User -->
                    <% if ("Utilisateur".equals(userToEdit.getTypeSpecifique()) &&
                            !"STAFF".equals(userToEdit.getRole().name()) &&
                            !"ADMIN".equals(userToEdit.getRole().name())) { %>
                    <div class="section-divider">
                        <div class="info-box">
                            <h4>
                                <i class="fas fa-info-circle"></i>
                                Utilisateur Standard
                            </h4>
                            <p>Cet utilisateur n'a pas d'informations supplémentaires spécifiques. Seuls les champs de base sont requis.</p>
                        </div>
                    </div>
                    <% } %>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary">
                            <i class="fas fa-times"></i>
                            Annuler
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i>
                            Enregistrer les modifications
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <% } else { %>
        <!-- Error Message -->
        <div class="form-card">
            <div class="form-card-body">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    Utilisateur non trouvé ou vous n'avez pas les permissions nécessaires pour modifier cet utilisateur.
                </div>
                <div style="margin-top: 24px;">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-primary">
                        <i class="fas fa-arrow-left"></i> Retour à la liste
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    // Auto-hide alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.animation = 'slideUp 0.3s ease';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });

    // Add slide up animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideUp {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(-10px);
            }
        }
    `;
    document.head.appendChild(style);
</script>
</body>
</html>