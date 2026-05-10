<%@page import="java.sql.*, java.util.Random"%>
<%@page import="SecurityUtil.SecurityUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String name = request.getParameter("fullname");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String pan = request.getParameter("pan");
    String password = request.getParameter("password");
    String encryptedPassword = SecurityUtil.encrypt(password);
    
    Random rand = new Random();
    long accountNo = 100000000000L + (long)(rand.nextDouble() * 900000000000L);
    String sortCode = "40-02-61"; // Fixed Sort Code for Finora Digital Branch
    
    try {
        // Database connection using your credentials 
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        // Insert statement for new users
        PreparedStatement ps = con.prepareStatement("INSERT INTO USER_DETAILS (NAME, EMAIL, PHONE, PAN, PASSWORD, ACCOUNT_NO, SORT_CODE, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, pan);
        ps.setString(5, encryptedPassword);
        ps.setLong(6, accountNo);
        ps.setString(7, sortCode);
        ps.setString(8, "Pending");
        
        int i = ps.executeUpdate();
        if (i > 0) {
            out.println("<script>alert('Application Submitted! Please wait for Admin Approval.'); window.location='index.html';</script>");
        }
        
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>