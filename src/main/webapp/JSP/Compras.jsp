<%@page import="java.text.DecimalFormatSymbols"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="conexion.jsp" %>
<%    String listar = request.getParameter("listar");

    if (listar != null) {
        if (listar.equals("cargarUnidadDeMedida")) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT idunidad_medida, descripcion FROM unidad_medida")) {
                out.print("<option value='selectum'>Seleccione una Unidad de Medida</option>");
                while (rs.next()) {
                    int idUnidadMedida = rs.getInt("idunidad_medida");
                    String descripcion = rs.getString("descripcion");
                    out.print("<option value='" + idUnidadMedida + "'>" + descripcion + "</option>");
                }
                st.close();
                rs.close();
            } catch (SQLException e) {
                out.println("<option value=''>Error al cargar unidades de medida</option>");
            }
        } else if (listar.equals("cargarMetodosDePago")) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT idmetodos_pago, metpag_nombre FROM metodos_pago")) {
                out.print("<option value='selectmp'>Seleccione un Método de Pago</option>");
                while (rs.next()) {
                    int idMetodoPago = rs.getInt("idmetodos_pago");
                    String nombreMetodoPago = rs.getString("metpag_nombre");
                    out.print("<option value='" + idMetodoPago + "'>" + nombreMetodoPago + "</option>");
                }
                st.close();
                rs.close();
            } catch (SQLException e) {
                out.println("<option value=''>Error al cargar métodos de pago</option>");
            }
        } else if (listar.equals("cargarProveedores")) {
            try (Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery("SELECT idproveedores, prov_nombre, prov_direccion, prov_correo, prov_telefono, prov_ruc, prov_timbrado, prov_inicio, prov_fin FROM proveedores")) {

                out.print("<option value='selectprov'>Seleccione un Proveedor</option>");
                while (rs.next()) {
                    int idproveedor = rs.getInt("idproveedores");
                    String nombreProveedor = rs.getString("prov_nombre");
                    String direccion = rs.getString("prov_direccion");
                    String correo = rs.getString("prov_correo");
                    String telefono = rs.getString("prov_telefono");
                    String ruc = rs.getString("prov_ruc");
                    String timbrado = rs.getString("prov_timbrado");

                    // Formateamos las fechas
                    java.sql.Date inicio = rs.getDate("prov_inicio");
                    java.sql.Date fin = rs.getDate("prov_fin");

                    String inicioStr = (inicio != null) ? new SimpleDateFormat("yyyy-MM-dd").format(inicio) : "";
                    String finStr = (fin != null) ? new SimpleDateFormat("yyyy-MM-dd").format(fin) : "";

                    // Concatenamos nombreProveedor y ruc en la opción visible
                    out.print("<option value='" + idproveedor + "' data-direccion='" + direccion + "' data-correo='" + correo + "' data-telefono='" + telefono + "' data-ruc='" + ruc + "' data-timbrado='" + timbrado + "' data-inicio='" + inicioStr + "' data-fin='" + finStr + "'>"
                            + nombreProveedor + " - " + ruc + "</option>");
                }
            } catch (SQLException e) {
                out.println("<option value=''>Error al cargar proveedores</option>");
            }
        } else if (listar.equals("cargarIngredientes")) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT idingredientes, ingre_nombre, descripcion, impuesto FROM ingredientes i JOIN unidad_medida u ON i.unidad_de_medida_id = u.idunidad_medida")) {
                out.print("<option value='ingredientes_id'>Seleccione un Ingrediente</option>");
                while (rs.next()) {
                    int idIngrediente = rs.getInt("idingredientes");
                    String nombreIngrediente = rs.getString("ingre_nombre");
                    String unidadMedida = rs.getString("descripcion");
                    String impuesto = rs.getString("impuesto");
                    out.print("<option value='" + idIngrediente + "' data-unidad='" + unidadMedida + "' data-impuesto='" + impuesto + "'>" + nombreIngrediente + "</option>");
                }
                st.close();
                rs.close();
            } catch (SQLException e) {
                out.println("<option value=''>Error al cargar ingredientes</option>");
            }
        } else if (listar.equals("cargar")) {
            // Cabecera
            String proveedores_id = request.getParameter("proveedores_id");
            String compras_fecha = request.getParameter("compras_fecha");
            String compras_estado = request.getParameter("compras_estado");
            String compras_hora = request.getParameter("compras_hora");
            String condicion_compra = request.getParameter("condicion_compra");
            String idmetodos_pago = request.getParameter("idmetodos_pago");
            String total_compra = request.getParameter("total_compra");
            String iva_5 = request.getParameter("iva5_total");
            String iva_10 = request.getParameter("iva10_total");
            String unidad_medidaid = request.getParameter("unidad_medidaid");

            String num_dias = "0"; // Inicializamos num_dias con 0

            if ("Credito".equalsIgnoreCase(condicion_compra)) {
                num_dias = request.getParameter("cuotas");
            } else if ("Contado".equalsIgnoreCase(condicion_compra)) {
                num_dias = "0";
            }

            // Detalle
            String ingredientes_id = request.getParameter("ingredientes_id");
            String detcompras_preciounitario = request.getParameter("detcompras_preciounitario");
            String detcompras_cantidad = request.getParameter("detcompras_cantidad");

            try (Statement st = conn.createStatement()) {
                HttpSession sesion = request.getSession();
                int empleados_id = (Integer) sesion.getAttribute("idempleados");

                String descripcionUnidadMedida = "";
                try (ResultSet rsUnidad = st.executeQuery("SELECT descripcion FROM unidad_medida WHERE idunidad_medida = " + unidad_medidaid)) {
                    if (rsUnidad.next()) {
                        descripcionUnidadMedida = rsUnidad.getString("descripcion");
                    } else {
                        out.println("<div class='alert alert-danger' role='alert'>No se encontró la unidad de medida</div>");
                        return;
                    }
                }
                // Verificar si hay una compra pendiente
                try (ResultSet rs = st.executeQuery("SELECT idcompras FROM compras WHERE compras_estado = 'Pendiente' AND empleados_id = " + empleados_id)) {

                    if (rs.next()) {
                        // Ya hay una cabecera en estado pendiente
                        int idCompra = rs.getInt("idcompras");
                        //out.println("<div class='alert alert-success' role='alert'>Ya existe una cabecera en estado pendiente (ID: " + idCompra + "). Insertando detalle...</div>");

                        // Validar si el ingrediente ya está en el detalle
                        try (ResultSet rsDetalle = st.executeQuery("SELECT ingredientes_id FROM detalle_compras WHERE compra_id = " + idCompra + " AND ingredientes_id = " + ingredientes_id)) {
                            if (rsDetalle.next()) {
                                out.println("<div class='alert alert-warning' role='alert'>El ingrediente ya está agregado en esta compra (ID Ingrediente: " + ingredientes_id + ")</div>");
                            } else {
                                // Insertar detalle si no existe
                                String insertDetalleSQL = "INSERT INTO detalle_compras (detcompras_cantidad, detcompras_preciounitario, compra_id, ingredientes_id, unidad_medida) "
                                        + "VALUES (" + detcompras_cantidad + ", " + detcompras_preciounitario + ", " + idCompra + ", " + ingredientes_id + ", '" + descripcionUnidadMedida + "')";
                                int rowsDetalle = st.executeUpdate(insertDetalleSQL);
                                if (rowsDetalle > 0) {
                                    //out.println("<div class='alert alert-success' role='alert'>Detalle insertado correctamente en la compra ID: " + idCompra + "</div>");
                                } else {
                                    out.println("<div class='alert alert-danger' role='alert'>Error al insertar el detalle</div>");
                                }
                            }
                        }
                    } else {
                        // No hay compras pendientes, insertar nueva cabecera
                        out.println("<div class='alert alert-info' role='alert'>No hay compras pendientes. Insertando nueva cabecera...</div>");

                        String insertCabeceraSQL = "INSERT INTO compras (compras_fecha, compras_estado, proveedores_id, compras_hora, condicion_compra, empleados_id, idmetodos_pago, total_compra, iva_5, iva_10, num_dias) "
                                + "VALUES ('" + compras_fecha + "', '" + compras_estado + "', " + proveedores_id + ", '" + compras_hora + "', '" + condicion_compra + "', " + empleados_id + ", " + idmetodos_pago + ", " + total_compra + ", " + iva_5 + ", " + iva_10 + ", " + num_dias + ")";

                        int rowsCabecera = st.executeUpdate(insertCabeceraSQL, Statement.RETURN_GENERATED_KEYS);

                        if (rowsCabecera > 0) {
                            out.println("<div class='alert alert-success' role='alert'>Cabecera insertada correctamente</div>");

                            // Obtener el ID de la compra recién creada
                            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    int idCompra = generatedKeys.getInt(1);
                                    //out.println("<div class='alert alert-success' role='alert'>ID Compra generada: " + idCompra + "</div>");

                                    // Insertar detalle de compras
                                    String insertDetalleSQL = "INSERT INTO detalle_compras (detcompras_cantidad, detcompras_preciounitario, compra_id, ingredientes_id, unidad_medida) "
                                            + "VALUES (" + detcompras_cantidad + ", " + detcompras_preciounitario + ", " + idCompra + ", " + ingredientes_id + ", '" + descripcionUnidadMedida + "')";
                                    int rowsDetalle = st.executeUpdate(insertDetalleSQL);
                                    if (rowsDetalle > 0) {
                                        //out.println("<div class='alert alert-success' role='alert'>Detalle insertado correctamente en la compra ID: " + idCompra + "</div>");
                                    } else {
                                        out.println("<div class='alert alert-danger' role='alert'>Error al insertar el detalle</div>");
                                    }
                                }
                            }
                        } else {
                            out.println("<div class='alert alert-danger' role='alert'>Error al insertar la cabecera</div>");
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<div class='alert alert-danger' role='alert'>Error en la base de datos: " + e.getMessage() + "</div>");
            }
        } else if (request.getParameter("listar").equals("mostrardetalle")) {
            try (Statement st = conn.createStatement()) {
                HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");
                ResultSet rs = st.executeQuery("SELECT idcompras FROM compras WHERE compras_estado = 'Pendiente' AND empleados_id = " + empleados_id + ";");
                if (rs.next()) {
                    int idCompra = rs.getInt("idcompras");
                    ResultSet pk = st.executeQuery("SELECT dt.iddetalle_compras, i.ingre_nombre AS ingredientes_id, dt.unidad_medida, " // Modificación aquí
                            + "dt.detcompras_preciounitario, dt.detcompras_cantidad, i.impuesto "
                            + "FROM detalle_compras dt "
                            + "JOIN ingredientes i ON dt.ingredientes_id = i.idingredientes "
                            + "WHERE dt.compra_id =" + idCompra);

                    int sumador = 0;
                    int totalIva5 = 0;  // Total para IVA del 5%
                    int totalIva10 = 0; // Total para IVA del 10%

                    while (pk.next()) {
                        String iddetalle_compras = pk.getString("iddetalle_compras");
                        String ingredientes_id = pk.getString("ingredientes_id");
                        String unidad_medida = pk.getString("unidad_medida");
                        String detcompras_preciounitario = pk.getString("detcompras_preciounitario");
                        String detcompras_cantidad = pk.getString("detcompras_cantidad");
                        int impuesto = pk.getInt("impuesto");

                        int subtotal5 = 0;  // Para el IVA del 5%
                        int subtotal10 = 0; // Para el IVA del 10%

                        int precio = pk.getInt("detcompras_preciounitario");
                        int cantidad = pk.getInt("detcompras_cantidad");

                        // Calcular subtotales e impuestos
                        if (impuesto == 5) {
                            subtotal5 = (precio * cantidad);
                            totalIva5 += subtotal5; // Acumula el total gravado al 5%
                        } else if (impuesto == 10) {
                            subtotal10 = (precio * cantidad);
                            totalIva10 += subtotal10; // Acumula el total gravado al 10%
                        }

                        sumador += subtotal5 + subtotal10;

                        // Formatear los subtotales para mostrar
                        DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
                        df.applyPattern("#,###"); // Formato sin decimales

                        String calcularFormateado5 = df.format(subtotal5);
                        String calcularFormateado10 = df.format(subtotal10);
                        String precioFormateado = df.format(precio);

%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= detcompras_cantidad%></td>
    <td style="text-align: center; vertical-align: middle;"><%= ingredientes_id%></td>
    <td style="text-align: center; vertical-align: middle;"><%= unidad_medida%></td>
    <td style="text-align: center; vertical-align: middle;"><%= precioFormateado%></td>
    <td style="text-align: center; vertical-align: middle;"><%= (impuesto == 5 ? calcularFormateado5 : "")%></td>
    <td style="text-align: center; vertical-align: middle;"><%= (impuesto == 10 ? calcularFormateado10 : "")%></td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color: blue; font-size: 16px;" onclick="$('#id_delete').val('<%= iddetalle_compras%>')"></i>
    </td>
</tr>
<%
            }

            // Cerrar el ResultSet
            pk.close();

            // Formatear los totales de IVA
            DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
            df.applyPattern("#,###"); // Sin decimales, usa 0 para obligar a que muestre al menos un dígito
            String iva5formateado = df.format(totalIva5);
            String iva10formateado = df.format(totalIva10);

            // Calcular el total de compras sumando IVA5 e IVA10
            int totalCompras = totalIva5 + totalIva10;
            String totalComprasFormateado = df.format(totalCompras);

            // Guarda los totales en la sesión
            session.setAttribute("sumador", sumador);
            session.setAttribute("iva5formateado", iva5formateado);
            session.setAttribute("iva10formateado", iva10formateado);
            session.setAttribute("totalComprasFormateado", totalComprasFormateado);

            // Imprimir los totales al final del proceso para que se devuelvan en la respuesta
            out.println("<input type='hidden' id='totalIva5' value='" + iva5formateado + "'/>");
            out.println("<input type='hidden' id='totalIva10' value='" + iva10formateado + "'/>");
            out.println("<input type='hidden' id='totalCompras' value='" + totalComprasFormateado + "'/>");
        } else {
            out.println("No hay compras pendientes.");
        }
        // Cerrar el ResultSet principal
        rs.close();
        st.close();

    } catch (SQLException e) {
        out.println("Error al mostrar detalle: " + e);
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");

    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("delete from detalle_compras where iddetalle_compras=" + id_delete + "");
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
            // Reemplazar los puntos por nada (eliminar separador de miles) y comas por puntos (si es necesario)
            iva10formateado = iva10formateado.replace(".", "").replace(",", ".");

            // Convertir el valor formateado a un número y dividir por 11
            double iva10Dividido = Double.parseDouble(iva10formateado) / 11;

            // Convertir a entero (sin decimales) para redondear correctamente
            int iva10DivididoEntero = (int) Math.round(iva10Dividido);

            // Formatear el resultado (sin decimales)
            DecimalFormat df = new DecimalFormat("#,###"); // Formato sin decimales
            String iva10DivididoFormateado = df.format(iva10DivididoEntero);

            // Enviar el resultado al frontend
            out.println(iva10DivididoFormateado);

            session.setAttribute("iva10DivididoFormateado", iva10DivididoFormateado);
        } else {
            out.println("0");
        }
    } catch (Exception e) {
        out.println("Error al mostrar total del IVA 10%: " + e);
    }
} else if (request.getParameter("listar").equals("mostrartotal5")) {
    try {
        // Obtener el total de IVA 5% desde la sesión
        String iva5formateado = (String) session.getAttribute("iva5formateado");

        // Validar que no esté nulo o vacío
        if (iva5formateado != null && !iva5formateado.isEmpty()) {
            // Reemplazar los puntos por nada (eliminar separador de miles) y comas por puntos (si es necesario)
            iva5formateado = iva5formateado.replace(".", "").replace(",", ".");

            // Convertir el valor formateado a un número y dividir por 21
            double iva5Dividido = Double.parseDouble(iva5formateado) / 21;

            // Convertir a entero (sin decimales) para redondear correctamente
            int iva5DivididoEntero = (int) Math.round(iva5Dividido);

            // Formatear el resultado (sin decimales)
            DecimalFormat df = new DecimalFormat("#,###"); // Formato sin decimales
            String iva5DivididoFormateado = df.format(iva5DivididoEntero);

            // Enviar el resultado al frontend
            out.println(iva5DivididoFormateado);

            // Guardar en la sesión el valor formateado para su uso posterior
            session.setAttribute("iva5DivididoFormateado", iva5DivididoFormateado);
        } else {
            out.println("0");
        }
    } catch (Exception e) {
        out.println("Error al mostrar total del IVA 5%: " + e);
    }
} else if (request.getParameter("listar").equals("mostrartotales")) {
    String totalComprasFormateado = (String) session.getAttribute("totalComprasFormateado");
    if (totalComprasFormateado != null) {
        out.println(totalComprasFormateado);
    } else {
        out.println("No se han calculado los totales.");
    }
} else if (request.getParameter("listar").equals("mostrartotaliva")) {
    try {
        // Obtener los valores de IVA 10% y 5% desde la sesión
        String iva10DivididoFormateado = (String) session.getAttribute("iva10DivididoFormateado");
        String iva5DivididoFormateado = (String) session.getAttribute("iva5DivididoFormateado");

        // Validar que no estén nulos o vacíos
        if ((iva10DivididoFormateado != null && !iva10DivididoFormateado.isEmpty())
                && (iva5DivididoFormateado != null && !iva5DivididoFormateado.isEmpty())) {

            // Reemplazar los puntos por nada (eliminar separador de miles) y comas por puntos (si es necesario)
            iva10DivididoFormateado = iva10DivididoFormateado.replace(".", "").replace(",", ".");
            iva5DivididoFormateado = iva5DivididoFormateado.replace(".", "").replace(",", ".");

            // Convertir ambos valores formateados a números
            double iva10 = Double.parseDouble(iva10DivididoFormateado);
            double iva5 = Double.parseDouble(iva5DivididoFormateado);

            // Sumar ambos valores
            double totalIva = iva10 + iva5;

            // Convertir a entero (sin decimales) para redondear correctamente
            int totalIvaEntero = (int) Math.round(totalIva);

            // Formatear el resultado (sin decimales)
            DecimalFormat df = new DecimalFormat("#,###"); // Formato sin decimales
            String totalIvaFormateado = df.format(totalIvaEntero);

            // Enviar el resultado al frontend
            out.println(totalIvaFormateado);

        } else {
            // Si alguno de los valores es nulo o vacío, devolver 0
            out.println("0");
        }
    } catch (Exception e) {
        out.println("Error al mostrar el total del IVA: " + e);
    }
} else if (request.getParameter("listar").equals("cancelar")) {
    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");
       rs = st.executeQuery("SELECT idcompras FROM compras WHERE compras_estado = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        rs.next();
        st.executeUpdate("update compras set compras_estado ='Cancelado' where idcompras =" + rs.getString(1) + "");
        //out.println("<div class='alert alert-success' role='alert'>Datos modificados correctamente</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("finalizar")) {
    Statement st = null;
    ResultSet rs = null;

    // Obtener parámetros necesarios
    String proveedores_id = request.getParameter("proveedores_id");
    String idmetodos_pago = request.getParameter("idmetodos_pago");
    String cuotas = request.getParameter("cuotas");
    String condicion_compra = request.getParameter("condicion_compra");

    HttpSession sesion = request.getSession();
    int empleados_id = (Integer) sesion.getAttribute("idempleados");

    try {
        st = conn.createStatement();

        rs = st.executeQuery("SELECT idcompras FROM compras WHERE compras_estado = 'Pendiente' AND empleados_id = " + empleados_id + ";");
        if (rs.next()) {
            int idCompra = rs.getInt("idcompras");

            // Obtener los valores formateados de la sesión
            String totalComprasFormateado = (String) sesion.getAttribute("totalComprasFormateado");
            String iva10Dividid = (String) sesion.getAttribute("iva10DivididoFormateado");
            String iva5Dividid = (String) sesion.getAttribute("iva5DivididoFormateado");

            int totalCompras = Integer.parseInt(totalComprasFormateado.replace(".", ""));
            int iva5 = Integer.parseInt(iva5Dividid.replace(".", ""));
            int iva10 = Integer.parseInt(iva10Dividid.replace(".", ""));

            // Actualizar el estado y los totales
            String updateSQL = "UPDATE compras SET "
                    + "compras_estado = 'Finalizado', "
                    + "total_compra = " + totalCompras + ", "
                    + "iva_5 = " + iva5 + ", "
                    + "iva_10 = " + iva10 + " "
                    + "WHERE idcompras = " + idCompra;
            st.executeUpdate(updateSQL);

            // Determinar el estado del pago
            String estadoPago = condicion_compra.equals("Contado") ? "Pagado" : "Pendiente";

            // Imprimir valores para depuración
            System.out.println("Proveedor ID: " + proveedores_id);
            System.out.println("Método de Pago: " + idmetodos_pago);
            System.out.println("Empleado ID: " + empleados_id);
            System.out.println("Total a Pagar: " + totalCompras);
            System.out.println("ID Compra: " + idCompra);
            System.out.println("Número de Días: " + cuotas);
            System.out.println("Condición de Compra: " + condicion_compra);
            System.out.println("Estado de Pago: " + estadoPago);

            // Ejecutar la inserción en la tabla pagos
            String insertPagoSQL = "INSERT INTO pagos (proveedor_id, met_pago, estado_pago, empleado_id, total_pagar, compras_id, num_dias, fecha_pago) "
                    + "VALUES (" + proveedores_id + ", '" + idmetodos_pago + "', '" + estadoPago + "', " + empleados_id + ", "
                    + totalCompras + ", " + idCompra + ", " + cuotas + ", CURRENT_DATE)";

            st.executeUpdate(insertPagoSQL);  // Ejecutar la inserción

            out.println("<div class='alert alert-success' role='alert'>Compra finalizada y pago registrado correctamente</div>");

        } else {
            out.println("<div class='alert alert-warning' role='alert'>No hay compras pendientes para finalizar</div>");
        }
    } catch (Exception e) {
        out.println("Error en la base de datos: " + e);
    }
} else if (request.getParameter("listar").equals("anularcompras")) {
    Statement st = null;
    ResultSet rs = null;
    String pkdelete = request.getParameter("pkdelete");
    try {
        st = conn.createStatement();
        st.executeUpdate("UPDATE compras SET compras_estado = 'Anulado' WHERE idcompras = " + pkdelete);
        // Actualizar el estado del pago a 'Anulado' para la compra correspondiente
        st.executeUpdate("UPDATE pagos SET estado_pago = 'Anulado' WHERE compras_id = " + pkdelete);
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("mostrarcompras")) {
    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();

        HttpSession sesion = request.getSession();
        int empleado_id = (Integer) sesion.getAttribute("idempleados");
        String rolNombre = (String) sesion.getAttribute("rol_nombre");
        String sql;

        if ("Administrador".equals(rolNombre)) {
            sql = "SELECT c.idcompras AS id, "
                    + "to_char(c.compras_fecha, 'dd/mm/YYYY') AS fecha, "
                    + "pv.prov_nombre AS nombre_proveedor, "
                    + "c.compras_estado AS estado, "
                    + "c.condicion_compra AS condicion_compra, "
                    + "c.total_compra AS total_compra "
                    + "FROM compras c "
                    + "JOIN proveedores pv ON c.proveedores_id = pv.idproveedores "
                    + "WHERE c.compras_estado = 'Finalizado' "
                    + "ORDER BY c.idcompras DESC";
        } else {
            sql = "SELECT c.idcompras AS id, "
                    + "to_char(c.compras_fecha, 'dd/mm/YYYY') AS fecha, "
                    + "pv.prov_nombre AS nombre_proveedor, "
                    + "c.compras_estado AS estado, "
                    + "c.condicion_compra AS condicion_compra, "
                    + "c.total_compra AS total_compra "
                    + "FROM compras c "
                    + "JOIN proveedores pv ON c.proveedores_id = pv.idproveedores "
                    + "WHERE c.compras_estado = 'Finalizado' "
                    + "AND c.empleados_id = " + empleado_id + " "
                    + "ORDER BY c.idcompras DESC";
        }

        pk = st.executeQuery(sql);
        while (pk.next()) {
            DecimalFormat df = new DecimalFormat("#,###");
            double totalCompra = pk.getDouble("total_compra");
            String totalCompraFormateado = df.format(totalCompra) + " Gs.";
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"> <% out.print(pk.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("fecha")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("condicion_compra")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("nombre_proveedor"));%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%= totalCompraFormateado%>
    </td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val(<% out.print(pk.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteCompras.jsp?id=<%= pk.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
        }
        pk.close();
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
        query = "SELECT c.idcompras AS id, "
                + "to_char(c.compras_fecha, 'dd/mm/YYYY') AS fecha, "
                + "pv.prov_nombre AS nombre_proveedor, "
                + "c.compras_estado AS estado, "
                + "c.condicion_compra AS condicion_compra, "
                + "c.total_compra AS total_compra "
                + "FROM compras c "
                + "JOIN proveedores pv ON c.proveedores_id = pv.idproveedores "
                + "WHERE LOWER(pv.prov_nombre) LIKE '" + buscador + "%' "
                + "AND c.compras_estado = 'Finalizado' "
                + "ORDER BY c.idcompras DESC";
    } else {
        query = "SELECT c.idcompras AS id, "
                + "to_char(c.compras_fecha, 'dd/mm/YYYY') AS fecha, "
                + "pv.prov_nombre AS nombre_proveedor, "
                + "c.compras_estado AS estado, "
                + "c.condicion_compra AS condicion_compra, "
                + "c.total_compra AS total_compra "
                + "FROM compras c "
                + "JOIN proveedores pv ON c.proveedores_id = pv.idproveedores "
                + "WHERE LOWER(pv.prov_nombre) LIKE '" + buscador + "%' "
                + "AND c.compras_estado = 'Finalizado' "
                + "AND c.empleados_id = " + empleado_id + " "
                + "ORDER BY c.idcompras DESC";
    }

    Statement st = null;
    ResultSet pk = null;

    try {
        st = conn.createStatement();

        // Ejecución de la consulta
        pk = st.executeQuery(query);

        // Recorrido de los resultados
        while (pk.next()) {
            DecimalFormat df = new DecimalFormat("#,###");
            double totalCompra = pk.getDouble("total_compra");
            String totalCompraFormateado = df.format(totalCompra) + " Gs.";
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"> <% out.print(pk.getString("id")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("fecha")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("condicion_compra")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("nombre_proveedor"));%></td>
    <td style="text-align: center; vertical-align: middle;">
        <%= totalCompraFormateado%>
    </td>
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 18px;" 
           onclick="$('#pkdelete').val(<% out.print(pk.getString("id"));%>)"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteCompras.jsp?id=<%= pk.getString("id")%>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black;  font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
                }
            } catch (SQLException e) {
                out.println("Error PSQL: " + e.getMessage());
            } finally {
                try {
                    if (pk != null) {
                        pk.close();
                    }
                    if (st != null) {
                        st.close();
                    }
                } catch (SQLException e) {
                    out.println("Error PSQL al cerrar recursos: " + e.getMessage());
                }
            }
        }
    }
%>
