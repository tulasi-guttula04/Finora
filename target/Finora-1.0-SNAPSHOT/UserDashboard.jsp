<%
    // Check if the user is logged in by verifying the session attribute
    if (session.getAttribute("phone") == null) {
        // If no session exists, redirect the user back to the login page
        response.sendRedirect("index.html");
        return; // Stop further execution of the page
    }
%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zxx">


<!-- Mirrored from p.w3layouts.com/demos_new/template_demo/05-02-2018/revenue-demo_Free/262669190/web/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 19 Jan 2026 17:02:26 GMT -->
<head>
    <title>Finora</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="Revenue Responsive web template, Bootstrap Web Templates, Flat Web Templates, Android Compatible web template, 
	SmartPhone Compatible web template, free WebDesigns for Nokia, Samsung, LG, Sony Ericsson, Motorola web design" />
    <script>
        addEventListener("load", function () {
            setTimeout(hideURLbar, 0);
        }, false);

        function hideURLbar() {
            window.scrollTo(0, 1);
        }
    </script>
    <!-- Custom Theme files -->
    <link href="css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <!-- gallery smoothbox -->
    <link rel="stylesheet" href="css/smoothbox.css" type='text/css' media="all" />
    <!-- team deoslide -->
    <link rel="stylesheet" href="css/jquery.desoslide.css">
    <link href="css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="css/font-awesome.css" rel="stylesheet">
    <!-- font-awesome icons -->
    <!-- //Custom Theme files -->
    <!-- web-fonts -->
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,200i,300,300i,400,400i,600,600i,700,700i,900,900i" rel="stylesheet">
    <!-- //web-fonts -->

    <style>
    
        /* Base state for the activity blocks */
.service-subgrids {
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); /* Professional easing [cite: 5, 7] */
    cursor: pointer;
}

/* Hover state: Lift and Glow */
.service-subgrids:hover {
    transform: translateY(-8px); /* Moves the block up slightly */
    box-shadow: 0 12px 24px rgba(2, 111, 191, 0.2); /* Soft brand-colored glow [cite: 9] */
    z-index: 10;
}

/* Icon Animation */
.service-subgrids:hover i {
    transform: scale(1.2) rotate(5deg); /* Bounces the icon slightly */
    color: #fff; /* Ensures icon stands out if background changes [cite: 11] */
    transition: all 0.3s ease;
}

/* Optional: Text color shift on hover */
.service-subgrids:hover h6 {
    color: #ffd700; /* Gold accent color for better UX [cite: 55] */
}
    </style>
</head>

<body>
    <div class="top-nav">
        <!--nav top-->
		<!---728x90--->
        <!-- nav-bottom -->
        <div class="inner-header">
            <nav class="navbar navbar-default">
                <div class="navbar-header">

                    <h1>
                        <a href="index.html">
                            Finora</a>
                    </h1>
                </div>
                <!-- navbar-header -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li>
                            <a href="#" data-toggle="modal" data-target="#cashDepositModal" style="color: #28a745; font-weight: 700;">
                                <i class="fa fa-plus-circle"></i> Deposit Cash
                            </a>
                        </li>
                        <li>
                            <a href="#" data-toggle="modal" data-target="#withdrawModal" style="color: #dc3545; font-weight: 700;">
                                <i class="fa fa-minus-circle"></i> Withdraw Cash
                            </a>
                        </li>
                        <li>
                            <a href="Logout.jsp" >Logout</a>
                        </li>
                    </ul>
                </div>
                <div class="clearfix"> </div>
            </nav>
        </div>
    </div>
    <!--/nav ends here-->
    <!-- banner -->

    <!-- //banner -->
    <!--about -->

    <!-- //about -->
    <!-- services -->
    <div class="services section" id="services">
        <div class="container2">
            <%
            try
            {
            String phone = (String) session.getAttribute("phone");
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
            Statement st = con.createStatement();
            ResultSet rs= st.executeQuery("SELECT * FROM USER_DETAILS WHERE PHONE='"+phone+"'");
            while(rs.next()){ 
            %>
            <h3 class="title-txt">Hello <span><%=rs.getString(1)%></span></h3>
            <% 
            } rs.close(); st.close(); con.close();   
            }
            catch(Exception e){}
            %>
            <h5>How can I <span>help</span> you <span>today</span>.</h5>
            <div class="col-md-5 service-left-grid">
                <div class="services-left">

                    <h4> You are eligible for 
                        <span>Finora Infinia</span> Credit Card. </h4>
                    <p> This card offers unlimited lounge access, premium dining privileges, high reward points, hotel discounts, milestone fee waivers, and luxury lifestyle benefits for elite travelers. </p>
                    <ul class="serv-list">
                        <li>
                            <a href="#gallery" class="abtlink scroll">Apply</a>
                        </li>
                        <li>
                            <a href="#contact" class="abtlink scroll">contact us</a>
                        </li>
                    </ul>

                </div>
            </div>
            <a href="AccountDetails.jsp">
            <div class="col-md-7 text-center agileinfo-about-grid">
                <div class="col-md-4 col-xs-4 service-subgrids">
                <div class="w3ls-about-grid">
                    <i class="fa fa-user-circle-o" aria-hidden="true"></i>
                    <h6>Account Details</h6>
                    <p>Check your details</p>
                </div>
            </div>
            </a>

            <div class="col-md-4 col-xs-4 service-subgrids">
                <a href="FundTransfer.jsp">
                <div class="w3ls-about-grid">
                    <i class="fa fa-exchange" aria-hidden="true"></i>
                    <h6>Fund Transfer</h6>
                    <p>Secure & Fast</p>
                </div>
                </a>
            </div>

            <a href="PrepaidCard.jsp">
            <div class="col-md-4 col-xs-4 service-subgrids">
                <div class="w3ls-about-grid">
                    <i class="fa fa-credit-card" aria-hidden="true"></i>
                    <h6>Prepaid Card</h6>
                    <p>View & Control</p>
                </div>
            </div>
            </a>

            <div class="col-md-4 col-xs-4 service-subgrids">
                <a href="TransactionHistory.jsp">
                <div class="w3ls-about-grid">
                    <i class="fa fa-list-alt" aria-hidden="true"></i>
                    <h6>Transactions</h6>
                    <p>Track your history</p>
                </div>
                </a>
            </div>

            <a href="LoanManagement.jsp">
            <div class="col-md-4 col-xs-4 service-subgrids">
                <div class="w3ls-about-grid">
                    <i class="fa fa-handshake-o" aria-hidden="true"></i>
                    <h6>Loans</h6>
                    <p>View & Manage</p>
                </div>
            </div>
            </a>

            <div class="col-md-4 col-xs-4 service-subgrids">
                <a href="NomineeDetails.jsp">
                <div class="w3ls-about-grid">
                    <i class="fa fa-users" aria-hidden="true"></i>
                    <h6>Nominee</h6>
                    <p> Manage nominee details</p>
                </div>
                </a>
            </div>

            <a href="Deposits.jsp">
            <div class="col-md-4 col-xs-4 service-subgrids">
                <div class="w3ls-about-grid">
                    <i class="fa fa-university" aria-hidden="true"></i>
                    <h6>Deposits</h6>
                    <p>Save Money Securely</p>
                </div>
            </div>
            </a>

           <div class="col-md-4 col-xs-4 service-subgrids">
               <a href="CreditCard.jsp">
                <div class="w3ls-about-grid">
                    <i class="fa fa-credit-card-alt" aria-hidden="true"></i>
                    <h6>Credit Card</h6>
                    <p>Pay Monthly Bills</p>
                </div>
                </a>
            </div>

            <a href="AdditionalServices.jsp">
            <div class="col-md-4 col-xs-4 service-subgrids">
                <div class="w3ls-about-grid">
                    <i class="fa fa-plus-circle" aria-hidden="true"></i>
                    <h6>More Options</h6>
                    <p>Access additional services</p>
                </div>
            </div>
            </a>
                <div class="clearfix"></div>
            </div>
            <div class="clearfix"></div>

        </div>
    </div>
    <!-- //services -->
    <!--about manager -->

    <!-- //about manager -->
    <!-- faq -->
    <!-- //faq -->
	<!---728x90--->
    <!-- gallery -->

    <!-- //gallery -->
    <!-- team -->

    <!-- //team -->
    <!-- testimonials -->

    <!-- //testimonials -->
    <!-- contact -->
    <div class="contact-main section" id="contact">
        <div class="container">
            <h3 class="title-txt">
                <span>c</span>ontact us</h3>
            <div class="col-md-4 contact-leftgrid">
                <div class="contact-g1">
                    <h6>Get In Touch</h6>
                    <ul class="address">
                        <li>
                            <span class="fa fa-phone" aria-hidden="true"></span>
                            1800 1900 1700
                        </li>
                        <li>
                            <span class="fa fa-envelope" aria-hidden="true"></span>
                            <a href=""> <span class="__cf_email__" data-cfemail="6b060a02072b0e130a061b070e45080406">help@finora.com</span></a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-8 contact-center">
                <div class="col-md-10 contact-g2">

                    <div class="subscribe-grid ">
                        <p>subscribe To receive helpful articles, customer alerts, services & more.</p>

                        <form action="#" method="post">
                            <input type="email" placeholder="Your Email" name="Subscribe" required="">
                            <button class="btn1">
                                <i class="fa fa-paper-plane-o" aria-hidden="true"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="clearfix"></div>
        </div>

    </div>
    <!-- contact -->
	<!---728x90--->
    <!-- copy right -->
    <p class="footer-class">© 2026 <a>Finora</a>. Design by <a>Batch_9_CSE_Java</a>_NIVUNALabs
    </p>
    <!-- //copy right -->
    <!-- bootstrap-pop-up for login and register -->
    <div class="modal video-modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    Be a Member of Revenue
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <section>
                    <div class="modal-body">
                        <div class="loginf_module">
                            <div class="module form-module">
                                <div class="toggle">
                                    <i class="fa fa-times fa-pencil"></i>
                                    <div class="tooltip">Click Me</div>
                                </div>
                                <div class="form">
                                    <h3>Login to your account</h3>
                                    <form action="#" method="post">
                                        <input type="text" name="Username" placeholder="Username" required="">
                                        <input type="password" name="Password" placeholder="Password" required="">
                                        <input type="submit" value="Login">
                                    </form>
                                    <div class="cta">
                                        <a href="#">Forgot password?</a>
                                    </div>
                                </div>
                                <div class="form">
                                    <h3>Create a new account</h3>
                                    <form action="#" method="post">
                                        <input type="text" name="Username" placeholder="Username" required="">
                                        <input type="password" name="Password" placeholder="Password" required="">
                                        <input type="email" name="Email" placeholder="Email address" required="">
                                        <input type="text" name="Phone" placeholder="Phone Number" required="">
                                        <input type="submit" value="Register">
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
    <!-- //bootstrap-pop-up for login and register-->

    <!-- js -->
    <script data-cfasync="false" src="../../../../../../cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="js/jquery-2.2.3.min.js"></script>
    <!-- //js -->
    <!-- about numscroller -->
    <script src="js/numscroller-1.0.js"></script>
    <!-- //about numscroller -->
    <!-- banner Slider starts Here -->
    <script src="js/responsiveslides.min.js"></script>
    <script>
        // You can also use "$(window).load(function() {"
        $(function () {
            // Slideshow 3
            $("#slider3").responsiveSlides({
                auto: true,
                pager: true,
                nav: false,
                speed: 500,
                namespace: "callbacks",
                before: function () {
                    $('.events').append("<li>before event fired.</li>");
                },
                after: function () {
                    $('.events').append("<li>after event fired.</li>");
                }
            });

        });
    </script>
    <!-- //banner slider script ends -->
    <!-- sign in and signup pop up toggle script -->
    <script>
        $('.toggle').click(function () {
            // Switches the Icon
            $(this).children('i').toggleClass('fa-pencil');
            // Switches the forms  
            $('.form').animate({
                height: "toggle",
                'padding-top': 'toggle',
                'padding-bottom': 'toggle',
                opacity: "toggle"
            }, "slow");
        });
    </script>
    <!-- sign in and signup pop up toggle script -->
    <!-- team desoslide-JavaScript -->
    <script src="js/jquery.desoslide.js"></script>
    <script>
        $('#demo1_thumbs').desoSlide({
            main: {
                container: '#demo1_main_image',
                cssClass: 'img-responsive'
            },
            effect: 'sideFade',
            caption: true
        });
    </script>
    <!-- //team desoslide-JavaScript -->
    <!-- Flexslider-js for-testimonials -->
    <script src="js/jquery.flexisel.js"></script>
    <script>
        $(window).load(function () {
            $("#flexiselDemo1").flexisel({
                visibleItems: 1,
                animationSpeed: 1000,
                autoPlay: false,
                autoPlaySpeed: 3000,
                pauseOnHover: true,
                enableResponsiveBreakpoints: true,
                responsiveBreakpoints: {
                    portrait: {
                        changePoint: 480,
                        visibleItems: 1
                    },
                    landscape: {
                        changePoint: 640,
                        visibleItems: 1
                    },
                    tablet: {
                        changePoint: 768,
                        visibleItems: 1
                    }
                }
            });

        });
    </script>
    <!-- //Flexslider-js for-testimonials -->
    <!-- start-smooth-scrolling -->
    <script src="js/move-top.js"></script>
    <script src="js/easing.js"></script>
    <script>
        jQuery(document).ready(function ($) {
            $(".scroll").click(function (event) {
                event.preventDefault();

                $('html,body').animate({
                    scrollTop: $(this.hash).offset().top
                }, 1000);
            });
        });
    </script>
    <!-- //end-smooth-scrolling -->
    <!-- smooth-scrolling-of-move-up -->
    <script>
        $(document).ready(function () {
            /*
            var defaults = {
                containerID: 'toTop', // fading element id
                containerHoverID: 'toTopHover', // fading element hover id
                scrollSpeed: 1200,
                easingType: 'linear' 
            };
            */

            $().UItoTop({
                easingType: 'easeOutQuart'
            });

        });
    </script>
    <script src="js/SmoothScroll.min.js"></script>
    <!-- //smooth-scrolling-of-move-up -->
    <!-- gallery smoothbox -->
    <script src="js/smoothbox.jquery2.js"></script>
    <!-- //gallery smoothbox -->
    <!-- Bootstrap core JavaScript
 ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/bootstrap.js"></script>
<script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9c07e6156a7b814b',t:'MTc2ODg0MjEzNQ=='};var a=document.createElement('script');a.src='../../../../../../cdn-cgi/challenge-platform/h/b/scripts/jsd/d251aa49a8a3/maind41d.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script><script defer src="https://static.cloudflareinsights.com/beacon.min.js/vcd15cbe7772f49c399c6a5babf22c1241717689176015" integrity="sha512-ZpsOmlRQV6y907TI0dKBHq9Md29nnaEIPlkf84rnaERnq6zvWvPUqr2ft8M1aS28oN72PdrCzSjY4U6VaAw1EQ==" data-cf-beacon='{"version":"2024.11.0","token":"ec75ad4155f144c68847bd31482c9a15","r":1,"server_timing":{"name":{"cfCacheStatus":true,"cfEdge":true,"cfExtPri":true,"cfL4":true,"cfOrigin":true,"cfSpeedBrain":true},"location_startswith":null}}' crossorigin="anonymous"></script>

<div class="modal fade" id="cashDepositModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content" style="border-top: 8px solid #28a745; border-radius: 15px;">
            <div class="modal-header">
                <h4 class="modal-title" style="color: #28a745;"><i class="fa fa-money"></i> CASH DEPOSIT SIMULATION</h4>
            </div>
            <form action="CashDepositAction.jsp" method="post">
                <div class="modal-body">
                    <p class="text-center">Simulating a physical cash deposit at a <strong>Finora Intelligent ATM</strong>.</p>
                    <div class="form-group">
                        <label>Deposit Amount (INR)</label>
                        <input type="number" name="amount" class="form-control" placeholder="Enter amount to deposit" min="100" step="100" required>
                        <small class="text-muted">Minimum deposit: ₹100 (Multiples of 100 only)</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success" style="background: #28a745; border: none;">Confirm Deposit</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="withdrawModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content" style="border-top: 8px solid #dc3545; border-radius: 15px;">
            <div class="modal-header">
                <h4 class="modal-title" style="color: #dc3545;"><i class="fa fa-bank"></i> CASH WITHDRAWAL SIMULATION</h4>
            </div>
            <form action="WithdrawAction.jsp" method="post">
                <div class="modal-body">
                    <p class="text-center">Simulating a physical cash withdrawal from a <strong>Finora ATM</strong>.</p>
                    <div class="form-group">
                        <label>Withdrawal Amount (INR)</label>
                        <input type="number" name="amount" class="form-control" placeholder="Enter amount to withdraw" min="100" step="100" required>
                        <small class="text-muted">Available in multiples of ₹100 only.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger" style="background: #dc3545; border: none;">Withdraw Cash</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>


<!-- Mirrored from p.w3layouts.com/demos_new/template_demo/05-02-2018/revenue-demo_Free/262669190/web/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 19 Jan 2026 17:02:26 GMT -->
</html>
