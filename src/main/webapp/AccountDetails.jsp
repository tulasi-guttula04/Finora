<%
    // Security check to ensure the user is logged in [cite: 71]
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html"); 
        return; 
    }
%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="SecurityUtil.SecurityUtil"%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | Account Profile</title> 
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; }
        
        /* Premium Profile Header */
        .profile-header {
            background: linear-gradient(135deg, #026fbf 0%, #014a80 100%);
            padding: 4em 0;
            color: white;
            text-align: center;
            margin-bottom: -5em;
        }
        
        /* Glassmorphism Card Container */
        .details-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 3.5em; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            border-top: 6px solid #026fbf; 
            margin-bottom: 3em;
        }

        /* Modern Grid Layout for Information */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .info-box {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #eef2f6;
            transition: transform 0.3s ease;
        }

        .info-box:hover {
            transform: translateY(-5px);
            border-color: #026fbf; 
        }

        .info-box i {
            color: #026fbf; 
            font-size: 1.5em;
            margin-bottom: 10px;
            display: block;
        }

        .info-label {
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #888;
            font-weight: 700; 
        }

        .info-data {
            font-size: 1.25em; 
            color: #333;
            font-weight: 600;
            margin-top: 5px;
        }

        .status-badge {
            background: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75em;
            vertical-align: middle;
        }
        
        .btn-dashboard {
            background: #026fbf;
            color: white !important;
            padding: 12px 30px;
            border-radius: 5px;
            text-transform: uppercase;
            font-weight: 700;
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
        }
    </style>
    <style>
    .balance-mask {
        filter: blur(8px);
        user-select: none;
        transition: all 0.5s ease;
        display: inline-block;
    }
    .balance-unmasked {
        filter: blur(0);
    }
    .pin-input-group {
        margin-top: 10px;
        display: none; /* Hidden by default */
        animation: slideDown 0.4s ease-out;
    }
    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .btn-reveal {
        font-size: 0.7em;
        color: #026fbf;
        cursor: pointer;
        text-decoration: underline;
        margin-left: 10px;
    }
    .pin-field {
        width: 100px;
        display: inline-block;
        height: 30px;
        font-size: 0.9em;
        text-align: center;
        letter-spacing: 3px;
    }
</style>
</head>

<body>
    <div class="profile-header">
        <div class="container">
            <h2 style="font-weight: 700; letter-spacing: 1px;">MY ACCOUNT PROFILE</h2>
            <p style="opacity: 0.8;">Manage your personal banking information</p>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <div class="details-container">
                    <div class="text-center">
                        <i class="fa fa-user-circle profile-icon" style="font-size: 5em; color: #026fbf;"></i> 
                        <h3 style="color: #333; margin-top: 10px; font-weight: 700;">Account Overview</h3>
                    </div>

                    <div class="info-grid">
                        <%
                        try {
                            String phone = (String) session.getAttribute("phone");
                            Class.forName("org.apache.derby.jdbc.ClientDriver"); 
                            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet"); 
                            
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM USER_DETAILS WHERE PHONE=?");
                            ps.setString(1, phone); 
                            ResultSet rs = ps.executeQuery();
                            
                            if(rs.next()) {
                        %>
                        <div class="info-box">
                            <i class="fa fa-id-card"></i>
                            <div class="info-label">Full Name</div> 
                            <div class="info-data"><%= rs.getString("NAME") %></div> 
                        </div>
                        
                        <%
                            // Derive PIN: First 2 and Last 2 of password
                            String rawPass = rs.getString("PASSWORD"); // Note: Ensure your DB query retrieves PASSWORD
                            String encryptedInput = SecurityUtil.decrypt(rawPass);
                            String derivedPin = "";
                            if(encryptedInput != null && encryptedInput.length() >= 4) {
                                derivedPin = encryptedInput.substring(0, 2) + encryptedInput.substring(encryptedInput.length() - 2);
                            }
                        %>

                        <div class="info-box" style="background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%); border-left: 5px solid #28a745;">
                            <i class="fa fa-money" style="color: #28a745;"></i>
                            <div class="info-label">
                                Available Balance <span class="status-badge">Active</span>
                                <span class="btn-reveal" id="toggleBtn" onclick="togglePinInput()">Show Balance</span>
                            </div>

                            <div id="pinGroup" class="pin-input-group">
                                <input type="password" id="userPin" class="form-control pin-field" placeholder="PIN" maxlength="4">
                                <button class="btn btn-xs btn-success" onclick="verifyPin('<%= derivedPin %>')">Verify</button>
                            </div>

                            <div class="info-data" style="font-size: 1.8em; color: #28a745;">
                                <span id="balanceText" class="balance-mask">
                                    ₹<%= String.format("%.2f", rs.getDouble("BALANCE")) %>
                                </span>
                            </div>
                        </div>

                        <script>
                            function togglePinInput() {
                                const pinGroup = document.getElementById('pinGroup');
                                const toggleBtn = document.getElementById('toggleBtn');

                                if (pinGroup.style.display === 'none' || pinGroup.style.display === '') {
                                    pinGroup.style.display = 'block';
                                    toggleBtn.innerText = 'Cancel';
                                } else {
                                    pinGroup.style.display = 'none';
                                    toggleBtn.innerText = 'Show Balance';
                                }
                            }

                            function verifyPin(correctPin) {
                                const inputPin = document.getElementById('userPin').value;
                                const balanceText = document.getElementById('balanceText');
                                const pinGroup = document.getElementById('pinGroup');
                                const toggleBtn = document.getElementById('toggleBtn');

                                if (inputPin === correctPin) {
                                    balanceText.classList.add('balance-unmasked');
                                    pinGroup.style.display = 'none';
                                    toggleBtn.style.display = 'none'; // Hide the button once revealed
                                } else {
                                    alert("Incorrect PIN. Please try again.");
                                    document.getElementById('userPin').value = '';
                                }
                            }
                        </script>

                        <div class="info-box" style="border-left: 4px solid #026fbf;">
                            <i class="fa fa-university"></i>
                            <div class="info-label">Account Number</div> 
                            <div class="info-data"><%= rs.getLong("ACCOUNT_NO") %></div> 
                        </div>

                        <div class="info-box">
                            <i class="fa fa-code-fork"></i>
                            <div class="info-label">Sort Code</div> 
                            <div class="info-data"><%= rs.getString("SORT_CODE") %></div> 
                        </div>

                        <div class="info-box">
                            <i class="fa fa-envelope"></i>
                            <div class="info-label">Email Address</div> 
                            <div class="info-data"><%= rs.getString("EMAIL") %></div> 
                        </div>

                        <div class="info-box">
                            <i class="fa fa-phone"></i>
                            <div class="info-label">Registered Phone</div> 
                            <div class="info-data"><%= rs.getString("PHONE") %></div> 
                        </div>

                        <div class="info-box">
                            <i class="fa fa-shield"></i>
                            <div class="info-label">PAN Card Number</div> 
                            <div class="info-data"><%= rs.getString("PAN") %></div> 
                        </div>
                        <% 
                            }
                            con.close(); 
                        } catch(Exception e) {
                            out.println("<p class='text-danger'>Error loading profile: " + e.getMessage() + "</p>"); 
                        }
                        %>
                    </div>

                    <div class="text-center" style="margin-top: 40px;">
                        <a href="UserDashboard.jsp" class="btn-dashboard"> 
                            <i class="fa fa-arrow-left"></i> Return to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <p class="footer-class">© 2026 <a>Finora</a>. Design by <a>Batch_9_CSE_Java</a>_NIVUNALabs</p>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>