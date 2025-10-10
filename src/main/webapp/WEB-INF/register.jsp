<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inscription - Clinique Digitale</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f7f8fc;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .register-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            width: 400px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            background: #28a745;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background: #218838;
        }
        .error, .success {
            text-align: center;
        }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Créer un compte</h2>

    <% String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) { %>
    <p class="error"><%= error %></p>
    <% } else if (success != null) { %>
    <p class="success"><%= success %></p>
    <% } %>

    <form action="register" method="post">
        <input type="text" name="nom" placeholder="Nom complet" required>
        <input type="email" name="email" placeholder="Adresse e-mail" required>
        <input type="password" name="password" placeholder="Mot de passe" required>
        <select name="role" required>
            <option value="PATIENT">Patient</option>
            <option value="DOCTOR">Docteur</option>
        </select>
        <button type="submit">S'inscrire</button>
    </form>

    <p style="text-align:center; margin-top:10px;">
        Déjà inscrit ? <a href="WEB-INF/login.jsp">Se connecter</a>
    </p>
</div>
</body>
</html>
