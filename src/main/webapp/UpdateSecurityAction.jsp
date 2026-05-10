<%@page import="java.sql.*"%>
<%@page import="SecurityUtil.SecurityUtil"%>
<%
    String currentPhone = (String) session.getAttribute("phone");
    String newPass = request.getParameter("newPassword");
    String newEmail = request.getParameter("newEmail");
    String newPhone = request.getParameter("newPhone");
    String encryptedPassword = SecurityUtil.encrypt(newPass);
    

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        String query;
        PreparedStatement ps;
        
        if (newPass != null && !newPass.trim().isEmpty()) {
            query = "UPDATE USER_DETAILS SET PASSWORD = ?, EMAIL = ?, PHONE = ? WHERE PHONE = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, encryptedPassword);
            ps.setString(2, newEmail);
            ps.setString(3, newPhone);
            ps.setString(4, currentPhone);
        } else {
            query = "UPDATE USER_DETAILS SET EMAIL = ?, PHONE = ? WHERE PHONE = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, newEmail);
            ps.setString(2, newPhone);
            ps.setString(3, currentPhone);
        }
        
        int i = ps.executeUpdate();
        if (i > 0) {
            session.setAttribute("phone", newPhone); // Update session with new phone if changed
            out.println("<script>alert('Credentials Updated Successfully!'); window.location='AccountDetails.jsp';</script>");
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>