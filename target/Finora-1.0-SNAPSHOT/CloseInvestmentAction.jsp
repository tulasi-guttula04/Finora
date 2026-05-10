<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = (String) session.getAttribute("phone");
    int tid = Integer.parseInt(request.getParameter("tid"));
    double amount = Double.parseDouble(request.getParameter("amount"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
        con.setAutoCommit(false);

        // 1. Move money back to the Liquid Balance
        PreparedStatement psUpdate = con.prepareStatement(
            "UPDATE USER_DETAILS SET BALANCE = BALANCE + ? WHERE PHONE = ?"
        );
        psUpdate.setDouble(1, amount);
        psUpdate.setString(2, phone);
        psUpdate.executeUpdate();

        // 2. Remove the investment record from Transactions
        PreparedStatement psDelete = con.prepareStatement("DELETE FROM TRANSACTIONS WHERE TID = ?");
        psDelete.setInt(1, tid);
        psDelete.executeUpdate();

        con.commit();
        out.println("<script>alert('Investment Closed! ₹" + amount + " has been returned to your liquid balance.'); window.location='Deposits.jsp';</script>");
        con.close();
    } catch(Exception e) { 
        out.println("Error: " + e.getMessage()); 
    }
%>