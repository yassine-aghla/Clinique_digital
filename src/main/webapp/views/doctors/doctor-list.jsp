<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.clinique_digital.entities.*" %>
<%@ page import="java.util.List" %>
<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
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
    <title>Gestion des Docteurs - MediPlan</title>
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
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
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

        .menu-toggle {
            display: none;
        }

        /* Content */
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
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .success-message {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .error-message {
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card-mini {
            background: white;
            border-radius: 16px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: var(--transition);
        }

        .stat-card-mini:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            border-color: var(--primary);
        }

        .stat-icon-mini {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }

        .stat-icon-primary {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
        }

        .stat-icon-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success);
        }

        .stat-icon-warning {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: var(--warning);
        }

        .stat-info h3 {
            font-size: 28px;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 4px;
        }

        .stat-info p {
            font-size: 12px;
            color: var(--gray);
            font-weight: 600;
        }

        /* Doctors Table Card */
        .doctors-table-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .table-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 24px 32px;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h2 {
            color: var(--dark);
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-header h2 i {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .search-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            background: white;
            padding: 10px 16px;
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            transition: var(--transition);
        }

        .search-bar:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
        }

        .search-bar i {
            color: var(--gray);
        }

        .search-bar input {
            border: none;
            outline: none;
            font-size: 14px;
            width: 250px;
        }

        /* Table */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }

        th {
            padding: 16px 24px;
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            border-bottom: 1px solid #f1f5f9;
            transition: var(--transition);
        }

        tbody tr:hover {
            background: #f8fafc;
            transform: scale(1.01);
        }

        td {
            padding: 20px 24px;
            font-size: 14px;
        }

        .doctor-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .doctor-avatar {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
        }

        .doctor-details h4 {
            color: var(--dark);
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .doctor-details p {
            color: var(--gray);
            font-size: 13px;
        }

        .matricule-badge {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            color: var(--dark);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            font-family: 'Courier New', monospace;
            border: 1px solid #e2e8f0;
        }

        .title-text {
            color: var(--dark);
            font-weight: 600;
            font-size: 14px;
        }

        .department-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
        }

        .specialty-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success);
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
        }

        .not-assigned {
            color: var(--danger);
            font-style: italic;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .actions-cell {
            display: flex;
            gap: 8px;
        }

        .btn-assign {
            padding: 10px 18px;
            background: linear-gradient(135deg, var(--info), #2563eb);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-assign:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(59, 130, 246, 0.3);
        }

        .btn-view {
            padding: 10px 18px;
            background: linear-gradient(135deg, var(--gray), #475569);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(100, 116, 139, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }

        .empty-state i {
            font-size: 80px;
            color: #cbd5e1;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: var(--dark);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .empty-state p {
            color: var(--gray);
            font-size: 16px;
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

            .content {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .search-bar input {
                width: 150px;
            }

            .table-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            td, th {
                padding: 12px;
                font-size: 12px;
            }

            .doctor-avatar {
                width: 40px;
                height: 40px;
                font-size: 16px;
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
                <span class="nav-badge">12</span>
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
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <i class="fas fa-users-cog"></i>
                <span>Utilisateurs</span>
            </a>
            <a href="" class="nav-item">
                <i class="fas fa-file-medical"></i>
                <span>Notes Médicales</span>
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
            <a href="" class="nav-item">
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
            <h1>Gestion des Docteurs</h1>
            <p>Assigner les docteurs aux départements et spécialités</p>
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

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card-mini">
                <div class="stat-icon-mini stat-icon-primary">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="stat-info">
                    <h3><%= doctors != null ? doctors.size() : 0 %></h3>
                    <p>Total Docteurs</p>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon-mini stat-icon-success">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <%= doctors != null ? doctors.stream().filter(d -> d.getDepartement() != null && d.getSpecialite() != null).count() : 0 %>
                    </h3>
                    <p>Assignés</p>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon-mini stat-icon-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <%= doctors != null ? doctors.stream().filter(d -> d.getDepartement() == null || d.getSpecialite() == null).count() : 0 %>
                    </h3>
                    <p>Non assignés</p>
                </div>
            </div>
        </div>

        <!-- Doctors Table -->
        <div class="doctors-table-card">
            <div class="table-header">
                <h2>
                    <i class="fas fa-user-md"></i>
                    Liste des Docteurs
                </h2>
                <div class="search-bar">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Rechercher un docteur..." id="searchInput">
                </div>
            </div>

            <% if (doctors != null && !doctors.isEmpty()) { %>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Docteur</th>
                        <th>Matricule</th>
                        <th>Titre</th>
                        <th>Département</th>
                        <th>Spécialité</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="doctorsTableBody">
                    <% for (Doctor doctor : doctors) { %>
                    <tr>
                        <td>
                            <div class="doctor-info">
                                <div class="doctor-avatar">
                                    <%= doctor.getNom().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="doctor-details">
                                    <h4><%= doctor.getNom() %></h4>
                                    <p><i class="fas fa-envelope"></i> <%= doctor.getEmail() %></p>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="matricule-badge"><%= doctor.getMatricule() %></span>
                        </td>
                        <td>
                            <span class="title-text"><%= doctor.getTitre() != null ? doctor.getTitre() : "Non défini" %></span>
                        </td>
                        <td>
                            <% if (doctor.getDepartement() != null) { %>
                            <span class="department-badge">
                                <i class="fas fa-hospital"></i>
                                <%= doctor.getDepartement().getName() %>
                            </span>
                            <% } else { %>
                            <span class="not-assigned">
                                <i class="fas fa-times-circle"></i>
                                Non assigné
                            </span>
                            <% } %>
                        </td>
                        <td>
                            <% if (doctor.getSpecialite() != null) { %>
                            <span class="specialty-badge">
                                <i class="fas fa-stethoscope"></i>
                                <%= doctor.getSpecialite().getName() %>
                            </span>
                            <% } else { %>
                            <span class="not-assigned">
                                <i class="fas fa-times-circle"></i>
                                Non assignée
                            </span>
                            <% } %>
                        </td>
                        <td>
                            <div class="actions-cell">
                                <a href="${pageContext.request.contextPath}/admin/doctors/assignment?action=showForm&doctorId=<%= doctor.getId() %>"
                                   class="btn-assign">
                                    <i class="fas fa-link"></i> Assigner
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-user-md"></i>
                <h3>Aucun docteur trouvé</h3>
                <p>Il n'y a aucun docteur enregistré dans le système</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    // Search functionality
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const searchValue = this.value.toLowerCase();
        const tableRows = document.querySelectorAll('#doctorsTableBody tr');

        tableRows.forEach(row => {
            const doctorName = row.querySelector('.doctor-details h4').textContent.toLowerCase();
            const doctorEmail = row.querySelector('.doctor-details p').textContent.toLowerCase();
            const matricule = row.querySelector('.matricule-badge').textContent.toLowerCase();

            if (doctorName.includes(searchValue) ||
                doctorEmail.includes(searchValue) ||
                matricule.includes(searchValue)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });

    // Smooth scroll animation for page load
    window.addEventListener('load', function() {
        document.body.style.opacity = '0';
        setTimeout(() => {
            document.body.style.transition = 'opacity 0.5s ease';
            document.body.style.opacity = '1';
        }, 100);
    });

    // Auto-hide messages after 5 seconds
    setTimeout(function() {
        const messages = document.querySelectorAll('.success-message, .error-message');
        messages.forEach(msg => {
            msg.style.transition = 'all 0.5s ease';
            msg.style.opacity = '0';
            msg.style.transform = 'translateY(-20px)';
            setTimeout(() => msg.remove(), 500);
        });
    }, 5000);
</script>
</body>
</html>