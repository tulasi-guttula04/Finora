<%@page import="java.sql.*"%>
<%
    String phone = (String) session.getAttribute("phone");
    String repayAmountStr = request.getParameter("repayAmount");
    String tidStr = request.getParameter("tid");

    if (phone == null || repayAmountStr == null || tidStr == null) {
        response.sendRedirect("LoanManagement.jsp");
        return;
    }

    double repayAmount = Double.parseDouble(repayAmountStr);
    int tid = Integer.parseInt(tidStr);
    Connection con = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
        con.setAutoCommit(false);

        // 1. Check current balance and current loan amount
        PreparedStatement psCheck = con.prepareStatement(
            "SELECT U.BALANCE, T.AMOUNT FROM USER_DETAILS U, TRANSACTIONS T WHERE U.PHONE = ? AND T.TID = ?"
        );
        psCheck.setString(1, phone);
        psCheck.setInt(2, tid);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            double currentBalance = rs.getDouble("BALANCE");
            double currentLoanDebt = rs.getDouble("AMOUNT");

            if (currentBalance >= repayAmount) {
                // 2. Deduct from User Balance and the Used Loan Limit [cite: 630]
                PreparedStatement psBal = con.prepareStatement(
                    "UPDATE USER_DETAILS SET BALANCE = BALANCE - ?, USED_LOAN_LIMIT = USED_LOAN_LIMIT - ? WHERE PHONE = ?"
                );
                psBal.setDouble(1, repayAmount);
                psBal.setDouble(2, repayAmount);
                psBal.setString(3, phone);
                psBal.executeUpdate();

                
                PreparedStatement psGetAcc = con.prepareStatement("SELECT ACCOUNT_NO FROM USER_DETAILS WHERE PHONE=?");
                psGetAcc.setString(1, phone);
                ResultSet rsAcc = psGetAcc.executeQuery();

                if(rsAcc.next()) {
                    long userAcc = rsAcc.getLong("ACCOUNT_NO"); // [cite: 1799]

                    // 2. Insert a NEW record into the TRANSACTIONS table for the repayment 
                    PreparedStatement psLogRepay = con.prepareStatement(
                        "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
                    );
                    psLogRepay.setLong(1, userAcc); // User is the sender 
                    psLogRepay.setLong(2, 0);       // 0 represents the Bank/System 
                    psLogRepay.setDouble(3, repayAmount); // 
                    psLogRepay.setString(4, "Loan Repayment for Ticket #TK" + tid); // 
                    psLogRepay.executeUpdate();
                }
                
                // 3. Update or Clear the Loan Record
                double remainingDebt = currentLoanDebt - repayAmount;

                if (remainingDebt <= 0.01) {
                    // Loan fully settled: Delete the disbursement log 
                    PreparedStatement psClear = con.prepareStatement("DELETE FROM TRANSACTIONS WHERE TID = ?");
                    psClear.setInt(1, tid);
                    psClear.executeUpdate();
                    con.commit();
                    out.println("<script>alert('Loan Fully Repaid!'); window.location='LoanManagement.jsp';</script>");
                } else {
                    // Partial payment: Update the remaining amount to grow the progress bar
                    PreparedStatement psUpdateLoan = con.prepareStatement("UPDATE TRANSACTIONS SET AMOUNT = AMOUNT - ? WHERE TID = ?");
                    psUpdateLoan.setDouble(1, repayAmount);
                    psUpdateLoan.setInt(2, tid);
                    psUpdateLoan.executeUpdate();
                    
                    con.commit();
                    out.println("<script>alert('Partial Payment of " + repayAmount + " Successful!'); window.location='LoanManagement.jsp';</script>");
                }
            } else {
                con.rollback(); // [cite: 633]
                out.println("<script>alert('Error: Insufficient balance!'); window.location='LoanManagement.jsp';</script>");
            }
        }
    } catch(Exception e) { 
        if (con != null) try { con.rollback(); } catch(SQLException se) {} // [cite: 634]
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='LoanManagement.jsp';</script>"); 
    } finally {
        if (con != null) con.close(); // [cite: 635]
    }
%>