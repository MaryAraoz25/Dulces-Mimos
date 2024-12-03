<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="../JSP/conexion.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%    try {
        
        String fechaDesdeParam = request.getParameter("fecha_desde_ventas");
        String fechaHastaParam = request.getParameter("fecha_hasta_ventas");
        String informeClienteParam = request.getParameter("informe_cliente");

        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaDesde = formato.parse(fechaDesdeParam);
        Date fechaHasta = formato.parse(fechaHastaParam);

        
        if (fechaDesde == null || fechaHasta == null) {
            response.setContentType("text/plain");
            response.getWriter().print("NO_DATOS");
            return;
        }

        File reportFile = new File(application.getRealPath("Informes/InformeVentas.jasper"));
        Map<String, Object> parametros = new HashMap<>();
        parametros.put("fecha_desde_ventas", fechaDesde);
        parametros.put("fecha_hasta_ventas", fechaHasta);

     
        if (informeClienteParam != null && !informeClienteParam.isEmpty()) {
            parametros.put("informe_cliente", Integer.parseInt(informeClienteParam));
        } else {
            parametros.put("informe_cliente", null);
        }

        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);

        
        response.setContentType("application/pdf");
        response.setContentLength(bytes.length);

        ServletOutputStream output = response.getOutputStream();
        output.write(bytes, 0, bytes.length);
        output.flush();
        output.close();
    } catch (Exception ex) {
        ex.printStackTrace();
        response.setContentType("text/plain");
        response.getWriter().print("ERROR_GENERANDO_INFORME");
    }

%>
