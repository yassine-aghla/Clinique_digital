<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.clinique_digital.entities.*" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.clinique_digital.dto.SpecialtyDTO" %>
<%
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    List<SpecialtyDTO> specialties = (List<SpecialtyDTO>) request.getAttribute("specialties");

    String successMessage = (String) request.getSession().getAttribute("successMessage");
    String errorMessage = (String) request.getSession().getAttribute("errorMessage");

    if (successMessage != null) {
        request.getSession().removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        request.getSession().removeAttribute("errorMessage");
    }

    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctors");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigner Docteur - MediPlan</title>
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

        /* Sidebar */
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

        /* Top Bar */
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
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .back-btn {
            background: linear-gradient(135deg, var(--gray), #475569);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: var(--transition);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(100, 116, 139, 0.3);
        }

        .topbar-title h1 {
            color: var(--dark);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .topbar-title p {
            color: var(--gray);
            font-size: 14px;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .topbar-btn {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--light);
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .topbar-btn:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }

        .topbar-btn i {
            color: var(--gray);
            font-size: 18px;
        }

        .menu-toggle {
            display: none;
        }

        /* Content */
        .content {
            padding: 32px;
            display: flex;
            justify-content: center;
        }

        /* Form Container */
        .form-container {
            max-width: 800px;
            width: 100%;
        }

        /* Messages */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .alert-error {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .form-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 32px;
            text-align: center;
        }

        .form-header-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 36px;
            backdrop-filter: blur(10px);
        }

        .form-header h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .form-header p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 14px;
        }

        .form-body {
            padding: 32px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 700;
            color: var(--dark);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label i {
            color: var(--primary);
            font-size: 16px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            transition: var(--transition);
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
        }

        /* Doctor Info Card */
        .doctor-info-card {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 24px;
            border-radius: 16px;
            border: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .doctor-avatar-big {
            width: 80px;
            height: 80px;
            border-radius: 16px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 800;
            font-size: 32px;
            flex-shrink: 0;
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.3);
        }

        .doctor-details-full {
            flex: 1;
        }

        .doctor-details-full h3 {
            color: var(--dark);
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .doctor-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: white;
            border-radius: 8px;
            font-size: 12px;
            color: var(--gray);
            border: 1px solid #e2e8f0;
        }

        .meta-item i {
            color: var(--primary);
        }

        .current-assignment {
            margin-top: 12px;
            padding: 12px;
            background: white;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
        }

        .current-assignment h4 {
            font-size: 12px;
            color: var(--gray);
            margin-bottom: 8px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .assignment-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .assignment-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-department {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
        }

        .badge-specialty {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success);
        }

        .badge-none {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: var(--danger);
        }

        /* Department Info Box */
        .department-info-box {
            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 50%, #7dd3fc 100%);
            padding: 20px;
            border-radius: 16px;
            border: 2px solid #0ea5e9;
            margin-top: 12px;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .department-info-box h4 {
            color: var(--primary-dark);
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .department-info-box p {
            color: #075985;
            font-size: 13px;
            font-weight: 600;
        }

        .no-department-info {
            color: var(--gray);
            font-size: 13px;
            margin-top: 8px;
            font-style: italic;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-help {
            color: var(--gray);
            font-size: 12px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-help i {
            color: var(--info);
        }

        .hidden {
            display: none;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f1f5f9;
        }

        .btn-cancel {
            background: linear-gradient(135deg, var(--gray), #475569);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            flex: 1;
            font-size: 14px;
            font-weight: 700;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(100, 116, 139, 0.3);
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            cursor: pointer;
            flex: 2;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-submit:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 162, 95, 0.4);
        }

        .btn-submit:disabled {
            background: linear-gradient(135deg, #9ca3af, #6b7280);
            cursor: not-allowed;
            opacity: 0.6;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            cursor: pointer;
            flex: 1;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-decoration: none; /* pour enlever le soulignement du lien */
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(239, 68, 68, 0.4);
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

            .topbar {
                padding: 16px 20px;
            }

            .topbar-left {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .content {
                padding: 20px;
            }

            .form-body {
                padding: 20px;
            }

            .doctor-info-card {
                flex-direction: column;
                text-align: center;
            }

            .doctor-meta {
                justify-content: center;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-cancel, .btn-submit {
                flex: 1;
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

    <% User user=(User) session.getAttribute("user");%>
    <div class="sidebar-user">
        <div class="user-card">
            <div class="user-avatar-large"><%=user.getNom().substring(0,1).toUpperCase()%></div>
            <div class="user-info-text">
                <h4><%=user.getNom()%></h4>
                <span class="role-badge role-admin"><%=user.getRole()%></span>
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
            <a href="" class="nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Rendez-vous</span>
            </a>
            <a href="" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
            <a href="${pageContext.request.contextPath}/doctors" class="nav-item active">
                <i class="fas fa-user-md"></i>
                <span>Docteurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Gestion</div>
            <a href="" class="nav-item">
                <i class="fas fa-clock"></i>
                <span>Disponibilités</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <i class="fas fa-user-cog"></i>
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
            <a href="" class="nav-item">
                <i class="fas fa-chart-bar"></i>
                <span>Rapports</span>
            </a>
            <a href="" class="nav-item">
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
            <a href="${pageContext.request.contextPath}/doctors" class="back-btn">
                <i class="fas fa-arrow-left"></i> Retour
            </a>
            <div class="topbar-title">
                <h1>Assigner un Docteur</h1>
                <p>Configuration du département et de la spécialité</p>
            </div>
        </div>
        <div class="topbar-right">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <button class="topbar-btn">
                <i class="fas fa-question-circle"></i>
            </button>
        </div>
    </div>

    <!-- Content -->
    <div class="content">
        <div class="form-container">
            <!-- Messages -->
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

            <!-- Form Card -->
            <div class="form-card">
                <div class="form-header">
                    <div class="form-header-icon">
                        <i class="fas fa-link"></i>
                    </div>
                    <h2>Formulaire d'Assignation</h2>
                    <p>Associer le docteur à un département et une spécialité</p>
                </div>

                <div class="form-body">
                    <form id="assignmentForm" action="${pageContext.request.contextPath}/admin/doctors/assignment" method="post">
                        <input type="hidden" name="action" value="assign">
                        <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                        <input type="hidden" id="departmentId" name="departmentId" value="">

                        <!-- Doctor Information -->
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-user-md"></i>
                                Informations du Docteur
                            </label>
                            <div class="doctor-info-card">
                                <div class="doctor-avatar-big">
                                    <%= doctor.getNom().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="doctor-details-full">
                                    <h3><%= doctor.getNom() %></h3>
                                    <div class="doctor-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-id-card"></i>
                                            <%= doctor.getMatricule() %>
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-envelope"></i>
                                            <%= doctor.getEmail() %>
                                        </div>
                                        <% if (doctor.getTitre() != null) { %>
                                        <div class="meta-item">
                                            <i class="fas fa-graduation-cap"></i>
                                            <%= doctor.getTitre() %>
                                        </div>
                                        <% } %>
                                    </div>

                                    <% if (doctor.getDepartement() != null || doctor.getSpecialite() != null) { %>
                                    <div class="current-assignment">
                                        <h4>Assignation actuelle</h4>
                                        <div class="assignment-badges">
                                            <% if (doctor.getDepartement() != null) { %>
                                            <span class="assignment-badge badge-department">
                                                <i class="fas fa-hospital"></i>
                                                <%= doctor.getDepartement().getName() %>
                                            </span>
                                            <% } else { %>
                                            <span class="assignment-badge badge-none">
                                                <i class="fas fa-times"></i>
                                                Aucun département
                                            </span>
                                            <% } %>

                                            <% if (doctor.getSpecialite() != null) { %>
                                            <span class="assignment-badge badge-specialty">
                                                <i class="fas fa-stethoscope"></i>
                                                <%= doctor.getSpecialite().getName() %>
                                            </span>
                                            <% } else { %>
                                            <span class="assignment-badge badge-none">
                                                <i class="fas fa-times"></i>
                                                Aucune spécialité
                                            </span>
                                            <% } %>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

            <div class="form-group">
                <label for="specialty" class="form-label">Spécialité</label>
                <select id="specialty" name="specialtyId" class="form-control" required
                        onchange="updateDepartmentInfo(this.value)">
                    <option value="">Sélectionnez une spécialité</option>
                    <% for (SpecialtyDTO spec : specialties) { %>
                    <option value="<%= spec.getId() %>"
                            data-department-id="<%= spec.getDepartmentId() %>"
                            data-department-name="<%= spec.getDepartmentName() %>"
                            data-department-code="<%= spec.getDepartmentCode() %>">
                        <%= spec.getCode() %> - <%= spec.getName() %>
                    </option>
                    <% } %>
                </select>
                <div class="form-help">
                    La spécialité déterminera automatiquement le département
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Département associé</label>
                <div id="departmentInfo" class="department-info hidden">
                    <strong id="deptName"></strong><br>
                    <small>Code: <span id="deptCode"></span></small>
                    <input type="hidden" id="selectedDepartmentId" name="selectedDepartmentId">
                </div>
                <div id="noDepartmentInfo" class="form-help">
                    Sélectionnez d'abord une spécialité pour voir le département associé
                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/doctors" class="btn-secondary">
                    <i class="fas fa-times"></i> Annuler
                </a>
                <button type="submit" class="btn-submit" id="submitBtn" disabled>
                    <i class="fas fa-check"></i> Assigner
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function updateDepartmentInfo(specialtyId) {
        const specialtySelect = document.getElementById('specialty');
        const departmentInfo = document.getElementById('departmentInfo');
        const noDepartmentInfo = document.getElementById('noDepartmentInfo');
        const deptName = document.getElementById('deptName');
        const deptCode = document.getElementById('deptCode');
        const departmentIdInput = document.getElementById('departmentId');
        const submitBtn = document.getElementById('submitBtn');
        const selectedDepartmentIdInput = document.getElementById('selectedDepartmentId');

        if (!specialtyId) {
            departmentInfo.classList.add('hidden');
            noDepartmentInfo.classList.remove('hidden');
            submitBtn.disabled = true;
            departmentIdInput.value = '';
            selectedDepartmentIdInput.value = '';
            return;
        }

        // Récupérer les informations de la spécialité sélectionnée
        const selectedOption = specialtySelect.options[specialtySelect.selectedIndex];
        const departmentId = selectedOption.getAttribute('data-department-id');
        const departmentName = selectedOption.getAttribute('data-department-name');
        const departmentCode = selectedOption.getAttribute('data-department-code');

        if (departmentId && departmentName && departmentCode) {
            // Afficher les informations du département
            deptName.textContent = departmentName;
            deptCode.textContent = departmentCode;
            departmentIdInput.value = departmentId;
            selectedDepartmentIdInput.value = departmentId;

            departmentInfo.classList.remove('hidden');
            noDepartmentInfo.classList.add('hidden');
            submitBtn.disabled = false;

            console.log('=== DEBUG ===');
            console.log('Spécialité ID:', specialtyId);
            console.log('Département ID:', departmentId);
            console.log('Département:', departmentName);
        } else {
            departmentInfo.classList.add('hidden');
            noDepartmentInfo.classList.remove('hidden');
            submitBtn.disabled = true;
            departmentIdInput.value = '';
            selectedDepartmentIdInput.value = '';
        }
    }

    // Validation côté client
    document.getElementById('assignmentForm').addEventListener('submit', function(e) {
        const specialtyId = document.getElementById('specialty').value;
        const departmentId = document.getElementById('departmentId').value;
        const submitBtn = document.getElementById('submitBtn');

        if (!specialtyId || !departmentId) {
            e.preventDefault();
            alert('Veuillez sélectionner une spécialité');
            return false;
        }

        // Désactiver le bouton pendant l'envoi pour éviter les doubles clics
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assignation en cours...';

        return true;
    });

    // Réactiver le bouton si l'utilisateur revient en arrière après soumission
    window.addEventListener('pageshow', function(event) {
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn && document.getElementById('specialty').value) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-check"></i> Assigner';
        }
    });

    // Pré-sélectionner la spécialité actuelle si le docteur en a une
    document.addEventListener('DOMContentLoaded', function() {
        <% if (doctor.getSpecialite() != null) { %>
        const currentSpecialtyId = <%= doctor.getSpecialite().getId() %>;
        document.getElementById('specialty').value = currentSpecialtyId;
        updateDepartmentInfo(currentSpecialtyId);
        <% } %>
    });
</script>
</body>
</html>