<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.clinique_digital.entities.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prendre un Rendez-vous - MediPlan</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c7fb8;
            --primary-dark: #1d5a82;
            --secondary: #7fcdbb;
            --success: #2ca25f;
            --white: #ffffff;
            --light: #f8fafc;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container-custom {
            max-width: 1200px;
            margin: 0 auto;
        }

        .appointment-wizard {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .wizard-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 30px;
            text-align: center;
        }

        .wizard-header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .wizard-steps {
            display: flex;
            justify-content: center;
            padding: 30px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .step {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 20px;
            position: relative;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            right: -20px;
            width: 40px;
            height: 2px;
            background: #cbd5e1;
            top: 50%;
            transform: translateY(-50%);
        }

        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            transition: all 0.3s;
        }

        .step.active .step-circle {
            background: var(--primary);
            box-shadow: 0 0 0 4px rgba(44, 127, 184, 0.2);
        }

        .step.completed .step-circle {
            background: var(--success);
        }

        .step-label {
            font-weight: 600;
            color: #64748b;
        }

        .step.active .step-label {
            color: var(--primary);
        }

        .wizard-content {
            padding: 40px;
        }

        .step-content {
            display: none;
        }

        .step-content.active {
            display: block;
            animation: fadeIn 0.5s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .specialty-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .specialty-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 25px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            border: 3px solid transparent;
        }

        .specialty-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: rgba(255, 255, 255, 0.1);
            transform: rotate(45deg);
            transition: all 0.5s;
        }

        .specialty-card:hover::before {
            top: -100%;
            right: -100%;
        }

        .specialty-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }

        .specialty-card.selected {
            border-color: #fbbf24;
            box-shadow: 0 0 0 4px rgba(251, 191, 36, 0.3);
        }

        .specialty-icon {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            margin-bottom: 15px;
        }

        .specialty-card h3 {
            color: white;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .specialty-card p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 14px;
            margin: 0;
        }

        .doctor-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            border: 2px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 15px;
        }

        .doctor-card:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow);
            transform: translateX(5px);
        }

        .doctor-card.selected {
            border-color: var(--primary);
            background: linear-gradient(135deg, rgba(44, 127, 184, 0.05), rgba(44, 127, 184, 0.1));
        }

        .doctor-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .doctor-info h4 {
            color: var(--primary-dark);
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .info-badge {
            display: inline-block;
            padding: 4px 12px;
            background: #e0f2fe;
            color: var(--primary);
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 8px;
            margin-bottom: 5px;
        }

        .calendar-section {
            margin-top: 30px;
        }

        .date-input {
            width: 100%;
            padding: 15px 20px;
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

        .slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 12px;
            margin-top: 20px;
        }

        .slot-button {
            padding: 15px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            color: #334155;
        }

        .slot-button:hover {
            border-color: var(--primary);
            background: rgba(44, 127, 184, 0.05);
        }

        .slot-button.selected {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        .wizard-actions {
            display: flex;
            justify-content: space-between;
            padding: 30px 40px;
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
        }

        .btn-wizard {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-prev {
            background: #e2e8f0;
            color: #334155;
        }

        .btn-prev:hover {
            background: #cbd5e1;
        }

        .btn-next, .btn-confirm {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        .btn-next:hover, .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(44, 127, 184, 0.3);
        }

        .summary-box {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-radius: 15px;
            padding: 30px;
            border: 2px solid #bae6fd;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #bae6fd;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-weight: 600;
            color: #0c4a6e;
        }

        .summary-value {
            color: #0369a1;
            font-weight: 700;
        }

        .loading {
            text-align: center;
            padding: 40px;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #e2e8f0;
            border-top: 4px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container-custom">
    <div class="appointment-wizard">
        <!-- Header -->
        <div class="wizard-header">
            <h1><i class="fas fa-calendar-check me-2"></i>Prendre un Rendez-vous</h1>
            <p>Réservez votre consultation en quelques étapes simples</p>
        </div>

        <!-- Steps -->
        <div class="wizard-steps">
            <div class="step active" data-step="1">
                <div class="step-circle">1</div>
                <div class="step-label">Spécialité</div>
            </div>
            <div class="step" data-step="2">
                <div class="step-circle">2</div>
                <div class="step-label">Médecin</div>
            </div>
            <div class="step" data-step="3">
                <div class="step-circle">3</div>
                <div class="step-label">Date & Heure</div>
            </div>
            <div class="step" data-step="4">
                <div class="step-circle">4</div>
                <div class="step-label">Confirmation</div>
            </div>
        </div>

        <!-- Content -->
        <div class="wizard-content">
            <!-- Step 1: Choisir Spécialité -->
            <div class="step-content active" id="step1">
                <h2 class="mb-4">Choisissez une spécialité</h2>
                <div class="specialty-grid">
                    <c:forEach var="specialty" items="${specialties}">
                        <div class="specialty-card" onclick="selectSpecialty(${specialty.id}, '${specialty.name}')">
                            <div class="specialty-icon">
                                <i class="fas fa-stethoscope"></i>
                            </div>
                            <h3>${specialty.name}</h3>
                            <p>${specialty.description}</p>
                            <p class="mt-2"><i class="fas fa-user-md me-1"></i>${specialty.doctorsCount} médecins</p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Step 2: Choisir Médecin -->
            <div class="step-content" id="step2">
                <h2 class="mb-4">Sélectionnez votre médecin</h2>
                <div id="doctorsList"></div>
            </div>

            <!-- Step 3: Choisir Date & Heure -->
            <div class="step-content" id="step3">
                <h2 class="mb-4">Choisissez la date et l'heure</h2>
                <div class="row">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Sélectionnez une date</label>
                        <input type="date" class="date-input" id="appointmentDate"
                               onchange="loadAvailableSlots()" min="${minDate}">
                    </div>
                </div>
                <div class="calendar-section">
                    <h5 class="mb-3"><i class="fas fa-clock me-2"></i>Créneaux disponibles (25 min + 5 min pause)</h5>
                    <div id="slotsContainer">
                        <p class="text-muted">Veuillez sélectionner une date pour voir les créneaux disponibles</p>
                    </div>
                </div>
            </div>

            <!-- Step 4: Confirmation -->
            <div class="step-content" id="step4">
                <h2 class="mb-4">Confirmez votre rendez-vous</h2>
                <div class="summary-box">
                    <div class="summary-item">
                        <span class="summary-label"><i class="fas fa-stethoscope me-2"></i>Spécialité</span>
                        <span class="summary-value" id="summarySpecialty"></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label"><i class="fas fa-user-md me-2"></i>Médecin</span>
                        <span class="summary-value" id="summaryDoctor"></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label"><i class="fas fa-calendar me-2"></i>Date</span>
                        <span class="summary-value" id="summaryDate"></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label"><i class="fas fa-clock me-2"></i>Heure</span>
                        <span class="summary-value" id="summaryTime"></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label"><i class="fas fa-hourglass-half me-2"></i>Durée</span>
                        <span class="summary-value">25 minutes</span>
                    </div>
                </div>

                <div class="mt-4">
                    <label class="form-label fw-bold">Motif de consultation (optionnel)</label>
                    <textarea class="form-control" id="appointmentReason" rows="3"
                              placeholder="Décrivez brièvement le motif de votre visite..."></textarea>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="wizard-actions">
            <button class="btn-wizard btn-prev" onclick="previousStep()" style="display: none;">
                <i class="fas fa-arrow-left"></i> Précédent
            </button>
            <div></div>
            <button class="btn-wizard btn-next" onclick="nextStep()">
                Suivant <i class="fas fa-arrow-right"></i>
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    let currentStep = 1;
    let selectedData = {
        specialtyId: null,
        specialtyName: null,
        doctorId: null,
        doctorName: null,
        date: null,
        time: null
    };


    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').min = today;
    });

    function selectSpecialty(id, name) {
        selectedData.specialtyId = id;
        selectedData.specialtyName = name;


        document.querySelectorAll('.specialty-card').forEach(card => {
            card.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');


        loadDoctors(id);
    }
    function loadDoctors(specialtyId) {
        const doctorsList = document.getElementById('doctorsList');
        doctorsList.innerHTML = '<div class="loading"><div class="spinner"></div><p>Chargement des médecins...</p></div>';

        fetch('${pageContext.request.contextPath}/api/doctors?specialtyId=' + specialtyId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Erreur réseau');
                }
                return response.json();
            })
            .then(doctors => {
                console.log('Doctors received:', doctors);

                if (doctors.length === 0) {
                    doctorsList.innerHTML = '<p class="text-center text-muted">Aucun médecin disponible pour cette spécialité</p>';
                    return;
                }

                let html = '';
                doctors.forEach(doctor => {

                    const nomInitial = doctor.nom ? doctor.nom.charAt(0).toUpperCase() : '?';
                    const nomComplet = doctor.nom || 'Nom inconnu';
                    const matricule = doctor.matricule || 'N/A';
                    const departement = doctor.departement || 'N/A';

                    html += '<div class="doctor-card" onclick="selectDoctor(' + doctor.id + ', \'' + nomComplet.replace(/'/g, "\\'") + '\')">' +
                        '<div class="doctor-avatar-large">' + nomInitial + '</div>' +
                        '<div class="doctor-info">' +
                        '<h4>Dr. ' + nomComplet + '</h4>' +
                        '<div>' +
                        '<span class="info-badge"><i class="fas fa-id-card me-1"></i>' + matricule + '</span>' +
                        '<span class="info-badge"><i class="fas fa-hospital me-1"></i>' + departement + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                });
                doctorsList.innerHTML = html;
            })
            .catch(error => {
                doctorsList.innerHTML = '<p class="text-danger">Erreur lors du chargement des médecins</p>';
                console.error('Error:', error);
            });
    }

    function selectDoctor(id, name) {
        selectedData.doctorId = id;
        selectedData.doctorName = name;

        document.querySelectorAll('.doctor-card').forEach(card => {
            card.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
    }

    function loadAvailableSlots() {
        const date = document.getElementById('appointmentDate').value;
        if (!date || !selectedData.doctorId) return;

        selectedData.date = date;
        const slotsContainer = document.getElementById('slotsContainer');
        slotsContainer.innerHTML = '<div class="loading"><div class="spinner"></div><p>Chargement des créneaux...</p></div>';


        const url = contextPath + '/appointments/available-slots?doctorId=' + selectedData.doctorId + '&date=' + date;
        console.log('Fetching URL:', url);

        fetch(url)
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Erreur réseau: ' + response.status);
                }
                return response.json();
            })
            .then(slots => {
                console.log('Slots received:', slots);

                if (slots.length === 0) {
                    slotsContainer.innerHTML = '<p class="text-center text-warning"><i class="fas fa-exclamation-circle me-2"></i>Aucun créneau disponible pour cette date</p>';
                    return;
                }

                let html = '<div class="slots-grid">';
                slots.forEach(slot => {
                    html += '<button class="slot-button" onclick="selectSlot(\'' + slot + '\')">' + slot + '</button>';
                });
                html += '</div>';
                slotsContainer.innerHTML = html;
            })
            .catch(error => {
                slotsContainer.innerHTML = '<p class="text-danger">Erreur lors du chargement des créneaux</p>';
                console.error('Error:', error);
            });
    }

    function selectSlot(time) {
        selectedData.time = time;

        document.querySelectorAll('.slot-button').forEach(btn => {
            btn.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
    }

    function nextStep() {

        if (currentStep === 1 && !selectedData.specialtyId) {
            alert('Veuillez sélectionner une spécialité');
            return;
        }
        if (currentStep === 2 && !selectedData.doctorId) {
            alert('Veuillez sélectionner un médecin');
            return;
        }
        if (currentStep === 3 && (!selectedData.date || !selectedData.time)) {
            alert('Veuillez sélectionner une date et une heure');
            return;
        }

        if (currentStep === 4) {
            confirmAppointment();
            return;
        }

        currentStep++;
        updateWizard();


        if (currentStep === 4) {
            document.getElementById('summarySpecialty').textContent = selectedData.specialtyName;
            document.getElementById('summaryDoctor').textContent = 'Dr. ' + selectedData.doctorName;
            document.getElementById('summaryDate').textContent = new Date(selectedData.date).toLocaleDateString('fr-FR');
            document.getElementById('summaryTime').textContent = selectedData.time;
        }
    }

    function previousStep() {
        if (currentStep > 1) {
            currentStep--;
            updateWizard();
        }
    }

    function updateWizard() {

        document.querySelectorAll('.step').forEach((step, index) => {
            const stepNum = index + 1;
            if (stepNum < currentStep) {
                step.classList.add('completed');
                step.classList.remove('active');
            } else if (stepNum === currentStep) {
                step.classList.add('active');
                step.classList.remove('completed');
            } else {
                step.classList.remove('active', 'completed');
            }
        });


        document.querySelectorAll('.step-content').forEach((content, index) => {
            content.classList.remove('active');
            if (index + 1 === currentStep) {
                content.classList.add('active');
            }
        });


        const prevBtn = document.querySelector('.btn-prev');
        const nextBtn = document.querySelector('.btn-next');

        prevBtn.style.display = currentStep > 1 ? 'flex' : 'none';

        if (currentStep === 4) {
            nextBtn.innerHTML = '<i class="fas fa-check me-2"></i>Confirmer le rendez-vous';
            nextBtn.classList.add('btn-confirm');
        } else {
            nextBtn.innerHTML = 'Suivant <i class="fas fa-arrow-right"></i>';
            nextBtn.classList.remove('btn-confirm');
        }
    }

    function confirmAppointment() {
        const reason = document.getElementById('appointmentReason').value;


        const nextBtn = document.querySelector('.btn-next');
        const originalText = nextBtn.innerHTML;
        nextBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Confirmation en cours...';
        nextBtn.disabled = true;

        const formData = new URLSearchParams();
        formData.append('doctorId', selectedData.doctorId);

        formData.append('date', selectedData.date);
        formData.append('time', selectedData.time);
        formData.append('reason', reason);

        console.log('Sending appointment data:', {
            doctorId: selectedData.doctorId,
            date: selectedData.date,
            time: selectedData.time,
            reason: reason
        });

        fetch(contextPath + '/appointments/create', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response redirected:', response.redirected);

                if (response.redirected) {
                    // Si le serveur a fait une redirection, suivre la redirection
                    window.location.href = response.url;
                    return;
                }

                if (response.ok) {
                    window.location.href = contextPath + '/appointments/my-appointments';
                    return;
                }

                return response.text().then(text => {
                    throw new Error('Erreur serveur: ' + text);
                });
            })
            .catch(error => {
                console.error('Error:', error);
                if (error.message.includes("déjà un rendez-vous programmé")) {
                    alert('Erreur: ' + error.message + '\nVeuillez choisir un autre créneau horaire.');
                } else {
                    alert('Erreur lors de la création du rendez-vous: ' + error.message);
                }
                nextBtn.innerHTML = originalText;
                nextBtn.disabled = false;
            });
    }
</script>
</body>
</html>