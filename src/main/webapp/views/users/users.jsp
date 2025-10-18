<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.clinique_digital.dto.UserDTO" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<%@ page import="java.util.List" %>
<%
    List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    Long totalUsers = (Long) request.getAttribute("totalUsers");
    Long totalDoctors = (Long) request.getAttribute("totalDoctors");
    Long totalPatients = (Long) request.getAttribute("totalPatients");
    Long totalAdmins = (Long) request.getAttribute("totalAdmins");
    Long totalStaff=(Long) request.getAttribute("totalStaff");

    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Utilisateurs - MediPlan</title>
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
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: linear-gradient(180deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 24px 0;
            overflow-y: auto;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1000;
            transition: var(--transition);
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
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 0;
            min-height: 100vh;
            transition: var(--transition);
        }

        /* Top Bar */
        .topbar {
            background: white;
            padding: 20px 30px;
            box-shadow: var(--shadow);
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            background: none;
            border: none;
            font-size: 20px;
            color: var(--dark);
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            transition: var(--transition);
        }

        .menu-toggle:hover {
            background: #f1f5f9;
        }

        .topbar-btn {
            background: none;
            border: none;
            font-size: 18px;
            color: var(--dark);
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            position: relative;
            transition: var(--transition);
        }

        .topbar-btn:hover {
            background: #f1f5f9;
        }

        .notification-dot {
            position: absolute;
            top: 6px;
            right: 6px;
            width: 8px;
            height: 8px;
            background: var(--danger);
            border-radius: 50%;
        }

        /* Content Area */
        .content {
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .page-title h1 {
            color: var(--dark);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .page-title p {
            color: var(--gray);
            font-size: 16px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .stat-admin { color: var(--danger); }
        .stat-doctor { color: var(--primary); }
        .stat-patient { color: var(--success); }
        .stat-total { color: var(--dark); }
        .stat-staff { color: var(--secondary); }

        .stat-label {
            font-size: 14px;
            color: var(--gray);
            font-weight: 600;
        }

        .users-table {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
        }

        .table-header {
            background: #f8fafc;
            padding: 20px 24px;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h2 {
            color: var(--dark);
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(44, 127, 184, 0.3);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f1f5f9;
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid #e2e8f0;
            font-size: 14px;
        }

        td {
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
            color: var(--dark);
        }

        tr:hover {
            background: #f8fafc;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-details h4 {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 4px;
        }

        .user-details p {
            color: var(--gray);
            font-size: 12px;
        }

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .role-admin { background: #fee2e2; color: #dc2626; }
        .role-doctor { background: #dbeafe; color: #1d4ed8; }
        .role-patient { background: #d1fae5; color: #059669; }
        .role-staff { background: #fef3c7; color: #d97706; }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        .status-active { background: #d1fae5; color: #059669; }
        .status-inactive { background: #fecaca; color: #dc2626; }

        .type-badge {
            background: #e0f2fe;
            color: #0369a1;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        .info-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-family: monospace;
        }

        .actions-cell {
            display: flex;
            gap: 8px;
        }

        .btn-toggle {
            padding: 6px 12px;
            background: var(--warning);
            color: var(--dark);
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 11px;
            font-weight: 600;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .btn-toggle:hover {
            background: #f59e0b;
        }

        .btn-delete {
            padding: 6px 12px;
            background: var(--danger);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 11px;
            font-weight: 600;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .btn-delete:hover {
            background: #dc2626;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray);
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            color: #cbd5e1;
        }

        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .success-message {
            background: #d1fae5;
            color: #065f46;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            border-left: 4px solid #059669;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            border-left: 4px solid #dc2626;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Popup Styles */
        .popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            backdrop-filter: blur(5px);
        }

        .popup-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            animation: popupFadeIn 0.3s ease;
        }

        @keyframes popupFadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -40%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .popup-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 24px 30px;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .popup-header h2 {
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .close-btn {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            font-size: 18px;
        }

        .close-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: rotate(90deg);
        }

        .popup-body {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: var(--transition);
            background: #f8fafc;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
        }

        .dynamic-fields {
            background: #f8fafc;
            border-radius: 10px;
            padding: 20px;
            margin-top: 16px;
            border: 2px dashed #e2e8f0;
            display: none;
        }

        .dynamic-fields.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .field-group {
            margin-bottom: 16px;
        }

        .field-group:last-child {
            margin-bottom: 0;
        }

        .form-help {
            color: var(--gray);
            font-size: 12px;
            margin-top: 4px;
            font-style: italic;
        }

        .required::after {
            content: " *";
            color: var(--danger);
        }

        .staff-only {
            background: #e0f2fe;
            border: 1px solid #bae6fd;
            border-radius: 10px;
            padding: 16px;
            margin: 16px 0;
        }

        .staff-only h4 {
            color: #0369a1;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .staff-only p {
            color: #475569;
            font-size: 14px;
            margin: 0;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 2px solid #f1f5f9;
        }

        .btn-secondary {
            background: #f1f5f9;
            color: var(--dark);
            border: 2px solid #e2e8f0;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            flex: 1;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            flex: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(44, 187, 99, 0.3);
        }

        /* Responsive */
        @media (max-width: 1024px) {
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
                display: block;
            }
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px 15px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .actions-cell {
                flex-direction: column;
            }

            table {
                display: block;
                overflow-x: auto;
            }

            .popup-content {
                width: 95%;
                margin: 20px;
            }

            .popup-body {
                padding: 20px;
            }

            .form-actions {
                flex-direction: column;
            }
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

    <% User Cuser=(User) session.getAttribute("user");%>
    <div class="sidebar-user">
        <div class="user-card">
            <div class="user-avatar-large"><%=Cuser.getNom().substring(0,1).toUpperCase()%></div>
            <div class="user-info-text">
                <h4><%=Cuser.getNom()%></h4>
                <span class="role-badge role-admin"><%=Cuser.getRole()%></span>
            </div>
        </div>
    </div>

    <nav class="nav-menu">
        <div class="nav-section">
            <div class="nav-section-title">Principal</div>
            <a href="../dashboard.jsp" class="nav-item">
                <i class="fas fa-home"></i>
                <span>Tableau de Bord</span>
            </a>
            <a href="../appointments" class="nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Rendez-vous</span>
            </a>
            <a href="../patients" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Patients</span>
            </a>
            <a href="../doctors" class="nav-item">
                <i class="fas fa-user-md"></i>
                <span>Docteurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/availabilities" class="nav-item">
                <i class="fas fa-clock"></i>
                <span>Disponibilités</span>
            </a>
            <a href="../departments" class="nav-item">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="../specialties" class="nav-item">
                <i class="fas fa-stethoscope"></i>
                <span>Spécialités</span>
            </a>
            <a href="users" class="nav-item active">
                <i class="fas fa-users-cog"></i>
                <span>Utilisateurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Système</div>
            <a href="../reports" class="nav-item">
                <i class="fas fa-chart-bar"></i>
                <span>Rapports</span>
            </a>
            <a href="../settings" class="nav-item">
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
            <h1>Gestion des Utilisateurs</h1>
            <p>Administrez tous les utilisateurs du système</p>
        </div>
        <div class="topbar-right">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <button class="topbar-btn">
                <i class="fas fa-bell"></i>
                <span class="notification-dot"></span>
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
                <h1><i class="fas fa-users-cog" style="color: var(--primary); margin-right: 12px;"></i> Utilisateurs du Système</h1>
                <p>Gérez les comptes de tous les utilisateurs de la clinique</p>
            </div>
            <button class="btn-primary" onclick="openPopup()">
                <i class="fas fa-user-plus"></i> Nouvel Utilisateur
            </button>
        </div>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number stat-total"><%= totalUsers != null ? totalUsers : 0 %></div>
                <div class="stat-label">Total Utilisateurs</div>
            </div>
            <div class="stat-card">
                <div class="stat-number stat-admin"><%= totalAdmins != null ? totalAdmins : 0 %></div>
                <div class="stat-label">Administrateurs</div>
            </div>
            <div class="stat-card">
                <div class="stat-number stat-doctor"><%= totalDoctors != null ? totalDoctors : 0 %></div>
                <div class="stat-label">Médecins</div>
            </div>
            <div class="stat-card">
                <div class="stat-number stat-patient"><%= totalPatients != null ? totalPatients : 0 %></div>
                <div class="stat-label">Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-number stat-staff"><%=totalStaff%></div>
                <div class="stat-label">Staff</div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="users-table">
            <div class="table-header">
                <h2><i class="fas fa-list"></i> Liste des Utilisateurs</h2>
            </div>

            <% if (users != null && !users.isEmpty()) { %>
            <table>
                <thead>
                <tr>
                    <th>Utilisateur</th>
                    <th>Rôle</th>
                    <th>Type</th>
                    <th>Info</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (UserDTO user : users) {
                    String initial = user.getNom() != null && !user.getNom().isEmpty() ?
                            user.getNom().substring(0, 1).toUpperCase() : "U";
                %>
                <tr>
                    <td>
                        <div class="user-info">
                            <div class="user-avatar"><%= initial %></div>
                            <div class="user-details">
                                <h4><%= user.getNom() %></h4>
                                <p><%= user.getEmail() %></p>
                            </div>
                        </div>
                    </td>
                    <td>
                                    <span class="role-badge role-<%= user.getRole().name().toLowerCase() %>">
                                        <%= user.getRole().name() %>
                                    </span>
                    </td>
                    <td>
                        <% if (user.getTypeSpecifique() != null) { %>
                        <span class="type-badge"><%= user.getTypeSpecifique() %></span>
                        <% } %>
                    </td>
                    <td>
                        <% if (user.getInfoSupplementaire() != null && !user.getInfoSupplementaire().isEmpty()) { %>
                        <span class="info-badge"><%= user.getInfoSupplementaire() %></span>
                        <% } %>
                    </td>
                    <td>
                                    <span class="status-badge <%= user.isStatus() ? "status-active" : "status-inactive" %>">
                                        <%= user.isStatus() ? "ACTIF" : "INACTIF" %>
                                    </span>
                    </td>

                    <td>
                        <div class="actions-cell">
                            <!-- Bouton Édition -->
                            <a href="users?action=edit&id=<%= user.getId() %>"
                               class="btn-toggle"
                               style="background: var(--info); color: white;">
                                <i class="fas fa-edit"></i>
                            </a>

                            <a href="users?action=toggleStatus&id=<%= user.getId() %>"
                               class="btn-toggle"
                               onclick="return confirm('Êtes-vous sûr de vouloir <%= user.isStatus() ? "désactiver" : "activer" %> cet utilisateur ?')">
                                <i class="fas <%= user.isStatus() ? "fa-pause" : "fa-play" %>"></i>
                            </a>
                            <a href="users?action=delete&id=<%= user.getId() %>"
                               class="btn-delete"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer définitivement cet utilisateur ?')">
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
                <i class="fas fa-users"></i>
                <h3>Aucun utilisateur trouvé</h3>
                <p>Il n'y a aucun utilisateur enregistré dans le système</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Popup de création d'utilisateur -->
<div id="userPopup" class="popup-overlay">
    <div class="popup-content">
        <div class="popup-header">
            <h2><i class="fas fa-user-plus"></i> Nouvel Utilisateur</h2>
            <button class="close-btn" onclick="closePopup()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="popup-body">
            <form id="userForm" action="${pageContext.request.contextPath}/admin/users" method="post">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label for="nom" class="form-label required">Nom complet</label>
                    <input type="text" id="nom" name="nom" class="form-control" placeholder="Nom et prénom" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label required">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="email@clinique.com" required>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label required">Mot de passe</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Mot de passe sécurisé" required>
                </div>

                <div class="form-group">
                    <label for="role" class="form-label required">Rôle</label>
                    <select id="role" name="role" class="form-control" required onchange="toggleDynamicFields()">
                        <option value="">Sélectionnez un rôle</option>
                        <option value="PATIENT">Patient</option>
                        <option value="DOCTOR">Docteur</option>
                        <option value="STAFF">Staff Administratif</option>
                        <option value="ADMIN">Administrateur</option>
                    </select>
                </div>

                <!-- Champs dynamiques pour Patient -->
                <div id="patientFields" class="dynamic-fields">
                    <div class="field-group">
                        <label for="cin" class="form-label required">CIN</label>
                        <input type="text" id="cin" name="cin" class="form-control" placeholder="Numéro CIN">
                        <div class="form-help">Carte d'identité nationale</div>
                    </div>

                    <div class="field-group">
                        <label for="dateNaissance" class="form-label">Date de naissance</label>
                        <input type="date" id="dateNaissance" name="dateNaissance" class="form-control">
                    </div>

                    <div class="field-group">
                        <label for="sexe" class="form-label">Sexe</label>
                        <select id="sexe" name="sexe" class="form-control">
                            <option value="">Sélectionnez</option>
                            <option value="MASCULIN">Masculin</option>
                            <option value="FEMININ">Féminin</option>
                        </select>
                    </div>

                    <div class="field-group">
                        <label for="telephone" class="form-label">Téléphone</label>
                        <input type="tel" id="telephone" name="telephone" class="form-control" placeholder="+212 6XX XXX XXX">
                    </div>
                    <div class="field-group">
                        <label for="adresse" class="form-label">adresse</label>
                        <input type="text" id="adresse" name="adresse" class="form-control" placeholder="">
                    </div>

                    <div class="field-group">
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
                </div>

                <div id="doctorFields" class="dynamic-fields">
                    <div class="field-group">
                        <label for="matricule" class="form-label">Matricule</label>
                        <input type="text" id="matricule" name="matricule" class="form-control" placeholder="MAT2024001">
                        <div class="form-help">Généré automatiquement</div>
                    </div>

                    <div class="field-group">
                        <label for="titre" class="form-label">Titre</label>
                        <select id="titre" name="titre" class="form-control">
                            <option value="Dr.">Docteur</option>
                            <option value="Prof.">Professeur</option>
                            <option value="Ch.">Chef de service</option>
                        </select>
                    </div>
                </div>

                <!-- Message pour Staff -->
                <div id="staffMessage" class="staff-only" style="display: none;">
                    <h4><i class="fas fa-info-circle"></i> Information</h4>
                    <p>Le staff administratif peut gérer les patients mais pas les autres utilisateurs.</p>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="closePopup()">
                        Annuler
                    </button>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-user-plus"></i> Créer l'utilisateur
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    function openPopup() {
        document.getElementById('userPopup').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closePopup() {
        document.getElementById('userPopup').style.display = 'none';
        document.body.style.overflow = 'auto';
        resetForm();
    }

    function resetForm() {
        document.getElementById('userForm').reset();
        toggleDynamicFields();
    }

    function toggleDynamicFields() {
        const role = document.getElementById('role').value;
        const patientFields = document.getElementById('patientFields');
        const doctorFields = document.getElementById('doctorFields');
        const staffMessage = document.getElementById('staffMessage');
        patientFields.classList.remove('active');
        doctorFields.classList.remove('active');
        staffMessage.style.display = 'none';
        if (role === 'PATIENT') {
            patientFields.classList.add('active');
        } else if (role === 'DOCTOR') {
            doctorFields.classList.add('active');
            const matriculeField = document.getElementById('matricule');
            if (!matriculeField.value || matriculeField.value === '') {
                const now = new Date();
                const timestamp = now.getFullYear().toString().slice(-2) +
                    String(now.getMonth() + 1).padStart(2, '0') +
                    String(now.getDate()).padStart(2, '0') +
                    String(now.getHours()).padStart(2, '0') +
                    String(now.getMinutes()).padStart(2, '0');
                matriculeField.value = 'MAT' + timestamp;
            }
        } else if (role === 'STAFF') {
            staffMessage.style.display = 'block';
        }

        updateFieldRequirements(role);
    }

    function updateFieldRequirements(role) {
        const cinField = document.getElementById('cin');
        const matriculeField = document.getElementById('matricule');

        cinField.required = false;
        matriculeField.required = false;

        if (role === 'PATIENT') {
            cinField.required = true;
        } else if (role === 'DOCTOR') {
            matriculeField.required = true;
        }
    }


    document.getElementById('userPopup').addEventListener('click', function(e) {
        if (e.target === this) {
            closePopup();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closePopup();
        }
    });

    // Validation du formulaire
    document.getElementById('userForm').addEventListener('submit', function(e) {
        const role = document.getElementById('role').value;
        let isValid = true;

        if (role === 'PATIENT') {
            const cin = document.getElementById('cin').value;
            if (!cin.trim()) {
                alert('Le CIN est obligatoire pour un patient');
                isValid = false;
            }
        } else if (role === 'DOCTOR') {
            const matricule = document.getElementById('matricule').value;
            if (!matricule.trim()) {
                alert('Le matricule est obligatoire pour un docteur');
                isValid = false;
            }
        }

        if (isValid) {
            setTimeout(closePopup, 100);
        } else {
            e.preventDefault();
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        toggleDynamicFields();
    });
</script>
</body>
</html>