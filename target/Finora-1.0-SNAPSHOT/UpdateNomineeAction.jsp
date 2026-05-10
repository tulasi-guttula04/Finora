<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: Ensure the user is logged in [cite: 1, 80, 143]
    String phone = (String) session.getAttribute("phone"); 
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    // Capture form parameters from NomineeDetails.jsp
    String nomineeName = request.getParameter("n_name");
    String nomineeRelation = request.getParameter("n_relation");

    try {
        // Database connection using your scet credentials 
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        
        // Update the user's specific record with nominee information
        PreparedStatement ps = con.prepareStatement(
            "UPDATE USER_DETAILS SET NOMINEE_NAME = ?, NOMINEE_RELATION = ? WHERE PHONE = ?"
        );
        ps.setString(1, nomineeName);
        ps.setString(2, nomineeRelation);
        ps.setString(3, phone);
        
        int status = ps.executeUpdate();
        
        if (status > 0) {
            // Success feedback matching your other action files logic
            out.println("<script>");
            out.println("alert('Nominee Details Updated Successfully!');");
            out.println("window.location='NomineeDetails.jsp';");
            out.println("</script>");
        } else {
            out.println("<script>alert('Update Failed. Please try again.'); window.location='NomineeDetails.jsp';</script>");
        }
        
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>