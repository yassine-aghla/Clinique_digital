<%@ page import="org.example.clinique_digital.entities.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Départements - MediPlan</title>
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

        /* Sidebar - Identique au dashboard */
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
        }

        .topbar-btn i {
            color: var(--gray);
            font-size: 18px;
        }

        /* Content */
        .content {
            padding: 32px;
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
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert i {
            font-size: 20px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Action Bar */
        .action-bar {
            background: white;
            padding: 24px;
            border-radius: 16px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--shadow);
        }

        .search-box {
            display: flex;
            gap: 12px;
            flex: 1;
            max-width: 500px;
        }

        .search-input {
            flex: 1;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: var(--transition);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.3);
        }

        .btn-secondary {
            background: var(--light);
            color: var(--dark);
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        /* Departments Grid */
        .departments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .department-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .department-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--primary), var(--primary-dark));
        }

        .department-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            border-color: var(--primary);
        }

        .department-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 16px;
        }

        .department-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 16px;
        }

        .department-code {
            background: #f1f5f9;
            color: var(--gray);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .department-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .department-description {
            color: var(--gray);
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .department-stats {
            display: flex;
            gap: 20px;
            padding-top: 16px;
            border-top: 1px solid #f1f5f9;
            margin-bottom: 16px;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stat-item i {
            color: var(--primary);
            font-size: 16px;
        }

        .stat-value {
            font-size: 18px;
            font-weight: 700;
            color: var(--dark);
        }

        .stat-label {
            font-size: 12px;
            color: var(--gray);
            margin-left: 4px;
        }

        .department-actions {
            display: flex;
            gap: 8px;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
            border-radius: 8px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: #78350f;
            border: none;
            flex: 1;
        }

        .btn-edit:hover {
            background: linear-gradient(135deg, #fdba74, #fcd34d);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(254, 215, 170, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, #fecaca, #fca5a5);
            color: #991b1b;
            border: none;
            flex: 1;
        }

        .btn-delete:hover {
            background: linear-gradient(135deg, #fca5a5, #f87171);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(254, 202, 202, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
        }

        .empty-state i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: var(--dark);
            font-size: 24px;
            margin-bottom: 12px;
        }

        .empty-state p {
            color: var(--gray);
            font-size: 16px;
            margin-bottom: 24px;
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

            .departments-grid {
                grid-template-columns: 1fr;
            }

            .action-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                max-width: 100%;
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
            <a href="dashboard" class="nav-item">
                <i class="fas fa-home"></i>
                <span>Tableau de Bord</span>
            </a>
            <a href="appointments" class="nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Rendez-vous</span>
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
            <a href="${pageContext.request.contextPath}/admin/availabilities" class="nav-item">
                <i class="fas fa-clock"></i>
                <span>Disponibilités</span>
            </a>
            <a href="departments" class="nav-item active">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="specialties" class="nav-item">
                <i class="fas fa-stethoscope"></i>
                <span>Spécialités</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <i class="fas fa-users-cog"></i>
                <span>Utilisateurs</span>
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
            <h1>Gestion des Départements</h1>
            <p>Gérer les départements de la clinique MediPlan</p>
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
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${successMessage}</span>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${errorMessage}</span>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Action Bar -->
        <div class="action-bar">
            <form action="departments" method="get" class="search-box">
                <input type="hidden" name="action" value="search">
                <input type="text" name="searchTerm" placeholder="Rechercher un département..."
                       value="${searchTerm}" class="search-input">
                <button type="submit" class="btn btn-secondary">
                    <i class="fas fa-search"></i>
                    Rechercher
                </button>
            </form>
            <a href="departments?action=new" class="btn btn-primary">
                <i class="fas fa-plus"></i>
                Nouveau Département
            </a>
        </div>

        <!-- Departments Grid -->
        <c:choose>
            <c:when test="${not empty departments}">
                <div class="departments-grid">
                    <c:forEach var="dept" items="${departments}">
                        <div class="department-card">
                            <div class="department-icon">
                                <i class="fas fa-hospital"></i>
                            </div>
                            <div class="department-header">
                                <div>
                                    <h3 class="department-title">${dept.name}</h3>
                                </div>
                                <span class="department-code">${dept.code}</span>
                            </div>
                            <p class="department-description">${dept.description}</p>
                            <div class="department-stats">
                                <div class="stat-item">
                                    <i class="fas fa-user-md"></i>
                                    <span class="stat-value">${dept.doctorsCount}</span>
                                    <span class="stat-label">Docteurs</span>
                                </div>
                            </div>
                            <div class="department-actions">
                                <a href="departments?action=edit&id=${dept.id}"
                                   class="btn btn-edit btn-sm">
                                    <i class="fas fa-edit"></i>
                                    Modifier
                                </a>
                                <a href="departments?action=delete&id=${dept.id}"
                                   class="btn btn-delete btn-sm"
                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce département?')">
                                    <i class="fas fa-trash"></i>
                                    Supprimer
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-hospital"></i>
                    <h3>Aucun département trouvé</h3>
                    <p>Commencez par créer votre premier département</p>
                    <a href="departments?action=new" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        Créer un département
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }

    // Auto-hide alerts after 5 seconds
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.animation = 'slideDown 0.3s ease reverse';
            setTimeout(() => alert.remove(), 300);
        });
    }, 5000);
</script>
</body>
</html>