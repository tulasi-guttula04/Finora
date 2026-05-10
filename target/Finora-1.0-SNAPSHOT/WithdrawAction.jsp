<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = (String) session.getAttribute("phone");
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    String amountStr = request.getParameter("amount");
    double withdrawAmount = Double.parseDouble(amountStr);
    Connection con = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        con.setAutoCommit(false); 

        // 1. Check current balance before allowing withdrawal
        PreparedStatement psUser = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
        psUser.setString(1, phone);
        ResultSet rsUser = psUser.executeQuery();

        if (rsUser.next()) {
            long accNo = rsUser.getLong("ACCOUNT_NO");
            double currentBalance = rsUser.getDouble("BALANCE");

            // 2. Logic Gate: Ensure balance does not go negative
            if (currentBalance >= withdrawAmount) {
                // Deduct from Balance
                PreparedStatement psUpdate = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE - ? WHERE PHONE = ?");
                psUpdate.setDouble(1, withdrawAmount);
                psUpdate.setString(2, phone);
                psUpdate.executeUpdate();

                // 3. Log into TRANSACTIONS table
                PreparedStatement psLog = con.prepareStatement(
                    "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
                );
                psLog.setLong(1, accNo);
                psLog.setLong(2, 0); // 0 represents ATM terminal
                psLog.setDouble(3, withdrawAmount);
                psLog.setString(4, "ATM Cash Withdrawal");
                psLog.executeUpdate();

                con.commit();
                out.println("<script>alert('Withdrawal Successful! ₹" + withdrawAmount + " dispensed.'); window.location='UserDashboard.jsp';</script>");
            } else {
                // Prevent negative balance
                con.rollback();
                out.println("<script>alert('Transaction Declined: Insufficient Funds!'); window.location='UserDashboard.jsp';</script>");
            }
        }
        con.close();
    } catch (Exception e) {
        if (con != null) try { con.rollback(); } catch(SQLException se) {}
        out.println("Error: " + e.getMessage());
    }
%>