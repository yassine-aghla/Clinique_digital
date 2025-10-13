<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - MediPlan</title>
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

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            opacity: 0.05;
        }

        .stat-card.primary::before { background: var(--primary); }
        .stat-card.success::before { background: var(--success); }
        .stat-card.warning::before { background: var(--warning); }
        .stat-card.danger::before { background: var(--danger); }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow);
            border-color: var(--primary);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .stat-card.primary .stat-icon {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
        }
        .stat-card.success .stat-icon {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success);
        }
        .stat-card.warning .stat-icon {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: var(--warning);
        }
        .stat-card.danger .stat-icon {
            background: linear-gradient(135deg, #fecaca, #fca5a5);
            color: var(--danger);
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 700;
            padding: 6px 10px;
            border-radius: 8px;
        }

        .stat-trend.up {
            background: #d1fae5;
            color: #065f46;
        }

        .stat-trend.down {
            background: #fee2e2;
            color: #991b1b;
        }

        .stat-content h3 {
            font-size: 36px;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .stat-content p {
            color: var(--gray);
            font-size: 14px;
            font-weight: 500;
        }

        /* Main Grid */
        .main-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 24px;
            margin-bottom: 24px;
        }

        .card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--shadow);
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
        }

        /* Appointments */
        .appointments-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .appointment-item {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 20px;
            border-radius: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: var(--transition);
            border: 1px solid #e2e8f0;
        }

        .appointment-item:hover {
            transform: translateX(8px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.06);
            border-color: var(--primary);
        }

        .appointment-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .appointment-time {
            background: white;
            padding: 16px;
            border-radius: 12px;
            text-align: center;
            min-width: 80px;
            border: 2px solid var(--light);
        }

        .appointment-time .time {
            font-weight: 800;
            color: var(--primary);
            font-size: 18px;
            margin-bottom: 4px;
        }

        .appointment-time .date {
            font-size: 11px;
            color: var(--gray);
            font-weight: 600;
        }

        .appointment-details h4 {
            color: var(--dark);
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .appointment-details p {
            color: var(--gray);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-planned { background: #dbeafe; color: #1e40af; }
        .status-done { background: #d1fae5; color: #065f46; }
        .status-canceled { background: #fee2e2; color: #991b1b; }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            gap: 12px;
        }

        .quick-action-btn {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 18px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
            border: 1px solid #e2e8f0;
        }

        .quick-action-btn:hover {
            transform: translateX(8px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.06);
            border-color: var(--primary);
        }

        .quick-action-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .action-primary {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: var(--primary);
        }
        .action-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success);
        }
        .action-warning {
            background: linear-gradient(135deg, #fed7aa, #fde68a);
            color: var(--warning);
        }
        .action-info {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: var(--info);
        }

        .quick-action-text h4 {
            color: var(--dark);
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .quick-action-text p {
            color: var(--gray);
            font-size: 12px;
        }

        /* Activity Feed */
        .activity-feed {
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-height: 450px;
            overflow-y: auto;
            padding-right: 8px;
        }

        .activity-item {
            display: flex;
            gap: 16px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--light);
        }

        .activity-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .activity-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .activity-primary { background: #e0f2fe; color: var(--primary); }
        .activity-success { background: #d1fae5; color: var(--success); }
        .activity-warning { background: #fed7aa; color: var(--warning); }
        .activity-danger { background: #fecaca; color: var(--danger); }

        .activity-content {
            flex: 1;
        }

        .activity-content h4 {
            color: var(--dark);
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .activity-content p {
            color: var(--gray);
            font-size: 13px;
            line-height: 1.6;
        }

        .activity-time {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 6px;
            font-weight: 600;
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
        .sidebar::-webkit-scrollbar,
        .activity-feed::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }

        .activity-feed::-webkit-scrollbar-track {
            background: var(--light);
            border-radius: 10px;
        }

        .activity-feed::-webkit-scrollbar-thumb {
            background: #cbd5e1;
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
            <a href="" class="nav-item active">
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
            <a href="" class="nav-item">
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
            <h1>Tableau de Bord</h1>
            <p>Vue d'ensemble de la clinique MediPlan</p>
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
        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card primary">
                <div class="stat-header">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i> +12%
                    </div>
                </div>
                <div class="stat-content">
                    <h3>247</h3>
                    <p>Total Rendez-vous</p>
                </div>
            </div>

            <div class="stat-card success">
                <div class="stat-header">
                    <div class="stat-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i> +5%
                    </div>
                </div>
                <div class="stat-content">
                    <h3>48</h3>
                    <p>Docteurs Actifs</p>
                </div>
            </div>

            <div class="stat-card warning">
                <div class="stat-header">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i> +8%
                    </div>
                </div>
                <div class="stat-content">
                    <h3>1,342</h3>
                    <p>Patients Enregistrés</p>
                </div>
            </div>

            <div class="stat-card danger">
                <div class="stat-header">
                    <div class="stat-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-trend down">
                        <i class="fas fa-arrow-down"></i> -3%
                    </div>
                </div>
                <div class="stat-content">
                    <h3>23</h3>
                    <p>Rendez-vous Annulés</p>
                </div>
            </div>
        </div>

        <!-- Main Grid -->
        <div class="main-grid">
            <!-- Left Column -->
            <div class="left-column">
                <!-- Appointments Card -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-calendar-alt"></i>
                            <h2>Rendez-vous Récents</h2>
                        </div>
                        <a href="" class="btn-primary">
                            <i class="fas fa-plus"></i> Nouveau
                        </a>
                    </div>
                    <div class="appointments-list">
                        <div class="appointment-item">
                            <div class="appointment-info">
                                <div class="appointment-time">
                                    <div class="time">09:00</div>
                                    <div class="date">10 Oct</div>
                                </div>
                                <div class="appointment-details">
                                    <h4>Mohammed Alami</h4>
                                    <p><i class="fas fa-user-md"></i> Dr. Benali - Cardiologie</p>
                                </div>
                            </div>
                            <span class="status-badge status-planned">Planifié</span>
                        </div>
                        <div class="appointment-item">
                            <div class="appointment-info">
                                <div class="appointment-time">
                                    <div class="time">10:30</div>
                                    <div class="date">10 Oct</div>
                                </div>
                                <div class="appointment-details">
                                    <h4>Fatima Zahra</h4>
                                    <p><i class="fas fa-user-md"></i> Dr. Idrissi - Dermatologie</p>
                                </div>
                            </div>
                            <span class="status-badge status-done">Terminé</span>
                        </div>
                        <div class="appointment-item">
                            <div class="appointment-info">
                                <div class="appointment-time">
                                    <div class="time">14:00</div>
                                    <div class="date">11 Oct</div>
                                </div>
                                <div class="appointment-details">
                                    <h4>Hamza Boumnjel</h4>
                                    <p><i class="fas fa-user-md"></i> Dr. Aghlla - Dentiste</p>
                                </div>
                            </div>
                            <span class="status-badge status-planned">Planifié</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="right-column">
                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-bolt"></i>
                            <h2>Actions Rapides</h2>
                        </div>
                    </div>
                    <div class="quick-actions">
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon action-primary">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="quick-action-text">
                                <h4>Nouveau Patient</h4>
                                <p>Ajouter un patient</p>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon action-success">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div class="quick-action-text">
                                <h4>Planifier RDV</h4>
                                <p>Créer un rendez-vous</p>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon action-warning">
                                <i class="fas fa-file-medical"></i>
                            </div>
                            <div class="quick-action-text">
                                <h4>Notes Médicales</h4>
                                <p>Rédiger une note</p>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon action-info">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="quick-action-text">
                                <h4>Statistiques</h4>
                                <p>Voir les rapports</p>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- Activity Feed -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-list-alt"></i>
                            <h2>Activité Récente</h2>
                        </div>
                    </div>
                    <div class="activity-feed">
                        <div class="activity-item">
                            <div class="activity-icon activity-primary">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-content">
                                <h4>Nouveau patient enregistré</h4>
                                <p>Karim Benjelloun a créé son compte patient</p>
                                <div class="activity-time">Il y a 5 minutes</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon activity-success">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="activity-content">
                                <h4>Rendez-vous confirmé</h4>
                                <p>Dr. Idrissi a confirmé le rendez-vous de 14:30</p>
                                <div class="activity-time">Il y a 1 heure</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon activity-warning">
                                <i class="fas fa-file-medical-alt"></i>
                            </div>
                            <div class="activity-content">
                                <h4>Note médicale ajoutée</h4>
                                <p>Dr. Benali a rédigé une note pour Leila Mansouri</p>
                                <div class="activity-time">Il y a 2 heures</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon activity-danger">
                                <i class="fas fa-times-circle"></i>
                            </div>
                            <div class="activity-content">
                                <h4>Rendez-vous annulé</h4>
                                <p>Youssef Alami a annulé son rendez-vous de demain</p>
                                <div class="activity-time">Il y a 3 heures</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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