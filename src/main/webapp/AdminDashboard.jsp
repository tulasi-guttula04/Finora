<%@page import="java.sql.*"%>
<%
    if (session.getAttribute("adminRole") == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Finora Admin | Account Approvals</title>
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #026fbf;
            --danger: #dc3545;
            --success: #28a745;
            --bg-body: #f0f2f5;
        }

        body { 
            background: var(--bg-body); 
            font-family: 'Inter', sans-serif;
            color: #333;
            padding: 20px;
        }

        .admin-wrapper {
            max-width: 1000px;
            margin: 0 auto;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .admin-card { 
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px; 
            padding: 40px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        .dashboard-header {
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 35px;
        }

        .brand-title {
            font-weight: 800; 
            color: #222;
            margin: 0;
            font-size: 24px;
        }

        .brand-title span { color: var(--primary); }

        .table-container {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }

        .table { margin-bottom: 0; }
        
        .table thead { background: #fcfcfd; }

        .table thead th {
            border: none;
            padding: 18px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #888;
        }

        .user-row {
            transition: 0.3s;
        }

        .user-row:hover {
            background: #f4f9ff !important;
        }

        .avatar-circle {
            width: 35px;
            height: 35px;
            background: #e9ecef;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: var(--primary);
            font-weight: bold;
        }

        .btn-approve {
            background: var(--success);
            color: white;
            border-radius: 10px;
            padding: 8px 20px;
            font-weight: 600;
            border: none;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-approve:hover {
            background: #218838;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .nav-btn {
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.2s;
        }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <div class="admin-card">
            <div class="dashboard-header">
                <h2 class="brand-title">Account <span>Requests</span></h2>
                <div>
                    <a href="AdminHelpDesk.jsp" class="btn btn-default nav-btn"><i class="fa fa-envelope"></i> Support Tickets</a>
                    <a href="Logout.jsp" class="btn btn-link text-danger" style="font-weight: 600;">Logout</a>
                </div>
            </div>

            <div class="table-responsive table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Applicant Name</th>
                            <th>Phone Number</th>
                            <th>PAN Details</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet"); 
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM USER_DETAILS WHERE STATUS = 'Pending'"); 
                                
                                boolean hasRequests = false;
                                while(rs.next()){ 
                                    hasRequests = true;
                                    String name = rs.getString("NAME");
                        %>
                        <tr class="user-row">
                            <td style="vertical-align: middle;">
                                <div class="avatar-circle"><%= name.substring(0,1).toUpperCase() %></div>
                                <span style="font-weight: 600;"><%= name %></span>
                            </td>
                            <td style="vertical-align: middle; color: #666;">
                                <i class="fa fa-phone-square"></i> <%= rs.getString("PHONE") %>
                            </td>
                            <td style="vertical-align: middle;">
                                <code style="background: #fff0f0; color: #c00;"><%= rs.getString("PAN") %></code>
                            </td>
                            <td class="text-center" style="vertical-align: middle;">
                                <a href="ApproveUser.jsp?phone=<%=rs.getString("PHONE")%>" class="btn-approve">
                                    <i class="fa fa-check"></i> Grant Access
                                </a>
                            </td>
                        </tr>
                        <% 
                                } 
                                if(!hasRequests) { 
                        %>
                        <tr>
                            <td colspan="4" class="text-center" style="padding: 50px; color: #999;">
                                <i class="fa fa-check-circle-o fa-3x" style="display: block; margin-bottom: 10px; color: #ddd;"></i>
                                No pending account requests at the moment.
                            </td>
                        </tr>
                        <%
                                }
                                con.close(); 
                            } catch (Exception e) { out.println("Error: " + e.getMessage()); } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>