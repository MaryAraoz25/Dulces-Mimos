<%-- 
    Document   : Produccion
    Created on : 2 ago. 2024, 20:18:18
    Author     : Maria
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");

    Statement st = conn.createStatement();
    ResultSet rs = null;

    if (listar != null && listar.equals("cargarRecetas")) {
        try {
            rs = st.executeQuery("SELECT idrecetas_productos, nombre_receta FROM recetas WHERE recetaspro_estado = 'Finalizado'");
            out.print("<option value=''>Seleccione una Receta</option>");
            while (rs.next()) {
                out.print("<option value='" + rs.getInt("idrecetas_productos") + "'>" + rs.getString("nombre_receta") + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar recetas</option>");
        } finally {
            if (rs != null) {
                rs.close();
            }
        }
    } else if (listar != null && listar.equals("cargarPedidos")) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy");
        try {
            rs = st.executeQuery("SELECT p.idpedidos, p.fecha_pedido, c.cli_nombre, c.cli_apellido "
                    + "FROM pedidos p "
                    + "JOIN clientes c ON p.cliente_id = c.idclientes "
                    + "WHERE p.estado_stock = 'No Disponible' "
                    + "AND p.fecha_pedido BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '7 days')");
            out.print("<option value=''>Seleccione un Pedido</option>");
            while (rs.next()) {
                // Formatear la fecha obtenida
                String fechaFormateada = sdf.format(rs.getDate("fecha_pedido"));
                String nombreCliente = rs.getString("cli_nombre") + " " + rs.getString("cli_apellido");
                out.print("<option value='" + rs.getInt("idpedidos") + "'>" + fechaFormateada + " - " + nombreCliente + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar pedidos</option>");
        } finally {
            if (rs != null) {
                rs.close();
            }
        }
    } else if (listar != null && listar.equals("cargar")) {
        String produccion_fecha_elaboracion = request.getParameter("fecha_elaboracion");
        String produccion_fecha_vencimiento = request.getParameter("fecha_vencimiento");
        String produccion_estado = request.getParameter("estado_produccion");
        String recetas_id = request.getParameter("receta_id");
        String cantidadStr = request.getParameter("cantidad");
        String pedido_id = request.getParameter("pedido_id");

        if (cantidadStr == null || cantidadStr.trim().isEmpty()) {
            out.println("<div class='alert alert-danger' role='alert'>La cantidad es obligatoria y no puede estar vacía.</div>");
            return;
        }

        int cantidad = 0;
        try {
            cantidad = Integer.parseInt(cantidadStr.trim());
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Cantidad inválida: " + cantidadStr + "</div>");
            return;
        }

        try {
            HttpSession sesion = request.getSession();
            int empleados_id = (Integer) sesion.getAttribute("idempleados");

            // Verificar si hay una producción pendiente
            ResultSet rsProduccionPendiente = st.executeQuery("SELECT idproduccion FROM produccion WHERE estado_produccion = 'Pendiente' AND empleados_id = " + empleados_id + ";");
            if (rsProduccionPendiente.next()) {
                out.println("<div class='alert alert-warning' role='alert'>Ya existe una producción en estado Pendiente.</div>");
            } else {
                // Manejar la inserción de pedido_id, validando si es nulo o no
                String pedidoSQL = (pedido_id != null && !pedido_id.trim().isEmpty()) ? pedido_id : "NULL";

                // Insertar en la tabla producción
                int rowsProduccion = st.executeUpdate(
                        "INSERT INTO produccion (fecha_elaboracion, fecha_vencimiento, estado_produccion, receta_id, empleados_id, cantidad, pedido_id) "
                        + "VALUES ('" + produccion_fecha_elaboracion + "', '" + produccion_fecha_vencimiento + "', '" + produccion_estado + "', "
                        + recetas_id + ", " + empleados_id + ", " + cantidad + ", " + pedidoSQL + ")",
                        Statement.RETURN_GENERATED_KEYS
                );

                if (rowsProduccion > 0) {
                    ResultSet generatedKeys = st.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int idProduccion = generatedKeys.getInt(1);

                        // Obtener los ingredientes asociados a la receta y crear el detalle de producción
                        Statement st1 = conn.createStatement();
                        ResultSet rsDetalleRecetas = st1.executeQuery("SELECT ingredientes_id, cantidad FROM detalle_recetas WHERE recetas_id = " + recetas_id);
                        while (rsDetalleRecetas.next()) {
                            int ingredientes_id = rsDetalleRecetas.getInt("ingredientes_id");
                            int cantidadBase = rsDetalleRecetas.getInt("cantidad");
                            int cantidadFinal = cantidadBase * cantidad;

                            // Verificar si el ingrediente ya existe en el detalle de producción
                            ResultSet rsCheckExist = st.executeQuery("SELECT * FROM detalle_produccion WHERE produccion_id = " + idProduccion + " AND ingredientes_id = " + ingredientes_id);
                            if (!rsCheckExist.next()) {
                                // Insertar el ingrediente si no existe en el detalle
                                st.executeUpdate("INSERT INTO detalle_produccion (produccion_id, ingredientes_id, cantidad) VALUES (" + idProduccion + ", " + ingredientes_id + ", " + cantidadFinal + ")");
                            } else {
                                out.println("<div class='alert alert-danger' role='alert'>Los ingredientes ya fueron insertados para esta producción.</div>");
                            }
                            rsCheckExist.close();
                        }
                        rsDetalleRecetas.close();
                        out.println("<div class='alert alert-success' role='alert'>Cabecera y Detalle insertados correctamente.</div>");
                    }
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Error al insertar la Producción.</div>");
                }
            }
            rsProduccionPendiente.close();
        } catch (SQLException e) {
            /*out.println("<div class='alert alert-danger' role='alert'>Error al cargar producción: " + e.getMessage() + "</div>");*/
        }
    } else if (listar != null && listar.equals("mostrardetalle")) {
        String recetaId = request.getParameter("receta_id");
        String cantidadProducirStr = request.getParameter("cantidad");

        int cantidadProducir;
        try {
            cantidadProducir = Integer.parseInt(cantidadProducirStr);
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Cantidad inválida: " + e.getMessage() + "</div>");
            return;
        }

        try {
            rs = st.executeQuery(
                    "SELECT dr.iddetalle_recetas, i.ingre_nombre, um.descripcion AS unidad_medida, "
                    + "(dr.cantidad * " + cantidadProducir + ") AS cantidad, "
                    + "(CASE WHEN i.ingre_stock >= (dr.cantidad * " + cantidadProducir + ") THEN 'Disponible' ELSE 'No Disponible' END) AS disponibilidad "
                    + "FROM detalle_recetas dr "
                    + "JOIN ingredientes i ON dr.ingredientes_id = i.idingredientes "
                    + "JOIN unidad_medida um ON i.unidad_de_medida_id = um.idunidad_medida "
                    + "WHERE dr.recetas_id = " + recetaId
            );

            boolean todosDisponibles = true; // Inicializa la variable
            while (rs.next()) {
                String ingre_nombre = rs.getString("ingre_nombre");
                String unidad_medida = rs.getString("unidad_medida");
                int cantidad = rs.getInt("cantidad");
                String disponibilidad = rs.getString("disponibilidad");

                // Verifica la disponibilidad
                if ("No Disponible".equals(disponibilidad)) {
                    todosDisponibles = false; // Si algún ingrediente no está disponible
                }
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= ingre_nombre%></td>
    <td style="text-align: center; vertical-align: middle;"><%= unidad_medida%></td>
    <td style="text-align: center; vertical-align: middle;"><%= cantidad%></td>
    <td style="text-align: center; vertical-align: middle; color: <%= "Disponible".equals(disponibilidad) ? "green" : "red"%>;">
        <%= disponibilidad%>
    </td>
</tr>
<%
        }
        session.setAttribute("todosDisponibles", todosDisponibles); // Establece el atributo de sesión

    } catch (SQLException e) {
        out.println("<div class='alert alert-danger' role='alert'>Error en la consulta: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) {
            rs.close();
        }
    }
} else if (listar != null && listar.equals("mostrarproductos")) {
    String pedido_id = request.getParameter("pedido_id");
    if (pedido_id == null || pedido_id.isEmpty()) {
        // Omitir la ejecución de la consulta o mostrar un mensaje
        //out.println("Por favor, seleccione un pedido válido.");
    } else {
        try {
            rs = st.executeQuery(
                    "SELECT p.idpedidos, dp.productos_id, pr.pro_nombre, dp.detpedidos_cantidad, "
                    + "(CASE WHEN pr.stock_actual >= dp.detpedidos_cantidad THEN 'Disponible' ELSE 'No Disponible' END) AS disponibilidad "
                    + "FROM pedidos p "
                    + "JOIN detalle_pedidos dp ON p.idpedidos = dp.pedidos_id "
                    + "JOIN productos pr ON dp.productos_id = pr.idproductos "
                    + "WHERE p.idpedidos = " + pedido_id
            );

            while (rs.next()) {
                String nombre_producto = rs.getString("pro_nombre");
                int cantidad = rs.getInt("detpedidos_cantidad");
                String disponibilidad = rs.getString("disponibilidad");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= nombre_producto%></td>
    <td style="text-align: center; vertical-align: middle;"><%= cantidad%></td>
    <td style="text-align: center; vertical-align: middle; color: <%= "Disponible".equals(disponibilidad) ? "green" : "red"%>;">
        <%= disponibilidad%>
    </td>
</tr>
<%
            }
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger' role='alert'>Error en la consulta: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) {
                rs.close();
            }
        }
    }
} else if (listar != null && listar.equals("cancelar")) {
    try {
        HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");
        rs = st.executeQuery("SELECT idproduccion FROM produccion WHERE estado_produccion = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idProduccion = rs.getInt("idproduccion");
            st.executeUpdate("UPDATE produccion SET estado_produccion = 'Cancelado' WHERE idproduccion = " + idProduccion);
            out.println("<div class='alert alert-success' role='alert'>Producción cancelada correctamente.</div>");
        } else {
            out.println("<div class='alert alert-info' role='alert'>No hay producciones pendientes para cancelar.</div>");
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al cancelar la producción: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) {
            rs.close();
        }
    }
} else if (listar != null && listar.equals("anular")) {
    String pkdelete = request.getParameter("pkdelete");
    if (pkdelete != null && !pkdelete.trim().isEmpty()) {
        try {
            int idProduccion = Integer.parseInt(pkdelete.trim());
            int rowsAffected = st.executeUpdate("UPDATE produccion SET estado_produccion = 'Anulado' WHERE idproduccion = " + idProduccion);
            if (rowsAffected > 0) {
                out.println("<div class='alert alert-success' role='alert'>Producción anulada correctamente.</div>");
            } else {
                out.println("<div class='alert alert-info' role='alert'>No se encontró ninguna producción con el ID especificado.</div>");
            }
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>ID de producción inválido: " + pkdelete + "</div>");
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger' role='alert'>Error al anular la producción: " + e.getMessage() + "</div>");
        }
    } else {
        out.println("<div class='alert alert-warning' role='alert'>Por favor, proporcione un ID de producción válido para anular.</div>");
    }
} else if (listar != null && listar.equals("finalizar")) {
    System.out.println("Solicitud para finalizar producción recibida.");
    HttpSession sesion = request.getSession();
    int empleados_id = (Integer) sesion.getAttribute("idempleados");
    rs = st.executeQuery("SELECT idproduccion FROM produccion WHERE estado_produccion = 'Pendiente' AND empleados_id = " + empleados_id + ";");
    if (rs.next()) {
        int idproduccion = rs.getInt("idproduccion");
        System.out.println("ID de producción obtenido: " + idproduccion);

        // Obtener la disponibilidad general desde la sesión
        Boolean todosDisponibles = (Boolean) session.getAttribute("todosDisponibles");
        System.out.println("Todos disponibles: " + todosDisponibles);

        String pedidoIdStr = request.getParameter("pedido_id");
        Integer pedidoId = null;
        if (pedidoIdStr != null && !pedidoIdStr.isEmpty()) {
            pedidoId = Integer.parseInt(pedidoIdStr);
        }

        if (todosDisponibles != null && todosDisponibles) {
            // Actualizar estado de producción a 'Finalizado'
            st.executeUpdate("UPDATE produccion SET estado_produccion = 'Finalizado' WHERE idproduccion = " + idproduccion);
            out.println("<div class='alert alert-success' role='alert'>Producción Finalizada.</div>");
            System.out.println("Producción finalizada para ID: " + idproduccion);

            if (pedidoId != null) {
                st.executeUpdate("UPDATE pedidos SET estado_stock = 'Disponible' WHERE idpedidos = " + pedidoId);
                System.out.println("Estado del pedido actualizado a 'Disponible' para ID: " + pedidoId);
            }

        } else {
            // Actualizar estado de producción a 'Cancelado'
            st.executeUpdate("UPDATE produccion SET estado_produccion = 'Cancelado' WHERE idproduccion = " + idproduccion);
            out.println("<div class='alert alert-danger' role='alert'>Ingredientes Insuficientes. Producción cancelada.</div>");
            System.out.println("Producción cancelada para ID: " + idproduccion);
        }
    } else {
        System.out.println("No se encontraron producciones pendientes.");
        out.println("<div class='alert alert-warning' role='alert'>No hay producciones pendientes para finalizar.</div>");
    }
} else if (listar != null && listar.equals("buscador")) {
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
    String rolNombre = (String) sesion.getAttribute("rol_nombre");

    String query;

    if ("Administrador".equals(rolNombre)) {
        query = "SELECT p.idproduccion AS id, "
                + "p.fecha_elaboracion AS fecha_elaboracion, "
                + "p.fecha_vencimiento AS fecha_vencimiento, "
                + "r.nombre_receta AS receta, "
                + "e.emple_nombre AS empleado, "
                + "p.cantidad AS cantidad, "
                + "p.estado_produccion AS estado "
                + "FROM produccion p "
                + "JOIN recetas r ON p.receta_id = r.idrecetas_productos "
                + "JOIN empleados e ON p.empleados_id = e.idempleados "
                + "WHERE (LOWER(r.nombre_receta) LIKE '" + buscador + "%' OR LOWER(e.emple_nombre) LIKE '" + buscador + "%') "
                + "AND p.estado_produccion = 'Finalizado' "
                + "ORDER BY p.idproduccion DESC;";
    } else {
        query = "SELECT p.idproduccion AS id, "
                + "p.fecha_elaboracion AS fecha_elaboracion, "
                + "p.fecha_vencimiento AS fecha_vencimiento, "
                + "r.nombre_receta AS receta, "
                + "e.emple_nombre AS empleado, "
                + "p.cantidad AS cantidad, "
                + "p.estado_produccion AS estado "
                + "FROM produccion p "
                + "JOIN recetas r ON p.receta_id = r.idrecetas_productos "
                + "JOIN empleados e ON p.empleados_id = e.idempleados "
                + "WHERE (LOWER(r.nombre_receta) LIKE '" + buscador + "%' OR LOWER(e.emple_nombre) LIKE '" + buscador + "%') "
                + "AND p.estado_produccion = 'Finalizado' "
                + "AND p.empleados_id = " + empleado_id + " "
                + "ORDER BY p.idproduccion DESC;";
    }

// Luego ejecutas la consulta
    rs = st.executeQuery(query);
    try ( Statement stmt = conn.createStatement();  ResultSet rsBuscador = stmt.executeQuery(query)) {

        while (rsBuscador.next()) {
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rsBuscador.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(sdf.format(rsBuscador.getDate("fecha_elaboracion"))); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(sdf.format(rsBuscador.getDate("fecha_vencimiento"))); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rsBuscador.getString("receta")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rsBuscador.getString("empleado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rsBuscador.getString("cantidad")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rsBuscador.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color:#ff007b; font-size: 16px;" onclick="$('#pkdelete').val(<% out.print(rsBuscador.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteProduccion.jsp?id=<%= rsBuscador.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
        }
    } catch (SQLException e) {
        out.println("error PSQL: " + e);
    }
} else if (listar != null && listar.equals(
        "mostrarproduccion")) {
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    try {
        HttpSession sesion = request.getSession();
        int empleado_id = (Integer) sesion.getAttribute("idempleados");
        String rolNombre = (String) sesion.getAttribute("rol_nombre");
        String query;

        if ("Administrador".equals(rolNombre)) {
            query = "SELECT p.idproduccion AS id, "
                    + "p.fecha_elaboracion AS fecha_elaboracion, "
                    + "p.fecha_vencimiento AS fecha_vencimiento, "
                    + "r.nombre_receta AS receta, "
                    + "e.emple_nombre AS empleado, "
                    + "p.cantidad AS cantidad, "
                    + "p.estado_produccion AS estado "
                    + "FROM produccion p "
                    + "JOIN recetas r ON p.receta_id = r.idrecetas_productos "
                    + "JOIN empleados e ON p.empleados_id = e.idempleados "
                    + "WHERE p.estado_produccion = 'Finalizado' "
                    + "ORDER BY p.idproduccion DESC;";
        } else {
            query = "SELECT p.idproduccion AS id, "
                    + "p.fecha_elaboracion AS fecha_elaboracion, "
                    + "p.fecha_vencimiento AS fecha_vencimiento, "
                    + "r.nombre_receta AS receta, "
                    + "e.emple_nombre AS empleado, "
                    + "p.cantidad AS cantidad, "
                    + "p.estado_produccion AS estado "
                    + "FROM produccion p "
                    + "JOIN recetas r ON p.receta_id = r.idrecetas_productos "
                    + "JOIN empleados e ON p.empleados_id = e.idempleados "
                    + "WHERE p.estado_produccion = 'Finalizado' "
                    + "AND p.empleados_id = " + empleado_id + " "
                    + "ORDER BY p.idproduccion DESC;";
        }

        rs = st.executeQuery(query);
        while (rs.next()) {
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rs.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(sdf.format(rs.getDate("fecha_elaboracion"))); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(sdf.format(rs.getDate("fecha_vencimiento"))); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rs.getString("receta")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rs.getString("empleado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rs.getString("cantidad")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(rs.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color:#ff007b; font-size: 16px;" onclick="$('#pkdelete').val(<% out.print(rs.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteProduccion.jsp?id=<%= rs.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (SQLException e) {
            out.println("error PSQL: " + e);
        }
    }


%>