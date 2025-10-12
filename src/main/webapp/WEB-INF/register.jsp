<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - MediPlan</title>
    <style>
        :root {
            --primary: #2c7fb8;
            --primary-dark: #1d5a82;
            --secondary: #7fcdbb;
            --light: #f7f7f7;
            --dark: #333;
            --success: #2ca25f;
            --danger: #e34a33;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .register-container {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 480px;
            overflow: hidden;
        }

        .register-header {
            background: var(--primary);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 1rem;
        }

        .logo-icon {
            font-size: 2rem;
        }

        .logo-text {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .register-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            opacity: 0.9;
        }

        .register-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 127, 184, 0.1);
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }

        .error {
            background-color: #ffeaea;
            color: var(--danger);
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            text-align: center;
            border-left: 4px solid var(--danger);
        }

        .success {
            background-color: #e8f7ef;
            color: var(--success);
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            text-align: center;
            border-left: 4px solid var(--success);
        }

        .register-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e1e5e9;
        }

        .register-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .register-footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .register-container {
                max-width: 100%;
            }

            .register-header {
                padding: 1.5rem;
            }

            .register-body {
                padding: 1.5rem;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <div class="logo">
            <i class="fas fa-hospital-alt logo-icon"></i>
            <span class="logo-text">MediPlan</span>
        </div>
        <h2>Créer votre compte MediPlan</h2>
    </div>

    <div class="register-body">
        <% String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) { %>
        <div class="error">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } else if (success != null) { %>
        <div class="success">
            <i class="fas fa-check-circle"></i> <%= success %>
        </div>
        <% } %>

        <form action="register" method="post">
            <div class="form-group">
                <label for="nom">Nom complet</label>
                <input type="text" id="nom" name="nom" class="form-control" placeholder="Votre nom complet" required>
            </div>

            <div class="form-group">
                <label for="email">Adresse e-mail</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="votre@email.com" required>
            </div>

            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Créez un mot de passe sécurisé" required>
            </div>

            <div class="form-group">
                <label for="role">Type de compte</label>
                <select id="role" name="role" class="form-control" required>
                    <option value="">Sélectionnez votre profil</option>
                    <option value="PATIENT">Patient</option>
                    <option value="DOCTOR">Docteur</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="fas fa-user-plus"></i> Créer mon compte
            </button>
        </form>

        <div class="register-footer">
            <p>Déjà inscrit ? <a href="login">Se connecter</a></p>
        </div>
    </div>
</div>
</body>
</html>