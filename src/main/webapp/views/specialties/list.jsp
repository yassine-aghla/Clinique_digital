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
        }

        .page-title p {
            color: var(--gray);
            font-size: 16px;
        }

        .actions-container {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-bottom: 24px;
        }

        .search-form {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .search-input {
            padding: 10px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            width: 300px;
            font-size: 14px;
            transition: var(--transition);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
        }

        .search-btn {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: var(--transition);
        }

        .search-btn:hover {
            background: var(--primary-dark);
        }

        .specialties-table {
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
        }

        .table-header h2 {
            color: var(--dark);
            font-size: 18px;
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
            background: #f1f5f9;
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid #e2e8f0;
            font-size: 14px;
        }

        td {
            padding: 20px;
            border-bottom: 1px solid #e2e8f0;
            color: var(--dark);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background: #f8fafc;
        }

        .specialty-code {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            padding: 8px 12px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 12px;
            display: inline-block;
        }

        .specialty-name {
            font-weight: 600;
            color: var(--dark);
        }

        .specialty-description {
            color: var(--gray);
            font-size: 14px;
            line-height: 1.5;
        }

        .department-badge {
            background: #e0f2fe;
            color: #0369a1;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .doctors-count {
            background: #fef3c7;
            color: #92400e;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .actions-cell {
            display: flex;
            gap: 8px;
        }

        .btn-edit {
            padding: 8px 16px;
            background: var(--warning);
            color: var(--dark);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-edit:hover {
            background: #f59e0b;
            transform: translateY(-1px);
        }

        .btn-delete {
            padding: 8px 16px;
            background: var(--danger);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-delete:hover {
            background: #dc2626;
            transform: translateY(-1px);
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

        .stats-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
            margin-bottom: 24px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
            border-radius: 12px;
            background: #f8fafc;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: var(--success);
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 14px;
            color: var(--gray);
            font-weight: 600;
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
                <h1><i class="fas fa-stethoscope" style="color: var(--success); margin-right: 12px;"></i> Spécialités Médicales</h1>
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
                    <div class="stat-label">Départements</div>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="actions-container">
            <form action="specialties" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="searchTerm"
                       placeholder="Rechercher une spécialité..."
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
                    <th>Nom</th>
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
                                    out.print(description != null ? description : "");
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
                                <i class="fas fa-edit"></i> Modifier
                            </a>
                            <a href="specialties?action=delete&id=<%= spec.getId() %>" class="btn-delete"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer la spécialité <%= spec.getName() %> ? Cette action est irréversible.')">
                                <i class="fas fa-trash"></i> Supprimer
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
                <p>Commencez par créer votre première spécialité médicale</p>
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
</script>
</body>
</html>