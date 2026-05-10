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
    <title>Finora | Credit Card Portal</title> 
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; margin: 0; padding: 0; } 
        .card-header-bg { background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); padding: 5em 0; color: white; text-align: center; }
        .content-area { padding: 3em 0 5em; }

        .cc-visual {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            border-radius: 20px; padding: 30px; color: #ffd700; height: 250px;
            box-shadow: 0 20px 45px rgba(0,0,0,0.4);
            position: relative; transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            border: 1px solid rgba(255, 215, 0, 0.3); cursor: pointer;
        }
        .cc-visual:hover { transform: translateY(-10px) rotateX(5deg); }
        .cc-chip { width: 50px; height: 40px; background: linear-gradient(135deg, #e0e0e0 0%, #bdbdbd 100%); border-radius: 8px; margin-bottom: 20px; }

        .controls-container { background: #ffffff; border-radius: 15px; padding: 30px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); border-top: 6px solid #026fbf; }
        .control-item { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
        .metric-value { font-weight: 900; color: #026fbf; font-size: 1.2em; }

        /* Toggle Styles */
        .switch { position: relative; display: inline-block; width: 50px; height: 24px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #28a745; transition: .4s; border-radius: 24px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: #dc3545; }
        input:checked + .slider:before { transform: translateX(26px); }
        .status-text { font-weight: 700; margin-right: 10px; text-transform: uppercase; font-size: 0.8em; }
        .locked { color: #dc3545; } .unlocked { color: #28a745; }

        .btn-action { background: #026fbf; color: white !important; padding: 12px 25px; border-radius: 5px; text-transform: uppercase; font-weight: 700; display: block; text-align: center; margin-top: 20px; text-decoration: none; }
    </style>
</head>

<body>
    <div class="card-header-bg">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">INFINIA CREDIT PORTAL</h1>
            <p style="opacity: 0.9;">Click the card to simulate a transaction or use controls below</p>
        </div>
    </div>

    <div class="container content-area">
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
                        double savingsBalance = rs.getDouble("BALANCE");
                        double creditLimit = savingsBalance * 10;

                        PreparedStatement psBill = con.prepareStatement(
                            "SELECT SUM(AMOUNT) as UNPAID FROM TRANSACTIONS WHERE SENDER_ACC = ? AND REMARKS LIKE 'Infinia Credit Swipe%'"
                        );
                        psBill.setLong(1, accNo);
                        ResultSet rsBill = psBill.executeQuery();
                        double outstandingBill = 0;
                        if(rsBill.next()) {
                            outstandingBill = rsBill.getDouble("UNPAID");
                        }

                        double availableCredit = creditLimit - outstandingBill;
                        String ccNum = "5241 9900 1122 " + (accNo % 10000);
            %>
            <div class="col-md-6 col-sm-12">
                <div id="mainCard" class="cc-visual" onclick="handleCardClick()">
                    <div class="cc-chip"></div> 
                    <div style="font-size: 1.5em; letter-spacing: 4px; font-weight: 600; color: #fff;"><%= ccNum %></div> 
                    <div style="margin-top: 40px; font-weight: 300; letter-spacing: 2px; color: #fff;">LIMIT: ₹<%= String.format("%.2f", creditLimit) %></div>
                    <div style="margin-top: 5px; text-transform: uppercase; font-weight: 700; color: #ffd700;"><%= rs.getString("NAME") %></div>
                    <div style="position: absolute; bottom: 30px; right: 30px; font-weight: 900; font-style: italic;">Finora Infinia Credit</div>
                </div>
            </div>

            <div class="col-md-6 col-sm-12">
                <div class="controls-container"> 
                    <h3 style="color: #333; font-weight: 700; margin-bottom: 20px;">Card Management</h3>

                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Total Credit Limit (10x)</span>
                        <span class="metric-value">₹<%= String.format("%.2f", creditLimit) %></span> 
                    </div>

                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Outstanding Bill</span>
                        <span class="metric-value" style="color: #dc3545;">₹<%= String.format("%.2f", outstandingBill) %></span> 
                    </div>

                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Available Credit</span>
                        <span class="metric-value" style="color: #28a745;">₹<%= String.format("%.2f", availableCredit) %></span> 
                    </div>
                    
                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Reward Points</span>
                        <span class="metric-value" style="color: #ffd700;">
                            <i class="fa fa-star"></i> <%= rs.getInt("REWARDS") %>
                        </span> 
                    </div>

                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Security Status</span>
                        <div style="display: flex; align-items: center;"> 
                            <span id="toggleLabel" class="status-text unlocked">Unlocked</span> 
                            <label class="switch"> 
                                <input type="checkbox" id="lockToggle" onchange="updateLockStatus()">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <a href="#" data-toggle="modal" data-target="#billModal" class="btn-action" style="background: #28a745; <%= outstandingBill <= 0 ? "pointer-events: none; opacity: 0.5;" : "" %>">
                        <i class="fa fa-money"></i> Pay Monthly Bill
                    </a>

                    <a href="UserDashboard.jsp" class="btn-action"> 
                        <i class="fa fa-home"></i> Back to Dashboard 
                    </a>
                </div>
            </div>

            <div class="modal fade" id="swipeModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content" style="border-top: 8px solid #026fbf; border-radius: 15px;">
                        <div class="modal-header">
                            <h4 class="modal-title"><i class="fa fa-credit-card"></i> CREDIT SWIPE SIMULATION</h4>
                        </div>
                        <form action="CCPaymentAction.jsp" method="post">
                            <div class="modal-body">
                                <p class="text-center">Simulating a physical credit transaction at a POS Terminal.</p>
                                <div class="form-group">
                                    <label>Amount to Spend (₹)</label>
                                    <input type="number" name="amount" class="form-control" placeholder="Max: <%= availableCredit %>" max="<%= availableCredit %>" required>
                                </div>
                                <input type="hidden" name="type" value="SWIPE">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary" style="background: #026fbf;">Confirm Swipe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="billModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header"><h4 class="modal-title">SETTLE CREDIT BILL</h4></div>
                        <form action="CCPaymentAction.jsp" method="post">
                            <div class="modal-body">
                                <p>Current outstanding: <strong>₹<%= outstandingBill %></strong></p>
                                <div class="form-group">
                                    <label>Payment Amount</label>
                                    <input type="number" name="amount" class="form-control" value="<%= outstandingBill %>" max="<%= savingsBalance %>" required>
                                </div>
                                <input type="hidden" name="type" value="BILL_PAY">
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-success">Pay Now</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <% 
                    }
                    con.close();
                } catch(Exception e) { out.println(e); }
            %>
        </div>
    </div>

    <footer style="text-align: center; padding: 20px 0;"> 
        <p class="footer-class">© 2026 <a>Finora</a>. Design by Batch_9_CSE_Java_NIVUNALabs</p> 
    </footer>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script>
    function updateLockStatus() {
        const isLocked = document.getElementById('lockToggle').checked;
        const label = document.getElementById('toggleLabel');
        label.innerText = isLocked ? "Locked" : "Unlocked";
        label.className = isLocked ? "status-text locked" : "status-text unlocked";
    }

    function handleCardClick() {
        const isLocked = document.getElementById('lockToggle').checked;
        if (isLocked) {
            alert("❌ TRANSACTION DENIED: This Credit Card is currently LOCKED.");
        } else {
            $('#swipeModal').modal('show');
        }
    }
    </script>
</body>
</html>