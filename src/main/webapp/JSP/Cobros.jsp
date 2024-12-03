<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.DecimalFormat"%>
<%@include file="conexion.jsp"%>

<%    String listar = request.getParameter("listar");

    try {
        if (listar != null) {
            if (listar.equals("mostrarcobros")) {
                HttpSession sesion = request.getSession();
                int empleado_id = (Integer) sesion.getAttribute("idempleados");
                String rolNombre = (String) sesion.getAttribute("rol_nombre");
                String sql;

                if ("Administrador".equals(rolNombre)) {
                    sql = "SELECT c.idcobro AS id_cobro, "
                            + "to_char(c.fecha_cobro, 'dd/mm/yyyy') AS fecha, "
                            + "CONCAT(cli.cli_nombre, ' ', cli.cli_apellido) AS nombre_cliente, "
                            + "mp.metpag_nombre AS metodo_pago, "
                            + "c.estado_cobro AS estado_cobro, "
                            + "emp.emple_nombre AS nombre_empleado, "
                            + "c.total_cobro AS total_cobro, "
                            + "c.num_dias AS dias "
                            + "FROM cobros c "
                            + "JOIN clientes cli ON c.cliente_id = cli.idclientes "
                            + "JOIN empleados emp ON c.empleado_id = emp.idempleados "
                            + "JOIN metodos_pago mp ON c.met_pag = mp.idmetodos_pago "
                            + "JOIN ventas v ON c.venta_id = v.idventas "
                            + "WHERE v.condicion_venta = 'Credito' "
                            + "AND c.estado_cobro IN ('Cobrado', 'Pendiente', 'Cobrado en Mora', 'Pendiente en Mora') "
                            + "ORDER BY c.idcobro DESC;"; 
                } else {
                    sql = "SELECT c.idcobro AS id_cobro, "
                            + "to_char(c.fecha_cobro, 'dd/mm/yyyy') AS fecha, "
                            + "CONCAT(cli.cli_nombre, ' ', cli.cli_apellido) AS nombre_cliente, "
                            + "mp.metpag_nombre AS metodo_pago, "
                            + "c.estado_cobro AS estado_cobro, "
                            + "emp.emple_nombre AS nombre_empleado, "
                            + "c.total_cobro AS total_cobro, "
                            + "c.num_dias AS dias "
                            + "FROM cobros c "
                            + "JOIN clientes cli ON c.cliente_id = cli.idclientes "
                            + "JOIN empleados emp ON c.empleado_id = emp.idempleados "
                            + "JOIN metodos_pago mp ON c.met_pag = mp.idmetodos_pago "
                            + "JOIN ventas v ON c.venta_id = v.idventas "
                            + "WHERE v.condicion_venta = 'Credito' "
                            + "AND c.estado_cobro IN ('Cobrado', 'Pendiente', 'Cobrado en Mora', 'Pendiente en Mora') "
                            + "AND emp.idempleados = " + empleado_id + " " 
                            + "ORDER BY c.idcobro DESC;";
                }

                try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
                    DecimalFormat df = new DecimalFormat("#,###");
                    while (rs.next()) {
                        double total_cobro = rs.getDouble("total_cobro");
                        String totalCobroFormateado = df.format(total_cobro) + " Gs.";
                        String estadoCobro = rs.getString("estado_cobro");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getInt("id_cobro")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("fecha")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("nombre_cliente")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("metodo_pago")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <span class="badge 
              <%=estadoCobro.equals("Cobrado") ? "badge bg-success"
                      : estadoCobro.equals("Pendiente") ? "badge bg-warning text-dark"
                      : estadoCobro.equals("Pendiente en Mora") ? "badge bg-danger"
                      : estadoCobro.equals("Cobrado en Mora") ? "badge bg-danger"
                      : ""%>">
            <%= estadoCobro%>
        </span>
    </td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("nombre_empleado")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= totalCobroFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getInt("dias")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%
            if (estadoCobro.equals("Pendiente") || estadoCobro.equals("Pendiente en Mora")) {
        %>
        <i class="fas fa-check-circle" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="setCobroId('<%= rs.getString("id_cobro")%>')"></i>
        <%
        } else if (estadoCobro.equals("Cobrado") || estadoCobro.equals("Cobrado en Mora")) {
        %>
        <a href="${pageContext.request.contextPath}/RecibosJSP/RecibosCobros.jsp?id=<%= rs.getInt("id_cobro")%>" 
           target="_blank" id="printLink_<%= rs.getString("id_cobro")%>" 
           style="display: block;">
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
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
    String rolNombre = (String) sesion.getAttribute("rol_nombre");
    String query;

if ("Administrador".equals(rolNombre)) {
    query = "SELECT c.idcobro AS id_cobro, "
            + "to_char(c.fecha_cobro, 'dd/mm/yyyy') AS fecha, "
            + "CONCAT(cli.cli_nombre, ' ', cli.cli_apellido) AS nombre_cliente, "
            + "mp.metpag_nombre AS metodo_pago, "
            + "c.estado_cobro AS estado_cobro, "
            + "emp.emple_nombre AS nombre_empleado, "
            + "c.total_cobro AS total_cobro, "
            + "c.num_dias AS dias "
            + "FROM cobros c "
            + "JOIN clientes cli ON c.cliente_id = cli.idclientes "
            + "JOIN empleados emp ON c.empleado_id = emp.idempleados "
            + "JOIN metodos_pago mp ON c.met_pag = mp.idmetodos_pago "
            + "JOIN ventas v ON c.venta_id = v.idventas "
            + "WHERE LOWER(c.estado_cobro) LIKE LOWER('" + buscador + "%') "
            + "AND v.condicion_venta = 'Credito' "
            + "AND c.estado_cobro IN ('Cobrado', 'Pendiente', 'Cobrado en Mora', 'Pendiente en Mora') "
            + "ORDER BY c.idcobro DESC;"; 
} else {
    query = "SELECT c.idcobro AS id_cobro, "
            + "to_char(c.fecha_cobro, 'dd/mm/yyyy') AS fecha, "
            + "CONCAT(cli.cli_nombre, ' ', cli.cli_apellido) AS nombre_cliente, "
            + "mp.metpag_nombre AS metodo_pago, "
            + "c.estado_cobro AS estado_cobro, "
            + "emp.emple_nombre AS nombre_empleado, "
            + "c.total_cobro AS total_cobro, "
            + "c.num_dias AS dias "
            + "FROM cobros c "
            + "JOIN clientes cli ON c.cliente_id = cli.idclientes "
            + "JOIN empleados emp ON c.empleado_id = emp.idempleados "
            + "JOIN metodos_pago mp ON c.met_pag = mp.idmetodos_pago "
            + "JOIN ventas v ON c.venta_id = v.idventas "
            + "WHERE LOWER(c.estado_cobro) LIKE LOWER('" + buscador + "%') "
            + "AND v.condicion_venta = 'Credito' "
            + "AND c.estado_cobro IN ('Cobrado', 'Pendiente', 'Cobrado en Mora', 'Pendiente en Mora') "
            + "AND emp.idempleados = " + empleado_id + " " 
            + "ORDER BY c.idcobro DESC;";
}

    try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
        DecimalFormat df = new DecimalFormat("#,###");
        while (rs.next()) {
            double total_cobro = rs.getDouble("total_cobro");
            String totalCobroFormateado = df.format(total_cobro) + " Gs.";
            String estadoCobro = rs.getString("estado_cobro");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getInt("id_cobro")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("fecha")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("nombre_cliente")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("metodo_pago")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <span class="badge 
              <%=estadoCobro.equals("Cobrado") ? "badge bg-success"
                      : estadoCobro.equals("Pendiente") ? "badge bg-warning text-dark"
                      : estadoCobro.equals("Pendiente en Mora") ? "badge bg-danger"
                      : estadoCobro.equals("Cobrado en Mora") ? "badge bg-danger"
                      : ""%>">
            <%= estadoCobro%>
        </span>
    </td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getString("nombre_empleado")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= totalCobroFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= rs.getInt("dias")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%
            if (estadoCobro.equals("Pendiente") || estadoCobro.equals("Pendiente en Mora")) {
        %>
        <i class="fas fa-check-circle" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="setCobroId('<%= rs.getString("id_cobro")%>')"></i>
        <%
        } else if (estadoCobro.equals("Cobrado") || estadoCobro.equals("Cobrado en Mora")) {
        %>
        <a href="${pageContext.request.contextPath}/RecibosJSP/RecibosCobros.jsp?id=<%= rs.getInt("id_cobro")%>" 
           target="_blank" id="printLink_<%= rs.getString("id_cobro")%>" 
           style="display: block;">
            <i class="fas fa-print" style="color: green; font-size: 20px;"></i>
        </a>
        <%
            } else {
                out.print("<span>N/A</span>");
            }
        %>
    </td>
</tr>
<%
                    }
                } catch (SQLException e) {
                    out.println("Error al buscar cobros: " + e.getMessage());
                }
            } else if (listar.equals("cobrar")) {
                String pkcheck = request.getParameter("pkcheck");

                LocalDate currentDate = LocalDate.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                String fechaActual = currentDate.format(formatter);

                try (Statement st = conn.createStatement()) {
                    String updateCobroSQL = "UPDATE cobros SET "
                            + "estado_cobro = CASE "
                            + "WHEN estado_cobro = 'Pendiente' THEN 'Cobrado' "
                            + "WHEN estado_cobro = 'Pendiente en Mora' THEN 'Cobrado en Mora' "
                            + "ELSE estado_cobro "
                            + "END, "
                            + "fecha_cobro = '" + fechaActual + "' "
                            + "WHERE idcobro = " + pkcheck;

                    int rowsCobro = st.executeUpdate(updateCobroSQL);

                    if (rowsCobro > 0) {
                        out.println("<div class='alert alert-success' role='alert'>Cobro actualizado correctamente.</div>");
                    } else {
                        out.println("<div class='alert alert-warning' role='alert'>No se encontró el cobro.</div>");
                    }
                } catch (SQLException e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error al actualizar el cobro: " + e.getMessage() + "</div>");
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