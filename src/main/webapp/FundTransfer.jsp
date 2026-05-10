<%-- [cite: 568-570] --%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="SecurityUtil.SecurityUtil"%>
<%
    if (session.getAttribute("phone") == null) {
        response.sendRedirect("index.html");
        return; 
    }
    String phone = (String) session.getAttribute("phone");
%>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <title>Finora | Secure Fund Transfer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; } 
        
        /* Header Fix: Removed negative margin to prevent overlapping [cite: 572] */
        .transfer-header { 
            background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); 
            padding: 4em 0 6em; 
            color: white; 
            text-align: center; 
        }
        
        /* Layout Fix: Use relative positioning and proper margins to prevent card overlap [cite: 573] */
        .main-content-wrapper {
            margin-top: -4em;
            position: relative;
            z-index: 10;
        }

        .transfer-card {
            background: #ffffff; 
            border-radius: 15px; 
            padding: 2.5em;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08); 
            border-top: 6px solid #026fbf;
            margin-bottom: 2em; 
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); 
        }

        /* Beneficiary List Fix: Added specific height and scroll to prevent card stretching  */
        .ben-list-container {
            max-height: 450px;
            overflow-y: auto;
            padding: 5px;
        }

        .ben-item { 
            background: #fff; 
            border: 1px solid #eef2f6; 
            padding: 12px; 
            border-radius: 10px; 
            margin-bottom: 10px; 
            cursor: pointer; 
            transition: all 0.2s ease; 
            display: flex; 
            align-items: center;
        }

        .ben-item:hover { 
            transform: translateX(5px); 
            border-color: #026fbf; 
            background: #fcfdfe;
        }

        .ben-icon { 
            width: 35px; height: 35px; 
            background: #e7f3ff; 
            color: #026fbf;
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            margin-right: 12px;
        }
        
        .form-group label { font-weight: 700; color: #026fbf; text-transform: uppercase; font-size: 0.8em; letter-spacing: 1px; margin-bottom: 8px; }
        .form-control { border-radius: 6px; height: 45px; border: 1px solid #eef2f6; box-shadow: none !important; }
        .btn-send { background: #026fbf; color: white !important; padding: 14px; border-radius: 6px; text-transform: uppercase; font-weight: 700; width: 100%; border: none; margin-top: 10px; }
        .btn-send:hover { background: #014a80; }
    
    
    /* Voice Input Styling */
.voice-input-container {
    position: relative;
    display: flex;
    align-items: center;
}
.mic-btn {
    position: absolute;
    right: 10px;
    background: none;
    border: none;
    color: #026fbf;
    cursor: pointer;
    font-size: 1.2em;
    transition: all 0.3s ease;
    z-index: 5;
}
.mic-btn.recording {
    color: #dc3545;
    animation: pulse-red 1.5s infinite;
}
@keyframes pulse-red {
    0% { transform: scale(1); text-shadow: 0 0 0 rgba(220, 53, 69, 0.7); }
    70% { transform: scale(1.2); text-shadow: 0 0 10px rgba(220, 53, 69, 0); }
    100% { transform: scale(1); text-shadow: 0 0 0 rgba(220, 53, 69, 0); }
}
.voice-status-msg {
    font-size: 0.75em;
    color: #dc3545;
    margin-top: 5px;
    display: none;
    font-weight: 600;
    animation: fadeIn 0.3s;
}
    </style>
    <style>
    .shake-animation {
        animation: shake 0.5s;
    }
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-10px); }
        75% { transform: translateX(10px); }
    }
</style>
</head>

<body>
    <div class="transfer-header">
        <div class="container">
            <h2 style="font-weight: 900; letter-spacing: 1px; margin: 0;">SECURE FUND TRANSFER</h2>
            <p style="opacity: 0.8; margin-top: 10px;">Transfer funds instantly to any Finora account</p>
        </div>
    </div>

    <div class="container main-content-wrapper">
        <div class="row">
            <div class="col-md-4">
                <div class="transfer-card">
                    <h4 style="font-weight: 700; color: #333; margin-bottom: 20px; border-bottom: 2px solid #f4f7f9; padding-bottom: 10px;">
                        <i class="fa fa-users" style="color: #026fbf;"></i> Funds can be transferred only to added beneficiaries
                    </h4>
                    <div class="ben-list-container">
                        <%
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
                                PreparedStatement psBen = con.prepareStatement("SELECT * FROM BENEFICIARIES WHERE OWNER_PHONE = ?");
                                psBen.setString(1, phone);
                                ResultSet rsBen = psBen.executeQuery();
                                boolean hasBen = false;
                                while(rsBen.next()) {
                                    hasBen = true;
                        %>
                            <div class="ben-item" onclick="selectBeneficiary('<%= rsBen.getLong("BENEFICIARY_ACC") %>')">
                                <div class="ben-icon"><i class="fa fa-user"></i></div>
                                <div style="overflow: hidden;">
                                    <div style="font-weight: 700; color: #333; white-space: nowrap; text-overflow: ellipsis;"><%= rsBen.getString("BENEFICIARY_NAME") %></div>
                                    <div style="font-size: 0.85em; color: #888;"><%= rsBen.getLong("BENEFICIARY_ACC") %></div>
                                </div>
                            </div>
                            <form action="DeleteBeneficiaryAction.jsp" method="post" onsubmit="return confirm('Remove this beneficiary?');">
                                <input type="hidden" name="bid" value="<%= rsBen.getInt("BID") %>">
                                <button type="submit" style="background: none; border: none; color: #dc3545; padding: 5px;">
                                    <i class="fa fa-trash-o"></i>
                                </button>
                            </form>
                        <% } con.close(); if(!hasBen) { %>
                            <div class="text-center" style="padding: 20px; color: #bbb;">
                                <i class="fa fa-address-book-o fa-2x"></i>
                                <p style="margin-top: 10px; font-size: 0.9em;">No contacts yet.</p>
                            </div>
                        <% } } catch(Exception e) { } %>
                    </div>
                    <button class="btn btn-default btn-block" style="margin-top: 15px; border: 1px dashed #026fbf; color: #026fbf; font-weight: 700;" data-toggle="modal" data-target="#addBenModal">
                        <i class="fa fa-plus-circle"></i> Add New
                    </button>
                </div>
            </div>

            <div class="col-md-8">
                <div class="transfer-card">
                    
                    <div style="background: #f8fbff; padding: 20px; border-radius: 10px; margin-bottom: 25px; border: 1px solid #e7f3ff;">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                            <span style="color: #666; font-weight: 600; text-transform: uppercase; font-size: 0.8em;">Available Balance</span>
                            <%
                                String derivedPin = ""; // Initialize the PIN variable [cite: 879]
                                try {
                                    Connection conB = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");

                                    // Updated query to also fetch PASSWORD for PIN derivation [cite: 878, 1073]
                                    PreparedStatement psB = conB.prepareStatement("SELECT BALANCE, SORT_CODE, PASSWORD FROM USER_DETAILS WHERE PHONE=?");
                                    psB.setString(1, phone);
                                    ResultSet rsB = psB.executeQuery();

                                    if(rsB.next()) {
                                        double balance = rsB.getDouble("BALANCE"); 
                                        String sortCode = rsB.getString("SORT_CODE"); 

                                        // --- PIN DERIVATION LOGIC START ---
                                        String rawPass = rsB.getString("PASSWORD"); 
                                        String decrypted = SecurityUtil.decrypt(rawPass);
                                        if(decrypted != null && decrypted.length() >= 4) {
                                            // Takes first 2 and last 2 characters [cite: 879]
                                            derivedPin = decrypted.substring(0, 2) + decrypted.substring(decrypted.length() - 2); 
                                        }
                                        // --- PIN DERIVATION LOGIC END ---
                            %>
                            <span style="font-size: 1.4em; font-weight: 900; color: #026fbf;"><a href="AccountDetails.jsp">Click here</a></span>
                        </div>
                        <div style="border-top: 1px solid #eef2f6; padding-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                            <span style="color: #888; font-size: 0.8em; font-weight: 600; text-transform: uppercase;">Sort Code</span>
                            <span style="color: #333; font-weight: 700; letter-spacing: 1px;"><%= sortCode %></span>
                        </div>
                        <%
                                    }
                                    conB.close();
                                } catch(Exception e) { out.print("Error loading security data"); }
                            %>
                    </div>

                    <form id="transferForm" action="TransferAction.jsp" method="post">
                        <input type="hidden" name="senderPhone" value="<%= phone %>">
                        
                        <div class="form-group">
                            <label><i class="fa fa-university"></i> Recipient Account Number</label>
                            <input type="text" id="receiverAcc" name="receiverAcc" class="form-control" placeholder="12-digit Account Number" required>
                        </div>

                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label><i class="fa fa-money"></i> Amount (INR)</label>
                                    <div class="voice-input-container">
                                        <input type="number" name="amount" id="amountInput" class="form-control" 
                                               placeholder="0.00" min="1" step="0.01" required>
                                        <button type="button" class="mic-btn" id="startVoice" title="Speak Amount">
                                            <i class="fa fa-microphone"></i>
                                        </button>
                                    </div>
                                    <div id="voiceStatus" class="voice-status-msg">Listening...</div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label><i class="fa fa-commenting-o"></i> Reference</label>
                                    <input type="text" name="reference" class="form-control" placeholder="e.g. Rent Payment">
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn-send" onclick="initiateTransfer()">
                            <i class="fa fa-paper-plane"></i> Send Funds Instantly
                        </button>


                    </form>
                    
                    <div class="text-center" style="margin-top: 20px;">
                        <a href="UserDashboard.jsp" style="color: #888; text-decoration: none; font-size: 0.9em;">
                            <i class="fa fa-arrow-left"></i> Return to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addBenModal" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content" style="border-radius: 15px; border-top: 8px solid #026fbf;">
                <div class="modal-header">
                    <h4 class="modal-title" style="font-weight: 900; color: #026fbf;">NEW CONTACT</h4>
                </div>
                <form action="AddBeneficiaryAction.jsp" method="post">
                    <div class="modal-body">
                        <div class="form-group">
                            <label>Name</label>
                            <input type="text" name="benName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Account No</label>
                            <input type="text" name="benAcc" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer" style="border: none;">
                        <button type="submit" class="btn btn-primary btn-block" style="background: #026fbf;">Save Contact</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script>
        function selectBeneficiary(accNo) {
            document.getElementById('receiverAcc').value = accNo;
            $('#receiverAcc').fadeOut(100).fadeIn(100); // Visual cue
        }
    </script>
    <script>
    const amountInput = document.getElementById('amountInput');
    const micBtn = document.getElementById('startVoice');
    const voiceStatus = document.getElementById('voiceStatus');

    // Check for browser support
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

    if (SpeechRecognition) {
        const recognition = new SpeechRecognition();
        recognition.continuous = false;
        recognition.lang = 'en-US';
        recognition.interimResults = false;

        micBtn.addEventListener('click', () => {
            recognition.start();
        });

        recognition.onstart = () => {
            micBtn.classList.add('recording');
            voiceStatus.style.display = 'block';
            amountInput.placeholder = "Say an amount...";
        };

        recognition.onspeechend = () => {
            recognition.stop();
            micBtn.classList.remove('recording');
            voiceStatus.style.display = 'none';
        };

        recognition.onresult = (event) => {
            const transcript = event.results[0][0].transcript;
            // Clean the string (remove currency symbols or words like "rupees")
            const cleanAmount = transcript.replace(/[^0-9.]/g, '');
            
            if (cleanAmount) {
                amountInput.value = cleanAmount;
                // UI Highlight Animation
                amountInput.style.backgroundColor = "#e7f3ff";
                setTimeout(() => { amountInput.style.backgroundColor = "#fff"; }, 1000);
            } else {
                alert("Could not recognize a number. Please try again.");
            }
        };

        recognition.onerror = (event) => {
            micBtn.classList.remove('recording');
            voiceStatus.style.display = 'none';
            console.error("Speech recognition error", event.error);
        };

    } else {
        micBtn.style.display = 'none';
        console.log("Speech Recognition not supported in this browser.");
    }
</script>
<script>
    const CORRECT_PIN = "<%= derivedPin %>";

    function initiateTransfer() {
        // Basic form validation first
        const acc = document.getElementById('receiverAcc').value;
        const amt = document.getElementById('amountInput').value;
        
        if(!acc || !amt) {
            alert("Please fill in recipient details and amount first.");
            return;
        }
        
        // Trigger Modal with Animation
        $('#pinModal').modal('show');
        setTimeout(() => document.getElementById('transferPin').focus(), 500);
    }

    function validateAndSubmit() {
        const inputPin = document.getElementById('transferPin').value;
        const btn = event.target;

        if(inputPin === CORRECT_PIN) {
            btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> AUTHORIZING...';

            // Use the specific ID instead of document.forms[1]
            document.getElementById('transferForm').submit(); 
        } else {
            alert("❌ Invalid Security PIN.");
        }
    }
    
</script>
                        <div class="modal fade" id="pinModal" tabindex="-1" role="dialog">
                            <div class="modal-dialog modal-sm" role="document">
                                <div class="modal-content" style="border-top: 8px solid #026fbf; border-radius: 15px; text-align: center;">
                                    <div class="modal-header" style="border: none; padding-top: 30px;">
                                        <div class="icon-circle" style="margin: 0 auto 15px; width: 60px; height: 60px; background: #f0f7ff; color: #026fbf; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5em;">
                                            <i class="fa fa-shield"></i>
                                        </div>
                                        <h4 class="modal-title" style="font-weight: 800; color: #333;">VERIFY PIN</h4>
                                        <p class="text-muted" style="font-size: 0.85em;">Enter your 4-digit security PIN to authorize</p>
                                    </div>
                                    <div class="modal-body" style="padding: 0 30px 30px;">
                                        <div class="pin-display-wrapper" style="margin-bottom: 20px;">
                                            <input type="password" id="transferPin" maxlength="4" 
                                                   style="letter-spacing: 15px; text-align: center; font-size: 2em; width: 100%; border: 2px solid #eef2f6; border-radius: 10px; height: 60px; outline: none; transition: border-color 0.3s;"
                                                   oninput="this.style.borderColor = (this.value.length === 4) ? '#28a745' : '#026fbf'">
                                        </div>
                                        <button type="button" class="btn btn-primary btn-block" onclick="validateAndSubmit()" 
                                                style="background: #026fbf; padding: 12px; font-weight: 700; border-radius: 8px; border: none; box-shadow: 0 4px 12px rgba(2, 111, 191, 0.2);">
                                            CONFIRM & TRANSFER
                                        </button>
                                        <button type="button" class="btn btn-link text-muted" data-dismiss="modal" style="margin-top: 10px; font-size: 0.8em;">Cancel Transaction</button>
                                    </div>
                                </div>
                            </div>
                        </div>
</body>
</html>