<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = (String) session.getAttribute("phone");
    if (phone == null) {
        response.sendRedirect("index.html");
        return;
    }

    String loanType = request.getParameter("loanType");
    String amountStr = request.getParameter("loanAmount");
    double requestedAmount = Double.parseDouble(amountStr);
    Connection con = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        con.setAutoCommit(false); 

        // 1. Fetch current balance and current used limit
        PreparedStatement psUser = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE, USED_LOAN_LIMIT FROM USER_DETAILS WHERE PHONE=?");
        psUser.setString(1, phone);
        ResultSet rsUser = psUser.executeQuery();

        if (rsUser.next()) {
            long accNo = rsUser.getLong("ACCOUNT_NO");
            double currentBalance = rsUser.getDouble("BALANCE");
            double usedLimit = rsUser.getDouble("USED_LOAN_LIMIT");
            double totalEligibleLimit = currentBalance * 100; // 100x Balance

            // 2. Validate against REMAINING limit
            if ((usedLimit + requestedAmount) <= totalEligibleLimit) {
                
                // FEATURE: Add to USED_LOAN_LIMIT instead of BALANCE to prevent glitch
                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE USER_DETAILS SET USED_LOAN_LIMIT = USED_LOAN_LIMIT + ? WHERE PHONE = ?"
                );
                psUpdate.setDouble(1, requestedAmount);
                psUpdate.setString(2, phone);
                psUpdate.executeUpdate();

                // 3. Log the Loan Disbursement into TRANSACTIONS for your history
                PreparedStatement psLog = con.prepareStatement(
                    "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, ORIGINAL_AMOUNT, REMARKS) VALUES (?, ?, ?, ?, ?)"
                );
                psLog.setLong(1, 0); // Bank/System
                psLog.setLong(2, accNo);
                psLog.setDouble(3, requestedAmount);
                psLog.setDouble(4, requestedAmount);
                psLog.setString(5, "Disbursement: " + loanType);
                psLog.executeUpdate();

                con.commit();
                out.println("<script>alert('Loan Authorized! ₹" + requestedAmount + " added to your used credit limit.'); window.location='LoanManagement.jsp';</script>");
            } else {
                con.rollback();
                out.println("<script>alert('Loan Rejected: Amount exceeds your remaining approved limit!'); window.location='LoanManagement.jsp';</script>");
            }
        }
        con.close();
    } catch (Exception e) {
        if (con != null) { try { con.rollback(); } catch(SQLException se) {} }
        out.println("Error: " + e.getMessage());
    }
%>