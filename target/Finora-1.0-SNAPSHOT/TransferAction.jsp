<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: Ensure the user is logged in [cite: 580]
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return;
    }

    String senderPhone = request.getParameter("senderPhone"); 
    String receiverAccStr = request.getParameter("receiverAcc");
    String amountStr = request.getParameter("amount");
    String remarks = request.getParameter("reference"); // [cite: 582]
    
    if(senderPhone == null || receiverAccStr == null || amountStr == null) {
        response.sendRedirect("FundTransfer.jsp");
        return;
    }

    long receiverAcc = Long.parseLong(receiverAccStr);
    double amount = Double.parseDouble(amountStr);
    
    Connection con = null;
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB", "scet", "scet");
        con.setAutoCommit(false); // 

        // 1. Get Sender Account Details and Check Balance [cite: 586]
        long senderAcc = 0;
        PreparedStatement ps0 = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
        ps0.setString(1, senderPhone);
        ResultSet rs0 = ps0.executeQuery();

        if(rs0.next()){
            senderAcc = rs0.getLong("ACCOUNT_NO");
            double currentBalance = rs0.getDouble("BALANCE");

            // 2. STRICT BALANCE CHECK 
            if(currentBalance < amount) {
                con.rollback();
                out.println("<script>alert('Insufficient Balance!'); window.location='FundTransfer.jsp';</script>");
                return;
            }
        } else {
            response.sendRedirect("index.html");
            return;
        }

        // 3. Verify Receiver exists [cite: 589, 590]
        PreparedStatement ps1 = con.prepareStatement("SELECT PHONE FROM USER_DETAILS WHERE ACCOUNT_NO=?");
        ps1.setLong(1, receiverAcc);
        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            // 4. Deduct from Sender [cite: 590, 591]
            PreparedStatement ps3 = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE - ? WHERE ACCOUNT_NO = ?");
            ps3.setDouble(1, amount);
            ps3.setLong(2, senderAcc);
            ps3.executeUpdate();

            // 5. Add to Receiver [cite: 592]
            PreparedStatement ps4 = con.prepareStatement("UPDATE USER_DETAILS SET BALANCE = BALANCE + ? WHERE ACCOUNT_NO = ?");
            ps4.setDouble(1, amount);
            ps4.setLong(2, receiverAcc);
            ps4.executeUpdate();

            // 6. LOG TRANSACTION [cite: 592, 593]
            PreparedStatement ps5 = con.prepareStatement(
                "INSERT INTO TRANSACTIONS (SENDER_ACC, RECEIVER_ACC, AMOUNT, REMARKS) VALUES (?, ?, ?, ?)"
            );
            ps5.setLong(1, senderAcc);
            ps5.setLong(2, receiverAcc);
            ps5.setDouble(3, amount);
            ps5.setString(4, (remarks == null || remarks.isEmpty()) ? "Fund Transfer" : remarks);
            ps5.executeUpdate();

            // Success: Commit changes [cite: 594]
            con.commit(); 
            out.println("<script>alert('Transfer Successful!'); window.location='UserDashboard.jsp';</script>");
        } else {
            con.rollback(); // [cite: 595]
            out.println("<script>alert('Recipient Account Not Found!'); window.location='FundTransfer.jsp';</script>");
        }
    } catch (Exception e) {
        if (con != null) { try { con.rollback(); } catch(SQLException se) {} } // 
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='FundTransfer.jsp';</script>");
    } finally {
        if (con != null) {
            try {
                con.setAutoCommit(true); // [cite: 598]
                con.close(); // [cite: 599]
            } catch(SQLException se) {}
        }
    }
%>