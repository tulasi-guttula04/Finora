<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Get the phone number of the user to be approved from the URL parameter
    String phone = request.getParameter("phone");
    
    // Check if phone is null to prevent errors
    if (phone != null && !phone.isEmpty()) {
        try {
            // 2. Load the Derby Driver and establish connection [cite: 4, 5]
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet"); 
            
            // 3. Prepare the update statement to change status to 'Approved'
            // This ensures the user can now pass the login check [cite: 1]
            PreparedStatement ps = con.prepareStatement("UPDATE USER_DETAILS SET STATUS = 'Approved' WHERE PHONE = ?");
            ps.setString(1, phone);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Success: Redirect back to the admin dashboard to see updated list
                out.println("<script>alert('User Approved Successfully!'); window.location='AdminDashboard.jsp';</script>");
            } else {
                // Failure: User might not exist or already updated
                out.println("<script>alert('Error: Approval failed.'); window.location='AdminDashboard.jsp';</script>");
            }
            
            // 4. Close resources [cite: 9]
            con.close();
            
        } catch (Exception e) {
            // Error handling [cite: 10]
            out.println("Database Error: " + e.getMessage());
        }
    } else {
        // Redirect if someone tries to access the page without a phone parameter
        response.sendRedirect("AdminDashboard.jsp");
    }
%>