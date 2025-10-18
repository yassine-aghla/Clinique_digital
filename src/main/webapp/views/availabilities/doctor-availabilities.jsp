<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Disponibilités du Docteur - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .role-doctor { background: rgba(124, 205, 187, 0.3); color: white; }
        .role-patient { background: rgba(237, 248, 177, 0.3); color: var(--dark); }
        .role-staff { background: rgba(254, 196, 79, 0.3); color: var(--dark); }

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

        /* Content Area */
        .content {
            padding: 32px;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--shadow);
            margin-bottom: 24px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--light);
        }

        .card-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-title i {
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

        .card-title h2 {
            color: var(--dark);
            font-size: 18px;
            font-weight: 700;
        }

        .btn-primary {
            padding: 10px 20px;
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
            color: white;
        }

        .btn-outline {
            padding: 10px 20px;
            background: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
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

        .btn-outline:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        /* Doctor Info */
        .doctor-info-card {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-left: 4px solid var(--primary);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: white;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .info-content h4 {
            color: var(--dark);
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .info-content p {
            color: var(--gray);
            font-size: 13px;
            margin: 0;
        }

        /* Form Styles */
        .form-card {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-label {
            color: var(--dark);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }

        .form-control, .form-select {
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: var(--transition);
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
            outline: none;
        }

        .btn-success {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--success), #1e7b4c);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            height: fit-content;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 162, 95, 0.3);
            color: white;
        }

        /* Table Styles */
        .table-responsive {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .table {
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table thead th {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            font-weight: 600;
            padding: 16px 12px;
            border: none;
        }

        .table tbody td {
            padding: 16px 12px;
            vertical-align: middle;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .table tbody tr:hover {
            background: #f8fafc;
        }

        .time-slot {
            font-family: monospace;
            font-weight: 600;
            color: var(--dark);
        }

        .break-time {
            color: var(--gray);
            font-style: italic;
            font-size: 13px;
        }

        /* Badges */
        .badge {
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
        }

        .badge-danger {
            background: linear-gradient(135deg, #fecaca, #fca5a5);
            color: #991b1b;
        }

        /* Button Groups */
        .btn-group-sm {
            gap: 8px;
        }

        .btn-group-sm .btn {
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-warning {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: #92400e;
            border: none;
        }

        .btn-danger {
            background: linear-gradient(135deg, #fecaca, #fca5a5);
            color: #991b1b;
            border: none;
        }

        /* Weekly Summary */
        .weekly-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 16px;
        }

        .day-card {
            background: white;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
            border: 2px solid #e2e8f0;
            transition: var(--transition);
        }

        .day-card.available {
            border-color: var(--success);
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
        }

        .day-card.unavailable {
            border-color: #e2e8f0;
            background: #f8fafc;
        }

        .day-card h6 {
            color: var(--dark);
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .day-card .time-slot {
            font-size: 12px;
            color: var(--success);
            font-weight: 600;
        }

        .day-card .break-info {
            font-size: 11px;
            color: var(--gray);
            margin-top: 4px;
        }

        .day-card .unavailable-text {
            font-size: 12px;
            color: var(--gray);
            font-style: italic;
        }

        /* Mobile Menu Toggle */
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

        /* Responsive */
        @media (max-width: 1200px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .weekly-summary {
                grid-template-columns: repeat(2, 1fr);
            }

            .topbar-left h1 {
                font-size: 20px;
            }

            .btn-group-sm {
                flex-direction: column;
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
            <a href="${pageContext.request.contextPath}/doctors" class="nav-item">
                <i class="fas fa-user-md"></i>
                <span>Docteurs</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-title">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/availabilities" class="nav-item active">
                <i class="fas fa-clock"></i>
                <span>Disponibilités</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Users</span>
            </a>
            <a href="departments" class="nav-item">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="specialties" class="nav-item">
                <i class="fas fa-stethoscope"></i>
                <span>Spécialités</span>
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
            <h1>
                <i class="fas fa-calendar-alt me-2"></i>
                Disponibilités du Dr. ${doctor.nom}
            </h1>
            <p>Gérez les horaires de disponibilité du médecin</p>
        </div>
        <div class="topbar-right">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin/availabilities" class="btn-outline">
                <i class="fas fa-arrow-left me-1"></i>Retour
            </a>
        </div>
    </div>

    <!-- Content -->
    <div class="content">
        <!-- Messages d'alerte -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <!-- Informations du docteur -->
        <div class="card doctor-info-card">
            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-user-md"></i>
                    <h2>Informations du Docteur</h2>
                </div>
            </div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <div class="info-content">
                        <h4>Matricule</h4>
                        <p>${doctor.matricule}</p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-signature"></i>
                    </div>
                    <div class="info-content">
                        <h4>Titre</h4>
                        <p>${doctor.titre}</p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="info-content">
                        <h4>Email</h4>
                        <p>${doctor.email}</p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-stethoscope"></i>
                    </div>
                    <div class="info-content">
                        <h4>Spécialité</h4>
                        <p>${doctor.specialite.name}</p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-hospital"></i>
                    </div>
                    <div class="info-content">
                        <h4>Département</h4>
                        <p>${doctor.departement.name}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Formulaire d'ajout de disponibilité -->
        <div class="card form-card">
            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-plus-circle"></i>
                    <h2>Ajouter une disponibilité</h2>
                </div>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/availabilities/add" method="post">
                    <input type="hidden" name="doctorId" value="${doctor.id}">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="dayOfWeek" class="form-label">Jour</label>
                            <select class="form-select" id="dayOfWeek" name="dayOfWeek" required>
                                <option value="">Choisir un jour</option>
                                <c:forEach var="day" items="${daysOfWeek}">
                                    <option value="${day}">${day.frenchName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="startTime" class="form-label">Heure début</label>
                            <input type="time" class="form-control" id="startTime" name="startTime"
                                   value="09:00" required>
                        </div>
                        <div class="form-group">
                            <label for="endTime" class="form-label">Heure fin</label>
                            <input type="time" class="form-control" id="endTime" name="endTime"
                                   value="17:00" required>
                        </div>
                        <div class="form-group">
                            <label for="breakStart" class="form-label">Début pause</label>
                            <input type="time" class="form-control" id="breakStart" name="breakStart"
                                   value="12:00" required>
                        </div>
                        <div class="form-group">
                            <label for="breakEnd" class="form-label">Fin pause</label>
                            <input type="time" class="form-control" id="breakEnd" name="breakEnd"
                                   value="13:00" required>
                        </div>
                        <div class="form-group d-flex align-items-end">
                            <button type="submit" class="btn-success w-100">
                                <i class="fas fa-plus"></i> Ajouter
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tableau des disponibilités -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-list"></i>
                    <h2>Disponibilités définies</h2>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty availabilities}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Jour</th>
                                    <th>Heures de travail</th>
                                    <th>Pause</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="avail" items="${availabilities}">
                                    <tr>
                                        <td>
                                            <strong>${avail.dayOfWeek.frenchName}</strong>
                                        </td>
                                        <td class="time-slot">
                                                ${avail.startTime} - ${avail.endTime}
                                        </td>
                                        <td class="break-time time-slot">
                                                ${avail.breakStart} - ${avail.breakEnd}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${avail.available}">
                                                    <span class="badge badge-success">
                                                        <i class="fas fa-check me-1"></i>Disponible
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">
                                                        <i class="fas fa-times me-1"></i>Indisponible
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <!-- Formulaire pour modifier le statut -->
                                                <form action="${pageContext.request.contextPath}/admin/availabilities/update"
                                                      method="post" class="d-inline">
                                                    <input type="hidden" name="availabilityId" value="${avail.id}">
                                                    <input type="hidden" name="startTime" value="${avail.startTime}">
                                                    <input type="hidden" name="endTime" value="${avail.endTime}">
                                                    <input type="hidden" name="breakStart" value="${avail.breakStart}">
                                                    <input type="hidden" name="breakEnd" value="${avail.breakEnd}">
                                                    <c:choose>
                                                        <c:when test="${avail.available}">
                                                            <input type="hidden" name="available" value="false">
                                                            <button type="submit" class="btn btn-warning"
                                                                    title="Marquer comme indisponible">
                                                                <i class="fas fa-pause"></i> Suspendre
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="hidden" name="available" value="true">
                                                            <button type="submit" class="btn btn-success"
                                                                    title="Marquer comme disponible">
                                                                <i class="fas fa-play"></i> Activer
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>

                                                <!-- Formulaire de suppression -->
                                                <form action="${pageContext.request.contextPath}/admin/availabilities/delete"
                                                      method="post" class="d-inline"
                                                      onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette disponibilité ?')">
                                                    <input type="hidden" name="availabilityId" value="${avail.id}">
                                                    <input type="hidden" name="doctorId" value="${doctor.id}">
                                                    <button type="submit" class="btn btn-danger"
                                                            title="Supprimer cette disponibilité">
                                                        <i class="fas fa-trash"></i> Supprimer
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center">
                            <i class="fas fa-info-circle me-2"></i>
                            Aucune disponibilité définie pour ce docteur.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Résumé visuel -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-chart-bar"></i>
                    <h2>Résumé hebdomadaire</h2>
                </div>
            </div>
            <div class="card-body">
                <div class="weekly-summary">
                    <c:forEach var="day" items="${daysOfWeek}">
                        <c:set var="dayAvailability" value="${null}"/>
                        <c:forEach var="avail" items="${availabilities}">
                            <c:if test="${avail.dayOfWeek == day}">
                                <c:set var="dayAvailability" value="${avail}"/>
                            </c:if>
                        </c:forEach>

                        <div class="day-card ${dayAvailability != null && dayAvailability.available ? 'available' : 'unavailable'}">
                            <h6>${day.frenchName}</h6>
                            <c:choose>
                                <c:when test="${dayAvailability != null && dayAvailability.available}">
                                    <div class="time-slot">
                                            ${dayAvailability.startTime} - ${dayAvailability.endTime}
                                    </div>
                                    <div class="break-info">
                                        Pause: ${dayAvailability.breakStart} - ${dayAvailability.breakEnd}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="unavailable-text">Non disponible</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    // Validation des heures
    document.addEventListener('DOMContentLoaded', function() {
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const startTime = form.querySelector('input[name="startTime"]');
                const endTime = form.querySelector('input[name="endTime"]');
                const breakStart = form.querySelector('input[name="breakStart"]');
                const breakEnd = form.querySelector('input[name="breakEnd"]');

                if (startTime && endTime && startTime.value >= endTime.value) {
                    alert('L\'heure de fin doit être après l\'heure de début');
                    e.preventDefault();
                    return;
                }

                if (breakStart && breakEnd && breakStart.value >= breakEnd.value) {
                    alert('L\'heure de fin de pause doit être après l\'heure de début');
                    e.preventDefault();
                    return;
                }
            });
        });
    });
</script>
</body>
</html>