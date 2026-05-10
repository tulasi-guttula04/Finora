<%@page import="java.sql.*"%>
<%
    if (session.getAttribute("adminRole") == null) {
        response.sendRedirect("AdminLogin.jsp");
        return; 
    }

    String tid = request.getParameter("tid");
    String reply = request.getParameter("adminReply");
    
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        // Update both the status and the custom reply message
        PreparedStatement ps = con.prepareStatement(
            "UPDATE SUPPORT_TICKETS SET STATUS = 'RESOLVED', ADMIN_REPLY = ? WHERE TICKET_ID = ?"
        );
        ps.setString(1, reply);
        ps.setInt(2, Integer.parseInt(tid));
        
        ps.executeUpdate();
        con.close();
        response.sendRedirect("AdminHelpDesk.jsp");
    } catch(Exception e) { 
        out.print("Error: " + e.getMessage()); 
    }
%>