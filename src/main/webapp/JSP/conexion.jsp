<%-- 
    Document   : conexion
    Created on : 16 abr. 2024, 08:34:26
    Author     : Maria
--%>

<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%Connection conn = null;

    Class.forName("org.postgresql.Driver");
    conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ecommerce", "postgres", "19312505");
    if (conn != null) {
        //out.print("Conectado");
    } else {
        out.print("Error al Conectar");
    } 


%>
