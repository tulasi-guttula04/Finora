<%@page import="java.sql.*"%>
<%
    String phone = (String) session.getAttribute("phone"); 
    String issue = request.getParameter("issueType");
    String subject = request.getParameter("subject");
    String desc = request.getParameter("description");

    if (phone != null) {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver"); 
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet"); 
            
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO SUPPORT_TICKETS (USER_PHONE, SUBJECT, ISSUE_TYPE, DESCRIPTION) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, phone);
            ps.setString(2, subject);
            ps.setString(3, issue);
            ps.setString(4, desc);
            
            int i = ps.executeUpdate();
            if (i > 0) {
                out.println("<script>alert('Ticket Raised Successfully! Reference ID will appear in your history.'); window.location='SupportTickets.jsp';</script>"); 
            }
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage()); 
        }
    } else {
        response.sendRedirect("index.html"); 
    }
%>