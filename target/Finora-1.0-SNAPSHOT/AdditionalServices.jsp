<%
    // Security check to ensure the user is logged in [cite: 555]
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
    <title>Finora | Advanced Services</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet">
    
    <style>
        body { background: #f4f7f9; font-family: 'Source Sans Pro', sans-serif; }
        
        /* Modern Gradient Header [cite: 503, 572] */
        .services-hero { 
            background: linear-gradient(135deg, #026fbf 0%, #014a80 100%); 
            padding: 6em 0 8em; 
            color: white; 
            text-align: center; 
            clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
        }

        .container-shift { margin-top: -6em; }

        /* Premium Glass Card Effect */
        .service-tile {
            background: #ffffff;
            border-radius: 20px;
            padding: 40px 25px;
            text-align: center;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.8);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); 
            height: 280px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .service-tile:hover {
            transform: translateY(-12px); 
            box-shadow: 0 20px 40px rgba(2, 111, 191, 0.15); 
            border-color: #026fbf;
        }

        /* Icon Styling [cite: 565-567] */
        .icon-circle {
            width: 70px;
            height: 70px;
            background: #f0f7ff;
            color: #026fbf;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2em;
            margin-bottom: 20px;
            transition: 0.3s;
        }

        .service-tile:hover .icon-circle {
            background: #026fbf;
            color: #fff; 
            transform: scale(1.1);
        }

        .service-tile h6 {
            font-size: 1.25em;
            font-weight: 700;
            color: #333;
            margin-bottom: 12px;
            letter-spacing: 0.5px;
        }

        .service-tile p {
            color: #888;
            font-size: 0.95em;
            line-height: 1.5;
        }

        .btn-return {
            background: transparent;
            color: #026fbf !important;
            border: 2px solid #026fbf;
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 700;
            text-transform: uppercase;
            transition: 0.3s;
            display: inline-block;
            margin: 40px 0;
        }

        .btn-return:hover {
            background: #026fbf;
            color: #fff !important;
        }

        a { text-decoration: none !important; }
    </style>
</head>

<body>
    <div class="services-hero">
        <div class="container">
            <h1 style="font-weight: 900; letter-spacing: 2px;">MORE OPTIONS</h1>
            <p style="opacity: 0.9; font-size: 1.1em;">Advanced tools for the elite Finora experience</p>
        </div>
    </div>

    <div class="container container-shift">
        <div class="row">
            
            <a href="SecuritySettings.jsp">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-lock"></i></div>
                        <h6>Security Center</h6>
                        <p>Update your authentication password and contact credentials.</p>
                    </div>
                </div>
            </a>

            <a href="StatementPortal.jsp">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-file-text-o"></i></div>
                        <h6>e-Statements</h6>
                        <p>Generate and download your official transaction history.</p>
                    </div>
                </div>
            </a>

            <a href="#">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-star"></i></div>
                        <h6>Rewards Store</h6>
                        <p>Redeem points earned from your Infinia Credit Card.</p>
                    </div>
                </div>
            </a>

            <a href="SupportTickets.jsp">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-life-ring"></i></div>
                        <h6>Help Desk</h6>
                        <p>Raise support tickets and track resolution status.</p>
                    </div>
                </div>
            </a>

            <a href="#">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-pie-chart"></i></div>
                        <h6>Split Bill</h6>
                        <p>Instantly share costs with your saved beneficiaries.</p>
                    </div>
                </div>
            </a>

            <a href="#">
                <div class="col-md-4 col-sm-6">
                    <div class="service-tile">
                        <div class="icon-circle"><i class="fa fa-map-marker"></i></div>
                        <h6>Locate Us</h6>
                        <p>Find the nearest Finora Intelligent ATM or branch.</p>
                    </div>
                </div>
            </a>

        </div>

        <div class="text-center">
            <a href="UserDashboard.jsp" class="btn-return">
                <i class="fa fa-chevron-left"></i> Return to Dashboard
            </a>
        </div>
    </div>

    <footer style="text-align: center; padding: 40px 0; color: #aaa;"> 
        <p>© 2026 Finora Banking. Design by Batch_9_CSE_Java_NIVUNALabs.</p>
    </footer>

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>