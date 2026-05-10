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
    <title>Finora | Prepaid Card</title> 
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { 
            background: #f4f7f9; 
            font-family: 'Source Sans Pro', sans-serif; 
            margin: 0; 
            padding: 0; 
        } 
        
        .card-header-bg {
            background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); 
            padding: 5em 0; 
            color: white; 
            text-align: center; 
        }
        
        .content-area {
            padding: 3em 0 5em;
        }

        .card-visual {
            background: linear-gradient(135deg, #1e1e1e 0%, #434343 100%); 
            border-radius: 20px;
            padding: 30px;
            color: white;
            height: 250px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            margin-bottom: 30px; 
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            cursor: pointer; /* Educational trigger indicator */
        }

        .card-visual:hover {
            transform: translateY(-10px) rotateX(5deg); 
        }

        .chip {
            width: 50px; 
            height: 40px;
            background: linear-gradient(135deg, #ffd700 0%, #b8860b 100%);
            border-radius: 8px;
            margin-bottom: 25px; 
        }

        .card-num {
            font-size: 1.6em;
            letter-spacing: 4px;
            font-weight: 600;
            margin-top: 15px;
        }

        .controls-container {
            background: #ffffff; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            border-top: 6px solid #026fbf; 
        }

        .control-item {
            display: flex; 
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee; 
        }

        .balance-text {
            color: #026fbf; 
            font-size: 1.8em;
            font-weight: 900; 
        }

        .btn-action {
            background: #026fbf; 
            color: white !important; 
            padding: 12px 25px; 
            border-radius: 5px; 
            text-transform: uppercase; 
            font-weight: 700; 
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none; 
        }

        /* Stylish Simulation Pop-up Styles */
        .modal-content { border-radius: 15px; border-top: 8px solid #026fbf; }
        .modal-header { border-bottom: none; text-align: center; }
        .modal-title { font-weight: 900; color: #026fbf; }
    </style>
    <style>
    /* Modern iOS Style Toggle Switch */
    .switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 24px;
    }
    .switch input { opacity: 0; width: 0; height: 0; }
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0; left: 0; right: 0; bottom: 0;
        background-color: #28a745; /* Green when unlocked */
        transition: .4s;
        border-radius: 24px;
    }
    .slider:before {
        position: absolute;
        content: "";
        height: 18px; width: 18px;
        left: 3px; bottom: 3px;
        background-color: white;
        transition: .4s;
        border-radius: 50%;
    }
    input:checked + .slider { background-color: #dc3545; } /* Red when locked */
    input:checked + .slider:before { transform: translateX(26px); }

    .status-text { font-weight: 700; margin-right: 10px; text-transform: uppercase; font-size: 0.8em; }
    .locked { color: #dc3545; }
    .unlocked { color: #28a745; }
</style>
</head>

<body>
    <div class="card-header-bg">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">VIRTUAL CARD</h1>
            <p style="opacity: 0.9;">Click the card image to simulate a physical swipe</p>
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
                        String maskedNum = "4532 8810 0000 " + (accNo % 10000); 
            %>
            <div class="col-md-6 col-sm-12">
                <div id="mainCard" class="card-visual" onclick="handleCardClick()">
                    <div class="chip"></div>
                    <div class="card-num"><%= maskedNum %></div>
                    <div class="card-num"> Valid Thru : 2029</div>
                    <div style="margin-top: 30px; text-transform: uppercase; letter-spacing: 1px;">
                        <%= rs.getString("NAME") %>
                    </div>
                    <div style="position: absolute; bottom: 30px; right: 30px; font-weight: 900;">
                        Finora Debit
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-sm-12">
                <div class="controls-container"> 
                    <h3 style="color: #333; font-weight: 700; margin-bottom: 20px;">Card Controls</h3>
                    
                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Available Balance</span>
                        <span class="balance-text"><a href="AccountDetails.jsp">Click here</a></span> 
                    <!--    <span class="balance-text">₹<%= String.format("%.2f", rs.getDouble("BALANCE")) %></span>  -->
                    </div>
                    
                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Online Payments</span> 
                        <span class="label label-success">ACTIVE</span>
                    </div>

                    <div class="control-item"> 
                        <span style="font-weight: 700; color: #888;">Card Security Status</span>
                        <div style="display: flex; align-items: center;">
                            <span id="toggleLabel" class="status-text unlocked">Unlocked</span>
                            <label class="switch">
                                <input type="checkbox" id="lockToggle" onchange="updateLockStatus()">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <a href="UserDashboard.jsp" class="btn-action"> 
                        <i class="fa fa-home"></i> Back to Dashboard 
                    </a>
                </div>
            </div>

            <div class="modal fade" id="swipeModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><i class="fa fa-credit-card"></i> CARD SWIPE SIMULATION</h4>
                        </div>
                        <form action="PrepaidCardPaymentAction.jsp" method="post">
                            <div class="modal-body">
                                <p class="text-center">You are using your physical card at a <strong>Finora POS Merchant</strong>.</p>
                                <hr>
                                <div class="form-group">
                                    <label>Transaction Amount (INR)</label>
                                    <input type="number" name="amount" class="form-control" placeholder="Enter amount to spend" min="1" step="0.01" required>
                                </div>
                                <div class="form-group">
                                    <label>Merchant Reference</label>
                                    <input type="text" name="merchant" class="form-control" value="Retail Store POS" readonly>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary" style="background: #026fbf;">Authorize Swipe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <% 
                    }
                    con.close(); 
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage()); 
                }
            %>
        </div>
    </div>

    <footer style="text-align: center; padding: 20px 0;"> 
        <p class="footer-class">© 2026 <a>Finora</a>. Design by <a>Batch_9_CSE_Java</a>_NIVUNALabs</p> 
    </footer>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
    
    <script>
    function updateLockStatus() {
        const isLocked = document.getElementById('lockToggle').checked;
        const label = document.getElementById('toggleLabel');
        
        if (isLocked) {
            label.innerText = "Locked";
            label.className = "status-text locked";
        } else {
            label.innerText = "Unlocked";
            label.className = "status-text unlocked";
        }
    }

    function handleCardClick() {
        const isLocked = document.getElementById('lockToggle').checked;
        
        if (isLocked) {
            // Best UI Alert using standard browser alert (or you can use a stylish modal)
            alert("❌ TRANSACTION DENIED: This card is currently LOCKED. Please unlock it in Card Controls to use simulation.");
        } else {
            // Manually trigger the Bootstrap Modal if unlocked
            $('#swipeModal').modal('show');
        }
    }
</script>
</body>
</html>