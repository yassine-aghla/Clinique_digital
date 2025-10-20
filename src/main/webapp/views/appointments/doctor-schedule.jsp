<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Planning - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c7fb8;
            --primary-dark: #1d5a82;
            --secondary: #7fcdbb;
            --success: #2ca25f;
            --warning: #fbbf24;
            --danger: #ef4444;
            --white: #ffffff;
            --light: #f8fafc;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container-custom {
            max-width: 1200px;
            margin: 0 auto;
        }

        .schedule-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .schedule-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 30px;
            text-align: center;
        }

        .schedule-header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .doctor-info-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
            backdrop-filter: blur(10px);
        }

        .date-selector {
            background: #f8fafc;
            padding: 25px;
            border-bottom: 1px solid #e2e8f0;
        }

        .date-input {
            max-width: 300px;
            padding: 12px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .date-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(44, 127, 184, 0.1);
        }

        .schedule-content {
            padding: 30px;
        }

        .appointments-list {
            max-height: 600px;
            overflow-y: auto;
        }

        .appointment-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 5px solid var(--primary);
            box-shadow: var(--shadow);
            transition: all 0.3s;
        }

        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .appointment-card.scheduled {
            border-left-color: var(--primary);
        }

        .appointment-card.confirmed {
            border-left-color: var(--success);
        }

        .appointment-card.completed {
            border-left-color: var(--secondary);
        }

        .appointment-card.cancelled {
            border-left-color: var(--danger);
            opacity: 0.7;
        }

        .appointment-time {
            font-size: 18px;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .appointment-patient {
            font-size: 16px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 5px;
        }

        .appointment-reason {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-scheduled {
            background: #e0f2fe;
            color: var(--primary);
        }

        .status-confirmed {
            background: #dcfce7;
            color: var(--success);
        }

        .status-completed {
            background: #ccfbf1;
            color: #0d9488;
        }

        .status-cancelled {
            background: #fee2e2;
            color: var(--danger);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #cbd5e1;
        }

        .stats-card {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }

        .stats-number {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stats-label {
            font-size: 14px;
            opacity: 0.9;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-confirm {
            background: var(--success);
            color: white;
        }

        .btn-cancel {
            background: var(--danger);
            color: white;
        }

        .btn-complete {
            background: var(--secondary);
            color: white;
        }

        .btn-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .time-slot {
            background: #f1f5f9;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
        }

        .time-slot-header {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 10px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e2e8f0;
        }
    </style>
</head>
<body>
<div class="container-custom">
    <div class="schedule-card">
        <!-- Header -->
        <div class="schedule-header">
            <h1><i class="fas fa-calendar-alt me-2"></i>Mon Planning Médical</h1>
            <p>Gérez vos rendez-vous et votre emploi du temps</p>

            <div class="doctor-info-card">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <div class="doctor-avatar" style="width: 60px; height: 60px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; font-weight: 700;">
                            ${doctor.nom.charAt(0)}
                        </div>
                    </div>
                    <div class="col">
                        <h4 class="mb-1">Dr. ${doctor.nom}</h4>
                        <p class="mb-0 opacity-75">
                            <i class="fas fa-stethoscope me-1"></i>
                            ${specialite != null ? specialite : 'Spécialité non définie'}
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Date Selector -->
        <div class="date-selector">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <label class="form-label fw-bold">Sélectionnez une date :</label>
                    <input type="date" class="date-input" id="selectedDate"
                           value="${selectedDate}"
                           onchange="changeDate(this.value)">
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group">
                        <button class="btn btn-outline-primary" onclick="changeDate('${selectedDate.minusDays(1)}')">
                            <i class="fas fa-chevron-left me-1"></i>Jour précédent
                        </button>
                        <button class="btn btn-outline-primary" onclick="changeDate('${LocalDate.now()}')">
                            Aujourd'hui
                        </button>
                        <button class="btn btn-outline-primary" onclick="changeDate('${selectedDate.plusDays(1)}')">
                            Jour suivant<i class="fas fa-chevron-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="schedule-content">
            <div class="row">
                <div class="col-md-9">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="mb-0">
                            <i class="fas fa-list me-2"></i>
                            Rendez-vous du ${selectedDate}
                        </h3>
                        <span class="badge bg-primary fs-6">${appointments.size()} rendez-vous</span>
                    </div>

                    <div class="appointments-list">
                        <c:if test="${empty appointments}">
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h4>Aucun rendez-vous programmé</h4>
                                <p>Vous n'avez pas de rendez-vous pour cette date.</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty appointments}">
                            <c:forEach var="appointment" items="${appointments}">
                                <div class="appointment-card ${appointment.status.name().toLowerCase()}">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <div class="appointment-time">
                                                <i class="fas fa-clock me-2"></i>
                                                    ${appointment.startTime} - ${appointment.endTime}
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="appointment-patient">
                                                <i class="fas fa-user me-2"></i>
                                                    ${appointment.patient.nom}
                                            </div>
                                            <c:if test="${not empty appointment.reason}">
                                                <div class="appointment-reason">
                                                    <i class="fas fa-comment me-2"></i>
                                                        ${appointment.reason}
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-3">
                                            <span class="status-badge status-${appointment.status.name().toLowerCase()}">
                                                <c:choose>
                                                    <c:when test="${appointment.status.name() == 'SCHEDULED'}">
                                                        <i class="fas fa-clock me-1"></i>Planifié
                                                    </c:when>
                                                    <c:when test="${appointment.status.name() == 'CONFIRMED'}">
                                                        <i class="fas fa-check me-1"></i>Confirmé
                                                    </c:when>
                                                    <c:when test="${appointment.status.name() == 'COMPLETED'}">
                                                        <i class="fas fa-check-circle me-1"></i>Terminé
                                                    </c:when>
                                                    <c:when test="${appointment.status.name() == 'CANCELLED'}">
                                                        <i class="fas fa-times me-1"></i>Annulé
                                                    </c:when>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <c:if test="${appointment.status.name() != 'CANCELLED' && appointment.status.name() != 'COMPLETED'}">
                                                <div class="btn-group btn-group-sm">
                                                    <c:if test="${appointment.status.name() == 'SCHEDULED'}">
                                                        <button class="btn-action btn-confirm"
                                                                onclick="updateAppointmentStatus(${appointment.id}, 'CONFIRMED')"
                                                                title="Confirmer le rendez-vous">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </c:if>
                                                    <button class="btn-action btn-complete"
                                                            onclick="updateAppointmentStatus(${appointment.id}, 'COMPLETED')"
                                                            title="Marquer comme terminé">
                                                        <i class="fas fa-flag-checkered"></i>
                                                    </button>
                                                    <button class="btn-action btn-cancel"
                                                            onclick="updateAppointmentStatus(${appointment.id}, 'CANCELLED')"
                                                            title="Annuler le rendez-vous">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number" id="scheduledCount">0</div>
                        <div class="stats-label">Planifiés</div>
                    </div>
                    <div class="stats-card" style="background: linear-gradient(135deg, var(--success), #16a34a);">
                        <div class="stats-number" id="confirmedCount">0</div>
                        <div class="stats-label">Confirmés</div>
                    </div>
                    <div class="stats-card" style="background: linear-gradient(135deg, var(--secondary), #0d9488);">
                        <div class="stats-number" id="completedCount">0</div>
                        <div class="stats-label">Terminés</div>
                    </div>
                    <div class="stats-card" style="background: linear-gradient(135deg, var(--danger), #dc2626);">
                        <div class="stats-number" id="cancelledCount">0</div>
                        <div class="stats-label">Annulés</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Calculer les statistiques
    function calculateStats() {
        const scheduled = document.querySelectorAll('.appointment-card.scheduled').length;
        const confirmed = document.querySelectorAll('.appointment-card.confirmed').length;
        const completed = document.querySelectorAll('.appointment-card.completed').length;
        const cancelled = document.querySelectorAll('.appointment-card.cancelled').length;

        document.getElementById('scheduledCount').textContent = scheduled;
        document.getElementById('confirmedCount').textContent = confirmed;
        document.getElementById('completedCount').textContent = completed;
        document.getElementById('cancelledCount').textContent = cancelled;
    }

    // Changer de date
    function changeDate(date) {
        window.location.href = contextPath + '/appointments/doctor-schedule?date=' + date;
    }

    function updateAppointmentStatus(appointmentId, status) {
        if (!confirm('Êtes-vous sûr de vouloir modifier le statut de ce rendez-vous ?')) {
            return;
        }

        console.log('Updating appointment:', appointmentId, 'to status:', status);

        const formData = new URLSearchParams();
        formData.append('appointmentId', appointmentId);
        formData.append('status', status);

        const button = event.target;
        const originalHTML = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        button.disabled = true;

        fetch(contextPath + '/appointments/update-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
            .then(response => {
                console.log('Response status:', response.status);

                if (response.ok) {
                    return response.json();
                } else {
                    return response.json().then(errorData => {
                        throw new Error(errorData.error || 'Erreur lors de la mise à jour');
                    });
                }
            })
            .then(data => {
                console.log('Success:', data);
                location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Erreur lors de la mise à jour du statut: ' + error.message);
                button.innerHTML = originalHTML;
                button.disabled = false;
            });
    }

    document.addEventListener('DOMContentLoaded', function() {
        calculateStats();
    });
</script>
</body>
</html>