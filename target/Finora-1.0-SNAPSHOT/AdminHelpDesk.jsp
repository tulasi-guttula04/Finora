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
    <title>Finora Admin | Ticket Management</title>
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #026fbf;
            --danger: #dc3545;
            --success: #28a745;
            --warning: #f39c12;
            --bg-body: #f0f2f5;
        }

        body { 
            background: var(--bg-body); 
            font-family: 'Inter', sans-serif;
            color: #333;
            padding: 20px;
        }

        /* Dashboard Container */
        .admin-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .admin-card { 
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 20px; 
            padding: 40px; 
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        /* Header Styling */
        .dashboard-header {
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 40px;
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
        }

        .brand-title {
            font-weight: 800; 
            color: var(--danger);
            letter-spacing: -1px;
            margin: 0;
        }

        /* Modern Table */
        .table-container {
            border-radius: 12px;
            overflow: hidden;
            background: white;
        }

        .table thead {
            background: #f8f9fa;
        }

        .table thead th {
            border: none;
            padding: 15px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #777;
        }

        .ticket-row {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .ticket-row:hover { 
            background: #fdfdfe !important;
            transform: scale(1.005);
            box-shadow: inset 4px 0 0 var(--primary);
        }

        /* Status Badges */
        .status-pill {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 700;
            display: inline-block;
            text-align: center;
        }

        .status-open { background: #fff4e5; color: #b95000; }
        .status-resolved { background: #e6fcf5; color: #087f5b; }

        /* Buttons */
        .btn-modern {
            border-radius: 8px;
            padding: 8px 18px;
            font-weight: 600;
            transition: 0.3s;
            border: none;
        }

        .btn-resolve {
            background: var(--primary);
            color: white;
        }

        .btn-resolve:hover {
            background: #015fa3;
            box-shadow: 0 4px 12px rgba(2, 111, 191, 0.3);
        }

        /* Modal Customization */
        .modal-content {
            border-radius: 20px;
            border: none;
            overflow: hidden;
        }

        .modal-header {
            background: var(--primary);
            color: white;
            padding: 25px;
        }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <div class="admin-card">
            <div class="dashboard-header">
                <h2 class="brand-title"><i class="fa fa-ticket"></i> FINORA SUPPORT</h2>
                <div class="btn-group">
                    <a href="AdminDashboard.jsp" class="btn btn-default"><i class="fa fa-users"></i> Account Requests</a>
                    <a href="Logout.jsp" class="btn btn-danger btn-modern"><i class="fa fa-sign-out"></i> Logout</a>
                </div>
            </div>

            <div class="table-responsive table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Ticket ID</th>
                            <th>Contact</th>
                            <th>Category</th>
                            <th>Issue Summary</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver"); 
                                Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet"); 
                                Statement st = con.createStatement(); 
                                ResultSet rs = st.executeQuery("SELECT * FROM SUPPORT_TICKETS ORDER BY CREATED_AT DESC"); 
                                
                                while(rs.next()) { 
                                    String status = rs.getString("STATUS");
                                    int tid = rs.getInt("TICKET_ID");
                                    String subject = rs.getString("SUBJECT"); 
                        %>
                        <tr class="ticket-row">
                            <td style="font-weight: 700; color: var(--primary);">#TK<%= tid %></td>
                            <td><i class="fa fa-phone text-muted"></i> <%= rs.getString("USER_PHONE") %></td>
                            <td><span class="label label-info"><%= rs.getString("ISSUE_TYPE") %></span></td>
                            <td>
                                <div style="font-weight: 600;"><%= subject %></div>
                                <small class="text-muted"><%= rs.getString("DESCRIPTION") %></small>
                            </td>
                            <td>
                                <span class="status-pill <%= status.equals("OPEN") ? "status-open" : "status-resolved" %>">
                                    <i class="fa <%= status.equals("OPEN") ? "fa-clock-o" : "fa-check" %>"></i> <%= status %>
                                </span>
                            </td>
                            <td>
                                <% if(status.equals("OPEN")) { %>
                                    <button class="btn btn-resolve btn-modern" 
                                            onclick="openReplyModal('<%= tid %>', '<%= subject %>')">
                                        Process Ticket
                                    </button> 
                                <% } else { %>
                                    <span class="text-success"><i class="fa fa-check-circle"></i> Resolved</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } con.close(); 
                        } catch(Exception e) { out.print(e); } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="replyModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" style="font-weight: 800;"><i class="fa fa-paper-plane"></i> SEND RESPONSE</h4>
                </div>
                <form action="ResolveTicketAction.jsp" method="post">
                    <div class="modal-body" style="padding: 30px;">
                        <input type="hidden" name="tid" id="replyTid"> 
                        <p style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            <strong>Subject:</strong> <span id="replySubject" class="text-primary"></span> 
                        </p>
                        <div class="form-group">
                            <label style="font-weight: 700; color: #555; margin-bottom: 10px;">RESOLUTION MESSAGE</label>
                            <textarea name="adminReply" class="form-control" rows="5" required 
                                      placeholder="Type the response that the customer will receive..."
                                      style="border-radius: 10px; border: 2px solid #eee;"></textarea> 
                        </div>
                    </div>
                    <div class="modal-footer" style="border: none; padding-bottom: 30px;">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Discard</button>
                        <button type="submit" class="btn btn-resolve btn-modern" style="padding: 10px 30px;">Send & Close Ticket</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="js/jquery-2.2.3.min.js"></script> 
    <script src="js/bootstrap.js"></script> 
    <script>
        function openReplyModal(tid, subject) { 
            document.getElementById('replyTid').value = tid; 
            document.getElementById('replySubject').innerText = subject; 
            $('#replyModal').modal('show'); 
        }
    </script>
</body>
</html>