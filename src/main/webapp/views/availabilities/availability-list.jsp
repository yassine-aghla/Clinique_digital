<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Disponibilités - MediPlan</title>
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

        /* Cards for doctors */
        .availability-card {
            transition: transform 0.2s;
            border-left: 4px solid var(--primary);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .availability-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        .day-badge {
            font-size: 0.8em;
            border-radius: 6px;
            padding: 4px 8px;
        }

        .doctor-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 1px solid #e2e8f0;
            height: 100%;
            display: grid;
            grid-template-columns: 1fr,
        }

        .doctor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            border-color: var(--primary);
        }

        .doctor-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
        }

        .doctor-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 18px;
        }

        .doctor-info h4 {
            color: var(--dark);
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .doctor-info p {
            color: var(--gray);
            font-size: 13px;
            margin: 0;
        }

        .doctor-details {
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .detail-item i {
            color: var(--primary);
            width: 16px;
        }

        .availability-section {
            margin-bottom: 20px;
        }

        .availability-section h6 {
            color: var(--gray);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .availability-section h6 i {
            color: var(--primary);
        }

        .availability-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .availability-badge {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .no-availability {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: var(--warning);
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-manage {
            width: 100%;
            padding: 10px 16px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-manage:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.3);
            color: white;
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

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .topbar-left h1 {
                font-size: 20px;
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
            <a href="${pageContext.request.contextPath}/departments" class="nav-item">
                <i class="fas fa-hospital"></i>
                <span>Départements</span>
            </a>
            <a href="${pageContext.request.contextPath}/specialties" class="nav-item">
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
            <h1>Gestion des Disponibilités</h1>
            <p>Gérez les disponibilités des médecins</p>
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
        <!-- Messages d'alerte -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <div class="row">
            <c:forEach var="doctor" items="${doctors}" varStatus="loop">
                <%-- Filtrage : Admin voit tout, Docteur ne voit que lui-même --%>
                <c:if test="${user.role == 'ADMIN' or (user.role == 'DOCTOR' and user.id == doctor.id)}">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="doctor-card">
                            <div class="doctor-header">
                                <div class="doctor-avatar">${doctor.nom.substring(0,1).toUpperCase()}</div>
                                <div class="doctor-info">
                                    <h4>Dr. ${doctor.nom}</h4>
                                    <p>${doctor.matricule}</p>
                                        <%-- Badge pour indiquer "vous" --%>
                                    <c:if test="${user.role == 'DOCTOR' and user.id == doctor.id}">
                                        <small class="text-success"><i class="fas fa-user me-1"></i>Vous</small>
                                    </c:if>
                                </div>
                            </div>

                            <div class="doctor-details">
                                <div class="detail-item">
                                    <i class="fas fa-stethoscope"></i>
                                    <span>
                                <c:choose>
                                    <c:when test="${not empty doctor.specialite}">
                                        ${doctor.specialite.name}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-warning">Non assigné</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-hospital"></i>
                                    <span>
                                <c:choose>
                                    <c:when test="${not empty doctor.departement}">
                                        ${doctor.departement.name}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-warning">Non assigné</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                                </div>
                            </div>

                            <!-- Disponibilités résumées -->
                            <div class="availability-section">
                                <h6><i class="fas fa-calendar-check"></i> Disponibilités</h6>
                                <div class="availability-badges">
                                    <c:choose>
                                        <c:when test="${not empty doctor.availabilities and doctor.availabilities.size() > 0}">
                                            <c:forEach var="avail" items="${doctor.availabilities}">
                                                <c:if test="${avail.available}">
                                            <span class="availability-badge">
                                                ${avail.dayOfWeek.frenchName}: ${avail.startTime} - ${avail.endTime}
                                            </span>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-availability">Aucune disponibilité définie</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Bouton Gérer les disponibilités avec contrôle d'accès -->
                            <c:choose>
                                <%-- Admin peut tout gérer --%>
                                <c:when test="${user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/availabilities/doctor/${doctor.id}" class="btn-manage">
                                        <i class="fas fa-edit me-1"></i>Gérer les disponibilités
                                    </a>
                                </c:when>

                                <%-- Docteur peut gérer ses propres disponibilités --%>
                                <c:when test="${user.role == 'DOCTOR' and user.id == doctor.id}">
                                    <a href="${pageContext.request.contextPath}/admin/availabilities/doctor/${doctor.id}" class="btn-manage"
                                       style="background: linear-gradient(135deg, var(--success), #059669);">
                                        <i class="fas fa-user-edit me-1"></i>Gérer mes disponibilités
                                    </a>
                                </c:when>

                                <%-- Autres cas ne devraient pas arriver grâce au filtrage --%>
                                <c:otherwise>
                                    <button class="btn-manage" disabled
                                            style="background: linear-gradient(135deg, var(--gray), #94a3b8); cursor: not-allowed; opacity: 0.6;">
                                        <i class="fas fa-eye me-1"></i>Consultation
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <c:if test="${empty doctors}">
            <div class="alert alert-info text-center">
                <i class="fas fa-info-circle me-2"></i>
                Aucun docteur trouvé.
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }
</script>
</body>
</html>