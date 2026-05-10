<%@page import="java.sql.*"%>
<%
    // Security check: Ensure user is logged in [cite: 144-145]
    String phone = (String) session.getAttribute("phone");
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    String tid = request.getParameter("tid");
    
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        // Update status back to OPEN and reset the reply field
        PreparedStatement ps = con.prepareStatement(
            "UPDATE SUPPORT_TICKETS SET STATUS = 'OPEN', ADMIN_REPLY = 'User re-opened this ticket' WHERE TICKET_ID = ?"
        );
        ps.setInt(1, Integer.parseInt(tid));
        
        int i = ps.executeUpdate();
        if (i > 0) {
            out.println("<script>alert('Ticket Re-opened. Our team will review it again.'); window.location='SupportTickets.jsp';</script>");
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>