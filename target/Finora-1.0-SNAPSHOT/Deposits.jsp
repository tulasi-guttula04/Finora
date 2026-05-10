<%
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
    <title>Finora | Deposits & Savings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; margin: 0; padding: 0; }
        .deposit-header { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 5em 0; color: white; text-align: center; }
        .content-area { padding: 3em 0 5em; }
        .deposit-card { background: #ffffff; border-radius: 15px; padding: 35px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; transition: all 0.4s; margin-bottom: 30px; }
        .deposit-card:hover { transform: translateY(-10px); }
        .rate-badge { background: #e7f3ff; color: #026fbf; padding: 8px 15px; border-radius: 20px; font-weight: 700; display: inline-block; margin-bottom: 15px; }
        .feature-item { display: flex; align-items: center; margin-bottom: 15px; color: #555; }
        .feature-item i { color: #28a745; margin-right: 12px; font-size: 1.2em; }
        .btn-invest { background: #026fbf; color: white !important; padding: 12px 30px; border-radius: 5px; text-transform: uppercase; font-weight: 700; display: block; text-align: center; margin-top: 25px; text-decoration: none; border: none; width: 100%; cursor: pointer; }
        .modal-content { border-radius: 15px; border-top: 8px solid #026fbf; }
        .modal-header { border: none; text-align: center; }
        .modal-title { font-weight: 900; color: #026fbf; text-transform: uppercase; }
    </style>
</head>

<body>
    <div class="deposit-header">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">DEPOSITS & SAVINGS</h1>
            <p style="opacity: 0.9;">Grow your wealth with Finora's high-yield investment plans</p>
        </div>
    </div>

    <div class="container content-area">
        <div class="row">
            <%
                Connection con = null;
                try {
                    String phone = (String) session.getAttribute("phone");
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
                    
                    PreparedStatement ps = con.prepareStatement("SELECT ACCOUNT_NO, BALANCE FROM USER_DETAILS WHERE PHONE=?");
                    ps.setString(1, phone);
                    ResultSet rs = ps.executeQuery();
                    
                    if(rs.next()) {
                        long accNo = rs.getLong("ACCOUNT_NO");
                        double currentBalance = rs.getDouble("BALANCE");
            %>
            
            <div class="col-md-6">
                <div class="deposit-card">
                    <div class="rate-badge">Up to 7.5% p.a.</div>
                    <h3 style="font-weight: 700; color: #333; margin-bottom: 15px;">Fixed Deposit (FD)</h3>
                    <p style="color: #888; margin-bottom: 25px;">Secure a lump sum amount for a fixed tenure and earn higher interest rates.</p>
                    <div class="feature-item"><i class="fa fa-check-circle"></i> Minimum Deposit: ₹5,000</div>
                    <div class="feature-item"><i class="fa fa-check-circle"></i> Tenure: 1 to 10 years</div>
                    <button class="btn-invest" onclick="openInvestModal('FD', 5000)">Open Fixed Deposit</button>
                </div>
            </div>

            <div class="col-md-6">
                <div class="deposit-card">
                    <div class="rate-badge">Up to 6.8% p.a.</div>
                    <h3 style="font-weight: 700; color: #333; margin-bottom: 15px;">Recurring Deposit (RD)</h3>
                    <p style="color: #888; margin-bottom: 25px;">Build your savings habit by investing a fixed amount every month.</p>
                    <div class="feature-item"><i class="fa fa-check-circle"></i> Monthly starting from ₹500</div>
                    <div class="feature-item"><i class="fa fa-check-circle"></i> Flexible Tenure options</div>
                    <button class="btn-invest" onclick="openInvestModal('RD', 500)">Start Recurring Deposit</button>
                </div>
            </div>

            <div class="col-md-12 text-center" style="margin-top: 20px; margin-bottom: 40px;">
                <a href="UserDashboard.jsp" style="color: #026fbf; text-decoration: none; font-weight: 700;"><i class="fa fa-arrow-left"></i> Return to Dashboard</a>
            </div>

            <div class="col-md-12">
                <div class="deposit-card" style="border-top: 6px solid #28a745;">
                    <h3 style="font-weight: 700; color: #333; margin-bottom: 20px;">
                        <i class="fa fa-briefcase" style="color: #28a745;"></i> My Investment Portfolio
                    </h3>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr style="color: #888; text-transform: uppercase; font-size: 0.85em;">
                                    <th>Investment Type</th>
                                    <th>Date</th>
                                    <th class="text-right">Amount Invested</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    double totalInvested = 0;
                                    // Querying for active investments linked to the user's account 
                                    PreparedStatement psPort = con.prepareStatement(
                                        "SELECT TID, REMARKS, TDATE, AMOUNT FROM TRANSACTIONS WHERE SENDER_ACC = ? AND REMARKS LIKE '%Investment%'"
                                    );
                                    psPort.setLong(1, accNo);
                                    ResultSet rsPort = psPort.executeQuery();

                                    boolean found = false;
                                    while(rsPort.next()) {
                                        found = true;
                                        int tid = rsPort.getInt("TID");
                                        double amt = rsPort.getDouble("AMOUNT");
                                        totalInvested += amt;
                                %>
                                <tr>
                                    <td style="font-weight: 600; color: #026fbf;"><%= rsPort.getString("REMARKS") %></td>
                                    <td style="color: #666;"><%= rsPort.getTimestamp("TDATE") %></td>
                                    <td class="text-right">
                                        <span style="font-weight: 700; color: #333; margin-right: 15px;">₹<%= String.format("%.2f", amt) %></span>
                                        <form action="CloseInvestmentAction.jsp" method="post" style="display: inline;">
                                            <input type="hidden" name="tid" value="<%= tid %>">
                                            <input type="hidden" name="amount" value="<%= amt %>">
                                            <button type="submit" class="btn btn-xs btn-danger" onclick="return confirm('Are you sure you want to close this investment and return funds to your balance?')">
                                                <i class="fa fa-times"></i> Close
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% 
                                    } 
                                    if(!found) { 
                                %>
                                <tr>
                                    <td colspan="3" class="text-center" style="color: #999; padding: 20px;">No active investments found.</td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr style="background: #f9f9f9; font-size: 1.1em;">
                                    <th colspan="2" style="text-align: right; color: #555;">Total Portfolio Value:</th>
                                    <th class="text-right" style="color: #28a745; font-weight: 900;">₹<%= String.format("%.2f", totalInvested) %></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <% 
                    } // End if(rs.next()) 
                } catch(Exception e) { out.println("Error: " + e.getMessage()); } 
                finally { if(con != null) con.close(); }
            %>
        </div>
    </div>

    <div class="modal fade" id="investModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="modalTitle">Investment</h4>
                </div>
                <form action="DepositAction.jsp" method="post">
                    <div class="modal-body">
                        <p id="modalDesc" class="text-muted"></p>
                        <div class="form-group">
                            <label>Amount to Invest (₹)</label>
                            <input type="number" name="amount" id="investAmount" class="form-control" required>
                            <input type="hidden" name="type" id="investType">
                        </div>
                        <div class="form-group">
                            <label>Tenure (Years)</label>
                            <select name="tenure" class="form-control">
                                <option value="1">1 Year</option>
                                <option value="3">3 Years</option>
                                <option value="5">5 Years</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary" style="background:#026fbf;">Confirm Investment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script>
        function openInvestModal(type, min) {
            document.getElementById('investType').value = type;
            document.getElementById('investAmount').min = min;
            document.getElementById('investAmount').value = min;
            document.getElementById('modalTitle').innerText = (type === 'FD' ? 'Fixed Deposit Application' : 'Recurring Deposit Setup');
            document.getElementById('modalDesc').innerText = (type === 'FD' ? 'Lump sum investment with guaranteed higher returns.' : 'Monthly systematic investment plan.');
            $('#investModal').modal('show');
        }
    </script>
</body>
</html>