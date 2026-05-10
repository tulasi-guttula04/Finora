<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Finora_Bank_Statement</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <style>
        @media print { .no-print { display: none; } }
        body { padding: 50px; background: white; }
        .statement-brand { color: #026fbf; font-weight: 900; font-size: 2em; }
        .table thead th { background: #f8f9fa; border-bottom: 2px solid #026fbf; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-xs-6">
                <div class="statement-brand">Finora Digital Bank</div>
                <p>Digital Branch: 40-02-61<br>help@finora.com</p>
            </div>
            <div class="col-xs-6 text-right">
                <h3>OFFICIAL STATEMENT</h3>
                <p>Period: <%= request.getParameter("startDate") %> to <%= request.getParameter("endDate") %></p>
            </div>
        </div>

        <hr>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Transaction Details</th>
                    <th>Reference</th>
                    <th class="text-right">Amount (INR)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        String phone = (String) session.getAttribute("phone");
                        String start = request.getParameter("startDate");
                        String end = request.getParameter("endDate");
                        
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
                        
                        // Get Account No [cite: 116-117]
                        PreparedStatement psAcc = con.prepareStatement("SELECT ACCOUNT_NO, NAME FROM USER_DETAILS WHERE PHONE=?");
                        psAcc.setString(1, phone);
                        ResultSet rsAcc = psAcc.executeQuery();
                        
                        if(rsAcc.next()) {
                            long myAcc = rsAcc.getLong("ACCOUNT_NO");
                            
                            // Filter transactions by date range 
                            PreparedStatement psTxn = con.prepareStatement(
                                "SELECT * FROM TRANSACTIONS WHERE (SENDER_ACC = ? OR RECEIVER_ACC = ?) " +
                                "AND CAST(TDATE AS DATE) BETWEEN ? AND ? ORDER BY TDATE ASC"
                            );
                            psTxn.setLong(1, myAcc);
                            psTxn.setLong(2, myAcc);
                            psTxn.setString(3, start);
                            psTxn.setString(4, end);
                            ResultSet rs = psTxn.executeQuery();

                            while(rs.next()) {
                                double amt = rs.getDouble("AMOUNT");
                                boolean isDebit = (rs.getLong("SENDER_ACC") == myAcc);
                %>
                <tr>
                    <td><%= rs.getDate("TDATE") %></td>
                    <td><%= rs.getString("REMARKS") %></td>
                    <td>#TXN<%= rs.getInt("TID") %></td>
                    <td class="text-right" style="color: <%= isDebit ? "red" : "green" %>">
                        <%= isDebit ? "-" : "+" %><%= String.format("%.2f", amt) %>
                    </td>
                </tr>
                <% 
                            }
                        }
                        con.close();
                    } catch(Exception e) { out.println(e); }
                %>
            </tbody>
        </table>

        <div class="no-print text-center" style="margin-top: 50px;">
            <button onclick="window.print()" class="btn btn-primary"><i class="fa fa-print"></i> Save as PDF / Print</button>
            <p style="margin-top: 10px; color: #888;">Note: Use Chrome's 'Save as PDF' destination to download this file.</p>
        </div>
    </div>
</body>
</html>