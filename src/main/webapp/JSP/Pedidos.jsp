<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");
    if (listar != null) {
        Statement st = null;
        ResultSet rs = null;
        try {
            st = conn.createStatement();
            if ("cargarClientes".equals(listar)) {
                rs = st.executeQuery("SELECT idclientes, cli_nombre, cli_direccion, cli_cedula, cli_telefono, cli_ruc FROM clientes");
                out.print("<option value=''>Seleccione un Cliente</option>");
                while (rs.next()) {
                    int idcliente = rs.getInt("idclientes");
                    String nombreCliente = rs.getString("cli_nombre");
                    String direccion = rs.getString("cli_direccion");
                    String cedula = rs.getString("cli_cedula");
                    String telefono = rs.getString("cli_telefono");
                    String ruc = rs.getString("cli_ruc");

                    out.print("<option value='" + idcliente + "' data-direccion='" + direccion + "' data-cedula='" + cedula + "' data-telefono='" + telefono + "' data-ruc='" + ruc + "'>"
                            + nombreCliente + " - " + cedula + "</option>");
                }
            } else if ("cargarProductos".equals(listar)) {
                rs = st.executeQuery("SELECT p.idproductos, p.pro_nombre, p.pro_precio, p.impuesto, u.descripcion AS unidad_medida "
                        + "FROM productos p "
                        + "JOIN unidad_medida u ON p.unidad_de_medida_id = u.idunidad_medida");
                out.print("<option value=''>Seleccione un Producto</option>");
                while (rs.next()) {
                    int idProducto = rs.getInt("idproductos");
                    String nombreProducto = rs.getString("pro_nombre");
                    String unidadMedida = rs.getString("unidad_medida");
                    String impuesto = rs.getString("impuesto");
                    String precioUnitario = rs.getString("pro_precio");

                    out.print("<option value='" + idProducto + "' data-unidad='" + unidadMedida + "' data-impuesto='" + impuesto + "' data-precio-unitario='" + precioUnitario + "'>" + nombreProducto + "</option>");
                }
            } else if ("cargar".equals(listar)) {
                String clientes_id = request.getParameter("clientes_id");
                String pedidos_fecha = request.getParameter("pedidos_fecha");
                String pedidos_estado = request.getParameter("estado_pedidos");
                String productos_id = request.getParameter("productos_id");
                String detpedidos_preciounitario = request.getParameter("detpedidos_preciounitario");
                String detpedidos_cantidad = request.getParameter("detpedidos_cantidad");
                String total_pedido = request.getParameter("total_pedido");
                String estado_stock = request.getParameter("estado_stock");
                String estado_entrega = request.getParameter("estado_entrega");
                String iva_10 = request.getParameter("iva_10");
                HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");

                rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
                if (rs.next()) {
                    int idPedido = rs.getInt("idpedidos");

                    // Validar que el detalle no exista ya
                    rs = st.executeQuery("SELECT COUNT(*) AS count FROM detalle_pedidos WHERE pedidos_id = " + idPedido + " AND productos_id = " + productos_id);
                    if (rs.next()) {
                        int count = rs.getInt("count");

                        if (count > 0) {
                            out.println("<div class='alert alert-warning' role='alert'>El detalle ya existe para este pedido.</div>");
                        } else {
                            st.executeUpdate("INSERT INTO detalle_pedidos (detpedidos_cantidad, detpedidos_preciounitario, pedidos_id, productos_id) "
                                    + "VALUES (" + detpedidos_cantidad + ", " + detpedidos_preciounitario + ", " + idPedido + ", " + productos_id + ")");
                            out.println("<div class='alert alert-success' role='alert'>Detalle insertado correctamente.</div>");
                        }
                    }
                } else {
                    st.executeUpdate("INSERT INTO pedidos (fecha_pedido, estado_pedidos, cliente_id, empleados_id, total_pedido, iva_10, estado_stock, estado_entrega) "
                            + "VALUES ('" + pedidos_fecha + "', '" + pedidos_estado + "', " + clientes_id + ", " + empleados_id + ", " + total_pedido + ", " + iva_10 + ", '" + estado_stock + "', '" + estado_entrega + "')");

                    rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
                    if (rs.next()) {
                        int idPedido = rs.getInt("idpedidos");

                        // Validar que el detalle no exista ya
                        rs = st.executeQuery("SELECT COUNT(*) AS count FROM detalle_pedidos WHERE pedidos_id = " + idPedido + " AND productos_id = " + productos_id);
                        if (rs.next()) {
                            int count = rs.getInt("count");

                            if (count > 0) {
                                out.println("<div class='alert alert-warning' role='alert'>El detalle ya existe para este pedido.</div>");
                            } else {
                                st.executeUpdate("INSERT INTO detalle_pedidos (detpedidos_cantidad, detpedidos_preciounitario, pedidos_id, productos_id) "
                                        + "VALUES (" + detpedidos_cantidad + ", " + detpedidos_preciounitario + ", " + idPedido + ", " + productos_id + ")");
                                out.print("<div class='alert alert-success' role='alert'>Cabecera y Detalle Insertados Correctamente</div>");
                            }
                        }
                    }
                }
            } else if ("mostrardetalle".equals(listar)) {
                HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");
                rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
                if (rs.next()) {
                    int idPedido = rs.getInt("idpedidos");
                    rs = st.executeQuery(
                            "SELECT dp.iddetalle_pedidos, p.pro_nombre AS producto_nombre, um.descripcion AS unidad_medida, "
                            + "dp.detpedidos_preciounitario, dp.detpedidos_cantidad, p.stock_actual "
                            + "FROM detalle_pedidos dp "
                            + "JOIN productos p ON dp.productos_id = p.idproductos "
                            + "JOIN unidad_medida um ON p.unidad_de_medida_id = um.idunidad_medida "
                            + "WHERE dp.pedidos_id = " + idPedido
                    );

                    int sumador = 0;
                    boolean todosDisponibles = true;
                    while (rs.next()) {
                        String iddetalle_pedidos = rs.getString("iddetalle_pedidos");
                        String producto_nombre = rs.getString("producto_nombre");
                        String unidad_medida = rs.getString("unidad_medida");
                        String detpedidos_preciounitario = rs.getString("detpedidos_preciounitario");
                        String detpedidos_cantidad = rs.getString("detpedidos_cantidad");
                        int stockActual = rs.getInt("stock_actual");

                        int precio = rs.getInt("detpedidos_preciounitario");
                        int cantidad = rs.getInt("detpedidos_cantidad");

                        // Calcular el impuesto como cantidad * precio unitario
                        int impuestoCalculado = cantidad * precio;

                        // Calcular subtotal incluyendo impuesto
                        double impuestoDecimal = impuestoCalculado / 100.0; // Si necesitas calcular un impuesto porcentual
                        double subtotal = (precio * (1 + impuestoDecimal)) * cantidad;
                        sumador += subtotal;

                        // Verifica disponibilidad
                        String disponibilidad = (stockActual >= cantidad) ? "Disponible" : "No Disponible";
                        if ("No Disponible".equals(disponibilidad)) {
                            todosDisponibles = false; // Si algún producto no está disponible
                        }

                        // Formatea el número con separadores de miles
                        DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
                        df.applyPattern("#,###");

                        // Formatea el subtotal y el impuesto calculado
                        String calcularFormateado = df.format(subtotal);
                        String impuestoFormateado = df.format(impuestoCalculado);

%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%=detpedidos_cantidad%></td>
    <td style="text-align: center; vertical-align: middle;"><%=producto_nombre%></td>
    <td style="text-align: center; vertical-align: middle;"><%=unidad_medida%></td>
    <td style="text-align: center; vertical-align: middle;"><%=detpedidos_preciounitario%></td>
    <td style="text-align: center; vertical-align: middle;"><%=impuestoFormateado%></td> <!-- Mostrando el impuesto calculado -->
    <td style="text-align: center; vertical-align: middle; color: <%= "Disponible".equals(disponibilidad) ? "green" : "red"%>;"><%=disponibilidad%></td>

    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color: blue; font-size: 16px;" onclick="$('#id_delete').val('<%= iddetalle_pedidos%>')"></i>

    </td>
</tr>
<%
            }
            session.setAttribute("sumador", sumador);
            session.setAttribute("todosDisponibles", todosDisponibles);

        } else {
            out.println("No hay pedidos pendientes.");
        }
    } else if ("cancelar".equals(listar)) {
HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");
        rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idPedido = rs.getInt("idpedidos");
            st.executeUpdate("UPDATE pedidos SET estado_pedidos ='Cancelado' WHERE idpedidos =" + idPedido);
        }
    } else if ("eliminar".equals(listar)) {
        String id_delete = request.getParameter("id_delete");
        st.executeUpdate("DELETE FROM detalle_pedidos WHERE iddetalle_pedidos=" + id_delete);
    } else if ("finalizar".equals(listar)) {
HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");
       rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idPedido = rs.getInt("idpedidos");

            // Obtener la disponibilidad general desde la sesión
            Boolean todosDisponibles = (Boolean) session.getAttribute("todosDisponibles");

            if (todosDisponibles != null) {
                // Actualizar el estado del pedido
                if (todosDisponibles) {
                    st.executeUpdate("UPDATE pedidos SET estado_pedidos ='Finalizado', estado_stock='Disponible' WHERE idpedidos =" + idPedido);
                } else {
                    st.executeUpdate("UPDATE pedidos SET estado_pedidos ='Finalizado', estado_stock='No Disponible' WHERE idpedidos =" + idPedido);
                }
            }
        }
    }
    if (listar.equals("mostrartotal10")) {
        double totalVenta = 0.0;
        double totalIVA10 = 0.0;
HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");
       rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idPedido = rs.getInt("idpedidos");
            String query = "SELECT dt.detpedidos_preciounitario, dt.detpedidos_cantidad, p.impuesto "
                    + "FROM detalle_pedidos dt "
                    + "JOIN productos p ON dt.productos_id = p.idproductos "
                    + "WHERE dt.pedidos_id = " + idPedido + " AND CAST(p.impuesto AS INTEGER) = 10";

            ResultSet pk = st.executeQuery(query);
            while (pk.next()) {
                int precio = pk.getInt("detpedidos_preciounitario");
                int cantidad = pk.getInt("detpedidos_cantidad");
                double subtotal = precio * cantidad; // Total por línea
                totalVenta += subtotal; // Acumula el total de ventas
            }

            // Calcular el IVA
            totalIVA10 = totalVenta / 11; // IVA 10%

            pk.close();
        } else {
            out.println("No se encontraron pedidos pendientes.");
        }

        DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
        df.applyPattern("#,###");
        String totalVentaFormateado = df.format(totalVenta);
        String totalIVA10Formateado = df.format(totalIVA10);

        // Imprimir los valores formateados
        //out.println("Total Venta: " + totalVentaFormateado);
        out.println(totalIVA10Formateado);

    } else if (listar.equals("mostrartotales")) {
HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");
        rs = st.executeQuery("SELECT idpedidos FROM pedidos WHERE estado_pedidos = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idPedido = rs.getInt("idpedidos");
            double totalVenta = 0.0; // Inicializa el total de venta

            rs = st.executeQuery("SELECT dt.detpedidos_preciounitario, dt.detpedidos_cantidad, p.impuesto "
                    + "FROM detalle_pedidos dt "
                    + "JOIN productos p ON p.idproductos = dt.productos_id "
                    + "WHERE dt.pedidos_id = " + idPedido);

            while (rs.next()) {
                int precio = rs.getInt("detpedidos_preciounitario");
                int cantidad = rs.getInt("detpedidos_cantidad");
                double subtotal = precio * cantidad; // Total por línea
                totalVenta += subtotal; // Acumula el total de ventas
            }

            // Almacenar el total de ventas en la base de datos
            st.executeUpdate("UPDATE pedidos SET total_pedido=" + totalVenta + ", iva_10=" + (totalVenta / 11) + " WHERE idpedidos=" + idPedido);

            // Imprimir el total de ventas
            DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
            df.applyPattern("#,###");
            String totalVentaFormateado = df.format(totalVenta);
            out.println(totalVentaFormateado);

        } else {
            out.println("No hay pedidos pendientes.");
        }
    } else if (listar.equals("mostrarpedidos")) {
        HttpSession sesion = request.getSession();
        int empleado_id = (Integer) sesion.getAttribute("idempleados");
        String rolNombre = (String) sesion.getAttribute("rol_nombre");
        String query;

if ("Administrador".equals(rolNombre)) {
    query = "SELECT p.idpedidos AS id, to_char(p.fecha_pedido, 'dd/mm/YYYY') AS fecha_pedido, "
            + "cl.cli_nombre || ' ' || cl.cli_apellido AS nombre_cliente, "
            + "p.estado_pedidos AS estado, p.estado_stock AS estado_stock, p.estado_entrega AS estado_entrega "
            + "FROM pedidos p "
            + "JOIN clientes cl ON p.cliente_id = cl.idclientes "
            + "WHERE p.estado_pedidos = 'Finalizado' "
            + "ORDER BY p.idpedidos DESC;"; 
} else {
    query = "SELECT p.idpedidos AS id, to_char(p.fecha_pedido, 'dd/mm/YYYY') AS fecha_pedido, "
            + "cl.cli_nombre || ' ' || cl.cli_apellido AS nombre_cliente, "
            + "p.estado_pedidos AS estado, p.estado_stock AS estado_stock, p.estado_entrega AS estado_entrega "
            + "FROM pedidos p "
            + "JOIN clientes cl ON p.cliente_id = cl.idclientes "
            + "WHERE p.estado_pedidos = 'Finalizado' "
            + "AND p.empleados_id = " + empleado_id + " " 
            + "ORDER BY p.idpedidos DESC;";
}

rs = st.executeQuery(query);

        while (rs.next()) {
            int id = rs.getInt("id");
            String fechaPedido = rs.getString("fecha_pedido");
            String cliente = rs.getString("nombre_cliente");
            String estado = rs.getString("estado");
            String estado_stock = rs.getString("estado_stock");
            String estado_entrega = rs.getString("estado_entrega");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= id%></td>
    <td style="text-align: center; vertical-align: middle;"><%= fechaPedido%></td>
    <td style="text-align: center; vertical-align: middle;"><%= cliente%></td>
    <td style="text-align: center; vertical-align: middle;"><%= estado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= estado_stock%></td><!-- comment -->
    <td style="text-align: center; vertical-align: middle;"><%= estado_entrega%></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val('<%= id%>')"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReportePedidos.jsp?id=<%= id%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>


    </td>
</tr>
<%
    }
} else if (listar.equals("anularpedidos")) {
    String pkdelete = request.getParameter("pkdelete");
    if (pkdelete != null) {
        st.executeUpdate("UPDATE pedidos SET estado_pedidos = 'Anulado' WHERE idpedidos = " + pkdelete);
        st.executeUpdate("UPDATE pedidos SET estado_entrega = 'Anulado' WHERE idpedidos = " + pkdelete);
        st.executeUpdate("UPDATE pedidos SET estado_stock = 'Anulado' WHERE idpedidos = " + pkdelete);
        // out.println("<div class='alert alert-success' role='alert'>Pedido anulado correctamente</div>");
    }
} else if (listar.equals("entregarpedidos")) {
    String pkcheck = request.getParameter("pkcheck");
    if (pkcheck != null) {
        // Obtener la fecha de entrega del pedido
        rs = st.executeQuery("SELECT fecha_pedido FROM pedidos WHERE idpedidos = " + pkcheck);
        if (rs.next()) {
            java.sql.Date fechaPedido = rs.getDate("fecha_pedido"); // Asegúrate de usar java.sql.Date
            java.sql.Date fechaActual = new java.sql.Date(System.currentTimeMillis()); // Obtiene la fecha actual

            // Compara las fechas (solo el día)
            if (fechaPedido.equals(fechaActual)) {
                // Cambiar el estado si las fechas coinciden
                st.executeUpdate("UPDATE pedidos SET estado_entrega = 'Entregado' WHERE idpedidos = " + pkcheck);
                // out.println("<div class='alert alert-success' role='alert'>Pedido entregado correctamente</div>");
            } else {
                // Mensaje de error si la fecha no coincide
                out.println("<div class='alert alert-danger' role='alert'>No se puede entregar el pedido antes de la fecha de entrega.</div>");
            }
        }
    }
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
    String rolNombre = (String) sesion.getAttribute("rol_nombre");
    String query;

    if ("Administrador".equals(rolNombre)) {
        query = "SELECT p.idpedidos AS id, to_char(p.fecha_pedido, 'dd/mm/YYYY') AS fecha_pedido, "
                + "cl.cli_nombre || ' ' || cl.cli_apellido AS nombre_cliente, p.estado_pedidos AS estado, "
                + "p.estado_stock AS estado_stock, p.estado_entrega AS estado_entrega "
                + "FROM pedidos p "
                + "JOIN clientes cl ON p.cliente_id = cl.idclientes "
                + "WHERE LOWER(cl.cli_nombre || ' ' || cl.cli_apellido) LIKE '" + buscador + "%' "
                + "AND p.estado_pedidos = 'Finalizado' "
                + "ORDER BY p.idpedidos DESC;";
    } else {
        query = "SELECT p.idpedidos AS id, to_char(p.fecha_pedido, 'dd/mm/YYYY') AS fecha_pedido, "
                + "cl.cli_nombre || ' ' || cl.cli_apellido AS nombre_cliente, p.estado_pedidos AS estado, "
                + "p.estado_stock AS estado_stock, p.estado_entrega AS estado_entrega "
                + "FROM pedidos p "
                + "JOIN clientes cl ON p.cliente_id = cl.idclientes "
                + "WHERE LOWER(cl.cli_nombre || ' ' || cl.cli_apellido) LIKE '" + buscador + "%' "
                + "AND p.estado_pedidos = 'Finalizado' "
                + "AND p.empleados_id = " + empleado_id + " "
                + "ORDER BY p.idpedidos DESC;";
    }

    try {
        // Ejecución de la consulta
        ResultSet pk = st.executeQuery(query);

        // Recorrido de los resultados
        while (pk.next()) {
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getInt("id")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("fecha_pedido")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("nombre_cliente")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("estado")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("estado_stock")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("estado_entrega")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val('<%= pk.getInt("id")%>')"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReportePedidos.jsp?id=<%= pk.getInt("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
                    }

                    // Cierre de ResultSet y Statement
                    pk.close();
                } catch (SQLException e) {
                    out.println("Error PSQL: " + e.getMessage());
                } finally {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                        if (st != null) {
                            st.close();
                        }
                    } catch (SQLException e) {
                        out.println("Error PSQL al cerrar recursos: " + e.getMessage());
                    }
                }
            }
        } catch (SQLException e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>