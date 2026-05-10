<%
    String pass = request.getParameter("adminPass");
    if("admin123".equals(pass)) {
        session.setAttribute("adminRole", "true");
        response.sendRedirect("AdminHelpDesk.jsp");
    } else {
        out.println("<script>alert('Invalid Admin Password'); window.location='AdminLogin.jsp';</script>");
    }
%>