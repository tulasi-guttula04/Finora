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
    <title>Finora | Help Desk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all"> 
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all"> 
    <link href="css/font-awesome.css" rel="stylesheet"> 
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet"> 
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; }
        .help-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 4em 0; color: white; text-align: center; margin-bottom: -5em; } 
        .ticket-card { background: #fff; border-radius: 15px; padding: 2.5em; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; margin-bottom: 2em; } 
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.8em; font-weight: 700; text-transform: uppercase; }
        .bg-open { background: #fff3cd; color: #856404; }
        .bg-resolved { background: #d4edda; color: #155724; }
    </style>
</head>

<body>
    <div class="help-header">
        <div class="container">
            <h2 style="font-weight: 700; letter-spacing: 1px;">FINORA HELP DESK</h2>
            <p style="opacity: 0.8;">Raise a ticket and our elite support team will assist you shortly</p>
        </div>
    </div>
<br>
    <div class="container">
        <div class="row">
            <div class="col-md-5">
                <div class="ticket-card">
                    <h4 style="font-weight: 700; color: #333; margin-bottom: 20px;">New Support Request</h4>
                    <form action="RaiseTicketAction.jsp" method="post">
                        <div class="form-group">
                            <label style="font-weight: 700; font-size: 0.8em; color: #888;">ISSUE CATEGORY</label>
                            <select name="issueType" class="form-control">
                                <option>Transaction Failure</option>
                                <option>Card Security</option>
                                <option>Loan Inquiry</option>
                                <option>Profile Update</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label style="font-weight: 700; font-size: 0.8em; color: #888;">SUBJECT</label>
                            <input type="text" name="subject" class="form-control" placeholder="Brief summary" required>
                        </div>
                        <div class="form-group">
                            <label style="font-weight: 700; font-size: 0.8em; color: #888;">DESCRIPTION</label>
                            <textarea name="description" class="form-control" rows="4" placeholder="Explain your issue in detail..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block" style="background: #026fbf; padding: 12px; font-weight: 700;">SUBMIT TICKET</button>
                    </form>
                </div>
            </div>

            <div class="col-md-7">
                <div class="ticket-card" style="border-top-color: #28a745;">
                    <h4 style="font-weight: 700; color: #333; margin-bottom: 20px;">My Support History</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr style="color: #888; font-size: 0.85em;">
                                    <th>ID</th>
                                    <th>Subject</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Class.forName("org.apache.derby.jdbc.ClientDriver"); 
                                        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet"); 
                                        PreparedStatement ps = con.prepareStatement("SELECT * FROM SUPPORT_TICKETS WHERE USER_PHONE = ? ORDER BY CREATED_AT DESC");
                                        ps.setString(1, phone);
                                        ResultSet rs = ps.executeQuery();
                                        boolean hasTickets = false;
                                        while(rs.next()) {
                                            hasTickets = true;
                                            String status = rs.getString("STATUS");
                                %>
                                <%-- Update the ticket description area in SupportTickets.jsp --%>
                                <%-- Update the ticket entry area in SupportTickets.jsp --%>
                                <tr class="ticket-row">
                                    <td style="font-weight: 700; color: #026fbf;">#TK<%= rs.getInt("TICKET_ID") %></td>
                                    <td>
                                        <strong><%= rs.getString("SUBJECT") %></strong><br>
                                        <small class="text-muted"><%= rs.getString("DESCRIPTION") %></small>

                                        <%-- Conditional display for Admin Response --%>
                                        <% if(rs.getString("ADMIN_REPLY") != null && !rs.getString("ADMIN_REPLY").equals("No reply yet")) { %>
                                            <div style="background: #f0f7ff; padding: 12px; border-left: 4px solid #026fbf; margin-top: 10px; border-radius: 5px;">
                                                <i class="fa fa-reply" style="color: #026fbf; margin-right: 8px;"></i>
                                                <strong>Finora Support Response:</strong><br>
                                                <span style="color: #333;"><%= rs.getString("ADMIN_REPLY") %></span>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td><span class="status-badge <%= rs.getString("STATUS").equals("OPEN") ? "bg-open" : "bg-resolved" %>"><%= rs.getString("STATUS") %></span></td>
                                    <td style="font-size: 0.85em; color: #999;"><%= rs.getDate("CREATED_AT") %></td>
                                    <%-- Update the Action or Status column in SupportTickets.jsp --%>
                                    <td>
                                        <% if(rs.getString("STATUS").equals("RESOLVED")) { %>
                                            <form action="ReopenTicketAction.jsp" method="post" onsubmit="return confirm('Do you want to re-open this issue?');">
                                                <input type="hidden" name="tid" value="<%= rs.getInt("TICKET_ID") %>">
                                                <button type="submit" class="btn btn-xs btn-warning">
                                                    <i class="fa fa-refresh"></i> Re-open
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="status-badge bg-open">OPEN</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } con.close(); if(!hasTickets) { %>
                                    <tr><td colspan="4" class="text-center" style="padding: 30px; color: #bbb;">No tickets raised yet.</td></tr>
                                <% } } catch(Exception e) { } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="text-center">
                    <a href="AdditionalServices.jsp" style="color: #888; text-decoration: none;"><i class="fa fa-arrow-left"></i> Back to Services</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>