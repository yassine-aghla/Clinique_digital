<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c7fb8;
            --primary-dark: #1d5a82;
            --success: #2ca25f;
            --warning: #fec44f;
            --danger: #e34a33;
            --gray: #64748b;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(44, 127, 184, 0.3);
        }

        .page-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .appointment-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-left: 5px solid var(--primary);
            transition: all 0.3s;
        }

        .appointment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .doctor-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: 700;
        }

        .doctor-info h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .doctor-info p {
            color: var(--gray);
            font-size: 14px;
            margin: 0;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-scheduled {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-confirmed {
            background: #d1fae5;
            color: #065f46;
        }

        .status-completed {
            background: #e0e7ff;
            color: #4338ca;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .detail-box {
            background: #f8fafc;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
        }

        .detail-box i {
            color: var(--primary);
            font-size: 20px;
            margin-bottom: 8px;
        }

        .detail-label {
            font-size: 12px;
            color: var(--gray);
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 16px;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .appointment-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-cancel {
            background: #fee2e2;
            color: #991b1b;
        }

        .btn-cancel:hover {
            background: #fecaca;
            transform: translateY(-2px);
        }

        .btn-new {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 15px 30px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(44, 127, 184, 0.3);
        }

        .btn-new:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .empty-state i {
            font-size: 80px;
            color: #cbd5e1;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: var(--gray);
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-calendar-alt me-3"></i>Mes Rendez-vous</h1>
        <p>Gérez vos consultations médicales</p>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/appointments" class="btn-new">
            <i class="fas fa-plus-circle"></i>
            Nouveau Rendez-vous
        </a>
    </div>

    <c:choose>
        <c:when test="${empty appointments}">
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h3>Aucun rendez-vous</h3>
                <p class="text-muted">Vous n'avez pas encore de rendez-vous programmés</p>
                <a href="${pageContext.request.contextPath}/appointments" class="btn-new mt-3">
                    <i class="fas fa-calendar-plus"></i>
                    Prendre un rendez-vous
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="appointment" items="${appointments}">
                <div class="appointment-card">
                    <div class="appointment-header">
                        <div class="doctor-section">
                            <div class="doctor-avatar">
                                    ${appointment.doctor.nom.substring(0,1).toUpperCase()}
                            </div>
                            <div class="doctor-info">
                                <h3>Dr. ${appointment.doctor.nom}</h3>
                                <p>
                                    <i class="fas fa-stethoscope me-1"></i>
                                        ${appointment.doctor.specialite.name}
                                </p>
                            </div>
                        </div>
                        <span class="status-badge status-${appointment.status.toString().toLowerCase()}">
                                ${appointment.status.frenchName}
                        </span>
                    </div>

                    <div class="appointment-details">
                        <div class="detail-box">
                            <i class="fas fa-calendar"></i>
                            <div class="detail-label">Date</div>
                            <div class="detail-value">${appointment.appointmentDate}</div>
                        </div>
                        <div class="detail-box">
                            <i class="fas fa-clock"></i>
                            <div class="detail-label">Heure</div>
                            <div class="detail-value">${appointment.startTime} - ${appointment.endTime}</div>
                        </div>
                        <div class="detail-box">
                            <i class="fas fa-hourglass-half"></i>
                            <div class="detail-label">Durée</div>
                            <div class="detail-value">25 minutes</div>
                        </div>

                    </div>

                    <c:if test="${not empty appointment.reason}">
                        <div class="detail-box mb-3">
                            <i class="fas fa-notes-medical"></i>
                            <div class="detail-label">Motif de consultation</div>
                            <div class="detail-value" style="font-size: 14px; font-weight: 400;">
                                    ${appointment.reason}
                            </div>
                        </div>
                    </c:if>

                    <div class="appointment-actions">
                        <c:if test="${appointment.status.toString() == 'SCHEDULED' || appointment.status.toString() == 'CONFIRMED'}">
                            <button class="btn-action btn-cancel"
                                    onclick="cancelAppointment(${appointment.id})">
                                <i class="fas fa-times-circle"></i>
                                Annuler
                            </button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Retour au tableau de bord
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function cancelAppointment(appointmentId) {
        if (confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/appointments/cancel';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = appointmentId;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>