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
        
        String fechaDesdeParam = request.getParameter("fecha_desde");
        String fechaHastaParam = request.getParameter("fecha_hasta");
        String empleado_id = request.getParameter("empleado_id");

        
        if (fechaDesdeParam == null || fechaHastaParam == null || fechaDesdeParam.isEmpty() || fechaHastaParam.isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().print("ERROR: Parámetros de fecha incompletos.");
            return;
        }

        
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha_desde = formato.parse(fechaDesdeParam);
        Date fecha_hasta = formato.parse(fechaHastaParam);

        
        boolean filtrarPorEmpleado = empleado_id != null && !empleado_id.trim().isEmpty();

       
        Statement stmt = conn.createStatement();
        String query = "SELECT COUNT(*) AS total FROM recetas WHERE fecha_receta BETWEEN '" + fechaDesdeParam + "' AND '" + fechaHastaParam + "'";
        if (filtrarPorEmpleado) {
            query += " AND empleados_id = " + empleado_id;  
        }

      
        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        int totalRecetas = rs.getInt("total");
        rs.close();
        stmt.close();

       
        if (totalRecetas > 0) {
            File reportFile = new File(application.getRealPath("Informes/InformeRecetas.jasper"));
            Map<String, Object> parametros = new HashMap<>();
            parametros.put("fecha_desde", fecha_desde);
            parametros.put("fecha_hasta", fecha_hasta);
            parametros.put("empleado_id", filtrarPorEmpleado ? Integer.parseInt(empleado_id) : null);

           
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
