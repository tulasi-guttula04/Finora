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
    <title>Finora | Loan Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; margin: 0; padding: 0; } 
        .loan-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 5em 0; color: white; text-align: center; } 
        .content-wrapper { padding: 3em 0 5em; } 
        .loan-card { background: #ffffff; border-radius: 15px; padding: 30px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; margin-bottom: 30px; } 
        .loan-status-box { background: #e7f3ff; border: 1px dashed #026fbf; padding: 20px; border-radius: 10px; text-align: center; margin-bottom: 25px; } 
        .loan-option-item { display: flex; align-items: center; padding: 15px; background: #fcfdfe; border: 1px solid #eef2f6; border-radius: 10px; margin-bottom: 15px; } 
        .loan-option-item i { font-size: 2em; color: #026fbf; margin-right: 15px; } 
        .btn-apply { background: #026fbf; color: white !important; padding: 10px 20px; border-radius: 5px; text-transform: uppercase; font-weight: 700; border: none; } 
        .repay-panel { background: #fff; border-radius: 15px; padding: 20px; border-top: 6px solid #28a745; margin-top: 20px; }
    
    /* QR Scanner UI & Animation */
.qr-container {
    text-align: center;
    padding: 20px;
    background: #fff;
    border-radius: 15px;
    position: relative;
    overflow: hidden;
}
.qr-frame {
    width: 200px;
    height: 200px;
    margin: 0 auto;
    border: 4px solid #026fbf;
    border-radius: 15px;
    position: relative;
    background: #f8fbff;
}
.scanner-laser {
    width: 100%;
    height: 3px;
    background: linear-gradient(to right, transparent, #dc3545, transparent);
    position: absolute;
    top: 0;
    left: 0;
    box-shadow: 0 0 15px #dc3545;
    animation: scanMove 2s infinite ease-in-out;
}
@keyframes scanMove {
    0%, 100% { top: 0; }
    50% { top: 100%; }
}
.qr-placeholder {
    font-size: 8em;
    color: #333;
    margin-top: 25px;
    opacity: 0.9;
}
.btn-qr-trigger {
    background: #333;
    color: white !important;
    border-radius: 5px;
    padding: 8px 15px;
    font-weight: 700;
    margin-left: 5px;
    transition: 0.3s;
}
.btn-qr-trigger:hover {
    background: #000;
    transform: scale(1.05);
}
    </style>
</head>

<body>
    <div class="loan-header">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">LOAN SERVICES</h1> 
            <p style="opacity: 0.9;">Manage your credit limits and active loans</p>
        </div>
    </div>

    <div class="container content-wrapper">
        <div class="row">
            <%
                try {
                    String phone = (String) session.getAttribute("phone"); 
                    Class.forName("org.apache.derby.jdbc.ClientDriver"); 
                    Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
                    
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM USER_DETAILS WHERE PHONE=?");
                    ps.setString(1, phone);
                    ResultSet rs = ps.executeQuery();
                    
                    if(rs.next()) {
                        long accNo = rs.getLong("ACCOUNT_NO");
                        double currentBalance = rs.getDouble("BALANCE"); 
                        double usedLimit = rs.getDouble("USED_LOAN_LIMIT");
                        double totalLimit = currentBalance * 100; 
                        double remainingLimit = totalLimit - usedLimit;
            %>
            
            <div class="col-md-5">
                <div class="loan-card">
                    <h3 style="font-weight: 700; color: #333;">Credit Limit</h3>
                    <div class="loan-status-box">
                        <div style="font-size: 0.8em; text-transform: uppercase; color: #888; font-weight: 700;">Remaining Limit</div>
                        <div style="font-size: 2em; color: #026fbf; font-weight: 900;">₹<%= String.format("%.2f", remainingLimit) %></div>
                    </div>
                    <p style="font-size: 0.8em; color: #777;">Total Approved: ₹<%= String.format("%.2f", totalLimit) %></p> 
                </div>

            <div class="repay-panel">
                <h4 style="font-weight: 700; color: #28a745; margin-bottom: 15px;">Active Debt Progress</h4>
                <%
                    PreparedStatement psLoans = con.prepareStatement("SELECT * FROM TRANSACTIONS WHERE SENDER_ACC = 0 AND RECEIVER_ACC = ? AND REMARKS LIKE 'Disbursement:%'");
                    psLoans.setLong(1, accNo);
                    ResultSet rsLoans = psLoans.executeQuery();
                    boolean hasLoans = false;
                    while(rsLoans.next()) {
                        hasLoans = true;
                        double currentDebt = rsLoans.getDouble("AMOUNT");
                        double original = rsLoans.getDouble("ORIGINAL_AMOUNT");
                        if(original == 0) original = currentDebt; // Fallback for old records

                        // Simulation: 5% Interest calculation
                        double interest = currentDebt * 0.05; 
                        double totalDue = currentBalance + interest;

                        int progress = (int)(( (original - currentDebt) / original ) * 100);
                %>
                    <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 700; color: #333;"><%= rsLoans.getString("REMARKS").replace("Disbursement: ", "") %></span>
                            <span style="color: #dc3545; font-weight: 700;">Remaining: ₹<%= String.format("%.2f", currentDebt) %></span>
                        </div>

                        <div class="progress" style="height: 10px; margin-bottom: 5px; background: #e9ecef;">
                            <div class="progress-bar progress-bar-success" role="progressbar" style="width: <%= progress %>%;" aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 0.8em; color: #888; margin-bottom: 10px;">
                            <span>Paid: <%= progress %>%</span>
                            <span>Interest Accrued: ₹<%= String.format("%.2f", interest) %></span>
                        </div>

                        <button type="button" class="btn btn-xs btn-success" onclick="openRepayModal('<%= rsLoans.getInt("TID") %>', <%= currentDebt %>)">
                            <i class="fa fa-pencil"></i> Manual Pay
                        </button>

                        <button type="button" class="btn-qr-trigger btn-xs" onclick="openQRModal('<%= rsLoans.getInt("TID") %>', <%= currentDebt %>)">
                            <i class="fa fa-qrcode"></i> Scan to Pay
                        </button>
                    </div>
                <% } if(!hasLoans) { out.println("<p style='color:#999;'>No active loans.</p>"); } %>
            </div>

            <div class="modal fade" id="repayModal" tabindex="-1">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content" style="border-top: 6px solid #28a745;">
                        <div class="modal-header"><h4 class="modal-title">Repay Loan</h4></div>
                        <form action="RepayLoanAction.jsp" method="post">
                            <div class="modal-body">
                                <input type="hidden" name="tid" id="repayTid">
                                <div class="form-group">
                                    <label>Repayment Amount (INR)</label>
                                    <input type="number" name="repayAmount" id="maxRepay" class="form-control" required>
                                    <small class="text-muted">Enter any amount up to your current debt.</small>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-success">Confirm Payment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                function openRepayModal(tid, maxAmt) {
                    document.getElementById('repayTid').value = tid;
                    document.getElementById('maxRepay').max = maxAmt;
                    document.getElementById('maxRepay').value = maxAmt;
                    $('#repayModal').modal('show');
                }
            </script>
            </div>

            <div class="col-md-7">
                <div class="loan-card">
                    <h3 style="font-weight: 700; color: #333; margin-bottom: 20px;">Available Products</h3>
                    <% String[] loanTypes = {"Business Loan", "Home Loan", "Vehicle Loan", "Education Loan"};
                       for(String type : loanTypes) { %>
                        <div class="loan-option-item">
                            <i class="fa fa-circle-o"></i>
                            <div style="flex-grow: 1;">
                                <div style="font-weight: 700; color: #026fbf;"><%= type %></div>
                            </div>
                            <button class="btn-apply" onclick="openLoanModal('<%= type %>')">Apply</button> 
                        </div>
                    <% } %>
                </div>
            </div>
                
            <div class="col-md-12 text-center" style="margin-top: 30px;">
                <a href="UserDashboard.jsp" class="btn btn-primary" style="background: #026fbf; border: none; padding: 10px 30px; font-weight: 700;">
                    <i class="fa fa-home"></i> BACK TO DASHBOARD
                </a>
            </div>

            <div class="modal fade" id="loanModal" tabindex="-1"> 
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">LOAN APPLICATION</h4>
                        </div>
                        <form action="LoanAction.jsp" method="post">
                            <div class="modal-body">
                                <div class="form-group">
                                    <label>Loan Type</label>
                                    <input type="text" id="displayLoanType" name="loanType" class="form-control" readonly> 
                                </div>
                                <div class="form-group">
                                    <label>Amount (Max: ₹<%= remainingLimit %>)</label>
                                    <input type="number" name="loanAmount" class="form-control" max="<%= remainingLimit %>" required> 
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Get Loan</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <%
                    }
                    con.close();
                } catch(Exception e) { out.println("Error: " + e.getMessage()); }
            %>
        </div>
    </div>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script>
        function openLoanModal(type) {
            document.getElementById('displayLoanType').value = type;
            $('#loanModal').modal('show');
        }
        function openQRModal(tid, amount) {
            document.getElementById('qrTidLabel').innerText = tid;
            document.getElementById('qrTidInput').value = tid;
            document.getElementById('qrAmountLabel').innerText = amount.toFixed(2);
            document.getElementById('qrAmountInput').value = amount;

            $('#qrModal').modal('show');
        }
    </script>
    
    <div class="modal fade" id="qrModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="border-top: 8px solid #333;">
            <div class="modal-header">
                <h4 class="modal-title" style="font-weight: 800;"><i class="fa fa-mobile"></i> FINORA SECURE SCAN</h4>
            </div>
            <div class="modal-body text-center">
                <p class="text-muted">Scan this unique QR with your Finora Mobile App to settle debt #TK<span id="qrTidLabel"></span></p>
                
                <div class="qr-container">
                    <div class="qr-frame">
                        <div class="scanner-laser"></div>
                        <i class="fa fa-qrcode qr-placeholder"></i>
                    </div>
                </div>

                <div style="margin-top: 20px; padding: 15px; background: #fdfdfe; border: 1px solid #eee; border-radius: 10px;">
                    <h5 style="font-weight: 700;">Amount: ₹<span id="qrAmountLabel"></span></h5>
                    <small class="text-success"><i class="fa fa-shield"></i> Encrypted Transaction</small>
                </div>
            </div>
            <div class="modal-footer" style="text-align: center; border: none;">
                <form action="RepayLoanAction.jsp" method="post">
                    <input type="hidden" name="tid" id="qrTidInput">
                    <input type="hidden" name="repayAmount" id="qrAmountInput">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background: #333; border: none;">
                        Simulate App Payment
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>