<%@ include file="conexion.jsp" %>
<%    String listar = request.getParameter("listar");

    if (listar != null) {
        String queryUpdate = null;
        String queryCount = null;
        int rowsCount = 0;

        switch (listar) {
            case "actualizarEstadoPedidos":

                /*queryUpdate = "UPDATE pedidos "
                        + "SET estado_entrega = 'No Entregado' "
                        + "WHERE fecha_pedido < CURRENT_DATE "
                        + "AND idpedidos NOT IN ("
                        + "    SELECT pedido_id "
                        + "    FROM ventas "
                        + "    WHERE ventas_estado = 'Finalizado' AND pedido_id IS NOT NULL"
                        + ") "
                        + "AND idpedidos NOT IN ("
                        + "    SELECT pedido_id "
                        + "    FROM produccion "
                        + "    WHERE estado_produccion = 'Finalizado' AND pedido_id IS NOT NULL"
                        + ") "
                        + "AND estado_entrega != 'No Entregado';";*/
                queryUpdate = "UPDATE pedidos "
                        + "SET estado_entrega = 'No Entregado' "
                        + "WHERE fecha_pedido < CURRENT_DATE "
                        + "AND idpedidos NOT IN ("
                        + "    SELECT pedido_id "
                        + "    FROM ventas "
                        + "    WHERE ventas_estado = 'Finalizado' AND pedido_id IS NOT NULL"
                        + ") "
                        + "AND estado_entrega != 'Entregado';";

                queryCount = "SELECT COUNT(*) FROM pedidos WHERE estado_entrega = 'No Entregado';";
                break;

            case "actualizarEstadoPagos":
                queryUpdate = "UPDATE pagos p "
                        + "SET estado_pago = 'Pendiente en Mora' "
                        + "FROM compras c "
                        + "WHERE p.compras_id = c.idcompras "
                        + "AND p.estado_pago = 'Pendiente' "
                        + "AND c.condicion_compra = 'Credito' "
                        + "AND p.fecha_pago + INTERVAL '1 day' * p.num_dias < CURRENT_DATE;";

                queryCount = "SELECT COUNT(*) FROM pagos WHERE estado_pago = 'Pendiente en Mora';";
                break;

            case "actualizarEstadoCobros":
                queryUpdate = "UPDATE cobros co "
                        + "SET estado_cobro = 'Pendiente en Mora' "
                        + "FROM ventas v "
                        + "WHERE co.venta_id = v.idventas "
                        + "AND co.estado_cobro = 'Pendiente' "
                        + "AND v.condicion_venta = 'Credito' "
                        + "AND co.fecha_cobro + INTERVAL '1 day' * co.num_dias < CURRENT_DATE;";

                queryCount = "SELECT COUNT(*) FROM cobros WHERE estado_cobro = 'Pendiente en Mora';";
                break;

            default:
                break;
        }

        if (queryUpdate != null) {
            try {
                // Ejecutar la actualización sin mostrar un mensaje específico
                try (PreparedStatement psUpdate = conn.prepareStatement(queryUpdate)) {
                    psUpdate.executeUpdate();
                }

                // Consultar el conteo sin importar si hubo cambios en la actualización
                try (PreparedStatement psCount = conn.prepareStatement(queryCount)) {
                    ResultSet rs = psCount.executeQuery();
                    if (rs.next()) {
                        rowsCount = rs.getInt(1);
                    }
                }

                // Generar el mensaje de conteo
                StringBuilder mensaje = new StringBuilder();
                if (listar.equals("actualizarEstadoPedidos")) {
                    mensaje.append("<div class='alert alert-success alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #d4edda;'>")
                            .append("<i class='fas fa-info-circle me-2'></i>")
                            .append("Total de pedidos&nbsp;&nbsp;<b>No Entregados:<b> <b>")
                            .append(rowsCount)
                            .append("</b>")
                            .append("</div>");
                } else if (listar.equals("actualizarEstadoPagos")) {
                    mensaje.append("<div class='alert alert-success alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #d4edda;'>")
                            .append("<i class='fas fa-info-circle me-2'></i>")
                            .append("Total de pagos&nbsp;&nbsp;<b>Pendientes en Mora:<b> <b>")
                            .append(rowsCount)
                            .append("</b>")
                            .append("</div>");
                } else if (listar.equals("actualizarEstadoCobros")) {
                    mensaje.append("<div class='alert alert-success alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #d4edda;'>")
                            .append("<i class='fas fa-info-circle me-2'></i>")
                            .append("Total de cobros&nbsp;&nbsp;<b>Pendientes en Mora:<b> <b>")
                            .append(rowsCount)
                            .append("</b>")
                            .append("</div>");
                }
                out.print(mensaje.toString());

            } catch (Exception ex) {
                out.print("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        out.print("<div class='alert alert-danger'>Error al cerrar la conexión: " + e.getMessage() + "</div>");
                    }
                }
            }
        }
    } else {
        out.print("<div class='alert alert-danger'>No se especificó ninguna acción.</div>");
    }
%>
