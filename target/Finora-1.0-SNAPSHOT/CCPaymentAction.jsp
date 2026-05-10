<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String type = request.getParameter("type"); 
    double amount = Double.parseDouble(request.getParameter("amount"));
    String phone = (String) session.getAttribute("phone");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
        con.setAutoCommit(false);

        PreparedStatement psUser = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
        psUser.setString(1, phone);
        ResultSet rsUser = psUser.executeQuery();

        if (rsUser.next()) {
            long accNo = rsUser.getLong("ACCOUNT_NO");
            double savingsBal = rsUser.getDouble("BALANCE");

            if ("SWIPE".equals(type)) {
                // 1. Calculate Reward Points (e.g., 1 point for every ₹100 spent)
                int pointsEarned = (int)(amount / 100);

                // 2. Log the Swipe Transaction
                PreparedStatement psLog = con.prepareStatement(
                    "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
                );
                psLog.setLong(1, accNo);
                psLog.setLong(2, 0); 
                psLog.setDouble(3, amount);
                psLog.setString(4, "Infinia Credit Swipe: Retail Store");
                psLog.executeUpdate();

                // 3. NEW: Update Reward Points in USER_DETAILS table
                PreparedStatement psReward = con.prepareStatement(
                    "UPDATE USER_DETAILS SET REWARDS = REWARDS + ? WHERE PHONE = ?"
                );
                psReward.setInt(1, pointsEarned);
                psReward.setString(2, phone);
                psReward.executeUpdate();

                con.commit();
                out.println("<script>alert('Swipe Successful! You earned " + pointsEarned + " Reward Points.'); window.location='CreditCard.jsp';</script>");

            } else if ("BILL_PAY".equals(type)) {
                if (savingsBal >= amount) {
                    // Deduct from Savings Balance
                    PreparedStatement psUpdate = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE - ? WHERE PHONE = ?");
                    psUpdate.setDouble(1, amount);
                    psUpdate.setString(2, phone);
                    psUpdate.executeUpdate();

                    // Clear swiped transactions history
                    PreparedStatement psClear = con.prepareStatement(
                        "UPDATE TRANSACTIONS SET REMARKS = 'Settled Credit Payment' WHERE SENDER_ACC = ? AND REMARKS = 'Infinia Credit Swipe: Retail Store'"
                    );
                    psClear.setLong(1, accNo);
                    psClear.executeUpdate();

                    con.commit();
                    out.println("<script>alert('Bill Settled Successfully!'); window.location='CreditCard.jsp';</script>");
                } else {
                    out.println("<script>alert('Insufficient Savings Balance!'); window.location='CreditCard.jsp';</script>");
                }
            }
        }
        con.close();
    } catch(Exception e) { 
        out.println(e); 
    }
%>