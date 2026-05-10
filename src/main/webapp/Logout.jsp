<%-- 
    Document   : Logout
    Author     : Batch_9_CSE_Java_NIVUNALabs
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session to clear user data
    session.removeAttribute("phone");
    session.invalidate();
    
    // Redirect back to the landing page
    response.sendRedirect("index.html");
%>