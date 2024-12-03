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
        String fechaDesdeParam = request.getParameter("fecha_desde_pagos");
        String fechaHastaParam = request.getParameter("fecha_hasta_pagos");

        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha_desde_pagos = formato.parse(fechaDesdeParam);
        Date fecha_hasta_pagos = formato.parse(fechaHastaParam);

        // Verificar si hay datos antes de generar el reporte
        Statement stmt = conn.createStatement();
        String query = "SELECT COUNT(*) AS total FROM pagos WHERE fecha_pago BETWEEN '" + fechaDesdeParam + "' AND '" + fechaHastaParam + "'";
        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        int totalPagos = rs.getInt("total");
        rs.close();
        stmt.close();

        if (totalPagos > 0) {
            // Generar el reporte solo si hay datos
            File reportFile = new File(application.getRealPath("Informes/InformePagos.jasper"));
            Map<String, Object> parametros = new HashMap<>();
            parametros.put("fecha_desde_pagos", fecha_desde_pagos);
            parametros.put("fecha_hasta_pagos", fecha_hasta_pagos);

            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);

            ServletOutputStream output = response.getOutputStream();
            output.write(bytes, 0, bytes.length);
            output.flush();
            output.close();
        } else {
            response.setContentType("text/plain");
            response.getWriter().print("NO_DATOS");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>
