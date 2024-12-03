<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");
    Statement st = null;
    ResultSet rs = null;

    try {
        st = conn.createStatement();

        if ("cargarClientes".equals(listar)) {
    rs = st.executeQuery("SELECT idclientes, cli_nombre, cli_direccion, cli_cedula, cli_telefono, cli_ruc FROM clientes");
    out.print("<option value='' disabled selected>Seleccione un Cliente</option>");
    while (rs.next()) {
        int idcliente = rs.getInt("idclientes");
        String nombreCliente = rs.getString("cli_nombre");
        String cedula = rs.getString("cli_cedula");
        String direccion = rs.getString("cli_direccion");
        String telefono = rs.getString("cli_telefono");
        String ruc = rs.getString("cli_ruc");
        
        out.print("<option value='" + idcliente + "' data-direccion='" + direccion + "' data-cedula='" + cedula + "' data-telefono='" + telefono + "' data-ruc='" + ruc + "'>" + nombreCliente + " - " + cedula + "</option>");
    }
} else if ("cargarPedidos".equals(listar)) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            rs = st.executeQuery("SELECT p.idpedidos, p.fecha_pedido, c.idclientes, c.cli_nombre, c.cli_apellido, c.cli_direccion, c.cli_cedula, c.cli_telefono, c.cli_ruc "
                    + "FROM pedidos p "
                    + "JOIN clientes c ON p.cliente_id = c.idclientes "
                    + "WHERE p.estado_stock = 'Disponible' AND p.estado_entrega = 'Pendiente' AND p.fecha_pedido = CURRENT_DATE");

            out.print("<option value=''>Seleccione un Pedido</option>");
            while (rs.next()) {
                String fechaFormateada = sdf.format(rs.getDate("fecha_pedido"));
                String nombreCliente = rs.getString("cli_nombre") + " " + rs.getString("cli_apellido"); 

                out.print("<option value='" + rs.getInt("idpedidos") + "' "
                        + "data-idclientes='" + rs.getInt("idclientes") + "' " // Añadir ID del cliente
                        + "data-direccion='" + rs.getString("cli_direccion") + "' "
                        + "data-cedula='" + rs.getString("cli_cedula") + "' "
                        + "data-telefono='" + rs.getString("cli_telefono") + "' "
                        + "data-ruc='" + rs.getString("cli_ruc") + "'>"
                        + fechaFormateada + " - " + nombreCliente + "</option>"); // Imprimir fecha con nombre y apellido del cliente
            }
        } else if ("cargarProductos".equals(listar)) {
            rs = st.executeQuery("SELECT idproductos, pro_nombre, pro_precio, impuesto FROM productos");
            out.print("<option value='' disabled selected>Seleccione un Producto</option>");
            while (rs.next()) {
                int idProducto = rs.getInt("idproductos");
                String nombreProducto = rs.getString("pro_nombre");
                String impuesto = rs.getString("impuesto");
                String precio_unitario = rs.getString("pro_precio");
                out.print("<option value='" + idProducto + "' data-impuesto='" + impuesto + "' data-precio-unitario='" + precio_unitario + "'>" + nombreProducto + "</option>");
            }
        } else if ("cargarMetodosDePago".equals(listar)) {
            rs = st.executeQuery("SELECT idmetodos_pago, metpag_nombre FROM metodos_pago");
            out.print("<option value='selectmp'>Seleccione un Método de Pago</option>");
            while (rs.next()) {
                int idMetodoPago = rs.getInt("idmetodos_pago");
                String nombreMetodoPago = rs.getString("metpag_nombre");
                out.print("<option value='" + idMetodoPago + "'>" + nombreMetodoPago + "</option>");
            }
        } else if ("cargar".equals(listar)) {
    // Cabecera
    String clientes_id = request.getParameter("clientes_id");
    String ventas_fecha = request.getParameter("ventas_fecha");
    String ventas_estado = request.getParameter("ventas_estado");
    String ventas_hora = request.getParameter("ventas_hora");
    String condicion_venta = request.getParameter("condicion_venta");
    String pedido_id = request.getParameter("pedido_id");
    String idmetodos_pago = request.getParameter("idmetodos_pago");
    String total_venta = request.getParameter("total_venta");
    String iva10_total = request.getParameter("iva10_total");
    String num_dias = "0";

    if ("Credito".equalsIgnoreCase(condicion_venta)) {
        num_dias = request.getParameter("cuotas");
    }

    // Detalle
    String productos_id = request.getParameter("productos_id");
    String detventas_preciounitario = request.getParameter("detventas_preciounitario");
    String detventas_cantidad = request.getParameter("detventas_cantidad");

    try {
        st = conn.createStatement();
        HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");

        // Verificar si ya existe una venta pendiente para el empleado
        ResultSet rsPendiente = st.executeQuery("SELECT idventas FROM ventas WHERE ventas_estado = 'Pendiente' AND empleados_id = " + empleados_id);
        if (rsPendiente.next()) {
            // Existe una venta pendiente, obtener su ID
            int idVentaPendiente = rsPendiente.getInt("idventas");

            // Validar si el producto ya fue insertado en la venta pendiente
            ResultSet rsDetalleExistente = st.executeQuery("SELECT * FROM detalle_ventas WHERE ventas_id = " + idVentaPendiente + " AND productos_id = " + productos_id);
            if (rsDetalleExistente.next()) {
                out.println("<div class='alert alert-warning' role='alert'>El producto ya ha sido añadido a la venta pendiente con ID: " + idVentaPendiente + "</div>");
            } else {
                // Insertar el detalle de ventas usando la venta pendiente
                String insertDetalle = "INSERT INTO detalle_ventas (detventas_cantidad, detventas_preciounitario, ventas_id, productos_id) VALUES ("
                        + detventas_cantidad + ", " + detventas_preciounitario + ", " + idVentaPendiente + ", " + productos_id + ")";
                int rowsDetalle = st.executeUpdate(insertDetalle);

                if (rowsDetalle > 0) {
                    out.println("<div class='alert alert-success' role='alert'>Detalle de ventas insertado correctamente en la venta pendiente con ID: " + idVentaPendiente + "</div>");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Error al insertar el detalle de ventas</div>");
                }
            }
        } else {
            // No existe venta pendiente, proceder con la inserción
            String insertVenta;
            if (pedido_id != null && !pedido_id.isEmpty()) {
                // Nueva venta con pedido
                insertVenta = "INSERT INTO ventas (ventas_fecha, ventas_estado, clientes_id, empleados_id, hora, condicion_venta, pedido_id, metodos_pago_id, total_venta, iva_10, num_dias) VALUES ('"
                        + ventas_fecha + "', '" + ventas_estado + "', " + clientes_id + ", " + empleados_id + ", '" + ventas_hora + "', '" + condicion_venta + "', "
                        + pedido_id + ", " + idmetodos_pago + ", " + total_venta + ", " + iva10_total + ", " + num_dias + ")";
            } else {
                // Nueva venta sin pedido
                insertVenta = "INSERT INTO ventas (ventas_fecha, ventas_estado, clientes_id, empleados_id, hora, condicion_venta, metodos_pago_id, total_venta, iva_10, num_dias) VALUES ('"
                        + ventas_fecha + "', '" + ventas_estado + "', " + clientes_id + ", " + empleados_id + ", '" + ventas_hora + "', '" + condicion_venta + "', "
                        + idmetodos_pago + ", " + total_venta + ", " + iva10_total + ", " + num_dias + ")";
            }

            int rowsVenta = st.executeUpdate(insertVenta, Statement.RETURN_GENERATED_KEYS);
            if (rowsVenta > 0) {
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int idVenta = generatedKeys.getInt(1);

                    // Copiar detalles del pedido a detalle_ventas si se agregó desde un pedido
                    if (pedido_id != null && !pedido_id.isEmpty()) {
                        String copyDetails = "INSERT INTO detalle_ventas (ventas_id, productos_id, detventas_cantidad, detventas_preciounitario) "
                                + "SELECT " + idVenta + ", productos_id, detpedidos_cantidad, detpedidos_preciounitario "
                                + "FROM detalle_pedidos WHERE pedidos_id = " + pedido_id;
                        int rowsDetalle = st.executeUpdate(copyDetails);

                        if (rowsDetalle > 0) {
                            out.println("<div class='alert alert-success' role='alert'>Venta y Detalles Insertados Correctamente</div>");
                        } else {
                            out.println("<div class='alert alert-danger' role='alert'>Error al insertar el detalle de ventas</div>");
                        }
                    } else {
                        // Validar si el producto ya existe en el detalle de la nueva venta
                        ResultSet rsNuevoDetalleExistente = st.executeQuery("SELECT * FROM detalle_ventas WHERE ventas_id = " + idVenta + " AND productos_id = " + productos_id);
                        if (rsNuevoDetalleExistente.next()) {
                            out.println("<div class='alert alert-warning' role='alert'>El producto ya ha sido añadido a la venta con ID: " + idVenta + "</div>");
                        } else {
                            // Insertar manualmente detalle de ventas
                            String insertDetalle = "INSERT INTO detalle_ventas (detventas_cantidad, detventas_preciounitario, ventas_id, productos_id) VALUES ("
                                    + detventas_cantidad + ", " + detventas_preciounitario + ", " + idVenta + ", " + productos_id + ")";
                            int rowsDetalle = st.executeUpdate(insertDetalle);

                            if (rowsDetalle > 0) {
                                out.println("<div class='alert alert-success' role='alert'>Venta Directa y Detalle Insertados Correctamente</div>");
                            } else {
                                out.println("<div class='alert alert-danger' role='alert'>Error al insertar el detalle de ventas</div>");
                            }
                        }
                    }
                }
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Error al insertar la venta</div>");
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error: " + e.getMessage() + "</div>");
    }
}else if (request.getParameter("listar").equals("mostrardetalle")) {

            String pedido_id = request.getParameter("pedido_id");

            if (pedido_id != null && !pedido_id.isEmpty()) {
                // Si pedido_id tiene un valor, busca la venta relacionada a ese pedido
                rs = st.executeQuery("SELECT idventas FROM ventas WHERE pedido_id = " + pedido_id + " AND ventas_estado = 'Pendiente';");
            } else {
                HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");
                rs = st.executeQuery("SELECT idventas FROM ventas WHERE ventas_estado = 'Pendiente' AND empleados_id = " + empleados_id);
            }
            if (rs.next()) {
                int idVenta = rs.getInt("idventas");
                ResultSet pk = st.executeQuery("SELECT dv.iddetalle_ventas, p.pro_nombre AS producto_id, "
                        + "dv.detventas_preciounitario, dv.detventas_cantidad, p.impuesto "
                        + "FROM detalle_ventas dv "
                        + "JOIN productos p ON dv.productos_id = p.idproductos "
                        + "WHERE dv.ventas_id =" + idVenta);

                int sumador = 0;
                int totalIva10 = 0; // Total para IVA del 10%

                while (pk.next()) {
                    String iddetalle_ventas = pk.getString("iddetalle_ventas");
                    String producto_id = pk.getString("producto_id");
                    String detventas_preciounitario = pk.getString("detventas_preciounitario");
                    String detventas_cantidad = pk.getString("detventas_cantidad");
                    int impuesto = pk.getInt("impuesto");

                    int subtotal10 = 0; // Para el IVA del 10%

                    int precio = pk.getInt("detventas_preciounitario");
                    int cantidad = pk.getInt("detventas_cantidad");

                    // Calcular subtotales e impuestos
                    if (impuesto == 10) {
                        subtotal10 = (precio * cantidad);
                        totalIva10 += subtotal10; // Acumula el total gravado al 10%
                    }

                    sumador += subtotal10;

                    // Formatear los subtotales para mostrar
                    DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
                    df.applyPattern("#,###"); // Formato sin decimales

                    String calcularFormateado10 = df.format(subtotal10);
                    String precioFormateado = df.format(precio);

%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= detventas_cantidad%></td>
    <td style="text-align: center; vertical-align: middle;"><%= producto_id%></td>
    <td style="text-align: center; vertical-align: middle;"><%= precioFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= (impuesto == 10 ? calcularFormateado10 : "")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color: blue; font-size: 16px;" onclick="$('#id_delete').val('<%= iddetalle_ventas%>')"></i>
    </td>
</tr>
<%
        }

        // Cerrar el ResultSet
        pk.close();

        // Formatear los totales de IVA
        DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
        df.applyPattern("#,###"); // Sin decimales, usa 0 para obligar a que muestre al menos un dígito
        String iva10formateado = df.format(totalIva10);

        // Calcular el total de ventas sumando IVA10
        int totalVentas = totalIva10;
        String totalVentasFormateado = df.format(totalVentas);

        // Guarda los totales en la sesión
        session.setAttribute("sumador", sumador);
        session.setAttribute("iva10formateado", iva10formateado);
        session.setAttribute("totalVentasFormateado", totalVentasFormateado);

        // Imprimir los totales al final del proceso para que se devuelvan en la respuesta
        out.println("<input type='hidden' id='totalIva10' value='" + iva10formateado + "'/>");
        out.println("<input type='hidden' id='totalVentas' value='" + totalVentasFormateado + "'/>");
    } else {
        out.println("No hay ventas pendientes.");
    }
    rs.close();
    st.close();
} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");

    try {
        st = null;
        st = conn.createStatement();
        st.executeUpdate("delete from detalle_ventas where iddetalle_ventas=" + id_delete + "");
        //out.println("<div class='alert alert-success' role='alert'>Datos eliminados correctamente</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("mostrartotal10")) {
    try {
        // Obtener el total de IVA 10% desde la sesión
        String iva10formateado = (String) session.getAttribute("iva10formateado");

        // Validar que no esté nulo o vacío
        if (iva10formateado != null && !iva10formateado.isEmpty()) {
            // Reemplazar los puntos de los miles para evitar errores de conversión
            iva10formateado = iva10formateado.replace(".", "");

            // Convertir el valor limpio a un número
            double iva10Dividido = Double.parseDouble(iva10formateado) / 11;

            // Convertir a entero para eliminar los decimales (sin Math.round para evitar redondeo)
            int iva10DivididoEntero = (int) iva10Dividido;

            // Formatear el resultado para mantener el formato de miles con comas
            DecimalFormat df = new DecimalFormat("#,###");
            String iva10DivididoFormateado = df.format(iva10DivididoEntero);

            // Enviar el resultado al frontend
            out.println(iva10DivididoFormateado);

            // Guardar en sesión el valor formateado para referencia futura
            session.setAttribute("iva10DivididoFormateado", iva10DivididoFormateado);
        } else {
            out.println("0");
        }
    } catch (Exception e) {
        out.println("Error al mostrar total del IVA 10%: " + e);
    }
}else if (request.getParameter("listar").equals("mostrartotaliva")) {
    try {
        // Obtener el total de IVA 10% desde la sesión
        String iva10formateado = (String) session.getAttribute("iva10formateado");

        // Validar que no esté nulo o vacío
        if (iva10formateado != null && !iva10formateado.isEmpty()) {
            // Eliminar puntos de miles, dejando solo números
            iva10formateado = iva10formateado.replace(".", "");

            // Convertir el valor formateado a número
            double iva10Dividido = Double.parseDouble(iva10formateado) / 11;

            // Convertir a entero para eliminar decimales
            int iva10DivididoEntero = (int) iva10Dividido;  // Sin Math.round

            // Formatear el resultado con puntos de miles
            DecimalFormat df = new DecimalFormat("#,###");
            String totalComprasFormateado = df.format(iva10DivididoEntero);

            // Enviar el resultado formateado al frontend
            out.println(totalComprasFormateado);
        } else {
            // Si el valor es nulo o vacío, mostrar 0
            out.println("0");
        }
    } catch (Exception e) {
        out.println("Error al mostrar total del IVA: " + e);
    }
} else if (request.getParameter("listar").equals("mostrartotales")) {
    String totalVentasFormateado = (String) session.getAttribute("totalVentasFormateado");
    if (totalVentasFormateado != null) {
        out.println(totalVentasFormateado);
    } else {
        out.println("No se han calculado los totales.");
    }
} else if (request.getParameter("listar").equals("cancelar")) {
    st = null;
    rs = null;
    try {
        st = conn.createStatement();
HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");
        rs = st.executeQuery("SELECT idventas FROM ventas WHERE ventas_estado = 'Pendiente' AND empleados_id = " + empleados_id);
        rs.next();
        st.executeUpdate("update ventas set ventas_estado ='Cancelado' where idventas =" + rs.getString(1) + "");
        //out.println("<div class='alert alert-success' role='alert'>Datos modificados correctamente</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("finalizar")) {
    st = null;
    rs = null;

    // Obtener parámetros necesarios
    String clientes_id = request.getParameter("clientes_id");
    String idmetodos_pago = request.getParameter("idmetodos_pago");
    String cuotas = request.getParameter("cuotas");
    String condicion_venta = request.getParameter("condicion_venta");
    String pedido_id = request.getParameter("pedido_id");

    HttpSession sesion = request.getSession();
    int empleados_id = (Integer) sesion.getAttribute("idempleados");

    try {
        st = conn.createStatement();
        
        // Obtener el ID de la venta pendiente
        rs = st.executeQuery("SELECT idventas FROM ventas WHERE ventas_estado = 'Pendiente' AND empleados_id = " + empleados_id);
        if (rs.next()) {
            int idVenta = rs.getInt("idventas");

            // Validar stock de los productos en la venta
            String stockQuery = "SELECT dv.productos_id, dv.detventas_cantidad, p.stock_actual "
                    + "FROM detalle_ventas dv "
                    + "JOIN productos p ON dv.productos_id = p.idproductos "
                    + "WHERE dv.ventas_id = " + idVenta;
            rs = st.executeQuery(stockQuery);

            boolean stockSuficiente = true;
            StringBuilder productosSinStock = new StringBuilder();

            while (rs.next()) {
                int productosId = rs.getInt("productos_id");
                int cantidadSolicitada = rs.getInt("detventas_cantidad");
                int stockActual = rs.getInt("stock_actual");

                // Verificar si hay suficiente stock
                if (cantidadSolicitada > stockActual) {
                    stockSuficiente = false;
                    productosSinStock.append("Producto ID: ").append(productosId)
                            .append(" - Cantidad solicitada: ").append(cantidadSolicitada)
                            .append(", Stock disponible: ").append(stockActual).append("<br/>");
                }
            }

            // Verificar si hay suficiente stock
            if (!stockSuficiente) {
// Informar que no hay suficiente stock
                out.println("<div class='alert alert-danger' role='alert'>Venta cancelada. No hay suficiente stock.</div>");

                // Salir del método si no hay suficiente stock
                // Actualizar el estado de la venta a "Cancelado"
                String cancelUpdateSQL = "UPDATE ventas SET ventas_estado = 'Cancelado' WHERE idventas = " + idVenta;
                st.executeUpdate(cancelUpdateSQL);

                return;
            }

            // Si hay suficiente stock, continuar con la finalización de la venta
            String totalVentasFormateado = (String) sesion.getAttribute("totalVentasFormateado");
            String iva10DivididoFormateado = (String) sesion.getAttribute("iva10DivididoFormateado");

            int totalVentas = Integer.parseInt(totalVentasFormateado.replace(".", ""));
            int iva10 = Integer.parseInt(iva10DivididoFormateado.replace(".", ""));

            // Actualizar el estado y los totales de la venta a "Finalizado"
            String updateSQL = "UPDATE ventas SET "
                    + "ventas_estado = 'Finalizado', "
                    + "total_venta = " + totalVentas + ", "
                    + "iva_10 = " + iva10 + " "
                    + "WHERE idventas = " + idVenta;
            st.executeUpdate(updateSQL);

            // Imprimir valores para depuración
            System.out.println("Cliente ID: " + clientes_id);
            System.out.println("Método de Pago: " + idmetodos_pago);
            System.out.println("Empleado ID: " + empleados_id);
            System.out.println("Total a Cobrar: " + totalVentas);
            System.out.println("ID Venta: " + idVenta);
            System.out.println("Número de Días: " + cuotas);
            System.out.println("Condición de Venta: " + condicion_venta);

            // Determinar estado de cobro
            String estadoCobro = condicion_venta.equals("Contado") ? "Cobrado" : "Pendiente";

            // Ejecutar la inserción en la tabla cobros
            String insertCobroSQL = "INSERT INTO cobros (fecha_cobro, cliente_id, met_pag, estado_cobro, empleado_id, total_cobro, num_dias, venta_id) "
                    + "VALUES (CURRENT_DATE, " + clientes_id + ", '" + idmetodos_pago + "', '" + estadoCobro + "', " + empleados_id + ", "
                    + totalVentas + ", " + cuotas + ", " + idVenta + ")";
            st.executeUpdate(insertCobroSQL);  // Ejecutar la inserción

            // Si hay un pedido_id, actualizar el estado_entrega en la tabla de pedidos
            if (pedido_id != null && !pedido_id.isEmpty()) {
                String updatePedidoSQL = "UPDATE pedidos SET estado_entrega = 'Entregado' WHERE idpedidos = " + pedido_id;
                st.executeUpdate(updatePedidoSQL); // Actualiza el estado de entrega
            }

            out.println("<div class='alert alert-success' role='alert'>Venta finalizada y cobro registrado correctamente</div>");

        } else {
            out.println("<div class='alert alert-warning' role='alert'>No hay ventas pendientes para finalizar</div>");
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger' role='alert'>Error en la base de datos: " + e.getMessage() + "</div>");
        e.printStackTrace();  // Imprimir stack trace para depuración
    }
} else if (request.getParameter("listar").equals("anularventas")) {
    st = null;
    rs = null;
    String pkdelete = request.getParameter("pkdelete");
    try {
        st = conn.createStatement();

        // Anular la venta
        st.executeUpdate("UPDATE ventas SET ventas_estado = 'Anulado' WHERE idventas = " + pkdelete);

        st.executeUpdate("UPDATE cobros SET estado_cobro = 'Anulado' WHERE venta_id = " + pkdelete);

        out.println("<div class='alert alert-success' role='alert'>Venta anulada y cobro registrado como anulado correctamente</div>");

    } catch (Exception e) {
        out.println("Error en la base de datos: " + e);
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Mostrar el error en la consola
            out.println("Error al cerrar los recursos: " + e.getMessage());
        }
    }
} else if (request.getParameter("listar").equals("mostrarventas")) {
    try {
        st = null;
        ResultSet pk = null;
        st = conn.createStatement();
HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
String rolNombre = (String) sesion.getAttribute("rol_nombre");
        String sql;

    if ("Administrador".equals(rolNombre)) {
        sql = "SELECT v.idventas AS id, "
                + "to_char(v.ventas_fecha, 'dd/mm/YYYY') AS fecha, "
                + "v.ventas_estado AS estado, "
                + "v.condicion_venta AS condicion_venta, " // Nueva columna añadida
                + "c.cli_nombre || ' ' || c.cli_apellido AS cliente, "
                + "v.total_venta AS total_venta "
                + "FROM ventas v "
                + "JOIN clientes c ON v.clientes_id = c.idclientes "
                + "WHERE v.ventas_estado = 'Finalizado' "
                + "ORDER BY v.idventas DESC;"; // Sin filtro por empleado
    } else {
        sql = "SELECT v.idventas AS id, "
                + "to_char(v.ventas_fecha, 'dd/mm/YYYY') AS fecha, "
                + "v.ventas_estado AS estado, "
                + "v.condicion_venta AS condicion_venta, " 
                + "c.cli_nombre || ' ' || c.cli_apellido AS cliente, "
                + "v.total_venta AS total_venta "
                + "FROM ventas v "
                + "JOIN clientes c ON v.clientes_id = c.idclientes "
                + "WHERE v.ventas_estado = 'Finalizado' "
                + "AND v.empleados_id = " + empleado_id + " " 
                + "ORDER BY v.idventas DESC;";
    }

        pk = st.executeQuery(sql);
        while (pk.next()) {
            DecimalFormat df = new DecimalFormat("#,###");
            double total_venta = pk.getDouble("total_venta");
            String totalVentaFormateado = df.format(total_venta) + " Gs.";
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"> <% out.print(pk.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("fecha")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("condicion_venta")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("cliente"));%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%= totalVentaFormateado%>
    </td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val(<% out.print(pk.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteVentas.jsp?id=<%= pk.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
        }
        // Cerrar los recursos correctamente
        pk.close(); // Cierra pk en lugar de rs
        st.close();
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
String rolNombre = (String) sesion.getAttribute("rol_nombre");
   String query;

if ("Administrador".equals(rolNombre)) {
    query = "SELECT v.idventas AS id, "
            + "to_char(v.ventas_fecha, 'dd/mm/YYYY') AS fecha, "
            + "c.cli_nombre || ' ' || c.cli_apellido AS cliente, "
            + "v.ventas_estado AS estado, "
            + "v.condicion_venta AS condicion_venta, "
            + "v.total_venta AS total_venta "
            + "FROM ventas v "
            + "JOIN clientes c ON v.clientes_id = c.idclientes "
            + "WHERE LOWER(c.cli_nombre) LIKE '" + buscador + "%' "
            + "AND v.ventas_estado = 'Finalizado' "
            + "ORDER BY v.idventas DESC;"; 
} else {
    query = "SELECT v.idventas AS id, "
            + "to_char(v.ventas_fecha, 'dd/mm/YYYY') AS fecha, "
            + "c.cli_nombre || ' ' || c.cli_apellido AS cliente, "
            + "v.ventas_estado AS estado, "
            + "v.condicion_venta AS condicion_venta, "
            + "v.total_venta AS total_venta "
            + "FROM ventas v "
            + "JOIN clientes c ON v.clientes_id = c.idclientes "
            + "WHERE LOWER(c.cli_nombre) LIKE '" + buscador + "%' "
            + "AND v.ventas_estado = 'Finalizado' "
            + "AND v.empleados_id = " + empleado_id + " " 
            + "ORDER BY v.idventas DESC;";
}


    st = null;
    ResultSet pk = null;

    try {
        st = conn.createStatement();

        // Ejecución de la consulta
        pk = st.executeQuery(query);

        // Recorrido de los resultados
        while (pk.next()) {
            DecimalFormat df = new DecimalFormat("#,###");
            double total_venta = pk.getDouble("total_venta");
            String totalVentaFormateado = df.format(total_venta) + " Gs.";
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"> <% out.print(pk.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("fecha")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("condicion_venta")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("cliente"));%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%= totalVentaFormateado%>
    </td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val(<% out.print(pk.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteVentas.jsp?id=<%= pk.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
                }
                // Cerrar los recursos correctamente
                pk.close(); // Cierra pk
                st.close();
            } catch (Exception e) {
                out.println("error PSQL: " + e);
            }
        }
//AQUI CONTINUAR
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al conectar a la base de datos: " + e.getMessage() + "</div>");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger' role='alert'>Error al cerrar la conexión: " + e.getMessage() + "</div>");
        }
    }

%>
