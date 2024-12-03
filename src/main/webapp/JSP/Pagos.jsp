<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");

    try {
        if (listar != null) {
            // Mostrar los pagos
            if (listar.equals("mostrarpagos")) {
                HttpSession sesion = request.getSession();
                int empleado_id = (Integer) sesion.getAttribute("idempleados");
                String rolNombre = (String) sesion.getAttribute("rol_nombre");

                String sql;

                if ("Administrador".equals(rolNombre)) {
                    sql = "SELECT p.id AS id_pago, "
                            + "to_char(p.fecha_pago, 'dd/mm/YYYY') AS fecha, "
                            + "p.estado_pago AS estado_pago, "
                            + "pv.prov_nombre AS nombre_proveedor, "
                            + "p.total_pagar AS total_pagar, "
                            + "p.num_dias AS dias, "
                            + "emp.emple_nombre || ' ' || emp.emple_apellido AS nombre_empleado, "
                            + "mp.metpag_nombre AS metodo_pago "
                            + "FROM pagos p "
                            + "JOIN proveedores pv ON p.proveedor_id = pv.idproveedores "
                            + "JOIN empleados emp ON p.empleado_id = emp.idempleados "
                            + "JOIN metodos_pago mp ON p.met_pago = mp.idmetodos_pago "
                            + "JOIN compras c ON p.compras_id = c.idcompras "
                            + "WHERE c.condicion_compra = 'Credito' "
                            + "AND p.estado_pago IN ('Pagado', 'Pendiente', 'Pendiente en Mora', 'Pagado en Mora') "
                            + "ORDER BY p.id DESC;";
                } else {
                    sql = "SELECT p.id AS id_pago, "
                            + "to_char(p.fecha_pago, 'dd/mm/YYYY') AS fecha, "
                            + "p.estado_pago AS estado_pago, "
                            + "pv.prov_nombre AS nombre_proveedor, "
                            + "p.total_pagar AS total_pagar, "
                            + "p.num_dias AS dias, "
                            + "emp.emple_nombre || ' ' || emp.emple_apellido AS nombre_empleado, "
                            + "mp.metpag_nombre AS metodo_pago "
                            + "FROM pagos p "
                            + "JOIN proveedores pv ON p.proveedor_id = pv.idproveedores "
                            + "JOIN empleados emp ON p.empleado_id = emp.idempleados "
                            + "JOIN metodos_pago mp ON p.met_pago = mp.idmetodos_pago "
                            + "JOIN compras c ON p.compras_id = c.idcompras "
                            + "WHERE c.condicion_compra = 'Credito' "
                            + "AND p.estado_pago IN ('Pagado', 'Pendiente', 'Pendiente en Mora', 'Pagado en Mora') "
                            + "AND emp.idempleados = " + empleado_id + " "
                            + "ORDER BY p.id DESC;";
                }

                try (Statement st = conn.createStatement(); ResultSet pk = st.executeQuery(sql)) {
                    DecimalFormat df = new DecimalFormat("#,###");

                    while (pk.next()) {
                        double totalpago = pk.getDouble("total_pagar");
                        String totalPagoFormateado = df.format(totalpago) + " Gs.";
                        String estadoPago = pk.getString("estado_pago");
                        String idPago = pk.getString("id_pago");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= idPago%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("fecha")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("nombre_proveedor")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("metodo_pago")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <span class="badge
              <%= estadoPago.equals("Pagado") ? "badge bg-success"
                      : estadoPago.equals("Pendiente") ? "badge bg-warning text-dark"
                      : estadoPago.equals("Pendiente en Mora") || estadoPago.equals("Pagado en Mora") ? "badge bg-danger"
                      : ""%>">
            <%= estadoPago%>
        </span>
    </td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("nombre_empleado")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= totalPagoFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("dias")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%
            // Consideramos "Pendiente", "Pendiente en Mora", "Pagado" y "Pagado en Mora"
            if (estadoPago.equals("Pendiente") || estadoPago.equals("Pendiente en Mora")) {
        %>
        <i class="fas fa-check-circle" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="$('#pkcheck').val('<%= idPago%>')"></i>
        <%
        } else if (estadoPago.equals("Pagado") || estadoPago.equals("Pagado en Mora")) {
        %>
        <a href="${pageContext.request.contextPath}/RecibosJSP/RecibosPagos.jsp?id=<%= idPago%>" 
           target="_blank" id="printLink_<%= idPago%>">
            <i class="fas fa-print" style="color: green; font-size: 20px;"></i>
        </a>
        <%
            } else {
                out.print("<span>N/A</span>"); // O puedes dejarlo vacío
            }
        %>
    </td>
</tr>
<%
        }
    } catch (SQLException e) {
        out.println("Error PSQL: " + e.getMessage());
    }
} // Buscador de pagos
else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
    String rolNombre = (String) sesion.getAttribute("rol_nombre");
    String query;

    if ("Administrador".equals(rolNombre)) {
        query = "SELECT p.id AS id_pago, "
                + "to_char(p.fecha_pago, 'dd/mm/YYYY') AS fecha, "
                + "p.estado_pago AS estado_pago, "
                + "pv.prov_nombre AS nombre_proveedor, "
                + "p.total_pagar AS total_pagar, "
                + "p.num_dias AS dias, "
                + "emp.emple_nombre || ' ' || emp.emple_apellido AS nombre_empleado, "
                + "mp.metpag_nombre AS metodo_pago "
                + "FROM pagos p "
                + "JOIN proveedores pv ON p.proveedor_id = pv.idproveedores "
                + "JOIN empleados emp ON p.empleado_id = emp.idempleados "
                + "JOIN metodos_pago mp ON p.met_pago = mp.idmetodos_pago "
                + "JOIN compras c ON p.compras_id = c.idcompras "
                + "WHERE LOWER(p.estado_pago) LIKE LOWER('" + buscador + "%') "
                + "AND c.condicion_compra = 'Credito' "
                + "AND p.estado_pago IN ('Pagado', 'Pendiente', 'Pendiente en Mora', 'Pagado en Mora') "
                + "ORDER BY p.id DESC;";
    } else {
        query = "SELECT p.id AS id_pago, "
                + "to_char(p.fecha_pago, 'dd/mm/YYYY') AS fecha, "
                + "p.estado_pago AS estado_pago, "
                + "pv.prov_nombre AS nombre_proveedor, "
                + "p.total_pagar AS total_pagar, "
                + "p.num_dias AS dias, "
                + "emp.emple_nombre || ' ' || emp.emple_apellido AS nombre_empleado, "
                + "mp.metpag_nombre AS metodo_pago "
                + "FROM pagos p "
                + "JOIN proveedores pv ON p.proveedor_id = pv.idproveedores "
                + "JOIN empleados emp ON p.empleado_id = emp.idempleados "
                + "JOIN metodos_pago mp ON p.met_pago = mp.idmetodos_pago "
                + "JOIN compras c ON p.compras_id = c.idcompras "
                + "WHERE LOWER(p.estado_pago) LIKE LOWER('" + buscador + "%') "
                + "AND c.condicion_compra = 'Credito' "
                + "AND p.estado_pago IN ('Pagado', 'Pendiente', 'Pendiente en Mora', 'Pagado en Mora') "
                + "AND emp.idempleados = " + empleado_id + " "
                + "ORDER BY p.id DESC;";
    }

    try (Statement st = conn.createStatement(); ResultSet pk = st.executeQuery(query)) {
        DecimalFormat df = new DecimalFormat("#,###");

        while (pk.next()) {
            double totalpago = pk.getDouble("total_pagar");
            String totalPagoFormateado = df.format(totalpago) + " Gs.";
            String estadoPago = pk.getString("estado_pago");
            String idPago = pk.getString("id_pago");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= idPago%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("fecha")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("nombre_proveedor")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("metodo_pago")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <span class="badge
              <%= estadoPago.equals("Pagado") ? "badge bg-success"
                      : estadoPago.equals("Pendiente") ? "badge bg-warning text-dark"
                      : estadoPago.equals("Pendiente en Mora") || estadoPago.equals("Pagado en Mora") ? "badge bg-danger"
                      : ""%>">
            <%= estadoPago%>
        </span>
    </td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("nombre_empleado")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= totalPagoFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("dias")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%
            // Consideramos "Pendiente", "Pendiente en Mora", "Pagado" y "Pagado en Mora"
            if (estadoPago.equals("Pendiente") || estadoPago.equals("Pendiente en Mora")) {
        %>
        <i class="fas fa-check-circle" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="$('#pkcheck').val('<%= idPago%>')"></i>
        <%
        } else if (estadoPago.equals("Pagado") || estadoPago.equals("Pagado en Mora")) {
        %>
        <a href="${pageContext.request.contextPath}/RecibosJSP/RecibosPagos.jsp?id=<%= idPago%>" 
           target="_blank" id="printLink_<%= idPago%>">
            <i class="fas fa-print" style="color: green; font-size: 20px;"></i>
        </a>
        <%
            } else {
                out.print("<span>N/A</span>"); // O puedes dejarlo vacío
            }
        %>
    </td>
</tr>
<%
                    }
                } catch (SQLException e) {
                    out.println("Error PSQL: " + e.getMessage());
                }
            } else if (listar.equals("pagar")) {
                String pkcheck = request.getParameter("pkcheck");

                LocalDate currentDate = LocalDate.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                String fechaActual = currentDate.format(formatter);

                try (Statement st = conn.createStatement()) {
                    String updatePagoSQL = "UPDATE pagos SET "
                            + "estado_pago = CASE "
                            + "WHEN estado_pago = 'Pendiente' THEN 'Pagado' "
                            + "WHEN estado_pago = 'Pendiente en Mora' THEN 'Pagado en Mora' "
                            + "ELSE estado_pago "
                            + "END, "
                            + "fecha_pago = '" + fechaActual + "' "
                            + "WHERE id = " + pkcheck;

                    int rowsPago = st.executeUpdate(updatePagoSQL);

                    if (rowsPago > 0) {
                        out.println("<div class='alert alert-success' role='alert'>Pago actualizado correctamente.</div>");
                    } else {
                        out.println("<div class='alert alert-warning' role='alert'>No se pudo actualizar el estado de pago.</div>");
                    }
                } catch (SQLException e) {
                    out.println("Error PSQL: " + e.getMessage());
                }
            }
        }
    } finally {
        if (conn != null) {
            try {
                conn.close(); // Cerrar la conexión
            } catch (SQLException e) {
                out.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
    }
%>