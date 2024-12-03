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
        String fechaDesdeParam = request.getParameter("fecha_desde_produccion");
        String fechaHastaParam = request.getParameter("fecha_hasta_produccion");
        String produc_informeStr = request.getParameter("produc_informe"); 
        Integer produc_informe = null;

        if (fechaDesdeParam == null || fechaHastaParam == null || fechaDesdeParam.isEmpty() || fechaHastaParam.isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().print("ERROR: Parámetros de fecha incompletos.");
            return;
        }
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha_desde_produccion = formato.parse(fechaDesdeParam);
        Date fecha_hasta_produccion = formato.parse(fechaHastaParam);

        if (produc_informeStr != null && !produc_informeStr.trim().isEmpty()) {
            try {
                produc_informe = Integer.parseInt(produc_informeStr); 
            } catch (NumberFormatException e) {
                response.setContentType("text/plain");
                response.getWriter().print("ERROR: ID de receta no válido.");
                return;
            }
        }

        Statement stmt = conn.createStatement();
        String query = "SELECT COUNT(*) AS total FROM produccion WHERE fecha_elaboracion BETWEEN '" + fechaDesdeParam + "' AND '" + fechaHastaParam + "'";
        if (produc_informe != null) {
            query += " AND receta_id = " + produc_informe;
        }
        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        int totalProduccion = rs.getInt("total");
        rs.close();
        stmt.close();

        if (totalProduccion > 0) {
            File reportFile = new File(application.getRealPath("Informes/InformeProduccion.jasper"));
            Map<String, Object> parametros = new HashMap<>();
            parametros.put("fecha_desde_produccion", fecha_desde_produccion);
            parametros.put("fecha_hasta_produccion", fecha_hasta_produccion);
            parametros.put("produc_informe", produc_informe); 

           
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
        response.setContentType("text/plain");
        response.getWriter().print("ERROR: " + ex.getMessage());
    }
%>
