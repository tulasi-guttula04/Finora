<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: Ensure user is logged in [cite: 568]
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return;
    }

    String bidStr = request.getParameter("bid");
    
    if (bidStr != null) {
        int bid = Integer.parseInt(bidStr);
        Connection con = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver"); 
            con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet"); 
            
            PreparedStatement ps = con.prepareStatement("DELETE FROM BENEFICIARIES WHERE BID = ?");
            ps.setInt(1, bid);
            
            int status = ps.executeUpdate();
            if (status > 0) {
                out.println("<script>alert('Beneficiary Removed'); window.location='FundTransfer.jsp';</script>");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (con != null) con.close();
        }
    } else {
        response.sendRedirect("FundTransfer.jsp");
    }
%>