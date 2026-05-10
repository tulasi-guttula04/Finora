<%
    // Security check to ensure the user is logged in [cite: 80, 143]
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
    <title>Finora | Nominee Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; margin: 0; padding: 0; } /* [cite: 83, 146] */
        
        .nominee-header {
            background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); /* [cite: 84, 121] */
            padding: 5em 0;
            color: white;
            text-align: center;
        }

        .content-area { padding: 3em 0 5em; } /* [cite: 149] */

        .nominee-card {
            background: #ffffff;
            border-radius: 15px;
            padding: 35px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); /* [cite: 85, 122] */
            border-top: 6px solid #026fbf; /* [cite: 150] */
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            margin-bottom: 30px;
        }

        .nominee-card:hover { transform: translateY(-8px); } /* [cite: 9, 154] */

        .info-label {
            font-size: 0.8em;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: #888;
            font-weight: 700; /* [cite: 92, 157] */
        }

        .info-data {
            font-size: 1.2em;
            color: #333;
            font-weight: 600;
            margin-bottom: 15px; /* [cite: 93, 158] */
        }

        .form-control {
            height: 45px;
            border-radius: 5px;
            border: 1px solid #eef2f6; /* [cite: 126] */
        }
    </style>
</head>

<body>
    <div class="nominee-header">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">NOMINEE DETAILS</h1>
            <p style="opacity: 0.9;">Secure your account by managing beneficiary information</p>
        </div>
    </div>

    <div class="container content-area">
        <div class="row">
            <%
                try {
                    String phone = (String) session.getAttribute("phone"); /* [cite: 100, 165] */
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet"); /* [cite: 101, 165] */
                    
                    // Note: Ensure your USER_DETAILS table has NOMINEE_NAME and NOMINEE_RELATION columns
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM USER_DETAILS WHERE PHONE=?");
                    ps.setString(1, phone);
                    ResultSet rs = ps.executeQuery();
                    
                    if(rs.next()) {
            %>
            
            <div class="col-md-5">
                <div class="nominee-card">
                    <h3 style="font-weight: 700; color: #026fbf; margin-bottom: 25px;"><i class="fa fa-users"></i> Current Nominee</h3>
                    
                    <div class="info-label">Nominee Name</div>
                    <div class="info-data"><%=rs.getString(9)%></div>
                    
                    <div class="info-label">Relationship</div>
                    <div class="info-data"><%=rs.getString(10)%></div>
                    
                    <div style="background: #fff8e1; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107;">
                        <small style="color: #856404;"><i class="fa fa-warning"></i> Please add a nominee to ensure seamless account transition in the future.</small>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="nominee-card">
                    <h3 style="font-weight: 700; color: #333; margin-bottom: 25px;">Update Nominee</h3>
                    <form action="UpdateNomineeAction.jsp" method="post">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="info-label">Full Name</label>
                                    <input type="text" name="n_name" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="info-label">Relationship</label>
                                    <select name="n_relation" class="form-control">
                                        <option>Father</option>
                                        <option>Mother</option>
                                        <option>Spouse</option>
                                        <option>Sibling</option>
                                        <option>Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn-dashboard" style="width: 100%; border: none; background: #026fbf; color: white; padding: 12px; border-radius: 5px; font-weight: 700; margin-top: 10px;">
                            SAVE NOMINEE DETAILS
                        </button>
                    </form>
                    <div class="text-center" style="margin-top: 20px;">
                        <a href="UserDashboard.jsp" style="color: #888; text-decoration: none;"><i class="fa fa-home"></i> Back to Dashboard</a>
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

    <footer style="text-align: center; padding: 20px 0;">
        <p class="footer-class">© 2026 <a>Finora</a>. Design by <a>Batch_9_CSE_Java</a>_NIVUNALabs</p> </footer>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>