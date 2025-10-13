<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.clinique_digital.dto.SpecialtyDTO" %>
<%
    List<SpecialtyDTO> specialties = (List<SpecialtyDTO>) request.getAttribute("specialties");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    String searchTerm = (String) request.getAttribute("searchTerm");

    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Spécialités - MediPlan</title>
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

        /* User Profile in Sidebar */
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

        /* Navigation Menu */
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

        .nav-badge {
            margin-left: auto;
            background: var(--danger);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
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
            position: relative;
        }

        .topbar-btn:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }

        .topbar-btn i {
            color: var(--gray);
            font-size: 18px;
        }

        .notification-dot {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 8px;
            height: 8px;
            background: var(--danger);
            border-radius: 50%;
            border: 2px solid white;
        }

        .menu-toggle {
            display: none;
        }

        /* Content Area */
        .content {
            padding: 32px;
        }

        /* Messages */
        .success-message, .error-message {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            animation: slideIn 0.3s ease;
        }

        .success-message {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border-left: 4px solid var(--success);
        }

        .error-message {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border-left: 4px solid var(--danger);
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            padding: 24px;
            background: linear-gradient(135deg, rgba(44, 127, 184, 0.05), rgba(124, 205, 187, 0.05));
            border-radius: 16px;
            border: 1px solid rgba(44, 127, 184, 0.1);
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

        .page-title p {
            color: var(--gray);
            font-size: 15px;
        }

        .btn-primary {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(44, 127, 184, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(44, 127, 184, 0.3);
        }

        /* Statistics Card */
        .stats-card {
            background: white;
            border-radius: 16px;
            padding: 28px;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
            margin-bottom: 24px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 24px;
            border-radius: 14px;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border: 2px solid #e2e8f0;
            transition: var(--transition);
        }

        .stat-item:hover {
            transform: translateY(-4px);
            border-color: var(--success);
            box-shadow: 0 8px 20px rgba(44, 162, 95, 0.15);
        }

        .stat-number {
            font-size: 36px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--success), #059669);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 14px;
            color: var(--gray);
            font-weight: 600;
        }

        /* Actions Container */
        .actions-container {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-bottom: 24px;
            background: white;
            padding: 20px;
            border-radius: 16px;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
        }

        .search-form {
            display: flex;
            gap: 12px;
            align-items: center;
            flex: 1;
        }

        .search-input {
            padding: 12px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            flex: 1;
            font-size: 14px;
            transition: var(--transition);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(44, 127, 184, 0.1);
        }

        .search-btn {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: var(--transition);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(44, 127, 184, 0.3);
        }

        /* Specialties Table */
        .specialties-table {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
        }

        .table-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 24px 28px;
            border-bottom: 2px solid #e2e8f0;
        }

        .table-header h2 {
            color: var(--dark);
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            padding: 18px 24px;
            text-align: left;
            font-weight: 700;
            color: var(--dark);
            border-bottom: 2px solid #cbd5e1;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 24px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--dark);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr {
            transition: var(--transition);
        }

        tbody tr:hover {
            background: linear-gradient(135deg, rgba(44, 127, 184, 0.02), rgba(124, 205, 187, 0.02));
            transform: scale(1.01);
        }

        .specialty-code {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            padding: 8px 14px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 12px;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(44, 162, 95, 0.2);
        }

        .specialty-name {
            font-weight: 700;
            color: var(--dark);
            font-size: 15px;
        }

        .specialty-description {
            color: var(--gray);
            font-size: 13px;
            line-height: 1.6;
            margin-top: 4px;
        }

        .department-badge {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: #0369a1;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .doctors-count {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .actions-cell {
            display: flex;
            gap: 10px;
        }

        .btn-edit {
            padding: 10px 18px;
            background: linear-gradient(135deg, var(--warning), #f59e0b);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(254, 196, 79, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(254, 196, 79, 0.4);
        }

        .btn-delete {
            padding: 10px 18px;
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(227, 74, 51, 0.3);
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(227, 74, 51, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray);
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 24px;
            color: #cbd5e1;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 12px;
            color: var(--dark);
            font-weight: 700;
        }

        .empty-state p {
            font-size: 15px;
            margin-bottom: 24px;
        }

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

            .content {
                padding: 20px;
            }

            .page-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-container {
                flex-direction: column;
                align-items: stretch;
            }

            .search-form {
                flex-direction: column;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 12px;
            }

            .actions-cell {
                flex-direction: column;
            }
        }

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

    <div class="sidebar-user">
        <div class="user-card">
            <div class="user-avatar-large">A</div>
            <div class="user-info-text">
                <h4>Dr. Ahmed</h4>
                <span class="role-badge role-admin">ADMIN</span>
            </div>
        </div>
    </div>

    <nav class="nav-menu">
        <div class="nav-section">
            <div class="nav-section-title">Principal</div>
            <a href="dashboard" class="nav-item">
                <i class="fas fa-home"></i>
                <span>Tableau de Bord</span>
            </a>
            <a href="appointments" class="nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Rendez-vous</span>
                <span class="nav-badge">12</span>
            </a>
            <a href="patients" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
            <a href="doctors" class="nav-item">
                <i class="fas fa-user-md"></i>
                <span>Docteurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Gestion</div>
            <a href="availabilities" class="nav-item">
                <i class="fas fa-clock"></i>
                <span>Disponibilités</span>
            </a>
            <a href="departments" class="nav-item">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="specialties" class="nav-item active">
                <i class="fas fa-stethoscope"></i>
                <span>Spécialités</span>
            </a>
            <a href="medical-notes" class="nav-item">
                <i class="fas fa-file-medical"></i>
                <span>Notes Médicales</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Système</div>
            <a href="reports" class="nav-item">
                <i class="fas fa-chart-bar"></i>
                <span>Rapports</span>
            </a>
            <a href="settings" class="nav-item">
                <i class="fas fa-cog"></i>
                <span>Paramètres</span>
            </a>
            <a href="logout" class="nav-item">
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
            <h1>Gestion des Spécialités</h1>
            <p>Administrez les spécialités médicales de votre clinique</p>
        </div>
        <div class="topbar-right">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <button class="topbar-btn">
                <i class="fas fa-search"></i>
            </button>
            <button class="topbar-btn">
                <i class="fas fa-bell"></i>
                <span class="notification-dot"></span>
            </button>
            <button class="topbar-btn">
                <i class="fas fa-envelope"></i>
            </button>
        </div>
    </div>

    <!-- Content -->
    <div class="content">
        <!-- Messages -->
        <% if (successMessage != null) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            <%= successMessage %>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <%= errorMessage %>
        </div>
        <% } %>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h1><i class="fas fa-stethoscope" style="color: var(--success);"></i> Spécialités Médicales</h1>
                <p>Gérez l'ensemble des spécialités médicales de votre établissement</p>
            </div>
            <a href="specialties?action=new" class="btn-primary">
                <i class="fas fa-plus"></i> Nouvelle Spécialité
            </a>
        </div>

        <!-- Statistics -->
        <div class="stats-card">
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number"><%= specialties != null ? specialties.size() : 0 %></div>
                    <div class="stat-label">Spécialités Actives</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%
                            int totalDoctors = 0;
                            if (specialties != null) {
                                for (SpecialtyDTO spec : specialties) {
                                    totalDoctors += spec.getDoctorsCount();
                                }
                            }
                        %>
                        <%= totalDoctors %>
                    </div>
                    <div class="stat-label">Docteurs au Total</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%
                            long uniqueDepartments = 0;
                            if (specialties != null) {
                                uniqueDepartments = specialties.stream()
                                        .map(SpecialtyDTO::getDepartmentId)
                                        .distinct()
                                        .count();
                            }
                        %>
                        <%= uniqueDepartments %>
                    </div>
                    <div class="stat-label">Départements Liés</div>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="actions-container">
            <form action="specialties" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="searchTerm"
                       placeholder="Rechercher une spécialité par nom ou code..."
                       value="<%= searchTerm != null ? searchTerm : "" %>"
                       class="search-input">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i> Rechercher
                </button>
            </form>
        </div>

        <!-- Specialties Table -->
        <div class="specialties-table">
            <div class="table-header">
                <h2><i class="fas fa-list"></i> Liste des Spécialités</h2>
            </div>

            <% if (specialties != null && !specialties.isEmpty()) { %>
            <table>
                <thead>
                <tr>
                    <th>Code</th>
                    <th>Spécialité</th>
                    <th>Description</th>
                    <th>Département</th>
                    <th>Docteurs</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (SpecialtyDTO spec : specialties) { %>
                <tr>
                    <td>
                        <span class="specialty-code"><%= spec.getCode() %></span>
                    </td>
                    <td>
                        <div class="specialty-name"><%= spec.getName() %></div>
                    </td>
                    <td>
                        <div class="specialty-description">
                            <%
                                String description = spec.getDescription();
                                if (description != null && description.length() > 80) {
                                    out.print(description.substring(0, 80) + "...");
                                } else {
                                    out.print(description != null ? description : "Non renseignée");
                                }
                            %>
                        </div>
                    </td>
                    <td>
                        <% if (spec.getDepartmentName() != null) { %>
                        <span class="department-badge">
                            <i class="fas fa-hospital"></i>
                            <%= spec.getDepartmentName() %>
                        </span>
                        <% } else { %>
                        <span style="color: var(--gray); font-style: italic;">Non assigné</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="doctors-count">
                            <i class="fas fa-user-md"></i> <%= spec.getDoctorsCount() %>
                        </span>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <a href="specialties?action=edit&id=<%= spec.getId() %>" class="btn-edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="specialties?action=delete&id=<%= spec.getId() %>" class="btn-delete"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer la spécialité <%= spec.getName() %> ?\n\nCette action est irréversible et supprimera toutes les données associées.')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-stethoscope"></i>
                <h3>Aucune spécialité trouvée</h3>
                <p>
                    <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                    Aucun résultat pour "<%= searchTerm %>". Essayez une autre recherche.
                    <% } else { %>
                    Commencez par créer votre première spécialité médicale pour structurer votre clinique.
                    <% } %>
                </p>
                <a href="specialties?action=new" class="btn-primary" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Créer une Spécialité
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    // Fermer la sidebar au clic en dehors sur mobile
    document.addEventListener('click', function(event) {
        const sidebar = document.querySelector('.sidebar');
        const menuToggle = document.querySelector('.menu-toggle');

        if (window.innerWidth <= 768 && sidebar.classList.contains('active')) {
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                sidebar.classList.remove('active');
            }
        }
    });

    // Animation au scroll
    window.addEventListener('scroll', function() {
        const topbar = document.querySelector('.topbar');
        if (window.scrollY > 10) {
            topbar.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.08)';
        } else {
            topbar.style.boxShadow = 'none';
        }
    });
</script>
</body>
</html>