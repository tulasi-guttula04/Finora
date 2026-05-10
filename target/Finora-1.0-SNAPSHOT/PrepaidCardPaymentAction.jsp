<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: Ensure the user is logged in
    String phone = (String) session.getAttribute("phone"); 
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    // Capture parameters from the simulation pop-up 
    String amountStr = request.getParameter("amount");
    String merchant = request.getParameter("merchant");
    
    if (amountStr == null) {
        response.sendRedirect("PrepaidCard.jsp");
        return;
    }

    double spendAmount = Double.parseDouble(amountStr);
    Connection con = null;

    try {
        // Database connection using your scet credentials 
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        con.setAutoCommit(false); // Enable transaction management for safe banking

        // 1. Retrieve current balance and account number 
        PreparedStatement psBal = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
        psBal.setString(1, phone);
        ResultSet rsBal = psBal.executeQuery();

        if (rsBal.next()) {
            long userAcc = rsBal.getLong("ACCOUNT_NO");
            double currentBalance = rsBal.getDouble("BALANCE");

            // 2. Logic: If amount is less than or equal to balance, deduct 
            if (currentBalance >= spendAmount) {
                
                // Deduct from User Balance
                PreparedStatement psUpdate = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE - ? WHERE PHONE = ?");
                psUpdate.setDouble(1, spendAmount);
                psUpdate.setString(2, phone);
                psUpdate.executeUpdate();

                // 3. Log into TRANSACTIONS table for the history activity
                PreparedStatement psLog = con.prepareStatement(
                    "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
                );
                psLog.setLong(1, userAcc);
                psLog.setLong(2, 0); // 0 represents a POS/Merchant terminal
                psLog.setDouble(3, spendAmount);
                psLog.setString(4, "Card Swipe: " + merchant);
                psLog.executeUpdate();

                con.commit(); // Finalize the simulation
                out.println("<script>alert('Transaction Approved! ₹" + spendAmount + " charged at " + merchant + "'); window.location='PrepaidCard.jsp';</script>");
            } else {
                // 4. Logic: If amount is more than balance, reject
                con.rollback();
                out.println("<script>alert('Transaction Declined: Insufficient Funds!'); window.location='PrepaidCard.jsp';</script>");
            }
        }
        con.close();
    } catch (Exception e) {
        if (con != null) { try { con.rollback(); } catch(SQLException se) {} }
        out.println("Error processing card simulation: " + e.getMessage());
    }
%>