<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return; 
    }
    String phone = (String) session.getAttribute("phone");
%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | Security Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; }
        .security-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 4em 0; color: white; text-align: center; margin-bottom: -5em; }
        .security-card { background: #fff; border-radius: 15px; padding: 3em; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #dc3545; margin-bottom: 3em; }
        .form-group label { font-weight: 700; color: #555; text-transform: uppercase; font-size: 0.85em; }
        .btn-update { background: #dc3545; color: white !important; padding: 12px 30px; border-radius: 5px; text-transform: uppercase; font-weight: 700; width: 100%; border: none; transition: 0.3s; }
        .btn-update:hover { background: #a71d2a; }
    </style>
</head>

<body>
    <div class="security-header">
        <div class="container">
            <h2>SECURITY CREDENTIALS</h2>
            <p>Update your password and registered contact information</p>
        </div>
    </div>
<br>
    <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <div class="security-card">
                    <form action="UpdateSecurityAction.jsp" method="post">
                        <h4 style="margin-bottom: 20px; color: #333; font-weight: 700;"><i class="fa fa-lock"></i> Authentication</h4>
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Leave blank to keep current">
                        </div>
                        <hr>
                        <h4 style="margin-bottom: 20px; color: #333; font-weight: 700;"><i class="fa fa-envelope"></i> Contact Information</h4>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="newEmail" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="text" name="newPhone" class="form-control" value="<%= phone %>" required>
                        </div>
                        <button type="submit" class="btn-update">Update Credentials</button>
                    </form>
                    <div class="text-center" style="margin-top: 20px;">
                        <a href="UserDashboard.jsp" style="color: #888; text-decoration: none;"><i class="fa fa-arrow-left"></i> Back to Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>