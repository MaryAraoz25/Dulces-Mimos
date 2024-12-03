<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");

    if (listar != null) {
        String query = null;

        switch (listar) {
            case "contarProductos":
                query = "SELECT COUNT(*) FROM productos";
                break;
            case "contarClientes":
                query = "SELECT COUNT(*) FROM clientes";
                break;
            case "contarUsuarios":
                query = "SELECT COUNT(*) FROM usuarios";
                break;
            case "contarEmpleados":
                query = "SELECT COUNT(*) FROM empleados";
                break;
            case "contarIngredientes":
                query = "SELECT ingre_nombre FROM ingredientes WHERE ingre_stock <= ingre_stockmin";
                break;
            case "contarStockProductos":
                query = "SELECT pro_nombre FROM productos WHERE stock_actual <= stock_minimo";
                break;
            case "pedidosProximos":
                query = "SELECT idpedidos, TO_CHAR(fecha_pedido, 'DD-MM-YYYY') AS fecha_formateada "
                        + "FROM pedidos "
                        + "WHERE fecha_pedido <= CURRENT_DATE + INTERVAL '3 days' "
                        + "AND estado_entrega = 'Pendiente'";
                break;
            case "verificarStock":
                query = "SELECT p.idpedidos, STRING_AGG(pr.pro_nombre, ', ') AS productos_no_disponibles "
                        + "FROM pedidos p "
                        + "JOIN detalle_pedidos dp ON p.idpedidos = dp.pedidos_id "
                        + "JOIN productos pr ON dp.productos_id = pr.idproductos "
                        + "WHERE p.estado_stock = 'No Disponible' "
                        + "GROUP BY p.idpedidos";
                break;
            case "produccionProxima":
                query = "SELECT idproduccion, fecha_vencimiento FROM produccion WHERE fecha_vencimiento <= CURRENT_DATE + INTERVAL '3 days'";
                break;
            case "conteoRegresivoPago":
                query = "SELECT c.idcompras, c.compras_fecha, p.num_dias, "
                        + "(c.compras_fecha + (p.num_dias * INTERVAL '1 day')) AS fecha_limite, "
                        + "EXTRACT(DAY FROM (c.compras_fecha + (p.num_dias * INTERVAL '1 day')) - CURRENT_DATE) AS dias_restantes, "
                        + "p.estado_pago "
                        + "FROM compras c "
                        + "JOIN pagos p ON c.idcompras = p.compras_id "
                        + "WHERE p.estado_pago = 'Pendiente' "
                        + "AND (c.compras_fecha + (p.num_dias * INTERVAL '1 day')) >= CURRENT_DATE;";
                break;
            case "conteoRegresivoCobros":
                query = "SELECT idcobro, fecha_cobro, num_dias, "
                        + "(fecha_cobro + (num_dias * INTERVAL '1 day')) AS fecha_limite, "
                        + "EXTRACT(DAY FROM (fecha_cobro + (num_dias * INTERVAL '1 day')) - CURRENT_DATE) AS dias_restantes "
                        + "FROM cobros WHERE estado_cobro = 'Pendiente' AND "
                        + "(fecha_cobro + (num_dias * INTERVAL '1 day')) >= CURRENT_DATE;";
                break;

            default:
                out.print("<div class='alert alert-danger'>Acción no reconocida</div>");
                return;
        }

        try (PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {

            StringBuilder mensaje = new StringBuilder();
            boolean isCountQuery = listar.equals("contarProductos") || listar.equals("contarClientes") || listar.equals("contarUsuarios") || listar.equals("contarEmpleados");

            if (isCountQuery) {
                if (rs.next()) {
                    out.print(rs.getInt(1));
                } else {
                    out.print("0");
                }
            } else {
                while (rs.next()) {
                    switch (listar) {
                        case "contarIngredientes":
                            String nombreIngr = rs.getString(1);
                            mensaje.append("<div class='alert alert-danger alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #f8d7da;'>")
                                    .append("<i class='fas fa-exclamation-triangle me-2'></i>")
                                    .append(" Stock del ingrediente <b style='margin-left: 5px; margin-right: 5px;'>").append(nombreIngr).append("</b> bajo.")
                                    .append(" Por favor vaya a <a href='FormCompras.jsp' style='margin-left: 2px;'>Compras</a>")
                                    .append("</div>");
                            break;

                        case "contarStockProductos":
                            String nombreProd = rs.getString(1);
                            mensaje.append("<div class='alert alert-info alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #d1ecf1;'>")
                                    .append("<i class='fas fa-box me-2'></i>")
                                    .append(" Stock del producto <b style='margin-left: 5px; margin-right: 5px;'>").append(nombreProd).append("</b> bajo.")
                                    .append(" Por favor vaya a <a href='FormProduccion.jsp' style='margin-left: 2px;'>Producción</a>")
                                    .append("</div>");
                            break;

                        case "pedidosProximos":
                            int idPedido = rs.getInt(1);
                            String fechaPedido = rs.getString(2);
                            mensaje.append("<div class='alert alert-warning alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #fff3cd;'>")
                                    .append("<i class='fas fa-calendar-alt me-2'></i>")
                                    .append(" Pedido <b style='margin-left: 3px; margin-right: 3px;'>").append(idPedido).append("</b> con fecha de entrega cercana: <b style='margin-left: 5px;'>").append(fechaPedido).append("</b>.")
                                    .append(" Por favor vaya a <a href='FormVentas.jsp' style='margin-left: 3px;'>Ventas</a>")
                                    .append("</div>");
                            break;

                        case "produccionProxima":
                            int idProduccion = rs.getInt(1);
                            String fechaVencimiento = rs.getString(2);
                            mensaje.append("<div class='alert alert-success alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #d4edda;'>")
                                    .append("<i class='fas fa-check-circle me-2'></i>")
                                    .append(" Producción <b style='margin-left: 3px; margin-right: 3px;'>").append(idProduccion).append("</b> con fecha de vencimiento cercana: <b style='margin-left: 5px;'>").append(fechaVencimiento).append("</b>.")
                                    .append(" Por favor vaya a <a href='ListadoProduccion.jsp' style='margin-left: 3px;'>Producción</a>")
                                    .append("</div>");
                            break;

                        case "verificarStock":
                            int idPedidoVerificar = rs.getInt("idpedidos");
                            String productosNoDisponibles = rs.getString("productos_no_disponibles");
                            mensaje.append("<div class='alert alert-danger alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #f8d7da;'>")
                                    .append("<i class='fas fa-exclamation-triangle me-2'></i>")
                                    .append(" Pedido <b style='margin-left: 3px; margin-right: 3px;'>").append(idPedidoVerificar).append("</b> tiene productos no disponibles: <b style='margin-left: 5px;'>").append(productosNoDisponibles).append("</b>.")
                                    .append(" Por favor vaya a <a href='ListadoPedidos.jsp' style='margin-left: 3px;'>Pedidos</a>")
                                    .append("</div>");
                            break;

                        case "conteoRegresivoPago":
                            int idCompra = rs.getInt("idcompras");
                            String fechaCompra = rs.getString("compras_fecha");
                            int diasRestantes = rs.getInt("dias_restantes");

                            mensaje.append("<div class='alert alert-primary alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #cce5ff;'>")
                                    .append("<i class='fas fa-calendar-check me-2'></i>")
                                    .append(" La compra <b style='margin-left: 3px; margin-right: 3px;'>ID: </b>").append(idCompra)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> realizada el </b>").append(fechaCompra)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> tiene </b>").append(diasRestantes)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> días</b> restantes para el pago.")
                                    .append("</div>");
                            break;

                        case "conteoRegresivoCobros":
                            int idCobro = rs.getInt("idcobro");
                            String fechaCobro = rs.getString("fecha_cobro");
                            int diasRestantesCobro = rs.getInt("dias_restantes");

                            mensaje.append("<div class='alert alert-secondary alert-dismissible fade show d-flex align-items-center' role='alert' style='margin: 10px; background-color: #e2e3e5;'>")
                                    .append("<i class='fas fa-money-bill-wave me-2'></i>")
                                    .append(" El cobro <b style='margin-left: 3px; margin-right: 3px;'>ID: </b>").append(idCobro)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> realizado el </b>").append(fechaCobro)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> tiene </b>").append(diasRestantesCobro)
                                    .append("<b style='margin-left: 3px; margin-right: 3px;'> días</b> restantes.")
                                    .append("</div>");

                            break;

                    }
                }
                out.print(mensaje.toString());
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Cerrar la conexión si se utiliza conexión en conexión.jsp
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                out.print("<div class='alert alert-danger'>Error al cerrar la conexión: " + e.getMessage() + "</div>");
            }
        }
    }
%>
