<%@ page import="net.sf.jasperreports.engine.*"%>
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="../JSP/conexion.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    try {
        String fechaDesdeParam = request.getParameter("fecha_desde_cobros");
        String fechaHastaParam = request.getParameter("fecha_hasta_cobros");

        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");

        Date fecha_desde_cobros = formato.parse(fechaDesdeParam);
        Date fecha_hasta_cobros = formato.parse(fechaHastaParam);

        Statement stmt = conn.createStatement();
        String query = "SELECT COUNT(*) AS total FROM cobros WHERE fecha_cobro BETWEEN '" + fechaDesdeParam + "' AND '" + fechaHastaParam + "'";
        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        int totalCobros = rs.getInt("total");
        rs.close();
        stmt.close();

        if (totalCobros > 0) {
            // Generar el reporte solo si hay datos
            File reportFile = new File(application.getRealPath("Informes/InformeCobros.jasper"));
            Map<String, Object> parametros = new HashMap<>();
            parametros.put("fecha_desde_cobros", fecha_desde_cobros);
            parametros.put("fecha_hasta_cobros", fecha_hasta_cobros);

            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);

            ServletOutputStream output = response.getOutputStream();
            output.write(bytes, 0, bytes.length);
            output.flush();
            output.close();
        } else {
            // Responde con "NO_DATOS" si no hay datos
            response.setContentType("text/plain");
            response.getWriter().print("NO_DATOS");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>
