<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = (String) session.getAttribute("phone");
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    String amountStr = request.getParameter("amount");
    double depositAmount = Double.parseDouble(amountStr);
    Connection con = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        con.setAutoCommit(false); 

        // 1. Get User Account Number
        PreparedStatement psUser = con.prepareStatement("SELECT ACCOUNT_NO FROM USER_DETAILS WHERE PHONE=?");
        psUser.setString(1, phone);
        ResultSet rsUser = psUser.executeQuery();

        if (rsUser.next()) {
            long accNo = rsUser.getLong("ACCOUNT_NO");

            // 2. Update Balance
            PreparedStatement psUpdate = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE + ? WHERE PHONE = ?");
            psUpdate.setDouble(1, depositAmount);
            psUpdate.setString(2, phone);
            psUpdate.executeUpdate();

            // 3. Log Transaction
            PreparedStatement psLog = con.prepareStatement(
                "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
            );
            psLog.setLong(1, 0); // 0 represents ATM/System Cash In
            psLog.setLong(2, accNo);
            psLog.setDouble(3, depositAmount);
            psLog.setString(4, "ATM Cash Deposit");
            psLog.executeUpdate();

            con.commit();
            out.println("<script>alert('Cash Deposited Successfully! ₹" + depositAmount + " added to your balance.'); window.location='UserDashboard.jsp';</script>");
        }
        con.close();
    } catch (Exception e) {
        if (con != null) try { con.rollback(); } catch(SQLException se) {}
        out.println("Error: " + e.getMessage());
    }
%>