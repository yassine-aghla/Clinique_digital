<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.clinique_digital.dto.SpecialtyDTO" %>
<%@ page import="org.example.clinique_digital.dto.DepartmentDTO" %>
<%@ page import="java.util.List" %>
<%
    SpecialtyDTO specialty = (SpecialtyDTO) request.getAttribute("specialty");
    List<DepartmentDTO> departments = (List<DepartmentDTO>) request.getAttribute("departments");
    boolean isEdit = specialty != null;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Modifier" : "Nouvelle" %> Spécialité - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>


        .form-container {
            background: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: var(--shadow);
            border: 1px solid #e2e8f0;
            max-width: 600px;
            margin: 0 auto;
        }

        .form-header {
            margin-bottom: 32px;
            text-align: center;
        }

        .form-header h1 {
            color: var(--dark);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .form-header p {
            color: var(--gray);
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 24px;
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
            border-color: var(--success);
            background: white;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f1f5f9;
        }

        .btn-secondary {
            padding: 12px 24px;
            background: #64748b;
            color: white;
            border: none;
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
            background: #475569;
            transform: translateY(-1px);
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

        .btn-primary {
            background: linear-gradient(135deg, var(--success), #059669);
        }

        .btn-primary:hover {
            box-shadow: 0 8px 16px rgba(16, 185, 129, 0.3);
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
            <h1><%= isEdit ? "Modifier la Spécialité" : "Nouvelle Spécialité" %></h1>
            <p><%= isEdit ? "Modifiez les informations de la spécialité existante" : "Ajoutez une nouvelle spécialité médicale" %></p>
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
        <div class="form-container">
            <div class="form-header">
                <h1>
                    <i class="fas fa-stethoscope" style="color: var(--success); margin-right: 12px;"></i>
                    <%= isEdit ? "Modifier la Spécialité" : "Créer une Nouvelle Spécialité" %>
                </h1>
                <p><%= isEdit ? "Modifiez les informations de la spécialité médicale" : "Ajoutez une nouvelle spécialité à votre clinique" %></p>
            </div>

            <form action="specialties" method="post">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= specialty.getId() %>">
                <% } %>

                <div class="form-group">
                    <label for="code" class="form-label required">Code de la Spécialité</label>
                    <input type="text" id="code" name="code"
                           value="<%= isEdit ? specialty.getCode() : "" %>"
                           class="form-control"
                           placeholder="Ex: CARD, DERM, PED"
                           pattern="[A-Z0-9]{2,10}"
                           title="2-10 caractères majuscules ou chiffres"
                           required>
                    <div class="form-help">Code unique en majuscules (2-10 caractères)</div>
                </div>

                <div class="form-group">
                    <label for="name" class="form-label required">Nom de la Spécialité</label>
                    <input type="text" id="name" name="name"
                           value="<%= isEdit ? specialty.getName() : "" %>"
                           class="form-control"
                           placeholder="Ex: Cardiologie, Dermatologie, Pédiatrie"
                           required>
                    <div class="form-help">Nom complet de la spécialité médicale</div>
                </div>

                <div class="form-group">
                    <label for="departmentId" class="form-label required">Département</label>
                    <select id="departmentId" name="departmentId" class="form-control" required>
                        <option value="">Sélectionnez un département</option>
                        <% if (departments != null) {
                            for (DepartmentDTO dept : departments) {
                                boolean selected = isEdit && specialty.getDepartmentId() != null &&
                                        specialty.getDepartmentId().equals(dept.getId());
                        %>
                        <option value="<%= dept.getId() %>" <%= selected ? "selected" : "" %>>
                            <%= dept.getCode() %> - <%= dept.getName() %>
                        </option>
                        <% }
                        } %>
                    </select>
                    <div class="form-help">Département auquel cette spécialité est rattachée</div>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <textarea id="description" name="description"
                              class="form-control"
                              rows="5"
                              placeholder="Décrivez les compétences et domaines d'expertise de cette spécialité..."><%= isEdit && specialty.getDescription() != null ? specialty.getDescription() : "" %></textarea>
                    <div class="form-help">Description détaillée des compétences de la spécialité</div>
                </div>

                <div class="form-actions">
                    <a href="specialties" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour à la liste
                    </a>
                    <button type="submit" class="btn-primary">
                        <% if (isEdit) { %>
                        <i class="fas fa-save"></i> Modifier la Spécialité
                        <% } else { %>
                        <i class="fas fa-plus"></i> Créer la Spécialité
                        <% } %>
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

    // Validation côté client
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const codeInput = document.getElementById('code');

        // Convertir le code en majuscules automatiquement
        codeInput.addEventListener('input', function() {
            this.value = this.value.toUpperCase();
        });

        // Empêcher les espaces dans le code
        codeInput.addEventListener('keypress', function(e) {
            if (e.key === ' ') {
                e.preventDefault();
            }
        });

        // Validation du formulaire
        form.addEventListener('submit', function(e) {
            const departmentSelect = document.getElementById('departmentId');
            if (departmentSelect.value === '') {
                e.preventDefault();
                alert('Veuillez sélectionner un département');
                departmentSelect.focus();
            }
        });
    });
</script>
</body>
</html>