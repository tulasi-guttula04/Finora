<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | Admin Access</title>
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet">
    <link href="css/style.css" type="text/css" rel="stylesheet">
    <style>
        body { background: #1a1a1a; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .login-card { background: white; padding: 40px; border-radius: 15px; width: 400px; text-align: center; border-top: 8px solid #dc3545; }
    </style>
</head>
<body>
    <div class="login-card">
        <h3 style="font-weight: 900; color: #333;">ADMIN PORTAL</h3>
        <p class="text-muted">Enter administrative credentials to proceed</p>
        <hr>
        <form action="AdminAuthAction.jsp" method="post">
            <div class="form-group">
                <input type="password" name="adminPass" class="form-control" placeholder="Admin Password" required>
            </div>
            <button type="submit" class="btn btn-danger btn-block" style="font-weight: 700;">UNLOCK ACCESS</button>
        </form>
    </div>
</body>
</html>