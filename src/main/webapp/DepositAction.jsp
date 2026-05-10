<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String phone = (String) session.getAttribute("phone");
    String type = request.getParameter("type");
    double amount = Double.parseDouble(request.getParameter("amount"));
    int tenure = Integer.parseInt(request.getParameter("tenure"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
        con.setAutoCommit(false);

        // 1. Check if user has enough liquid balance
        PreparedStatement psBal = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
        psBal.setString(1, phone);
        ResultSet rs = psBal.executeQuery();

        if(rs.next()) {
            long accNo = rs.getLong("ACCOUNT_NO");
            double currentBalance = rs.getDouble("BALANCE");

            if(currentBalance >= amount) {
                // 2. Deduct from Liquid Balance
                PreparedStatement psUpdate = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE - ? WHERE PHONE = ?");
                psUpdate.setDouble(1, amount);
                psUpdate.setString(2, phone);
                psUpdate.executeUpdate();

                // 3. Log into Transactions for Audit
                PreparedStatement psLog = con.prepareStatement("INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)");
                psLog.setLong(1, accNo);
                psLog.setLong(2, 99999999L); // System Investment Account
                psLog.setDouble(3, amount);
                psLog.setString(4, "New " + type + " Investment - " + tenure + " Years");
                psLog.executeUpdate();

                con.commit();
                out.println("<script>alert('Investment Successful! ₹" + amount + " moved to your " + type + " account.'); window.location='Deposits.jsp';</script>");
            } else {
                out.println("<script>alert('Insufficient Liquid Balance for this investment!'); window.location='Deposits.jsp';</script>");
            }
        }
        con.close();
    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
%>