<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | e-Statement Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; }
        .statement-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 4em 0; color: white; text-align: center; margin-bottom: -5em; }
        .statement-card { background: #fff; border-radius: 15px; padding: 3em; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; margin-bottom: 3em; }
        .form-group label { font-weight: 700; color: #555; text-transform: uppercase; font-size: 0.85em; }
        .btn-generate { background: #026fbf; color: white !important; padding: 12px 30px; border-radius: 5px; text-transform: uppercase; font-weight: 700; width: 100%; border: none; transition: 0.3s; }
    </style>
</head>

<body>
    <div class="statement-header">
        <div class="container">
            <h2>E-STATEMENT GENERATOR</h2>
            <p>Download official transaction records for your records</p>
        </div>
    </div>
<br>
    <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <div class="statement-card">
                    <form action="ViewStatement.jsp" method="post" target="_blank">
                        <div class="form-group">
                            <label>Start Date</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>End Date</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                        <p class="text-muted small"><i class="fa fa-info-circle"></i> This will generate a secure, print-ready document of all credits and debits.</p>
                        <button type="submit" class="btn-generate">Generate Statement</button>
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