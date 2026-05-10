<%@page import="java.sql.*"%>
<%@page import="SecurityUtil.SecurityUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String encryptedInput = SecurityUtil.encrypt(password);

    try {
        // Database connection using your credentials 
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        // Secure query using PreparedStatement
        PreparedStatement ps = con.prepareStatement("SELECT * FROM USER_DETAILS WHERE PHONE=? AND PASSWORD=? AND STATUS='Approved'");
        ps.setString(1, phone);
        ps.setString(2, encryptedInput);
        
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            // Store phone in session for UserDashboard.jsp [cite: 9]
            session.setAttribute("phone", phone);
            response.sendRedirect("UserDashboard.jsp");
        } else {
            out.println("<script>alert('Login Failed: Account not found or pending approval.'); window.location='index.html';</script>");
        }
        
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>