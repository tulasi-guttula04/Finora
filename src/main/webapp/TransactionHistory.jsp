<%
    // Security check to ensure the user is logged in
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return; 
    }
%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | Transaction History</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; margin: 0; padding: 0; }
        .history-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 4em 0; color: white; text-align: center; }
        .content-area { padding: 3em 0 5em; }
        
        /* Modern Table Card */
        .history-card { background: #ffffff; border-radius: 15px; padding: 30px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; }
        
        /* Icon Column Styling */
        .type-icon { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2em; }
        .bg-credit { background: #e7f3ff; color: #026fbf; } /* Deposits/Loans */
        .bg-debit { background: #fff0f0; color: #dc3545; }  /* CC Swipes/Spending */
        .bg-invest { background: #f0fff4; color: #28a745; } /* FD/RD Investments */
        
        .txn-row:hover { background-color: #f8fbff; cursor: default; }
        .amount-credit { color: #28a745; font-weight: 900; }
        .amount-debit { color: #dc3545; font-weight: 900; }
        
        .remarks-badge { font-size: 0.8em; padding: 4px 10px; border-radius: 15px; background: #f1f1f1; color: #666; font-weight: 600; }
    </style>
</head>

<body>
    <div class="history-header">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">TRANSACTION PASSBOOK</h1>
            <p style="opacity: 0.9;">Tracking your Loans, Investments, and Credit activity</p>
        </div>
    </div>

    <div class="container content-area">
        <div class="row">
            <div class="col-md-12">
                <div class="history-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr style="border-bottom: 2px solid #eee; color: #888; text-transform: uppercase; font-size: 0.85em;">
                                    <th>Type</th>
                                    <th>Date & Time</th>
                                    <th>Details</th>
                                    <th>Reference</th>
                                    <th class="text-right">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        String phone = (String) session.getAttribute("phone");
                                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                                        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
                                        
                                        // 1. Get current user's account number
                                        PreparedStatement psAcc = con.prepareStatement("SELECT ACCOUNT_NO FROM USER_DETAILS WHERE PHONE=?");
                                        psAcc.setString(1, phone);
                                        ResultSet rsAcc = psAcc.executeQuery();
                                        
                                        if(rsAcc.next()) {
                                            long myAcc = rsAcc.getLong("ACCOUNT_NO");
                                            
                                            // 2. Query ALL transactions where user is sender OR receiver
                                            PreparedStatement psTxn = con.prepareStatement(
                                                "SELECT * FROM TRANSACTIONS WHERE SENDER_ACC = ? OR RECEIVER_ACC = ? ORDER BY TID DESC"
                                            );
                                            psTxn.setLong(1, myAcc);
                                            psTxn.setLong(2, myAcc);
                                            ResultSet rs = psTxn.executeQuery();
                                            
                                            while(rs.next()) {
                                                    String remarks = rs.getString("REMARKS");
                                                    long sender = rs.getLong("SENDER_ACC");

                                                    // FIX: If it's a Loan Disbursement, show the ORIGINAL_AMOUNT 
                                                    // instead of the decreasing 'AMOUNT' column.
                                                    double displayAmount;
                                                    if(remarks.contains("Disbursement")) {
                                                        displayAmount = rs.getDouble("ORIGINAL_AMOUNT"); 
                                                    } else {
                                                        displayAmount = rs.getDouble("AMOUNT"); 
                                                    }

                                                    // Identify Transaction Logic
                                                    String icon = "fa-exchange";
                                                    String iconClass = "bg-credit";
                                                    String amountDisplay = "+" + String.format("%.2f", displayAmount);
                                                    String amountClass = "amount-credit";

                                                    // Logic for Debits (Spending/Repayments)
                                                    if(sender == myAcc) {
                                                        iconClass = "bg-debit"; 
                                                        amountDisplay = "-" + String.format("%.2f", displayAmount);
                                                        amountClass = "amount-debit"; 
                                                    }

                                                // Specific Feature Icons
                                                if(remarks.contains("Credit Swipe")) { icon = "fa-credit-card"; }
                                                else if(remarks.contains("Disbursement")) { icon = "fa-bank"; iconClass="bg-credit"; }
                                                else if(remarks.contains("Investment")) { icon = "fa-briefcase"; iconClass="bg-invest"; }
                                                else if(remarks.contains("Settled")) { icon = "fa-check-circle"; }
                                %>
                                <tr class="txn-row">
                                    <td width="60">
                                        <div class="type-icon <%= iconClass %>">
                                            <i class="fa <%= icon %>"></i>
                                        </div>
                                    </td>
                                    <td style="vertical-align: middle; color: #666;">
                                        <%= rs.getTimestamp("TDATE") %>
                                    </td>
                                    <td style="vertical-align: middle;">
                                        <div style="font-weight: 700; color: #333;"><%= remarks %></div>
                                        <span class="remarks-badge">ID: #TXN<%= rs.getInt("TID") %></span>
                                    </td>
                                    <td style="vertical-align: middle; color: #888; font-size: 0.9em;">
                                        <%= (sender == myAcc) ? "To: " + rs.getLong("RECEIVER_ACC") : "From: Bank/Internal" %>
                                    </td>
                                    <td class="text-right <%= amountClass %>" style="vertical-align: middle; font-size: 1.2em;">
                                        ₹<%= amountDisplay %>
                                    </td>
                                </tr>
                                <% 
                                            } 
                                        }
                                        con.close();
                                    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="col-md-12 text-center" style="margin-top: 30px;">
                <a href="UserDashboard.jsp" class="btn btn-primary" style="background: #026fbf; border: none; padding: 10px 30px; font-weight: 700;">
                    <i class="fa fa-home"></i> BACK TO DASHBOARD
                </a>
            </div>
        </div>
    </div>

    <footer style="text-align: center; padding: 20px 0;">
        <p>© 2026 Finora. Design by Batch_9_CSE_Java_NIVUNALabs</p>
    </footer>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>