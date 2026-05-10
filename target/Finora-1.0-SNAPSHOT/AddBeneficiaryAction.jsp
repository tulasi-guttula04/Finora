<%@page import="java.sql.*"%>
<%
    String phone = (String) session.getAttribute("phone");
    String benName = request.getParameter("benName");
    String benAcc = request.getParameter("benAcc");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Finora_DB","scet","scet");
        PreparedStatement ps = con.prepareStatement("INSERT INTO BENEFICIARIES (OWNER_PHONE, BENEFICIARY_ACC, BENEFICIARY_NAME) VALUES (?, ?, ?)");
        ps.setString(1, phone);
        ps.setLong(2, Long.parseLong(benAcc));
        ps.setString(3, benName);
        ps.executeUpdate();
        con.close();
        out.println("<script>alert('Beneficiary Added!'); window.location='FundTransfer.jsp';</script>");
    } catch(Exception e) { out.println(e); }
%>