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
        String fechaDesdeParam = request.getParameter("fecha_desde_pedidos");
        String fechaHastaParam = request.getParameter("fecha_hasta_pedidos");
        String cli_informe = request.getParameter("cli_informe");

        // Validación de parámetros
        if (fechaDesdeParam == null || fechaHastaParam == null || fechaDesdeParam.isEmpty() || fechaHastaParam.isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().print("ERROR: Parámetros de fecha incompletos.");
            return;
        }

        // Parseo de fechas
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha_desde_pedidos = formato.parse(fechaDesdeParam);
        Date fecha_hasta_pedidos = formato.parse(fechaHastaParam);

        // Validación adicional para el cliente
        boolean filtrarPorCliente = cli_informe != null && !cli_informe.trim().isEmpty();

        // Consulta previa para validar si hay datos
        Statement stmt = conn.createStatement();
        String query = "SELECT COUNT(*) AS total FROM pedidos WHERE fecha_pedido BETWEEN '" + fechaDesdeParam + "' AND '" + fechaHastaParam + "'";
        if (filtrarPorCliente) {
            query += " AND cliente_id = " + cli_informe;
        }

        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        int totalPedidos = rs.getInt("total");
        rs.close();
        stmt.close();

        if (totalPedidos > 0) {
            // Generar el reporte si hay datos
            File reportFile = new File(application.getRealPath("Informes/InformePedidos.jasper"));
            Map<String, Object> parametros = new HashMap<>();
            parametros.put("fecha_desde_pedidos", fecha_desde_pedidos);
            parametros.put("fecha_hasta_pedidos", fecha_hasta_pedidos);  
            parametros.put("cli_informe", filtrarPorCliente ? Integer.parseInt(cli_informe) : null);

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
